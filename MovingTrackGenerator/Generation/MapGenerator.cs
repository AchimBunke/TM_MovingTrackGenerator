using GBX.NET;
using GBX.NET.Engines.Game;
using GBX.NET.Engines.GameData;
using GBX.NET.Engines.Meta;
using GBX.NET.Engines.Plug;
using GBX.NET.Inputs;
using GBX.NET.LZO;
using System.ComponentModel;
using System.IO;
using System.Numerics;
using System.Text.Json;
using System.Text.Json.Serialization;
using System.Windows;
using System.Windows.Input;
using static GBX.NET.Engines.Meta.NPlugDyna_SKinematicConstraint;
using static GBX.NET.Engines.Plug.CPlugPrefab;
using static GBX.NET.Engines.Plug.CPlugSurface.Mesh;
using static GBX.NET.Engines.Plug.CPlugSurface;
using System;

namespace MovingTrackGenerator.Generation
{
    public class MapGenerator : INotifyPropertyChanged
    {

        public event PropertyChangedEventHandler? PropertyChanged;
        private void OnPropertyChanged(string propertyName)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
        }

        private bool _isMapDataLoaded = false;
        public bool IsMapDataLoaded => _isMapDataLoaded;
        MapData _mapData;
        public MapData MapData
        {
            get => _mapData;
            set
            {
                _mapData = value;
                _isMapDataLoaded = true;
                OnPropertyChanged(nameof(IsMapDataLoaded));
                _generated = false;
                ExportMapPath = Path.Combine(Settings.GeneratedMapsFolder, _mapData.mapName + ".Map.Gbx");
                GeneratedMapName = _mapData.mapName;
            }
        }
        Settings Settings => ComponentRegistry.Settings;
        public GbxReadSettings GbxReadSettings { get; set; }
            = new GbxReadSettings()
            {
                CloseStream = true,
                SafeSkippableChunks = true,
            };

        public MapGenerator()
        {
            ComponentRegistry.ConnectionManager.MapDataReceived += mapData => MapData = mapData;
        }
        public void UnloadMapData()
        {
            MapData = default;
            _isMapDataLoaded = false;
            OnPropertyChanged(nameof(IsMapDataLoaded));
            _generated = false;
        }

        public string GetMapName()
        {
            return _mapData.mapName;
        }
        string SanitizeFullPath(string fullPath)
        {
            string directory = Path.GetDirectoryName(fullPath); // Extract directory
            string fileName = Path.GetFileName(fullPath);       // Extract file name

            // Sanitize the file name only
            foreach (char c in Path.GetInvalidFileNameChars())
            {
                fileName = fileName.Replace(c, '_');
            }

            // Combine sanitized file name with the original directory
            return Path.Combine(directory, fileName);
        }
        public string GetGeneratedItemFileName(string mapName, int generationIndex)
            => Path.Combine(Settings.GeneratedItemsFolder, SanitizeFullPath(GetMapName()),$"{_generatedItemsPrefix}{generationIndex}.Item.Gbx");
        public string GetGeneratedItemId(string mapName, int generationIndex)
            => Path.GetRelativePath(Settings.ItemsFolder, GetGeneratedItemFileName(mapName, generationIndex));

        CGameCtnChallenge currentMap;
        bool _generated = false;

        public string CurrentMapName => currentMap?.MapName;
        public string CurrentMapPath => _mapData.mapPath;

        private string _exportMapPath;
        public string ExportMapPath
        {
            get => _exportMapPath;
            set
            {
                _exportMapPath = SanitizeFullPath(value);
                OnPropertyChanged(nameof(ExportMapPath));
            }
        }
        private string _generatedMapName;
        public string GeneratedMapName
        {
            get => _generatedMapName;
            set
            {
                _generatedMapName = value;
                OnPropertyChanged(nameof(GeneratedMapName));
            }
        }

        private string _generatedItemsPrefix;
        public string GeneratedItemsPrefix
        {
            get => _generatedItemsPrefix;
            set
            {
                _generatedItemsPrefix = value;
                OnPropertyChanged(nameof(GeneratedItemsPrefix));
            }
        }

        public ICommand SaveCommand => new RelayCommand(_ => CanSave(), _ => Save());
        public bool CanSave()
        {
            return _isMapDataLoaded && _generated && !string.IsNullOrWhiteSpace(_generatedMapName) && !string.IsNullOrWhiteSpace(_exportMapPath);
        }
        public void Save()
        {
            ComponentRegistry.InfoOutput.WriteLine($"Saving generated map at {ExportMapPath}");
            currentMap.MapName = GeneratedMapName;
            currentMap.Save(ExportMapPath);

            genInfo.GeneratedMapPath = ExportMapPath;
            genInfo.GeneratedMapName = GeneratedMapName;

            SaveGenerationInfo(genInfo);

            ComponentRegistry.InfoOutput.Highlight($"Saved successfully. Restart Trackmania to load generated items!");
        }

        public ICommand GenerateCommand => new RelayCommand(_ => CanGenerate(), _ => Generate());
        public bool CanGenerate()
        {
            return _isMapDataLoaded;
        }

        public event Action<Dictionary<int, BlockStatus>, bool> Generated;
        GenerationInfo genInfo;
        public void Generate()
        {
            Dictionary<int, BlockStatus> blockStatus = new();
            genInfo = new GenerationInfo();
            try
            {
                Gbx.LZO = new Lzo();
                ComponentRegistry.InfoOutput.Highlight("-- Starting Map Generation --");
                var gbx = Gbx.Parse<CGameCtnChallenge>(Path.Combine(Settings.MapsFolder, _mapData.mapPath), GbxReadSettings);
                genInfo.Author = Settings.Author;
                genInfo.OriginalMapPath = Path.Combine(Settings.MapsFolder, _mapData.mapPath);
                genInfo.OriginalMapName = _mapData.mapName;
                genInfo.GeneratedItemsFolder = Settings.GeneratedItemsFolder;
                ComponentRegistry.InfoOutput.WriteLine($"Open Map: {Path.Combine(Settings.MapsFolder,_mapData.mapPath)}");
                currentMap = gbx.Node;
                int generatedItemCount = 0;

                List<CGameCtnAnchoredObject> itemsToRemove = new(); // replaced by generated items
                List<(string itemPath, GBX.NET.Vec3 position, GBX.NET.Vec3 pitchYawRoll)> itemsToAdd = new(); // replacements

                foreach (var anchoredItem in currentMap.AnchoredObjects)
                {
                    var correspondingItem = _mapData.blocks.FirstOrDefault(b => Utils.EqualPosition(b.serializedPositionInWorld, anchoredItem.AbsolutePositionInMap), new BlockData { id = -1 });
                    if (correspondingItem.id == -1)
                    {
                        ComponentRegistry.InfoOutput.WriteLine($"Ignoring item at Position: {anchoredItem.AbsolutePositionInMap}.");
                        continue;
                    }
                    blockStatus[correspondingItem.id] = BlockStatus.Original;
                    ComponentRegistry.InfoOutput.WriteLine($"Found replacable item at Position: {correspondingItem.serializedPositionInWorld}.");
                    var model = anchoredItem.ItemModel;
                    var pathToModel = Path.Combine(Settings.ItemsFolder, model.Id);
                    ComponentRegistry.InfoOutput.WriteLine($"Opening ItemModel at path: {pathToModel}.");

                    string exportFileName = GetGeneratedItemFileName(_mapData.mapName, generatedItemCount);
                    string newItemId = GetGeneratedItemId(_mapData.mapName, generatedItemCount);

                    var genItemInfo = new GeneratedItemInfo();
                    try
                    {

                        genItemInfo.OriginalItemPath = pathToModel;
                        genItemInfo.Position = anchoredItem.AbsolutePositionInMap;
                        genItemInfo.PitchYawRoll = anchoredItem.PitchYawRoll;

                        var originalItem = Gbx.Parse<CGameItemModel>(pathToModel);


                        ComponentRegistry.InfoOutput.WriteLine($"Generating animation data for item: {newItemId}");
                        bool wasAnimationGenerated = GenerateAnimations(originalItem, correspondingItem, genItemInfo, anchoredItem);

                        string exportFolder = Path.GetDirectoryName(exportFileName);
                        if (!Directory.Exists(exportFolder))
                        {
                            ComponentRegistry.InfoOutput.WriteLine($"Directory for generated items does not exist! Creating one.");
                            Directory.CreateDirectory(exportFolder);
                        }


                        ComponentRegistry.InfoOutput.WriteLine($"Saving generated item at: {exportFileName}");
                        originalItem.Save(exportFileName);


                        itemsToRemove.Add(anchoredItem);
                        itemsToAdd.Add((newItemId, anchoredItem.AbsolutePositionInMap, anchoredItem.PitchYawRoll));
                        generatedItemCount++;

                        blockStatus[correspondingItem.id] = wasAnimationGenerated ? BlockStatus.Updated : BlockStatus.Original;

                        genItemInfo.BlockStatus = wasAnimationGenerated ? BlockStatus.Updated : BlockStatus.Original;
                    }
                    catch(KeyNotFoundException k)
                    {
                        ComponentRegistry.InfoOutput.Error($"A variable could not be resolved. Skipping item: {model.Id} at position: {anchoredItem.AbsolutePositionInMap}");
                        blockStatus[correspondingItem.id] = BlockStatus.Problem;
                        genItemInfo.BlockStatus = BlockStatus.Problem;
                    }
                    genInfo.GeneratedItems.Add(genItemInfo);

                }
                ComponentRegistry.InfoOutput.WriteLine($"Replacing Items with generated ones...");
                ComponentRegistry.InfoOutput.WriteLine($"Removing original items.");
                currentMap.RemoveAnchoredObjects(itemsToRemove.Contains);
                foreach (var item in itemsToAdd)
                {
                    ComponentRegistry.InfoOutput.WriteLine($"Adding replacement item: {item.itemPath} for position: {item.position}.");
                    currentMap.PlaceAnchoredObject(new Ident(item.itemPath, 26, Settings.Author), item.position, item.pitchYawRoll);
                }

                ComponentRegistry.InfoOutput.Highlight($"-- Completed Generation -- Replaced: {generatedItemCount} items -- ");
                _generated = true;
            }
            catch (Exception e)
            {
                ComponentRegistry.InfoOutput.Error($"Unexpected error while generating map: {e.Message}");
                genInfo.WasGenerationFaulty = true;
            }

            Generated?.Invoke(blockStatus, _generated);

        }

        public NPlugDyna_SKinematicConstraint FindKinematicConstraint(CGameItemModel itemModel, out EntRef entRef)
        {
            var entityModel = itemModel.EntityModel as CPlugPrefab;
            var ents = entityModel.Ents.ToList();
            foreach (var ent in ents)
            {
                if (ent.Model is NPlugDyna_SKinematicConstraint c)
                {
                    entRef = ent;
                    return c;
                }
            }
            entRef = null;
            return null;
        }

        public CPlugDynaObjectModel FindDynaObjectModel(CGameItemModel itemModel, out EntRef entRef)
        {

            var entityModel = itemModel.EntityModel as CPlugPrefab;
            var ents = entityModel.Ents.ToList();
            foreach (var ent in ents)
            {
                if (ent.Model is CPlugDynaObjectModel c)
                {
                    entRef = ent;
                    return c;
                }
            }
            entRef = null;
            return null;
        }
        public static Vector3 Rotate(Vector3 position, Vector3 pitchYawRoll)
        {

            // Create quaternion from pitch, yaw, and roll (Euler Angles)
            var rotationQuat = Quaternion.CreateFromYawPitchRoll(pitchYawRoll.X, pitchYawRoll.Y, pitchYawRoll.Z);

            // Apply rotation to position (multiply vector by quaternion)
            Vector3 rotatedPosition = Vector3.Transform(position, rotationQuat);

            return rotatedPosition;
        }

        void SetAnchorRotationForItemModel(CGameCtnAnchoredObject anchoredItem, Gbx<CGameItemModel> itemModel)
        {
            var originalDynaObjectModel = FindDynaObjectModel(itemModel, out var dynaEnt);
            // TODO: maybe copy?
            Vec3 pitchYawRoll = anchoredItem.PitchYawRoll;
            //TODO: Pitch and Yaw are swapped?
            //pitchYawRoll = (pitchYawRoll.Y, pitchYawRoll.X, pitchYawRoll.Z);
            Vec3 position = anchoredItem.AbsolutePositionInMap;
            if (pitchYawRoll == (0,0,0))
            {
                return;
            }
            var mesh = originalDynaObjectModel.Mesh;

            foreach (CPlugVisualIndexedTriangles visual in mesh.Visuals)
            {
                for (int i = 0; i < visual.VertexStreams[0].Positions.Length; ++i)
                {
                    Vec3 p = visual.VertexStreams[0].Positions[i];
                    Vec3 rotated = Rotate(p, pitchYawRoll);
                    //Vec3 translated = rotated - position;
                    visual.VertexStreams[0].Positions[i] = rotated;
                }
            }
            anchoredItem.PitchYawRoll = (0, 0, 0);
            //anchoredItem.AbsolutePositionInMap = (0,0,0);
        }

        bool GenerateAnimations(Gbx<CGameItemModel> itemModel, BlockData blockData, GeneratedItemInfo genItemInfo, CGameCtnAnchoredObject anchoredItem)
        {
            var originalKinemConstraint = FindKinematicConstraint(itemModel, out var entRef);
            if(originalKinemConstraint == null || entRef == null)
            {
                ComponentRegistry.InfoOutput.Warn($"No Kinematic Constraint found! Skipping Animation generation.");
                return false;
            }
            var entityModel = itemModel.Node.EntityModel as CPlugPrefab;
            if(entityModel == null)
            {
                ComponentRegistry.InfoOutput.Warn($"No EntityModel found! Skipping Animation generation.");
                return false;
            }
            var ents = entityModel.Ents.ToList();
            EntRef entCpy = Utils.CopyEnt(entRef);
            var targetKinematicConstraint = entCpy.Model as NPlugDyna_SKinematicConstraint;

            if (!blockData.fullAnimationData.isLocalSpace)
            {
                SetAnchorRotationForItemModel(anchoredItem, itemModel);
            }

            ApplyAnimations(targetKinematicConstraint, entCpy, blockData, genItemInfo);

          

            ents.RemoveAt(ents.Count - 1);
            ents.Add(entCpy);
            entityModel.Ents = ents.ToArray();
            itemModel.Node.EntityModel = entityModel;
            return true;
        }

        void ApplyAnimations(NPlugDyna_SKinematicConstraint kinematicConstraint, EntRef ent, BlockData blockData, GeneratedItemInfo genItemInfo)
        {
            Dictionary<AnimationOptions, float> transValues = new();
            var transData = blockData.fullAnimationData.translationData;
            //Translation
            (kinematicConstraint.TransAxis, var avoidArrivalPosTrans) = ResolveAxisFormula(transData.axisFormula, blockData.playerArrivalPosition);
            kinematicConstraint.TransMin = ent.Position.Y;
            kinematicConstraint.TransMax = transData.maxFormula.Resolve(blockData.playerArrivalTime, ValueType.Float, MapData.FloatVarDeclarations, transValues);
            var wait1Func_trans = new SubAnimFunc()
            {            
                Ease = transData.wait1EasingFormula.Resolve(MapData.EasingVarDeclarations),
            };
            var wait2Func_trans = new SubAnimFunc()
            {
                Ease = transData.wait2EasingFormula.Resolve(MapData.EasingVarDeclarations),
            };
            var flyInFunc_trans = new SubAnimFunc()
            {
                Ease = transData.flyInEasingFormula.Resolve(MapData.EasingVarDeclarations),
            };
            var flyoutFunc_trans = new SubAnimFunc()
            {
                Ease = transData.flyOutEasingFormula.Resolve(MapData.EasingVarDeclarations),
            };
            float d1, d2, d3, d4;
            switch (blockData.fullAnimationData.animationOrder)
            {
                case AnimationOrder.Wait_FlyIn_Wait_FlyOut:
                    wait1Func_trans.Reverse = true;
                    d1 = transData.wait1DurationFormula.Resolve(blockData.playerArrivalTime, ValueType.Int, MapData.IntVarDeclarations, transValues);
                    wait1Func_trans.Duration = new TmEssentials.TimeInt32((int)d1);
                    transValues[AnimationOptions.Wait_1] = d1;
                    genItemInfo.PositionFrames.Add(new AnimKeyFrameInfo()
                    {
                        Target = KeyFrameTarget.Max,
                        Time = (int)d1,
                        Value = AddAxisMovement(genItemInfo.Position, kinematicConstraint.TransMax, kinematicConstraint.TransAxis),
                        Easing = wait1Func_trans.Ease,
                    });

                    flyInFunc_trans.Reverse = true;
                    d2 = transData.flyInDurationFormula.Resolve(blockData.playerArrivalTime, ValueType.Int, MapData.IntVarDeclarations, transValues);
                    flyInFunc_trans.Duration = new TmEssentials.TimeInt32((int)d2);
                    transValues[AnimationOptions.FlyIn] = d2;
                    genItemInfo.PositionFrames.Add(new AnimKeyFrameInfo()
                    {
                        Target = KeyFrameTarget.Min,
                        Time = (int)d1 + (int)d2,
                        Value = genItemInfo.Position,
                        Easing = flyInFunc_trans.Ease,
                    });

                    wait2Func_trans.Reverse = false;
                    d3 = transData.wait2DurationFormula.Resolve(blockData.playerArrivalTime, ValueType.Int, MapData.IntVarDeclarations, transValues);
                    wait2Func_trans.Duration = new TmEssentials.TimeInt32((int)d3);
                    transValues[AnimationOptions.Wait_2] = d3;
                    genItemInfo.PositionFrames.Add(new AnimKeyFrameInfo()
                    {
                        Target = KeyFrameTarget.Min,
                        Time = (int)d1 + (int)d2 + (int)d3,
                        Value = genItemInfo.Position,
                        Easing = wait2Func_trans.Ease,
                    });

                    flyoutFunc_trans.Reverse = false;
                    d4 = transData.flyOutDurationFormula.Resolve(blockData.playerArrivalTime, ValueType.Int, MapData.IntVarDeclarations, transValues);
                    flyoutFunc_trans.Duration = new TmEssentials.TimeInt32((int)d4);
                    transValues[AnimationOptions.FlyOut] = d4;
                    genItemInfo.PositionFrames.Add(new AnimKeyFrameInfo()
                    {
                        Target = KeyFrameTarget.Max,
                        Time = (int)d1 + (int)d2 + (int)d3 + (int)d4,
                        Value = AddAxisMovement(genItemInfo.Position, kinematicConstraint.TransMax, kinematicConstraint.TransAxis),
                        Easing = flyoutFunc_trans.Ease,
                    });

                    kinematicConstraint.TransAnimFunc = new AnimFunc()
                    {
                        IsDuration = true,
                        SubFuncs = [wait1Func_trans, flyInFunc_trans, wait2Func_trans, flyoutFunc_trans],
                    };
                    break;
                case AnimationOrder.Wait_FlyOut_Wait_FlyIn:

                    wait1Func_trans.Reverse = false;
                    d1 = transData.wait1DurationFormula.Resolve(blockData.playerArrivalTime, ValueType.Int, MapData.IntVarDeclarations, transValues);
                    wait1Func_trans.Duration = new TmEssentials.TimeInt32((int)d1);
                    transValues[AnimationOptions.Wait_1] = d1;

                    genItemInfo.PositionFrames.Add(new AnimKeyFrameInfo()
                    {
                        Target = KeyFrameTarget.Min,
                        Time = (int)d1,
                        Value = genItemInfo.Position,
                        Easing = wait1Func_trans.Ease,
                    });

                    flyoutFunc_trans.Reverse = false;
                    d4 = transData.flyOutDurationFormula.Resolve(blockData.playerArrivalTime, ValueType.Int, MapData.IntVarDeclarations, transValues);
                    flyoutFunc_trans.Duration = new TmEssentials.TimeInt32((int)d4);
                    transValues[AnimationOptions.FlyOut] = d4;

                    genItemInfo.PositionFrames.Add(new AnimKeyFrameInfo()
                    {
                        Target = KeyFrameTarget.Max,
                        Time = (int)d1 + (int)d4,
                        Value = AddAxisMovement(genItemInfo.Position, kinematicConstraint.TransMax, kinematicConstraint.TransAxis),
                        Easing = flyoutFunc_trans.Ease,
                    });

                    wait2Func_trans.Reverse = true;
                    d3 = transData.wait2DurationFormula.Resolve(blockData.playerArrivalTime, ValueType.Int, MapData.IntVarDeclarations, transValues);
                    wait2Func_trans.Duration = new TmEssentials.TimeInt32((int)d3);
                    transValues[AnimationOptions.Wait_2] = d3;

                    genItemInfo.PositionFrames.Add(new AnimKeyFrameInfo()
                    {
                        Target = KeyFrameTarget.Max,
                        Time = (int)d1 + (int)d4 + (int)d3,
                        Value = AddAxisMovement(genItemInfo.Position, kinematicConstraint.TransMax, kinematicConstraint.TransAxis),
                        Easing = wait2Func_trans.Ease,
                    });

                    flyInFunc_trans.Reverse = true;
                    d2 = transData.flyInDurationFormula.Resolve(blockData.playerArrivalTime, ValueType.Int, MapData.IntVarDeclarations, transValues);
                    flyInFunc_trans.Duration = new TmEssentials.TimeInt32((int)d2);
                    transValues[AnimationOptions.FlyIn] = d2;
                    genItemInfo.PositionFrames.Add(new AnimKeyFrameInfo()
                    {
                        Target = KeyFrameTarget.Min,
                        Time = (int)d1 + (int)d2 + (int)d3 + (int)d4,
                        Value = genItemInfo.Position,
                        Easing = flyInFunc_trans.Ease,
                    });

                    kinematicConstraint.TransAnimFunc = new AnimFunc()
                    {
                        IsDuration = true,
                        SubFuncs = [wait1Func_trans, flyoutFunc_trans, wait2Func_trans, flyInFunc_trans],
                    };
                    break;
            }
            var rotData = blockData.fullAnimationData.rotationData;
            //Rotation
            Dictionary<AnimationOptions, float> rotValues = new();

            (kinematicConstraint.RotAxis, var avoidArrivalPosRot) = ResolveAxisFormula(transData.axisFormula, blockData.playerArrivalPosition);
            kinematicConstraint.AngleMinDeg = 0;
            kinematicConstraint.AngleMaxDeg = rotData.maxFormula.Resolve(blockData.playerArrivalTime, ValueType.Float, MapData.FloatVarDeclarations, rotValues);
            var wait1Func_rot = new SubAnimFunc()
            {
                Ease = rotData.wait1EasingFormula.Resolve(MapData.EasingVarDeclarations),
            };
            var wait2Func_rot = new SubAnimFunc()
            {
                Ease = rotData.wait2EasingFormula.Resolve(MapData.EasingVarDeclarations),
            };
            var flyInFunc_rot = new SubAnimFunc()
            {
                Ease = rotData.flyInEasingFormula.Resolve(MapData.EasingVarDeclarations),
            };
            var flyoutFunc_rot = new SubAnimFunc()
            {
                Ease = rotData.flyOutEasingFormula.Resolve(MapData.EasingVarDeclarations),
            };
            switch (blockData.fullAnimationData.animationOrder)
            {
                case AnimationOrder.Wait_FlyIn_Wait_FlyOut:
                    wait1Func_rot.Reverse = true;
                    d1 = rotData.wait1DurationFormula.Resolve(blockData.playerArrivalTime, ValueType.Int, MapData.IntVarDeclarations, rotValues);
                    wait1Func_rot.Duration = new TmEssentials.TimeInt32((int)d1);
                    rotValues[AnimationOptions.Wait_1] = d1;
                    genItemInfo.RotationFrames.Add(new AnimKeyFrameInfo()
                    {
                        Target = KeyFrameTarget.Max,
                        Time = (int)d1,
                        Value = AddAxisMovement(genItemInfo.PitchYawRoll, kinematicConstraint.AngleMaxDeg, kinematicConstraint.RotAxis),
                        Easing = wait1Func_rot.Ease,
                    });

                    flyInFunc_rot.Reverse = true;
                    d2 = rotData.flyInDurationFormula.Resolve(blockData.playerArrivalTime, ValueType.Int, MapData.IntVarDeclarations, rotValues);
                    flyInFunc_rot.Duration = new TmEssentials.TimeInt32((int)d2);
                    rotValues[AnimationOptions.FlyIn] = d2;
                    genItemInfo.RotationFrames.Add(new AnimKeyFrameInfo()
                    {
                        Target = KeyFrameTarget.Min,
                        Time = (int)d1 + (int)d2,
                        Value = genItemInfo.PitchYawRoll,
                        Easing = flyInFunc_rot.Ease,
                    });

                    wait2Func_rot.Reverse = false;
                    d3 = rotData.wait2DurationFormula.Resolve(blockData.playerArrivalTime, ValueType.Int, MapData.IntVarDeclarations, rotValues);
                    wait2Func_rot.Duration = new TmEssentials.TimeInt32((int)d3);
                    rotValues[AnimationOptions.Wait_2] = d3;
                    genItemInfo.RotationFrames.Add(new AnimKeyFrameInfo()
                    {
                        Target = KeyFrameTarget.Min,
                        Time = (int)d1 + (int)d2 + (int)d3,
                        Value = genItemInfo.PitchYawRoll,
                        Easing = wait2Func_rot.Ease,
                    });

                    flyoutFunc_rot.Reverse = false;
                    d4 = rotData.flyOutDurationFormula.Resolve(blockData.playerArrivalTime, ValueType.Int, MapData.IntVarDeclarations, rotValues);
                    flyoutFunc_rot.Duration = new TmEssentials.TimeInt32((int)d4);
                    rotValues[AnimationOptions.FlyOut] = d4;
                    genItemInfo.RotationFrames.Add(new AnimKeyFrameInfo()
                    {
                        Target = KeyFrameTarget.Max,
                        Time = (int)d1 + (int)d2 + (int)d3 + (int)d4,
                        Value = AddAxisMovement(genItemInfo.PitchYawRoll, kinematicConstraint.AngleMaxDeg, kinematicConstraint.RotAxis),
                        Easing = flyoutFunc_rot.Ease,
                    });

                    kinematicConstraint.RotAnimFunc = new AnimFunc()
                    {
                        IsDuration = true,
                        SubFuncs = [wait1Func_rot, flyInFunc_rot, wait2Func_rot, flyoutFunc_rot],
                    };
                    break;
                case AnimationOrder.Wait_FlyOut_Wait_FlyIn:
                    wait1Func_rot.Reverse = false;
                    d1 = rotData.wait1DurationFormula.Resolve(blockData.playerArrivalTime, ValueType.Int, MapData.IntVarDeclarations, rotValues);
                    wait1Func_rot.Duration = new TmEssentials.TimeInt32((int)d1);
                    rotValues[AnimationOptions.Wait_1] = d1;
                    genItemInfo.RotationFrames.Add(new AnimKeyFrameInfo()
                    {
                        Target = KeyFrameTarget.Min,
                        Time = (int)d1,
                        Value = genItemInfo.PitchYawRoll,
                        Easing = wait1Func_rot.Ease,
                    });

                    flyoutFunc_rot.Reverse = false;
                    d4 = rotData.flyOutDurationFormula.Resolve(blockData.playerArrivalTime, ValueType.Int, MapData.IntVarDeclarations, rotValues);
                    flyoutFunc_rot.Duration = new TmEssentials.TimeInt32((int)d4);
                    rotValues[AnimationOptions.FlyOut] = d4;
                    genItemInfo.RotationFrames.Add(new AnimKeyFrameInfo()
                    {
                        Target = KeyFrameTarget.Max,
                        Time = (int)d1 + (int)d4,
                        Value = AddAxisMovement(genItemInfo.PitchYawRoll, kinematicConstraint.AngleMaxDeg, kinematicConstraint.RotAxis),
                        Easing = flyoutFunc_rot.Ease,
                    });

                    wait2Func_rot.Reverse = true;
                    d3 = rotData.wait2DurationFormula.Resolve(blockData.playerArrivalTime, ValueType.Int, MapData.IntVarDeclarations, rotValues);
                    wait2Func_rot.Duration = new TmEssentials.TimeInt32((int)d3);
                    rotValues[AnimationOptions.Wait_2] = d3;
                    genItemInfo.RotationFrames.Add(new AnimKeyFrameInfo()
                    {
                        Target = KeyFrameTarget.Max,
                        Time = (int)d1 + (int)d4 + (int)d3,
                        Value = AddAxisMovement(genItemInfo.PitchYawRoll, kinematicConstraint.AngleMaxDeg, kinematicConstraint.RotAxis),
                        Easing = wait2Func_rot.Ease,
                    });

                    flyInFunc_rot.Reverse = true;
                    d2 = rotData.flyInDurationFormula.Resolve(blockData.playerArrivalTime, ValueType.Int, MapData.IntVarDeclarations, rotValues);
                    flyInFunc_rot.Duration = new TmEssentials.TimeInt32((int)d2);
                    rotValues[AnimationOptions.FlyIn] = d2;
                    genItemInfo.RotationFrames.Add(new AnimKeyFrameInfo()
                    {
                        Target = KeyFrameTarget.Min,
                        Time = (int)d1 + (int)d4 + (int)d3 + (int)d2,
                        Value = genItemInfo.PitchYawRoll,
                        Easing = flyInFunc_rot.Ease,
                    });

                    kinematicConstraint.RotAnimFunc = new AnimFunc()
                    {
                        IsDuration = true,
                        SubFuncs = [wait1Func_rot, flyoutFunc_rot, wait2Func_rot, flyInFunc_rot],
                    };
                    break;
            }

        }

        (EAxis, bool) ResolveAxisFormula(AxisFormula axisFormula, Vec3 arrivalPosition)
        {
            var arrivalAxis = Utils.GetDominantAxis(arrivalPosition);
            var axis = axisFormula.Resolve(arrivalAxis, MapData.AxisVarDeclarations);
            bool avoidArrivalAxis = false;
            if(axisFormula.axisValue is RandomAxisValue randomAxisValue)
            {
                avoidArrivalAxis = randomAxisValue.avoidArrivalDirection;
            }
            return (axis, avoidArrivalAxis);
        }

        Vec3 AddAxisMovement(Vec3 initPos, float distance, EAxis axis) => axis switch
        {
            EAxis.X => initPos + (distance, 0, 0),
            EAxis.Y => initPos + (0, distance, 0),
            EAxis.Z => initPos + (0, 0, distance),
        };


        public void SaveGenerationInfo(GenerationInfo genInfo)
        {
            if (!Settings.IsGenerationInfoExportEnabled)
                return;
            var exportFolder = Settings.GenerationInfoExportFolder;
            var exportFileName = Path.Combine(exportFolder, SanitizeFullPath($"{genInfo.GeneratedMapName}_genInfo.json"));
            try
            {
                ComponentRegistry.InfoOutput.WriteLine($"Writing Generation Info to {exportFileName}");
                if (!Directory.Exists(exportFolder))
                {
                    Directory.CreateDirectory(exportFolder);
                }
                File.WriteAllText(exportFileName, JsonSerializer.Serialize(genInfo, new JsonSerializerOptions() { WriteIndented = true }));
            }catch(Exception e)
            {
                ComponentRegistry.InfoOutput.Error($"Error while writing Generation Infos: {e.Message}");
            }
        }
    }
}

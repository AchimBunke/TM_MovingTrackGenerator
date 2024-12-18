using MovingTrackGenerator.Generation;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Media;
using System.Windows.Shapes;

namespace MovingTrackGenerator.UI
{
    /// <summary>
    /// Interaction logic for TopDownPreview.xaml
    /// </summary>
    public partial class TopDownPreview : UserControl
    {
        public TopDownPreview()
        {
            InitializeComponent();
            ComponentRegistry.ConnectionManager.MapDataReceived += OnMapDataReceived;
            ComponentRegistry.MapGenerator.Generated += (blockStatus, _) => Update(blockStatus);
            //OnMapDataReceived(TestData);
        }
        MapData TestData = new MapData
        {
            blocks =
            [
                new BlockData
                {
                    serializedPositionInWorld = (0, 0, 0),
                    id = 0,
                },
                new BlockData
                {
                    serializedPositionInWorld = (40, 0, 20),
                    id = 1,
                },
                new BlockData
                {
                    serializedPositionInWorld = (100, 0, 100),
                    id = 2,
                },
                new BlockData
                {
                    serializedPositionInWorld = (30, 0, 80),
                    id = 3,
                },
                new BlockData
                {
                    serializedPositionInWorld = (90, 0, 90),
                    id = 4,
                },
            ],
            arrivals = new Arrivals
            {
                entries = [
                    new ArrivalEntry { position = (0,0,0) },
                    new ArrivalEntry { position = (40,0,20) },
                    new ArrivalEntry { position = (30,0,80) },
                    new ArrivalEntry { position = (90,0,90) },
                    ],
            },
        };

        MapData _mapData;
        Vec3 mapDataBoundsMax;
        Vec3 mapDataBoundsMin;
        Vec3 generalOffset = (20,0,20);
        private void OnMapDataReceived(MapData obj)
        {
            Clear();
            _mapData = obj;
            mapDataBoundsMax = new();
            mapDataBoundsMin = (float.MaxValue, 0, float.MaxValue);
            foreach (var block in _mapData.blocks)
            {
                if(block.serializedPositionInWorld.X > mapDataBoundsMax.X)
                {
                    mapDataBoundsMax.X = block.serializedPositionInWorld.X;
                }
                if (block.serializedPositionInWorld.Z > mapDataBoundsMax.Z)
                {
                    mapDataBoundsMax.Z = block.serializedPositionInWorld.Z;
                }
                if (block.serializedPositionInWorld.X < mapDataBoundsMin.X)
                {
                    mapDataBoundsMin.X = block.serializedPositionInWorld.X;
                }
                if (block.serializedPositionInWorld.Z < mapDataBoundsMin.Z)
                {
                    mapDataBoundsMin.Z = block.serializedPositionInWorld.Z;
                }
            }
            foreach (var entry in _mapData.arrivals.entries)
            {
                if (entry.position.X > mapDataBoundsMax.X)
                {
                    mapDataBoundsMax.X = entry.position.X;
                }
                if (entry.position.Z > mapDataBoundsMax.Z)
                {
                    mapDataBoundsMax.Z = entry.position.Z;
                }
                if (entry.position.X < mapDataBoundsMin.X)
                {
                    mapDataBoundsMin.X = entry.position.X;
                }
                if (entry.position.Z < mapDataBoundsMin.Z)
                {
                    mapDataBoundsMin.Z = entry.position.Z;
                }
            }

            Draw();
        }
        void Clear()
        {
            Canvas.Children.Clear();
        }
        void Draw()
        {
            foreach (var block in _mapData.blocks)
            {
                DrawBlock(block, BlockStatus.Original);
            }
            DrawArrivals();
        }
        void Draw(Dictionary<int, BlockStatus> blockStatus)
        {
            foreach (var block in _mapData.blocks)
            {
                if (blockStatus.ContainsKey(block.id))
                {
                    DrawBlock(block, blockStatus[block.id]);
                }
            }
            DrawArrivals();
        }
        void Update(Dictionary<int, BlockStatus> blockStatus)
        {
            Clear();
            Draw(blockStatus);
        }
        void DrawArrivals()
        {
            DrawLine(_mapData.arrivals.entries.Select(e => e.position).ToList(), Brushes.Blue);
        }

        void DrawLine(List<Vec3> positions, SolidColorBrush brush)
        {
            if (positions.Count < 2)
                return;
            for (int i = 0; i < positions.Count; ++i)
            {
                if (i == positions.Count - 1)
                    continue;
                var line = new Line();
                line.Stroke = brush;
                line.StrokeThickness = 1;
                var coords_1 = ToCanvasCoords(positions[i]);
                var coords_2 = ToCanvasCoords(positions[i + 1]);
                coords_1.x += generalOffset.X / 2f;
                coords_1.z += generalOffset.Z / 2f;
                coords_2.x += generalOffset.X / 2f;
                coords_2.z += generalOffset.Z / 2f;
                line.X1 = coords_1.x;
                line.Y1 = coords_1.z;
                line.X2 = coords_2.x;
                line.Y2 = coords_2.z;
                Canvas.Children.Add(line);
            }
        }
        void DrawBlock(BlockData blockData, BlockStatus blockStatus)
        {
            var pos = blockData.serializedPositionInWorld;
            var ellipse = new Ellipse();
            ellipse.Fill = BlockStatusToBrush(blockStatus);
            ellipse.StrokeThickness = 1.4;
            ellipse.Stroke = Brushes.Black;
            ellipse.Width = 10;
            ellipse.Height = 10;
            Label label = new Label();
            label.Content = blockData.id;
            AddChild(ellipse, pos, (5, 0, 5));
            AddChild(label, pos, (0, 0, 8));
        }
        SolidColorBrush BlockStatusToBrush(BlockStatus blockStatus) => blockStatus switch
        {
            BlockStatus.Original => Brushes.Red,
            BlockStatus.Problem => Brushes.Orange,
            BlockStatus.Updated => Brushes.Green,
        };
        void AddChild(UIElement child, Vec3 pos, Vec3 centerOffset)
        {
            Canvas.Children.Add(child);
            var coords = ToCanvasCoords(pos);
            coords.x += generalOffset.X / 2f;
            coords.z += generalOffset.Z / 2f;
            Canvas.SetLeft(child, coords.x - centerOffset.X);
            Canvas.SetTop(child, coords.z - centerOffset.Z);
        }
        (float x, float z) ToCanvasCoords(Vec3 vec)
        {
            return (Normalize(vec.X, mapDataBoundsMin.X, mapDataBoundsMax.X) * ((float)Canvas.Width - generalOffset.X), Normalize(vec.Z, mapDataBoundsMin.Z, mapDataBoundsMax.Z) * ((float)Canvas.Height - generalOffset.Z));
        }

        float Normalize(float v, float min, float max) => (v - min) / (max - min);
    }
}

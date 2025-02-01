namespace Serialization
{
    string ItemGenerationPath = "";
    string MapGenerationFilePath = "";

    CGameCtnChallengeInfo@ GetCurrentMapInfo(){
        auto editor = MBEditor::GetEditor();
        auto challenge = editor.Challenge;
        return challenge.MapInfo;
    }

    string GetCurrentMapName(){
        CGameCtnChallengeInfo@ mapInfo = GetCurrentMapInfo();
        return mapInfo.Name;
    }
    string GetCurrentMapPath(){
        CGameCtnChallengeInfo@ mapInfo = GetCurrentMapInfo();
        return mapInfo.Path;
    }
    string GetCurrentMapFile(){
        CGameCtnChallengeInfo@ mapInfo = GetCurrentMapInfo();
        return mapInfo.FileName;
    }
    string GetCurrentMapGenerationFilePathRelative(){
        if(MapGenerationFilePath.Length == 0){
            auto generationPath = Path::Join(GetCurrentMapPath(), Path::Join(GetCurrentMapName(),"_mov-generated.Map.Gbx"));
            MapGenerationFilePath = generationPath;
        }
        return MapGenerationFilePath;
    }
    string GetCurrentMapPathAbsolute(){
        return IO::FromUserGameFolder(Path::Join("Maps", GetCurrentMapPath()));
    }
    string GetCurrentMapGenerationFilePathAbsolute(){
        return IO::FromUserGameFolder(Path::Join("Maps", GetCurrentMapGenerationFilePathRelative()));
    }
    void SetMapGenerationFilePathRelative(const string &in generationFilePath){
        MapGenerationFilePath = generationFilePath;
    }
    string GetCurrentItemGenerationPathRelative(){
        if(ItemGenerationPath.Length == 0){
            auto generationPath = GetCurrentMapName();
            ItemGenerationPath = generationPath;
        }
        return ItemGenerationPath;
    }
    void SetItemGenerationPathRelative(const string &in generationPath){
        ItemGenerationPath = generationPath;
    }

    string GetCurrentItemGenerationFolderAbsolute(){
        return IO::FromUserGameFolder(Path::Join("Items", GetCurrentItemGenerationPathRelative()));
    }
    string GetOrCreateCurrentItemGenerationFolderAbsolute(){
        auto path = GetCurrentItemGenerationFolderAbsolute();
        if(!IO::FolderExists(path)){
            IO::CreateFolder(path);
        }
        return path;
    }
    string GetCurrentMetaDataFolderPathAbsolute()
    {
        return IO::FromStorageFolder(Path::GetDirectoryName(GetCurrentMetaDataFilePath()));
    }
    string GetCurrentMetaDataFilePath(){
        return Path::Join("Saved", Path::Join(GetCurrentMapPath(), Path::SanitizeFileName(GetCurrentMapName()) + ".meta"));
    }

    class MapMetaData{
        string mapPath;
        string mapName;
        dictionary@ aaBBs;
        dictionary@ blocks;
        array<Generation::VarIntDeclaration@> intVars;
        array<Generation::VarFloatDeclaration@> floatVars;
        array<Generation::VarAxisDeclaration@> axisVars;
        array<Generation::VarEasingDeclaration@> easingVars;
        ArrivalCalculator::Arrivals@ arrivals;
        array<const string> groupNames;
    }
    Json::Value GetSerializeMapData(){
        MapMetaData metaData;
        if(ArrivalCalculator::CurrentArrivals is null){
            @ArrivalCalculator::CurrentArrivals = ArrivalCalculator::Arrivals();
        }
        @metaData.arrivals = ArrivalCalculator::CurrentArrivals;
        @metaData.blocks = Generation::blocks;
        @metaData.aaBBs = Generation::aaBBs;
        metaData.groupNames = Generation::groupNames;
        metaData.intVars = Generation::intVars;
        metaData.floatVars = Generation::floatVars;
        metaData.axisVars = Generation::axisVars;
        metaData.easingVars = Generation::easingVars;

        print(GetCurrentMapName());
        metaData.mapName = GetCurrentMapName();
        metaData.mapPath = GetCurrentMapFile();

        auto jsonObject = MapMetaDataJson(metaData);
        return jsonObject;
    }
    void SerializeMapData(){
        string path = IO::FromStorageFolder(GetCurrentMetaDataFilePath());
        auto data = GetSerializeMapData();
        //Json::ToFile(path, data);
        string folderPath = Path::GetDirectoryName(path);
        
        if(!IO::FolderExists(folderPath)){
            IO::CreateFolder(folderPath);
        }

        Json::ToFile(path, data);
    }
    void LoadMapData(){
        Selection::ResetSelection();
        string path = IO::FromStorageFolder(GetCurrentMetaDataFilePath());
        if(!IO::FileExists(path)){
            warn("Map data file does not exist!");
            return;
        }
        auto json = Json::FromFile(path);
        MapMetaData metaData = JsonMapMetaData(json);

        if(!(metaData.arrivals is null)){
            ArrivalCalculator::ClearArrivals();
            @ArrivalCalculator::CurrentArrivals = metaData.arrivals;
        }
        Generation::Clear();
        if(!(metaData.blocks is null)){
            LoadBlocks(metaData.blocks);
        }
        if(!(metaData.aaBBs is null)){
            LoadAABBs(metaData.aaBBs);
        }
        if(!(metaData.groupNames is null)){
            LoadGroupNames(metaData.groupNames);
        }
        if(!(metaData.intVars is null)){
            Generation::intVars = metaData.intVars;
        }
        if(!(metaData.floatVars is null)){
            Generation::floatVars = metaData.floatVars;
        }
        if(!(metaData.axisVars is null)){
            Generation::axisVars = metaData.axisVars;
        }
        if(!(metaData.easingVars is null)){
            Generation::easingVars = metaData.easingVars;
        }

    }
    void LoadBlocks(dictionary@ blocks){
        auto keys = blocks.GetKeys();
        for(uint i=0;i < keys.Length; i++){
            auto key = keys[i];
            auto block = cast<Generation::BlockData>(blocks[key]);
            auto correspondingItem = Generation::FindObjectAtPosition(block.serializedPositionInWorld);
            @block.anchoredObject = correspondingItem;
            if(correspondingItem is null){
                warn("Map data contains id for an item that could not be found in this map!");
                continue;
            }
            Generation::SetBlock(block);
        }
    }
    void LoadGroupNames(array<const string> groupNames){
        Generation::groupNames.Resize(0);
        for(uint i=0;i< groupNames.Length; i++){
            Generation::groupNames.InsertLast(groupNames[i]);
        }
    }
    void LoadAABBs(dictionary@ aaBBs)
    {
        auto keys = aaBBs.GetKeys();
        for(uint i=0;i < keys.Length; i++){
            auto key = keys[i];
            auto aabb = cast<Generation::AABB>(aaBBs[key]);
            Generation::SetAABB(aabb);   
        }
    }

    vec3 JsonVec3(Json::Value@ json){
        return vec3(json["X"], json["Y"], json["Z"]);
    }
    Json::Value@ Vec3Json(vec3 vec){
        Json::Value@ jsonObject = Json::Object();
        jsonObject["X"] = vec.x;
        jsonObject["Y"] = vec.y;
        jsonObject["Z"] = vec.z;
        return jsonObject;
    }

    Json::Value@ ArrivalEntryJson(ArrivalCalculator::ArrivalEntry entry){
        Json::Value@ jsonObject = Json::Object();
        jsonObject["position"] = Vec3Json(entry.position);
        jsonObject["timeSinceStart"] = entry.timeSinceStart;
        return jsonObject;
    }
    ArrivalCalculator::ArrivalEntry JsonArrivalEntry(Json::Value@ json){
        ArrivalCalculator::ArrivalEntry entry;
        entry.position = JsonVec3(json["position"]);
        entry.timeSinceStart = json["timeSinceStart"];
        return entry;
    }
    Json::Value@ ArrivalsJson(ArrivalCalculator::Arrivals@ arrivals)
    {
        Json::Value@ jsonObject = Json::Object();
        Json::Value@ arrivalsArray = Json::Array();
        for(uint i=0;i< arrivals.entries.Length; i++){
            arrivalsArray.Add(ArrivalEntryJson(arrivals.entries[i]));
        }
        jsonObject["entries"] = arrivalsArray;
        return jsonObject;
    }
    ArrivalCalculator::Arrivals@ JsonArrivals(Json::Value@ json){
        ArrivalCalculator::Arrivals arrivals;
        auto entries = json["entries"];
        for(uint i=0;i< entries.Length; i++){
            arrivals.entries.InsertLast(JsonArrivalEntry(entries[i]));
        }
        return arrivals;
    }
   
    Json::Value@ AABBJson(Generation::AABB@ aaBB){
        Json::Value@ jsonObject = Json::Object();
        jsonObject["center"] = Vec3Json(aaBB.center);
        jsonObject["size"] = Vec3Json(aaBB.size);
        jsonObject["id"] = aaBB.id;
        return jsonObject;
    }
    Generation::AABB@ JsonAABB(Json::Value@ json){
        Generation::AABB aaBB;
        aaBB.center = JsonVec3(json["center"]);
        aaBB.size = JsonVec3(json["size"]);
        aaBB.id = json["id"];
        return aaBB;
    }

    Json::Value@ BlockJson(Generation::BlockData@ block){
        Json::Value@ jsonObject = Json::Object();
        jsonObject["id"] = block.id;
        jsonObject["hasArrivalData"] = block.hasArrivalData;
        jsonObject["playerArrivalTime"] = block.playerArrivalTime;
        jsonObject["playerArrivalPosition"] = Vec3Json(block.playerArrivalPosition);
        jsonObject["playerArrivalIndex"] = block.playerArrivalIndex;
        jsonObject["serializedPositionInWorld"] = Vec3Json(block.anchoredObject.AbsolutePositionInMap);
        jsonObject["fullAnimationData"] = BlockAnimationDataJson(block.fullAnimationData);
        jsonObject["group"] = block.group;
        return jsonObject;
    }
    Generation::BlockData@ JsonBlock(Json::Value@ json){
        Generation::BlockData block;
        block.id = json["id"];
        block.hasArrivalData = json["hasArrivalData"];
        block.playerArrivalTime = json["playerArrivalTime"];
        block.playerArrivalPosition = JsonVec3(json["playerArrivalPosition"]);
        block.playerArrivalIndex = json["playerArrivalIndex"];
        block.serializedPositionInWorld = JsonVec3(json["serializedPositionInWorld"]);
        @block.fullAnimationData = JsonBlockAnimationData(json["fullAnimationData"]);
        block.group = json["group"];
        return block;
    }

   //TODO: Serialization of animationData;
   Json::Value@ BlockAnimationDataJson(Generation::BlockAnimationData@ data)
   {
        Json::Value@ jsonObject = Json::Object();
        jsonObject["animationOrder"] = data.animationOrder;
        jsonObject["translationData"] = AnimationDataJson(data.translationData);
        jsonObject["rotationData"] = AnimationDataJson(data.rotationData);
        jsonObject["isLocalSpace"] = data.localAnimation;
        return jsonObject;
   }
   Generation::BlockAnimationData@ JsonBlockAnimationData(Json::Value@ json){
        Generation::BlockAnimationData animData;
        @animData.translationData = JsonAnimationData(json["translationData"]);
        @animData.rotationData = JsonAnimationData(json["rotationData"]);
        animData.animationOrder = Generation::AnimationOrder(int(json["animationOrder"]));
        animData.localAnimation = bool(json["isLocalSpace"]);
        return animData;
    }
   Json::Value@ AnimationDataJson(Generation::AnimationData@ data)
   {
        Json::Value@ jsonObject = Json::Object();
        jsonObject["maxFormula"] = FormulaFloatJson(data.MaxFormula);
        jsonObject["axisFormula"] = FormulaAxisJson(data.AxisFormula);

        jsonObject["wait1DurationFormula"] = FormulaIntJson(data.Wait1DurationFormula);
        jsonObject["wait1EasingFormula"] = FormulaEasingJson(data.Wait1EasingFormula);

        jsonObject["flyInDurationFormula"] = FormulaIntJson(data.FlyInDurationFormula);
        jsonObject["flyInEasingFormula"] = FormulaEasingJson(data.FlyInEasingFormula);

        jsonObject["wait2DurationFormula"] = FormulaIntJson(data.Wait2DurationFormula);
        jsonObject["wait2EasingFormula"] = FormulaEasingJson(data.Wait2EasingFormula);

        jsonObject["flyOutDurationFormula"] = FormulaIntJson(data.FlyOutDurationFormula);
        jsonObject["flyOutEasingFormula"] = FormulaEasingJson(data.FlyOutEasingFormula);

        return jsonObject;
   }
   Generation::AnimationData@ JsonAnimationData(Json::Value@ json){
        Generation::AnimationData animData;
        @animData.MaxFormula = JsonFormulaFloat(json["maxFormula"]);
        @animData.AxisFormula = JsonFormulaAxis(json["axisFormula"]);

        @animData.Wait1DurationFormula = JsonFormulaInt(json["wait1DurationFormula"]);
        @animData.Wait1EasingFormula = JsonFormulaEasing(json["wait1EasingFormula"]);

        @animData.FlyInDurationFormula = JsonFormulaInt(json["flyInDurationFormula"]);
        @animData.FlyInEasingFormula = JsonFormulaEasing(json["flyInEasingFormula"]);

        @animData.Wait2DurationFormula = JsonFormulaInt(json["wait2DurationFormula"]);
        @animData.Wait2EasingFormula = JsonFormulaEasing(json["wait2EasingFormula"]);

        @animData.FlyOutDurationFormula = JsonFormulaInt(json["flyOutDurationFormula"]);
        @animData.FlyOutEasingFormula = JsonFormulaEasing(json["flyOutEasingFormula"]);

        return animData;
    }

   Json::Value@ FormulaEasingJson(Generation::FormulaEasing@ data){
        Json::Value@ jsonObject = Json::Object();
        jsonObject["type"] = data.Type.Value;
        jsonObject["easingValue"] = OperantEasingJson(data.EasingValue, data.Type.Value);
        return jsonObject;
   }
   Generation::FormulaEasing@ JsonFormulaEasing(Json::Value@ json){
        Generation::FormulaEasing easing;
        @easing.Type = Generation::EasinValueTypeContainer(Generation::EasingValueType(int(json["type"])));
        @easing.EasingValue = JsonOperantEasing(json["easingValue"], easing.Type.Value);
        return easing;
    }
   Json::Value@ OperantEasingJson(Generation::EasingValue@ data, Generation::EasingValueType type){
        Json::Value@ jsonObject = Json::Object();
        switch(type){
            case Generation::EasingValueType::Fixed:
                jsonObject["value"] = cast<Generation::FixedEasing>(data).Value;
                break;
            case Generation::EasingValueType::Random:
                {
                    auto rnd = cast<Generation::RandomEasing>(data);
                    jsonObject["randomFlags"] = 
                        (rnd.RandomNone ? 1 << 0 : 0) |
                        (rnd.RandomLinear ? 1 << 1 : 0) |
                        (rnd.RandomQuadIn ? 1 << 2 : 0) |
                        (rnd.RandomQuadOut ? 1 << 3 : 0) |
                        (rnd.RandomQuadInOut ? 1 << 4 : 0) |
                        (rnd.RandomCubicIn ? 1 << 5 : 0) |
                        (rnd.RandomCubicOut ? 1 << 6 : 0) |
                        (rnd.RandomCubicInOut ? 1 << 7 : 0);
                }
                break;
            case Generation::EasingValueType::Var:
                jsonObject["var"] = cast<Generation::VarEasing>(data).Var;
                break;
        }
        return jsonObject;
   }
   Generation::EasingValue@ JsonOperantEasing(Json::Value@ json, Generation::EasingValueType type){
        Generation::EasingValue@ easing;
         switch(type){
            case Generation::EasingValueType::Fixed:
                @easing = Generation::FixedEasing(Generation::EasingType(int(json["value"])));
                break;
            case Generation::EasingValueType::Random:
                {
                    @easing = Generation::RandomEasing(int(json["randomFlags"]));
                }
                break;
            case Generation::EasingValueType::Var:
                @easing = Generation::VarEasing(string(json["var"]));
                break;
        }
        return easing;
    }
   Json::Value@ FormulaAxisJson(Generation::FormulaAxis@ data){
        Json::Value@ jsonObject = Json::Object();
        jsonObject["type"] = data.Type.Type;
        jsonObject["axisValue"] = OperantAxisJson(data.AxisValue, data.Type.Type);
        return jsonObject;
   }
    Generation::FormulaAxis@ JsonFormulaAxis(Json::Value@ json){
        Generation::FormulaAxis axis;
        @axis.Type = Generation::AxisTypeContainer(Generation::AxisValueType(int(json["type"])));
        @axis.AxisValue = JsonOperantAxis(json["axisValue"], axis.Type.Type); 
        return axis;
   }
   Json::Value@ OperantAxisJson(Generation::AxisValue@ data, Generation::AxisValueType type){
        Json::Value@ jsonObject = Json::Object();
        switch(type){
            case Generation::AxisValueType::Fixed:
                jsonObject["axis"] = cast<Generation::FixedAxis>(data).Axis;
                break;
            case Generation::AxisValueType::Random:
                {
                    auto rnd = cast<Generation::RandomAxis>(data);
                    jsonObject["randomX"] = rnd.RandomX;
                    jsonObject["randomY"] = rnd.RandomY;
                    jsonObject["randomZ"] = rnd.RandomZ;
                    jsonObject["avoidArrivalDirection"] = rnd.AvoidArrivalDirection;
                }
                break;
            case Generation::AxisValueType::Var:
                jsonObject["var"] = cast<Generation::VarAxis>(data).Var;
                break;
        }
        return jsonObject;
   }
   Generation::AxisValue@ JsonOperantAxis(Json::Value@ json, Generation::AxisValueType type){
        Generation::AxisValue@ axis;
         switch(type){
            case Generation::AxisValueType::Fixed:
                @axis = Generation::FixedAxis(Generation::MathAxis(int(json["axis"])));
                break;
            case Generation::AxisValueType::Random:
                {
                    auto rnd = Generation::RandomAxis();
                    rnd.RandomX = json["randomX"];
                    rnd.RandomY = json["randomY"];
                    rnd.RandomZ = json["randomZ"];
                    rnd.AvoidArrivalDirection = json["avoidArrivalDirection"];
                    @axis = rnd;
                }
                break;
            case Generation::AxisValueType::Var:
                @axis = Generation::VarAxis(string(json["axis"]));
                break;
        }
        return axis;
    }

   Json::Value@ FormulaIntJson(Generation::FormulaInt@ data){
        Json::Value@ jsonObject = Json::Object();
        jsonObject["type1"] = data.type1.OperantType;
        jsonObject["operant1"] = OperantIntJson(data.operant1, data.type1.OperantType);
        jsonObject["mathOperator"] = data.Operator.Operator;
        jsonObject["type2"] = data.type2.OperantType;
        jsonObject["operant2"] = OperantIntJson(data.operant2, data.type2.OperantType);
        return jsonObject;
   }
   Json::Value@ FormulaFloatJson(Generation::FormulaFloat@ data){
        Json::Value@ jsonObject = Json::Object();
        jsonObject["type1"] = data.type1.OperantType;
        jsonObject["operant1"] = OperantFloatJson(data.operant1, data.type1.OperantType);
        jsonObject["mathOperator"] = data.Operator.Operator;
        jsonObject["type2"] = data.type2.OperantType;
        jsonObject["operant2"] = OperantFloatJson(data.operant2, data.type2.OperantType);
        return jsonObject;
   }
   Generation::FormulaInt@ JsonFormulaInt(Json::Value@ json){
        Generation::FormulaInt formulaInt;
        @formulaInt.type1 = Generation::OperantTypeContainer(Generation::OperantType(int(json["type1"])));
        @formulaInt.type2 = Generation::OperantTypeContainer(Generation::OperantType(int(json["type2"])));
        @formulaInt.Operator = Generation::OperatorContainer(Generation::MathOperator(int(json["mathOperator"])));
        @formulaInt.operant1 = JsonOperantInt(json["operant1"], formulaInt.type1.OperantType);
        @formulaInt.operant2 = JsonOperantInt(json["operant2"], formulaInt.type2.OperantType);
        return formulaInt;
   }
   Generation::FormulaFloat@ JsonFormulaFloat(Json::Value@ json){
        Generation::FormulaFloat formulaInt;
        @formulaInt.type1 = Generation::OperantTypeContainer(Generation::OperantType(int(json["type1"])));
        @formulaInt.type2 = Generation::OperantTypeContainer(Generation::OperantType(int(json["type2"])));
        @formulaInt.Operator = Generation::OperatorContainer(Generation::MathOperator(int(json["mathOperator"])));
        @formulaInt.operant1 = JsonOperantFloat(json["operant1"], formulaInt.type1.OperantType);
        @formulaInt.operant2 = JsonOperantFloat(json["operant2"], formulaInt.type2.OperantType);
        return formulaInt;
   }
   Json::Value@ OperantIntJson(Generation::OperantInt@ data, Generation::OperantType type){
        Json::Value@ jsonObject = Json::Object();
        switch(type){
            case Generation::OperantType::Fixed:
                jsonObject["value"] = cast<Generation::FixedInt>(data).Value;
                break;
            case Generation::OperantType::Random:
                {
                    auto rnd = cast<Generation::RandomInt>(data);
                    jsonObject["min"] = rnd.Min;
                    jsonObject["max"] = rnd.Max;
                }
                break;
            case Generation::OperantType::ArrivalTime:
                break;
            case Generation::OperantType::Var:
                jsonObject["var"] = cast<Generation::VarInt>(data).Var;
                break;
            case Generation::OperantType::ValueFrom:
                jsonObject["option"] = cast<Generation::ValueFromInt>(data).Option;
                break;
        }
        return jsonObject;
   }
    Json::Value@ OperantFloatJson(Generation::OperantFloat@ data, Generation::OperantType type){
        Json::Value@ jsonObject = Json::Object();
        switch(type){
            case Generation::OperantType::Fixed:
                jsonObject["value"] = cast<Generation::FixedFloat>(data).Value;
                break;
            case Generation::OperantType::Random:
                {
                    auto rnd = cast<Generation::RandomFloat>(data);
                    jsonObject["min"] = rnd.Min;
                    jsonObject["max"] = rnd.Max;
                }
                break;
            case Generation::OperantType::ArrivalTime:
                break;
            case Generation::OperantType::Var:
                jsonObject["var"] = cast<Generation::VarFloat>(data).Var;
                break;
        }
        return jsonObject;
   }
   Generation::OperantInt@ JsonOperantInt(Json::Value@ json, Generation::OperantType type){
        Generation::OperantInt@ operant;
         switch(type){
            case Generation::OperantType::Fixed:
                @operant = Generation::FixedInt(int(json["value"]));
                break;
            case Generation::OperantType::Random:
                {
                    auto rnd = Generation::RandomInt();
                    rnd.Min = json["min"];
                    rnd.Max = json["max"];
                    @operant = rnd;
                }
                break;
            case Generation::OperantType::ArrivalTime:
                {
                    @operant = Generation::ArrivalTime();
                }
                break;
            case Generation::OperantType::Var:
                @operant = Generation::VarInt(string(json["var"]));
                break;
            case Generation::OperantType::ValueFrom:
                @operant = Generation::ValueFromInt(Generation::AnimationOptions(int(json["option"])));
        }
        return operant;
    }
    Generation::OperantFloat@ JsonOperantFloat(Json::Value@ json, Generation::OperantType type){
        Generation::OperantFloat@ operant;
         switch(type){
            case Generation::OperantType::Fixed:
                @operant = Generation::FixedFloat(float(json["value"]));
                break;
            case Generation::OperantType::Random:
                {
                    auto rnd = Generation::RandomFloat();
                    rnd.Min = json["min"];
                    rnd.Max = json["max"];
                    @operant = rnd;
                }
                break;
            case Generation::OperantType::ArrivalTime:
                {
                    @operant = Generation::ArrivalTimeFloat();
                }
                break;
            case Generation::OperantType::Var:
                @operant = Generation::VarFloat(string(json["var"]));
                break;
        }
        return operant;
    }
    Json::Value@ VarIntDeclarationJson(Generation::VarIntDeclaration@ data){
        Json::Value@ jsonObject = Json::Object();
        jsonObject["id"] = data.id;
        jsonObject["formula"] = FormulaIntJson(data.formula);
        return jsonObject;
    }
    Generation::VarIntDeclaration@ JsonVarIntDeclaration(Json::Value@ data){
        Generation::VarIntDeclaration@ decl = Generation::VarIntDeclaration(data["id"]);
        @decl.formula = JsonFormulaInt(data["formula"]);
        return decl;
    }

    Json::Value@ VarFloatDeclarationJson(Generation::VarFloatDeclaration@ data){
        Json::Value@ jsonObject = Json::Object();
        jsonObject["id"] = data.id;
        jsonObject["formula"] = FormulaFloatJson(data.formula);
        return jsonObject;
    }
    Generation::VarFloatDeclaration@ JsonVarFloatDeclaration(Json::Value@ data){
        Generation::VarFloatDeclaration@ decl = Generation::VarFloatDeclaration(data["id"]);
        @decl.formula = JsonFormulaFloat(data["formula"]);
        return decl;
    }
    Json::Value@ VarAxisDeclarationJson(Generation::VarAxisDeclaration@ data){
        Json::Value@ jsonObject = Json::Object();
        jsonObject["id"] = data.id;
        jsonObject["formula"] = FormulaAxisJson(data.formula);
        return jsonObject;
    }
    Generation::VarAxisDeclaration@ JsonVarAxisDeclaration(Json::Value@ data){
        Generation::VarAxisDeclaration@ decl = Generation::VarAxisDeclaration(data["id"]);
        @decl.formula = JsonFormulaAxis(data["formula"]);
        return decl;
    }
    Json::Value@ VarEasingDeclarationJson(Generation::VarEasingDeclaration@ data){
        Json::Value@ jsonObject = Json::Object();
        jsonObject["id"] = data.id;
        jsonObject["formula"] = FormulaEasingJson(data.formula);
        return jsonObject;
    }
    Generation::VarEasingDeclaration@ JsonVarEasingDeclaration(Json::Value@ data){
        Generation::VarEasingDeclaration@ decl = Generation::VarEasingDeclaration(data["id"]);
        @decl.formula = JsonFormulaEasing(data["formula"]);
        return decl;
    }

    


    Json::Value@ MapMetaDataJson(MapMetaData@ mapMetaData){
        Json::Value@ jsonObject = Json::Object();

        jsonObject["mapName"] = mapMetaData.mapName;
        jsonObject["mapPath"] = mapMetaData.mapPath;
        jsonObject["arrivals"] = ArrivalsJson(mapMetaData.arrivals);
        
        Json::Value blockArray = Json::Array();
        auto blockKeys = mapMetaData.blocks.GetKeys();
        for(uint i=0;i < blockKeys.Length; i++){
            auto key = blockKeys[i];
            auto block = cast<Generation::BlockData>(mapMetaData.blocks[key]);
            blockArray.Add(BlockJson(block));
        }
        jsonObject["blocks"] = blockArray;

        Json::Value aaBBArray = Json::Array();
        auto aaBBKeys = mapMetaData.aaBBs.GetKeys();
        for(uint i=0;i < aaBBKeys.Length; i++){
            auto key = aaBBKeys[i];
            auto aaBB = cast<Generation::AABB>(mapMetaData.aaBBs[key]);
            aaBBArray.Add(AABBJson(aaBB));
        }
        jsonObject["AABBs"] = aaBBArray;

        Json::Value intVarsArray = Json::Array();
        for(uint i=0;i < mapMetaData.intVars.Length; i++){
            intVarsArray.Add(VarIntDeclarationJson(mapMetaData.intVars[i]));
        }
        jsonObject["intVars"] = intVarsArray;

        Json::Value floatVarsArray = Json::Array();
        for(uint i=0;i < mapMetaData.floatVars.Length; i++){
            floatVarsArray.Add(VarFloatDeclarationJson(mapMetaData.floatVars[i]));
        }
        jsonObject["floatVars"] = floatVarsArray;

        Json::Value axisVarsArray = Json::Array();
        for(uint i=0;i < mapMetaData.axisVars.Length; i++){
            axisVarsArray.Add(VarAxisDeclarationJson(mapMetaData.axisVars[i]));
        }
        jsonObject["axisVars"] = axisVarsArray;

        Json::Value easingVarsArray = Json::Array();
        for(uint i=0;i < mapMetaData.easingVars.Length; i++){
            easingVarsArray.Add(VarEasingDeclarationJson(mapMetaData.easingVars[i]));
        }
        jsonObject["easingVars"] = easingVarsArray;

        Json::Value groupNamesArray = Json::Array();
        for(uint i=0;i < mapMetaData.groupNames.Length; i++){
            groupNamesArray.Add(mapMetaData.groupNames[i]);
        }
        jsonObject["groupNames"] = groupNamesArray;

        return jsonObject;
    }
    MapMetaData@ JsonMapMetaData(Json::Value@ json){
        MapMetaData metaData = MapMetaData();
        @metaData.blocks = dictionary();
        @metaData.aaBBs = dictionary();
        @metaData.arrivals = JsonArrivals(json["arrivals"]);
        metaData.mapName = json["mapName"];
        metaData.mapPath = json["mapPath"];
        
        Json::Value blockArray = json["blocks"];
        for(uint i=0;i < blockArray.Length; i++){
            auto blockJson = blockArray[i];
            auto block = JsonBlock(blockJson);
            metaData.blocks.Set(Generation::GetStringId(block.id), block);
        }

        Json::Value aaBBArray = json["AABBs"];
        for(uint i=0;i < aaBBArray.Length; i++){
            auto aaBBJson = aaBBArray[i];
            auto aaBB = JsonAABB(aaBBJson);
            metaData.aaBBs.Set(aaBB.id, aaBB);
        }

        Json::Value intVarArray = json["intVars"];
        for(uint i=0;i < intVarArray.Length; i++){
            metaData.intVars.InsertLast(JsonVarIntDeclaration(intVarArray[i]));
        }
        Json::Value floatVarArray = json["floatVars"];
        for(uint i=0;i < floatVarArray.Length; i++){
            metaData.floatVars.InsertLast(JsonVarFloatDeclaration(floatVarArray[i]));
        }
        Json::Value axisVarArray = json["axisVars"];
        for(uint i=0;i < axisVarArray.Length; i++){
            metaData.axisVars.InsertLast(JsonVarAxisDeclaration(axisVarArray[i]));
        }
        Json::Value easingVarArray = json["easingVars"];
        for(uint i=0;i < easingVarArray.Length; i++){
            metaData.easingVars.InsertLast(JsonVarEasingDeclaration(easingVarArray[i]));
        }

        Json::Value groupNamesArray = json["groupNames"];
        for(uint i=0;i < groupNamesArray.Length; i++){
            metaData.groupNames.InsertLast(groupNamesArray[i]);
        }


        return metaData;
    }

   
}
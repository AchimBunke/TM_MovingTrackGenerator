namespace Generation
{
    enum MathOperator
    {
        Plus,
        Minus,
        Multiply,
        Divide,
    }
    enum MathAxis{
        X,
        Y,
        Z,
    }
    enum AxisValueType{
        Fixed,
        Random,
        Var,
    }
    enum EasingValueType{
        Fixed,
        Random,
        Var,
    }
    enum OperantType{
        Fixed,
        Random,
        ArrivalTime,
        Var,
        ValueFrom,
    }
    enum EasingType{
        None,
        Linear,
        QuadIn,
        QuadOut,
        QuadInOut,
        CubicIn,
        CubicOut,
        CubicInOut,
    }
    class VarIntDeclaration
    {
        string id;
        FormulaInt@ formula;
        VarIntDeclaration(){
            @formula = FormulaInt();
        }
        VarIntDeclaration(const string &in varName){
            id = varName;
            @formula = FormulaInt();
        }
    }
    class VarFloatDeclaration
    {
        string id;
        FormulaFloat@ formula;
        VarFloatDeclaration(){
            @formula = FormulaFloat();
        }
        VarFloatDeclaration(const string &in varName){
            id = varName;
            @formula = FormulaFloat();
        }
    }
    class VarAxisDeclaration
    {
        string id;
        FormulaAxis@ formula;
        VarAxisDeclaration(){
            @formula = FormulaAxis();
        }
        VarAxisDeclaration(const string &in varName){
            id = varName;
            @formula = FormulaAxis();
        }
    }
    class VarEasingDeclaration
    {
        string id;
        FormulaEasing@ formula;
        VarEasingDeclaration(){
            @formula = FormulaEasing();
        }
        VarEasingDeclaration(const string &in varName){
            id = varName;
            @formula = FormulaEasing();
        }
    }
    class FormulaInt{
        OperantInt@ operant1;
        OperantTypeContainer@ type1;
        OperatorContainer@ Operator;
        OperantInt@ operant2;
        OperantTypeContainer@ type2;

        FormulaInt(){
            @operant1 = FixedInt();
            @type1 = OperantTypeContainer(OperantType::Fixed);
            @Operator = OperatorContainer();
            @operant2 = FixedInt();
            @type2 = OperantTypeContainer(OperantType::Fixed);
        }
        FormulaInt(FormulaInt@ other){
            @operant1 = other.operant1.Copy();
            @type1 = OperantTypeContainer(other.type1.OperantType);
            @Operator = OperatorContainer(other.Operator.Operator);
            @operant2 = other.operant2.Copy();
            @type2 = OperantTypeContainer(other.type2.OperantType);
        }
    }
    class FormulaFloat{
        OperantFloat@ operant1;
        OperantTypeContainer@ type1;
        OperatorContainer@ Operator;
        OperantFloat@ operant2;
        OperantTypeContainer@ type2;

        FormulaFloat(){
            @operant1 = FixedFloat();
            @type1 = OperantTypeContainer(OperantType::Fixed);
            @Operator = OperatorContainer();
            @operant2 = FixedFloat();
            @type2 = OperantTypeContainer(OperantType::Fixed);
        }
        FormulaFloat(FormulaFloat@ other){
            @operant1 = other.operant1.Copy();
            @type1 = OperantTypeContainer(other.type1.OperantType);
            @Operator = OperatorContainer(other.Operator.Operator);
            @operant2 = other.operant2.Copy();
            @type2 = OperantTypeContainer(other.type2.OperantType);
        }
    }
    class EasinValueTypeContainer{
        EasingValueType Value;
        EasinValueTypeContainer(){};
        EasinValueTypeContainer(EasingValueType type){
            Value = type;
        }
    }
    class AxisTypeContainer{
        AxisValueType Type;
        AxisTypeContainer(){}
        AxisTypeContainer(AxisValueType type){
            Type = type;
        }
    }
    class FormulaAxis{
        AxisValue@ AxisValue;
        AxisTypeContainer@ Type;
        FormulaAxis(){
            @AxisValue = FixedAxis();
            @Type = AxisTypeContainer();
        }
        FormulaAxis(FormulaAxis@ other){
            @AxisValue = other.AxisValue.Copy();
            @Type = AxisTypeContainer(other.Type.Type);
        }
    }
    class FormulaEasing{
        EasingValue@ EasingValue;
        EasinValueTypeContainer@ Type;
        FormulaEasing(){
            @EasingValue = FixedEasing();
            @Type = EasinValueTypeContainer();
        }
        FormulaEasing(EasingValue@ easingValue, EasingValueType valueType){
            @EasingValue = easingValue;
            @Type = EasinValueTypeContainer(valueType);
        }
        FormulaEasing(FormulaEasing@ other){
            @EasingValue = other.EasingValue.Copy();
            @Type = EasinValueTypeContainer(other.Type.Value);
        }
    }
    class OperantTypeContainer{
        OperantType OperantType;
        OperantTypeContainer(){
            OperantType = OperantType::Fixed;
        }
        OperantTypeContainer(OperantType type){
            OperantType = type;
        }
    }
    class OperatorContainer
    {
        MathOperator Operator;
        OperatorContainer(){}
        OperatorContainer(MathOperator operator){
            Operator = operator;
        }
    }
    class OperantFloat{
        OperantFloat@ Copy(){return null;}
    }
    class OperantInt{
        OperantInt@ Copy(){return null;}
    }
    class RandomInt : OperantInt
    {
        OperantInt@ Copy() override{
            RandomInt f;
            f.Min = Min; 
            f.Max = Max;
            return f;
        }
        RandomInt(){}
        int Min;
        int Max;
    }
    class RandomFloat : OperantFloat
    {
        OperantFloat@ Copy() override{
            RandomFloat f;
            f.Min = Min; 
            f.Max = Max;
            return f;
        }
        RandomFloat(){}
        float Min;
        float Max;
    }
    class AxisValue{
        AxisValue@ Copy() { return AxisValue();}
    }
    class EasingValue
    {
        EasingValue@ Copy() {return null;}
    }
    class FixedEasing : EasingValue{
        EasingValue@ Copy() override{
            FixedEasing f;
            f.Value = Value; 
            return f;
        }
        FixedEasing(){}
        FixedEasing(EasingType type){Value = type;}
        EasingType Value;
    }
    class VarEasing : EasingValue{
        EasingValue@ Copy() override{
            VarEasing f;
            f.Var = Var; 
            return f;
        }
        VarEasing(){}
        VarEasing(const string &in var){Var = var;}
        string Var;
    }
    class RandomEasing : EasingValue{
        EasingValue@ Copy() override{
            RandomEasing c;
            c.RandomNone = RandomNone;
            c.RandomLinear = RandomLinear;
            c.RandomQuadIn = RandomQuadIn;
            c.RandomQuadOut = RandomQuadOut;
            c.RandomQuadInOut = RandomQuadInOut;
            c.RandomCubicIn = RandomCubicIn;
            c.RandomCubicOut = RandomCubicOut;
            c.RandomCubicInOut = RandomCubicInOut;
            return c;
        }
        bool RandomNone;
        bool RandomLinear;
        bool RandomQuadIn;
        bool RandomQuadOut;
        bool RandomQuadInOut;
        bool RandomCubicIn;
        bool RandomCubicOut;
        bool RandomCubicInOut;
        RandomEasing(){}
        RandomEasing(int flags){
            RandomNone      = (flags & (1 << 0)) != 0;
            RandomLinear    = (flags & (1 << 1)) != 0;
            RandomQuadIn    = (flags & (1 << 2)) != 0;
            RandomQuadOut   = (flags & (1 << 3)) != 0;
            RandomQuadInOut = (flags & (1 << 4)) != 0;
            RandomCubicIn   = (flags & (1 << 5)) != 0;
            RandomCubicOut  = (flags & (1 << 6)) != 0;
            RandomCubicInOut = (flags & (1 << 7)) != 0;
        }
    }
    class RandomAxis : AxisValue{
        AxisValue@ Copy() override{
            RandomAxis c;
            c.AvoidArrivalDirection = AvoidArrivalDirection;
            c.RandomX = RandomX;
            c.RandomY = RandomY;
            c.RandomZ = RandomZ;
            return c;
        }
        bool RandomX = true;
        bool RandomY = true;
        bool RandomZ = true;
        bool AvoidArrivalDirection = false;
        RandomAxis(){
        }
    }
    class FixedInt : OperantInt{
        OperantInt@ Copy() override{
            FixedInt f;
            f.Value = Value; 
            return f;
        }
        FixedInt(){}
        FixedInt(int val){Value = val;}
        int Value;
    }
    class FixedFloat : OperantFloat{
        OperantFloat@ Copy() override{
            FixedFloat f;
            f.Value = Value; 
            return f;
        }
        FixedFloat(){}
        FixedFloat(float val){Value = val;}
        float Value;
    }
    class VarInt : OperantInt{
        OperantInt@ Copy() override{
            VarInt f;
            f.Var = Var; 
            return f;
        }
        VarInt(){}
        VarInt(const string &in var){Var = var;}
        string Var;
    }
    class VarFloat : OperantFloat{
        OperantFloat@ Copy() override{
            VarFloat f;
            f.Var = Var; 
            return f;
        }
        VarFloat(){}
        VarFloat(const string &in var){Var = var;}
        string Var;
    }
    class FixedAxis : AxisValue{
        AxisValue@ Copy() override{
            FixedAxis f;
            f.Axis = Axis; 
            return f;
        }
        FixedAxis(){}
        FixedAxis(MathAxis axis){
            Axis = axis;
        }
        MathAxis Axis;
    }
    class VarAxis : AxisValue{
        AxisValue@ Copy() override{
            VarAxis f;
            f.Var = Var; 
            return f;
        }
        VarAxis(){}
        VarAxis(const string &in var){
            Var = var;
        }
        string Var;
    }
    class ArrivalTime : OperantInt{
        OperantInt@ Copy() override{
            ArrivalTime f;
            return f;
        }
    }
    class ArrivalTimeFloat : OperantFloat{
        OperantFloat@ Copy() override{
            ArrivalTimeFloat f;
            return f;
        }
    }
    enum AnimationOptions{
        Wait_1,
        Wait_2,
        FlyIn,
        FlyOut,
    }
    class ValueFromInt : OperantInt{
         OperantInt@ Copy() override{
            ValueFromInt f;
            f.Option = Option; 
            return f;
        }
        ValueFromInt(){}
        ValueFromInt(AnimationOptions option){Option = option;}
        AnimationOptions Option;
    }

    AxisValue@ GetAxisValueFromType(AxisValueType type){
        switch(type){
            case AxisValueType::Fixed:
                return FixedAxis();
            case AxisValueType::Random:
                return RandomAxis();
            case AxisValueType::Var:
                return VarAxis(); 
        }
        return FixedAxis();
    }
    EasingValue@ GetEasingValueFromType(EasingValueType type){
        switch(type){
            case EasingValueType::Fixed:
                return FixedEasing();
            case EasingValueType::Random:
                return RandomEasing();
            case AxisValueType::Var:
                return VarEasing();
        }
        return FixedEasing();
    }
    OperantInt@ GetOperantFromType(OperantType type)
    {
        switch(type){
            case OperantType::Fixed:
                return FixedInt();
            case OperantType::Random:
                return RandomInt();
            case OperantType::ArrivalTime:
                return ArrivalTime();
            case OperantType::Var:
                return VarInt();
            case OperantType::ValueFrom:
                return ValueFromInt();
        }
        return FixedInt();
    }
    OperantFloat@ GetOperantFloatFromType(OperantType type)
    {
        switch(type){
            case OperantType::Fixed:
                return FixedFloat();
            case OperantType::Random:
                return RandomFloat();
            case OperantType::ArrivalTime:
                return ArrivalTimeFloat();
            case OperantType::Var:
                return VarFloat();
        }
        return FixedFloat();
    }

    class BlockData{
        int id;
        CGameCtnAnchoredObject@ anchoredObject;

        bool hasArrivalData;
        int32 playerArrivalTime;
        vec3 playerArrivalPosition;
        int playerArrivalIndex;

        BlockAnimationData@ fullAnimationData = BlockAnimationData();

        // Only for deserialization
        vec3 serializedPositionInWorld;


    }
    BlockAnimationData@ blockAnimationDataCopy;

    class BlockAnimationData{
        AnimationOrder animationOrder;
        AnimationData@ translationData;
        AnimationData@ rotationData;
        BlockAnimationData(){
            @translationData = AnimationData();
            @rotationData = AnimationData();
        }
        BlockAnimationData(BlockAnimationData@ other){
            animationOrder = other.animationOrder;
            @translationData = AnimationData(other.translationData);
            @rotationData = AnimationData(other.rotationData);
        }

    }
    enum AnimationOrder{
        Wait_FlyIn_Wait_FlyOut,
        Wait_FlyOut_Wait_FlyIn,
    }
    class AnimationData{
        FormulaFloat@ MaxFormula;
        FormulaAxis@ AxisFormula;

        FormulaInt@ Wait1DurationFormula;
        FormulaEasing@ Wait1EasingFormula;

        FormulaInt@ FlyInDurationFormula;
        FormulaEasing@ FlyInEasingFormula;

        FormulaInt@ Wait2DurationFormula;
        FormulaEasing@ Wait2EasingFormula;

        FormulaInt@ FlyOutDurationFormula;
        FormulaEasing@ FlyOutEasingFormula;
        AnimationData(){
            @MaxFormula = FormulaFloat();
            @AxisFormula = FormulaAxis();
            @Wait1DurationFormula = FormulaInt();
            @Wait1EasingFormula = FormulaEasing();
            @FlyInDurationFormula = FormulaInt();
            @FlyInEasingFormula = FormulaEasing(FixedEasing(EasingType::QuadInOut), EasingValueType::Fixed);
            @Wait2DurationFormula = FormulaInt();
            @Wait2EasingFormula = FormulaEasing();
            @FlyOutDurationFormula = FormulaInt();
            @FlyOutEasingFormula = FormulaEasing(FixedEasing(EasingType::QuadInOut), EasingValueType::Fixed);
        }
        AnimationData(AnimationData@ other){
            @MaxFormula = FormulaFloat(other.MaxFormula);
            @AxisFormula = FormulaAxis(other.AxisFormula);
            @Wait1DurationFormula = FormulaInt(other.Wait1DurationFormula);
            @Wait1EasingFormula = FormulaEasing(other.Wait1EasingFormula);
            @FlyInDurationFormula = FormulaInt(other.FlyInDurationFormula);
            @FlyInEasingFormula = FormulaEasing(other.FlyInEasingFormula);
            @Wait2DurationFormula = FormulaInt(other.Wait2DurationFormula);
            @Wait2EasingFormula = FormulaEasing(other.Wait2EasingFormula);
            @FlyOutDurationFormula = FormulaInt(other.FlyOutDurationFormula);
            @FlyOutEasingFormula = FormulaEasing(other.FlyOutEasingFormula);
        }
    }


    class AABB{
        string id;
        vec3 size = vec3(8,8,8);
        vec3 center = vec3(0,0,0);
    }


    int objCounter = 0;
    array<CGameCtnAnchoredObject@> markedObjects;
    array<int> objectIds;
    dictionary blocks;
    dictionary aaBBs;
    array<VarIntDeclaration@> intVars;
    array<VarFloatDeclaration@> floatVars;
    array<VarAxisDeclaration@> axisVars;
    array<VarEasingDeclaration@> easingVars;

    void MarkObject(CGameCtnAnchoredObject@ obj){
        if(IsMarked(obj))
            return;
        markedObjects.InsertLast(obj);

        BlockData blockData;
        blockData.id = objCounter;
        @blockData.anchoredObject = obj;
        blocks[GetStringId(objCounter)]= blockData;

        objectIds.InsertLast(objCounter++);
        
    }
    AABB@ GetAABB(CGameCtnAnchoredObject@ obj){
        return GetAABB(obj.ItemModel.IdName);
    }
    AABB@ GetAABB(const string &in itemModelPath){
        AABB@ val = cast<AABB@>(aaBBs[itemModelPath]);
        if(val is null){
            auto newv = AABB();
            newv.id = itemModelPath;
            aaBBs.Set(itemModelPath, newv);
            return newv;
        }
        return val;
    }
    void SetAABB(AABB@ aaBB){
        aaBBs.Set(aaBB.id,aaBB);
    }
    void SetAABB(const string &in itemModelPath, vec3 size, vec3 center){
        AABB val = AABB();
        val.size = size;
        val.id = itemModelPath;
        val.center = center;
        aaBBs.Set(itemModelPath,val);
    }
    string GetStringId(int id){
        return ""+id;
    }
    void CleanupDeletedObjects(){
        for (uint i = 0; i < markedObjects.Length; i++) {
            if (markedObjects[i] is null) {
                markedObjects.RemoveAt(i); // Remove invalid references
                objectIds.RemoveAt(i);
                blocks.Delete(GetStringId(i));
            }
        }
    }
    void Clear(){
        markedObjects.Resize(0);
        objectIds.Resize(0);
        objCounter = 0;
        blocks.DeleteAll();
    }
    void SetMarkedItem(CGameCtnAnchoredObject@ obj, int id){
        if(id < objCounter){
            warn("Id might already be assigned to another item");
        }
        if(IsMarked(obj))
        {
            UnMark(obj);
        }
        markedObjects.InsertLast(obj);
        objectIds.InsertLast(id);

        BlockData blockData;
        blockData.id = id;
        @blockData.anchoredObject = obj;
        blocks[GetStringId(id)] = blockData;

        objCounter = Math::Max(objCounter, id) +1;
    }
    void SetBlock(BlockData@ block){
        if(IsMarked(block.anchoredObject))
        {
            UnMark(block.anchoredObject);
        }
        blocks.Set(GetStringId(block.id), block);
        markedObjects.InsertLast(block.anchoredObject);
        objectIds.InsertLast(block.id);
        objCounter = Math::Max(objCounter, block.id) +1;
    }

    void UnMark(CGameCtnAnchoredObject@ obj){
        int idx;
        if((idx = markedObjects.FindByRef(obj)) >= 0){
            markedObjects.RemoveAt(idx);
            objectIds.RemoveAt(idx);
            blocks.Delete(GetStringId(idx));
        }
    }

    bool IsMarked(CGameCtnAnchoredObject@ obj){
        return(markedObjects.FindByRef(obj) >= 0);
    }

    int GetId(CGameCtnAnchoredObject@ obj){
        int idx;
        if((idx = markedObjects.FindByRef(obj)) >= 0){
            return objectIds[idx];
        }
        return -1;
    }

    void MarkAllInstances(CGameCtnAnchoredObject@ obj){
        auto challenge = MBEditor::GetChallenge();
        auto anchoredItems = challenge.AnchoredObjects;
        for(uint i= 0; i< anchoredItems.Length; i++){
            if(anchoredItems[i].ItemModel.IdName == obj.ItemModel.IdName){
                if(!IsMarked(anchoredItems[i])){
                    MarkObject(anchoredItems[i]);
                }
            }
        }
    }

    CGameCtnAnchoredObject@ FindObjectAtPosition(vec3 position){
        auto challenge = MBEditor::GetChallenge();
        auto anchoredItems = challenge.AnchoredObjects;
        for(uint i=0;i< anchoredItems.Length; i++){
            if(EqualPosition(anchoredItems[i].AbsolutePositionInMap, position)){
                return anchoredItems[i];
            }
        }
        return null;
    }

    bool EqualPosition(vec3 p1, vec3 p2){
        return Math::Abs(p1.x - p2.x) <= 0.001f && Math::Abs(p1.y - p2.y) <= 0.001f && Math::Abs(p1.z - p2.z) <= 0.001f;
    }



    void DrawPositionIndicators(){
        vec4 fillcolor = vec4(1,0,1,1);
        vec4 strokecolor = vec4(0,0,0,1);
        float fillsize = 5;
        float strokesize = 2;
        for(uint i=0;i<markedObjects.Length;i++){
            auto obj = markedObjects[i];
            DrawPositionIndicator(obj,fillcolor,strokecolor, fillsize,strokesize );
        }
    }
    const vec4 ArrivalStrokeColor = vec4(1,0,0,1);
    const float ArrivalStrokeWidth = 2;
    void DrawArrivalTimes()
    {
        auto keys = blocks.GetKeys();
        for(uint i=0;i < keys.Length; i++){
            auto key = keys[i];
            auto block = cast<BlockData@>(blocks[key]);
            if(block is null){continue;}
            DrawArrivalTime(block);
        }
    }

    void DrawArrivalTime(BlockData@ blockData){
        if(!blockData.hasArrivalData){return;}
        auto itemPos = blockData.anchoredObject.AbsolutePositionInMap;
        auto arrivalPosScreen = Camera::ToScreenSpace(blockData.playerArrivalPosition);
        auto isArrivalBehindCamera = Camera::IsBehind(blockData.playerArrivalPosition);
        if(Camera::IsBehind(itemPos) || isArrivalBehindCamera){
            return;
        }
        nvg::BeginPath();
        nvg::MoveTo(Camera::ToScreenSpace(itemPos));
        nvg::LineTo(arrivalPosScreen);
        nvg::Circle(arrivalPosScreen, 2);
        nvg::StrokeColor(ArrivalStrokeColor);
        nvg::FillColor(ArrivalStrokeColor);
        nvg::StrokeWidth(ArrivalStrokeWidth);
        nvg::Stroke();
        nvg::FontSize(20);
        nvg::Text(arrivalPosScreen, "" +blockData.playerArrivalTime + 
            "(" + (blockData.playerArrivalTime - ArrivalGeneration::arrivalTimeOffset) +")");
        nvg::ClosePath();
    }

    void DrawPositionIndicator(CGameCtnAnchoredObject@ obj, vec4 fillColor, vec4 strokeColor, float fillSize, float strokeSize){
        auto p = obj.AbsolutePositionInMap;
        if(Camera::IsBehind(p))
        {
            return;
        }
        nvg::BeginPath();
        nvg::Circle(Camera::ToScreenSpace(p),fillSize);
        nvg::FillColor(fillColor);
        nvg::StrokeColor(strokeColor);
        nvg::StrokeWidth(strokeSize);
        nvg::Fill();
        nvg::Stroke();
        nvg::ClosePath();
    }
    void DrawObjectInfos(int id){
        vec4 fillcolor = vec4(1,0,0,1);
        vec4 strokecolor = vec4(0,0,0,1);
        float fillsize = 8;
        float strokesize = 2;
        auto e = blocks[GetStringId(id)];
        if(BlockData(e) is null){return;}
        BlockData block = BlockData(e);
        auto obj = block.anchoredObject;
        if(obj is null){return;}
        DrawPositionIndicator(obj,fillcolor,strokecolor, fillsize,strokesize );
    }
    const vec4 AABBStrokeColor = vec4(0,1,0,1);
    const float AABBStrokeWidth = 2;
    void DrawAABB(CGameCtnAnchoredObject@ obj){
        auto itemModel = obj.ItemModel;
        string id = itemModel.IdName;
        auto aaBB = GetAABB(id);
        auto aaBBSize = aaBB.size;
        auto center = obj.AbsolutePositionInMap + aaBB.center;
        if(Camera::IsBehind(center)){
            return;
        }
        auto halfSize = aaBBSize / 2.;

        auto bl_b = center - halfSize;
        auto bl_t = bl_b + vec3(0, aaBBSize.y, 0);

        auto tl_b = bl_b + vec3(aaBBSize.x, 0 ,0);
        auto tl_t = tl_b + vec3(0, aaBBSize.y, 0);

        auto br_b = bl_b + vec3(0, 0 ,aaBBSize.z);
        auto br_t = br_b + vec3(0, aaBBSize.y, 0);

        auto tr_b = center + halfSize;
        auto tr_t = tr_b - vec3(0, aaBBSize.y, 0);
        nvg::BeginPath();
        nvg::MoveTo(Camera::ToScreenSpace(bl_b));
        nvg::LineTo(Camera::ToScreenSpace(bl_t));
        nvg::MoveTo(Camera::ToScreenSpace(tl_b));
        nvg::LineTo(Camera::ToScreenSpace(tl_t));
        nvg::MoveTo(Camera::ToScreenSpace(br_b));
        nvg::LineTo(Camera::ToScreenSpace(br_t));
        nvg::MoveTo(Camera::ToScreenSpace(tr_b));
        nvg::LineTo(Camera::ToScreenSpace(tr_t));
        nvg::Circle(Camera::ToScreenSpace(center), 2);
        nvg::StrokeWidth(AABBStrokeWidth);
        nvg::StrokeColor(AABBStrokeColor);
        nvg::Stroke();
        nvg::ClosePath();

    }

    void DrawInfosForSelectedItem(){
        if(!Selection::IsItemPicked){ return;}
        auto pickedObject = Selection::PickedObject;
        if(!IsMarked(pickedObject)){ return;}
        auto id = GetId(pickedObject);
        DrawObjectInfos(id);
        DrawAABB(pickedObject);
    }


    namespace ArrivalGeneration
    {
        int32 arrivalTimeOffset = 0;

        // generate time and position when a player begins to hit/move over the block
        //  from the current arrivals
        void GeneratePlayerArrivals(){
            if(ArrivalCalculator::CurrentArrivals is null){
                return;
            }
            auto keys = blocks.GetKeys();
            for(uint i=0; i< keys.Length; i++){
                auto key = keys[i];
                BlockData@ block = cast<BlockData@>(blocks[key]);

                auto intersectionIdx = GetFirstRouteIntersectionIdx(block);
                auto entry = ArrivalCalculator::CurrentArrivals.entries[intersectionIdx];
                block.playerArrivalTime = entry.timeSinceStart;
                block.playerArrivalPosition = entry.position;
                block.hasArrivalData = true;
                block.playerArrivalIndex = intersectionIdx;
            }
        }

        uint GetFirstRouteIntersectionIdx(BlockData@ blockData){
            auto aaBB = GetAABB(blockData.anchoredObject);
            float minOutsideDistance = 10000000;
            float lastDistance = 0;
            uint currentNearestIndex = 0;
            for(uint i=0;i< ArrivalCalculator::CurrentArrivals.entries.Length; i++){
                auto entry = ArrivalCalculator::CurrentArrivals.entries[i];
                auto distance = GetDistance(blockData.anchoredObject, aaBB, entry.position);
                if(distance >= 0){
                    if(distance < minOutsideDistance){
                        minOutsideDistance = distance;
                        currentNearestIndex = i;
                    }
                    lastDistance = distance;
                }else{
                    // entering AABB at current index so return last entry idx;
                    return Math::Max(0, currentNearestIndex);
                }
            }
            // never entered boudning box so return nearest position
            return currentNearestIndex;
        }

        float GetDistance(CGameCtnAnchoredObject@ obj, AABB@ aaBB, vec3 position){
            vec3 objPos = obj.AbsolutePositionInMap;
            vec3 localPoint = position - (objPos + aaBB.center);
            vec3 halfExtents = aaBB.size * 0.5;

            vec3 clamped = MathUtils::Max(MathUtils::Neg(halfExtents), MathUtils::Min(localPoint, halfExtents));
            vec3 delta = localPoint - clamped;
            float outsideDistance = MathUtils::Magnitude(delta);
            bool isInside = (localPoint.x >= -halfExtents.x && localPoint.x <= halfExtents.x &&
                    localPoint.y >= -halfExtents.y && localPoint.y <= halfExtents.y &&
                    localPoint.z >= -halfExtents.z && localPoint.z <= halfExtents.z);
            return isInside ? -outsideDistance : outsideDistance;
        }
    }


    void DrawGenerationUI(){
        UI::Text("Generation");
        UI::BeginTabBar("Generation Tabs");
        if(UI::BeginTabItem("Actions")){
            if(UI::Button("Generate Arrivals")){
                ArrivalGeneration::GeneratePlayerArrivals();
            }
            UI::SetTooltip("Generate arrival times for each block using the current recorded arrival.");
            UI::EndTabItem();
        }
        
        if(UI::BeginTabItem("Settings")){
            ArrivalGeneration::arrivalTimeOffset = UI::InputInt("Arrival Offset", ArrivalGeneration::arrivalTimeOffset);
            UI::SetTooltip("Distance for when the player is recognized as 'arrived' at an item. Millis.");



            UI::EndTabItem();
        }
        UI::EndTabBar();
    }

    void CopyGenerationSettings(BlockData@ source, BlockData@ target){
        @target.fullAnimationData = BlockAnimationData(source.fullAnimationData);
    }

    void BlockDataSettingsUI(){
        if(!Selection::IsItemPicked){
            return;
        }
        auto selectedItem = Selection::PickedObject;
        auto selectedModel = Selection::PickedItemModel;
        if(!IsMarked(selectedItem)){
            UI::Text("Item is not marked.");
            return;
        }
        auto id = GetId(selectedItem);
        BlockData@ blockData = cast<BlockData@>(blocks[GetStringId(id)]);
        ExtraUI::AnimationOrderSelectionDropdown(blockData.fullAnimationData);
        if(UI::CollapsingHeader("Translation Generation Settings"))
        {
            if(UI::Button("Copy from Rotation")){
                @blockData.fullAnimationData.translationData = AnimationData(blockData.fullAnimationData.rotationData);
            }
            UI::SetTooltip("Copy the rotation settings into the translation settings.");
            ExtraUI::AnimationDataInput(blockData.fullAnimationData.translationData);
        }
        if(UI::CollapsingHeader("Rotation Generation Settings"))
        {
            if(UI::Button("Copy from Translation")){
                @blockData.fullAnimationData.rotationData = AnimationData(blockData.fullAnimationData.translationData);
            }
            UI::SetTooltip("Copy the translation settings into the rotation settings.");
            ExtraUI::AnimationDataInput(blockData.fullAnimationData.rotationData);
        }
        UI::Separator();


        if(UI::Button("Copy")){
            @blockAnimationDataCopy = BlockAnimationData(blockData.fullAnimationData);
        }
        UI::SetTooltip("Copy the translation, rotation and AABB settings.");

        UI::SameLine();
        UI::BeginDisabled(blockAnimationDataCopy is null);
        if(UI::Button("Paste")){
            @blockData.fullAnimationData = BlockAnimationData(blockAnimationDataCopy);
        }
        UI::SetTooltip("Copy the translation, rotation and AABB settings.");
        UI::EndDisabled();

        UI::SameLine();
        if(UI::Button("Copy to instances")){
            auto keys = blocks.GetKeys();
            for(uint i=0;i < keys.Length; i++){
                auto targetBlockData = cast<BlockData@>(blocks[keys[i]]);
                if(selectedModel.IdName == targetBlockData.anchoredObject.ItemModel.IdName){
                    CopyGenerationSettings(blockData, targetBlockData);
                }
            }
        }
        UI::SetTooltip("Copy the translation, rotation and AABB settings to all items with the same item model.");
        UI::SameLine();
        if(UI::Button("Copy to all")){
            auto keys = blocks.GetKeys();
            for(uint i=0;i < keys.Length; i++){
                auto targetBlockData = cast<BlockData@>(blocks[keys[i]]);
                CopyGenerationSettings(blockData, targetBlockData);
            }
        }
        UI::SetTooltip("Copy the translation, rotation and AABB settings to all other items.");
        
      
    }


    void ArrivalEditingUI(){
        if(!Selection::IsItemPicked){
            return;
        }
        auto selectedItem = Selection::PickedObject;
        auto selectedModel = Selection::PickedItemModel;
        if(!IsMarked(selectedItem)){
            return;
        }
        auto id = GetId(selectedItem);
        BlockData@ blockData = cast<BlockData@>(blocks[GetStringId(id)]);
        if(blockData is null){return;}
        if(!blockData.hasArrivalData){
            return;
        }

        blockData.playerArrivalTime = UI::InputInt("Arrival Time", blockData.playerArrivalTime, 0);
        blockData.playerArrivalPosition = UI::InputFloat3("Arrival Position", blockData.playerArrivalPosition);
        int newIndex = UI::InputInt("Arrival Index", blockData.playerArrivalIndex, 1);
        if(newIndex != blockData.playerArrivalIndex){
            if(ArrivalCalculator::CurrentArrivals is null){
                blockData.playerArrivalIndex = newIndex;
            }else{
                blockData.playerArrivalIndex = Math::Clamp(newIndex, 0, ArrivalCalculator::CurrentArrivals.entries.Length -1);
                auto routeEntry = ArrivalCalculator::CurrentArrivals.entries[blockData.playerArrivalIndex];
                blockData.playerArrivalTime = routeEntry.timeSinceStart;
                blockData.playerArrivalPosition = routeEntry.position;
            }
        }


    }

}
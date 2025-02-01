namespace ExtraUI
{
    int NumberInputWidth = 130;
    int OperatorInputWidth = 45;
    int OperantTypeInputWidth = 110;
    int AxisInputWidth = 45;
    int EasingInputWidth = 150;
    int VarInputWidth = 100;

    

    bool OperatorDropDown(Generation::OperatorContainer@ container){
        UI::PushID(container);
        UI::SetNextItemWidth(OperatorInputWidth);
        bool changed = false;
        if(UI::BeginCombo(" ",GetOperatorName(container.Operator))){
            if(UI::Selectable("+", container.Operator == Generation::MathOperator::Plus)){
                changed = container.Operator != Generation::MathOperator::Plus;
                container.Operator = Generation::MathOperator::Plus;
            }
            if(UI::Selectable("-", container.Operator == Generation::MathOperator::Minus)){
                changed = container.Operator != Generation::MathOperator::Minus;
                container.Operator = Generation::MathOperator::Minus;
            }
            if(UI::Selectable("*", container.Operator == Generation::MathOperator::Multiply)){
                changed = container.Operator != Generation::MathOperator::Multiply;
                container.Operator = Generation::MathOperator::Multiply;
            }
            if(UI::Selectable("/", container.Operator == Generation::MathOperator::Divide)){
                changed = container.Operator != Generation::MathOperator::Divide;
                container.Operator = Generation::MathOperator::Divide;
            }
            UI::EndCombo();
        }
        UI::PopID();
        return changed;
    }
    bool OperantTypeDropDown(Generation::OperantTypeContainer@ container){
        UI::PushID(container);
        UI::SetNextItemWidth(OperantTypeInputWidth);
        bool changed = false;
        if(UI::BeginCombo(" ",GetOperantTypeName(container.OperantType))){
            if(UI::Selectable("Fixed", container.OperantType == Generation::OperantType::Fixed)){
                changed = container.OperantType != Generation::OperantType::Fixed;
                container.OperantType = Generation::OperantType::Fixed;
            }
            if(UI::Selectable("Random", container.OperantType == Generation::OperantType::Random)){
                changed = container.OperantType != Generation::OperantType::Random;
                container.OperantType = Generation::OperantType::Random;
            }
            if(UI::Selectable("Arrival", container.OperantType == Generation::OperantType::ArrivalTime)){
                changed = container.OperantType != Generation::OperantType::ArrivalTime;
                container.OperantType = Generation::OperantType::ArrivalTime;
            }
            if(UI::Selectable("Var", container.OperantType == Generation::OperantType::Var)){
                changed = container.OperantType != Generation::OperantType::Var;
                container.OperantType = Generation::OperantType::Var;
            }
            if(UI::Selectable("Value From", container.OperantType == Generation::OperantType::ValueFrom)){
                changed = container.OperantType != Generation::OperantType::ValueFrom;
                container.OperantType = Generation::OperantType::ValueFrom;
            }
            UI::EndCombo();
        }
        UI::PopID();
        return changed;
    }
    bool AxisTypeDropDown(Generation::AxisTypeContainer@ container){
        UI::PushID(container);
        UI::SetNextItemWidth(OperantTypeInputWidth);
        bool changed = false;
        if(UI::BeginCombo(" ",GetAxisTypeName(container.Type))){
            if(UI::Selectable("Fixed", container.Type == Generation::AxisValueType::Fixed)){
                changed = container.Type != Generation::AxisValueType::Fixed;
                container.Type = Generation::AxisValueType::Fixed;
            }
            if(UI::Selectable("Random", container.Type == Generation::OperantType::Random)){
                changed = container.Type != Generation::AxisValueType::Random;
                container.Type = Generation::AxisValueType::Random;
            }
            if(UI::Selectable("Var", container.Type == Generation::OperantType::Var)){
                changed = container.Type != Generation::AxisValueType::Var;
                container.Type = Generation::AxisValueType::Var;
            }
            UI::EndCombo();
        }
        UI::PopID();
        return changed;
    }
    bool EasingTypeDropDown(Generation::EasinValueTypeContainer@ container){
        UI::PushID(container);
        UI::SetNextItemWidth(OperantTypeInputWidth);
        bool changed = false;
        if(UI::BeginCombo(" ",GetEasingValueTypeName(container.Value))){
            if(UI::Selectable("Fixed", container.Value == Generation::EasingValueType::Fixed)){
                changed = container.Value != Generation::EasingValueType::Fixed;
                container.Value = Generation::EasingValueType::Fixed;
            }
            if(UI::Selectable("Random", container.Value == Generation::EasingValueType::Random)){
                changed = container.Value != Generation::EasingValueType::Random;
                container.Value = Generation::EasingValueType::Random;
            }
            if(UI::Selectable("Var", container.Value == Generation::EasingValueType::Var)){
                changed = container.Value != Generation::EasingValueType::Var;
                container.Value = Generation::EasingValueType::Var;
            }
            UI::EndCombo();
        }
        UI::PopID();
        return changed;
    }
    string GetAxisTypeName(Generation::AxisValueType axisType){
         switch(axisType){
            case Generation::AxisValueType::Fixed:
                return "Fixed";
            case Generation::AxisValueType::Random:
                return "Random";
            case Generation::AxisValueType::Var:
                return "Var";
        }
        return "o";
    }
     string GetEasingValueTypeName(Generation::EasingValueType easingValueType){
         switch(easingValueType){
            case Generation::EasingValueType::Fixed:
                return "Fixed";
            case Generation::EasingValueType::Random:
                return "Random";
            case Generation::EasingValueType::Var:
                return "Var";
        }
        return "o";
    }
    string GetOperatorName(Generation::MathOperator operator){
        switch(operator){
            case Generation::MathOperator::Plus:
                return "+";
            case Generation::MathOperator::Minus:
                return "-";
            case Generation::MathOperator::Multiply:
                return "*";
            case Generation::MathOperator::Divide:
                return "/";
        }
        return "o";
    }
    string GetAxisName(Generation::MathAxis axis){
        switch(axis){
            case Generation::MathAxis::X:
                return "X";
            case Generation::MathAxis::Y:
                return "Y";
            case Generation::MathAxis::Z:
                return "Z";
        }
        return "o";
    }
    string GetEasingName(Generation::EasingType easing){
         switch(easing){
            case Generation::EasingType::None:
                return "Constant";
            case Generation::EasingType::Linear:
                return "Linear";
            case Generation::EasingType::QuadIn:
                return "QuadIn";
            case Generation::EasingType::QuadOut:
                return "QuadOut";
            case Generation::EasingType::QuadInOut:
                return "QuadInOut";
            case Generation::EasingType::CubicIn:
                return "CubicIn";
            case Generation::EasingType::CubicOut:
                return "CubicOut";
            case Generation::EasingType::CubicInOut:
                return "CubicInOut";
        }
        return "o";
    }
    string GetValueFromName(Generation::AnimationOptions animOptions){
        switch(animOptions){
            case Generation::AnimationOptions::Wait_1:
                return "Wait 1";
            case Generation::AnimationOptions::Wait_2:
                return "Wait 2";
            case Generation::AnimationOptions::FlyIn:
                return "Fly In";
            case Generation::AnimationOptions::FlyOut:
                return "Fly Out";
        }
        return "o";
    }
    string GetOperantTypeName(Generation::OperantType operantType){
         switch(operantType){
            case Generation::OperantType::Fixed:
                return "Fixed";
            case Generation::OperantType::Random:
                return "Random";
            case Generation::OperantType::ArrivalTime:
                return "Arrival";
            case Generation::OperantType::Var:
                return "Var";
            case Generation::OperantType::ValueFrom:
                return "Value From";
        }
        return "o";
    }
    string GetMinLabel(){
        return string("Min");
    }
    void RandomIntInput(Generation::RandomInt@ currentRandomInt, int step = 1){
        UI::SetNextItemWidth(NumberInputWidth);
        UI::PushID(currentRandomInt);
        currentRandomInt.Min = UI::InputInt("Min", currentRandomInt.Min);
        UI::SameLine();
        UI::SetNextItemWidth(NumberInputWidth);
        currentRandomInt.Max = UI::InputInt(string("Max"), currentRandomInt.Max);  
        UI::PopID(); 
    }
    void RandomFloatInput(Generation::RandomFloat@ currentRandomFloat, float step = 1.0){
        UI::PushID(currentRandomFloat);
        UI::SetNextItemWidth(NumberInputWidth);
        currentRandomFloat.Min = UI::InputFloat("Min", currentRandomFloat.Min, step);
        UI::SameLine();
        UI::SetNextItemWidth(NumberInputWidth);
        currentRandomFloat.Max = UI::InputFloat(string("Max"), currentRandomFloat.Max, step);
        UI::PopID(); 
    }
    void FixedAxisInput(Generation::FixedAxis@ axisContainer){
        UI::PushID(axisContainer);
        UI::SetNextItemWidth(AxisInputWidth);
        if(UI::BeginCombo("Axis",GetAxisName(axisContainer.Axis))){
            if(UI::Selectable("X", axisContainer.Axis == Generation::MathAxis::X)){
                axisContainer.Axis = Generation::MathAxis::X;
            }
            if(UI::Selectable("Y", axisContainer.Axis == Generation::MathAxis::Y)){
                axisContainer.Axis = Generation::MathAxis::Y;
            }
            if(UI::Selectable("Z", axisContainer.Axis == Generation::MathAxis::Z)){
                axisContainer.Axis = Generation::MathAxis::Z;
            }
            UI::EndCombo();
        }
        UI::PopID();
    }
    void VarAxisInput(Generation::VarAxis@ axisContainer){
        UI::PushID(axisContainer);
        UI::SetNextItemWidth(VarInputWidth);
        axisContainer.Var = UI::InputText(" ", axisContainer.Var);
        UI::PopID();
    }
    void FixedEasingInput(Generation::FixedEasing@ fixedEasing){
        UI::PushID(fixedEasing);
        UI::SetNextItemWidth(EasingInputWidth);
        if(UI::BeginCombo("Easing", GetEasingName(fixedEasing.Value))){
            if(UI::Selectable("Constant", fixedEasing.Value == Generation::EasingType::None)){
                fixedEasing.Value = Generation::EasingType::None;
            }
            if(UI::Selectable("Linear", fixedEasing.Value == Generation::EasingType::Linear)){
                fixedEasing.Value = Generation::EasingType::Linear;
            }
            if(UI::Selectable("QuadIn", fixedEasing.Value == Generation::EasingType::QuadIn)){
                fixedEasing.Value = Generation::EasingType::QuadIn;
            }
            if(UI::Selectable("QuadOut", fixedEasing.Value == Generation::EasingType::QuadOut)){
                fixedEasing.Value = Generation::EasingType::QuadOut;
            }
            if(UI::Selectable("QuadInOut", fixedEasing.Value == Generation::EasingType::QuadInOut)){
                fixedEasing.Value = Generation::EasingType::QuadInOut;
            }


            UI::EndCombo();
        }
        UI::PopID(); 
    }
    void VarEasingInput(Generation::VarEasing@ easingContainer){
        UI::PushID(easingContainer);
        UI::SetNextItemWidth(VarInputWidth);
        easingContainer.Var = UI::InputText(" ", easingContainer.Var);
        UI::PopID();
    }
    void RandomAxisInput(Generation::RandomAxis@ currentRandomAxis){
        UI::PushID(currentRandomAxis);
        currentRandomAxis.RandomX = UI::Checkbox("X",currentRandomAxis.RandomX);
        UI::SameLine();
        currentRandomAxis.RandomY = UI::Checkbox("Y",currentRandomAxis.RandomY);
        UI::SameLine();
        currentRandomAxis.RandomZ = UI::Checkbox("Z",currentRandomAxis.RandomZ);
        UI::SameLine();
        currentRandomAxis.AvoidArrivalDirection = UI::Checkbox("Avoid Arrival Dir",currentRandomAxis.AvoidArrivalDirection);
        UI::PopID(); 
    }
    void RandomEasingInput(Generation::RandomEasing@ currentRandomEasing){
        UI::PushID(currentRandomEasing);
        currentRandomEasing.RandomNone = UI::Checkbox("None",currentRandomEasing.RandomNone);
        UI::SameLine();
        currentRandomEasing.RandomLinear = UI::Checkbox("Linear",currentRandomEasing.RandomLinear);
        UI::SameLine();
        currentRandomEasing.RandomQuadIn = UI::Checkbox("QuadIn",currentRandomEasing.RandomQuadIn);
        UI::SameLine();
        currentRandomEasing.RandomQuadOut = UI::Checkbox("QuadOut",currentRandomEasing.RandomQuadOut);
        UI::SameLine();
        currentRandomEasing.RandomQuadInOut = UI::Checkbox("QuadInOut",currentRandomEasing.RandomQuadInOut);
        // UI::SameLine();
        // currentRandomEasing.RandomCubicIn = UI::Checkbox("CubicIn",currentRandomEasing.RandomCubicIn);
        // UI::SameLine();
        // currentRandomEasing.RandomCubicOut = UI::Checkbox("CubicOut",currentRandomEasing.RandomCubicOut);
        // UI::SameLine();
        // currentRandomEasing.RandomCubicInOut = UI::Checkbox("CubicInOut",currentRandomEasing.RandomCubicInOut);
        UI::PopID(); 
    }
    void FixedIntInput(Generation::FixedInt@ fixedInt, int step = 1){
        UI::PushID(fixedInt);
        UI::SetNextItemWidth(NumberInputWidth);
        fixedInt.Value = UI::InputInt(" ",fixedInt.Value, step);
        UI::PopID();
    }
    void FixedFloatInput(Generation::FixedFloat@ fixedFloat, float step = 1){
        UI::PushID(fixedFloat);
        UI::SetNextItemWidth(NumberInputWidth);
        fixedFloat.Value = UI::InputFloat(" ",fixedFloat.Value, step);
        UI::PopID();
    }
    void VarIntInput(Generation::VarInt@ varInt){
        UI::PushID(varInt);
        UI::SetNextItemWidth(VarInputWidth);
        varInt.Var = UI::InputText(" ",varInt.Var);
        UI::PopID();
    }
    void VarFloatInput(Generation::VarFloat@ varFloat){
        UI::PushID(varFloat);
        UI::SetNextItemWidth(VarInputWidth);
        varFloat.Var = UI::InputText(" ",varFloat.Var);
        UI::PopID();
    }
    void ArrivalTimeInput(Generation::ArrivalTime@ arrivalTime){
        UI::Text("[Arrival Time]");
    }
    void ArrivalTimeFloatInput(Generation::ArrivalTimeFloat@ arrivalTime){
        UI::Text("[Arrival Time]");
    }

    void ValueFromInput(Generation::ValueFromInt valueFrom){
        UI::PushID(valueFrom);
        UI::SetNextItemWidth(VarInputWidth);
        if(UI::BeginCombo("Value From", GetValueFromName(valueFrom.Option))){
            if(UI::Selectable("Wait 1", valueFrom.Option == Generation::AnimationOptions::Wait_1)){
                valueFrom.Option = Generation::AnimationOptions::Wait_1;
            }
            if(UI::Selectable("Wait 2", valueFrom.Option == Generation::AnimationOptions::Wait_2)){
                valueFrom.Option = Generation::AnimationOptions::Wait_2;
            }
            if(UI::Selectable("Fly In", valueFrom.Option == Generation::AnimationOptions::FlyIn)){
                valueFrom.Option = Generation::AnimationOptions::FlyIn;
            }
            if(UI::Selectable("Fly Out", valueFrom.Option == Generation::AnimationOptions::FlyOut)){
                valueFrom.Option = Generation::AnimationOptions::FlyOut;
            }
            UI::EndCombo();
        }
        UI::PopID();
    }


    void FormulaIntInput(Generation::FormulaInt@ formula, int step = 1){
        UI::PushID(formula);
        if(OperantTypeDropDown(formula.type1)){
            @formula.operant1 = Generation::GetOperantFromType(formula.type1.OperantType);
        }
        UI::SameLine();
        switch(formula.type1.OperantType){
            case Generation::OperantType::Fixed:
                FixedIntInput(cast<Generation::FixedInt>(formula.operant1), step);
                break;
            case Generation::OperantType::ArrivalTime:
                ArrivalTimeInput(cast<Generation::ArrivalTime>(formula.operant1));
                break;
            case Generation::OperantType::Random:
                RandomIntInput(cast<Generation::RandomInt>(formula.operant1));
                break;    
            case Generation::OperantType::Var:
                VarIntInput(cast<Generation::VarInt>(formula.operant1));
                break;
            case Generation::OperantType::ValueFrom:
                ValueFromInput(cast<Generation::ValueFromInt>(formula.operant1));
                break;
        }
        UI::SameLine();
        OperatorDropDown(formula.Operator);
        UI::SameLine();
        if(OperantTypeDropDown(formula.type2)){
            @formula.operant2 = Generation::GetOperantFromType(formula.type2.OperantType);
        }
        UI::SameLine();
        switch(formula.type2.OperantType){
            case Generation::OperantType::Fixed:
                FixedIntInput(cast<Generation::FixedInt>(formula.operant2), step);
                break;
            case Generation::OperantType::ArrivalTime:
                ArrivalTimeInput(cast<Generation::ArrivalTime>(formula.operant2));
                break;
            case Generation::OperantType::Random:
                RandomIntInput(cast<Generation::RandomInt>(formula.operant2));
                break;    
            case Generation::OperantType::Var:
                VarIntInput(cast<Generation::VarInt>(formula.operant2));
                break;
            case Generation::OperantType::ValueFrom:
                ValueFromInput(cast<Generation::ValueFromInt>(formula.operant2));
                break;
        }
        UI::PopID();
    }
    void FormulaFloatInput(Generation::FormulaFloat@ formula, int step = 1){
        UI::PushID(formula);
        if(OperantTypeDropDown(formula.type1)){
            @formula.operant1 = Generation::GetOperantFloatFromType(formula.type1.OperantType);
        }
        UI::SameLine();
        switch(formula.type1.OperantType){
            case Generation::OperantType::Fixed:
                FixedFloatInput(cast<Generation::FixedFloat>(formula.operant1), step);
                break;
            case Generation::OperantType::ArrivalTime:
                ArrivalTimeFloatInput(cast<Generation::ArrivalTimeFloat>(formula.operant1));
                break;
            case Generation::OperantType::Random:
                RandomFloatInput(cast<Generation::RandomFloat>(formula.operant1));
                break;  
            case Generation::OperantType::Var:
                VarFloatInput(cast<Generation::VarFloat>(formula.operant1));
                break;  
        }
        UI::SameLine();
        OperatorDropDown(formula.Operator);
        UI::SameLine();
        if(OperantTypeDropDown(formula.type2)){
            @formula.operant2 = Generation::GetOperantFloatFromType(formula.type2.OperantType);
        }
        UI::SameLine();
        switch(formula.type2.OperantType){
            case Generation::OperantType::Fixed:
                FixedFloatInput(cast<Generation::FixedFloat>(formula.operant2), step);
                break;
            case Generation::OperantType::ArrivalTime:
                ArrivalTimeFloatInput(cast<Generation::ArrivalTimeFloat>(formula.operant2));
                break;
            case Generation::OperantType::Random:
                RandomFloatInput(cast<Generation::RandomFloat>(formula.operant2));
                break;  
            case Generation::OperantType::Var:
                VarFloatInput(cast<Generation::VarFloat>(formula.operant2));
                break;   
        }
        UI::PopID();
    }
    void FormulaAxisInput(Generation::FormulaAxis@ axisFormula){
        UI::PushID(axisFormula);
        if(AxisTypeDropDown(axisFormula.Type)){
            @axisFormula.AxisValue = Generation::GetAxisValueFromType(axisFormula.Type.Type);
        }
        UI::SameLine();
        switch(axisFormula.Type.Type){
            case Generation::AxisValueType::Fixed:
                FixedAxisInput(cast<Generation::FixedAxis>(axisFormula.AxisValue));
                break;
            case Generation::AxisValueType::Random:
                RandomAxisInput(cast<Generation::RandomAxis>(axisFormula.AxisValue));
                break;
            case Generation::AxisValueType::Var:
                VarAxisInput(cast<Generation::VarAxis>(axisFormula.AxisValue));
                break;
        }
        UI::PopID();
    }
    void FormulaEasingInput(Generation::FormulaEasing@ easingFormula){
        UI::PushID(easingFormula);
        if(EasingTypeDropDown(easingFormula.Type)){
            @easingFormula.EasingValue = Generation::GetEasingValueFromType(easingFormula.Type.Value);
        }
        UI::SameLine();
        switch(easingFormula.Type.Value){
            case Generation::EasingValueType::Fixed:
                FixedEasingInput(cast<Generation::FixedEasing>(easingFormula.EasingValue));
                break;
            case Generation::EasingValueType::Random:
                RandomEasingInput(cast<Generation::RandomEasing>(easingFormula.EasingValue));
                break;
            case Generation::EasingValueType::Var:
                VarEasingInput(cast<Generation::VarEasing>(easingFormula.EasingValue));
                break;
        }
        UI::PopID();
    }

    void VarCreationUI(){
        UI::PushID("varCreation");
        if(UI::CollapsingHeader("Variables")){
            for(uint i=0;i<Generation::intVars.Length; i++){
                auto decl = Generation::intVars[i];
                UI::PushID(decl);
                UI::SetNextItemWidth(NumberInputWidth);
                decl.id = UI::InputText(" ", decl.id);
                UI::SameLine();
                FormulaIntInput(decl.formula);
                UI::PopID();
            }
            for(uint i=0;i<Generation::floatVars.Length; i++){
                auto decl = Generation::floatVars[i];
                UI::PushID(decl);
                UI::SetNextItemWidth(NumberInputWidth);
                decl.id = UI::InputText(" ", decl.id);
                UI::SameLine();
                FormulaFloatInput(decl.formula);
                UI::PopID();
            }
            for(uint i=0;i<Generation::axisVars.Length; i++){
                auto decl = Generation::axisVars[i];
                UI::PushID(decl);
                UI::SetNextItemWidth(NumberInputWidth);
                decl.id = UI::InputText(" ", decl.id);
                UI::SameLine();
                FormulaAxisInput(decl.formula);
                UI::PopID();
            }
            for(uint i=0;i<Generation::easingVars.Length; i++){
                auto decl = Generation::easingVars[i];
                UI::PushID(decl);
                UI::SetNextItemWidth(NumberInputWidth);
                decl.id = UI::InputText(" ", decl.id);
                UI::SameLine();
                FormulaEasingInput(decl.formula);
                UI::PopID();
            }
            if(UI::Button("Add Integer Var")){
                Generation::intVars.InsertLast(Generation::VarIntDeclaration("i" + Generation::intVars.Length));
            }
            UI::SameLine();
            if(UI::Button("Add Float Var")){
                Generation::floatVars.InsertLast(Generation::VarFloatDeclaration("f" + Generation::floatVars.Length));
            }
            UI::SameLine();
            if(UI::Button("Add Axis Var")){
                Generation::axisVars.InsertLast(Generation::VarAxisDeclaration("a" + Generation::axisVars.Length));
            }
            UI::SameLine();
            if(UI::Button("Add Easing Var")){
                Generation::easingVars.InsertLast(Generation::VarEasingDeclaration("e" + Generation::easingVars.Length));
            }
            UI::SameLine();
            UI::Text("*Random in Variables stays constant across uses.");
        }
        UI::PopID();
    }
    void AnimationDataInput(Generation::AnimationData@ animData){
        UI::PushID(animData);

        UI::Text("Max Formula");
        UI::Indent();
        FormulaFloatInput(animData.MaxFormula);
        UI::Unindent();

        UI::Text("Axis Formula");
        UI::Indent();
        FormulaAxisInput(animData.AxisFormula);
        UI::Unindent();


        UI::Text("Wait 1 Duration Formula");
        UI::Indent();
        FormulaIntInput(animData.Wait1DurationFormula);
        UI::Unindent();

        UI::Text("Wait 1 Easing Formula");
        UI::Indent();
        FormulaEasingInput(animData.Wait1EasingFormula);
        UI::Unindent();


        UI::Text("FlyIn Duration Formula");
        UI::Indent();
        FormulaIntInput(animData.FlyInDurationFormula);
        UI::Unindent();

        UI::Text("FlyIn Easing Formula");
        UI::Indent();
        FormulaEasingInput(animData.FlyInEasingFormula);
        UI::Unindent();

        UI::Text("Wait 2 Duration Formula");
        UI::Indent();
        FormulaIntInput(animData.Wait2DurationFormula);
        UI::Unindent();

        UI::Text("Wait 2 Easing Formula");
        UI::Indent();
        FormulaEasingInput(animData.Wait2EasingFormula);
        UI::Unindent();

        UI::Text("FlyOut Duration Formula");
        UI::Indent();
        FormulaIntInput(animData.FlyOutDurationFormula);
        UI::Unindent();

        UI::Text("FlyOut Easing Formula");
        UI::Indent();
        FormulaEasingInput(animData.FlyOutEasingFormula);
        UI::Unindent();

        UI::PopID();
    }

    string GetAnimationorderName(Generation::AnimationOrder animOrder){
        switch(animOrder){
            case Generation::AnimationOrder::Wait_FlyIn_Wait_FlyOut:
                return "Wait_FlyIn_Wait_FlyOut";
            case Generation::AnimationOrder::Wait_FlyOut_Wait_FlyIn:
                return "Wait_FlyOut_Wait_FlyIn";
        }
        return "Wait_FlyIn_Wait_FlyOut";
    }
    void AnimationOrderSelectionDropdown(Generation::BlockAnimationData@ animData){
        UI::PushID(animData);
        UI::SetNextItemWidth(250);
        if(UI::BeginCombo("Animation Order", GetAnimationorderName(animData.animationOrder))){
            if(UI::Selectable("Wait -> FlyIn -> Wait -> FlyOut", animData.animationOrder == Generation::AnimationOrder::Wait_FlyIn_Wait_FlyOut)){
                animData.animationOrder = Generation::AnimationOrder::Wait_FlyIn_Wait_FlyOut;
            }
            if(UI::Selectable("Wait -> FlyOut -> Wait -> FlyInt", animData.animationOrder == Generation::AnimationOrder::Wait_FlyOut_Wait_FlyIn)){
                animData.animationOrder = Generation::AnimationOrder::Wait_FlyOut_Wait_FlyIn;
            }
            UI::EndCombo();
        }
        UI::PopID();
    }

    void GroupingUI(){
        if(UI::CollapsingHeader("Grouping")){
            GroupCreationInput();
            for(uint i=0;i < Generation::groupNames.Length; i++){
                UI::Text(Generation::groupNames[i]);
            }
        }
    }
    string currentGroupInput;
    void GroupCreationInput(){
        currentGroupInput = UI::InputText("Group Name",currentGroupInput);
        UI::BeginDisabled(currentGroupInput == "" || Generation::groupNames.Find(currentGroupInput) >= 0);
        UI::SameLine();
        if(UI::Button("+")){
            Generation::groupNames.InsertLast(currentGroupInput);
        }
        UI::SetTooltip("Creates a new group.");
        UI::EndDisabled();
    }
    void GroupDropDown(Generation::BlockData@ blockData){
        UI::PushID(blockData);
        UI::SetNextItemWidth(250);
        if(UI::BeginCombo("Group", blockData.group)){
            if(UI::Selectable("<NONE>", blockData.group == "")){
                blockData.group = "";
            }
            for(uint i=0;i < Generation::groupNames.Length; i++){
                if(UI::Selectable(Generation::groupNames[i], blockData.group == Generation::groupNames[i])){
                    blockData.group = Generation::groupNames[i];
                }
            }
            UI::EndCombo();
        }
        UI::PopID();
    }

    void LocalAnimationDropDown(Generation::BlockAnimationData@ animData){
        UI::PushID(animData);
        animData.localAnimation = UI::Checkbox("Local Space", animData.localAnimation);
        UI::SetItemTooltip("Generate animation data in local space.");
        UI::PopID();
    }




}
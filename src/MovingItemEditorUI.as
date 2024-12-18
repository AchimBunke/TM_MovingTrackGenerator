namespace MovingItemEditorUI 
{
    const string MenuTitle = "Moving Track Configurator";
    const string WindowTitle = "Moving Track Configurator";

    bool IsWindowOpen = false;

    // Menu Item under 'Plugins'
    void RenderMenu(){
        if(UI::MenuItem(MenuTitle, "",IsWindowOpen)){
            IsWindowOpen = !IsWindowOpen;
        }
    }

    // Menu Window
    void Show(){
        if(!IsWindowOpen){return;}

        vec2 size = vec2(300,500);
        vec2 pos = (vec2(Draw::GetWidth(), Draw::GetHeight()) - size) / 2.;
        UI::SetNextWindowSize(int(size.x), int(size.y), UI::Cond::FirstUseEver);
        UI::SetNextWindowPos(int(pos.x), int(pos.y), UI::Cond::FirstUseEver);
        if(UI::Begin(WindowTitle, IsWindowOpen)){
            UI::BeginTabBar("tabBar");
            if(UI::BeginTabItem("Selection")){
                SelectedItemUI::Draw();
                UI::Separator();
                Generation::ArrivalEditingUI();
                UI::Separator();
                ExtraUI::VarCreationUI();
                UI::Separator();
                Generation::BlockDataSettingsUI();
                UI::EndTabItem();
            }
            if(UI::BeginTabItem("Generation")){
                Generation::DrawGenerationUI();
                UI::Separator();
                Client::ShowUI();
                UI::EndTabItem();
            }
            if(UI::BeginTabItem("Arrival Calculator")){
                ArrivalCalculator::ShowUI();
                UI::EndTabItem();
            }
            if(UI::BeginTabItem("Save / Load")){
                SerializationUI::Draw();
                UI::EndTabItem();
            }
            UI::EndTabBar();
            UI::Separator();
            Debug::DebugUI();
        }
        UI::End();
    }
}
namespace Debug
{
    void PrintSelectedAnchoredItemId(){
        if(!Selection::IsItemPicked){
            return;
        }
        auto selectedItem = Selection::PickedObject;
        int id = Generation::GetId(selectedItem);
        print(id);
    }

    void DebugGeneration(){
        Generation::ArrivalGeneration::GeneratePlayerArrivals();
    }

    class obj{
        string val="";
    }



    void DebugUI(){
        // if(UI::Button("Start Client")){
        //     Client::StartConnecting();
        // }
        // if(UI::Button("Send")){
        //     Client::Send("Test");
        //     JsonDebug();
        // }
    
    }
}
namespace SerializationUI
{
    const string ItemPathLabelText = "Item Generation Path: ";
    const string MapGenerationFilePathLabelText = "Map Output: ";
    const string OpenMapPathButtonText = "Open Map Directory..";
    const string OpenMetaDataPathButtonText = "Open MetaData Directory..";
    const string OpenItemsPathButtonText = "Open Items Dir..";
    const string SaveDataText = "Save Map Data";
    const string LoadDataText = "Load Map Data";

    void Draw(){
       // Serialization::SetMapGenerationFilePathRelative(
       //     UI::InputText(MapGenerationFilePathLabelText, Serialization::GetCurrentMapGenerationFilePathRelative()));
       
        //Serialization::SetItemGenerationPathRelative(UI::InputText(ItemPathLabelText, Serialization::GetCurrentItemGenerationPathRelative()));
        if(UI::Button(OpenMapPathButtonText)){
            OpenExplorerPath(Serialization::GetCurrentMapPathAbsolute());
        }
        UI::SameLine();
        if(UI::Button(OpenMetaDataPathButtonText)){
            OpenExplorerPath(Serialization::GetCurrentMetaDataFolderPathAbsolute());
        }
        // if(UI::Button(OpenItemsPathButtonText)){
        //     OpenExplorerPath(Serialization::GetOrCreateCurrentItemGenerationFolderAbsolute());
        // }
        if(UI::Button(SaveDataText)){
            Serialization::SerializeMapData();
        }
        if(UI::Button(LoadDataText)){
            Selection::ResetSelection();
            Serialization::LoadMapData();
        }
       
    }
}
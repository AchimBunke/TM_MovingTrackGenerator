namespace Selection
{
    const bool ResetSelectionForBlocks = true;

    bool IsItemPicked = false;
    CGameCtnAnchoredObject@ PickedObject = null;
    CGameItemModel@ PickedItemModel = null;

    void UpdateSelectedItem(){
        auto editor = MBEditor::GetEditor();
        
        if(!(editor.PickedObject is null)){
            IsItemPicked = true;
            @PickedObject = editor.PickedObject;
            @PickedItemModel = PickedObject.ItemModel;
        }
        // if(ResetSelectionForBlocks && !(editor.PickedBlock is null)){
        //     ResetSelection();
        // }
    }
    void ResetSelection(){
        @PickedObject = null;
        @PickedItemModel = null;
        IsItemPicked = false;
    }

}
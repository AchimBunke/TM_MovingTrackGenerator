namespace SelectedItemUI
{

    void Draw(){
        if(!Selection::IsItemPicked || Selection::PickedObject is null){
            UI::Text("No item selected");
            return;
        }
        int id = Generation::GetId(Selection::PickedObject);
        bool marked = id != -1;
        string modelIdName = Selection::PickedItemModel.IdName;
        UI::Text("Selected Item:  " + modelIdName);
        UI::Text(Selection::PickedObject.AbsolutePositionInMap.ToString());
        if(marked){
            auto aaBB = Generation::GetAABB(modelIdName);
            aaBB.center = UI::InputFloat3("AABB Center", aaBB.center);
            aaBB.size = UI::InputFloat3("AABB Size", aaBB.size);
            //Generation::SetAABB(Selection::PickedItemModel.IdName, currentSize);
        }

       
        if(UI::Checkbox("Mark (ctrl+m)", marked)){
            if(!marked){
                Generation::MarkObject(Selection::PickedObject);
                marked = true;
            }
        }else if(marked){
            Generation::UnMark(Selection::PickedObject);
        }
        UI::SameLine();
        UI::Text("ID: " + id);
        UI::SameLine();
        if(UI::Button("Mark All Instances")){
            Generation::MarkAllInstances(Selection::PickedObject);
        }
        UI::SetTooltip("Marks all items that use the same Item Model.");
        UI::SameLine();
        if(Generation::IsMarked(Selection::PickedObject)){
            auto blockData = cast<Generation::BlockData@>(Generation::blocks[Generation::GetStringId(Generation::GetId(Selection::PickedObject))]);
            if(!(blockData is null)){
            
                ExtraUI::GroupDropDown(blockData);
                UI::SameLine();
                if(UI::Button("Add All Selected")){
                    Generation::AddItemsToGroup(blockData.group, Selection::multiSelectedObjects);
                }
                UI::SetTooltip("Adds all selected items to the same group.");
            }
        }
        
       
        UI::Text("Multi Selection Items (ctrl+n): " + Selection::multiSelectedObjects.Length);
        UI::SameLine();
        UI::BeginDisabled(!Selection::hasMultiSelectedItems);
        if(UI::Button("Mark All Selected Items")){
            Generation::MarkMultiSelectedItems();
        }
        UI::SetTooltip("Marks all items selected with Multi Selection.");

        UI::EndDisabled();
        ExtraUI::GroupingUI();
    }
}
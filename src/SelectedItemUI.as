namespace SelectedItemUI
{
    void Draw(){
        if(!Selection::IsItemPicked){
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

       
        if(UI::Checkbox("Mark (m)", marked)){
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
        UI::SetTooltip("Marks all items with the same item model.");
    }
}
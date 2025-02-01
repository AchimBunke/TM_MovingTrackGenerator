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
        IsItemPicked = false;
        @PickedObject = null;
        @PickedItemModel = null;
    }


    array<CGameCtnAnchoredObject@> multiSelectedObjects;
    bool hasMultiSelectedItems = false;
    bool isMultiSelecting = false;
    vec2 multiSelectWindowStartPos;
    vec2 multiSelectWindowEndPos;

    void EndMultiSelection(){
        vec2 multiSelectWindowEndPos = UI::GetMousePos();



        isMultiSelecting = false;
        hasMultiSelectedItems = multiSelectedObjects.Length > 0;
    }
    void StartMultiSelection(){
        if(isMultiSelecting){
            return;
        }
        isMultiSelecting = true;
        multiSelectedObjects.Resize(0);
        multiSelectWindowStartPos = UI::GetMousePos();
    }
    vec4 multiSelectStrokeColor = vec4(1,0,0,1);
    
    int delay = 10;
    int c=100;
    void TickMultiSelect(){
        c++;
        if(!isMultiSelecting){
            return;
        }
        
        auto newEndPos = UI::GetMousePos();
        vec2 size = newEndPos - multiSelectWindowStartPos;
        nvg::BeginPath();
        nvg::StrokeColor(multiSelectStrokeColor);
        nvg::StrokeWidth(3);
        nvg::Rect(multiSelectWindowStartPos, size);
        nvg::Stroke();
        nvg::ClosePath();
        
        if(c >= delay){// dont update every frame because operation is costly!!
            c = 0; 
            if(multiSelectWindowEndPos != newEndPos){
             
                multiSelectWindowEndPos = newEndPos;
                auto challenge = MBEditor::GetChallenge();
                multiSelectedObjects.Resize(0);

                for(uint i=0;i < challenge.AnchoredObjects.Length; i++)
                {
                    auto obj = challenge.AnchoredObjects[i];
                    if(IsInsideMultiSelectionBox(multiSelectWindowStartPos, multiSelectWindowEndPos, obj)){
                        multiSelectedObjects.InsertLast(obj);
                    }
                }
            }
            
        }
        
    }
    bool IsInsideMultiSelectionBox(vec2 boxStart, vec2 boxEnd, CGameCtnAnchoredObject@ obj){
        auto pos = obj.AbsolutePositionInMap;
        if(Camera::IsBehind(pos)){
            return false;
        }
        vec2 screenPos = Camera::ToScreenSpace(pos);
        float minX = Math::Min(boxStart.x, boxEnd.x);
        float maxX = Math::Max(boxStart.x, boxEnd.x);
        float minY = Math::Min(boxStart.y, boxEnd.y);
        float maxY = Math::Max(boxStart.y, boxEnd.y);
        return (screenPos.x >= minX && screenPos.x <= maxX && screenPos.y >= minY && screenPos.y <= maxY);
    }

    void DrawMultiSelectedItemIndicators(){
        
        for(uint i=0 ; i< multiSelectedObjects.Length; i++){
            vec2 screenPos = Camera::ToScreenSpace(multiSelectedObjects[i].AbsolutePositionInMap);
            nvg::BeginPath();
            nvg::Circle(screenPos, 4);
            nvg::FillColor(vec4(0.5,0.2,0.6,1));
            nvg::Fill();
            nvg::ClosePath();
        }
    }

}
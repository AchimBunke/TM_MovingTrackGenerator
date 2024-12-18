namespace ArrivalVisualizer
{
    bool IsVisualizing = true;


    bool ShouldVisualize(){
        if(!IsVisualizing){
            return false;
        }
        if(MBEditor::IsPlaying()){
            return false;
        }
        if(!MovingItemEditorUI::IsWindowOpen){
            return false;
        }
        if(ArrivalCalculator::CurrentArrivals is null){
            return false;
        }
        return true;
    }

    void Visualize(){
        vec4 strokeColor = vec4(0,0,1,1);
        nvg::StrokeColor(strokeColor);
        nvg::BeginPath();
        bool start = true;
        for(uint i=0;i< ArrivalCalculator::CurrentArrivals.entries.Length; i++){
            auto entry = ArrivalCalculator::CurrentArrivals.entries[i];
            if(Camera::IsBehind(entry.position)){
                continue;
            }
            auto screenPos = Camera::ToScreenSpace(entry.position);
            if(start){
                nvg::MoveTo(screenPos);
                start = false;
            }else{
                nvg::LineTo(screenPos);
            }
        }
        nvg::ResetTransform();
        nvg::Stroke();
    }

}
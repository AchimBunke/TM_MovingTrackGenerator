void Main()
{
   print("Init Moving Track Configurator");
   CTrackMania@ app = cast<CTrackMania>(GetApp());

   while (true) {
      if(MBEditor::EditorIsNull()){
         // sleep while not in editor
         sleep(500);
         continue;
      }

      Selection::UpdateSelectedItem();
      Client::Tick();
      yield();
   }
}
void Render(){
   if(MBEditor::EditorIsNull())
   {
      return;
   }

   if(MovingItemEditorUI::IsWindowOpen && !MBEditor::IsPlaying()){
      Generation::DrawPositionIndicators();
      Generation::DrawInfosForSelectedItem();
      Generation::DrawArrivalTimes();
      KeyInputControl::Tick();
      Selection::TickMultiSelect();
      Selection::DrawMultiSelectedItemIndicators();
   }
   ArrivalCalculator::Tick();
   if(ArrivalCalculator::CanRecord() && ArrivalCalculator::IsTrackingArrivals){
      ArrivalCalculator::Record();
   }
   if(ArrivalVisualizer::ShouldVisualize()){
      ArrivalVisualizer::Visualize();
   }
}

void RenderInterface(){
   if(MBEditor::EditorIsNull())
   {
      return;
   }
   MovingItemEditorUI::Show();
}
void RenderMenu(){
   MovingItemEditorUI::RenderMenu();
}


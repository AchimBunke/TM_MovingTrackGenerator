namespace KeyInputControl
{
    bool isCtrlDown;

    UI::Key markKey = UI::Key::M;
    bool markKeyPressed;

    UI::Key multiSelectKey = UI::Key::N;
    bool multiSelectPressed;


    void Tick(){
        isCtrlDown = UI::IsKeyDown(UI::Key::LeftCtrl);

        if(UI::IsKeyPressed(markKey) && isCtrlDown  && !markKeyPressed){
            markKeyPressed = true;
            if(Selection::IsItemPicked){
                if(Generation::IsMarked(Selection::PickedObject)){
                    Generation::UnMark(Selection::PickedObject);
                }
                else{
                    Generation::MarkObject(Selection::PickedObject);
                }
            }
            //TODO
        }
        if(UI::IsKeyReleased(markKey)){
            markKeyPressed = false;
        }

        if(UI::IsKeyPressed(multiSelectKey) && isCtrlDown && !multiSelectPressed){
            Selection::StartMultiSelection();
        }
        if(UI::IsKeyReleased(multiSelectKey)){
            Selection::EndMultiSelection();
        }
    }
}
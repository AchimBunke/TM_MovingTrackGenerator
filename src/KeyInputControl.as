namespace KeyInputControl
{
    UI::Key markKey = UI::Key::M;
    bool markKeyPressed;


    void Tick(){
        if(UI::IsKeyPressed(markKey) && !markKeyPressed){
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
    }
}
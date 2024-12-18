namespace ArrivalCalculator
{
    class ArrivalEntry
    {
        vec3 position;
        int32 timeSinceStart;
    }
    class Arrivals
    {
        array<ArrivalEntry> entries;
    }

    bool IsTrackingArrivals = false;

    Arrivals@ CurrentArrivals;
    int32 RunStartTime;
    bool HasRunStarted = false;
    bool HasRunFinished = false;

    int TrackingStepSize = 50;

    void ClearArrivals(){
        @CurrentArrivals = Arrivals();
    }
    void Record(){
        if(!IsTrackingArrivals){
            return;
        }
        if(CurrentArrivals is null)
        {
            ClearArrivals();
        }
        Arrivals@ arrivals = CurrentArrivals;
        auto currentRaceTime = GetGameTime() - RunStartTime;
        if (currentRaceTime < 0) 
		{
			warn("Cannot record. Time is negative.");
			return; 
		}
        if(ShouldRecord(currentRaceTime)){
            auto newEntry= ArrivalEntry();
            newEntry.timeSinceStart = currentRaceTime;
            auto player = MBEditor::GetScriptPlayer();
            newEntry.position = player.Position;
            CurrentArrivals.entries.InsertLast(newEntry);
        }
    }

    bool ShouldRecord(int32 currentRaceTime){
        if(CurrentArrivals.entries.IsEmpty())
        {
            return true;
        }
        auto lastEntry = CurrentArrivals.entries[CurrentArrivals.entries.Length-1];
        if(currentRaceTime - lastEntry.timeSinceStart >= TrackingStepSize){
            return true;
        }
        return false;
    }

    bool CanRecord(){
        return MBEditor::IsPlaying() &&
            HasRunStarted && IsTrackingArrivals;
    }
    int32 GetGameTime(){
        return GetApp().Network.PlaygroundClientScriptAPI.GameTime;
    }

    void Tick(){
        if(MBEditor::IsPlaying()){
            auto scriptPlayer = MBEditor::GetScriptPlayer();
            auto post = scriptPlayer.Post;
            if(post == CSmScriptPlayer::EPost::Char) {
                HasRunStarted = false;
                HasRunFinished = false;
			} 
			else if(post == CSmScriptPlayer::EPost::CarDriver && !HasRunFinished) {
				if(!HasRunStarted){
                    RunStartTime = GetGameTime();
                    HasRunStarted = true;
                    if(IsTrackingArrivals){
                        ClearArrivals();
                    }
                }
			}
            auto playground = MBEditor::GetPlayground();
            if (playground.GameTerminals.Length > 0){
                auto terminal = playground.GameTerminals[0];
				auto uiSequence = terminal.UISequence_Current;
                if(uiSequence == CGamePlaygroundUIConfig::EUISequence::Finish) 
				{
                    HasRunStarted = false;
                    HasRunFinished = true;
                }
            }
            
        }
    }

    void ShowUI(){
        TrackingStepSize = UI::InputInt("Tracking Step Size Millis",TrackingStepSize,10);
        IsTrackingArrivals = UI::Checkbox("Track Arrivals", IsTrackingArrivals);
        UI::SameLine();
        ArrivalVisualizer::IsVisualizing = UI::Checkbox("Show Arrivals", ArrivalVisualizer::IsVisualizing);
    }

}
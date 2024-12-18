namespace MBEditor
{
    CGameCtnEditorFree@ GetEditor(){
        return cast<CGameCtnEditorFree>(GetApp().Editor);
    }

    bool EditorIsNull()
    {
        auto editor = GetEditor();
        return editor is null;
    }

    bool DoesPlayerExist(){
        if(EditorIsNull())
        {
            return false;
        }
        auto playground = cast<CSmArenaClient>(GetApp().CurrentPlayground);
        if(playground is null){
            return false;
        }else{
            return playground.Players.Length>0;
        }
    }
    bool IsPlaying(){
        if(!DoesPlayerExist()){
            return false;
        }
        auto player = GetPlayer();
        auto scriptPlayer = GetScriptPlayer();
	
        return scriptPlayer.IsEntityStateAvailable &&
			player.CurrentLaunchedRespawnLandmarkIndex != 0xFFFFFFFF;
    }
    CSmArenaClient@ GetPlayground(){
        auto playground = cast<CSmArenaClient>(GetApp().CurrentPlayground);
        return playground;
    }

    CSmPlayer@ GetPlayer(){
        auto playground = GetPlayground();
        auto player = cast<CSmPlayer>(playground.Players[0]);
        return player;
    }
    CSmScriptPlayer@ GetScriptPlayer(){
        auto player = GetPlayer();
        auto scriptPlayer = cast<CSmScriptPlayer>(player.ScriptAPI);
        return scriptPlayer;
    }
    CGameCtnChallenge@ GetChallenge(){
        return GetEditor().Challenge;
    }
}
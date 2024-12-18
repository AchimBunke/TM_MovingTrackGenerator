namespace Client
{
    string serverAddress = "127.0.0.1";
    int serverPort = 7171;

    Net::Socket@ socket;
    bool connectedAndReady = false;

    void StartConnecting(){
        @socket = Net::Socket();
        print("Connecting to " + serverAddress+" - "+serverPort);
        bool b = socket.Connect(serverAddress, serverPort);
        CheckConnection();
    }
    void EndConnection(){
        print("Stop connection");
        if(connectedAndReady){
            socket.Close();
            @socket = null;
            connectedAndReady = false;
        }
    }
    void CheckConnection(){
        if(socket is null){return;}
        if(socket.IsReady() && !connectedAndReady){
            print("Client Ready");
            connectedAndReady = true;
        }else if(connectedAndReady && !socket.IsReady()){
            print("Client Hung Up");
            connectedAndReady = false;
        }
    }

    void Tick(){
       CheckConnection();
    }

    void Send(const string &in data){
        if(connectedAndReady){
            socket.Write(data);
            socket.WriteRaw("\n");
        }
    }

    void SendMapData(){
        StartConnecting();
        Send(Serialization::GetSerializeMapData());
        EndConnection();
    }
    void ShowUI(){
        if(UI::Button("Send MapData to Server")){
            Client::SendMapData();
        }
        UI::SetTooltip("Sends map data to the Moving Track Generator");
    }

}
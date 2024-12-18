using System.Formats.Asn1;
using System.Net;
using System.Net.Sockets;
using System.Text;
using System.Text.Json;
using System.Windows.Input;

namespace MovingTrackGenerator
{
    public class ConnectionManager
    {
        public ConnectionManager()
        {
            if (CanStart())
                Start();
        }
        public ICommand RestartCommand
            => new RelayCommand(_ => CanStart(), _ => Restart());

        public bool CanStart()
        {
            return !string.IsNullOrWhiteSpace(ComponentRegistry.Settings.Author) &&
                !string.IsNullOrWhiteSpace(ComponentRegistry.Settings.Address) &&
                !string.IsNullOrWhiteSpace(ComponentRegistry.Settings.TrackmaniaFolder) &&
                !string.IsNullOrWhiteSpace(ComponentRegistry.Settings.MapsFolder) &&
                !string.IsNullOrWhiteSpace(ComponentRegistry.Settings.GeneratedMapsFolder) &&
                !string.IsNullOrWhiteSpace(ComponentRegistry.Settings.ItemsFolder) &&
                !string.IsNullOrWhiteSpace(ComponentRegistry.Settings.GeneratedItemsFolder);
        }
        public void Restart()
        {
            ComponentRegistry.InfoOutput.WriteLine("Restarting...");
            Stop();
            Start();
        }

        TcpListener listener;
        public async Task Start()
        {
            var settings = ComponentRegistry.Settings;
            IPHostEntry host = Dns.GetHostEntry(settings.Address);
            IPAddress ipAddress = host.AddressList[0];
            listener = new TcpListener(ipAddress, (int)settings.Port);
            listener.Start();
            ComponentRegistry.InfoOutput.WriteLine("Waiting for Connection...");
            while (true)
            {
                TcpClient client = await listener.AcceptTcpClientAsync();
                _ = HandleClientAsync(client); // Fire-and-forget client handler
            }
        }
        async Task HandleClientAsync(TcpClient client)
        {
            ComponentRegistry.InfoOutput.WriteLine("Client connected.");
            int bufferSize = 1024;
            var buffer = new byte[bufferSize];
            using var stream = client.GetStream();
            var msgSizeBuffer = new byte[4];
            try
            {
                StringBuilder sb = new StringBuilder();
                int bytesRead;
                bytesRead = await stream.ReadAsync(msgSizeBuffer, 0, msgSizeBuffer.Length);
                int msgSize = BitConverter.ToInt32(msgSizeBuffer, 0);
                int totalBytesRead = 0;
                while (totalBytesRead < msgSize)
                {
                    bytesRead = await stream.ReadAsync(buffer, 0, buffer.Length);
                    totalBytesRead += bytesRead;
                    var chunk = Encoding.UTF8.GetString(buffer, 0, bytesRead);
                    sb.Append(chunk);
                }
                ComponentRegistry.InfoOutput.Highlight($"Received message. Trying to parse map data..");

                if (MapData.TryParse(sb.ToString(), out var mapData))
                {
                    ComponentRegistry.InfoOutput.Highlight($"Success!");
                    MapDataReceived?.Invoke(mapData);
                }
                else
                {
                    ComponentRegistry.InfoOutput.Error($"Could not read map data.");
                    ComponentRegistry.InfoOutput.Error($"Message: {sb.ToString()}");
                }

            }
            catch (Exception ex)
            {
                ComponentRegistry.InfoOutput.Error($"Error: {ex.Message}");
            }
            finally
            {
                client.Close();
            }
        }

        public event Action<MapData> MapDataReceived;

        public void Stop()
        {
            if (listener == null)
                return;
            listener.Stop();
        }
    }
}

using MovingTrackGenerator.Generation;

namespace MovingTrackGenerator
{
    public static class ComponentRegistry
    {
        private static Settings _settings;
        public static Settings Settings => _settings ?? (_settings = new Settings());

        private static ConnectionManager _connectionManager;
        public static ConnectionManager ConnectionManager => _connectionManager ?? (_connectionManager = new ConnectionManager());

        private static InfoOutput _infoOutput;
        public static InfoOutput InfoOutput => _infoOutput ?? (_infoOutput = new InfoOutput());


        private static MapGenerator _mapGenerator;
        public static MapGenerator MapGenerator => _mapGenerator ?? (_mapGenerator = new MapGenerator());

    }
}

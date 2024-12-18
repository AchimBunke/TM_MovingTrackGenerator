using System.ComponentModel;
using System.IO;
using static GBX.NET.Engines.Plug.CPlugCrystal;

namespace MovingTrackGenerator
{
    public class Settings : INotifyPropertyChanged
    {
        #region defaults

        const string default_Address = "127.0.0.1";
        const int default_Port = 7171;

        const string relativePathToItems = "Items";
        const string relativePathToMaps = "Maps";
        const string relativePathToGeneratedMaps = @"Maps\Generated";
        const string relativePathToGeneratedItems = @"Items\Generated";

        #endregion

        public event PropertyChangedEventHandler? PropertyChanged;
        private void OnPropertyChanged(string propertyName)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
        }

        public string Address
        {
            get => Properties.Settings.Default.Address;
            set
            {
                if (string.IsNullOrWhiteSpace(value))
                {
                    ComponentRegistry.InfoOutput.WriteLine("Address should not be empty!", OutputFlags.Warning | OutputFlags.Time);
                }
                Properties.Settings.Default.Address = value;
                Properties.Settings.Default.Save();
                OnPropertyChanged(nameof(Address));
            }
        }

        public int Port
        {
            get => Properties.Settings.Default.Port;
            set
            {
                Properties.Settings.Default.Port = value;
                Properties.Settings.Default.Save();
                OnPropertyChanged(nameof(Port));
            }
        }



        public string TrackmaniaFolder
        {
            get => Properties.Settings.Default.TrackmaniaFolder;
            set
            {
           
                Properties.Settings.Default.TrackmaniaFolder = value;
                Properties.Settings.Default.Save();
                if (string.IsNullOrWhiteSpace(ItemsFolder))
                    ItemsFolder = Path.Combine(value, relativePathToItems);
                if (string.IsNullOrWhiteSpace(MapsFolder))
                    MapsFolder = Path.Combine(value, relativePathToMaps);
                if (string.IsNullOrWhiteSpace(GeneratedMapsFolder))
                    GeneratedMapsFolder = Path.Combine(value, relativePathToGeneratedMaps);
                if (string.IsNullOrWhiteSpace(GeneratedItemsFolder))
                    GeneratedItemsFolder = Path.Combine(value, relativePathToGeneratedItems);
                OnPropertyChanged(nameof(TrackmaniaFolder));
            }
        }


        public string ItemsFolder
        {
            get => Properties.Settings.Default.ItemsFolder;
            set
            {
                Properties.Settings.Default.ItemsFolder = value;
                Properties.Settings.Default.Save(); 
                OnPropertyChanged(nameof(ItemsFolder));
            }
        }

        public string MapsFolder
        {
            get => Properties.Settings.Default.MapsFolder;
            set
            {
                Properties.Settings.Default.MapsFolder = value;
                Properties.Settings.Default.Save();
                OnPropertyChanged(nameof(MapsFolder));
            }
        }

        public string GeneratedMapsFolder
        {
            get => Properties.Settings.Default.GeneratedMapsFolder;
            set
            {
                Properties.Settings.Default.GeneratedMapsFolder = value;
                Properties.Settings.Default.Save();
                OnPropertyChanged(nameof(GeneratedMapsFolder));
            }
        }

        public string GeneratedItemsFolder
        {
            get => Properties.Settings.Default.GeneratedItemsFolder;
            set
            {
                Properties.Settings.Default.GeneratedItemsFolder = value;
                Properties.Settings.Default.Save();
                OnPropertyChanged(nameof(GeneratedItemsFolder));
            }
        }

        public string Author
        {
            get => Properties.Settings.Default.Author;
            set
            {
                Properties.Settings.Default.Author = value;
                Properties.Settings.Default.Save();
                OnPropertyChanged(nameof(Author));
            }
        }


        public void ResetToDefault()
        {
            Address = default_Address;
            Port = default_Port;
            TrackmaniaFolder = string.Empty;
            ItemsFolder = string.Empty;
            GeneratedItemsFolder = string.Empty;
            GeneratedMapsFolder = string.Empty;
            MapsFolder = string.Empty;
        }

    }
}

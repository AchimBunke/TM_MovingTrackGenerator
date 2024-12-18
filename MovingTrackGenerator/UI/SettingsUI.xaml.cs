using Microsoft.Win32;
using System.Windows.Controls;

namespace MovingTrackGenerator.UI
{
    /// <summary>
    /// Interaction logic for Settings.xaml
    /// </summary>
    public partial class SettingsUI : UserControl
    {
        public SettingsUI()
        {
            InitializeComponent();
        }

        Settings Settings => ComponentRegistry.Settings;
        string OpenFileDialog(string startPath)
        {
            OpenFolderDialog openFolderDialog = new OpenFolderDialog();
            openFolderDialog.InitialDirectory = @"C:\";
            if (openFolderDialog.ShowDialog() == true)
                return openFolderDialog.FolderName;
            return "";
        }
        private void Button_Click1(object sender, System.Windows.RoutedEventArgs e)
        {
            var f = OpenFileDialog(@"C:\");
            if (!string.IsNullOrEmpty(f))
            {
                Settings.TrackmaniaFolder = f;
            }
        }
        private void Button_Click2(object sender, System.Windows.RoutedEventArgs e)
        {
            var f = OpenFileDialog(@"C:\");
            if (!string.IsNullOrEmpty(f))
            {
                Settings.ItemsFolder = f;
            }
        }
        private void Button_Click3(object sender, System.Windows.RoutedEventArgs e)
        {
            var f = OpenFileDialog(@"C:\");
            if (!string.IsNullOrEmpty(f))
            {
                Settings.GeneratedItemsFolder = f;
            }
        }
        private void Button_Click4(object sender, System.Windows.RoutedEventArgs e)
        {
            var f = OpenFileDialog(@"C:\");
            if (!string.IsNullOrEmpty(f))
            {
                Settings.MapsFolder = f;
            }
        }
        private void Button_Click5(object sender, System.Windows.RoutedEventArgs e)
        {
            var f = OpenFileDialog(@"C:\");
            if (!string.IsNullOrEmpty(f))
            {
                Settings.GeneratedMapsFolder = f;
            }
        }
  

    }
}

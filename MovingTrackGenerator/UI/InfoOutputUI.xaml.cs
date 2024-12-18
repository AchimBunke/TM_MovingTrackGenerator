using System.Windows;
using System.Windows.Controls;
using System.Windows.Documents;
using System.Windows.Media;

namespace MovingTrackGenerator.UI
{
    /// <summary>
    /// Interaction logic for InfoOutput.xaml
    /// </summary>
    public partial class InfoOutputUI : UserControl
    {
        public InfoOutputUI()
        {
            InitializeComponent();
            var ouputTextbox = OutputTextBox;
            var infoOutput = ComponentRegistry.InfoOutput;
            DataContext = infoOutput;
            infoOutput.OutputWritten += InfoOutput_OutputWritten;
        }

        private void InfoOutput_OutputWritten(string arg1, OutputFlags arg3)
        {
            var color = GetColor(arg3);
            var text = arg1;
            var paragraph = OutputTextBox.Document.Blocks.LastBlock as Paragraph;
            if (paragraph == null || arg3.HasFlag(OutputFlags.LineBreak))
            {
                paragraph = new Paragraph();
                paragraph.Margin = new Thickness(0);
                OutputTextBox.Document.Blocks.Add(paragraph);
            }
            var run = new Run(arg1)
            {
                Foreground = color,
            };
            paragraph.Inlines.Add(run);

            OutputTextBox.ScrollToEnd();

        }
        private Brush GetColor(OutputFlags flags)
        {
            if (flags.HasFlag(OutputFlags.Error)) return Brushes.Red;
            if (flags.HasFlag(OutputFlags.Warning)) return Brushes.DarkOrange;
            if(flags.HasFlag(OutputFlags.Highlight)) return Brushes.DarkGreen;
            return Brushes.Black;
        }
    }
}

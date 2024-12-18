using System.Drawing;
using System.Text;

namespace MovingTrackGenerator
{
    public class InfoOutput
    {
        public event Action<string, OutputFlags> OutputWritten;

      
        public void WriteLine(string output, OutputFlags flags = OutputFlags.Info | OutputFlags.Time)
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(output);
            if (flags.HasFlag(OutputFlags.Time))
            {
                sb.Insert(0, $"[{DateTime.Now:HH:mm:ss}] ");
            }
            OutputWritten?.Invoke(sb.ToString(), flags | OutputFlags.LineBreak);
        }
        public void Error(string output)
        {
            OutputWritten?.Invoke(output, OutputFlags.LineBreak | OutputFlags.Error | OutputFlags.Time);
        }
        public void Warn(string output)
        {
            OutputWritten?.Invoke(output, OutputFlags.LineBreak | OutputFlags.Warning | OutputFlags.Time);
        }
        public void Highlight(string output)
        {
            OutputWritten?.Invoke(output, OutputFlags.LineBreak | OutputFlags.Highlight | OutputFlags.Time);
        }
    }
    [Flags]
    public enum OutputFlags
    {
        LineBreak = 1,
        Time = 2,
        Info = 4,
        Warning = 8,
        Error = 16,
        Highlight = 32,
    }
}

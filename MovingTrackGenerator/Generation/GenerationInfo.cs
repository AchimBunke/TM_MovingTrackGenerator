using static GBX.NET.Engines.Meta.NPlugDyna_SKinematicConstraint;

namespace MovingTrackGenerator.Generation
{
    public class GenerationInfo
    {
        public bool WasGenerationFaulty { get; set; }
        public string OriginalMapName { get; set; }
        public string OriginalMapPath { get; set; }

        public string Author { get; set; }

        public string GeneratedMapName { get; set; }
        public string GeneratedMapPath { get; set; }
        public string GeneratedItemsFolder { get; set; }

        public List<GeneratedItemInfo> GeneratedItems { get; set; } = new();


    }
    public class GeneratedItemInfo
    {
        public BlockStatus BlockStatus { get; set; }
        public Vec3 Position { get; set; }
        public Vec3 PitchYawRoll { get; set; }
        public string OriginalItemPath { get; set; }

        public List<AnimKeyFrameInfo> PositionFrames { get; set; } = new();
        public List<AnimKeyFrameInfo> RotationFrames { get; set; } = new();

    }
    public class AnimKeyFrameInfo
    {
        public KeyFrameTarget Target { get; set; }
        public int Time { get; set; }
        public Vec3 Value { get; set; }
        public AnimEase Easing { get; set; }

    }
    public enum KeyFrameTarget 
    {
        Min,
        Max,
    }
}

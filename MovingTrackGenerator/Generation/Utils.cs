using GBX.NET.Engines.Meta;
using System.Numerics;
using static GBX.NET.Engines.Meta.NPlugDyna_SKinematicConstraint;
using static GBX.NET.Engines.Plug.CPlugPrefab;

namespace MovingTrackGenerator.Generation
{
    public static class Utils
    {
        public static bool EqualPosition(Vec3 p1, Vec3 p2)
        {
            return Math.Abs(p1.X - p2.X) <= 0.01f && Math.Abs(p1.Y - p2.Y) <= 0.01f && Math.Abs(p1.Z - p2.Z) <= 0.01f;
        }
        public static EntRef CopyEnt(EntRef ent)
        {
            return new EntRef()
            {
                Model = CopyNPlugDyna_SKinematicConstraint(ent.Model as NPlugDyna_SKinematicConstraint),
                Position = ent.Position,
                Rotation = ent.Rotation,
                Params = ent.Params,
                U01 = ent.U01,
            };
        }
        public static NPlugDyna_SKinematicConstraint CopyNPlugDyna_SKinematicConstraint(NPlugDyna_SKinematicConstraint c)
        {
            return new NPlugDyna_SKinematicConstraint()
            {
                AngleMaxDeg = c.AngleMaxDeg,
                AngleMinDeg = c.AngleMinDeg,
                RotAnimFunc = CopyAnimFunc(c.RotAnimFunc),
                RotAxis = c.RotAxis,
                ShaderTcAnimFunc = c.ShaderTcAnimFunc,
                ShaderTcDataTransSub = c.ShaderTcDataTransSub,
                ShaderTcType = c.ShaderTcType,
                ShaderTcVersion = c.ShaderTcVersion,
                SubVersion = c.SubVersion,
                TransAnimFunc = CopyAnimFunc(c.TransAnimFunc),
                TransAxis = c.TransAxis,
                TransMax = c.TransMax,
                TransMin = c.TransMin,
                Version = c.Version,
            };
        }
        public static AnimFunc CopyAnimFunc(AnimFunc f)
        {
            return new AnimFunc()
            {
                IsDuration = f.IsDuration,
                SubFuncs = f.SubFuncs.Select(sf => CopySubAnimFunc(sf)).ToArray(),
            };
        }
        public static SubAnimFunc CopySubAnimFunc(SubAnimFunc s)
        {
            return new SubAnimFunc()
            {
                Ease = s.Ease,
                Reverse = s.Reverse,
                Duration = s.Duration,
            };
        }

        public static EAxis GetDominantAxis(Vec3 vec)
        {
            float absX = Math.Abs(vec.X);
            float absY = Math.Abs(vec.Y);
            float absZ = Math.Abs(vec.Z);

            if (absX >= absY && absX >= absZ)
                return EAxis.X;
            else if (absY >= absX && absY >= absZ)
                return EAxis.Y;
            else
                return EAxis.Z;
        }

        public static AnimEase ToAnimEase(EasingType easingType) => easingType switch
        {
            EasingType.None => AnimEase.Constant,
            EasingType.Linear => AnimEase.Linear,
            EasingType.QuadIn => AnimEase.QuadIn,
            EasingType.QuadOut => AnimEase.QuadOut,
            EasingType.QuadInOut => AnimEase.QuadInOut,
            EasingType.CubicIn => AnimEase.CubicIn,
            EasingType.CubicOut => AnimEase.CubicOut,
            EasingType.CubicInOut => AnimEase.CubicInOut,
            _ => throw new NotImplementedException(),
        };


    }
    public enum BlockStatus
    {
        Original,
        Problem,
        Updated,
    }
}

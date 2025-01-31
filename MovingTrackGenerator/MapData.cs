using Microsoft.VisualBasic;
using MovingTrackGenerator.Generation;
using System.Numerics;
using System.Text.Json;
using System.Text.Json.Serialization;
using static GBX.NET.Engines.Meta.NPlugDyna_SKinematicConstraint;

namespace MovingTrackGenerator
{
    /// <summary>
    /// Needs to be ssynchronized with the openplanet plugin json objects
    /// </summary>
    public struct MapData
    {
        static JsonSerializerOptions SerializerOptions = new JsonSerializerOptions()
        {
            Converters = { new IEasingValueConverter(), new IAxisValueConverter(), new IOperantIntConverter(), },
            PropertyNameCaseInsensitive = true,
            WriteIndented = true
        };

        public string mapName { get; set; }
        public string mapPath { get; set; }
        public Arrivals arrivals { get; set; }
        public AABB[] AABBs { get; set; }
        public BlockData[] blocks { get; set; }

        public List<VarNumberDeclaration> intVars { get; set; }
        public List<VarNumberDeclaration> floatVars { get; set; }
        public List<VarAxisDeclaration> axisVars { get; set; }
        public List<VarEasingDeclaration> easingVars { get; set; }

        public Dictionary<string, NumberFormula> IntVarDeclarations { get; private set; }
        public Dictionary<string, NumberFormula> FloatVarDeclarations { get; private set; }
        public Dictionary<string, AxisFormula> AxisVarDeclarations { get; private set; }
        public Dictionary<string, EasingFormula> EasingVarDeclarations { get; private set; }

        public static bool TryParse(string json, out MapData mapData)
        {
            try
            {
                mapData = JsonSerializer.Deserialize<MapData>(json, SerializerOptions);
                mapData.IntVarDeclarations = new Dictionary<string, NumberFormula>(mapData.intVars.Select(iv=> new VarNumberDeclaration()
                {
                    id = iv.id,
                    formula = new NumberFormula()
                    {
                        mathOperator = iv.formula.mathOperator,
                        operant1 = iv.formula.operant1,
                        operant2 = iv.formula.operant2,
                        type1 = iv.formula.type1,
                        type2 = iv.formula.type2,
                        FixedRandom = true,
                    }
                }).ToDictionary(iv => iv.id, iv => iv.formula));
                mapData.FloatVarDeclarations = new Dictionary<string, NumberFormula>(mapData.floatVars.Select(iv => new VarNumberDeclaration()
                {
                    id = iv.id,
                    formula = new NumberFormula()
                    {
                        mathOperator = iv.formula.mathOperator,
                        operant1 = iv.formula.operant1,
                        operant2 = iv.formula.operant2,
                        type1 = iv.formula.type1,
                        type2 = iv.formula.type2,
                        FixedRandom = true,
                    }
                }).ToDictionary(iv => iv.id, iv => iv.formula));
                mapData.AxisVarDeclarations = new Dictionary<string, AxisFormula>(mapData.axisVars.Select(iv => new VarAxisDeclaration()
                {
                    id = iv.id,
                    formula = new AxisFormula()
                    {
                        axisValue = iv.formula.axisValue,
                        type = iv.formula.type,
                        FixedRandom = true,
                    }
                }).ToDictionary(iv => iv.id, iv => iv.formula));
                mapData.EasingVarDeclarations = new Dictionary<string, EasingFormula>(mapData.easingVars.Select(iv => new VarEasingDeclaration()
                {
                    id = iv.id,
                    formula = new EasingFormula()
                    {
                        type = iv.formula.type,
                        easingValue = iv.formula.easingValue,
                        FixedRandom = true,
                    }
                }).ToDictionary(iv => iv.id, iv => iv.formula));
                return true;
            }
            catch (Exception e)
            {
                ComponentRegistry.InfoOutput.Error($"Error parsing json: {e.Message}");
            }
            mapData = default;
            return false;
        }
    }
    public struct Arrivals
    {
        public ArrivalEntry[] entries { get; set; }
    }
    public struct ArrivalEntry
    {
        public Vec3 position { get; set; }
        public int timeSinceStart { get; set; }
    }
    public struct AABB
    {
        public Vec3 center { get; set; }
        public Vec3 size { get; set; }
        public string id { get; set; }
    }
    public struct BlockData
    {
        public int id { get; set; }
        public bool hasArrivalData { get; set; }
        public int playerArrivalTime { get; set; }
        public Vec3 playerArrivalPosition { get; set; }
        public Vec3 serializedPositionInWorld { get; set; }
        public BlockAnimationData fullAnimationData { get; set; }


    }
    public enum MathOperator
    {
        Plus,
        Minus,
        Multiply,
        Divide,
    }
    public enum AxisValueType
    {
        Fixed,
        Random,
        Var,
    }
    public enum EasingValueType
    {
        Fixed,
        Random,
        Var,
    }
    public enum OperantType
    {
        Fixed,
        Random,
        ArrivalTime,
        Var,
        ValueFrom,
    }
    public enum  AnimationOptions
    {
        Wait_1,
        Wait_2,
        FlyIn,
        FlyOut,
    }
    [Flags]
    public enum EasingTypeFlags
    {
        None = 1 << 0,
        Linear = 1 << 1,
        QuadIn = 1 << 2,
        QuadOut = 1 << 3,
        QuadInOut = 1 << 4,
        CubicIn = 1 << 5,
        CubicOut = 1 << 6,
        CubicInOut = 1 << 7,
    }
    public enum EasingType
    {
        None,
        Linear,
        QuadIn,
        QuadOut,
        QuadInOut,
        CubicIn,
        CubicOut,
        CubicInOut,
    }
   
    public enum AnimationOrder
    {
        Wait_FlyIn_Wait_FlyOut,
        Wait_FlyOut_Wait_FlyIn,
    }
    public struct BlockAnimationData
    {
        public AnimationOrder animationOrder { get; set; }
        public AnimationData translationData { get; set; }
        public AnimationData rotationData { get; set; }
        public bool isLocalSpace { get; set; }
    }
    public struct AnimationData
    {
        public NumberFormula maxFormula { get; set; }
        public AxisFormula axisFormula { get; set; }

        public NumberFormula wait1DurationFormula { get; set; }
        public EasingFormula wait1EasingFormula { get; set; }

        public NumberFormula flyInDurationFormula { get; set; }
        public EasingFormula flyInEasingFormula { get; set; }

        public NumberFormula wait2DurationFormula { get; set; }
        public EasingFormula wait2EasingFormula { get; set; }

        public NumberFormula flyOutDurationFormula { get; set; }
        public EasingFormula flyOutEasingFormula { get; set; }
    }
    public struct NumberFormula
    {
        public OperantType type1 { get; set; }
        public INumericOperant operant1 { get; set; }
        public MathOperator mathOperator { get; set; }
        public OperantType type2 { get; set; }
        public INumericOperant operant2 { get; set; }

        public bool FixedRandom { get; set; }

        public float Resolve(float arrivalTime, ValueType valueType, Dictionary<string, NumberFormula> vars, Dictionary<AnimationOptions, float> animPartResults)
        {
            var v1 = operant1.GetValue(valueType, arrivalTime, vars, FixedRandom, animPartResults);
            var v2 = operant2.GetValue(valueType, arrivalTime, vars, FixedRandom, animPartResults);
            if (valueType == ValueType.Int)
            {
                switch (mathOperator)
                {
                    case MathOperator.Plus:
                        return (int)v1 + (int)v2;
                    case MathOperator.Minus:
                        return (int)v1 - (int)v2;
                    case MathOperator.Multiply:
                        return (int)v1 * (int)v2;
                    case MathOperator.Divide:
                        return (int)v1 / (int)v2;
                    default:
                        throw new NotImplementedException();
                }
            }
            else
            {
                switch (mathOperator)
                {
                    case MathOperator.Plus:
                        return v1 + v2;
                    case MathOperator.Minus:
                        return v1 - v2;
                    case MathOperator.Multiply:
                        return v1 * v2;
                    case MathOperator.Divide:
                        return v1 / v2;
                    default:
                        throw new NotImplementedException();
                }
            }
        }
    }

    public struct VarNumberDeclaration
    {
        public string id { get; set; }
        public NumberFormula formula { get; set; }
    }
    public struct VarAxisDeclaration
    {
        public string id { get; set; }
        public AxisFormula formula { get; set; }
    }
    public struct VarEasingDeclaration
    {
        public string id { get; set; }
        public EasingFormula formula { get; set; }
    }
    public struct AxisFormula
    {
        public AxisValueType type { get; set; }
        public IAxisValue axisValue { get; set; }
        public bool FixedRandom { get; set; }
        public EAxis Resolve(EAxis arrivalDirection, Dictionary<string, AxisFormula> vars)
        {
            return axisValue.GetValue(arrivalDirection, vars, FixedRandom);
        }
    }
    
    public struct EasingFormula
    {
        public EasingValueType type { get; set; }
        public IEasingValue easingValue { get; set; }
        public bool FixedRandom { get; set; }

        public AnimEase Resolve(Dictionary<string, EasingFormula> vars)
        {
            return easingValue.GetValue(vars, FixedRandom);
        }
    }
    public interface IEasingValue
    {
        public AnimEase GetValue(Dictionary<string, EasingFormula> _, bool fixedRandom);
    }
    public struct FixedEasingValue : IEasingValue
    {
        public EasingType value { get; set; }
        public AnimEase GetValue(Dictionary<string, EasingFormula> _, bool fixedRandom) => Utils.ToAnimEase(value);
    }
    public struct VarEasingValue : IEasingValue
    {
        public string var { get; set; }
        public AnimEase GetValue(Dictionary<string, EasingFormula> vars, bool fixedRandom)
        {
            return vars[var].Resolve(vars);
        }
    }
    public struct RandomEasingValue : IEasingValue
    {
        public EasingTypeFlags randomFlags { get; set; }
        int _fixedRandomResult;
        bool _fixedRandomInitialized;
        public AnimEase GetValue(Dictionary<string, EasingFormula> _, bool fixedRandom)
        {
            Random r = new Random();
            var values = new List<EasingType>();
            if (randomFlags.HasFlag(EasingTypeFlags.None)) values.Add(EasingType.None);
            if (randomFlags.HasFlag(EasingTypeFlags.Linear)) values.Add(EasingType.Linear);
            if (randomFlags.HasFlag(EasingTypeFlags.QuadIn)) values.Add(EasingType.QuadIn);
            if (randomFlags.HasFlag(EasingTypeFlags.QuadOut)) values.Add(EasingType.QuadOut);
            if (randomFlags.HasFlag(EasingTypeFlags.QuadInOut)) values.Add(EasingType.QuadInOut);
            if (randomFlags.HasFlag(EasingTypeFlags.CubicIn)) values.Add(EasingType.CubicIn);
            if (randomFlags.HasFlag(EasingTypeFlags.CubicOut)) values.Add(EasingType.CubicOut);
            if (randomFlags.HasFlag(EasingTypeFlags.CubicInOut)) values.Add(EasingType.CubicInOut);
            int result;
            if (fixedRandom)
            {
                if (!_fixedRandomInitialized)
                {
                    _fixedRandomResult = r.Next(values.Count);
                    _fixedRandomInitialized = true;
                }
                result = _fixedRandomResult;
            }
            else
                result = r.Next(values.Count);
            return Utils.ToAnimEase(values[result]);
        }
    }
    public class IEasingValueConverter : JsonConverter<IEasingValue>
    {
        public override IEasingValue Read(ref Utf8JsonReader reader, Type typeToConvert, JsonSerializerOptions options)
        {
            // Parse the JSON element
            using var doc = JsonDocument.ParseValue(ref reader);
            var root = doc.RootElement;

            if (root.TryGetProperty("value", out _))
            {
                // It's FixedEasingValue
                return root.Deserialize<FixedEasingValue>(options);
            }
            else if (root.TryGetProperty("randomFlags", out _))
            {
                // It's RandomEasingValue
                return root.Deserialize<RandomEasingValue>(options);
            }else if(root.TryGetProperty("var", out _))
            {
                return root.Deserialize<VarEasingValue>(options);
            }

            throw new JsonException("Unknown IEasingValue type");
        }

        public override void Write(Utf8JsonWriter writer, IEasingValue value, JsonSerializerOptions options)
        {
            switch (value)
            {
                case FixedEasingValue fixedValue:
                    JsonSerializer.Serialize(writer, fixedValue, options);
                    break;

                case RandomEasingValue randomValue:
                    JsonSerializer.Serialize(writer, randomValue, options);
                    break;
                case VarEasingValue varValue:
                    JsonSerializer.Serialize(writer, varValue, options);
                    break;

                default:
                    throw new JsonException("Unknown IEasingValue implementation");
            }
        }
    }
    public interface IAxisValue 
    {
        public EAxis GetValue(EAxis arrivalDirection, Dictionary<string, AxisFormula> _, bool fixedRandom);
    }
    public struct FixedAxisValue : IAxisValue
    {
        public EAxis axis { get; set; }
        public EAxis GetValue(EAxis _, Dictionary<string, AxisFormula> _2, bool fixedRandom) => axis;
    }
    public struct RandomAxisValue : IAxisValue
    {
        public bool randomX { get;set; }
        public bool randomY { get; set; }
        public bool randomZ { get; set; }
        public bool avoidArrivalDirection { get; set; }
        int _fixedRandomResult;
        bool _fixedRandomInitialized;
        public EAxis GetValue(EAxis arrivalAxis, Dictionary<string, AxisFormula> _, bool fixedRandom)
        {
            System.Random r = new System.Random();
            var values = new List<EAxis>();
            if (randomX) values.Add(EAxis.X);
            if (randomY) values.Add(EAxis.Y);
            if (randomZ) values.Add(EAxis.Z);
            if (avoidArrivalDirection && randomX && arrivalAxis != EAxis.X) values.Add(EAxis.X);
            if (avoidArrivalDirection && randomY && arrivalAxis != EAxis.Y) values.Add(EAxis.Y);
            if (avoidArrivalDirection && randomZ && arrivalAxis != EAxis.Z) values.Add(EAxis.Z);
            int result;
            if (fixedRandom)
            {
                if (!_fixedRandomInitialized)
                {
                    _fixedRandomResult = r.Next(values.Count);
                    _fixedRandomInitialized = true;
                }
                result = _fixedRandomResult;
            }
            else
                result = r.Next(values.Count);
            return values[result];
        }
    }
    public struct VarAxisValue : IAxisValue
    {
        public string var { get; set; }
        public EAxis GetValue(EAxis arrivalAxis, Dictionary<string, AxisFormula> vars, bool fixedRandom)
        {
            return vars[var].Resolve(arrivalAxis, vars);
        }
    }
    public class IAxisValueConverter : JsonConverter<IAxisValue>
    {
        public override IAxisValue Read(ref Utf8JsonReader reader, Type typeToConvert, JsonSerializerOptions options)
        {
            using var doc = JsonDocument.ParseValue(ref reader);
            var root = doc.RootElement;

            if (root.TryGetProperty("axis", out _))
            {
                // Deserialize as FixedAxisValue
                return root.Deserialize<FixedAxisValue>(options);
            }
            else if (root.TryGetProperty("randomX", out _))
            {
                // Deserialize as RandomAxisValue
                return root.Deserialize<RandomAxisValue>(options);
            }else if(root.TryGetProperty("var", out _))
            {
                return root.Deserialize<VarAxisValue>(options);
            }

            throw new JsonException("Unknown IAxisValue type");
        }

        public override void Write(Utf8JsonWriter writer, IAxisValue value, JsonSerializerOptions options)
        {
            switch (value)
            {
                case FixedAxisValue fixedAxis:
                    JsonSerializer.Serialize(writer, fixedAxis, options);
                    break;

                case RandomAxisValue randomAxis:
                    JsonSerializer.Serialize(writer, randomAxis, options);
                    break;
                case VarAxisValue varAxis:
                    JsonSerializer.Serialize(writer, varAxis, options);
                    break;

                default:
                    throw new JsonException("Unknown IAxisValue implementation");
            }
        }
    }
    public class IOperantIntConverter : JsonConverter<INumericOperant>
    {
        public override INumericOperant Read(ref Utf8JsonReader reader, Type typeToConvert, JsonSerializerOptions options)
        {
            using var doc = JsonDocument.ParseValue(ref reader);
            var root = doc.RootElement;

            if (root.TryGetProperty("value", out _))
            {
                // Deserialize as FixedInt
                return root.Deserialize<FixedNumeric>(options);
            }
            else if (root.TryGetProperty("min", out _) && root.TryGetProperty("max", out _))
            {
                // Deserialize as RandomInt
                return root.Deserialize<RandomNumeric>(options);
            }
            else if (root.ValueKind == JsonValueKind.Object && root.GetRawText() == "{}")
            {
                // Deserialize as ArrivalTime (empty object)
                return new ArrivalTime();
            }else if(root.TryGetProperty("var", out _))
            {
                return root.Deserialize<VarNumericValue>(options);
            }
            else if(root.TryGetProperty("option", out _))
            {
                return root.Deserialize<ValueFromNumericValue>(options);
            }

            throw new JsonException("Unknown IOperantInt type");
        }

        public override void Write(Utf8JsonWriter writer, INumericOperant value, JsonSerializerOptions options)
        {
            switch (value)
            {
                case FixedNumeric fixedInt:
                    JsonSerializer.Serialize(writer, fixedInt, options);
                    break;

                case RandomNumeric randomInt:
                    JsonSerializer.Serialize(writer, randomInt, options);
                    break;

                case ArrivalTime:
                    writer.WriteStartObject();
                    writer.WriteEndObject();
                    break;
                case VarNumericValue varInt:
                    JsonSerializer.Serialize(writer, varInt, options);
                    break;
                case ValueFromNumericValue valueFromInt:
                    JsonSerializer.Serialize(writer, valueFromInt, options);
                    break;

                default:
                    throw new JsonException("Unknown IOperantInt implementation");
            }
        }
    }
    public enum ValueType
    {
        Int,
        Float,
    }
    public interface INumericOperant 
    {
        public float GetValue(ValueType valueType, float arrivalTime, Dictionary<string, NumberFormula> _, bool fixedRandom, Dictionary<AnimationOptions, float> animPartResults);
    }
    public struct FixedNumeric : INumericOperant
    {
        public float value { get; set; }
        public float GetValue(ValueType valueType, float arrivalTime, Dictionary<string, NumberFormula> _, bool fixedRandom, Dictionary<AnimationOptions, float> animPartResults) => value;
    }
    public struct RandomNumeric : INumericOperant
    {
        public float min { get; set; }
        public float max { get; set; }
        float _fixedRandomResult;
        bool _fixedRandomInitialized;
        public float GetValue(ValueType valueType, float arrivalTime, Dictionary<string, NumberFormula> _, bool fixedRandom, Dictionary<AnimationOptions, float> animPartResults)
        {
            Random r = new Random();
            if (fixedRandom)
            {
                if (!_fixedRandomInitialized)
                {
                    if (valueType == ValueType.Int)
                    {
                        _fixedRandomResult = r.Next((int)min, (int)max + 1);
                    }
                    else
                    {
                        _fixedRandomResult = (float)r.NextDouble() * (max - min) + min;
                    }
                    _fixedRandomInitialized = true;
                }
                return _fixedRandomResult;
            }
            if (valueType == ValueType.Int)
            {
                return r.Next((int)min, (int)max + 1);
            }
            return (float)r.NextDouble() * (max - min) + min;
        }
    }
    public struct ArrivalTime : INumericOperant
    {
        public float GetValue(ValueType valueType, float arrivalTime, Dictionary<string, NumberFormula> _, bool fixedRandom, Dictionary<AnimationOptions, float> animPartResults) => arrivalTime;
    }
    public struct VarNumericValue : INumericOperant
    {
        public string var { get; set; }
        public float GetValue(ValueType valueType, float arrivalTime, Dictionary<string, NumberFormula> vars, bool fixedRandom, Dictionary<AnimationOptions, float> animPartResults)
        {
            return vars[var].Resolve(arrivalTime, valueType, vars, animPartResults);
        }
    }
    public struct ValueFromNumericValue : INumericOperant
    {
        public AnimationOptions options { get; set; }

        public float GetValue(ValueType valueType, float arrivalTime, Dictionary<string, NumberFormula> _, bool fixedRandom, Dictionary<AnimationOptions, float> animPartResults)
        {
            return animPartResults[options];
        }
    }
    public struct Vec3
    {
        public float X { get; set; }
        public float Y { get; set; }
        public float Z { get; set; }

        public static implicit operator GBX.NET.Vec3(Vec3 v) => new GBX.NET.Vec3(v.X, v.Y, v.Z);
        public static implicit operator Vec3((float x, float y, float z) c) => new Vec3() { Z = c.z, Y = c.y, X = c.x };
        public static implicit operator Vec3(GBX.NET.Vec3 v) => new Vec3() { X = v.X, Y = v.Y, Z = v.Z };
        public static implicit operator Vec3(Vector3 v) => new Vec3() { X = v.X, Y = v.Y, Z = v.Z };
        public static implicit operator Vector3(Vec3 v) => new Vector3(v.X, v.Y, v.Z);

        public static Vec3 operator +(Vec3 a, Vec3 b) => new Vec3 { X = a.X + b.X, Y = a.Y + b.Y, Z = a.Z + b.Z };
        public static Vec3 operator -(Vec3 a, Vec3 b) => new Vec3 { X = a.X - b.X, Y = a.Y - b.Y, Z = a.Z - b.Z };
        public static Vec3 operator *(Vec3 a, float b) => new Vec3 { X = a.X * b, Y = a.Y * b, Z = a.Z * b };
        public static Vec3 operator /(Vec3 a, float b) => new Vec3 { X = a.X / b, Y = a.Y / b, Z = a.Z / b };

        public static bool operator ==(Vec3 a, Vec3 b) => a.X == b.X && a.Y == b.Y && a.Z == b.Z;
        public static bool operator !=(Vec3 a, Vec3 b) => a.X != b.X || a.Y != b.Y || a.Z != b.Z;
        public override string ToString()
        {
            return $"({X}, {Y}, {Z})";
        }
    }

}

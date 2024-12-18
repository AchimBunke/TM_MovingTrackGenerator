namespace MathUtils
{
    vec3 Min(vec3 a, vec3 b){
        return vec3(Math::Min(a.x, b.x), Math::Min(a.y, b.y),Math::Min(a.y, b.y));
    }
    vec3 Max(vec3 a, vec3 b){
        return vec3(Math::Max(a.x, b.x), Math::Max(a.y, b.y),Math::Max(a.y, b.y));
    }
    float Magnitude(vec3 v){
        return Math::Sqrt(v.x * v.x + v.y * v.y + v.z * v.z);
    }
    vec3 Neg(vec3 v){
        return vec3(-v.x, -v.y, -v.z);
    }
}
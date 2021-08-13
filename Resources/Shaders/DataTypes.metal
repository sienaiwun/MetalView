#ifndef SHADER_DATA_TYPES_H
#define SHADER_DATA_TYPES_H
#include <metal_stdlib>
using namespace metal;


struct PerDrawConstants
{
    float4x4 modelMatrix;
};

struct SceneConstants
{
    float4x4 viewMatrix ;
    float4x4 projectionMatrix;
    float3 camera_pos;
};

struct Material {
    float4 color;
    bool isLit;
    
    float3 ambient;
    float3 diffuse;
    float3 specular;
    float shininess;
};

struct LightData {
    float3 position;
    float3 color;
    float brightness;
    
    float ambientIntensity;
    float diffuseIntensity;
    float specularIntensity;
};
#endif

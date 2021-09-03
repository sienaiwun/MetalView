#include <metal_stdlib>
using namespace metal;
#include "DataTypes.metal"
#include "LightModel.metal"

struct VertexIn{
    float3 position [[ attribute(0) ]];
    float4 color [[ attribute(1) ]];
    float2 texCoord [[ attribute(2) ]];
    float3 normal [[ attribute(3) ]];
};

struct RasterizerData{
    float4 position [[ position ]];
    float4 color;
    float2 tc1;
    float3 worldNormal;
    float3 worldPosition;
    float3 toCameraD;
};


vertex RasterizerData basic_ui_shader(const VertexIn vIn [[ stage_in ]],
                                          constant PerDrawConstants &perdrawConstants[[buffer(1)]],
                                          constant SceneConstants &sceneConstants[[buffer(2)]]){
    RasterizerData rd;
    
    float4 worldPos = perdrawConstants.modelMatrix * float4(vIn.position, 1);
    rd.position = worldPos;
    rd.color = vIn.color;
    rd.tc1 = vIn.texCoord;
    rd.worldPosition = worldPos.xyz;
    rd.worldNormal = (perdrawConstants.modelMatrix * float4(vIn.normal, 0.0f)).xyz;
    rd.toCameraD = sceneConstants.camera_pos - worldPos.xyz;
    return rd;
}


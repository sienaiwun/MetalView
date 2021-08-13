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


vertex RasterizerData basic_vertex_shader(const VertexIn vIn [[ stage_in ]],
                                          constant PerDrawConstants &perdrawConstants[[buffer(1)]],
                                          constant SceneConstants &sceneConstants[[buffer(2)]]){
    RasterizerData rd;
    
    float4 worldPos = perdrawConstants.modelMatrix * float4(vIn.position, 1);
    rd.position = sceneConstants.projectionMatrix * sceneConstants.viewMatrix * worldPos;
    rd.color = vIn.color;
    rd.tc1 = vIn.texCoord;
    rd.worldPosition = worldPos.xyz;
    rd.worldNormal = (perdrawConstants.modelMatrix * float4(vIn.normal, 0.0f)).xyz;
    rd.toCameraD = sceneConstants.camera_pos - worldPos.xyz;
    return rd;
}

fragment half4 basic_fragment_shader(RasterizerData rd [[ stage_in ]],
                                     constant Material &material[[buffer(1)]],
                                     constant int &lightCount[[buffer(2)]],
                                     constant LightData *lightDatas [[ buffer(3) ]],
                                     sampler sampler2d [[ sampler(0) ]],
                                    texture2d<float> colorMap [[ texture(0) ]] ){
    float2 tex = rd.tc1;
    float4 color = material.color;
    if(!is_null_texture(colorMap))
        color = colorMap.sample(sampler2d, tex);
    if(material.isLit) {
        float3 unitNormal = normalize(rd.worldNormal);
        float3 unitToCameraVector = normalize(rd.toCameraD); // V Vector

        float3 phongIntensity = LightModel::GetPhongIntensity(material,
                                                            lightDatas,
                                                            lightCount,
                                                            rd.worldPosition,
                                                            unitNormal,
                                                            unitToCameraVector);
        color *= float4(phongIntensity, 1.0);
    }
    return half4(color);
}


#include <metal_stdlib>
using namespace metal;

struct VertexIn{
    float3 position [[ attribute(0) ]];
    float4 color [[ attribute(1) ]];
    float2 texCoord [[ attribute(2) ]];
};

struct RasterizerData{
    float4 position [[ position ]];
    float4 color;
    float2 tc1;
};

struct PerDrawConstants
{
    float4x4 modelMatrix;
};

vertex RasterizerData basic_vertex_shader(const VertexIn vIn [[ stage_in ]],
                                          constant PerDrawConstants &perdrawConstants[[buffer(1)]]){
    RasterizerData rd;
    
    rd.position = perdrawConstants.modelMatrix * float4(vIn.position, 1);
    rd.color = vIn.color;
    rd.tc1 = vIn.texCoord;
    
    return rd;
}

fragment half4 basic_fragment_shader(RasterizerData rd [[ stage_in ]],
                                     sampler sampler2d [[ sampler(0) ]],
                                    texture2d<float> texture [[ texture(0) ]] ){
    float4 color = texture.sample(sampler2d, rd.tc1 );
   // float4 color = rd.color;
    return half4(color.r, color.g, color.b, color.a);
}

//
//  ComputeShader.metal
//  MetalView
//
//  Created by sws on 2021/6/11.
//

#include <metal_stdlib>
using namespace metal;


struct cbuffer
{
    float c_width;
    float c_height;
    float c_renderSoftShadows;
    float c_tap;
    float c_speed;
    float c_epsilon;
    float c_time;
    float tap;
};

struct Gear
{
    float t;            // Time
    float gearR;        // Gear radius
    float teethH;        // Teeth height
    float teethR;        // Teeth "roundness"
    float teethCount;    // Teeth count
    float diskR;        // Inner or outer border radius
    float3 color;            // Color
};


float GearFunction(float2 uv, Gear g)
{
    float r = length(uv);
    float a = atan2(uv.y, uv.x);

    // Gear polar function:
    //  A sine squashed by a logistic function gives a convincing
    //  gear shape!
    float p = g.gearR - 0.5*g.teethH +
        g.teethH / (1.0 + exp(g.teethR*sin(g.t + g.teethCount*a)));

    float gear = r - p;
    float disk = r - g.diskR;

    return g.gearR > g.diskR ? max(-disk, gear) : max(disk, -gear);
}


float GearDe(float2 uv, Gear g)
{
    // IQ's f/|Grad(f)| distance estimator:
    float f = GearFunction(uv, g);
    float2 eps = float2(0.0001, 0);
    float2 grad = float2(
        GearFunction(uv + eps.xy, g) - GearFunction(uv - eps.xy, g),
        GearFunction(uv + eps.yx, g) - GearFunction(uv - eps.yx, g)) / (2.0*eps.x);

    return (f) / length(grad);
}


float GearShadow(float2 uv, Gear g)
{
    float r = length(uv + float2(0.1, 0.1));
    float de = r - g.diskR + 0.0*(g.diskR - g.gearR);
    float eps = 0.4*g.diskR;
    return smoothstep(eps, 0., abs(de));
}


float3 DrawGear(float3 color, float2 uv, Gear g, float eps,cbuffer buffer)
{
    float d = smoothstep(eps, -eps, GearDe(uv, g));
    float s = 1.0 - 0.7*GearShadow(uv, g)*buffer.c_renderSoftShadows;
    color = mix(s*color, g.color, d);
    return color;
}

kernel void testShader(constant cbuffer *buffer        [[ buffer(0) ]],
                       texture2d<float, access::write> outTexture [[texture(0)]],
                       uint2 gid [[thread_position_in_grid]])
{
    float t = buffer->c_speed * buffer->c_time;
    float4 coord = float4((float)gid.x, (float)gid.y, 0.0f, 0.0f);
    float2 size = float2((float)buffer->c_width, (float)buffer->c_height);

    float2 uv = coord.xy / size.xy;
    uv = uv.yx;
    uv = uv * 2.0f - 1.0f;
    float eps = buffer->c_epsilon;

    // Scene parameters;
    float3 base = float3(0.95, 0.7, 0.2);
    float count = 3.0;

    Gear outer;// = Gear(0.0, 0.8, 0.08, 4.0, 32.0, 0.9, base);
    outer.t = 0.0;
    outer.gearR = 0.8;
    outer.teethH = 0.08;
    outer.teethR = 4.0;        // Teeth "roundness"
    outer.teethCount = 32.0;    // Teeth count
    outer.diskR = 0.9;        // Inner or outer border radius
    outer.color = base;            // Color
    Gear inner; //= Gear(0.0, 0.4, 0.08, 4.0, 16.0, 0.3, base);
    inner = outer;
    inner.teethCount = 16.0;
    inner.diskR = 0.3;
    inner.gearR = 0.4;

    // Draw inner gears back to front:
    float3 color = float3(0.0,0.0,0.0);
    for (float i = 0.0; i < count; i++)
    {
        t += 2.0*3.1415 / count;
        inner.t = 16.0*t;
        inner.color = base * (0.35 + 0.6*i / (count - 1.0));
        color = DrawGear(color, uv + 0.4*float2(cos(t), sin(t)), inner, eps, *buffer);
    }

    // Draw outer gear:
    color = DrawGear(color, uv, outer, eps,*buffer);
    float4 outColor = float4(color, 1.0);
    outTexture.write(outColor, gid);
}

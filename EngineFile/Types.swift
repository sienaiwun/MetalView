import simd
public typealias FLOAT3 = SIMD3<Float>
public typealias FLOAT4 = SIMD4<Float>
public typealias FLOAT2 = SIMD2<Float>
protocol datasize {
}
extension datasize{
    
       static func size(_ count: Int = 1)->Int{
           return MemoryLayout<Self>.size * count
       }
       
       static func stride(_ count: Int = 1)->Int{
           return MemoryLayout<Self>.stride * count
       }
}

extension FLOAT2: datasize { }
extension FLOAT3: datasize { }
extension FLOAT4: datasize { }
extension UInt32: datasize { }

struct Vertex: datasize{
    var position: FLOAT3
    var color: FLOAT4
    var texCoord: FLOAT2
}

struct ModelConstants:datasize {
    var modelMatrix  = matrix_identity_float4x4
}

struct SceneConstants:datasize
{
    var viewMatrix = matrix_identity_float4x4
    var projectionMatrix = matrix_identity_float4x4
    var cameraPos:FLOAT3 = FLOAT3(0,0,0)
}

struct BufferConstants:datasize
{
    var mWidth :Float = 0
    var mHeight:Float = 0
    var mRenderSoftShadows:Float = 0
    var _tap:Float = 0
    var mSpeed:Float = 0.0
    var mEpsilon:Float = 0.0
    var time:Float = 0.0
    var _tap2:Float = 0.0
}

struct Material: datasize{
    var color = FLOAT4(0.6, 0.6, 0.6, 1.0)
    var isLit: Bool = true
    
    var ambient: FLOAT3 = FLOAT3(0.1, 0.1, 0.1)
    var diffuse: FLOAT3 = FLOAT3(1,1,1)
    var specular: FLOAT3 = FLOAT3(1,1,1)
    var shininess: Float = 2
}

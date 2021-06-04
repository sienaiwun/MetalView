import simd
typealias FLOAT3 = SIMD3<Float>
typealias FLOAT4 = SIMD4<Float>
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


extension FLOAT3: datasize { }

struct Vertex: datasize{
    var position: FLOAT3
    var color: FLOAT4
}

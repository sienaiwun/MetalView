import MetalKit

public var X_AXIS: FLOAT3{
    return FLOAT3(1,0,0)
}

public var Y_AXIS: FLOAT3{
    return FLOAT3(0,1,0)
}

public var Z_AXIS: FLOAT3{
    return FLOAT3(0,0,1)
}

extension Float
{
    var toRadians: Float{
           return (self / 180.0) * Float.pi
       }
       
       var toDegrees: Float{
           return self * (180.0 / Float.pi)
       }
}
extension matrix_float4x4{
    
    mutating func translate(direction: FLOAT3){
        var result = matrix_identity_float4x4
        
        let x: Float = direction.x
        let y: Float = direction.y
        let z: Float = direction.z
        
        result.columns = (
            FLOAT4(1,0,0,0),
            FLOAT4(0,1,0,0),
            FLOAT4(0,0,1,0),
            FLOAT4(x,y,z,1)
        )
        
        self = matrix_multiply(self, result)
    }
    
    mutating func scale(axis: FLOAT3){
        var result = matrix_identity_float4x4
        
        let x: Float = axis.x
        let y: Float = axis.y
        let z: Float = axis.z
        
        result.columns = (
            FLOAT4(x,0,0,0),
            FLOAT4(0,y,0,0),
            FLOAT4(0,0,z,0),
            FLOAT4(0,0,0,1)
        )
        
        self = matrix_multiply(self, result)
    }
    
    
    mutating func rotate(angle: Float, axis: FLOAT3){
        var result = matrix_identity_float4x4
        
        let x: Float = axis.x
        let y: Float = axis.y
        let z: Float = axis.z
        
        let c: Float = cos(angle)
        let s: Float = sin(angle)
        
        let mc: Float = (1 - c)
        
        let r1c1: Float = x * x * mc + c
        let r2c1: Float = x * y * mc + z * s
        let r3c1: Float = x * z * mc - y * s
        let r4c1: Float = 0.0
        
        let r1c2: Float = y * x * mc - z * s
        let r2c2: Float = y * y * mc + c
        let r3c2: Float = y * z * mc + x * s
        let r4c2: Float = 0.0
        
        let r1c3: Float = z * x * mc + y * s
        let r2c3: Float = z * y * mc - x * s
        let r3c3: Float = z * z * mc + c
        let r4c3: Float = 0.0
        
        let r1c4: Float = 0.0
        let r2c4: Float = 0.0
        let r3c4: Float = 0.0
        let r4c4: Float = 1.0
        
        result.columns = (
            FLOAT4(r1c1, r2c1, r3c1, r4c1),
            FLOAT4(r1c2, r2c2, r3c2, r4c2),
            FLOAT4(r1c3, r2c3, r3c3, r4c3),
            FLOAT4(r1c4, r2c4, r3c4, r4c4)
        )
        
        self = matrix_multiply(self, result)
    }
    
    static func perspective(degreesFov: Float, aspectRatio: Float, near: Float, far: Float)->matrix_float4x4{
            let fov = degreesFov.toRadians
            
            let t: Float = tan(fov / 2)
            
            let x: Float = 1 / (aspectRatio * t)
            let y: Float = 1 / t
            let z: Float = -((far + near) / (far - near))
            let w: Float = -((2 * far * near) / (far - near))
            
            var result = matrix_identity_float4x4
            result.columns = (
                FLOAT4(x,  0,  0,   0),
                FLOAT4(0,  y,  0,   0),
                FLOAT4(0,  0,  z,  -1),
                FLOAT4(0,  0,  w,   0)
            )
            return result
        }
    
    func toUpperLeft3x3() -> matrix_float3x3 {
        let x = columns.0
        let y = columns.1
        let z = columns.2
        
        return matrix_float3x3(columns: (vector_float3(x.x, x.y, x.z),
                                         vector_float3(y.x, y.y, y.z),
                                         vector_float3(z.x, z.y, z.z)))
    }
    
}

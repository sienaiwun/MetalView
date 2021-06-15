import MetalKit

class Camera:Node
{
    private var _viewMatrix = matrix_identity_float4x4
    private var _projectionMatrix = matrix_float4x4.perspective(degreesFov: 35.0,
                                                                aspectRatio: 1.0,
                                                                near: 0.1,
                                                                far: 1000)
    
    var viewMatrix: matrix_float4x4 {
            return _viewMatrix
        }
    var projectionMatrix: matrix_float4x4 {
           return _projectionMatrix
       }
       
   override func updateModelMatrix() {
       _viewMatrix = matrix_identity_float4x4
       _viewMatrix.rotate(angle: self.getRotationX(), axis: X_AXIS)
       _viewMatrix.rotate(angle: self.getRotationY(), axis: Y_AXIS)
       _viewMatrix.rotate(angle: self.getRotationZ(), axis: Z_AXIS)
       _viewMatrix.translate(direction: -getPosition())
   }
    
    
    
}

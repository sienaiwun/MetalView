import MetalKit

class Camera:Node
{
    private var _viewMatrix = matrix_identity_float4x4
    private var _projectionMatrix = matrix_float4x4.perspective(degreesFov: 35.0,
                                                                aspectRatio: 1.0,
                                                                near: 0.1,
                                                                far: 1000)
    public weak var input:InputDevice?
    
    
    var viewMatrix: matrix_float4x4 {
            return _viewMatrix
        }
    var projectionMatrix: matrix_float4x4 {
           return _projectionMatrix
       }
       
   override func updateModelMatrix() {
        let sensitivess:Float = 0.001
        if let x = input?.mouseDeltaX as Float? ,let y = input?.mouseDeltaY as Float?
        {
            self.setRotationY(self.getRotationY()+x*(-sensitivess))
            self.setRotationX(self.getRotationX()+y*(-sensitivess))
        }
    #if USE_VIRTUAL_JOYSTICKS
        if let x:Float = input?.joystick?.value_x, let y:Float = input?.joystick?.value_y
        {
            let translation_speed:Float = 0.01
            let fowardDelta = forward * y * translation_speed;
            let rightdleta = right * x * translation_speed;
            self.setPosition(fowardDelta+rightdleta+self.getPosition())
        }
    #endif
       _viewMatrix = matrix_identity_float4x4
       _viewMatrix.rotate(angle: self.getRotationX(), axis: X_AXIS)
       _viewMatrix.rotate(angle: self.getRotationY(), axis: Y_AXIS)
       _viewMatrix.rotate(angle: self.getRotationZ(), axis: Z_AXIS)
       _viewMatrix.translate(direction: -getPosition())
   }
    
    /*override func update(deltaTime: Float) {
       
    }*/
    
    
    
}

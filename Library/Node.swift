import MetalKit

public class Node{
    
    var position:FLOAT3 = FLOAT3(0,0,0)
    
    var scale: FLOAT3 = FLOAT3(1,1,1)
    
    var rotation:FLOAT3 = FLOAT3(0,0,0)
    
    var modelMatrix :matrix_float4x4
    {
        var modelMatrix = matrix_identity_float4x4
       modelMatrix.translate(direction: position)
       modelMatrix.rotate(angle: rotation.x, axis: X_AXIS)
       modelMatrix.rotate(angle: rotation.y, axis: Y_AXIS)
       modelMatrix.rotate(angle: rotation.z, axis: Z_AXIS)
       modelMatrix.scale(axis: scale)
       return modelMatrix
    }
    
    var children :[Node] = []
    
    func addChild(_ child:Node)
    {
        children.append(child)
    }
    
    func update(deltaTime:Float)
    {
        for child:Node in children
        {
            child.update(deltaTime: deltaTime)
        }
    }
    
    func render(_ renderCommandEncoder: MTLRenderCommandEncoder!){
        if let rendable = self as? Renderable
        {
            rendable.doRender(renderCommandEncoder);
        }
    }
    
    func compute(_ computeEncoder: MTLComputeCommandEncoder!)
    {
        if let computable = self as? Computable
        {
            computable.doCompute(computeEncoder)
        }
    }
}

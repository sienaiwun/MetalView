import MetalKit

public class Node{
    
    private var _name:String = "basic node"
    private var _id: String!
    
    private var _position:FLOAT3 = FLOAT3(0,0,0)
    
    private var _scale: FLOAT3 = FLOAT3(1,1,1)
    
    private var _rotation:FLOAT3 = FLOAT3(0,0,0)
    
    private var _modelMatrix :matrix_float4x4 = matrix_identity_float4x4
    
    var parentModelMatrix = matrix_identity_float4x4
    
    init(name: String = ""){
        self._name = name
        self._id = UUID().uuidString
    }
    
    var modelMatrix :matrix_float4x4
    {
        updateModelMatrix();
        _position = FLOAT3(0,0,0)
        _scale = FLOAT3(1,1,1)
        _rotation = FLOAT3(0,0,0)
        return matrix_multiply(parentModelMatrix, _modelMatrix);
    }
    
    func updateModelMatrix()
    {
        _modelMatrix.translate(direction: _position)
        _modelMatrix.rotate(angle: _rotation.x, axis: X_AXIS)
        _modelMatrix.rotate(angle: _rotation.y, axis: Y_AXIS)
        _modelMatrix.rotate(angle: _rotation.z, axis: Z_AXIS)
        _modelMatrix.scale(axis: _scale)
    }
    
    
    var children :[Node] = []
    
    func addChild(_ child:Node)
    {
        children.append(child)
    }
    
    func doUpdate()
    {
        updateModelMatrix();
    }
    
    func update(deltaTime:Float)
    {
        doUpdate()
        for child:Node in children
        {
            child.parentModelMatrix = self.modelMatrix
            child.update(deltaTime: deltaTime)
        }
    }
    
    func render(_ renderCommandEncoder: MTLRenderCommandEncoder!){
        renderCommandEncoder.pushDebugGroup("Rendering \(_name)")
        if let rendable = self as? Renderable
        {
            rendable.doRender(renderCommandEncoder);
        }
        for child in children
        {
            child.render(renderCommandEncoder)
        }
        renderCommandEncoder.popDebugGroup()
    }
    
    func compute(_ computeEncoder: MTLComputeCommandEncoder!)
    {
        computeEncoder.pushDebugGroup("Compute \(_name)")
        if let computable = self as? Computable
        {
            computable.doCompute(computeEncoder)
        }
        for child in children
        {
            child.compute(computeEncoder)
        }
        computeEncoder.popDebugGroup()
    }
}


extension Node {
    func setName(_ name: String){ self._name = name }
    func getName()->String{return self._name}
    func getPosition()->FLOAT3 { return self._position }
      func getPositionX()->Float { return self._position.x }
      func getPositionY()->Float { return self._position.y }
      func getPositionZ()->Float { return self._position.z }
    
    func setPosition(_ position: FLOAT3){
           self._position = position
       }
    func setPosition(_ x: Float,_ y: Float,_ z: Float) { setPosition(FLOAT3(x,y,z)) }
        func setPositionX(_ xPosition: Float) { setPosition(xPosition, getPositionY(), getPositionZ()) }
        func setPositionY(_ yPosition: Float) { setPosition(getPositionX(), yPosition, getPositionZ()) }
        func setPositionZ(_ zPosition: Float) { setPosition(getPositionX(), getPositionY(), zPosition) }
    
    func getRotation()->FLOAT3 { return self._rotation }
      func getRotationX()->Float { return self._rotation.x }
      func getRotationY()->Float { return self._rotation.y }
      func getRotationZ()->Float { return self._rotation.z }
    
    func setRotation(_ rotation: FLOAT3) {
            self._rotation = rotation
        }
        func setRotation(_ x: Float,_ y: Float,_ z: Float) { setRotation(FLOAT3(x,y,z)) }
        func setRotationX(_ xRotation: Float) { setRotation(xRotation, getRotationY(), getRotationZ()) }
        func setRotationY(_ yRotation: Float) { setRotation(getRotationX(), yRotation, getRotationZ()) }
        func setRotationZ(_ zRotation: Float) { setRotation(getRotationX(), getRotationY(), zRotation) }
    
    
    func setScale(_ scale: FLOAT3){ self._scale = scale }
    func setScale(_ r: Float,_ g: Float,_ b: Float) { setScale(FLOAT3(r,g,b)) }
    func setScale(_ scale: Float){setScale(FLOAT3(scale, scale, scale))}
    func setScaleX(_ scaleX: Float){ self._scale.x = scaleX }
    func setScaleY(_ scaleY: Float){ self._scale.y = scaleY }
    func setScaleZ(_ scaleZ: Float){ self._scale.z = scaleZ }
    func getScale()->FLOAT3 { return self._scale }
    func getScaleX()->Float { return self._scale.x }
    func getScaleY()->Float { return self._scale.y }
    func getScaleZ()->Float { return self._scale.z }
    func scaleX(_ delta: Float){ self._scale.x += delta }
    func scaleY(_ delta: Float){ self._scale.y += delta }
    func scaleZ(_ delta: Float){ self._scale.z += delta }
}

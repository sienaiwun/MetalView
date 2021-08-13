import MetalKit



class ObjectScene:Scene
{
    override func buildScene()
    {
        let singleObject:GameObject = GameObject(meshType: .Chest, texture: TextureLibrary.Descriptor(.RT))
        singleObject.setScale(0.01)
        addChild(singleObject)
        _camera.setPositionZ(5)
        addChild(_camera)
        addLight(Sun())
    }
}

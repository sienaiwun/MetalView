import MetalKit



class ObjectScene:Scene
{
    override func buildScene()
    {
        let singleObject:GameObject = GameObject(meshType: .Cruiser, texture: TextureLibrary.Descriptor(.RT))
        addChild(singleObject)
        _camera.setPositionZ(5)
        addChild(_camera)
        addLight(Sun())
    }
}

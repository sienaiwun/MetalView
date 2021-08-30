import MetalKit

class ObjectScene:Scene
{
    override func buildScene()
    {
        let singleObject:GameObject = GameObject(meshType: .Chest)
        singleObject.setScale(0.01)
        addChild(singleObject)
        let planeObject:GameObject = GameObject(meshType: .Rectangle)
        planeObject.setRotationX(Float(Double.pi/2))
        planeObject.setPositionY(-0.1)
        addChild(planeObject)
        camera.setPosition(0,0.5,5)
        addChild(camera)
        addLight(Sun())
    }
}

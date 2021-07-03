import MetalKit

class BoxScene:Node
{
    private var _camera:Camera = Camera()
 
    private var _sceneConstant:SceneConstants = SceneConstants()
    
    init(name:String) {
        super.init()
        self.setName(name)
        buildScene()
    }
    
   
    
    override func doUpdate() {
        _sceneConstant.viewMatrix = _camera.viewMatrix
        _sceneConstant.projectionMatrix = _camera.projectionMatrix
        _sceneConstant.cameraPos = _camera.getPosition()
    }
    
    override func render(_ renderCommandEncoder: MTLRenderCommandEncoder!) {
        renderCommandEncoder.pushDebugGroup("Rendering Scene \(getName())")
        renderCommandEncoder.setVertexBytes(&_sceneConstant, length: SceneConstants.stride(), index: 2)
        super.render(renderCommandEncoder)
        renderCommandEncoder.popDebugGroup()
    }
}

extension BoxScene:Scene
{
    func buildScene() {
        let singleObject:GameObject = GameObject(meshType: .Cruiser, texture: TextureLibrary.Descriptor(.RT))
        addChild(singleObject)
        _camera.setPositionZ(5)
        addChild(_camera)
        
    }
}

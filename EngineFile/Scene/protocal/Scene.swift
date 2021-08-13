import MetalKit

class Scene :Node{
    internal var _camera:Camera = Camera(name:"Camera")
    private var _lightManager = Lighting()
    private var _sceneConstant:SceneConstants = SceneConstants()
    
    func buildScene(){}
    
    override init(name:String) {
        super.init(name:name)
        buildScene()
        
    }
    
    func addLight(_ lightObject: LightObject) {
        self.addChild(lightObject)
        _lightManager.addLightObject(lightObject)
    }
    
    override func doUpdate() {
        _sceneConstant.viewMatrix = _camera.viewMatrix
        _sceneConstant.projectionMatrix = _camera.projectionMatrix
        _sceneConstant.cameraPos = _camera.getPosition()
    }
    
    override func render(_ renderCommandEncoder: MTLRenderCommandEncoder!) {
        renderCommandEncoder.pushDebugGroup("Rendering Scene \(getName())")
        renderCommandEncoder.setVertexBytes(&_sceneConstant, length: SceneConstants.stride(), index: 2)
        _lightManager.setLightData(renderCommandEncoder)
        super.render(renderCommandEncoder)
        renderCommandEncoder.popDebugGroup()
    }
};

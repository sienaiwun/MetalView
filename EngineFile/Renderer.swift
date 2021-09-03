import MetalKit

class Renderer:NSObject, MTKViewDelegate{
    //var triangle:Triangle = Triangle()
    var currentScene:ObjectScene = ObjectScene(name:"Computer Example")
    var input:InputDevice = InputDevice()
    #if IOS_TARGET
     internal var _touches:[UITouch:Touch] = [:]
    #endif
    
    override init() {
        currentScene.camera.input = input
    }

    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    
    
    
    func draw(in view: MTKView) {
        #if IOS_TARGET
        for(_,touch) in _touches
        {
            input.touches.append(touch)
        }
        #endif
        input.update()
        

        guard let drawable = view.currentDrawable, let rpd = view.currentRenderPassDescriptor else {return}
        currentScene.update(deltaTime: 1.0/Float(view.preferredFramesPerSecond))
        
        
        let commandBuffer = Engine.CommandQueue?.makeCommandBuffer()
        commandBuffer?.label = "command buffer"
        let computeEncoder = commandBuffer?.makeComputeCommandEncoder()
        computeEncoder?.label = "Compute Encoder"
        currentScene.compute(computeEncoder)
        computeEncoder?.endEncoding()
        
        let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: rpd);
        commandEncoder?.label = "Graph Encoder"
        currentScene.render(commandEncoder)
        commandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
        input.touches.removeAll()
    }
    
    
    
}


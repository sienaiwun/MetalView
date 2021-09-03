import MetalKit

class Renderer:NSObject, MTKViewDelegate{
    //var triangle:Triangle = Triangle()
    var currentScene:ObjectScene = ObjectScene(name:"Computer Example")
    var screenSize:FLOAT2 = FLOAT2()
  
    
    override init() {
        currentScene.camera.input = Engine.input
    }

    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    
    
    
    func draw(in view: MTKView) {
       
        Engine.input.update()
        guard let drawable = view.currentDrawable, let rpd = view.currentRenderPassDescriptor else {return}
        screenSize = FLOAT2(Float(view.drawableSize.width),Float(view.drawableSize.height))
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
        Engine.input.render(commandEncoder, screenSize: screenSize)
        commandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
        
        Engine.input.clear()
    }
    
    
}


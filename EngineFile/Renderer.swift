import MetalKit

class Renderer:NSObject{
    //var triangle:Triangle = Triangle()
    var currentScene:ObjectScene = ObjectScene(name:"Computer Example")
    var screenSize:FLOAT2 = FLOAT2()
    override init() {
        currentScene.camera.input = Engine.input
    }
}

extension Renderer:MTKViewDelegate
{
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    
    func draw(in view: MTKView) {
       
       guard let drawable = view.currentDrawable, let rpd = view.currentRenderPassDescriptor else {return}
        screenSize = FLOAT2(Float(view.drawableSize.width),Float(view.drawableSize.height))
        let detatime:Float = 1.0/Float(view.preferredFramesPerSecond)
        Engine.input.update(deltaTime: detatime, screenSize: screenSize)
        currentScene.update(deltaTime: detatime)
        let commandBuffer = Engine.CommandQueue?.makeCommandBuffer()
        commandBuffer?.label = "command buffer"
        let computeEncoder = commandBuffer?.makeComputeCommandEncoder()
        computeEncoder?.label = "Compute Encoder"
        currentScene.compute(computeEncoder)
        computeEncoder?.endEncoding()
        
        let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: rpd);
        commandEncoder?.label = "Graph Encoder"
        currentScene.render(commandEncoder)
        Engine.input.render(commandEncoder)
        commandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
        
        Engine.input.clear()
    }
}


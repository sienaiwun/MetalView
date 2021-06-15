import MetalKit

class Renderer:NSObject, MTKViewDelegate{
    //var triangle:Triangle = Triangle()
    var currentScene:Scene = Scene(name:"Computer Example")
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    
    
    
    func draw(in view: MTKView) {
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
    }
    
    
    
}


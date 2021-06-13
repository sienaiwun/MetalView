import MetalKit

class Renderer:NSObject, MTKViewDelegate{
    //var triangle:Triangle = Triangle()
    var singleObject:GameObject = GameObject(meshType: .Rectangle, texture: TextureLibrary.Descriptor(.RT))
    let debugName:String = "Debugger"
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    
    
    
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable, let rpd = view.currentRenderPassDescriptor else {return}
        singleObject.update(deltaTime: 1.0/Float(view.preferredFramesPerSecond))
        
        
        let commandBuffer = Engine.CommandQueue?.makeCommandBuffer()
        commandBuffer?.label = "command buffer"
        let computeEncoder = commandBuffer?.makeComputeCommandEncoder()
        computeEncoder?.label = "Compute Encoder"
        singleObject.compute(computeEncoder)
        computeEncoder?.endEncoding()
        
        let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: rpd);
        commandEncoder?.label = "Graph Encoder"
        commandEncoder?.pushDebugGroup(debugName)
        singleObject.color_texture = TextureLibrary.Descriptor(.RT) 
        singleObject.render(commandEncoder)
        commandEncoder?.popDebugGroup()
        commandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
    
    
    
}


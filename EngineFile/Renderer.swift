import MetalKit

class Renderer:NSObject, MTKViewDelegate{
    //var triangle:Triangle = Triangle()
    var singleObject:GameObject = GameObject(meshType: .Rectangle)
    let debugName:String = "Debugger"
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    
    func compute(_ computerEncoder:MTLComputeCommandEncoder)
    {
        let texture = TextureLibrary.Descriptor(.RT1024)
        let threadGroupCount = MTLSizeMake(16, 16, 1)
        let threadGroups = MTLSizeMake(Int(texture.width) / threadGroupCount.width+1, Int(texture.height) / threadGroupCount.height + 1, 1)
        computerEncoder.setTexture(texture, index: 0)
        computerEncoder.setComputePipelineState(ComputePipelineStateLibrary.PipelineState(.Basic))
        computerEncoder.dispatchThreadgroups(threadGroups, threadsPerThreadgroup: threadGroupCount)
    }
    
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable, let rpd = view.currentRenderPassDescriptor else {return}
        let commandBuffer = Engine.CommandQueue?.makeCommandBuffer()
        commandBuffer?.label = "command buffer"
        let computeEncoder = commandBuffer?.makeComputeCommandEncoder()
        computeEncoder?.label = "Compute Encoder"
        compute(computeEncoder!)
        computeEncoder?.endEncoding()
        
        let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: rpd);
        commandEncoder?.label = "Graph Encoder"
        commandEncoder?.pushDebugGroup(debugName)
        singleObject.texture = TextureLibrary.Descriptor(.RT1024)
        singleObject.update(deltaTime: 1.0/Float(view.preferredFramesPerSecond))
        singleObject.render(commandEncoder)
        commandEncoder?.popDebugGroup()
        commandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
    
    
    
}


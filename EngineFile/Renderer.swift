import MetalKit

class Renderer:NSObject, MTKViewDelegate{
    //var triangle:Triangle = Triangle()
    var singleObject:GameObject = GameObject(meshType: .Rectangle)
    let debugName:String = "Debugger"
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    var texture:MTLTexture?

       let quadSizeX:Float = 100
       let quadSizeZ:Float = 200
       
       let textureSizeX:Int = 100 * 2
       let textureSizeY:Int = 200 * 2
       
    var pipelineState: MTLComputePipelineState!
    
    override init() {
        let textureDescriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: .rgba8Unorm_srgb, width:Int(textureSizeX), height: Int(textureSizeY), mipmapped: false)
              
        textureDescriptor.usage = [MTLTextureUsage.shaderWrite, MTLTextureUsage.shaderRead ]
        texture = Engine.Device.makeTexture(descriptor: textureDescriptor)
        texture?.label = "C"
        
    }
    
    func compute(_ computerEncoder:MTLComputeCommandEncoder)
    {
        let threadGroupCount = MTLSizeMake(16, 16, 1)
         let          threadGroups = MTLSizeMake(Int(textureSizeX) / threadGroupCount.width+1, Int(textureSizeY) / threadGroupCount.height + 1, 1)
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
        singleObject.texture = texture
        singleObject.update(deltaTime: 1.0/Float(view.preferredFramesPerSecond))
        singleObject.render(commandEncoder)
        commandEncoder?.popDebugGroup()
        commandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
    
    
    
}


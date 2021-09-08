import MetalKit

class Renderer:NSObject{
    //var triangle:Triangle = Triangle()
    var currentScene:ObjectScene = ObjectScene(name:"Computer Example")
    var screenSize:FLOAT2 = FLOAT2()
    var bgColorRT:MTLTexture?
    var bgDepthRT:MTLTexture?
    var baseRenderPassDescriptor:MTLRenderPassDescriptor?
    init(_ view: MTKView) {
        super.init()
        screenSize = FLOAT2(Float(view.drawableSize.width),Float(view.drawableSize.height))
        createBaseRenderPass()
        currentScene.camera.input = Engine.input
    }
    
    
    private func createBaseRenderPass()
    {
        let baseColorRTDescriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: Defines.bgPixelFormat, width: Int(screenSize.x), height:Int(screenSize.y), mipmapped: false)
        baseColorRTDescriptor.usage = [.renderTarget, .shaderRead]
        baseColorRTDescriptor.storageMode = .private
        bgColorRT = Engine.Device.makeTexture(descriptor: baseColorRTDescriptor)
    
        let baseDepthRTDescriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: Defines.bgDepthPixelFormatl, width: Int(screenSize.x), height:Int(screenSize.y), mipmapped: false)
        baseDepthRTDescriptor.usage = [.renderTarget]
        baseDepthRTDescriptor.storageMode = .private
        bgDepthRT = Engine.Device.makeTexture(descriptor: baseDepthRTDescriptor)
        
        baseRenderPassDescriptor = MTLRenderPassDescriptor()
        baseRenderPassDescriptor?.colorAttachments[0].texture = bgColorRT!
        baseRenderPassDescriptor?.colorAttachments[0].storeAction = .store
        baseRenderPassDescriptor?.colorAttachments[0].loadAction = .clear
        baseRenderPassDescriptor?.colorAttachments[0].clearColor = Defines.clearColor
        baseRenderPassDescriptor?.depthAttachment.texture = bgDepthRT
        baseRenderPassDescriptor?.depthAttachment.loadAction = .clear
        baseRenderPassDescriptor?.depthAttachment.storeAction = .dontCare
    }
}

extension Renderer:MTKViewDelegate
{
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        screenSize = FLOAT2(Float(size.width),Float(size.height))
        createBaseRenderPass()
    }
    
    
    func draw(in view: MTKView) {
       
       guard let drawable = view.currentDrawable, let rpd = view.currentRenderPassDescriptor else {return}
        screenSize = FLOAT2(Float(view.drawableSize.width),Float(view.drawableSize.height))
        let detatime:Float = 1.0/Float(view.preferredFramesPerSecond)
        Engine.input.update(deltaTime: detatime, screenSize: screenSize)
        currentScene.update(deltaTime: detatime)
        
        
        let commandBuffer = Engine.CommandQueue?.makeCommandBuffer()
        commandBuffer?.label = "command buffer"
        /*
         let computeEncoder = commandBuffer?.makeComputeCommandEncoder()
        computeEncoder?.label = "Compute Encoder"
        currentScene.compute(computeEncoder)
        computeEncoder?.endEncoding()
        */
        
        let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: baseRenderPassDescriptor!);
        commandEncoder?.label = "Graph Encoder"
        currentScene.render(commandEncoder)
        Engine.input.render(commandEncoder)
        commandEncoder?.endEncoding()
     
        
        let blitEncoder = commandBuffer?.makeBlitCommandEncoder()
            blitEncoder?.label = "View Display Copy Encoder"
            blitEncoder?.copy(from: bgColorRT!,
                              to: view.currentDrawable!.texture)
            blitEncoder?.endEncoding()
        
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
        Engine.input.clear()
    }
}


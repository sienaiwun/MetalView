import MetalKit

class MetalView: MTKView {
    var render:Renderer!
    
    required init(coder:NSCoder){
        super.init(coder:coder)
        device = MTLCreateSystemDefaultDevice()
        Engine.Ignite(device: device!)
        clearColor = Defines.clearColor
        colorPixelFormat = Defines.bgPixelFormat
        depthStencilPixelFormat = Defines.bgDepthPixelFormatl
        render = Renderer()
        self.delegate = render
    }
    
    
}

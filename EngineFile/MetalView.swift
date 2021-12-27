import MetalKit

class MetalView:MTKView
{
    
    var renderer:Renderer!
    required init(coder: NSCoder) {
        super.init(coder: coder)
        let device = MTLCreateSystemDefaultDevice()!
        self.device = device
        self.clearColor = Defines.clearColor
        self.colorPixelFormat = Defines.bgPixelFormat
        self.depthStencilPixelFormat = Defines.bgDepthPixelFormatl
        self.framebufferOnly = false
        Engine.Ignite(device: device)
        renderer = Renderer()
        self.delegate = renderer
        
    }
}

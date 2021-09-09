import MetalKit

class MetalView:MTKView
{
    
    var renderer:Renderer!
    required init(coder: NSCoder) {
        super.init(coder: coder)
        let msaaSample = Engine.msaaSample
        print ("msaaSample %d", msaaSample)
        let device = MTLCreateSystemDefaultDevice()!
        self.device = device
        self.clearColor = Defines.clearColor
        self.colorPixelFormat = Defines.bgPixelFormat
        self.depthStencilPixelFormat = Defines.bgDepthPixelFormatl
        self.framebufferOnly = false
        Engine.Ignite(device: device)
        renderer = Renderer(self)
        self.delegate = renderer
        
    }
}

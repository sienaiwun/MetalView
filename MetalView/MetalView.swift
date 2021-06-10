import MetalKit

class MetalView: MTKView {
    var render:Renderer!
    
    required init(coder:NSCoder){
        super.init(coder:coder)
        device = MTLCreateSystemDefaultDevice()
        Engine.Ignite(device: device!)
        clearColor = MTLClearColor(red: 0, green: 0.0, blue: 0.0, alpha: 1)
        colorPixelFormat = Defines.bgPixelColor
        render = Renderer()
        self.delegate = render
    }
    
 
}

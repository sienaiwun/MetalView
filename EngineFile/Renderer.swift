import MetalKit

class Renderer:NSObject, MTKViewDelegate{
    //var triangle:Triangle = Triangle()
    var singleObject:GameObject = GameObject(meshType: .Box)
    let debugName:String = "Debugger"
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    
    func draw(in view: MTKView) {
        //print("drawableSize" + view.drawableSize.width + " " + view.drawableSize.height)
       // NSLog("%f, %f", view.drawableSize.width, view.drawableSize.height);
        let duration = String(format: "%.01f  %.01f",view.drawableSize.width,view.drawableSize.height)
        print(duration)
        guard let drawable = view.currentDrawable, let rpd = view.currentRenderPassDescriptor else {return}
        let commandBuffer = Engine.CommandQueue?.makeCommandBuffer()
        commandBuffer?.label = "rendering buffer"
        let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: rpd);
        commandEncoder?.label = "label encoder"
        commandEncoder?.pushDebugGroup(debugName)
        singleObject.update(deltaTime: 1.0/Float(view.preferredFramesPerSecond))
        singleObject.render(commandEncoder)
        commandEncoder?.popDebugGroup()
        commandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
    
    
    
}


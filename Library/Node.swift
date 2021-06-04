import MetalKit

public class Node{
    func render(_ renderCommandEncoder: MTLRenderCommandEncoder!){
        if let rendable = self as? Renderable
        {
            rendable.doRender(renderCommandEncoder);
        }
    }
}

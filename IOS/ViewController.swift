import MetalKit
import UIKit


class ViewController: UIViewController {

    var mtkView : MTKView!
    var renderer:Renderer!
    
    //internal var _touches:[UITouch:Touch] = [:]

    override func viewDidLoad() {
      super.viewDidLoad()
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for uiTouch in touches{
            let location = uiTouch.location(in: nil)
            let size = uiTouch.view?.bounds.size
            let x:Float = Float(location.x)/Float(size!.width)
            let y:Float = Float(location.y)/Float(size!.height)
            let pos:FLOAT2 = FLOAT2(x,y)
            let touch = Touch(pos: pos, startPos: pos, delta: FLOAT2(0,0))
            if let _ = self.view as? MetalView{
                Engine.input._touches.updateValue(touch, forKey: uiTouch)
            }
           // _touches.
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for uiTouch in touches{
            let location = uiTouch.location(in: nil)
            let prevLocation    = uiTouch.previousLocation(in: nil)
            let size = uiTouch.view?.bounds.size
            let x:Float = Float(location.x)/Float(size!.width)
            let y:Float = Float(location.y)/Float(size!.height)
            let pos:FLOAT2 = FLOAT2(x,y)
            if let _ = self.view as? MetalView{
                let touch = Engine.input._touches[uiTouch]!
                touch.pos = pos
                touch.delta = FLOAT2(Float(location.x-prevLocation.x),Float(location.y-prevLocation.y))
            }
          
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for uiTouch in touches{
           // var touch = _touches[uiTouch]!
            //print(String(format: "x: %f y:%f", touch.delta.x,touch.delta.y))
            if let _ = self.view as? MetalView{
                Engine.input._touches.removeValue(forKey: uiTouch)
                
            }
        }
   
    }
    
}


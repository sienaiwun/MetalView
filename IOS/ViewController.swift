import MetalKit
import UIKit

class Touch
{
    var pos:FLOAT2
    var startPos:FLOAT2
    var delta:FLOAT2
    init(pos:FLOAT2,startPos:FLOAT2,delta:FLOAT2) {
        self.pos = pos
        self.startPos = startPos
        self.delta = delta
    }
};


class ViewController: UIViewController {

    var mtkView : MTKView!
    var renderer:Renderer!
    
    internal var _touches:[UITouch:Touch] = [:]

    override func viewDidLoad() {
      super.viewDidLoad()
      mtkView = MTKView()
      mtkView.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview(mtkView)
      view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[mtkView]|", options: [], metrics: nil, views: ["mtkView" : mtkView]))
      view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[mtkView]|", options: [], metrics: nil, views: ["mtkView" : mtkView]))
      let device = MTLCreateSystemDefaultDevice()!
      mtkView.device = device
      mtkView.clearColor = Defines.clearColor
      mtkView.colorPixelFormat = Defines.bgPixelFormat
      mtkView.depthStencilPixelFormat = Defines.bgDepthPixelFormatl
      
      Engine.Ignite(device: device)
      renderer = Renderer()
      mtkView.delegate = renderer        // Do any additional setup after loading the view.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for uiTouch in touches{
            let location = uiTouch.location(in: nil)
            let size = uiTouch.view?.bounds.size
            let x:Float = Float(location.x)/Float(size!.width)
            let y:Float = Float(location.y)/Float(size!.height)
            let pos:FLOAT2 = FLOAT2(x,y)
            let touch = Touch(pos: pos, startPos: pos, delta: FLOAT2(0,0))
            _touches.updateValue(touch, forKey: uiTouch)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for uiTouch in touches{
            let location = uiTouch.location(in: nil)
            let prevLocation    = uiTouch.preciseLocation(in: nil)
            let size = uiTouch.view?.bounds.size
            let x:Float = Float(location.x)/Float(size!.width)
            let y:Float = Float(location.y)/Float(size!.height)
            let pos:FLOAT2 = FLOAT2(x,y)
            var touch = _touches[uiTouch]!
            touch.pos = pos
            touch.delta = FLOAT2(Float(location.x-prevLocation.x),Float(location.y-prevLocation.y))
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for uiTouch in touches{
            var touch = _touches[uiTouch]!
            print(String(format: "x: %f y:%f", touch.delta.x,touch.delta.y))
            _touches.removeValue(forKey: uiTouch)
        }
   
    }
}


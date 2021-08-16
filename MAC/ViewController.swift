import MetalKit
import Cocoa

class ViewController: NSViewController {

    var mtkView : MTKView!
    var renderer:Renderer!
    
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
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}


import MetalKit
import Cocoa

enum KEYS:UInt16
{
    case W    = 0x0d
    case S    = 0x01
    case A    = 0x00 // A,
    case D    = 0x02 // D
};

class ViewController: NSViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) {
                   self.keyDown(with: $0)
                   return $0
               }
        NSEvent.addLocalMonitorForEvents(matching: .keyUp) {
                   self.keyUp(with: $0)
                   return $0
               }
             // Do any additional setup after loading the view.
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    override func keyDown(with event: NSEvent) {
        if (!event.isARepeat)
        {
            Engine.input.keyPressed.insert(event.keyCode)
        }
    }
    
    override func keyUp(with event: NSEvent) {
        Engine.input.keyPressed.remove(event.keyCode)
    }
    
    override func mouseDragged(with event: NSEvent) {
        //ßprint("%d",event.keyCode)
    }
}


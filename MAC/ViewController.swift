import MetalKit
import Cocoa

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
        print("%d",event.keyCode)
        if (!event.isARepeat)
        {
            Engine.input.keyPressed.insert(event.keyCode)
        }
    }
    
    override func keyUp(with event: NSEvent) {
        Engine.input.keyPressed.remove(event.keyCode)
    }
    
    override func mouseDragged(with event: NSEvent) {
        print("%d",event.keyCode)
    }
}


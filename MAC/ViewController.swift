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
        if (!event.isARepeat)
        {
            Engine.input.keyPressed.insert(event.keyCode)
        }
    }
    
    override func keyUp(with event: NSEvent) {
        Engine.input.keyPressed.remove(event.keyCode)
    }
    
    override func mouseUp(with event: NSEvent) {
        Engine.input.mouseDown = true;
    }
    
    override func mouseDown(with event: NSEvent) {
        Engine.input.mouseDown = true;

        Engine.input.mouseCurPos = FLOAT2(Float(event.locationInWindow.x), Float(event.locationInWindow.y));
        Engine.input.mouseCurPos.x /= Float(event.window!.frame.size.width)
        Engine.input.mouseCurPos.x /= Float(event.window!.frame.size.height)
        Engine.input.mouseCurPos.y = 1.0 - Engine.input.mouseCurPos.y;

        Engine.input.mouseDownPos = Engine.input.mouseCurPos
    }
    
    override func mouseDragged(with event: NSEvent) {
        Engine.input.mouseDeltaX = Float(event.deltaX);
        Engine.input.mouseDeltaY = Float(event.deltaY);

        Engine.input.mouseCurPos = FLOAT2(Float(event.locationInWindow.x), Float(event.locationInWindow.y));
        Engine.input.mouseCurPos.x /= Float(event.window!.frame.size.width)
        Engine.input.mouseCurPos.x /= Float(event.window!.frame.size.height)
        Engine.input.mouseCurPos.y = 1.0 - Engine.input.mouseCurPos.y;
    }
    
    override func rightMouseDragged(with event: NSEvent)
    {
        Engine.input.mouseDeltaX = Float(event.deltaX)
        Engine.input.mouseDeltaY = Float(event.deltaY)
    }
}


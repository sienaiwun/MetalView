import MetalKit

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



class InputDevice
{
    public var name: String = "Basic Vertex Shader"
    public var mouseDeltaX : Float = 0.0
    public var mouseDeltaY : Float = 0.0
    var               mouseDown:Bool = true
    var               mouseDownPos:FLOAT2 = FLOAT2(0,0)
    var               mouseCurPos:FLOAT2 = FLOAT2(0,0)
    var               touches:[Touch] = []
    
    
    public func update() {
        mouseDeltaX = 0.0
        mouseDeltaY = 0.0
        for touch in touches
        {
            mouseDeltaX = touch.delta.x;
            mouseDeltaY = touch.delta.y;
        }
    }
    
    public func clear(){
        touches.removeAll()
    }
    
    
}

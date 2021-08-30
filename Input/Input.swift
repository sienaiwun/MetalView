import MetalKit


class Input
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
        for var touch in touches
        {
            mouseDeltaX = touch.delta.x;
            mouseDeltaY = touch.delta.y;
        }
    }
    
    
}

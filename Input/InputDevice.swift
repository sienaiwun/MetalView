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

#if USE_VIRTUAL_JOYSTICKS && IOS_TARGET
    struct VirtualJoystick
    {
        public var pos:FLOAT2 = FLOAT2(0.2, 0.8);
        public var  radius:Float = 0.1
        public var  deadzoneRadius:Float = 0.01
        public var  value_x:Float! = 0.0
        public var  value_y:Float! = 0.0
    };
#endif

class InputDevice
{
    public var name: String = "Basic Vertex Shader"
    public var mouseDeltaX : Float = 0.0
    public var mouseDeltaY : Float = 0.0
    var               mouseDown:Bool = true
    var               mouseDownPos:FLOAT2 = FLOAT2(0,0)
    var               mouseCurPos:FLOAT2 = FLOAT2(0,0)
    var               touches:[Touch] = []
    
    #if IOS_TARGET
        internal var _touches:[UITouch:Touch] = [:]
    #if USE_VIRTUAL_JOYSTICKS
        internal var joystick:VirtualJoystick! = VirtualJoystick()
        internal var circle:GameObject = GameObject(meshType: .Circle)
    #endif
    #endif
    
    public func update(deltaTime:Float, screenSize:FLOAT2) {
        #if IOS_TARGET
        for(_,touch) in _touches
        {
            Engine.input.touches.append(touch)
        }
        #endif
        mouseDeltaX = 0.0
        mouseDeltaY = 0.0
        #if USE_VIRTUAL_JOYSTICKS
        joystick = VirtualJoystick()
        #endif
        for touch in touches
        {
            var used:Bool = false
            #if USE_VIRTUAL_JOYSTICKS
            let MAX_JOYSTICK_DIST:Float = 0.1
            let downOffset = touch.startPos - joystick.pos;
            let downDist          = simd_length(downOffset);
            if(downDist > joystick.radius)
            {
                mouseDeltaX = touch.delta.x;
                mouseDeltaY = touch.delta.y;
                continue// didnt press joystick
            }
            joystick.pos = touch.startPos;
            var offset:FLOAT2 = touch.pos - joystick.pos;
            let dist = max(simd_length(offset), 0.001);
            offset = offset/dist * min(max(0.0, dist - joystick.deadzoneRadius), MAX_JOYSTICK_DIST);
            joystick.pos      += offset;
            joystick.value_x  = offset.x / MAX_JOYSTICK_DIST;
            joystick.value_y  = -offset.y / MAX_JOYSTICK_DIST;
            used = true;
            #endif
            if(used){
                continue
            }
            mouseDeltaX = touch.delta.x;
            mouseDeltaY = touch.delta.y;
        }
        
        
        let aspectRatio = screenSize.x/screenSize.y
        let position = joystick.pos;
        let scale    = joystick.radius;
        #if USE_VIRTUAL_JOYSTICKS
        circle.reset()
        circle.setPosition(-1.0 + position.x * 2.0, 1.0 - position.y * 2.0,0.0)
        circle.setScale(scale, scale * aspectRatio, 1.0)
        circle.update(deltaTime: deltaTime)
        #endif
    }
    
    public func clear(){
        touches.removeAll()
    }
    
    public func render(_ renderCommandEncoder: MTLRenderCommandEncoder! ) {
        #if USE_VIRTUAL_JOYSTICKS
        renderCommandEncoder.pushDebugGroup("Rendering Input UI")
        renderCommandEncoder.setRenderPipelineState(RenderPipelineStateLibrary.PipelineState(.UI))
        renderCommandEncoder.setDepthStencilState(DepthStencilStateLibrary.depthState(.UI))
        circle.render(renderCommandEncoder)
        renderCommandEncoder.popDebugGroup()
        #endif
    }
    
    
}

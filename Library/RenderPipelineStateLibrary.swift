import MetalKit

enum RenderPipelineStateTypes {
    case Basic
    case UI
}

class RenderPipelineStateLibrary {
    
    private static var renderPipelineStates: [RenderPipelineStateTypes: RenderPipelineState] = [:]
    
    public static func initialize(){
        createDefaultRenderPipelineStates()
    }
    
    private static func createDefaultRenderPipelineStates(){
        renderPipelineStates.updateValue(Basic_RenderPipelineState(), forKey: .Basic)
        renderPipelineStates.updateValue(UI_RenderPipelineState(), forKey: .UI)
    }
    
    public static func PipelineState(_ renderPipelineStateType: RenderPipelineStateTypes)->MTLRenderPipelineState{
        return (renderPipelineStates[renderPipelineStateType]?.renderPipelineState)!
    }
    
}

protocol RenderPipelineState {
    var name: String { get }
    var renderPipelineState: MTLRenderPipelineState? { get }
}

public struct Basic_RenderPipelineState: RenderPipelineState {
    var name: String = "Basic Render Pipeline State"
    var renderPipelineState: MTLRenderPipelineState?
    init() {
        do{
            renderPipelineState = try Engine.Device.makeRenderPipelineState(descriptor: RenderPipelineDescriptorLibrary.Descriptor(.Basic))
        }catch let error as NSError {
            print("ERROR::CREATE::RENDER_PIPELINE_STATE::__\(name)__::\(error)")
        }
    }
}


public struct UI_RenderPipelineState: RenderPipelineState {
    var name: String = "UI Render Pipeline State"
    var renderPipelineState: MTLRenderPipelineState?
    init() {
        do{
            renderPipelineState = try Engine.Device.makeRenderPipelineState(descriptor: RenderPipelineDescriptorLibrary.Descriptor(.UI))
        }catch let error as NSError {
            print("ERROR::CREATE::RENDER_PIPELINE_STATE::__\(name)__::\(error)")
        }
    }
}

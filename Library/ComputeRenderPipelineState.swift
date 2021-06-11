import MetalKit

enum ComputePipelineStateTypes {
    case Basic
}

class ComputePipelineStateLibrary {
    
    private static var computePipelineStates: [ComputePipelineStateTypes: ComputePipelineState] = [:]
    
    public static func initialize(){
        createDefaultRenderPipelineStates()
    }
    
    private static func createDefaultRenderPipelineStates(){
        computePipelineStates.updateValue(Basic_ComputePipelineState(), forKey: .Basic)
    }
    
    public static func PipelineState(_ computePipelineStateType: ComputePipelineStateTypes)->MTLComputePipelineState{
        return (computePipelineStates[computePipelineStateType]?.computePipelineState)!
    }
    
}

protocol ComputePipelineState {
    var name: String { get }
    var computePipelineState: MTLComputePipelineState? { get }
}

public struct Basic_ComputePipelineState: ComputePipelineState {
    var name: String = "Basic Compute Pipeline State"
    var computePipelineState: MTLComputePipelineState?
    init() {
        do{
            computePipelineState = try Engine.Device.makeComputePipelineState(function: ShaderLibrary.Compute(.Basic))
        }catch let error as NSError {
            print("ERROR::CREATE::RENDER_PIPELINE_STATE::__\(name)__::\(error)")
        }
    }
}

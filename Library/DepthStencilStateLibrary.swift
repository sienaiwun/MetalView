import MetalKit

enum DepthStateTypes {
    case Regular
    case UI
}

protocol DepthStencilState {
    var depthStencilState:MTLDepthStencilState!{get}
}

class DepthStencilStateLibrary{
    private static var _library: [DepthStateTypes: DepthStencilState] = [:]
    
    static func initialize() {
        _library.updateValue(RegularDepthState(), forKey: .Regular)
        _library.updateValue(UIDepthState(), forKey: .UI)
    }
    
    static func depthState(_ type: DepthStateTypes)->MTLDepthStencilState{
        return _library[type]!.depthStencilState
    }
}


class RegularDepthState:DepthStencilState
{
    var depthStencilState:MTLDepthStencilState!
    init() {
        let depthStencilDescriptor = MTLDepthStencilDescriptor()
        depthStencilDescriptor.isDepthWriteEnabled = true
        depthStencilDescriptor.depthCompareFunction = .less
        depthStencilDescriptor.label = "regular state"
        depthStencilState = Engine.Device.makeDepthStencilState(descriptor: depthStencilDescriptor)
    }
}


class UIDepthState:DepthStencilState
{
    var depthStencilState:MTLDepthStencilState!
    init() {
        let depthStencilDescriptor = MTLDepthStencilDescriptor()
        depthStencilDescriptor.isDepthWriteEnabled = false
        depthStencilDescriptor.depthCompareFunction = .always
        depthStencilDescriptor.label = "UI state"
        depthStencilState = Engine.Device.makeDepthStencilState(descriptor: depthStencilDescriptor)
    }
}

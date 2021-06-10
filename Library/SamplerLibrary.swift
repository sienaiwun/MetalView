import MetalKit

enum SamplerTypes
{
    case Point
    case Bilinar
}

class SamplerLibrary{
    private static var library:[SamplerTypes:SamplerState] = [:]
    private static func initValues()
    {
        library.updateValue(BilinearSampler(), forKey: .Bilinar)
        library.updateValue(PointSampler(), forKey: .Point)
    }
    public static func initialize(){
        initValues()
    }
    public static func Descriptor(_ type:SamplerTypes)->MTLSamplerState
    {
        return library[type]!.samplerState
    }
}

protocol SamplerState {
    var name:String{get}
    var samplerState:MTLSamplerState!{get}
}

public struct BilinearSampler:SamplerState{
    var name: String = "Linear Sampler State"
    var samplerState: MTLSamplerState!
    
    init()
    {
        let sampleStateDescipt = MTLSamplerDescriptor()
        sampleStateDescipt.minFilter = .linear
        sampleStateDescipt.magFilter = .linear
        sampleStateDescipt.label = name
        samplerState =  Engine.Device.makeSamplerState(descriptor: sampleStateDescipt)
    }
}

public struct PointSampler:SamplerState{
    var name: String = "Point Sampler State"
    var samplerState: MTLSamplerState!
    
    init()
    {
        let sampleStateDescipt = MTLSamplerDescriptor()
        sampleStateDescipt.minFilter = .nearest
        sampleStateDescipt.magFilter = .nearest
        sampleStateDescipt.label = name
        samplerState =  Engine.Device.makeSamplerState(descriptor: sampleStateDescipt)
    }
}

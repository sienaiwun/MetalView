import MetalKit

enum RenderPipelineDescriptorTypes {
    case Basic
    case UI
}


class RenderPipelineDescriptorLibrary {
    
    private static var renderPipelineDescriptors: [RenderPipelineDescriptorTypes : RenderPipelineDescriptor] = [:]
    
    public static func initialize() {
        createDefaultRenderPipelineDescriptors()
    }
    
    private static func createDefaultRenderPipelineDescriptors() {
        
        renderPipelineDescriptors.updateValue(Basic_RenderPipelineDescriptor(), forKey: .Basic)
        renderPipelineDescriptors.updateValue(UI_RenderPipelineDescriptor(), forKey: .UI)
        
    }
    
    public static func Descriptor(_ renderPipelineDescriptorType: RenderPipelineDescriptorTypes)->MTLRenderPipelineDescriptor{
        return renderPipelineDescriptors[renderPipelineDescriptorType]!.renderPipelineDescriptor
    }
    
}

protocol RenderPipelineDescriptor {
    var name:String{get}
    var renderPipelineDescriptor:MTLRenderPipelineDescriptor{get}
}

class Basic_RenderPipelineDescriptor:RenderPipelineDescriptor
{
    var name: String = "basicRenderPipelineDescrpitor"
    
    var renderPipelineDescriptor: MTLRenderPipelineDescriptor
    {
        let renderPipelineDescriptor = MTLRenderPipelineDescriptor()
        renderPipelineDescriptor.colorAttachments[0].pixelFormat = Defines.bgPixelFormat
        renderPipelineDescriptor.sampleCount = Engine.msaaSample
        renderPipelineDescriptor.depthAttachmentPixelFormat = Defines.bgDepthPixelFormatl
        renderPipelineDescriptor.vertexFunction = ShaderLibrary.Vertex(.Basic)
        renderPipelineDescriptor.fragmentFunction = ShaderLibrary.Fragment(.Basic)
        renderPipelineDescriptor.vertexDescriptor = VertexDescriptionLibrary.Descriptor(.Basic)
        return renderPipelineDescriptor;
    }
}


class UI_RenderPipelineDescriptor:RenderPipelineDescriptor
{
    var name: String = "UIRenderPipelineDescrpitor"
    
    var renderPipelineDescriptor: MTLRenderPipelineDescriptor
    {
        let renderPipelineDescriptor = MTLRenderPipelineDescriptor()
        renderPipelineDescriptor.colorAttachments[0].pixelFormat = Defines.bgPixelFormat
        renderPipelineDescriptor.sampleCount = Engine.msaaSample
        renderPipelineDescriptor.depthAttachmentPixelFormat = Defines.bgDepthPixelFormatl
        renderPipelineDescriptor.vertexFunction = ShaderLibrary.Vertex(.UI)
        renderPipelineDescriptor.fragmentFunction = ShaderLibrary.Fragment(.Basic)
        renderPipelineDescriptor.vertexDescriptor = VertexDescriptionLibrary.Descriptor(.Basic)
        return renderPipelineDescriptor;
    }
}

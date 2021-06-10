import MetalKit

enum VertexDescriptorTypes {
    case Basic
}

class VertexDescriptionLibrary{
    private static var vertexDescriptors:[VertexDescriptorTypes:VertexDescription] = [:]
    private static func initValues()
    {
        vertexDescriptors.updateValue(Basic_VertexDescriptor(), forKey: .Basic)
    }
    public static func initialize(){
        initValues()
    }
    public static func Descriptor(_ veretx_type:VertexDescriptorTypes)->MTLVertexDescriptor
    {
        return vertexDescriptors[veretx_type]!.vertexDescription
    }
}

protocol VertexDescription {
    var name:String{get}
    var vertexDescription:MTLVertexDescriptor{get}
}

public struct Basic_VertexDescriptor:VertexDescription{
    var name: String = "Basic Vertex Description"
    
    var vertexDescription: MTLVertexDescriptor
    {
        let vertexDescriptor = MTLVertexDescriptor()
             
          //Position
        vertexDescriptor.attributes[0].format = .float3
        vertexDescriptor.attributes[0].bufferIndex = 0
        vertexDescriptor.attributes[0].offset = 0
      
        //Color
        vertexDescriptor.attributes[1].format = .float4
        vertexDescriptor.attributes[1].bufferIndex = 0
        vertexDescriptor.attributes[1].offset = FLOAT3.size()
        
        vertexDescriptor.attributes[2].format = .float2
        vertexDescriptor.attributes[2].bufferIndex = 0
        vertexDescriptor.attributes[2].offset = FLOAT3.size() + FLOAT4.size()
      
         vertexDescriptor.layouts[0].stride = Vertex.stride()
         return vertexDescriptor
    }
    
    
}

import MetalKit

enum MeshTypes {
    case Triangle
    case Rectangle
}

protocol Mesh {
    var vertexBuffer: MTLBuffer! {get}
    var vertexNum:Int {get}
}

class MeshLibrary {
    
    private static var meshes: [MeshTypes:Mesh] = [:]
    
    public static func Initialize(){
        createDefaultMeshes()
    }
    
    private static func createDefaultMeshes(){
        meshes.updateValue(Triangle(), forKey: .Triangle)
        meshes.updateValue(Rectangle(), forKey: .Rectangle)
    }
    
    public static func Mesh(_ meshType: MeshTypes)->Mesh{
        return meshes[meshType]!
    }
    
}


class Primitive : Mesh {
    var vertexBuffer: MTLBuffer!
    var vertices:[Vertex]!
    var vertexNum:Int {
        get
        {
            return vertices.count;
        }
    }
    func  createVertex()
    {
        
    }
    func  createBuffers(){
        vertexBuffer = Engine.Device?.makeBuffer(bytes: vertices, length: Vertex.stride(vertices.count), options: [])
        vertexBuffer.label = "vertex buffer"
    }
    init()
    {
        createVertex()
        createBuffers()
    }
}

class Triangle: Primitive{
    override func createVertex() {
        vertices = [
                    Vertex(position: FLOAT3( 0, 1,0), color: FLOAT4(1,0,0,1), texCoord:FLOAT2(1,0)),
                    Vertex(position: FLOAT3(-1,-1,0), color: FLOAT4(0,1,0,1), texCoord:FLOAT2(0,1)),
                    Vertex(position: FLOAT3( 1,-1,0), color: FLOAT4(0,0,1,1), texCoord:FLOAT2(0,0)),
                ]
    }
}

class Rectangle: Primitive{
    override func createVertex() {
        vertices = [
                    Vertex(position: FLOAT3( 0.5, 0.5,0), color: FLOAT4(1,0,0,1), texCoord:FLOAT2(1,0)), //Top Right
                    Vertex(position: FLOAT3(-0.5, 0.5,0), color: FLOAT4(0,1,0,1), texCoord:FLOAT2(0,0)), //Top Left
                    Vertex(position: FLOAT3(-0.5,-0.5,0), color: FLOAT4(0,0,1,1), texCoord:FLOAT2(0,1)),  //Bottom Left
                    
                    Vertex(position: FLOAT3( 0.5, 0.5,0), color: FLOAT4(1,0,0,1), texCoord:FLOAT2(1,0)), //Top Right
                    Vertex(position: FLOAT3(-0.5,-0.5,0), color: FLOAT4(0,0,1,1), texCoord:FLOAT2(0,1)), //Bottom Left
                    Vertex(position: FLOAT3( 0.5,-0.5,0), color: FLOAT4(1,0,1,1), texCoord:FLOAT2(1,1)),  //Bottom Right
            
  
                ]
    }
}


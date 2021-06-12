import MetalKit

enum MeshTypes {
    case Triangle
    case Rectangle
    case Box
}

protocol Mesh {
    var vertexBuffer: MTLBuffer! {get}
    var vertexNum:Int {get}
}

class MeshLibrary {
    
    private static var meshes: [MeshTypes:Mesh] = [:]
    
    public static func initialize(){
        createDefaultMeshes()
    }
    
    private static func createDefaultMeshes(){
        meshes.updateValue(Triangle(), forKey: .Triangle)
        meshes.updateValue(Rectangle(), forKey: .Rectangle)
        meshes.updateValue(Box(), forKey: .Box)
    }
    
    public static func Mesh(_ meshType: MeshTypes)->Mesh{
        return meshes[meshType]!
    }
    
}


class Primitive : Mesh {
    var vertexBuffer: MTLBuffer!
    var vertices:[Vertex]! = []
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
    
    func addVertex(position: FLOAT3,
                     color: FLOAT4 = FLOAT4(1,0,1,1),
                     texCoord: FLOAT2 = FLOAT2(0,0)) {
            vertices.append(Vertex(position: position, color: color, texCoord: texCoord))
      }
    init()
    {
        createVertex()
        createBuffers()
    }
}

class Triangle: Primitive{
    override func createVertex() {
        addVertex(position: FLOAT3( 0, 1,0), color: FLOAT4(1,0,0,1), texCoord:FLOAT2(1,0))
        addVertex(position: FLOAT3(-1,-1,0), color: FLOAT4(0,1,0,1), texCoord:FLOAT2(0,1))
        addVertex(position: FLOAT3( 1,-1,0), color: FLOAT4(0,0,1,1), texCoord:FLOAT2(0,0))
    }
}

class Rectangle: Primitive{
    override func createVertex() {
        let loopNum = 1
        for _ in 1...loopNum
        {
            let half_size:Float = 1.0;
            addVertex(position: FLOAT3( half_size, half_size,0), color: FLOAT4(1,0,0,1), texCoord:FLOAT2(1,0)) //Top Right
            addVertex(position: FLOAT3(-half_size, half_size,0), color: FLOAT4(0,1,0,1), texCoord:FLOAT2(0,0)) //Top Left
            addVertex(position: FLOAT3(-half_size,-half_size,0), color: FLOAT4(0,0,1,1), texCoord:FLOAT2(0,1))  //Bottom Left
                        
            addVertex(position: FLOAT3( half_size, half_size,0), color: FLOAT4(1,0,0,1), texCoord:FLOAT2(1,0)) //Top Right
            addVertex(position: FLOAT3(-half_size,-half_size,0), color: FLOAT4(0,0,1,1), texCoord:FLOAT2(0,1)) //Bottom Left
            addVertex(position: FLOAT3( half_size,-half_size,0), color: FLOAT4(1,0,1,1), texCoord:FLOAT2(1,1))  //Bottom Right
        }
    }
}

class Box: Primitive {
    override func createVertex() {
        //Left
        addVertex(position: FLOAT3(-1.0,-1.0,-1.0), color: FLOAT4(1.0, 0.5, 0.0, 1.0))
        addVertex(position: FLOAT3(-1.0,-1.0, 1.0), color: FLOAT4(0.0, 1.0, 0.5, 1.0))
        addVertex(position: FLOAT3(-1.0, 1.0, 1.0), color: FLOAT4(0.0, 0.5, 1.0, 1.0))
        addVertex(position: FLOAT3(-1.0,-1.0,-1.0), color: FLOAT4(1.0, 1.0, 0.0, 1.0))
        addVertex(position: FLOAT3(-1.0, 1.0, 1.0), color: FLOAT4(0.0, 1.0, 1.0, 1.0))
        addVertex(position: FLOAT3(-1.0, 1.0,-1.0), color: FLOAT4(1.0, 0.0, 1.0, 1.0))
        
        //RIGHT
        addVertex(position: FLOAT3( 1.0, 1.0, 1.0), color: FLOAT4(1.0, 0.0, 0.5, 1.0))
        addVertex(position: FLOAT3( 1.0,-1.0,-1.0), color: FLOAT4(0.0, 1.0, 0.0, 1.0))
        addVertex(position: FLOAT3( 1.0, 1.0,-1.0), color: FLOAT4(0.0, 0.5, 1.0, 1.0))
        addVertex(position: FLOAT3( 1.0,-1.0,-1.0), color: FLOAT4(1.0, 1.0, 0.0, 1.0))
        addVertex(position: FLOAT3( 1.0, 1.0, 1.0), color: FLOAT4(0.0, 1.0, 1.0, 1.0))
        addVertex(position: FLOAT3( 1.0,-1.0, 1.0), color: FLOAT4(1.0, 0.5, 1.0, 1.0))
        
        //TOP
        addVertex(position: FLOAT3( 1.0, 1.0, 1.0), color: FLOAT4(1.0, 0.0, 0.0, 1.0))
        addVertex(position: FLOAT3( 1.0, 1.0,-1.0), color: FLOAT4(0.0, 1.0, 0.0, 1.0))
        addVertex(position: FLOAT3(-1.0, 1.0,-1.0), color: FLOAT4(0.0, 0.0, 1.0, 1.0))
        addVertex(position: FLOAT3( 1.0, 1.0, 1.0), color: FLOAT4(1.0, 1.0, 0.0, 1.0))
        addVertex(position: FLOAT3(-1.0, 1.0,-1.0), color: FLOAT4(0.5, 1.0, 1.0, 1.0))
        addVertex(position: FLOAT3(-1.0, 1.0, 1.0), color: FLOAT4(1.0, 0.0, 1.0, 1.0))
        
        //BOTTOM
        addVertex(position: FLOAT3( 1.0,-1.0, 1.0), color: FLOAT4(1.0, 0.5, 0.0, 1.0))
        addVertex(position: FLOAT3(-1.0,-1.0,-1.0), color: FLOAT4(0.5, 1.0, 0.0, 1.0))
        addVertex(position: FLOAT3( 1.0,-1.0,-1.0), color: FLOAT4(0.0, 0.0, 1.0, 1.0))
        addVertex(position: FLOAT3( 1.0,-1.0, 1.0), color: FLOAT4(1.0, 1.0, 0.5, 1.0))
        addVertex(position: FLOAT3(-1.0,-1.0, 1.0), color: FLOAT4(0.0, 1.0, 1.0, 1.0))
        addVertex(position: FLOAT3(-1.0,-1.0,-1.0), color: FLOAT4(1.0, 0.5, 1.0, 1.0))
        
        //BACK
        addVertex(position: FLOAT3( 1.0, 1.0,-1.0), color: FLOAT4(1.0, 0.5, 0.0, 1.0))
        addVertex(position: FLOAT3(-1.0,-1.0,-1.0), color: FLOAT4(0.5, 1.0, 0.0, 1.0))
        addVertex(position: FLOAT3(-1.0, 1.0,-1.0), color: FLOAT4(0.0, 0.0, 1.0, 1.0))
        addVertex(position: FLOAT3( 1.0, 1.0,-1.0), color: FLOAT4(1.0, 1.0, 0.0, 1.0))
        addVertex(position: FLOAT3( 1.0,-1.0,-1.0), color: FLOAT4(0.0, 1.0, 1.0, 1.0))
        addVertex(position: FLOAT3(-1.0,-1.0,-1.0), color: FLOAT4(1.0, 0.5, 1.0, 1.0))
        
        //FRONT
        addVertex(position: FLOAT3(-1.0, 1.0, 1.0), color: FLOAT4(1.0, 0.5, 0.0, 1.0))
        addVertex(position: FLOAT3(-1.0,-1.0, 1.0), color: FLOAT4(0.0, 1.0, 0.0, 1.0))
        addVertex(position: FLOAT3( 1.0,-1.0, 1.0), color: FLOAT4(0.5, 0.0, 1.0, 1.0))
        addVertex(position: FLOAT3( 1.0, 1.0, 1.0), color: FLOAT4(1.0, 1.0, 0.5, 1.0))
        addVertex(position: FLOAT3(-1.0, 1.0, 1.0), color: FLOAT4(0.0, 1.0, 1.0, 1.0))
        addVertex(position: FLOAT3( 1.0,-1.0, 1.0), color: FLOAT4(1.0, 0.0, 1.0, 1.0))
    }

}


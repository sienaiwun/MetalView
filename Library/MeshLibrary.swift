import MetalKit

enum MeshTypes {
    case Triangle
    case Rectangle
    case Box
    case Cruiser
}

protocol Mesh {
    //var vertexBuffer: MTLBuffer! {get}
    //var vertexNum:Int {get}
    func drawPrimitives(_ renderCommandEncoder: MTLRenderCommandEncoder)
    func setInstanceCount(_ count: Int)
    
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
        meshes.updateValue(MeshLoader(modelName: "cruiser"), forKey: .Cruiser)
    }
    
    public static func Mesh(_ meshType: MeshTypes)->Mesh{
        return meshes[meshType]!
    }
    
}


class MeshLoader:Mesh{
    private var _meshes: [Any]!
    private var _instanceCount: Int = 1
    
    init(modelName: String) {
            loadModel(modelName: modelName)
        }
    
    private func loadModel(modelName:String)
    {
        guard let assetURL = Bundle.main.url(forResource: modelName, withExtension: "obj") else {
                   fatalError("Asset \(modelName) does not exist.")
               }
        let descriptor = MTKModelIOVertexDescriptorFromMetal(VertexDescriptionLibrary.Descriptor(.Basic))
       (descriptor.attributes[0] as! MDLVertexAttribute).name = MDLVertexAttributePosition
       (descriptor.attributes[1] as! MDLVertexAttribute).name = MDLVertexAttributeColor
       (descriptor.attributes[2] as! MDLVertexAttribute).name = MDLVertexAttributeTextureCoordinate

       let bufferAllocator = MTKMeshBufferAllocator(device: Engine.Device)
       let asset: MDLAsset = MDLAsset(url: assetURL,
                                     vertexDescriptor: descriptor,
                                     bufferAllocator: bufferAllocator)
          do{
              self._meshes = try MTKMesh.newMeshes(asset: asset,
                                                   device: Engine.Device).metalKitMeshes
          } catch {
              print("ERROR::LOADING_MESH::__\(modelName)__::\(error)")
          }
    }
    
    func setInstanceCount(_ count: Int) {
            self._instanceCount = count
        }
        
    func drawPrimitives(_ renderCommandEncoder: MTLRenderCommandEncoder) {
        guard let meshes = self._meshes as? [MTKMesh] else { return }
        for mesh in meshes {
            for vertexBuffer in mesh.vertexBuffers {
                renderCommandEncoder.setVertexBuffer(vertexBuffer.buffer, offset: vertexBuffer.offset, index: 0)
                for submesh in mesh.submeshes {
                    renderCommandEncoder.drawIndexedPrimitives(type: submesh.primitiveType,
                                                               indexCount: submesh.indexCount,
                                                               indexType: submesh.indexType,
                                                               indexBuffer: submesh.indexBuffer.buffer,
                                                               indexBufferOffset: submesh.indexBuffer.offset,
                                                               instanceCount: self._instanceCount)
                }
            }
        }
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
    
    func setInstanceCount(_ count: Int)
    {
        
    }
    
    func drawPrimitives(_ renderCommandEncoder: MTLRenderCommandEncoder) {
        renderCommandEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        renderCommandEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertexNum)
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


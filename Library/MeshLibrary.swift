import MetalKit

enum MeshTypes {
    case Triangle
    case Rectangle
    case Box
    case Cruiser
}
class Submesh
{
    private var _indices:[UInt32] = []
    private var _indexCount: Int = 0
    public var indexCount: Int { return _indexCount }
    private var _indexBuffer: MTLBuffer!
    public var indexBuffer: MTLBuffer { return _indexBuffer }
    private var _primitiveType: MTLPrimitiveType = .triangle
    public var primitiveType: MTLPrimitiveType { return _primitiveType }
    private var _indexType: MTLIndexType = .uint32
    public var indexType: MTLIndexType { return _indexType }
    private var _indexBufferOffset: Int = 0
    public var indexBufferOffset: Int { return _indexBufferOffset }
    
    private var _material = Material()
    private var _baseColorTexture:MTLTexture!
    
    init(indices:[UInt32]) {
        self._indices = indices
        self._indexCount = indices.count
        createIndexBuffer()
    }
    
    init(mtkSubmesh:MTKSubmesh,
         mdlSubmesh:MDLSubmesh) {
        _indexBuffer = mtkSubmesh.indexBuffer.buffer
        _indexBufferOffset = mtkSubmesh.indexBuffer.offset
        _indexCount = mtkSubmesh.indexCount
        _indexType = mtkSubmesh.indexType
        _primitiveType = mtkSubmesh.primitiveType
        
        createTexture(mdlSubmesh.material!)
        createMateiral(mdlSubmesh.material!)
    }
    
    private func createIndexBuffer()
    {
        if(_indices.count>0)
        {
            _indexBuffer = Engine.Device.makeBuffer(bytes: _indices,
                                                    length: UInt32.stride(_indices.count),
                                                    options: [])
        }
    }
    
    private func texture(sanmatic: MDLMaterialSemantic,
                         material: MDLMaterial?,
                         textureOrigin: MTKTextureLoader.Origin) -> MTLTexture? {
        let textureLoader = MTKTextureLoader(device: Engine.Device)
        guard let materialProperty = material?.property(with: sanmatic) else { return nil }
        guard let sourceTexture = materialProperty.textureSamplerValue?.texture else { return nil }
        let options: [MTKTextureLoader.Option : Any] = [
            MTKTextureLoader.Option.origin : textureOrigin as Any,
            MTKTextureLoader.Option.generateMipmaps : true
        ]
        let tex = try? textureLoader.newTexture(texture: sourceTexture, options: options)
        return tex
    }
    
    private func createTexture(_ mdlMaterial:MDLMaterial)
    {
        _baseColorTexture = texture(sanmatic: .baseColor, material: mdlMaterial, textureOrigin: .bottomLeft)
    }
    
    private func createMateiral(_ mdlMaterial:MDLMaterial)
    {
        if let ambient = mdlMaterial.property(with: .emission)?.float3Value{
            _material.ambient = ambient
        }
        if let diffuse = mdlMaterial.property(with: .baseColor)?.float3Value { _material.diffuse = diffuse }
        if let specular = mdlMaterial.property(with: .specular)?.float3Value { _material.specular = specular }
        if let shininess = mdlMaterial.property(with: .specularExponent)?.floatValue { _material.shininess = shininess }
    }
    
    func applyTextures(renderCommandEncoder:MTLRenderCommandEncoder, customBaseColorTextureType:TextureType)
    {
        renderCommandEncoder.setFragmentSamplerState(SamplerLibrary.Descriptor(.Bilinar), index: 0)
        let baseColorTex = customBaseColorTextureType == .None ? _baseColorTexture : TextureLibrary.Descriptor(customBaseColorTextureType)
            renderCommandEncoder.setFragmentTexture(baseColorTex, index: 0)
    }
    
    func applyMaterial(renderCommandEncoder:MTLRenderCommandEncoder, in customMaterial: Material?)
    {
        var mat = customMaterial == nil ? _material : customMaterial
        renderCommandEncoder.setFragmentBytes(&mat, length: Material.stride(), index: 1)
    }
}

class Mesh {
    private var _vertices:[Vertex] = []
    private var _vertexCount: Int = 0
    private var _vertexBuffer:MTLBuffer? = nil
    private var _instanceCount: Int = 1
    private var _submeshes: [Submesh] = []
    init()
    {
        createMesh();
        createBuffer();
    }
    
    init(modelName:String)
    {
        createMeshFromModel(modelName)
    }
    
    func createMesh(){}
    
    private func createBuffer()
    {
        if(_vertices.count > 0)
        {
            _vertexBuffer = Engine.Device.makeBuffer(bytes: _vertices,
                                                     length: Vertex.stride(_vertices.count),
                                                     options: [])
        }
    }
    
    private func createMeshFromModel(_ modelName:String, ext:String = "obj")
    {
        guard let assetURL = Bundle.main.url(forResource: modelName, withExtension: ext) else {
                   fatalError("Asset \(modelName) does not exist.")
               }
       let descriptor = MTKModelIOVertexDescriptorFromMetal(VertexDescriptionLibrary.Descriptor(.Basic))
       (descriptor.attributes[0] as! MDLVertexAttribute).name = MDLVertexAttributePosition
       (descriptor.attributes[1] as! MDLVertexAttribute).name = MDLVertexAttributeColor
       (descriptor.attributes[2] as! MDLVertexAttribute).name = MDLVertexAttributeTextureCoordinate
       (descriptor.attributes[3] as! MDLVertexAttribute).name = MDLVertexAttributeNormal

       let bufferAllocator = MTKMeshBufferAllocator(device: Engine.Device)
       let asset: MDLAsset = MDLAsset(url: assetURL,
                                   vertexDescriptor: descriptor,
                                   bufferAllocator: bufferAllocator,
                                   preserveTopology: true,
                                   error: nil)
       asset.loadTextures()
       var mtkMeshes: [MTKMesh] = []
       var mdlMeshes: [MDLMesh] = []
        do{
            mtkMeshes = try MTKMesh.newMeshes(asset: asset,
                                              device: Engine.Device).metalKitMeshes
            mdlMeshes = try MTKMesh.newMeshes(asset: asset,
                                              device: Engine.Device).modelIOMeshes
        } catch {
            print("ERROR::LOADING_MESH::__\(modelName)__::\(error)")
        }
        let mtkMesh = mtkMeshes[0]
        let mdlMesh = mdlMeshes[0]
        self._vertexBuffer = mtkMesh.vertexBuffers[0].buffer
        self._vertexCount = mtkMesh.vertexCount
        for i in 0..<mtkMesh.submeshes.count {
            let mtkSubmesh = mtkMesh.submeshes[i]
            let mdlSubmesh = mdlMesh.submeshes![i] as! MDLSubmesh
            let submesh = Submesh(mtkSubmesh: mtkSubmesh,
                                  mdlSubmesh: mdlSubmesh)
            addSubmesh(submesh)
        }
    }
    
    func addSubmesh(_ submesh:Submesh)
    {
        _submeshes.append(submesh)
    }
    
    func drawPrimitives(_ renderCommandEncoder: MTLRenderCommandEncoder,
                        material:Material? = nil,
                        baseColorTextureType:TextureType = .None)
    {
        if(_vertexBuffer != nil)
        {
            renderCommandEncoder.setVertexBuffer(_vertexBuffer, offset: 0, index: 0)
            if(_submeshes.count > 0)
            {
                for submesh in _submeshes
                {
                    submesh.applyTextures(renderCommandEncoder: renderCommandEncoder, customBaseColorTextureType: baseColorTextureType)
                    submesh.applyMaterial(renderCommandEncoder: renderCommandEncoder, in: material)
                    renderCommandEncoder.drawIndexedPrimitives(type: submesh.primitiveType, indexCount: submesh.indexCount, indexType: submesh.indexType, indexBuffer: submesh.indexBuffer, indexBufferOffset: submesh.indexBufferOffset)
                }
            }
            
        }
    }
    func setInstanceCount(_ count: Int)
    {
        _instanceCount = count
    }
    
    func addVertex(position: FLOAT3,
                     color: FLOAT4 = FLOAT4(1,0,1,1),
                     texCoord: FLOAT2 = FLOAT2(0,0),
                     normal:FLOAT3 = FLOAT3(0,1,0)) {
        _vertices.append(Vertex(position: position, color: color, texCoord: texCoord, normal: normal))
      }
    
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
        meshes.updateValue(Mesh(modelName: "cruiser"), forKey: .Cruiser)
    }
    
    public static func Descriptor(_ meshType: MeshTypes)->Mesh{
        return meshes[meshType]!
    }
    
}

class Triangle: Mesh{
    override func createMesh() {
        addVertex(position: FLOAT3( 0, 1,0), color: FLOAT4(1,0,0,1), texCoord:FLOAT2(1,0))
        addVertex(position: FLOAT3(-1,-1,0), color: FLOAT4(0,1,0,1), texCoord:FLOAT2(0,1))
        addVertex(position: FLOAT3( 1,-1,0), color: FLOAT4(0,0,1,1), texCoord:FLOAT2(0,0))
    }
}

class Rectangle: Mesh{
    override func createMesh() {
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
            
            addSubmesh(Submesh(indices: [0,1,2,0,2,3]))
        }
    }
}

class Box: Mesh {
    override func createMesh() {
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


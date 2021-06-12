import MetalKit
enum TextureType{
    case Basic
    case HighRes
    case RT1024
}

class TextureLibrary{
    private static var library:[TextureType:Texture] = [:]
    private static func initValues()
    {
        library.updateValue(AssetTexture("rename", ext: "jpeg"), forKey: .Basic)
        library.updateValue(AssetTexture("high_res", ext: "jpeg"), forKey: .HighRes)
        library.updateValue(RTTexture(textureSizeX:4096,textureSizeY:4096), forKey: .RT1024)
    }
    public static func initialize(){
        initValues()
    }
    public static func Descriptor(_ type:TextureType)->MTLTexture
    {
        return library[type]!.texture
    }
}

protocol Texture {
    var texture: MTLTexture! {get}
}

class RTTexture: Texture
{
    var texture: MTLTexture!
    init( textureSizeX:Int, textureSizeY:Int, pixelFormat:MTLPixelFormat = .rgba8Unorm_srgb)
    {
        let textureDescriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: pixelFormat, width:textureSizeX, height: textureSizeY, mipmapped: false)
              
        textureDescriptor.usage = [MTLTextureUsage.shaderWrite, MTLTextureUsage.shaderRead ]
        textureDescriptor.storageMode = .private
        texture = Engine.Device.makeTexture(descriptor: textureDescriptor)
        texture?.label = "RT Texture"
    }
    
}

class AssetTexture : Texture{
    var texture: MTLTexture!
    
    init(_ textureName: String, ext: String = "jpeg", origin: MTKTextureLoader.Origin = .topLeft){
        let textureLoader = TextureLoader(textureName: textureName, textureExtension: ext, origin: origin)
        let texture: MTLTexture = textureLoader.loadTextureFromBundle()
        setTexture(texture)
    }
    
    func setTexture(_ texture: MTLTexture){
        self.texture = texture
    }
}

class TextureLoader
{
    private var _name:String!
    private var _extention:String!
    private var _texOrigin:MTKTextureLoader.Origin
    
    init(textureName: String, textureExtension: String = "png", origin: MTKTextureLoader.Origin = .topLeft)
    {
        self._name = textureName
        self._extention = textureExtension
        self._texOrigin = origin
    }
    
    public func loadTextureFromBundle()->MTLTexture
    {
        var result:MTLTexture!
        if let url = Bundle.main.url(forResource: _name, withExtension: _extention)
        {
            let textureLoader = MTKTextureLoader(device: Engine.Device)
            
            let options: [MTKTextureLoader.Option : MTKTextureLoader.Origin] = [MTKTextureLoader.Option.origin : _texOrigin]
            
            do{
                result = try textureLoader.newTexture(URL: url, options: options)
                result.label = _name
            }catch let error as NSError {
                print("ERROR::CREATING::TEXTURE::__\(_name!)__::\(error)")
            }
        }
        else {
            print("ERROR::CREATING::TEXTURE::__\(_name!) does not exist")
        }
        return result
    }
}

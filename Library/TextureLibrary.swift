import MetalKit
enum TextureType{
    case Basic
    case HighRes
}

class TextureLibrary{
    private static var library:[TextureType:Texture] = [:]
    private static func initValues()
    {
        library.updateValue(Texture("rename", ext: "jpeg"), forKey: .Basic)
        library.updateValue(Texture("high_res", ext: "jpeg"), forKey: .HighRes)
    }
    public static func initialize(){
        initValues()
    }
    public static func Descriptor(_ type:TextureType)->MTLTexture
    {
        return library[type]!.texture
    }
}

class Texture {
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

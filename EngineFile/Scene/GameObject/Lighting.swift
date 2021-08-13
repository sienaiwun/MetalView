import MetalKit

class LightObject:Node
{
    var lightData = LightData()
    
    override func update(deltaTime: Float) {
        super.update(deltaTime: deltaTime)
        self.lightData.position = self.getPosition()
    }
    
    public func setLightColor(_ color: FLOAT3) { self.lightData.color = color }
    public func setLightColor(_ r: Float,_ g: Float,_ b: Float) { setLightColor(FLOAT3(r,g,b)) }
    public func getLightColor()->FLOAT3 { return self.lightData.color }
    
    // Light Brightness
    public func setLightBrightness(_ brightness: Float) { self.lightData.brightness = brightness }
    public func getLightBrightness()->Float { return self.lightData.brightness }

    // Ambient Intensity
    public func setLightAmbientIntensity(_ intensity: Float) { self.lightData.ambientIntensity = intensity }
    public func getLightAmbientIntensity()->Float { return self.lightData.ambientIntensity }
    
    // Diffuse Intensity
    public func setLightDiffuseIntensity(_ intensity: Float) { self.lightData.diffuseIntensity = intensity }
    public func getLightDiffuseIntensity()->Float { return self.lightData.diffuseIntensity }
    
    // Specular Intensity
    public func setLightSpecularIntensity(_ intensity: Float) { self.lightData.specularIntensity = intensity }
    public func getLightSpecularIntensity()->Float { return self.lightData.specularIntensity }
}

class Sun: LightObject {
    init() {
        super.init(name: "Sun")
        self.setPositionY(10)
    }
}


class Lighting{
    private var _lightObjects:[LightObject] =  []
    
    func addLightObject(_ lightObject:LightObject)
    {
        self._lightObjects.append(lightObject)
    }
    
    private func gatherLightData() ->[LightData]{
        var result:[LightData] = []
        for lightObject in _lightObjects{
            result.append(lightObject.lightData)
        }
        return result
    }
    
    func setLightData(_ encoder:MTLRenderCommandEncoder)
    {
        var lightDatas = gatherLightData()
        var lightCount = lightDatas.count
        encoder.setFragmentBytes(&lightCount, length: Int32.size(), index:2)
        encoder.setFragmentBytes(&lightDatas, length: LightData.stride(lightCount),
                                 index: 3)
    }
    
}

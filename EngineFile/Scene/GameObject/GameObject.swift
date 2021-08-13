import MetalKit

public class GameObject:Node
{
    // Renderable Gmae Object
    var mesh: Mesh!
    var modelConstants:ModelConstants = ModelConstants()
    var computeConstants:BufferConstants = BufferConstants()
    
    var color_texture: MTLTexture!
    var s_time:Float = 0
   
    init(meshType: MeshTypes, texture : MTLTexture) {
        mesh = MeshLibrary.Descriptor(meshType)
        self.color_texture = texture
    }
    
    override func update(deltaTime:Float)
    {
        s_time += deltaTime
        setRotationX(s_time*0.02)
        computeConstants.mRenderSoftShadows = 1;
        computeConstants.mEpsilon = 0.15;
        computeConstants.mSpeed = 1;
        computeConstants.mWidth = Float(color_texture.width);
        computeConstants.mHeight = Float(color_texture.height);
        computeConstants.time = s_time;
        updateModelConstants()
    }
    
    private func updateModelConstants()
    {
        modelConstants.modelMatrix = self.modelMatrix
    }
}


extension GameObject: Renderable
{
    func doRender(_ renderCommandEncoder: MTLRenderCommandEncoder!)
    {
        renderCommandEncoder.setVertexBytes(&modelConstants, length: ModelConstants.stride(), index:1)
        renderCommandEncoder.setRenderPipelineState(RenderPipelineStateLibrary.PipelineState(.Basic))
        renderCommandEncoder.setDepthStencilState(DepthStencilStateLibrary.depthState(.Regular))
        renderCommandEncoder.setFragmentTexture(self.color_texture!, index: 0)
        renderCommandEncoder.setFragmentSamplerState(SamplerLibrary.Descriptor(.Bilinar), index: 0)
        mesh.drawPrimitives(renderCommandEncoder)
    }
}

extension GameObject: Computable
{
    func doCompute(_ computeEncoder: MTLComputeCommandEncoder!) {
        let threadGroupCount = MTLSizeMake(16, 16, 1)
        let threadGroups = MTLSizeMake(Int(color_texture.width) / threadGroupCount.width+1, Int(color_texture.height) / threadGroupCount.height + 1, 1)
        computeEncoder.setTexture(color_texture, index: 0)
        computeEncoder.setBytes(&computeConstants, length: BufferConstants.stride(), index: 0)
        computeEncoder.setComputePipelineState(ComputePipelineStateLibrary.PipelineState(.Basic))
        computeEncoder.dispatchThreadgroups(threadGroups, threadsPerThreadgroup: threadGroupCount)
    }
}
			

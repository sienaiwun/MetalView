import MetalKit

public class GameObject:Node
{
    // Renderable Gmae Object
    var mesh: Mesh!
    var modelConstants:ModelConstants = ModelConstants()
    var computeConstants:BufferConstants = BufferConstants()
    
    var texture: MTLTexture!
    var s_time:Float = 0
   
    init(meshType: MeshTypes, texture : MTLTexture) {
        mesh = MeshLibrary.Mesh(meshType)
        self.texture = texture
    }
    
    override func update(deltaTime:Float)
    {
        s_time += deltaTime
        computeConstants.mRenderSoftShadows = 1;
        computeConstants.mEpsilon = 0.15;
        computeConstants.mSpeed = 1;
        computeConstants.mWidth = Float(texture.width);
        computeConstants.mHeight = Float(texture.height);
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
        renderCommandEncoder.setVertexBuffer(mesh.vertexBuffer, offset: 0, index: 0)
        renderCommandEncoder.setFragmentTexture(texture!, index: 0)
        renderCommandEncoder.setFragmentSamplerState(SamplerLibrary.Descriptor(.Bilinar), index: 0)
        renderCommandEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: mesh.vertexNum)
    }
}

extension GameObject: Computable
{
    func doCompute(_ computeEncoder: MTLComputeCommandEncoder!) {
        let threadGroupCount = MTLSizeMake(16, 16, 1)
        let threadGroups = MTLSizeMake(Int(texture.width) / threadGroupCount.width+1, Int(texture.height) / threadGroupCount.height + 1, 1)
        computeEncoder.setTexture(texture, index: 0)
        computeEncoder.setBytes(&computeConstants, length: BufferConstants.stride(), index: 0)
        computeEncoder.setComputePipelineState(ComputePipelineStateLibrary.PipelineState(.Basic))
        computeEncoder.dispatchThreadgroups(threadGroups, threadsPerThreadgroup: threadGroupCount)
    }
}
			

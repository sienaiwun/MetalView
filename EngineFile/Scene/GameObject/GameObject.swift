import MetalKit

public class GameObject:Node
{
    // Renderable Gmae Object
    var mesh: Mesh!
    var modelConstants:ModelConstants = ModelConstants()
    var computeConstants:BufferConstants = BufferConstants()
    
    var s_time:Float = 0
   
    init(meshType: MeshTypes, texture : MTLTexture) {
        mesh = MeshLibrary.Descriptor(meshType)
    }
    
    override func update(deltaTime:Float)
    {
        s_time += deltaTime
        computeConstants.mRenderSoftShadows = 1;
        computeConstants.mEpsilon = 0.15;
        computeConstants.mSpeed = 1;
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
        renderCommandEncoder.setFragmentSamplerState(SamplerLibrary.Descriptor(.Bilinar), index: 0)
        mesh.drawPrimitives(renderCommandEncoder)
    }
}

extension GameObject: Computable
{
    func doCompute(_ computeEncoder: MTLComputeCommandEncoder!) {
        
    }
}
			

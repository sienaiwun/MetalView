import MetalKit

public class GameObject:Node
{
    // Renderable Gmae Object
    var mesh: Mesh!
    var modelConstants:ModelConstants = ModelConstants()
        
    init(meshType: MeshTypes) {
        mesh = MeshLibrary.Mesh(meshType)
    }
    
    override func update(deltaTime:Float)
    {
        updateModelConstants()
    }
    
    private func updateModelConstants()
    {
        self.position = self.position + (FLOAT3(0.01,0,0))
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
        renderCommandEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: mesh.vertexNum)
    }
}
			
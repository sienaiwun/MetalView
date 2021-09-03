//
//  Engine.swift
//  MetalView
//
//  Created by sws on 2021/6/1.
//

import MetalKit

class Engine
{
    public static var Device: MTLDevice!
    public static var CommandQueue: MTLCommandQueue!
    public static var input:InputDevice = InputDevice()
    
    public static func Ignite(device: MTLDevice)
    {
        self.Device = device
        self.CommandQueue = self.Device.makeCommandQueue()
        
        ShaderLibrary.initialize()
        VertexDescriptionLibrary.initialize()
        RenderPipelineDescriptorLibrary.initialize()
        RenderPipelineStateLibrary.initialize()
        DepthStencilStateLibrary.initialize()
        ComputePipelineStateLibrary.initialize()
        MeshLibrary.initialize()
        TextureLibrary.initialize()
        SamplerLibrary.initialize()
    }
}

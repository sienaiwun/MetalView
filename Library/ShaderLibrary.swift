//
//  ShaderLibrary.swift
//  MetalView
//
//  Created by sws on 2021/6/1.
//

import MetalKit

enum VertexShaderTypes{
    case Basic
    case UI
}

enum FragmentShaderTypes {
    case Basic
}

enum ComputeShaderTypes{
    case Basic
}

class ShaderLibrary{
    public static var DefaultLibrary: MTLLibrary!
    
    private static var vertexShaders :[VertexShaderTypes:Shader] = [:]
    private static var fragmentShaders :[FragmentShaderTypes:Shader] = [:]
    private static var computerShaders :[ComputeShaderTypes:Shader] = [:]
    
    public static func initialize()
    {
        DefaultLibrary = Engine.Device.makeDefaultLibrary()
        InitValues();
    }
    private static func InitValues(){
        vertexShaders.updateValue( Basic_VertexShader(), forKey: .Basic)
        vertexShaders.updateValue( Basic_UIShader(), forKey: .UI)
        fragmentShaders.updateValue( Basic_FragmentShader(), forKey: .Basic)
        computerShaders.updateValue(Basic_ComputeShader(), forKey: .Basic)
    }
    
    public static func Vertex(_ vertexShaderType:VertexShaderTypes) ->MTLFunction{
        return vertexShaders[vertexShaderType]!.function
    }
    
    public static func Fragment(_ fragmentShaderType:FragmentShaderTypes) ->MTLFunction{
        return fragmentShaders[fragmentShaderType]!.function
    }
    
    public static func Compute(_ computeShaderTypes:ComputeShaderTypes) ->MTLFunction{
        return computerShaders[computeShaderTypes]!.function
    }
}


protocol Shader {
    var name: String{get}
    var functionName: String{get}
    var function: MTLFunction{get}
}

public struct Basic_VertexShader:Shader{
    public var name: String = "Basic Vertex Shader"
    public var functionName: String = "basic_vertex_shader"
    public var function: MTLFunction{
        let function = ShaderLibrary.DefaultLibrary.makeFunction(name: functionName)
        function?.label = name
        return function!
    }
}

public struct Basic_UIShader:Shader{
    public var name: String = "Basic UI Shader"
    public var functionName: String = "basic_ui_shader"
    public var function: MTLFunction{
        let function = ShaderLibrary.DefaultLibrary.makeFunction(name: functionName)
        function?.label = name
        return function!
    }
}


public struct Basic_FragmentShader:Shader{
    public var name: String = "Basic Fragment Shader"
    public var functionName: String = "basic_fragment_shader"
    public var function: MTLFunction{
        let function = ShaderLibrary.DefaultLibrary.makeFunction(name: functionName)
        function?.label = name
        return function!
    }
}

public struct Basic_ComputeShader:Shader{
    public var name: String = "Basic Compute Shader"
    public var functionName: String = "testShader"
    public var function: MTLFunction{
        let function = ShaderLibrary.DefaultLibrary.makeFunction(name: functionName)
        function?.label = name
        return function!
    }
}



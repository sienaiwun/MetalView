//
//  ShaderLibrary.swift
//  MetalView
//
//  Created by sws on 2021/6/1.
//

import MetalKit

enum VertexShaderTypes{
    case Basic
}

enum FragmentShaderTypes {
    case Basic
}

class ShaderLibrary{
    public static var DefaultLibrary: MTLLibrary!
    
    private static var vertexShaders :[VertexShaderTypes:Basic_VertexShader] = [:]
    private static var fragmentShaders :[FragmentShaderTypes:Basic_FragmentShader] = [:]

    public static func initialize()
    {
        DefaultLibrary = Engine.Device.makeDefaultLibrary()
        InitValues();
    }
    private static func InitValues(){
        vertexShaders.updateValue( Basic_VertexShader(), forKey: .Basic)
        fragmentShaders.updateValue( Basic_FragmentShader(), forKey: .Basic)
    }
    
    public static func Vertex(_ vertexShaderType:VertexShaderTypes) ->MTLFunction{
        return vertexShaders[vertexShaderType]!.function
    }
    
    public static func Fragment(_ fragmentShaderType:FragmentShaderTypes) ->MTLFunction{
        return fragmentShaders[fragmentShaderType]!.function
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


public struct Basic_FragmentShader:Shader{
    public var name: String = "Basic Fragment Shader"
    public var functionName: String = "basic_fragment_shader"
    public var function: MTLFunction{
        let function = ShaderLibrary.DefaultLibrary.makeFunction(name: functionName)
        function?.label = name
        return function!
    }
}

import MetalKit
protocol Computable {
    func doCompute(_ computeEncoder: MTLComputeCommandEncoder!)
}

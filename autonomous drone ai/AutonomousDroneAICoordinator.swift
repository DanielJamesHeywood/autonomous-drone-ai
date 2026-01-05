import MetalKit

class AutonomousDroneAICoordinator: NSObject, MTKViewDelegate {

    let device = MTLCreateSystemDefaultDevice()

    let commandQueue: MTL4CommandQueue?

    let commandBuffer: MTL4CommandBuffer?

    let commandAllocator: MTL4CommandAllocator?

    override init() {
        commandQueue = device?.makeMTL4CommandQueue()
        commandBuffer = device?.makeCommandBuffer()
        commandAllocator = device?.makeCommandAllocator()
    }

    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}

    func draw(in view: MTKView) {
        guard let device, let commandQueue, let commandBuffer, let commandAllocator else { return }
        commandBuffer.beginCommandBuffer(allocator: commandAllocator)
        commandBuffer.endCommandBuffer()
        commandQueue.commit([commandBuffer])
    }
}

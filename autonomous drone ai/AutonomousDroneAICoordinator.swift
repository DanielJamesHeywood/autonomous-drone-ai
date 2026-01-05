import MetalKit

class AutonomousDroneAICoordinator: NSObject, MTKViewDelegate {

    let device = MTLCreateSystemDefaultDevice()

    let commandQueue: MTL4CommandQueue?

    let commandAllocator: MTL4CommandAllocator?

    override init() {
        commandQueue = device?.makeMTL4CommandQueue()
        commandAllocator = device?.makeCommandAllocator()
    }

    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}

    func draw(in view: MTKView) {
        guard let device, let commandQueue, let commandAllocator else { return }
        guard let commandBuffer = device.makeCommandBuffer() else { return }
        commandBuffer.beginCommandBuffer(allocator: commandAllocator)
        commandBuffer.endCommandBuffer()
        commandQueue.commit([commandBuffer])
    }
}

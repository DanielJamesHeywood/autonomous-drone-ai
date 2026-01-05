import MetalKit

class AutonomousDroneAICoordinator: NSObject, MTKViewDelegate {

    let commandQueue: MTL4CommandQueue?

    let commandBuffer: MTL4CommandBuffer?

    let commandAllocator: MTL4CommandAllocator?

    override init() {
        let device = MTLCreateSystemDefaultDevice()
        commandQueue = device?.makeMTL4CommandQueue()
        commandBuffer = device?.makeCommandBuffer()
        commandAllocator = device?.makeCommandAllocator()
    }

    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}

    func draw(in view: MTKView) {
        guard let commandQueue, let commandBuffer, let commandAllocator else { return }
        commandBuffer.beginCommandBuffer(allocator: commandAllocator)
        commandBuffer.endCommandBuffer()
        commandQueue.commit([commandBuffer])
        guard let drawable = view.currentDrawable else { return }
        drawable.present()
    }
}

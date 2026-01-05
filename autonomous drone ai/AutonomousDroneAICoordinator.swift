import MetalKit

class AutonomousDroneAICoordinator: NSObject, MTKViewDelegate {

    let commandQueue: MTL4CommandQueue?

    let commandBuffer: MTL4CommandBuffer?

    let commandAllocator: MTL4CommandAllocator?

    let sharedEvent: MTLSharedEvent?

    override init() {
        let device = MTLCreateSystemDefaultDevice()
        commandQueue = device?.makeMTL4CommandQueue()
        commandBuffer = device?.makeCommandBuffer()
        commandAllocator = device?.makeCommandAllocator()
        sharedEvent = device?.makeSharedEvent()
    }

    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}

    func draw(in view: MTKView) {
        guard let commandQueue, let commandBuffer, let commandAllocator, let sharedEvent else { return }
        guard let drawable = view.currentDrawable else { return }
        commandAllocator.reset()
        commandBuffer.beginCommandBuffer(allocator: commandAllocator)
        commandBuffer.endCommandBuffer()
        commandQueue.waitForDrawable(drawable)
        commandQueue.commit([commandBuffer])
        commandQueue.signalDrawable(drawable)
        drawable.present()
    }
}

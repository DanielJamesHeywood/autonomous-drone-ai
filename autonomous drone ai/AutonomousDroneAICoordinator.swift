import MetalKit

class AutonomousDroneAICoordinator: NSObject, MTKViewDelegate {

    let state: (
        commandQueue: MTL4CommandQueue,
        commandBuffer: MTL4CommandBuffer,
        commandAllocator: MTL4CommandAllocator,
        sharedEvent: MTLSharedEvent
    )?

    override init() {
        let device = MTLCreateSystemDefaultDevice()
        guard let commandQueue = device?.makeMTL4CommandQueue() else {
            state = nil
            return
        }
        guard let commandBuffer = device?.makeCommandBuffer() else {
            state = nil
            return
        }
        guard let commandAllocator = device?.makeCommandAllocator() else {
            state = nil
            return
        }
        guard let sharedEvent = device?.makeSharedEvent() else {
            state = nil
            return
        }
        state = (commandQueue, commandBuffer, commandAllocator, sharedEvent)
    }

    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}

    func draw(in view: MTKView) {
        guard let state else { return }
        guard let drawable = view.currentDrawable else { return }
        state.commandAllocator.reset()
        state.commandBuffer.beginCommandBuffer(allocator: state.commandAllocator)
        state.commandBuffer.endCommandBuffer()
        state.commandQueue.waitForDrawable(drawable)
        state.commandQueue.commit([state.commandBuffer])
        state.commandQueue.signalDrawable(drawable)
        drawable.present()
    }
}

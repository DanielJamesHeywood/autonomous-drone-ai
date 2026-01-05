import MetalKit

class AutonomousDroneAICoordinator: NSObject, MTKViewDelegate {

    struct State {

        let commandQueue: MTL4CommandQueue
        
        let commandBuffer: MTL4CommandBuffer
        
        let commandAllocator: MTL4CommandAllocator
        
        let sharedEvent: MTLSharedEvent
        
        init?() {
            guard let device = MTLCreateSystemDefaultDevice() else { return nil }
            guard let commandQueue = device.makeMTL4CommandQueue() else { return nil }
            self.commandQueue = commandQueue
            guard let commandBuffer = device.makeCommandBuffer() else { return nil }
            self.commandBuffer = commandBuffer
            guard let commandAllocator = device.makeCommandAllocator() else { return nil }
            self.commandAllocator = commandAllocator
            guard let sharedEvent = device.makeSharedEvent() else { return nil }
            self.sharedEvent = sharedEvent
        }
    }

    let state = State()

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

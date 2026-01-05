import MetalKit

class AutonomousDroneAICoordinator: NSObject, MTKViewDelegate {

    struct State {

        let commandQueue: MTL4CommandQueue
        
        let commandBuffer: MTL4CommandBuffer
        
        let commandAllocator: MTL4CommandAllocator
        
        let sharedEvent: MTLSharedEvent
        
        init?() {
            let device = MTLCreateSystemDefaultDevice()
            guard let _commandQueue = device?.makeMTL4CommandQueue() else { return nil }
            commandQueue = _commandQueue
            guard let _commandBuffer = device?.makeCommandBuffer() else { return nil }
            commandBuffer = _commandBuffer
            guard let _commandAllocator = device?.makeCommandAllocator() else { return nil }
            commandAllocator = _commandAllocator
            guard let _sharedEvent = device?.makeSharedEvent() else { return nil }
            sharedEvent = _sharedEvent
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

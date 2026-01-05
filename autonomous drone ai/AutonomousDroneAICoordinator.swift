import MetalKit

class AutonomousDroneAICoordinator: NSObject, MTKViewDelegate {

    struct State {

        let commandQueue: MTL4CommandQueue
        
        let commandBuffer: MTL4CommandBuffer
        
        let commandAllocators: [MTL4CommandAllocator]
        
        let sharedEvent: MTLSharedEvent
        
        init?() {
            guard let device = MTLCreateSystemDefaultDevice() else { return nil }
            guard let commandQueue = device.makeMTL4CommandQueue() else { return nil }
            self.commandQueue = commandQueue
            guard let commandBuffer = device.makeCommandBuffer() else { return nil }
            self.commandBuffer = commandBuffer
            var commandAllocators = [] as [MTL4CommandAllocator]
            for _ in 0..<3 {
                guard let commandAllocator = device.makeCommandAllocator() else { return nil }
                commandAllocators.append(commandAllocator)
            }
            self.commandAllocators = commandAllocators
            guard let sharedEvent = device.makeSharedEvent() else { return nil }
            self.sharedEvent = sharedEvent
        }
    }

    let state = State()

    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}

    func draw(in view: MTKView) {
        guard let state, let drawable = view.currentDrawable else { return }
        state.commandAllocators[0].reset()
        state.commandBuffer.beginCommandBuffer(allocator: state.commandAllocators[0])
        state.commandBuffer.endCommandBuffer()
        state.commandQueue.waitForDrawable(drawable)
        state.commandQueue.commit([state.commandBuffer])
        state.commandQueue.signalDrawable(drawable)
        drawable.present()
    }
}

import MetalKit

class AutonomousDroneAICoordinator: NSObject, MTKViewDelegate {

    class State {

        var frameNumber = 0 as UInt64

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
            repeat {
                guard let commandAllocator = device.makeCommandAllocator() else { return nil }
                commandAllocators.append(commandAllocator)
            } while commandAllocators.count < 3
            self.commandAllocators = commandAllocators
            guard let sharedEvent = device.makeSharedEvent() else { return nil }
            self.sharedEvent = sharedEvent
        }
    }

    let state = State()

    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}

    func draw(in view: MTKView) {
        guard let state, let drawable = view.currentDrawable else { return }
        let commandAllocator = state.commandAllocators[Int(state.frameNumber % 3)]
        if state.frameNumber >= 3 {
            state.sharedEvent.wait(untilSignaledValue: state.frameNumber - 3, timeoutMS: 10)
            commandAllocator.reset()
        }
        state.commandBuffer.beginCommandBuffer(allocator: commandAllocator)
        state.commandBuffer.endCommandBuffer()
        state.commandQueue.waitForDrawable(drawable)
        state.commandQueue.commit([state.commandBuffer])
        state.commandQueue.signalDrawable(drawable)
        state.commandQueue.signalEvent(state.sharedEvent, value: state.frameNumber)
        state.frameNumber += 1
        drawable.present()
    }
}

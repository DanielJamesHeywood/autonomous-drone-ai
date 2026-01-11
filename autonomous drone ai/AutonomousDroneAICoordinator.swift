import MetalKit

class AutonomousDroneAICoordinator: NSObject, MTKViewDelegate {
    
    class State {
        
        let commandQueue: MTL4CommandQueue
        
        let commandBuffer: MTL4CommandBuffer
        
        let commandAllocators: [MTL4CommandAllocator]
        
        let renderPipelineState: MTLRenderPipelineState
        
        let depthStencilState: MTLDepthStencilState
        
        let sharedEvent: MTLSharedEvent
        
        var frameNumber = 0 as UInt64
        
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
            guard let renderPipelineState = try? device.makeRenderPipelineState(descriptor: MTLRenderPipelineDescriptor()) else { return nil }
            self.renderPipelineState = renderPipelineState
            let depthStencilDescriptor = MTLDepthStencilDescriptor()
            depthStencilDescriptor.depthCompareFunction = .less
            guard let depthStencilState = device.makeDepthStencilState(descriptor: depthStencilDescriptor) else { return nil }
            self.depthStencilState = depthStencilState
        }
    }
    
    let state = State()
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}
    
    func draw(in view: MTKView) {
        guard let state else { return }
        guard let renderPassDescriptor = view.currentMTL4RenderPassDescriptor else { return }
        guard let drawable = view.currentDrawable else { return }
        let commandAllocator = state.commandAllocators[Int(state.frameNumber % 3)]
        if state.frameNumber >= 3 {
            guard state.sharedEvent.wait(untilSignaledValue: state.frameNumber - 3, timeoutMS: 1000) else { return }
            commandAllocator.reset()
        }
        state.commandBuffer.beginCommandBuffer(allocator: commandAllocator)
        guard let renderCommandEncoder = state.commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else { return }
        renderCommandEncoder.setRenderPipelineState(state.renderPipelineState)
        renderCommandEncoder.setDepthStencilState(state.depthStencilState)
        renderCommandEncoder.setViewport(MTLViewport(originX: 0, originY: 0, width: view.drawableSize.width, height: view.drawableSize.height, znear: 0, zfar: 1))
        renderCommandEncoder.endEncoding()
        state.commandBuffer.endCommandBuffer()
        state.commandQueue.waitForDrawable(drawable)
        state.commandQueue.commit([state.commandBuffer])
        state.commandQueue.signalDrawable(drawable)
        state.commandQueue.signalEvent(state.sharedEvent, value: state.frameNumber)
        state.frameNumber += 1
        drawable.present()
    }
}

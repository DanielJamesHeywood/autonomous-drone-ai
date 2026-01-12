import MetalKit

class AutonomousDroneAICoordinator: NSObject, MTKViewDelegate {
    
    class Context {
        
        let commandQueue: MTL4CommandQueue
        
        let commandBuffer: MTL4CommandBuffer
        
        let commandAllocators: [MTL4CommandAllocator]
        
        let renderPipelineState: MTLRenderPipelineState
        
        let depthStencilState: MTLDepthStencilState
        
        let sharedEvent: MTLSharedEvent
        
        var frameNumber = 0 as UInt64
        
        init() {
            let device = MTLCreateSystemDefaultDevice()!
            self.commandQueue = device.makeMTL4CommandQueue()!
            self.commandBuffer = device.makeCommandBuffer()!
            var commandAllocators = [] as [MTL4CommandAllocator]
            repeat {
                commandAllocators.append(device.makeCommandAllocator()!)
            } while commandAllocators.count < 3
            self.commandAllocators = commandAllocators
            self.renderPipelineState = Context.makeRenderPipelineState()
            self.depthStencilState = Context.makeDepthStencilState()
            self.sharedEvent = device.makeSharedEvent()!
        }
        
        static func makeRenderPipelineState() -> MTLRenderPipelineState {
            fatalError()
        }
        
        static func makeDepthStencilState() -> MTLDepthStencilState {
            let descriptor = MTLDepthStencilDescriptor()
            descriptor.depthCompareFunction = .less
            return MTLCreateSystemDefaultDevice()!.makeDepthStencilState(descriptor: descriptor)!
        }
    }
    
    let context = Context()
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}
    
    func draw(in view: MTKView) {
        guard let context else { return }
        guard let renderPassDescriptor = view.currentMTL4RenderPassDescriptor else { return }
        guard let drawable = view.currentDrawable else { return }
        let commandAllocator = context.commandAllocators[Int(context.frameNumber % 3)]
        if context.frameNumber >= 3 {
            guard context.sharedEvent.wait(untilSignaledValue: context.frameNumber - 3, timeoutMS: 1000) else { return }
            commandAllocator.reset()
        }
        context.commandBuffer.beginCommandBuffer(allocator: commandAllocator)
        guard let renderCommandEncoder = context.commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else { return }
        renderCommandEncoder.setRenderPipelineState(context.renderPipelineState)
        renderCommandEncoder.setDepthStencilState(context.depthStencilState)
        renderCommandEncoder.setViewport(MTLViewport(originX: 0, originY: 0, width: view.drawableSize.width, height: view.drawableSize.height, znear: 0, zfar: 1))
        renderCommandEncoder.endEncoding()
        context.commandBuffer.endCommandBuffer()
        context.commandQueue.waitForDrawable(drawable)
        context.commandQueue.commit([context.commandBuffer])
        context.commandQueue.signalDrawable(drawable)
        context.commandQueue.signalEvent(context.sharedEvent, value: context.frameNumber)
        context.frameNumber += 1
        drawable.present()
    }
}

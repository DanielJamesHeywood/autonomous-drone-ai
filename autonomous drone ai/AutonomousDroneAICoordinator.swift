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
            commandQueue = Context.makeCommandQueue()
            commandBuffer = Context.makeCommandBuffer()
            commandAllocators = Context.makeCommandAllocators()
            renderPipelineState = Context.makeRenderPipelineState()
            depthStencilState = Context.makeDepthStencilState()
            sharedEvent = Context.makeSharedEvent()
        }
        
        static func makeCommandQueue() -> MTL4CommandQueue {
            guard let commandQueue = MTLCreateSystemDefaultDevice()?.makeMTL4CommandQueue() else {
                fatalError()
            }
            return commandQueue
        }
        
        static func makeCommandBuffer() -> MTL4CommandBuffer {
            guard let commandBuffer = MTLCreateSystemDefaultDevice()?.makeCommandBuffer() else {
                fatalError()
            }
            return commandBuffer
        }
        
        static func makeCommandAllocators() -> [MTL4CommandAllocator] {
            var commandAllocators = [] as [MTL4CommandAllocator]
            repeat {
                commandAllocators.append(Context.makeCommandAllocator())
            } while commandAllocators.count < 3
            return commandAllocators
        }
        
        static func makeCommandAllocator() -> MTL4CommandAllocator {
            guard let commandAllocator = MTLCreateSystemDefaultDevice()?.makeCommandAllocator() else {
                fatalError()
            }
            return commandAllocator
        }
        
        static func makeRenderPipelineState() -> MTLRenderPipelineState {
            fatalError()
        }
        
        static func makeDepthStencilState() -> MTLDepthStencilState {
            let descriptor = MTLDepthStencilDescriptor()
            descriptor.depthCompareFunction = .less
            guard let depthStencilState = MTLCreateSystemDefaultDevice()?.makeDepthStencilState(descriptor: descriptor) else {
                fatalError()
            }
            return depthStencilState
        }
        
        static func makeSharedEvent() -> MTLSharedEvent {
            guard let sharedEvent = MTLCreateSystemDefaultDevice()?.makeSharedEvent() else {
                fatalError()
            }
            return sharedEvent
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

import MetalKit

class AutonomousDroneAICoordinator: NSObject, MTKViewDelegate {
    
    let device = MTLCreateSystemDefaultDevice()!
    
    let commandQueue: any MTL4CommandQueue
    
    let commandBuffer: any MTL4CommandBuffer
    
    let allocators: [any MTL4CommandAllocator]
    
    let depthStencilState: any MTLDepthStencilState
    
    let sharedEvent: any MTLSharedEvent
    
    var pipelineState: (any MTLRenderPipelineState)?
    
    var frameNumber = 0 as UInt64
    
    override init() {
        self.commandQueue = device.makeMTL4CommandQueue()!
        self.commandBuffer = device.makeCommandBuffer()!
        var allocators = [] as [MTL4CommandAllocator]
        repeat {
            allocators.append(device.makeCommandAllocator()!)
        } while allocators.count < 3
        self.allocators = allocators
        let depthStencilDescriptor = MTLDepthStencilDescriptor()
        depthStencilDescriptor.depthCompareFunction = .less
        depthStencilDescriptor.isDepthWriteEnabled = true
        self.depthStencilState = device.makeDepthStencilState(descriptor: depthStencilDescriptor)!
        self.sharedEvent = device.makeSharedEvent()!
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}
    
    func draw(in view: MTKView) {
        guard let renderPassDescriptor = view.currentMTL4RenderPassDescriptor, let drawable = view.currentDrawable else {
            return
        }
        let allocator = allocators[Int(frameNumber % 3)]
        if frameNumber >= 3 {
            guard sharedEvent.wait(untilSignaledValue: frameNumber - 3, timeoutMS: 1000) else {
                return
            }
            allocator.reset()
        }
        commandBuffer.beginCommandBuffer(allocator: allocator)
        let renderCommandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)!
        if let pipelineState {
            renderCommandEncoder.setRenderPipelineState(pipelineState)
        }
        renderCommandEncoder.setDepthStencilState(depthStencilState)
        renderCommandEncoder.setViewport(
            MTLViewport(
                originX: 0,
                originY: 0,
                width: view.drawableSize.width,
                height: view.drawableSize.height,
                znear: 0,
                zfar: 1
            )
        )
        renderCommandEncoder.endEncoding()
        commandBuffer.endCommandBuffer()
        commandQueue.waitForDrawable(drawable)
        commandQueue.commit([commandBuffer])
        commandQueue.signalDrawable(drawable)
        commandQueue.signalEvent(sharedEvent, value: frameNumber)
        drawable.present()
        frameNumber += 1
    }
}

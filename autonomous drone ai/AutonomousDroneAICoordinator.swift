import MetalKit

class AutonomousDroneAICoordinator: NSObject, MTKViewDelegate {
    
    let commandQueue: MTL4CommandQueue
    
    let commandBuffer: MTL4CommandBuffer
    
    let commandAllocators: [MTL4CommandAllocator]
    
    let renderPipelineState: MTLRenderPipelineState
    
    let depthStencilState: MTLDepthStencilState
    
    let sharedEvent: MTLSharedEvent
    
    var frameNumber = 0 as UInt64
    
    override init() {
        let device = MTLCreateSystemDefaultDevice()!
        self.commandQueue = device.makeMTL4CommandQueue()!
        self.commandBuffer = device.makeCommandBuffer()!
        var commandAllocators = [] as [MTL4CommandAllocator]
        repeat {
            commandAllocators.append(device.makeCommandAllocator()!)
        } while commandAllocators.count < 3
        self.commandAllocators = commandAllocators
        let renderPipelineDescriptor = MTL4RenderPipelineDescriptor()
        do {
            let archive = try device.makeArchive(url: URL(filePath: "renderPipelineStateArchive.bin"))
            self.renderPipelineState = try! archive.makeRenderPipelineState(descriptor: renderPipelineDescriptor)
        } catch {
            let pipelineDataSetSerializerDescriptor = MTL4PipelineDataSetSerializerDescriptor()
            pipelineDataSetSerializerDescriptor.configuration = .captureBinaries
            let pipelineDataSetSerializer = device.makePipelineDataSetSerializer(descriptor: pipelineDataSetSerializerDescriptor)
            let compilerDescriptor = MTL4CompilerDescriptor()
            compilerDescriptor.pipelineDataSetSerializer = pipelineDataSetSerializer
            let compiler = try! device.makeCompiler(descriptor: compilerDescriptor)
            self.renderPipelineState = try! compiler.makeRenderPipelineState(descriptor: renderPipelineDescriptor)
            try! pipelineDataSetSerializer.serializeAsArchiveAndFlush(url: URL(filePath: "renderPipelineStateArchive.bin"))
        }
        let depthStencilDescriptor = MTLDepthStencilDescriptor()
        depthStencilDescriptor.depthCompareFunction = .less
        self.depthStencilState = device.makeDepthStencilState(descriptor: depthStencilDescriptor)!
        self.sharedEvent = device.makeSharedEvent()!
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}
    
    func draw(in view: MTKView) {
        guard let renderPassDescriptor = view.currentMTL4RenderPassDescriptor, let drawable = view.currentDrawable else {
            return
        }
        let commandAllocator = commandAllocators[Int(frameNumber % 3)]
        if frameNumber >= 3 {
            guard sharedEvent.wait(untilSignaledValue: frameNumber - 3, timeoutMS: 1000) else {
                return
            }
            commandAllocator.reset()
        }
        commandBuffer.beginCommandBuffer(allocator: commandAllocator)
        guard let renderCommandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else {
            return
        }
        renderCommandEncoder.setRenderPipelineState(renderPipelineState)
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
        frameNumber += 1
        drawable.present()
    }
}

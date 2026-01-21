import MetalKit

class AutonomousDroneAICoordinator: NSObject, MTKViewDelegate {
    
    let _renderer: Renderer
    
    let commandBuffer: any MTL4CommandBuffer
    
    let argumentTable: any MTL4ArgumentTable
    
    let allocators: [any MTL4CommandAllocator]
    
    let depthStencilState: any MTLDepthStencilState
    
    let indexBuffer: any MTLBuffer
    
    let indirectBuffer: any MTLBuffer
    
    let sharedEvent: any MTLSharedEvent
    
    var pipelineState: (any MTLRenderPipelineState)?
    
    var frameNumber = 0 as UInt64
    
    init(renderer: Renderer) {
        _renderer = renderer
        self.commandBuffer = _renderer._device.makeCommandBuffer()!
        let argumentTableDescriptor = MTL4ArgumentTableDescriptor()
        self.argumentTable = try! _renderer._device.makeArgumentTable(descriptor: argumentTableDescriptor)
        var allocators = [] as [MTL4CommandAllocator]
        repeat {
            allocators.append(_renderer._device.makeCommandAllocator()!)
        } while allocators.count < 3
        self.allocators = allocators
        let depthStencilDescriptor = MTLDepthStencilDescriptor()
        depthStencilDescriptor.depthCompareFunction = .less
        depthStencilDescriptor.isDepthWriteEnabled = true
        self.depthStencilState = _renderer._device.makeDepthStencilState(descriptor: depthStencilDescriptor)!
        self.indexBuffer = _renderer._device.makeBuffer(bytes: [0, 1, 2, 3, 2, 1] as [UInt32], length: 24)!
        var indirectArguments = MTLDrawIndexedPrimitivesIndirectArguments(
            indexCount: 6,
            instanceCount: 1,
            indexStart: 0,
            baseVertex: 0,
            baseInstance: 0
        )
        self.indirectBuffer = _renderer._device.makeBuffer(bytes: &indirectArguments, length: MemoryLayout.size(ofValue: indirectArguments))!
        self.sharedEvent = _renderer._device.makeSharedEvent()!
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
        } else {
            let pipelineState: any MTLRenderPipelineState
            let archiveURL = URL(filePath: "renderPipelineStateArchive.bin")
            let library = _renderer._device.makeDefaultLibrary()!
            let pipelineDescriptor = MTL4RenderPipelineDescriptor()
            pipelineDescriptor.colorAttachments[0].pixelFormat = view.colorPixelFormat
            let fragmentFunctionDescriptor = MTL4LibraryFunctionDescriptor()
            fragmentFunctionDescriptor.library = library
            fragmentFunctionDescriptor.name = "fragmentShader"
            pipelineDescriptor.fragmentFunctionDescriptor = fragmentFunctionDescriptor
            pipelineDescriptor.rasterSampleCount = 4
            let vertexFunctionDescriptor = MTL4LibraryFunctionDescriptor()
            vertexFunctionDescriptor.library = library
            vertexFunctionDescriptor.name = "vertexShader"
            pipelineDescriptor.vertexFunctionDescriptor = vertexFunctionDescriptor
            do {
                let archive = try _renderer._device.makeArchive(url: archiveURL)
                pipelineState = try! archive.makeRenderPipelineState(descriptor: pipelineDescriptor)
            } catch {
                let pipelineDataSetSerializerDescriptor = MTL4PipelineDataSetSerializerDescriptor()
                pipelineDataSetSerializerDescriptor.configuration = .captureBinaries
                let pipelineDataSetSerializer = _renderer._device.makePipelineDataSetSerializer(
                    descriptor: pipelineDataSetSerializerDescriptor
                )
                let compilerDescriptor = MTL4CompilerDescriptor()
                compilerDescriptor.pipelineDataSetSerializer = pipelineDataSetSerializer
                let compiler = try! _renderer._device.makeCompiler(descriptor: compilerDescriptor)
                pipelineState = try! compiler.makeRenderPipelineState(descriptor: pipelineDescriptor)
                try! pipelineDataSetSerializer.serializeAsArchiveAndFlush(url: archiveURL)
            }
            renderCommandEncoder.setRenderPipelineState(pipelineState)
            self.pipelineState = pipelineState
        }
        renderCommandEncoder.setCullMode(.back)
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
        renderCommandEncoder.setArgumentTable(argumentTable, stages: .vertex)
        renderCommandEncoder.drawIndexedPrimitives(
            primitiveType: .triangle,
            indexType: .uint32,
            indexBuffer: indexBuffer.gpuAddress,
            indexBufferLength: indexBuffer.length,
            indirectBuffer: indirectBuffer.gpuAddress
        )
        renderCommandEncoder.endEncoding()
        commandBuffer.endCommandBuffer()
        _renderer._commandQueue.waitForDrawable(drawable)
        _renderer._commandQueue.commit([commandBuffer])
        _renderer._commandQueue.signalDrawable(drawable)
        _renderer._commandQueue.signalEvent(sharedEvent, value: frameNumber)
        drawable.present()
        frameNumber += 1
    }
}

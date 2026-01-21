import MetalKit

class AutonomousDroneAICoordinator: NSObject, MTKViewDelegate {
    
    let _renderer: Renderer
    
    let _commandBuffer: any MTL4CommandBuffer
    
    let _argumentTable: any MTL4ArgumentTable
    
    let _allocators: [any MTL4CommandAllocator]
    
    let _depthStencilState: any MTLDepthStencilState
    
    let _indexBuffer: any MTLBuffer
    
    let _indirectBuffer: any MTLBuffer
    
    let _sharedEvent: any MTLSharedEvent
    
    var _pipelineState: (any MTLRenderPipelineState)?
    
    var _frameNumber = 0 as UInt64
    
    init(renderer: Renderer) {
        _renderer = renderer
        _commandBuffer = _renderer._device.makeCommandBuffer()!
        let argumentTableDescriptor = MTL4ArgumentTableDescriptor()
        _argumentTable = try! _renderer._device.makeArgumentTable(descriptor: argumentTableDescriptor)
        var allocators = [] as [MTL4CommandAllocator]
        repeat {
            allocators.append(_renderer._device.makeCommandAllocator()!)
        } while allocators.count < 3
        _allocators = allocators
        let depthStencilDescriptor = MTLDepthStencilDescriptor()
        depthStencilDescriptor.depthCompareFunction = .less
        depthStencilDescriptor.isDepthWriteEnabled = true
        _depthStencilState = _renderer._device.makeDepthStencilState(descriptor: depthStencilDescriptor)!
        _indexBuffer = _renderer._device.makeBuffer(bytes: [0, 1, 2, 3, 2, 1] as [UInt32], length: 24)!
        var indirectArguments = MTLDrawIndexedPrimitivesIndirectArguments(
            indexCount: 6,
            instanceCount: 1,
            indexStart: 0,
            baseVertex: 0,
            baseInstance: 0
        )
        _indirectBuffer = _renderer._device.makeBuffer(bytes: &indirectArguments, length: MemoryLayout.size(ofValue: indirectArguments))!
        _sharedEvent = _renderer._device.makeSharedEvent()!
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}
    
    func draw(in view: MTKView) {
        Task(
            operation: {
                guard let renderPassDescriptor = view.currentMTL4RenderPassDescriptor, let drawable = view.currentDrawable else {
                    return
                }
                let allocator = _allocators[Int(_frameNumber % 3)]
                if _frameNumber >= 3 {
                    await _sharedEvent.valueSignaled(_frameNumber - 3)
                    allocator.reset()
                }
                _commandBuffer.beginCommandBuffer(allocator: allocator)
                let renderCommandEncoder = _commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)!
                if let _pipelineState {
                    renderCommandEncoder.setRenderPipelineState(_pipelineState)
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
                        pipelineState = try! await compiler.makeRenderPipelineState(descriptor: pipelineDescriptor)
                        try! pipelineDataSetSerializer.serializeAsArchiveAndFlush(url: archiveURL)
                    }
                    renderCommandEncoder.setRenderPipelineState(pipelineState)
                    _pipelineState = pipelineState
                }
                renderCommandEncoder.setCullMode(.back)
                renderCommandEncoder.setDepthStencilState(_depthStencilState)
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
                renderCommandEncoder.setArgumentTable(_argumentTable, stages: .vertex)
                renderCommandEncoder.drawIndexedPrimitives(
                    primitiveType: .triangle,
                    indexType: .uint32,
                    indexBuffer: _indexBuffer.gpuAddress,
                    indexBufferLength: _indexBuffer.length,
                    indirectBuffer: _indirectBuffer.gpuAddress
                )
                renderCommandEncoder.endEncoding()
                _commandBuffer.endCommandBuffer()
                _renderer._commandQueue.waitForDrawable(drawable)
                _renderer._commandQueue.commit([_commandBuffer])
                _renderer._commandQueue.signalDrawable(drawable)
                _renderer._commandQueue.signalEvent(_sharedEvent, value: _frameNumber)
                drawable.present()
                _frameNumber += 1
            }
        )
    }
}

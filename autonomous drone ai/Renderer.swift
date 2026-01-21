import Metal

actor Renderer {
    
    let _device = MTLCreateSystemDefaultDevice()!
    
    let _commandQueue: any MTL4CommandQueue
    
    init() {
        _commandQueue = _device.makeMTL4CommandQueue()!
    }
}

import MetalKit

class AutonomousDroneAICoordinator: NSObject, MTKViewDelegate {

    let device = MTLCreateSystemDefaultDevice()

    let commandQueue: MTL4CommandQueue?

    let commandAllocator: MTL4CommandAllocator?

    override init() {
        commandQueue = device?.makeMTL4CommandQueue()
        commandAllocator = device?.makeCommandAllocator()
    }

    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}

    func draw(in view: MTKView) {}
}

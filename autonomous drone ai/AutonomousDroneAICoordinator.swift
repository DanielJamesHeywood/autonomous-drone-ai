import MetalKit

class AutonomousDroneAICoordinator: NSObject, MTKViewDelegate {

    let device = MTLCreateSystemDefaultDevice()

    let commandQueue: MTL4CommandQueue?

    override init() {
        commandQueue = device?.makeMTL4CommandQueue()
    }

    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}

    func draw(in view: MTKView) {}
}

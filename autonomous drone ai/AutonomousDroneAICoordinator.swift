import MetalKit

class AutonomousDroneAICoordinator: NSObject, MTKViewDelegate {

    let commandQueue: MTL4CommandQueue?

    override init() {
        let device = MTLCreateSystemDefaultDevice()
        commandQueue = device?.makeMTL4CommandQueue()
    }

    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}

    func draw(in view: MTKView) {}
}

import MetalKit

class AutonomousDroneAICoordinator: NSObject, MTKViewDelegate {

    let commandQueue = MTLCreateSystemDefaultDevice()?.makeMTL4CommandQueue()

    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}

    func draw(in view: MTKView) {}
}

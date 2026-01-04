import MetalKit
import SwiftUI

struct AutonomousDroneAIView: NSViewRepresentable {

    func makeNSView(context: Context) -> MTKView {
        let view = MTKView()
        view.delegate = context.coordinator
        view.device = MTLCreateSystemDefaultDevice()
        return view
    }

    func updateNSView(_ view: MTKView, context: Context) {}

    func makeCoordinator() -> AutonomousDroneAICoordinator {
        AutonomousDroneAICoordinator()
    }
}

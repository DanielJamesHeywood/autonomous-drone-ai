import SwiftUI
import MetalKit

struct AutonomousDroneAIView: NSViewRepresentable {

    func makeNSView(context: Context) -> MTKView {
        let view = MTKView()
        view.delegate = context.coordinator
        return view
    }

    func updateNSView(_ view: MTKView, context: Context) {}

    func makeCoordinator() -> AutonomousDroneAIViewDelegate {
        AutonomousDroneAIViewDelegate()
    }
}

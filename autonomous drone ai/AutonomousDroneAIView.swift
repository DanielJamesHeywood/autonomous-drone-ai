import MetalKit
import SwiftUI

struct AutonomousDroneAIView: NSViewRepresentable {
    
    func makeNSView(context: Context) -> MTKView {
        let view = MTKView()
        view.delegate = context.coordinator
        view.device = MTLCreateSystemDefaultDevice()
        view.sampleCount = 4
        return view
    }
    
    func updateNSView(_ view: MTKView, context: Context) {}
    
    func makeCoordinator() -> AutonomousDroneAICoordinator {
        AutonomousDroneAICoordinator()
    }
}

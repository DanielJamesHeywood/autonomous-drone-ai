import SwiftUI
import MetalKit

struct AutonomousDroneAIView: NSViewRepresentable {

    func makeNSView(context: Context) -> MTKView {
        let view = MTKView()
        return view
    }

    func updateNSView(_ view: MTKView, context: Context) {}
}

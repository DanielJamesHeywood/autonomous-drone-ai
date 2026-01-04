import SwiftUI
import MetalKit

struct ContentView: NSViewRepresentable {

    func makeNSView(context: Context) -> MTKView {
        let view = MTKView()
        return view
    }

    func updateNSView(_ nsView: MTKView, context: Context) {}
}

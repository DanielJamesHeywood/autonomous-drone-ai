import SwiftUI
import MetalKit

struct ContentView: NSViewRepresentable {
    
    func makeNSView(context: Context) -> MTKView { MTKView() }
    
    func updateNSView(_ nsView: MTKView, context: Context) {}
}

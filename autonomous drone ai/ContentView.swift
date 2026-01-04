import SwiftUI
import MetalKit

internal struct ContentView: NSViewRepresentable {
    
    internal func makeNSView(context: Context) -> MTKView { MTKView() }
    
    internal func updateNSView(_ nsView: MTKView, context: Context) {}
}

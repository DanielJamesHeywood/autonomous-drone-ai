import Network

public class TelloVideoStream {
    
    @usableFromInline
    internal let _listener: NWListener
    
    @inlinable
    public init() throws {
        _listener = try NWListener(using: .udp, on: 11111)
        _listener.newConnectionHandler = { _ in }
        _listener.start(queue: DispatchQueue(label: "tello.videostream.listener", qos: .utility))
    }
}

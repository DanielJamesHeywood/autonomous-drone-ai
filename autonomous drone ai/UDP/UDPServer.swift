import Network

public class UDPServer {
    
    @usableFromInline
    internal let _listener: NWListener
    
    @inlinable
    public init(on port: NWEndpoint.Port) throws {
        _listener = try NWListener(using: .udp, on: port)
        _listener.start(queue: DispatchQueue(label: ""))
    }
    
    @inlinable
    deinit {
        _listener.cancel()
    }
}

import Network

public class UDPServer {
    
    @usableFromInline
    internal let _listener: NWListener
    
    @inlinable
    public init(on port: NWEndpoint.Port) throws {
        _listener = try NWListener(using: .udp, on: port)
        _listener.newConnectionHandler = { connection in }
        _listener.start(queue: DispatchQueue(label: "udpserver.listener", qos: .utility))
    }
    
    @inlinable
    deinit {
        _listener.cancel()
    }
}

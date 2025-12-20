import Network

public class UDPServer {
    
    @usableFromInline
    internal let _listener: NWListener
    
    @inlinable
    public init(on port: NWEndpoint.Port = .any) throws {
        _listener = try NWListener(using: .udp, on: port)
    }
}

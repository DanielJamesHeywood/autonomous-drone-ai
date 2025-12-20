import Network

public class UDPServer {
    
    @usableFromInline
    internal let _listener: NWListener
    
    @inlinable
    public init() throws {
        _listener = try NWListener(using: .udp)
    }
}

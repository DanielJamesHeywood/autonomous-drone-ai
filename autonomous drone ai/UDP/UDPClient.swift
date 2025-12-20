import Network

public class UDPClient {
    
    @usableFromInline
    internal let _connection: NWConnection
    
    @inlinable
    public init(for endpoint: NWEndpoint) {
        _connection = NWConnection(to: endpoint, using: .udp)
    }
    
    @inlinable
    deinit {
        _connection.cancel()
    }
}

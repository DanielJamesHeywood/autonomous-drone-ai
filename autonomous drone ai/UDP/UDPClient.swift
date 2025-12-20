import Network

public class UDPClient {
    
    @usableFromInline
    internal let _connection: NetworkConnection<UDP>
    
    @inlinable
    public init(for endpoint: NWEndpoint) {
        _connection = NetworkConnection(to: endpoint, using: { UDP() })
    }
}

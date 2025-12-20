import Network

public class UDPClient {
    
    @usableFromInline
    internal let _listener: NetworkListener<UDP>
    
    @inlinable
    public init() async throws {
        _listener = try NetworkListener(using: { UDP() })
        try await _listener.run { connection in }
    }
}

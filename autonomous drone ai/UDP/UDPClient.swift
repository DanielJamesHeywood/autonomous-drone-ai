import Network

public class UDPClient {
    
    @usableFromInline
    internal let _listener: NetworkListener<UDP>
    
    @inlinable
    public init() throws {
        _listener = try NetworkListener(using: { UDP() })
    }
}

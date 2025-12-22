import Network

public struct Endpoint {
    
    @usableFromInline
    internal let _endpoint: NWEndpoint
    
    @inlinable
    public init(host: NWEndpoint.Host, port: Port) {
        _endpoint = .hostPort(host: host, port: NWEndpoint.Port(rawValue: port).unsafelyUnwrapped)
    }
}

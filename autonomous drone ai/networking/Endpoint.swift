import Network

public struct Endpoint {
    
    @usableFromInline
    internal let _endpoint: NWEndpoint
    
    @inlinable
    public init(host: Host, port: Port) {
        switch host {
        case let .ipv4(a, b, c, d):
            _endpoint = .hostPort(
                host: NWEndpoint.Host("\(a).\(b).\(c).\(d)"),
                port: NWEndpoint.Port(rawValue: port).unsafelyUnwrapped
            )
        case let .ipv6(a, b, c, d, e, f):
            _endpoint = .hostPort(
                host: NWEndpoint.Host("\(a).\(b).\(c).\(d).\(e).\(f)"),
                port: NWEndpoint.Port(rawValue: port).unsafelyUnwrapped
            )
        }
    }
}

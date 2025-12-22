import Network

public struct Endpoint {
    
    public enum Host {
        case ipv4(UInt8, UInt8, UInt8, UInt8)
        case ipv6(UInt8, UInt8, UInt8, UInt8, UInt8, UInt8)
    }
    
    public typealias Port = UInt16

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

extension Endpoint {
    
    @inlinable
    internal func _convertToNWEndpoint() -> NWEndpoint { _endpoint }
}

extension Endpoint.Host {
    
    @inlinable
    internal func _convertToNWEndpointHost() -> NWEndpoint.Host {
        switch self {
        case let .ipv4(a, b, c, d): return NWEndpoint.Host("\(a).\(b).\(c).\(d)")
        case let .ipv6(a, b, c, d, e, f): return NWEndpoint.Host("\(a).\(b).\(c).\(d).\(e).\(f)")
        }
    }
}

extension Endpoint.Port {
    
    @inlinable
    internal func _convertToNWEndpointPort() -> NWEndpoint.Port { NWEndpoint.Port(rawValue: self).unsafelyUnwrapped }
}

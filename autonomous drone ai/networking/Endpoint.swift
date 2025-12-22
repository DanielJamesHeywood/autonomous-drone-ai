import Network

public struct Endpoint {
    
    public enum Host {
        case ipv4(UInt8, UInt8, UInt8, UInt8)
        case ipv6(UInt8, UInt8, UInt8, UInt8, UInt8, UInt8)
    }
    
    public typealias Port = UInt16
    
    public var host: Host
    
    public var port: Port
    
    @inlinable
    public init(host: Host, port: Port) {
        self.host = host
        self.port = port
    }
}

extension Endpoint {
    
    @inlinable
    internal func _convertToNWEndpoint() -> NWEndpoint {
        return .hostPort(host: host._convertToNWEndpointHost(), port: port._convertToNWEndpointPort())
    }
}

extension Endpoint.Host {
    
    @inlinable
    internal func _convertToNWEndpointHost() -> NWEndpoint.Host {
        switch self {
        case let .ipv4(a, b, c, d):
            return NWEndpoint.Host("\(a).\(b).\(c).\(d)")
        case let .ipv6(a, b, c, d, e, f):
            return NWEndpoint.Host("\(a).\(b).\(c).\(d).\(e).\(f)")
        }
    }
}

extension Endpoint.Port {
    
    @inlinable
    internal func _convertToNWEndpointPort() -> NWEndpoint.Port {
        return NWEndpoint.Port(rawValue: self).unsafelyUnwrapped
    }
}

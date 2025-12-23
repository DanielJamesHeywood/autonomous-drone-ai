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
        case let .ipv4(octet1, octet2, octet3, octet4):
            return NWEndpoint.Host("\(octet1).\(octet2).\(octet3).\(octet4)")
        case let .ipv6(octet1, octet2, octet3, octet4, octet5, octet6):
            return NWEndpoint.Host("\(octet1).\(octet2).\(octet3).\(octet4).\(octet5).\(octet6)")
        }
    }
}

extension Endpoint.Port {
    
    @inlinable
    internal func _convertToNWEndpointPort() -> NWEndpoint.Port {
        return NWEndpoint.Port(rawValue: self).unsafelyUnwrapped
    }
}

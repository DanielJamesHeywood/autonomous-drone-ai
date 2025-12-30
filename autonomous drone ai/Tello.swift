import Network

public let state = State(_empty: ())

public struct State {
    
    @usableFromInline
    internal let _connection = NetworkConnection(
        to: .hostPort(host: "192.168.10.1", port: .any),
        using: .parameters { UDP() } .localPort(8890)
    )
    
    @inlinable
    internal init(_empty: ()) {}
}

public let videoStream = VideoStream(_empty: ())

public struct VideoStream {
    
    @usableFromInline
    internal let _connection = NetworkConnection(
        to: .hostPort(host: "192.168.10.1", port: .any),
        using: .parameters { UDP() } .localPort(11111)
    )
    
    @inlinable
    internal init(_empty: ()) {}
}

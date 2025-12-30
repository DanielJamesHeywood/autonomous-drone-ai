import Network

public class Tello {
    
    public struct State {
        
        public struct Iterator {}
        
        @inlinable
        internal init(_empty: ()) {}
    }
    
    public struct VideoStream {
        
        public struct Iterator {}
        
        @inlinable
        internal init(_empty: ()) {}
    }
    
    @usableFromInline
    internal let _stateConnection = NetworkConnection(
        to: .hostPort(host: "192.168.10.1", port: .any),
        using: .parameters { UDP() } .localPort(8890)
    )
    
    @usableFromInline
    internal let _videoStreamConnection = NetworkConnection(
        to: .hostPort(host: "192.168.10.1", port: .any),
        using: .parameters { UDP() } .localPort(11111)
    )
    
    public let state = State(_empty: ())
    
    public let videoStream = VideoStream(_empty: ())
    
}

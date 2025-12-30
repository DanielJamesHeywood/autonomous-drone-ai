import Foundation
import Network
import VideoToolbox

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
    internal let _connection = NetworkConnection(to: .hostPort(host: "192.168.10.1", port: 8889), using: { UDP() })
    
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
    
    @inlinable
    internal init(_empty: ()) {}
    
    public let state = State(_empty: ())
    
    public let videoStream = VideoStream(_empty: ())
    
}

public let tello = Tello(_empty: ())

import Network

public class TelloVideoStream {
    
    @usableFromInline
    internal let _stream: AsyncThrowingStream<Any, Error>
    
    @inlinable
    public init() {
        _stream = AsyncThrowingStream { continuation in
            do {
                let listener = try NWListener(using: .udp, on: 11111)
                listener.stateUpdateHandler = { state in
                    switch state {
                    case .setup: break
                    case .waiting(_): break
                    case .ready: break
                    case let .failed(error):
                        continuation.finish(throwing: error)
                    case .cancelled:
                        continuation.finish()
                    @unknown
                    default:
                        fatalError()
                    }
                }
                listener.newConnectionHandler = { connection in }
                listener.start(queue: DispatchQueue(label: "tello.videostream.listener", qos: .utility))
            } catch {
                continuation.finish(throwing: error)
            }
        }
    }
}

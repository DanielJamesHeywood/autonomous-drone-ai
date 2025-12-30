import Network

public struct TelloVideoStream: AsyncSequence {
    
    public struct Iterator: AsyncIteratorProtocol {
        
        @usableFromInline
        internal var _iterator: AsyncThrowingStream<Any, Error>.Iterator
        
        @inlinable
        internal init(_base: TelloVideoStream) {
            _iterator = _base._stream.makeAsyncIterator()
        }
        
        @inlinable
        public mutating func next() async throws -> Any? {
            return try await _iterator.next()
        }
        
        @inlinable
        public mutating func next(isolation actor: isolated Actor?) async throws -> Any? {
            return try await _iterator.next(isolation: actor)
        }
    }
    
    @usableFromInline
    internal let _stream: AsyncThrowingStream<Any, Error>
    
    @inlinable
    public init() {
        _stream = AsyncThrowingStream { continuation in
            do {
                let listener = try NWListener(using: .udp, on: 11111)
                listener.stateUpdateHandler = { state in
                    if case let .failed(error) = state {
                        continuation.finish(throwing: error)
                    }
                    switch state {
                    case let .failed(error):
                        continuation.finish(throwing: error)
                    default: break
                    }
                }
                listener.newConnectionHandler = { connection in }
                listener.start(queue: DispatchQueue(label: "tello.videostream.listener", qos: .utility))
            } catch {
                continuation.finish(throwing: error)
            }
        }
    }
    
    @inlinable
    public func makeAsyncIterator() -> Iterator { Iterator(_base: self) }
}

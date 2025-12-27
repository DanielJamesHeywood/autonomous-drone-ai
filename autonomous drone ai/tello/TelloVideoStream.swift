import Network

public class TelloVideoStream {
    
    @usableFromInline
    internal let _stream: AsyncThrowingStream<Any, Error>
    
    @inlinable
    public init() {
        _stream = AsyncThrowingStream {}
    }
}

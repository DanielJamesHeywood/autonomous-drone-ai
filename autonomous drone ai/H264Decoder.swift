import VideoToolbox

public class H264Decoder {
    
    @usableFromInline
    internal var _decompressionSession: VTDecompressionSession?
    
    @inlinable
    deinit {
        if let _decompressionSession {
            VTDecompressionSessionInvalidate(_decompressionSession)
        }
    }
    
    @inlinable
    public func waitForOutstandingFrames() async throws {
        try await withUnsafeThrowingContinuation { continuation in
            do {
                try _waitForOutstandingFrames()
                continuation.resume()
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
    
    @inlinable
    internal func _waitForOutstandingFrames() throws {
        if let _decompressionSession {
            let status = VTDecompressionSessionWaitForAsynchronousFrames(_decompressionSession)
            guard status == noErr else { throw OSError(status) }
        }
    }
}

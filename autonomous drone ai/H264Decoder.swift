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
    public func waitForOutstandingFrames() throws {
        if let _decompressionSession {
            let status = VTDecompressionSessionWaitForAsynchronousFrames(_decompressionSession)
            guard status == noErr else { throw OSError(status) }
        }
    }
}

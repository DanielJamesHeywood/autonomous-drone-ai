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
}

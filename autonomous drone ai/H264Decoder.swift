import VideoToolbox

public class H264Decoder {
    
    @usableFromInline
    internal let _decompressionSession: VTDecompressionSession
    
    @inlinable
    public init() throws {
        var status: OSStatus
        var videoFormatDescription: CMVideoFormatDescription?
        status = CMVideoFormatDescriptionCreateFromH264ParameterSets(
            allocator: nil,
            parameterSetCount: <#T##Int#>,
            parameterSetPointers: <#T##UnsafePointer<UnsafePointer<UInt8>>#>,
            parameterSetSizes: <#T##UnsafePointer<Int>#>,
            nalUnitHeaderLength: <#T##Int32#>,
            formatDescriptionOut: &videoFormatDescription
        )
        guard status == noErr else { throw OSError(status) }
        var decompressionSession: VTDecompressionSession?
        status = VTDecompressionSessionCreate(
            allocator: nil,
            formatDescription: videoFormatDescription.unsafelyUnwrapped,
            decoderSpecification: [
                kVTVideoDecoderSpecification_EnableHardwareAcceleratedVideoDecoder: kCFBooleanTrue.unsafelyUnwrapped
            ] as CFDictionary,
            imageBufferAttributes: [
                kCVPixelBufferPixelFormatTypeKey: kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange,
                kCVPixelBufferMetalCompatibilityKey: kCFBooleanTrue.unsafelyUnwrapped
            ] as CFDictionary,
            outputCallback: <#T##UnsafePointer<VTDecompressionOutputCallbackRecord>?#>,
            decompressionSessionOut: &decompressionSession
        )
        guard status == noErr else { throw OSError(status) }
        _decompressionSession = decompressionSession.unsafelyUnwrapped
    }
    
    @inlinable
    deinit {
        VTDecompressionSessionInvalidate(_decompressionSession)
    }
    
    @inlinable
    public func decodeFrame() throws {
        let status = VTDecompressionSessionDecodeFrame(
            _decompressionSession,
            sampleBuffer: <#T##CMSampleBuffer#>,
            flags: [._EnableAsynchronousDecompression, ._EnableTemporalProcessing],
            frameRefcon: nil,
            infoFlagsOut: nil
        )
        guard status == noErr else { throw OSError(status) }
    }
    
    @inlinable
    public func waitForAsynchronousFrames() throws {
        let status = VTDecompressionSessionWaitForAsynchronousFrames(_decompressionSession)
        guard status == noErr else { throw OSError(status) }
    }
}

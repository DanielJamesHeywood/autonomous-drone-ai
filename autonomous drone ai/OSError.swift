import CoreFoundation

public struct OSError: Error {
    
    public let status: OSStatus
    
    @inlinable
    public init(_ status: OSStatus) {
        precondition(status != noErr)
        self.status = status
    }
}

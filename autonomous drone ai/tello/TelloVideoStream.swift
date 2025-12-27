import Darwin
import System

public class TelloVideoStream {
    
    @usableFromInline
    internal let _socketDescriptor: FileDescriptor
    
    @inlinable
    public init() throws {
        let socketDescriptor = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP)
        guard socketDescriptor != -1 else { throw Errno(rawValue: errno) }
        _socketDescriptor = FileDescriptor(rawValue: socketDescriptor)
    }
}

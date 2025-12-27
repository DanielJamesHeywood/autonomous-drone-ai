import Darwin
import System

public class TelloVideoStream {
    
    @inlinable
    public init() throws {
        let socketDescriptor = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP)
        guard socketDescriptor != -1 else { throw Errno(rawValue: errno) }
    }
}

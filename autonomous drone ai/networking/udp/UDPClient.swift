import Foundation
import Network

public class UDPClient {
    
    @usableFromInline
    internal let _connection: NWConnection
    
    @inlinable
    public init(for endpoint: Endpoint) {
        _connection = NWConnection(to: endpoint._convertToNWEndpoint(), using: .udp)
        _connection.start(queue: DispatchQueue(label: "udpclient.connection", qos: .utility))
    }
    
    @inlinable
    deinit {
        _connection.cancel()
    }
    
    @inlinable
    public func send(_ content: Data) async throws {
        try await withUnsafeThrowingContinuation { continuation in
            _connection.send(
                content: content,
                completion: .contentProcessed { error in
                    if let error {
                        continuation.resume(throwing: error)
                    } else {
                        continuation.resume()
                    }
                }
            )
        } as Void
    }
    
    @inlinable
    public func receive() async throws -> Data {
        return try await withUnsafeThrowingContinuation { continuation in
            _connection.receiveMessage(
                completion: { content, _, _, error in
                    if let error {
                        continuation.resume(throwing: error)
                    } else if let content {
                        continuation.resume(returning: content)
                    } else {
                        continuation.resume(throwing: UDPError.noMessageReceived)
                    }
                }
            )
        }
    }
}

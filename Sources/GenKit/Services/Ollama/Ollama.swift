import Foundation
import OllamaKit

public final class OllamaService: ChatService {
    
    public static var shared = OllamaService()
    
    private var client: OllamaClient
    
    init() {
        self.client = OllamaClient()
    }
    
    public func completion(request: ChatServiceRequest) async throws -> Message {
        let payload = ChatRequest(model: request.model, messages: encode(messages: request.messages))
        let result = try await client.chat(payload)
        return decode(result: result)
    }
    
    public func completionStream(request: ChatServiceRequest, delta: (Message) async -> Void) async throws {
        let payload = ChatRequest(model: request.model, messages: encode(messages: request.messages), stream: true)
        for try await result in client.chatStream(payload) {
            let message = decode(result: result)
            await delta(message)
        }
    }
    
    public func embeddings(model: String, input: String) async throws -> [Double] {
        let payload = EmbeddingRequest(model: model, prompt: input, options: [:])
        let result = try await client.embeddings(payload)
        return result.embedding
    }
}
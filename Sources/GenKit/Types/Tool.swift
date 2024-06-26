import Foundation
import SharedKit

public struct Tool: Codable {
    public var type: ToolType
    public var function: Function
    
    public enum ToolType: String, Codable {
        case function
    }
    
    public struct Function: Codable {
        public var name: String
        public var description: String
        public var parameters: JSONSchema
        
        public init(name: String, description: String, parameters: JSONSchema) {
            self.name = name
            self.description = description
            self.parameters = parameters
        }
    }
    
    public init(type: ToolType = .function, function: Function) {
        self.type = type
        self.function = function
    }
}

extension Tool: Hashable, Equatable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(type)
        hasher.combine(function.name)
    }
    
    public static func == (lhs: Tool, rhs: Tool) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}

public struct ToolCall: Codable {
    public var id: String
    public var type: String
    public var function: FunctionCall
    
    public struct FunctionCall: Codable {
        public var name: String
        public var arguments: String
        
        public init(name: String, arguments: String) {
            self.name = name
            self.arguments = arguments
        }
    }
    
    public init(id: String = .id, type: String = "function", function: FunctionCall) {
        self.id = id
        self.type = type
        self.function = function
    }
}

extension ToolCall {
    
    public func apply(_ toolCall: ToolCall) -> ToolCall {
        var existing = self
        
        // Name should never be a fragment so we shouldn't 'apply' it like other strings.
        if existing.function.name.isEmpty {
            existing.function.name = toolCall.function.name
        }
        
        existing.function.arguments = existing.function.arguments.apply(with: toolCall.function.arguments)
        return existing
    }
}

import Foundation

enum ServiceError: Error {
    case missingToken
    case missingImageData
    case unsupportedResponseFormat
    case notImplemented
}

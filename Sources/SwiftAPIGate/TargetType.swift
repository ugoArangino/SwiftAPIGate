import Foundation

public protocol TargetType: CustomStringConvertible {
    /// The target's base `URL`.
    var baseURL: URL { get }

    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String? { get }

    /// The HTTP method used.
    var method: HTTPMethod { get }

    /// The type of validation to perform on the request.
    var validationType: ValidationType { get }

    /// The headers to be used.
    /// As a key value dictionary.
    var headers: [String: String]? { get }

    /// The request body data
    var body: Data? { get }
}

public extension TargetType {
    var description: String {
        "\(baseURL), \(path), \(method), \(validationType), \(String(describing: headers))"
    }
}

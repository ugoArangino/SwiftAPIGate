import Foundation

public protocol TargetType: CustomStringConvertible {
    /// The target's base `URL`.
    var baseURL: URL { get }

    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String? { get }

    /// The query parameters to be appended to the `URL`.
    var queryParameters: [String: String]? { get }

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

// MARK: - CustomStringConvertible

public extension TargetType {
    var description: String {
        var components = ["\(method.rawValue.uppercased()) \(baseURL.absoluteString)"]

        // Add path if it exists
        if let path = path, !path.isEmpty {
            components.append(path)
        }

        // Add query parameters if they exist
        if let queryParameters = queryParameters, !queryParameters.isEmpty {
            let queryString = queryParameters.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
            components.append("?\(queryString)")
        }

        // Add validation type
        components.append("; Validation: \(validationType)")

        // Add headers if they exist
        if let headers = headers, !headers.isEmpty {
            let headersString = headers.map { "\($0.key): \($0.value)" }.joined(separator: ", ")
            components.append("; Headers: [\(headersString)]")
        }

        // Add body length if body exists
        if let body = body {
            components.append("; Body Length: \(body.count) bytes")
        }

        return components.joined(separator: "")
    }
}

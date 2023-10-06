import Foundation

public struct APIResponse: CustomDebugStringConvertible, Equatable {
    /// The status code of the response.
    public var statusCode: Int {
        response.statusCode
    }

    /// The response data.
    public let data: Data

    /// The original URLRequest for the response.
    public let request: URLRequest

    /// The HTTPURLResponse object.
    public let response: HTTPURLResponse

    public init(data: Data, request: URLRequest, response: HTTPURLResponse) {
        self.data = data
        self.request = request
        self.response = response
    }

    /// A text description of the `Response`.
    public var description: String {
        return "Status Code: \(statusCode), Data Length: \(data.count)"
    }

    /// A text description of the `Response`. Suitable for debugging.
    public var debugDescription: String {
        return description
    }
}

import Foundation

public struct AbstractTarget: TargetType {
    public let baseURL: URL
    public let path: String
    public let method: HTTPMethod
    public let validationType: ValidationType
    public let headers: [String: String]?

    public init(
        baseURL: URL,
        path: String,
        method: HTTPMethod,
        validationType: ValidationType = .none,
        headers: [String: String]? = nil
    ) {
        self.baseURL = baseURL
        self.path = path
        self.method = method
        self.validationType = validationType
        self.headers = headers
    }

    public init(
        from target: TargetType,
        withBaseURL baseURL: URL? = nil,
        withPath path: String? = nil,
        withMethod method: HTTPMethod? = nil,
        withValidationType validationType: ValidationType? = nil,
        withHeaders headers: [String: String]? = nil
    ) {
        self.init(
            baseURL: baseURL ?? target.baseURL,
            path: path ?? target.path,
            method: method ?? target.method,
            validationType: validationType ?? target.validationType,
            headers: headers ?? target.headers
        )
    }
}

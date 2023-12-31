import Foundation

public struct AbstractTarget: TargetType {
    public let baseURL: URL
    public let path: String?
    public let queryParameters: [String: String]?
    public let method: HTTPMethod
    public let validationType: ValidationType
    public let headers: [String: String]?
    public let body: Data?

    public init(
        baseURL: URL,
        path: String?,
        queryParameters: [String: String]? = nil,
        method: HTTPMethod,
        validationType: ValidationType = .none,
        headers: [String: String]? = nil,
        body: Data?
    ) {
        self.baseURL = baseURL
        self.path = path
        self.queryParameters = queryParameters
        self.method = method
        self.validationType = validationType
        self.headers = headers
        self.body = body
    }

    public init(
        from target: TargetType,
        withBaseURL baseURL: URL? = nil,
        withPath path: String? = nil,
        withQueryParameters queryParameters: [String: String]? = nil,
        withMethod method: HTTPMethod? = nil,
        withValidationType validationType: ValidationType? = nil,
        withHeaders headers: [String: String]? = nil,
        withBody body: Data? = nil
    ) {
        self.init(
            baseURL: baseURL ?? target.baseURL,
            path: path ?? target.path,
            queryParameters: queryParameters ?? target.queryParameters,
            method: method ?? target.method,
            validationType: validationType ?? target.validationType,
            headers: headers ?? target.headers,
            body: body ?? target.body
        )
    }
}

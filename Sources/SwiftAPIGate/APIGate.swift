import Foundation

protocol APIGateType: AnyObject {
    associatedtype Target: TargetType

    func request(_ target: Target) async throws -> APIResponse
}

public final class APIGate<Target: TargetType>: APIGateType {
    let urlSession: URLSessionType
    let middleware: MiddlewareType?
    private lazy var decoder = JSONDecoder()

    public init(
        urlSession: URLSessionType = URLSession.shared,
        middleware: MiddlewareType? = nil
    ) {
        self.urlSession = urlSession
        self.middleware = middleware
    }

    public func request(_ target: Target) async throws -> APIResponse {
        let updatedTarget: TargetType = try await middleware?.target(target) ?? target
        let baseURL = updatedTarget.baseURL
        let path = updatedTarget.path
        let queryParameters = updatedTarget.queryParameters
        let method = updatedTarget.method
        let validationType = updatedTarget.validationType
        let headers = updatedTarget.headers

        guard var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false) else {
            throw URLError(.badURL)
        }
        if let path = path {
            components.path = path
        }
        if let queryParameters = queryParameters {
            components.queryItems = queryParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        }

        guard let requestURL = components.url else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: requestURL)
        request.httpMethod = method.rawValue
        headers?.forEach {
            request.addValue($0.value, forHTTPHeaderField: $0.key)
        }
        request.httpBody = target.body
        request = try await middleware?.request(request, target) ?? request

        let (data, urlResponse) = try await urlSession.data(for: request)

        guard let response = urlResponse as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        guard validationType.statusCodes.contains(response.statusCode) else {
            throw URLError(.badServerResponse)
        }

        return APIResponse(
            data: data,
            request: request,
            response: response
        )
    }

    public func request<Value: Decodable>(_ target: Target) async throws -> (apiResponse: APIResponse, value: Value) {
        let apiResponse = try await request(target)
        let value = try decoder.decode(Value.self, from: apiResponse.data)

        return (apiResponse, value)
    }
}

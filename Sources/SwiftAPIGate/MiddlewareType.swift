import Foundation

public protocol MiddlewareType {
    func target(_ target: some TargetType) async throws -> AbstractTarget?
    func request(_ request: URLRequest, _ target: some TargetType) async throws -> URLRequest?
}

public extension MiddlewareType {
    func target(_: some TargetType) async throws -> AbstractTarget? {
        nil
    }

    func request(_: URLRequest, _: some TargetType) async throws -> URLRequest? {
        nil
    }
}

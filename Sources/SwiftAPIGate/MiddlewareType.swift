import Foundation

public protocol MiddlewareType {
    func target(_ target: some TargetType) -> AbstractTarget?
    func request(_ request: URLRequest, _ target: some TargetType) -> URLRequest?
}

import Foundation
import SwiftAPIGate

class ExampleTargetMiddleware: MiddlewareType {
    var mode: FetchMode

    init(mode: FetchMode) {
        self.mode = mode
    }

    func target(_ target: some SwiftAPIGate.TargetType) -> SwiftAPIGate.AbstractTarget? {
        switch mode {
        case .all:
            nil
        default:
            .init(from: target, withPath: "users/\(mode.rawValue)/orgs")
        }
    }

    func request(_: URLRequest, _: some SwiftAPIGate.TargetType) -> URLRequest? {
        nil
    }
}

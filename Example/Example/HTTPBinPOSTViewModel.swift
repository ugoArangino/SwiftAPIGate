import Foundation
import SwiftAPIGate

@Observable
final class HTTPBinPOSTViewModel {
    private let provider: APIGate<ExampleTarget>

    private(set) var response: APIResponse?
    private(set) var error: Error?

    init() {
        provider = .init()
    }

    func post() {
        Task {
            do {
                response = try await provider.request(.httpbinPOST)
                error = nil
            } catch {
                self.error = error
            }
        }
    }
}

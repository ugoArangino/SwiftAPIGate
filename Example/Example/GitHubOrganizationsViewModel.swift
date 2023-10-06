import Foundation
import SwiftAPIGate

@Observable
final class GitHubOrganizationsViewModel {
    private var middleware: ExampleTargetMiddleware
    private let provider: APIGate<ExampleTarget>
    var mode: FetchMode {
        middleware.mode
    }

    private(set) var organizations: [Organization]?
    private(set) var error: Error?

    init() {
        let middleware = ExampleTargetMiddleware(mode: .all)
        self.middleware = middleware
        provider = .init(middleware: middleware)
    }

    func load() async {
        do {
            organizations = try await provider.request(.gitHubOrganizations).value
        } catch {
            self.error = error
        }
    }

    func setMode(_ mode: FetchMode) {
        middleware.mode = mode
        Task {
            await load()
        }
    }
}

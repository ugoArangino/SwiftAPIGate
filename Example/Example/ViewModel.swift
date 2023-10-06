import Foundation
import SwiftAPIGate

@Observable
final class ViewModel {
    private var middleware: GitHubTargetMiddleware
    private let provider: APIGate<GitHubTarget>
    var mode: FetchMode {
        middleware.mode
    }

    private(set) var organizations: [Organization]?
    private(set) var error: Error?

    init() {
        let middleware = GitHubTargetMiddleware(mode: .all)
        self.middleware = middleware
        provider = .init(middleware: middleware)
    }

    func load() async {
        do {
            organizations = try await provider.request(.organizations).value
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

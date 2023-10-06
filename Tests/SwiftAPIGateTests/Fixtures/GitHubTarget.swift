import Foundation
import SwiftAPIGate

enum GitHubTarget {
    case organizations
    case userProfile(String)
    case updateAuthenticatedUser(String)
}

extension GitHubTarget: TargetType {
    var baseURL: URL {
        URL(string: "https://api.github.com")!
    }

    var path: String {
        switch self {
        case .organizations:
            "/organizations"
        case let .userProfile(name):
            "/users/\(name)"
        case .updateAuthenticatedUser:
            "/users"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .organizations:
            .get
        case .userProfile:
            .get
        case .updateAuthenticatedUser:
            .patch
        }
    }

    var validationType: ValidationType {
        .successAndRedirectCodes
    }

    var headers: [String: String]? {
        switch self {
        case .userProfile:
            ["X-GitHub-Api-Version": "2022-11-28"]
        default: nil
        }
    }

    var body: Data? {
        switch self {
        case let .updateAuthenticatedUser(body):
            body.data(using: .utf8)
        default: nil
        }
    }
}

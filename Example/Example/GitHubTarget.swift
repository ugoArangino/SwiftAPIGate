import Foundation
import SwiftAPIGate

enum GitHubTarget {
    case organizations
}

extension GitHubTarget: TargetType {
    var baseURL: URL {
        URL(string: "https://api.github.com")!
    }

    var path: String {
        switch self {
        case .organizations:
            return "/organizations"
        }
    }

    var method: HTTPMethod {
        .get
    }

    var validationType: ValidationType {
        .successAndRedirectCodes
    }

    var headers: [String: String]? {
        nil
    }
}

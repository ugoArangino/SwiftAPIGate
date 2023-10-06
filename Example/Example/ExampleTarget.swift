import Foundation
import SwiftAPIGate

enum ExampleTarget {
    case gitHubOrganizations
}

extension ExampleTarget: TargetType {
    var baseURL: URL {
        URL(string: "https://api.github.com")!
    }

    var path: String {
        switch self {
        case .gitHubOrganizations:
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

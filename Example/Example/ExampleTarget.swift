import Foundation
import SwiftAPIGate

enum ExampleTarget {
    case gitHubOrganizations
    case httpbinPOST
}

extension ExampleTarget: TargetType {
    var baseURL: URL {
        switch self {
        case .gitHubOrganizations:
            URL(string: "https://api.github.com")!
        case .httpbinPOST:
            URL(string: "https://httpbin.org")!
        }
    }

    var path: String {
        switch self {
        case .gitHubOrganizations:
            "/organizations"
        case .httpbinPOST:
            "/post"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .gitHubOrganizations:
            .get
        case .httpbinPOST:
            .post
        }
    }

    var validationType: ValidationType {
        .successAndRedirectCodes
    }

    var headers: [String: String]? {
        nil
    }
}

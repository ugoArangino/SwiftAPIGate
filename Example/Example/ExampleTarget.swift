import Foundation
import SwiftAPIGate

struct ExampleBody: Codable, Equatable {
    let date: Date
    let id: UUID

    init(date: Date = .now, id: UUID = .init()) {
        self.date = date
        self.id = id
    }
}

enum ExampleTarget {
    case gitHubOrganizations
    case httpbinPOST(ExampleBody)

    private static let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }()
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

    var path: String? {
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

    var body: Data? {
        switch self {
        case .gitHubOrganizations:
            nil
        case let .httpbinPOST(body):
            try? Self.encoder.encode(body)
        }
    }
}

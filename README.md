# SwiftAPIGate

## Overview
SwiftAPIGate is a lightweight network layer for Swift applications, inspired by the Moya framework. It provides a simplified and efficient approach for handling API calls in iOS and macOS applications.

## Installation
Install SwiftAPIGate using the Swift Package Manager. Add it as a dependency in your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/ugoArangino/SwiftAPIGate.git", branch("main")
]
```

## [Example](./Example)
### 1. Usage
To use SwiftAPIGate, import the package and create a view model that handles your network requests. Here is a basic example:

```swift
import SwiftAPIGate

@Observable
final class GitHubOrganizationsViewModel {
    private var middleware: ExampleTargetMiddleware
    private let provider: APIGate<ExampleTarget>

    private(set) var organizations: [Organization]?
    private(set) var error: Error?

    init() {
        // Injecting a middleware into the provider to modify the requests
        let middleware = ExampleTargetMiddleware()
        self.middleware = middleware
        provider = .init(middleware: middleware)
    }

    func load() async {
        do {
            // Using .value to access the decoded data
            organizations = try await provider.request(.gitHubOrganizations).value
        } catch {
            self.error = error
        }
    }
}

```

### 2. Creating the Target
The `Target` is a key component in SwiftAPIGate. It defines the endpoints for your network requests. Here's an example of how to create a target:

```swift

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
    // Use case associated values to pass data to the request
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

    var body: Data? {
        switch self {
        case .gitHubOrganizations:
            nil
        case let .httpbinPOST(body):
            try? Self.encoder.encode(body)
        }
    }
}
```

### 3. Middleware
Middleware in SwiftAPIGate allows you to intercept requests and responses, adding additional functionality or modifying the request/response as needed. Here's a simple example of middleware usage:

```swift
class ExampleTargetMiddleware: MiddlewareType {
    // Use this method to modify the target before it is used to create a request
    // E.g. Changing the baseURL for a development environment
    func target(_ target: some SwiftAPIGate.TargetType) -> SwiftAPIGate.AbstractTarget? {
        .init(from: target, withPath: "users/\(mode.rawValue)/orgs")
    }

    // Use this method to modify the raw request before it is sent
    func request(_: URLRequest, _: some SwiftAPIGate.TargetType) -> URLRequest? {
        nil
    }
}
```

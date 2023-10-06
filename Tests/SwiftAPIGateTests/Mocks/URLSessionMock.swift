import Foundation
@testable import SwiftAPIGate
import XCTest

class URLSessionMock: URLSessionType {
    private var data: Data?
    private var response: HTTPURLResponse?
    private var error: Error?
    private(set) var dataInvocations: [URLRequest] = []

    func setDataValue(
        data: Data? = nil,
        response: HTTPURLResponse? = nil,
        error: Error? = nil
    ) {
        self.data = data
        self.response = response
        self.error = error
    }

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        dataInvocations.append(request)

        if let error = error {
            throw error
        } else if let data = data, let response = response {
            return (data, response)
        } else {
            throw URLError(.unknown)
        }
    }
}

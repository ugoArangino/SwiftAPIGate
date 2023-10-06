@testable import SwiftAPIGate
import XCTest

final class APIGateTests: XCTestCase {
    private enum Fixture {
        static let url = URL(string: "https://api.github.com/organizations")!
    }

    var sessionMock: URLSessionMock!
    var sut: APIGate<GitHubTarget>!

    override func setUp() {
        sessionMock = .init()
        sut = .init(urlSession: sessionMock)
    }

    func testLoad() async throws {
        // Arrange
        let fakeData = #function.data(using: .utf8)
        sessionMock.setDataValue(
            data: fakeData,
            response: .init(url: Fixture.url, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
        )

        // Act
        let apiResponse = try await sut.request(.organizations)

        // Assert
        XCTAssertEqual(try XCTUnwrap(apiResponse.data), fakeData)
        XCTAssertEqual(sessionMock.dataInvocations, [
            .init(url: .init(string: "https://api.github.com/organizations")!),
        ])
    }

    func testLoadWithHeader() async throws {
        // Arrange
        let fakeData = #function.data(using: .utf8)
        sessionMock.setDataValue(
            data: fakeData,
            response: .init(url: Fixture.url, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
        )

        // Act
        let apiResponse = try await sut.request(.userProfile("test"))

        // Assert
        XCTAssertEqual(try XCTUnwrap(apiResponse.data), fakeData)
        XCTAssertEqual(sessionMock.dataInvocations.map(\.url), [
            .init(string: "https://api.github.com/users/test")!,
        ])
        XCTAssertEqual(sessionMock.dataInvocations.map(\.allHTTPHeaderFields), [
            ["X-GitHub-Api-Version": "2022-11-28"],
        ])
    }

    func testLoadWithMethod() async throws {
        // Arrange
        let fakeData = #function.data(using: .utf8)
        sessionMock.setDataValue(
            data: fakeData,
            response: .init(url: Fixture.url, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
        )

        // Act
        let apiResponse = try await sut.request(.updateAuthenticatedUser(""))

        // Assert
        XCTAssertEqual(try XCTUnwrap(apiResponse.data), fakeData)
        XCTAssertEqual(sessionMock.dataInvocations.map(\.url), [
            .init(string: "https://api.github.com/users")!,
        ])
        XCTAssertEqual(sessionMock.dataInvocations.map(\.httpMethod), [
            "PATCH",
        ])
    }

    func testLoadWithDecoding() async throws {
        // Arrange
        let exampleDecodable = ExampleDecodable(id: .init())
        let exampleData = try JSONEncoder().encode(exampleDecodable)
        sessionMock.setDataValue(
            data: exampleData,
            response: .init(url: Fixture.url, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
        )

        // Act
        let decodedResponse: ExampleDecodable = try await sut.request(.organizations).value

        // Assert
        XCTAssertEqual(decodedResponse, exampleDecodable)
        XCTAssertEqual(sessionMock.dataInvocations, [
            .init(url: .init(string: "https://api.github.com/organizations")!),
        ])
    }

    func testLoadWithBody() async throws {
        // Arrange
        let fakeData1 = #function.data(using: .utf8)
        let fakeData2 = "requestBody".data(using: .utf8)
        sessionMock.setDataValue(
            data: fakeData1,
            response: .init(url: Fixture.url, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
        )

        // Act
        let apiResponse = try await sut.request(.updateAuthenticatedUser("requestBody"))

        // Assert
        XCTAssertEqual(try XCTUnwrap(apiResponse.data), fakeData1)
        XCTAssertEqual(sessionMock.dataInvocations.map(\.url), [
            .init(string: "https://api.github.com/users")!,
        ])
        XCTAssertEqual(sessionMock.dataInvocations.map(\.httpBody), [
            fakeData2,
        ])
    }

    func testLoadFailed() async throws {
        // Arrange
        let error = URLError(.badServerResponse)
        sessionMock.setDataValue(
            response: .init(url: Fixture.url, mimeType: nil, expectedContentLength: 0, textEncodingName: nil),
            error: error
        )

        // Act
        let act = { [unowned self] in
            try await self.sut.request(.organizations)
        }

        // Assert
        await XCTAssertThrowsAsyncError(try await act())
        XCTAssertEqual(sessionMock.dataInvocations, [
            .init(url: .init(string: "https://api.github.com/organizations")!),
        ])
    }
}

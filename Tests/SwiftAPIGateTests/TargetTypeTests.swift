@testable import SwiftAPIGate
import XCTest

final class TargetTypeTests: XCTestCase {
    func testTargetType() {
        let organizationsRequest = GitHubTarget.organizations
        let updateAuthenticatedUserRequest = GitHubTarget.updateAuthenticatedUser("Bob")
        let userProfileRequest = GitHubTarget.userProfile("Alice")

        XCTAssertEqual(
            organizationsRequest.description,
            "GET https://api.github.com/organizations?per_page=5; Validation: successAndRedirectCodes"
        )

        XCTAssertEqual(
            updateAuthenticatedUserRequest.description,
            "PATCH https://api.github.com/users; Validation: successAndRedirectCodes; Body Length: 3 bytes"
        )

        XCTAssertEqual(
            userProfileRequest.description,
            "GET https://api.github.com/users/Alice; Validation: successAndRedirectCodes; Headers: [X-GitHub-Api-Version: 2022-11-28]"
        )
    }
}

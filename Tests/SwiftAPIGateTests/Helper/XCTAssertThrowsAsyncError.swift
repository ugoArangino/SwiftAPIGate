import XCTest

func XCTAssertThrowsAsyncError<T>(
    _ expression: @autoclosure () async throws -> T,
    _ message: @autoclosure () -> String? = nil,
    file: StaticString = #filePath,
    line: UInt = #line,
    _ errorHandler: (_ error: Error) -> Void = { _ in }
) async {
    do {
        _ = try await expression()
        if let message = message() {
            XCTFail(message, file: file, line: line)
        } else {
            XCTFail("XCTAssertThrowsAsyncError failed: did not throw an error", file: file, line: line)
        }
    } catch {
        errorHandler(error)
    }
}

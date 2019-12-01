import XCTest
@testable import Discord

final class DiscordTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Discord().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}

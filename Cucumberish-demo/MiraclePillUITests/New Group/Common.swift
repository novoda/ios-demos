import Foundation
import XCTest

class Common: XCTest {

    let application = XCUIApplication()

    func launchApplication() {
        application.launch()
    }

    func verifyUIElementExists(_ type: XCUIElementType, withId id: String) {
        XCTAssert(application.descendants(matching: type)[id].exists)
    }

    func waitForElementToAppear(_ element: XCUIElement) -> Bool {
        let existsPredicate = NSPredicate(format: "exists == true")
        let expectation = XCTNSPredicateExpectation(predicate: existsPredicate,
                                                    object: element)
        let result = XCTWaiter().wait(for: [expectation], timeout: 5)
        return result == .completed
    }
}

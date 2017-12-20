import Foundation
import XCTest

class SuccessScreen: XCTest {

    let application = XCUIApplication()

    func verifySuccessIconExists() {
        Common().waitForElementToAppear(application.buttons["Success"])
        Common().verifyUIElementExists(.button, withId: "Success")
    }

    func pressSuccessButton() {
        application.buttons["Success"].tap()
    }
}

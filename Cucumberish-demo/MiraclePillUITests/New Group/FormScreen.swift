import Foundation
import XCTest

class FormScreen: XCTestCase {

    let application = XCUIApplication()

    func verifyPillImageIsVisible() {
        Common().verifyUIElementExists(.image, withId: "Pill")
    }

    func fillInNameField(name: String) {
        application.textFields["Name"].tap()
        application.textFields["Name"].typeText(name)
    }

    func fillInStreet(street: String) {
        application.textFields["Street"].tap()
        application.textFields["Street"].typeText(street)
    }

    func fillInCity(city: String) {
        application.textFields["City"].tap()
        application.textFields["City"].typeText(city)
    }

    func fillInCountry(country: String) {
        application.textFields["Country"].tap()
        application.textFields["Country"].typeText(country)
    }

    func pressBuyNowButton() {
        let buyNowButton = application.buttons["BuyNowBtn"]
        buyNowButton.tap()
    }

    func verifyBuyButtonIsHittable() {
        let buyNowButton = application.buttons["BuyNowBtn"]
        XCTAssertTrue(buyNowButton.isHittable)
    }
    
    func pressReturnButtonOnKeyboard() {
        let returnButton = application.buttons["return"]
        returnButton.tap()
    }
}

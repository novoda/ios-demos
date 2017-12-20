import Foundation
import Cucumberish

class FormScreenSteps: FormScreen {

    func FormScreenStepsImplementation() {

        Then("user is on the form screen") { _,_ in
            self.verifyPillImageIsVisible()
        }

        When("user fills in all the text fields") { _,_ in
            self.fillInNameField(name: "Bart")
            self.pressReturnButtonOnKeyboard()
            self.fillInStreet(street: "20, The Ivories, 6 Northampton St")
            self.pressReturnButtonOnKeyboard()
            self.fillInCity(city: "London")
            self.pressReturnButtonOnKeyboard()
            self.fillInCountry(country: "UK")
            self.pressReturnButtonOnKeyboard()
        }

        Then("user is able to tap on buy button") { _,_ in
            self.verifyBuyButtonIsHittable()
        }

        MatchAll("user presses buy now button") { _,_ in
            self.pressBuyNowButton()
        }
    }
}

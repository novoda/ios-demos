import Foundation
import Cucumberish

class SuccessScreenSteps: SuccessScreen {

    func SuccessScreenStepsImplementation() {

        Then("user is taken on the success screen") { _,_ in
            self.verifySuccessIconExists()
        }

        When("user presses success button") {_,_ in
            self.pressSuccessButton()
        }
    }
}

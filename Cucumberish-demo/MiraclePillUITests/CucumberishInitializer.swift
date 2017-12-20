import Foundation
import Cucumberish

@objc public class CucumberishInitializer: NSObject {
    @objc public class func CucumberishSwiftInit() {
        var application: XCUIApplication!

        beforeStart { () -> Void in
            application = XCUIApplication()
            FormScreenSteps().FormScreenStepsImplementation()
            SuccessScreenSteps().SuccessScreenStepsImplementation()
            CommonStepDefinitions().CommonStepDefinitionsImplementation()
        }

        let bundle = Bundle(for: CucumberishInitializer.self)

        Cucumberish.executeFeatures(inDirectory: "Features", from: bundle, includeTags: nil, excludeTags: nil)

//implemented tags 
//        Cucumberish.executeFeatures(inDirectory: "Features", from: bundle, includeTags: ["implemented"], excludeTags: ["not_implemented"])
    }
}



//:  ## TestSpy Implementation

import Foundation

protocol TestSpy: class {
    associatedtype Method: Equatable
    var recordedMethods: [Method] { get set }
}

extension TestSpy {
    func record(_ event: Method) {
        recordedMethods.append(event)
    }

    func verify(_ events: [Method]) -> Bool {
        return recordedMethods == events
    }
}

extension Array where Element: Equatable {
    static func == (lhs: [Element], rhs: [Element]) -> Bool {
        return lhs.elementsEqual(rhs)
    }
}

//: ## Example

protocol Navigator {
    func showSplashScreen()
    func toArticle(articleID: String)
    func toSettings()
}

final class SpyNavigator: Navigator, TestSpy {
    enum Method {
        case showSplashScreen
        case toArticle(articleID: String)
        case toSettings
    }

    var recordedMethods = [SpyNavigator.Method]()

    func showSplashScreen() {
        record(.showSplashScreen)
    }

    func toArticle(articleID: String) {
        record(.toArticle(articleID: articleID))
    }

    func toSettings() {
        record(.toSettings)
    }
}

extension SpyNavigator.Method: Equatable {
    static func == (lhs: SpyNavigator.Method, rhs: SpyNavigator.Method) -> Bool {
        switch (lhs, rhs) {
        case (.showSplashScreen, .showSplashScreen):
            return true
        case (.toArticle(let lhsArticleID), .toArticle(let rhsArticleID)):
            return lhsArticleID == rhsArticleID
        case (.toSettings, .toSettings):
            return true
        default:
            return false
        }
    }
}

//: ## TestCase

import XCTest

final class ExampleTests: XCTestCase {
    func testToSettingIsInvoked() {
        let navigator = SpyNavigator()
        navigator.toSettings()

        XCTAssertTrue(navigator.verify([.toSettings]))
    }
}

import XCTest
import EarlGrey

// This code allows a nicer API around [EarlGrey](https://github.com/google/EarlGrey).
// Let your `XCTest` class implement this protocol, and then use the protocol extensions. For example:
// `onView(with: .accessibilityLabel("doneButton")).tap()`

protocol UITest {

}

extension UITest {

    func onView(with matchers: Matcher...) -> GREYElementInteraction {
        let greyMatchers = matchers.map {
            $0.function()
        }
        return EarlGrey.select(elementWithMatcher: grey_allOfMatchers(greyMatchers))
    }

    func onTabBarButton(with matcher: Matcher) -> GREYElementInteraction {
        return onView(with: matcher)
                .inRoot(grey_kindOfClass(UITabBar.classForCoder()))
    }

}

struct Matcher {

    fileprivate let function: ((Void) -> GREYMatcher)

    static func accessibilityIdentifier(_ accessibilityIdentifier: String) -> Matcher {
        return Matcher(function: {
            return grey_accessibilityID(accessibilityIdentifier)
        })
    }

    static func accessibilityLabel(_ accessibilityLabel: String) -> Matcher {
        return Matcher(function: {
            return grey_accessibilityLabel(accessibilityLabel)
        })
    }

    static func type(_ classType: AnyClass) -> Matcher {
        return Matcher(function: {
            return grey_kindOfClass(classType)
        })
    }

    static func title(_ title: String) -> Matcher {
        return Matcher(function: {
            return grey_buttonTitle(title)
        })
    }

    static func text(_ text: String) -> Matcher {
        return Matcher(function: {
            return grey_text(text)
        })
    }

}

extension GREYElementInteraction {

    func tap() {
        perform(GREYActions.actionForTap())
    }

    func doubleTap() {
        perform(GREYActions.actionForTap())
        perform(GREYActions.actionForTap())
    }

    func swipeLeft() {
        perform(GREYActions.actionForSwipeSlow(in: GREYDirection.left))
    }

    func assertIsVisible() {
        assert(with: GREYMatchers.matcherForSufficientlyVisible())
    }

    func assertText(matches string: String) {
        assert(with: GREYMatchers.matcher(forText: string))
    }

    func type(_ text: String) {
        perform(GREYActions.action(forTypeText: text))
    }

    func backspace(times: Int) {
        let backspaceString = String(repeating: "\u{8}", count: times)
        type(backspaceString)
    }
}

import XCTest
import EarlGrey

// This code allows a nicer API around [EarlGrey](https://github.com/google/EarlGrey).
// Let your `XCTest` class implement this protocol, and then use the protocol extensions. For example:
// `onView(with: .accessibilityLabel("doneButton")).tap()`
protocol UITest {
    
}

class Foo: UITest {
    
    func foo() {
        onView(with: .accessibilityIdentifier("hello")).assertIsVisible()
    }
    
}

extension UITest {
    
    func onView(with matcher: Matcher) -> GREYElementInteraction {
        return EarlGrey.select(elementWithMatcher: matcher.function())
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
    
    func type(_ text:String) {
        perform(GREYActions.action(forTypeText: text))
    }
}

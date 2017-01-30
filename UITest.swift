import XCTest

// This code allows a nicer API around [EarlGrey](https://github.com/google/EarlGrey). 
// Let your `XCTest` class implement this protocol, and then use the protocol extensions. For example:
// `onViewWith(accesssibilityLabel: "doneButton").tap()`
protocol UITest {

	var earlGrey: EarlGreyImpl { get }

}

extension UITest {

	func onViewWith(accessibilityIdentifier accessibilityIdentifier: String) -> GREYElementInteraction {
		return earlGrey.selectElementWith(accessibilityIdentifier: accessibilityIdentifier)
	}
	
	func onViewsWith(accessibilityIdentifier accessibilityIdentifier: String) -> GREYElementInteraction {
		return earlGrey.selectElementWith(accessibilityIdentifier: accessibilityIdentifier)
	}

	func onViewWith(accessibilityLabel accessibilityLabel: String) -> GREYElementInteraction {
		return earlGrey.selectElementWith(accessibilityLabel: accessibilityLabel)
	}

	func assertVisibleViewWith(accessibilityIdentifier: String) {
		earlGrey.selectElementWith(accessibilityIdentifier: accessibilityIdentifier).assertIsVisible()
	}
	
}

extension EarlGreyImpl {
	
	func selectElementWith(accessibilityLabel accessibilityLabel: String) -> GREYElementInteraction {
		return selectElementWithMatcher(GREYMatchers.matcherForAccessibilityLabel(accessibilityLabel))
	}

	func selectElementWith(accessibilityIdentifier accessibilityIdentifier: String) -> GREYElementInteraction {
		return selectElementWithMatcher(GREYMatchers.matcherForAccessibilityID(accessibilityIdentifier))
	}

	func selectElementWith(text text: String) -> GREYElementInteraction {
		return selectElementWithMatcher(GREYMatchers.matcherForText(text))
	}

	func selectElementWith(buttonTitle buttonTitle: String) -> GREYElementInteraction {
		return selectElementWithMatcher(GREYMatchers.matcherForButtonTitle(buttonTitle))
	}
	
	func tapTabBarItemWith(accesibilityLabel label: String) {
		EarlGrey().selectElementWithMatcher(grey_accessibilityLabel(label)).inRoot(grey_kindOfClass(UITabBar.classForCoder())).atIndex(0).performAction(grey_tap())
	}
}

extension GREYElementInteraction {

	func tap() {
		performAction(GREYActions.actionForTap())
	}
	
	func doubleTap() {
		performAction(GREYActions.actionForTap())
		performAction(GREYActions.actionForTap())
	}

	func swipeLeft() {
		performAction(GREYActions.actionForSwipeSlowInDirection(GREYDirection.Left))
	}

	func assertIsVisible() {
		assertWithMatcher(GREYMatchers.matcherForSufficientlyVisible())
	}

	func assertText(matches string: String) {
		assertWithMatcher(GREYMatchers.matcherForText(string))
	}
	
	func type(text text:String) {
		performAction(GREYActions.actionForTypeText(text))
	}
	
	func getText(inout text: String) {
		performAction(GREYActionBlock.actionWithName("get text",
			constraints: grey_respondsToSelector(Selector("text")),
			performBlock: { element, errorOrNil -> Bool in
				text = element.text
				return true
		}))
	}
}

//
//  Earl_Grey_DemoTests.swift
//  Earl-Grey-DemoTests
//
//  Created by Alex Curran on 15/02/2017.
//  Copyright © 2017 Alex Curran. All rights reserved.
//

import XCTest
@testable import Earl_Grey_Demo

class Earl_Grey_DemoTests: XCTestCase, UITest {
    
    func testTappingGoGoesToTheSecondController() {
        onView(with: .title("Go")).tap()

        onView(with: .text("Welcome to the second controller!")).assertIsVisible()
    }
    
}

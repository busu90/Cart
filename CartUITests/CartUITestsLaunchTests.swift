//
//  CartUITestsLaunchTests.swift
//  CartUITests
//
//  Created by Andrei Busuioc on 07.05.2022.
//

import XCTest

class CartUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()
    }
}

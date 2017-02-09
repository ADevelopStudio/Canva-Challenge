//
//  Canva_ChallengeUITests.swift
//  Canva-ChallengeUITests
//
//  Created by Dmitrii Zverev on 8/2/17.
//  Copyright © 2017 Dmitrii Zverev. All rights reserved.
//

import XCTest

class Canva_ChallengeUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLeftEmptyBtnPressed() {
        XCUIApplication().buttons["Lorem"].tap()
    }
    
    func testRightEmptyBtnPressed() {
        XCUIApplication().buttons["Ipsum"].tap()
    }
    
    func testUIElements(){
        let app = XCUIApplication()
        XCTAssertTrue(app.buttons.count == 3, "Buttons on screen count: \(app.buttons.count)")
        XCTAssertTrue(app.collectionViews.count == 1, "Collections on screen count: \(app.collectionViews.count)")
        XCTAssertTrue(app.collectionViews.element(boundBy: 0).cells.count == 0)
    }
    
    func testCancelAlert() {
        let app = XCUIApplication()
        let generateButton = app.buttons["Generate"]
        generateButton.tap()
        XCTAssertTrue(app.alerts.count == 0)
        generateButton.tap()
        sleep(1)
        XCTAssertTrue(app.alerts.count == 1)
        app.alerts["Maze generating in progress."].buttons["Cancel"].press(forDuration: 0.6);
        XCTAssertTrue(app.alerts.count == 0)
    }
    
    
    func testStopMazeGeneration() {
        let app = XCUIApplication()
        let generateButton = app.buttons["Generate"]
        generateButton.tap()
        XCTAssertTrue(app.alerts.count == 0)
        generateButton.tap()
        sleep(1)
        XCTAssertTrue(app.alerts.count == 1)
        app.alerts["Maze generating in progress."].buttons["Stop"].press(forDuration: 0.6);
        XCTAssertTrue(app.alerts.count == 0)

    }
}

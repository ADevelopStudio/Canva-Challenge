//
//  modelTests.swift
//  Canva-Challenge
//
//  Created by Dmitrii Zverev on 9/2/17.
//  Copyright © 2017 Dmitrii Zverev. All rights reserved.
//

import XCTest
@testable import Canva_Challenge

class modelTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMazeCellData() {
        let newMazeData = MazeCellData()
        XCTAssertTrue(newMazeData.id.length == 0, "The data is a Wall: \(newMazeData.id.length)")
        
        let newMazeData2 = MazeCellData(id: "qweqwe", image: "httpLink")
        XCTAssertEqual(newMazeData2.id, "qweqwe")
        XCTAssertEqual(newMazeData2.image, "httpLink")
        XCTAssertFalse(newMazeData2.id.length == 0, "The second data is a Wall: \(newMazeData2.id.length)")
    }

}

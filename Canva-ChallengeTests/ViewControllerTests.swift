//
//  ViewControllerTests.swift
//  ViewControllerTests
//
//  Created by Dmitrii Zverev on 8/2/17.
//  Copyright © 2017 Dmitrii Zverev. All rights reserved.
//

import XCTest
@testable import Canva_Challenge

class ViewControllerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGenerateEmptyArrayAndCutNils() {
        let vc = ViewController()
        var array = vc.matrix
        XCTAssertTrue(array.count == 0, "Matrix array count = \(array.count)")
        array = vc.generateEmptyArray(size: 100)
        XCTAssertTrue(array.count == 100, "Matrix array after generation count = \(array.count)")
        XCTAssertTrue(array.cutEmptyData().count == 0, "Matrix array after cutting nils count = \(array.cutEmptyData().count)")
    
        array.append(Array(arrayLiteral: nil, nil, nil))
        for _ in 0..<3 {
            array.append(Array(arrayLiteral: nil, nil, nil, MazeCellData(), MazeCellData(), nil))
        }
        array.append(Array(arrayLiteral: nil, nil, nil, nil))

        XCTAssertTrue(array.cutEmptyData().count == 3, "Matrix array after cutting nils count = \(array.cutEmptyData().count)")
    }

    
}

//
//  CardCrucibleTests.swift
//  CardCrucibleTests
//
//  Created by Matthew Kressin on 7/9/20.
//  Copyright © 2020 Matthew Kressin. All rights reserved.
//

import XCTest
@testable import CardCrucible

class CardCrucibleTests: XCTestCase {
    private var ace: Card!
    private var eight: Card!
    private var nine: Card!
    private var ten: Card!
    private var jack: Card!
    private var queen: Card!
    private var king: Card!
    override func setUp() {
        super.setUp()
        // Using this, a new instance of ShoppingCart will be created
        // before each test is run.
        ace = Card(suitValue: .clubs, rankValue: .ace)
        eight = Card(suitValue: .clubs, rankValue: .eight)
        nine = Card(suitValue: .clubs, rankValue: .nine)
        
        ten = Card(suitValue: .clubs, rankValue: .ten)
        jack = Card(suitValue: .clubs, rankValue: .jack)
        
        queen = Card(suitValue: .clubs, rankValue: .queen)
        king = Card(suitValue: .clubs, rankValue: .king)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    func testValues() throws {
        let three = Card(suitValue: .clubs, rankValue: .three)
        XCTAssertTrue(three.cardValue == 3)

        XCTAssertTrue(ten.cardValue == 10)
        XCTAssertTrue(jack.cardValue == 10)
        XCTAssertTrue(ten.cardValue == jack.cardValue)
        
        let twoH = Card(suitValue: .hearts, rankValue: .two)
        let twoS = Card(suitValue: .spades, rankValue: .two)
        XCTAssertTrue(twoH.cardValue == 2)
        XCTAssertTrue(twoS.cardValue == 2)
        XCTAssertTrue(twoH.cardValue == twoS.cardValue)
    }
    func testLessThan() throws {
        // test all suits
        let twoC = Card(suitValue: .clubs, rankValue: .two)
        let twoD = Card(suitValue: .diamonds, rankValue: .two)
        let twoH = Card(suitValue: .hearts, rankValue: .two)
        let twoS = Card(suitValue: .spades, rankValue: .two)
        XCTAssertTrue(ace < twoC)
        XCTAssertTrue(ace < twoD)
        XCTAssertTrue(ace < twoH)
        XCTAssertTrue(ace < twoS)
        
        // test same ranks
        XCTAssertFalse(twoS < twoC)
        XCTAssertFalse(ten < ten)
        XCTAssertFalse(king < king)
        
        XCTAssertTrue(eight < nine)
        XCTAssertFalse(nine < eight)
        
        XCTAssertTrue(ten < jack)
        XCTAssertFalse(jack < ten)
        
        XCTAssertTrue(ten < king)
        XCTAssertTrue(queen < king)
        XCTAssertFalse(king < jack)
        XCTAssertFalse(king < queen)
    }

    /*
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
*/
}

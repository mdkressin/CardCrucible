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
    private var suit: Card.Suit!
    private var rank: Card.Rank!
    private var ace: Card!
    override func setUp() {
        super.setUp()
        // Using this, a new instance of ShoppingCart will be created
        // before each test is run.
        suit = Card.Suit.spades
        rank = Card.Rank.ace
        ace = Card(suit: suit, rank: rank)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    func testValues() throws {
        let three = Card(suit: .clubs, rank: .three)
        XCTAssertTrue(three.cardValue == 3)
    }
    func testLessThan() throws {
        // test all suits
        let twoC = Card(suit: .clubs, rank: .two)
        let twoD = Card(suit: .diamonds, rank: .two)
        let twoH = Card(suit: .hearts, rank: .two)
        let twoS = Card(suit: .spades, rank: .two)
        XCTAssertTrue(ace < twoC)
        XCTAssertTrue(ace < twoD)
        XCTAssertTrue(ace < twoH)
        XCTAssertTrue(ace < twoS)
        
        XCTAssertFalse(twoS < twoC)
        
        let eight = Card(suit: .clubs, rank: .eight)
        let nine = Card(suit: .clubs, rank: .nine)
        XCTAssertTrue(eight < nine)
        XCTAssertFalse(nine < eight)
        
        let ten = Card(suit: .clubs, rank: .ten)
        let jack = Card(suit: .clubs, rank: .jack)
        XCTAssertTrue(ten < jack)
        XCTAssertFalse( jack < ten)
        
        let queen = Card(suit: .clubs, rank: .queen)
        let king = Card(suit: .clubs, rank: .king)
        
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

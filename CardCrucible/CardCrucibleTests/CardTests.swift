//
//  CardTests.swift
//  CardCrucibleTests
//
//  Created by Matthew Kressin on 7/9/20.
//  Copyright © 2020 Matthew Kressin. All rights reserved.
//

import XCTest
import SwiftyJSON
@testable import CardCrucible

class CardTests: XCTestCase {
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
    func testCardDataJSON() throws {
        if let path = Bundle.main.path(forResource: "cardData", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let jsonObj = try JSON(data: data)
                XCTAssertEqual("\(jsonObj[Card.Suit.diamonds.rawValue][Card.Rank.toString(rank: Card.Rank.queen)].stringValue)", "QD")
                print("jsonData:\(jsonObj)")
            } catch let error {
                XCTFail("parse error: \(error.localizedDescription)")
            }
        } else {
            XCTFail("Invalid filename/path.")
        }
    }
    func testValues() throws {
        let three = Card(suitValue: .clubs, rankValue: .three)
        XCTAssertEqual(three.cardValue, 3)

        XCTAssertEqual(ten.cardValue, 10)
        XCTAssertEqual(jack.cardValue, 11)
        XCTAssertNotEqual(ten.cardValue, jack.cardValue)
        
        let twoH = Card(suitValue: .hearts, rankValue: .two)
        let twoS = Card(suitValue: .spades, rankValue: .two)
        XCTAssertEqual(twoH.cardValue, 2)
        XCTAssertEqual(twoS.cardValue, 2)
        XCTAssertEqual(twoH.cardValue, twoS.cardValue)
    }
    func testLessThan() throws {
        // test all suits
        let twoC = Card(suitValue: .clubs, rankValue: .two)
        let twoD = Card(suitValue: .diamonds, rankValue: .two)
        let twoH = Card(suitValue: .hearts, rankValue: .two)
        let twoS = Card(suitValue: .spades, rankValue: .two)
        
        let three = Card(suitValue: .spades, rankValue: .three)
        XCTAssertLessThan(twoC, three)
        XCTAssertLessThan(twoD, three)
        XCTAssertLessThan(twoH, three)
        XCTAssertLessThan(twoS, three)
        
        // test same ranks
        XCTAssertFalse(twoS < twoC)
        XCTAssertFalse(ten < ten)
        XCTAssertFalse(king < king)
        
        XCTAssertLessThan(eight, nine)
        XCTAssertFalse(nine < eight)
        
        XCTAssertLessThan(ten, jack)
        XCTAssertFalse(jack < ten)
        
        XCTAssertLessThan(ten, king)
        XCTAssertLessThan(queen, king)
        XCTAssertLessThan(king, ace)
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

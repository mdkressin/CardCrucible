//
//  TournamentPlayerTests.swift
//  CardCrucibleTests
//
//  Created by Matthew Kressin on 12/28/20.
//  Copyright © 2020 Matthew Kressin. All rights reserved.
//

import XCTest
@testable import CardCrucible

class TournamentPlayerTests: XCTestCase {

    private var player1: Player!
    private var player2: Player!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        player1 = TournamentPlayer("tournament player 1")
        player2 = TournamentPlayer("tournament player 2")
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTournamentPlayerInit() throws {
        // Test that newly created players have different names but the same cards
        XCTAssertFalse(player1 == player2, "players 1 and 2 should have unique ids and have different names but were considered equal")
        XCTAssertTrue(player1.numCards == 0 && player2.numCards == 0, "newly created players should not yet have any cards")
        
        // create tournament player from another player and check that they are equal
        let player3 = TournamentPlayer(player1)
        XCTAssertTrue(player1 == player3, "failure trying to initialize player based on other player's data")
        
        // create player who already has cards
        var deck = Deck.createShuffledDeck(numSubDecks: 1)
        do {
            let newCards = try Deck.drawCards(drawAmount: 5, from: &deck)
            player1.addToCards(newCards)
            let player = TournamentPlayer(player1)
            
            XCTAssertTrue(player == player1)
            XCTAssertTrue(player.numCards == newCards.count, "player's number of cards does not match the expected count")
            XCTAssertTrue(newCards =/ player.cards, "player's cards do not match the expected cards")
        } catch {
            XCTFail("an error should not have occurred here")
        }
    }

    func testTournementPlayerEliminated() {
        let player = TournamentPlayer("tournament player")
        
        XCTAssertFalse(player.isEliminated)
        XCTAssertTrue(player.isNotEliminated)
        
        player.isEliminated = true
        XCTAssertTrue(player.isEliminated)
        XCTAssertFalse(player.isNotEliminated)
        
        player.isNotEliminated = true
        XCTAssertFalse(player.isEliminated)
        XCTAssertTrue(player.isNotEliminated)
    }
    /*
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
*/
}

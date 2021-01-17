//
//  PlayerTests.swift
//  CardCrucibleTests
//
//  Created by Matthew Kressin on 12/27/20.
//  Copyright © 2020 Matthew Kressin. All rights reserved.
//

import XCTest
@testable import CardCrucible

class PlayerTests: XCTestCase {

    private var player1: Player!
    private var player2: Player!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        
        player1 = Player("Player 1")
        player2 = Player("Player 2")
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPlayerInit() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertFalse(player1 == player2, "players 1 and 2 should have unique ids and have different names but were considered equal")
        
        XCTAssertTrue(player1.numCards == 0 && player2.numCards == 0, "newly created players should not yet have any cards")
        
        // Create a new player based on player1
        let player3 = Player(player1.name, player1.playerID, player1.cards)
        XCTAssertTrue(player1 == player3, "failure trying to initialize player based on other player's data")
        
        // create player who already has cards
        var deck = Deck.createShuffledDeck(numSubDecks: 1)
        do {
            let newCards = try Deck.drawCards(drawAmount: 5, from: &deck)
            let player = Player(player1.name, player1.playerID, newCards)
            
            XCTAssertTrue(player.numCards == newCards.count, "player's number of cards does not match the expected count")
            XCTAssertTrue(newCards =/ player.cards, "player's cards do not match the expected cards")
        } catch {
            XCTFail("an error should not have occurred here")
        }
    }
    
    func testAddToCards() throws {
        var deck = Deck.createShuffledDeck(numSubDecks: 1)
        
        do {
            let card = try Deck.drawCard(from: &deck)
            player1.addToCards(card)
            XCTAssertEqual(player1.cards[0], card)
            
            var cards = try Deck.drawCards(drawAmount: 5, from: &deck)
            player1.addToCards(cards)
            XCTAssertEqual(player1.cards, [card] + cards)
            
            cards = []
            for _ in 0 ..< 3 {
                let c = try Deck.drawRandomCard(&deck)
                cards.append(c)
                player2.addToCards(c)
            }
            XCTAssertEqual(player2.cards, cards)
        } catch {
            XCTFail("Should not reach here")
        }
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

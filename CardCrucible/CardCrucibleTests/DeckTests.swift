//
//  DeckTests.swift
//  CardCrucibleTests
//
//  Created by Matthew Kressin on 7/18/20.
//  Copyright © 2020 Matthew Kressin. All rights reserved.
//

import XCTest
@testable import CardCrucible

class DeckTests: XCTestCase {
    /// The number of cards in a single deck or sub-deck
    private let deckSize = Deck.defaultDeckSize
    /// The max number of sub-decks allowed within a single deck
    private let maxNumDecks =
                        Deck.AllowedNumSubDecks.maxNumSubDecks
    /// The min number of  sub-decks allowed within a single deck
    private let minNumDecks =
                        Deck.AllowedNumSubDecks.minNumSubDecks
    private var testDeck: Deck!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        // create test deck with default of 1 sub-deck
        testDeck = Deck()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDeckInit() {
        // default value of 1 is used
        XCTAssertEqual(testDeck.deck.count, deckSize)
        
        // use 2 decks
        testDeck = Deck(numDecks: 2)
        XCTAssertEqual(testDeck.deck.count, deckSize*2)
        
        // use 5 decks
        testDeck = Deck(numDecks: 5)
        XCTAssertEqual(testDeck.deck.count, deckSize*5)
        
        // use 10 decks (maximum amount of decks)
        testDeck = Deck(numDecks: maxNumDecks)
        XCTAssertEqual(testDeck.deck.count, deckSize*maxNumDecks)
        
        // use 1 more than max amount of decks
        testDeck = Deck(numDecks: maxNumDecks + 1)
        XCTAssertEqual(testDeck.deck.count, deckSize*maxNumDecks)
        
        // use value that greatly exceeds maximum amount of decks
        testDeck = Deck(numDecks: maxNumDecks*1000000)
        XCTAssertEqual(testDeck.deck.count, deckSize*maxNumDecks)
        
        // use 0 decks (minimum amount of decks)
        testDeck = Deck(numDecks: minNumDecks)
        XCTAssertEqual(testDeck.deck.count, minNumDecks)
        
        // use 1 less than min amount of decks
        testDeck = Deck(numDecks: minNumDecks - 1)
        XCTAssertEqual(testDeck.deck.count, minNumDecks)
        
        // use value that is much less than minimum amount of decks
        testDeck = Deck(numDecks: -1000000)
        XCTAssertEqual(testDeck.deck.count, minNumDecks)
    }
    
    func testCreateDeck() {
        var newDeck: [Card]
        
        // default value of 1 is used
        newDeck = testDeck.createDeck()
        // test that doesn't add to non-empty local decks variable
        XCTAssertEqual(testDeck.deck.count, deckSize)
        /*
         test that a deck of the correct size was created and
         returned
         */
        XCTAssertEqual(newDeck.count, deckSize)
        
        // use 2 sub-decks
        testDeck = Deck(numDecks: 2)
        newDeck = testDeck.createDeck()
        // test that doesn't add to non-empty local decks variable
        XCTAssertEqual(testDeck.deck.count, deckSize*2)
        /*
         test that a deck of the correct size was created and
         returned
         */
        XCTAssertEqual(newDeck.count, deckSize*2)
        
        // use 5 decks
        testDeck = Deck(numDecks: 5)
        newDeck = testDeck.createDeck()
        XCTAssertEqual(testDeck.deck.count, deckSize*5)
        XCTAssertEqual(newDeck.count, deckSize*5)
        
        // use 10 decks (maximum amount of decks)
        testDeck = Deck(numDecks: maxNumDecks)
        newDeck = testDeck.createDeck()
        XCTAssertEqual(testDeck.deck.count, deckSize*maxNumDecks)
        XCTAssertEqual(newDeck.count, deckSize*maxNumDecks)
        
        // use 1 more than max amount of decks
        testDeck = Deck(numDecks: maxNumDecks + 1)
        newDeck = testDeck.createDeck()
        XCTAssertEqual(testDeck.deck.count, deckSize*maxNumDecks)
        XCTAssertEqual(newDeck.count, deckSize*maxNumDecks)
        
        // use value that greatly exceeds maximum amount of decks
        testDeck = Deck(numDecks: maxNumDecks*1000000)
        newDeck = testDeck.createDeck()
        XCTAssertEqual(testDeck.deck.count, deckSize*maxNumDecks)
        XCTAssertEqual(newDeck.count, deckSize*maxNumDecks)
        
        // use 0 decks (minimum amount of decks)
        testDeck = Deck(numDecks: minNumDecks)
        newDeck = testDeck.createDeck()
        XCTAssertEqual(testDeck.deck.count, minNumDecks)
        XCTAssertEqual(newDeck.count, minNumDecks)
        
        // use 1 less than min amount of decks
        testDeck = Deck(numDecks: minNumDecks - 1)
        newDeck = testDeck.createDeck()
        XCTAssertEqual(testDeck.deck.count, minNumDecks)
        XCTAssertEqual(newDeck.count, minNumDecks)
        
        // use value that is much less than minimum amount of decks
        testDeck = Deck(numDecks: -1000000)
        newDeck = testDeck.createDeck()
        XCTAssertEqual(testDeck.deck.count, minNumDecks)
        XCTAssertEqual(newDeck.count, minNumDecks)
    }

    /**
     Checks to see that the Deck struct creats an array of cards that contains all the cards
     expected to be in a deck
     */
    func testDeckContents() {
        
        let testContentsDeck = manuallyCreateDeck()
        XCTAssertEqual(testContentsDeck.count, deckSize)
        
        var i = 0
        for card in testContentsDeck {
            if !testDeck.deck.contains(card) {
                XCTFail()
            }
            i += 1
        }
        XCTAssertEqual(i, deckSize)
    }
    
    func testDrawCard() {
        var firstCard = testDeck.deck[0]
        var drawnCard = testDeck.drawCard()
        XCTAssertEqual(firstCard, drawnCard)
        XCTAssertEqual(testDeck.deckSize, deckSize-1)
        
        firstCard = testDeck.deck[0]
        drawnCard = testDeck.drawCard()
        XCTAssertEqual(firstCard, drawnCard)
        XCTAssertEqual(testDeck.deckSize, deckSize-1)
        
        /*
         The original first card was already removed from the deck
         so the original second card is now the new first carde in
         the deck
         */
        var secondCard = testDeck.deck[0]
        drawnCard = testDeck.drawCard()
        XCTAssertEqual(secondCard, drawnCard)
        XCTAssertEqual(testDeck.deckSize, deckSize-2)
        XCTAssertNotEqual(firstCard, secondCard)
    }
    /**
     Manually creates a deck of 52 cards containing all Card suits and all Card ranks per suit
     
     - Returns: An array that holds a single full deck of cards
     */
    fileprivate func manuallyCreateDeck() -> [Card] {
        // manually create a deck
        var deck: [Card] = []
        deck.append(Card(suitValue: .clubs, rankValue: .ace))
        deck.append(Card(suitValue: .diamonds, rankValue: .ace))
        deck.append(Card(suitValue: .hearts, rankValue: .ace))
        deck.append(Card(suitValue: .spades, rankValue: .ace))
        deck.append(Card(suitValue: .clubs, rankValue: .two))
        deck.append(Card(suitValue: .diamonds, rankValue: .two))
        deck.append(Card(suitValue: .hearts, rankValue: .two))
        deck.append(Card(suitValue: .spades, rankValue: .two))
        deck.append(Card(suitValue: .clubs, rankValue: .three))
        deck.append(Card(suitValue: .diamonds, rankValue: .three))
        deck.append(Card(suitValue: .hearts, rankValue: .three))
        deck.append(Card(suitValue: .spades, rankValue: .three))
        deck.append(Card(suitValue: .clubs, rankValue: .four))
        deck.append(Card(suitValue: .diamonds, rankValue: .four))
        deck.append(Card(suitValue: .hearts, rankValue: .four))
        deck.append(Card(suitValue: .spades, rankValue: .four))
        deck.append(Card(suitValue: .clubs, rankValue: .five))
        deck.append(Card(suitValue: .diamonds, rankValue: .five))
        deck.append(Card(suitValue: .hearts, rankValue: .five))
        deck.append(Card(suitValue: .spades, rankValue: .five))
        deck.append(Card(suitValue: .clubs, rankValue: .six))
        deck.append(Card(suitValue: .diamonds, rankValue: .six))
        deck.append(Card(suitValue: .hearts, rankValue: .six))
        deck.append(Card(suitValue: .spades, rankValue: .six))
        deck.append(Card(suitValue: .clubs, rankValue: .seven))
        deck.append(Card(suitValue: .diamonds, rankValue: .seven))
        deck.append(Card(suitValue: .hearts, rankValue: .seven))
        deck.append(Card(suitValue: .spades, rankValue: .seven))
        deck.append(Card(suitValue: .clubs, rankValue: .eight))
        deck.append(Card(suitValue: .diamonds, rankValue: .eight))
        deck.append(Card(suitValue: .hearts, rankValue: .eight))
        deck.append(Card(suitValue: .spades, rankValue: .eight))
        deck.append(Card(suitValue: .clubs, rankValue: .nine))
        deck.append(Card(suitValue: .diamonds, rankValue: .nine))
        deck.append(Card(suitValue: .hearts, rankValue: .nine))
        deck.append(Card(suitValue: .spades, rankValue: .nine))
        deck.append(Card(suitValue: .clubs, rankValue: .ten))
        deck.append(Card(suitValue: .diamonds, rankValue: .ten))
        deck.append(Card(suitValue: .hearts, rankValue: .ten))
        deck.append(Card(suitValue: .spades, rankValue: .ten))
        deck.append(Card(suitValue: .clubs, rankValue: .jack))
        deck.append(Card(suitValue: .diamonds, rankValue: .jack))
        deck.append(Card(suitValue: .hearts, rankValue: .jack))
        deck.append(Card(suitValue: .spades, rankValue: .jack))
        deck.append(Card(suitValue: .clubs, rankValue: .queen))
        deck.append(Card(suitValue: .diamonds, rankValue: .queen))
        deck.append(Card(suitValue: .hearts, rankValue: .queen))
        deck.append(Card(suitValue: .spades, rankValue: .queen))
        deck.append(Card(suitValue: .clubs, rankValue: .king))
        deck.append(Card(suitValue: .diamonds, rankValue: .king))
        deck.append(Card(suitValue: .hearts, rankValue: .king))
        deck.append(Card(suitValue: .spades, rankValue: .king))
        
        return deck
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

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
    private let expectedErrorStr = "no error was thrown when one"
                                    + "was expected to be thrown"
    
    /// The number of cards in a single deck or sub-deck
    private let deckSize = Deck.defaultDeckSize
    /// The max number of sub-decks allowed within a single deck
    private let maxNumDecks =
                        Deck.AllowedNumSubDecks.maxNumSubDecks
    /// The min number of  sub-decks allowed within a single deck
    private let minNumDecks =
                        Deck.AllowedNumSubDecks.minNumSubDecks
    private var testDeck1: Deck!
    private var testDeck2: Deck!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        // create test deck with default of 1 sub-deck
        testDeck1 = Deck()
        testDeck2 = Deck()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDeckInit() {
        // default value of 1 is used
        XCTAssertEqual(testDeck1.deckCards.count, deckSize)
        
        // use 2 decks
        testDeck1 = Deck(numSubDecks: 2)
        XCTAssertEqual(testDeck1.deckCards.count, deckSize*2)
        
        // use 5 decks
        testDeck1 = Deck(numSubDecks: 5)
        XCTAssertEqual(testDeck1.deckCards.count, deckSize*5)
        
        // use 10 decks (maximum amount of decks)
        testDeck1 = Deck(numSubDecks: maxNumDecks)
        XCTAssertEqual(testDeck1.deckCards.count, deckSize*maxNumDecks)
        
        // use 1 more than max amount of decks
        testDeck1 = Deck(numSubDecks: maxNumDecks + 1)
        XCTAssertEqual(testDeck1.deckCards.count, deckSize*maxNumDecks)
        
        // use value that greatly exceeds maximum amount of decks
        testDeck1 = Deck(numSubDecks: maxNumDecks*1000000)
        XCTAssertEqual(testDeck1.deckCards.count, deckSize*maxNumDecks)
        
        // use 0 decks (minimum amount of decks)
        testDeck1 = Deck(numSubDecks: minNumDecks)
        XCTAssertEqual(testDeck1.deckCards.count, minNumDecks)
        
        // use 1 less than min amount of decks
        testDeck1 = Deck(numSubDecks: minNumDecks - 1)
        XCTAssertEqual(testDeck1.deckCards.count, minNumDecks)
        
        // use value that is much less than minimum amount of decks
        testDeck1 = Deck(numSubDecks: -1000000)
        XCTAssertEqual(testDeck1.deckCards.count, minNumDecks)
    }
    
    func testCreateDeck() {
        var newDeck: [Card]
        
        // default value of 1 is used
        newDeck = testDeck1.createDeck(numSubDecks: 1)
        // test that doesn't add to non-empty local decks variable
        XCTAssertEqual(testDeck1.deckCards.count, deckSize)
        /*
         test that a deck of the correct size was created and
         returned
         */
        XCTAssertEqual(newDeck.count, deckSize)
        
        // use 2 sub-decks
        testDeck1 = Deck(numSubDecks: 2)
        newDeck = testDeck1.createDeck(numSubDecks: 2)
        // test that doesn't add to non-empty local decks variable
        XCTAssertEqual(testDeck1.deckCards.count, deckSize*2)
        /*
         test that a deck of the correct size was created and
         returned
         */
        XCTAssertEqual(newDeck.count, deckSize*2)
        
        // use 5 decks
        testDeck1 = Deck(numSubDecks: 5)
        newDeck = testDeck1.createDeck(numSubDecks: 5)
        XCTAssertEqual(testDeck1.deckCards.count, deckSize*5)
        XCTAssertEqual(newDeck.count, deckSize*5)
        
        // use 10 decks (maximum amount of decks)
        testDeck1 = Deck(numSubDecks: maxNumDecks)
        newDeck = testDeck1.createDeck(numSubDecks: maxNumDecks)
        XCTAssertEqual(testDeck1.deckCards.count, deckSize*maxNumDecks)
        XCTAssertEqual(newDeck.count, deckSize*maxNumDecks)
        
        // use 1 more than max amount of decks
        testDeck1 = Deck(numSubDecks: maxNumDecks + 1)
        newDeck = testDeck1.createDeck(numSubDecks: maxNumDecks + 1)
        XCTAssertEqual(testDeck1.deckCards.count, deckSize*maxNumDecks)
        XCTAssertEqual(newDeck.count, deckSize*maxNumDecks)
        
        // use value that greatly exceeds maximum amount of decks
        testDeck1 = Deck(numSubDecks: maxNumDecks*1_000_000)
        newDeck = testDeck1.createDeck(numSubDecks: maxNumDecks*1_000_000)
        XCTAssertEqual(testDeck1.deckCards.count, deckSize*maxNumDecks)
        XCTAssertEqual(newDeck.count, deckSize*maxNumDecks)
        
        // use 0 decks (minimum amount of decks)
        testDeck1 = Deck(numSubDecks: minNumDecks)
        newDeck = testDeck1.createDeck(numSubDecks: minNumDecks)
        XCTAssertEqual(testDeck1.deckCards.count, minNumDecks)
        XCTAssertEqual(newDeck.count, minNumDecks)
        
        // use 1 less than min amount of decks
        testDeck1 = Deck(numSubDecks: minNumDecks - 1)
        newDeck = testDeck1.createDeck(numSubDecks: minNumDecks - 1)
        XCTAssertEqual(testDeck1.deckCards.count, minNumDecks)
        XCTAssertEqual(newDeck.count, minNumDecks)
        
        // use value that is much less than minimum amount of decks
        testDeck1 = Deck(numSubDecks: -1_000_000)
        newDeck = testDeck1.createDeck(numSubDecks: -1_000_000)
        XCTAssertEqual(testDeck1.deckCards.count, minNumDecks)
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
            if !testDeck1.deckCards.contains(card) {
                XCTFail()
            }
            i += 1
        }
        XCTAssertEqual(i, deckSize)
    }
    
    func testEquatability() {
        let manDeck = manuallyCreateDeck()
        XCTAssertFalse(manDeck =/ testDeck1.deckCards)
        XCTAssertTrue(testDeck1.deckCards =/ testDeck2.deckCards)
        
        do {
            try _ = testDeck1.drawCard()
            XCTAssertFalse(testDeck1.deckCards =/ testDeck2.deckCards)
            
            try _ = testDeck2.drawCard()
            XCTAssertTrue(testDeck1.deckCards =/ testDeck2.deckCards)
            
            // draw all cards to test empty decks
            try _ = testDeck1.drawCards(drawAmount: testDeck1.deckSize)
            XCTAssertFalse(testDeck1.deckCards =/ testDeck2.deckCards)
            try _ = testDeck2.drawCards(drawAmount: testDeck2.deckSize)
            XCTAssertTrue(testDeck1.deckCards =/ testDeck2.deckCards)
            
            // test decks that have different starting sizes
            testDeck1 = Deck()
            testDeck2 = Deck(numSubDecks: 2)
            XCTAssertFalse(testDeck1.deckCards =/ testDeck2.deckCards)
            
            // draw from deck 2 until same size as deck 1
            try _ = testDeck2.drawCards(drawAmount: testDeck1.deckSize)
            XCTAssertTrue(testDeck1.deckCards =/ testDeck2.deckCards)
            
            // draw remaining cards
            try _ = testDeck1.drawCards(drawAmount: deckSize)
            try _ = testDeck2.drawCards(drawAmount: deckSize)
            XCTAssertTrue(testDeck1.deckCards =/ testDeck2.deckCards)
        } catch {
            // should not reach here
            XCTFail("unexpected error trying to draw cards")
        }
    }
    
    func testDrawCard() {
        do {
            var firstCard = testDeck1.deckCards[0]
            var drawnCard = try testDeck1.drawCard()
            XCTAssertEqual(firstCard, drawnCard)
            XCTAssertEqual(testDeck1.deckSize, deckSize-1)
            
            testDeck1 = Deck()
            firstCard = testDeck1.deckCards[0]
            try drawnCard = testDeck1.drawCard()
            XCTAssertEqual(firstCard, drawnCard)
            XCTAssertEqual(testDeck1.deckSize, deckSize-1)
            
            /*
             The original first card was already removed from the deck
             so the original second card is now the new first card in
             the deck
             */
            let secondCard = testDeck1.deckCards[0]
            try drawnCard = testDeck1.drawCard()
            XCTAssertEqual(secondCard, drawnCard)
            XCTAssertEqual(testDeck1.deckSize, deckSize-2)
            XCTAssertNotEqual(firstCard, secondCard)
            
            
            // continuously draw cards until all cards have been drawn
            testDeck1 = Deck()
            let drawnCards = try testDeck1.drawCards(drawAmount: testDeck1.deckSize)
            XCTAssertEqual(testDeck1.deckSize, 0)
            XCTAssertEqual(drawnCards.count, deckSize)
        } catch {
            // should not reach here
            XCTFail("unintended error trying to drawCard")
        }
        
        // test drawing a card from an empty deck
        testDeck1 = Deck()
        do {
            // this should execute normally
            try _ = testDeck1.drawCards(drawAmount: deckSize)
            // this should throw an error
            try _ = testDeck1.drawCard()
            // should not reach here
            XCTFail(expectedErrorStr)
        } catch DeckError.drawFromEmptyDeck {
            print("successfully caught expected error")
        } catch {
            XCTFail("did not catch the expected type of error")
        }
    }
    
    func testStaticDrawCard() {
        var staticTestDeck1 = Deck.createShuffledDeck()
        do {
            var firstCard = staticTestDeck1[0]
            var drawnCard = try Deck.drawCard(from: &staticTestDeck1)
            XCTAssertEqual(firstCard, drawnCard)
            XCTAssertEqual(staticTestDeck1.count, deckSize-1)
            
            staticTestDeck1 = Deck.createShuffledDeck()
            firstCard = staticTestDeck1[0]
            try drawnCard = Deck.drawCard(from: &staticTestDeck1)
            XCTAssertEqual(firstCard, drawnCard)
            XCTAssertEqual(staticTestDeck1.count, deckSize-1)
            
            /*
             The original first card was already removed from the deck
             so the original second card is now the new first card in
             the deck
             */
            let secondCard = staticTestDeck1[0]
            try drawnCard = Deck.drawCard(from: &staticTestDeck1)
            XCTAssertEqual(secondCard, drawnCard)
            XCTAssertEqual(staticTestDeck1.count, deckSize-2)
            XCTAssertNotEqual(firstCard, secondCard)
            
            
            // continuously draw cards until all cards have been drawn
            staticTestDeck1 = Deck.createShuffledDeck()
            let copyDeck = staticTestDeck1
            let drawnCards = try Deck.drawCards(drawAmount: staticTestDeck1.count, from: &staticTestDeck1)
            XCTAssertTrue(copyDeck =/ drawnCards)
            XCTAssertTrue(staticTestDeck1.isEmpty)
            XCTAssertEqual(drawnCards.count, deckSize)
        } catch {
            // should not reach here
            XCTFail("unintended error trying to drawCard")
        }
        
        // test drawing a card from an empty deck
        staticTestDeck1 = Deck.createDeck()
        do {
            // this should execute normally
            try _ = Deck.drawCards(drawAmount: deckSize, from: &staticTestDeck1)
            // this should throw an error
            try _ = Deck.drawCard(from: &staticTestDeck1)
            // should not reach here
            XCTFail(expectedErrorStr)
        } catch DeckError.drawFromEmptyDeck {
            print("successfully caught expected error")
        } catch {
            XCTFail("did not catch the expected type of error")
        }
    }
    
    func testDrawCards() {
        // test drawing from decks with a single sub-deck
        do {
            // test that functions same as drawCard when given argument of 1
            var draw1 = try testDeck1.drawCards(drawAmount: 1)
            var draw2 = try [testDeck2.drawCard()]
            XCTAssertEqual(draw1.count, 1)
            XCTAssertEqual(draw1.count, draw2.count)
            XCTAssertTrue(draw1 =/ draw2)
            var afterDrawSize = deckSize - 1
            XCTAssertEqual(testDeck1.deckSize, afterDrawSize)
            XCTAssertEqual(testDeck1, testDeck2)
            
            // reset decks
            testDeck1 = Deck()
            testDeck2 = Deck()
            
            // test drawing multiple cards
            try draw1 = testDeck1.drawCards(drawAmount: 3)
            draw2 = []
            try draw2.append(testDeck2.drawCard())
            try draw2.append(testDeck2.drawCard())
            try draw2.append(testDeck2.drawCard())
            XCTAssertEqual(draw1.count, 3)
            XCTAssertEqual(draw1.count, draw2.count)
            XCTAssertTrue(draw1 =/ draw2)
            afterDrawSize = deckSize - 3
            XCTAssertEqual(testDeck1.deckSize, afterDrawSize)
            XCTAssertEqual(testDeck1, testDeck2)
            
            // test drawing from a previously drawn from deck
            try draw1 = testDeck1.drawCards(drawAmount: 5)
            afterDrawSize -= 5
            XCTAssertEqual(draw1.count, 5)
            XCTAssertEqual(testDeck1.deckSize, afterDrawSize)
            XCTAssertNotEqual(testDeck1, testDeck2)
            try draw1 = testDeck1.drawCards(drawAmount: 20)
            afterDrawSize -= 20
            XCTAssertEqual(draw1.count, 20)
            XCTAssertEqual(testDeck1.deckSize, afterDrawSize)
            try draw1 = testDeck1.drawCards(drawAmount: 2)
            afterDrawSize -= 2
            XCTAssertEqual(draw1.count, 2)
            XCTAssertEqual(testDeck1.deckSize, afterDrawSize)
        } catch  {
            // should not reach here
            XCTFail("unexpected error trying to draw cards")
        }
        
        // trying drawing from decks with more than one sub-deck
        do {
            var deck2Subs = Deck(numSubDecks: 2)
            var afterDrawSize = deck2Subs.deckSize
            var draw = try deck2Subs.drawCards(drawAmount: 5)
            afterDrawSize -= 5
            XCTAssertEqual(draw.count, 5)
            XCTAssertEqual(deck2Subs.deckSize, afterDrawSize)
            
            // try draw amount larger than a single sub-deck's size
            try draw = deck2Subs.drawCards(drawAmount: 55)
            afterDrawSize -= 55
            XCTAssertEqual(draw.count, 55)
            XCTAssertEqual(deck2Subs.deckSize, afterDrawSize)
            
            // see if can still make smaller draws
            try draw = deck2Subs.drawCards(drawAmount: 3)
            afterDrawSize -= 3
            XCTAssertEqual(draw.count, 3)
            XCTAssertEqual(deck2Subs.deckSize, afterDrawSize)
            try draw = deck2Subs.drawCards(drawAmount: 1)
            afterDrawSize -= 1
            XCTAssertEqual(draw.count, 1)
            XCTAssertEqual(deck2Subs.deckSize, afterDrawSize)
            try draw = deck2Subs.drawCards(drawAmount: 5)
            afterDrawSize -= 5
            XCTAssertEqual(draw.count, 5)
            XCTAssertEqual(deck2Subs.deckSize, afterDrawSize)
        } catch {
            // should not reach here
            XCTFail("unexpected error trying to draw cards")
        }
        
        // test draw amounts larger than amount of cards left in a deck
        do {
            testDeck1 = Deck()
            // try drawing 1 more than the size of a single sub-deck
            try _ = testDeck1.drawCards(drawAmount: deckSize + 1)
        } catch DeckError.insufficientCardsRemaining(let cardsDrawn, let message) {
            XCTAssertEqual(cardsDrawn.count, deckSize)
            XCTAssertEqual(testDeck1.deckSize, 0)
            print(message)
        } catch {
            // should not reach here
            XCTFail("unexpected error trying to draw cards")
        }
        do {
            testDeck1 = Deck()
            // try drawing way more than the size of a single sub-deck
            try _ = testDeck1.drawCards(drawAmount: deckSize * 3)
        } catch DeckError.insufficientCardsRemaining(let cardsDrawn, let message) {
            XCTAssertEqual(cardsDrawn.count, deckSize)
            XCTAssertEqual(testDeck1.deckSize, 0)
            print(message)
        } catch {
            // should not reach here
            XCTFail("unexpected error trying to draw cards")
        }
        do {
            testDeck1 = Deck()
            // try drawing in increments (50 picked arbitrarily)
            try _ = testDeck1.drawCards(drawAmount: 50)
            try _ = testDeck1.drawCards(drawAmount: 50)
        } catch DeckError.insufficientCardsRemaining(let cardsDrawn, let message) {
            XCTAssertEqual(cardsDrawn.count, deckSize-50)
            XCTAssertEqual(testDeck1.deckSize, 0)
            print(message)
        } catch {
            // should not reach here
            XCTFail("unexpected error trying to draw cards")
        }
    }
    
    func testStaticDrawCards() {
        // test drawing from decks with a single sub-deck
        var staticTestDeck1 = Deck.createDeck()
        var staticTestDeck2 = Deck.createDeck()
        do {
            // test that functions same as drawCard when given argument of 1
            var draw1 = try Deck.drawCards(drawAmount: 1, from: &staticTestDeck1)
            var draw2 = try [Deck.drawCard(from: &staticTestDeck2)]
            XCTAssertEqual(draw1.count, 1)
            XCTAssertEqual(draw1.count, draw2.count)
            XCTAssertTrue(draw1 =/ draw2)
            var afterDrawSize = deckSize - 1
            XCTAssertEqual(staticTestDeck1.count, afterDrawSize)
            XCTAssertEqual(staticTestDeck1, staticTestDeck2)
            
            // reset decks
            staticTestDeck1 = Deck.createDeck()
            staticTestDeck2 = Deck.createDeck()
            
            // test drawing multiple cards
            try draw1 = Deck.drawCards(drawAmount: 3, from: &staticTestDeck1)
            draw2 = []
            try draw2.append(Deck.drawCard(from: &staticTestDeck2))
            try draw2.append(Deck.drawCard(from: &staticTestDeck2))
            try draw2.append(Deck.drawCard(from: &staticTestDeck2))
            XCTAssertEqual(draw1.count, 3)
            XCTAssertEqual(draw1.count, draw2.count)
            XCTAssertTrue(draw1 =/ draw2)
            afterDrawSize = deckSize - 3
            XCTAssertEqual(staticTestDeck1.count, afterDrawSize)
            XCTAssertEqual(staticTestDeck1, staticTestDeck2)
            
            // test drawing from a previously drawn from deck
            try draw1 = Deck.drawCards(drawAmount: 5, from: &staticTestDeck1)
            afterDrawSize -= 5
            XCTAssertEqual(draw1.count, 5)
            XCTAssertEqual(staticTestDeck1.count, afterDrawSize)
            XCTAssertNotEqual(staticTestDeck1, staticTestDeck2)
            try draw1 = Deck.drawCards(drawAmount: 20, from: &staticTestDeck1)
            afterDrawSize -= 20
            XCTAssertEqual(draw1.count, 20)
            XCTAssertEqual(staticTestDeck1.count, afterDrawSize)
            try draw1 = Deck.drawCards(drawAmount: 2, from: &staticTestDeck1)
            afterDrawSize -= 2
            XCTAssertEqual(draw1.count, 2)
            XCTAssertEqual(staticTestDeck1.count, afterDrawSize)
        } catch  {
            // should not reach here
            XCTFail("unexpected error trying to draw cards")
        }
        
        // trying drawing from decks with more than one sub-deck
        do {
            var deck2Subs = Deck.createDeck(numSubDecks: 2)
            var afterDrawSize = deck2Subs.count
            var draw = try Deck.drawCards(drawAmount: 5, from: &deck2Subs)
            afterDrawSize -= 5
            XCTAssertEqual(draw.count, 5)
            XCTAssertEqual(deck2Subs.count, afterDrawSize)
            
            // try draw amount larger than a single sub-deck's size
            try draw = Deck.drawCards(drawAmount: 55, from: &deck2Subs)
            afterDrawSize -= 55
            XCTAssertEqual(draw.count, 55)
            XCTAssertEqual(deck2Subs.count, afterDrawSize)
            
            // see if can still make smaller draws
            try draw = Deck.drawCards(drawAmount: 3, from: &deck2Subs)
            afterDrawSize -= 3
            XCTAssertEqual(draw.count, 3)
            XCTAssertEqual(deck2Subs.count, afterDrawSize)
            try draw = Deck.drawCards(drawAmount: 1, from: &deck2Subs)
            afterDrawSize -= 1
            XCTAssertEqual(draw.count, 1)
            XCTAssertEqual(deck2Subs.count, afterDrawSize)
            try draw = Deck.drawCards(drawAmount: 5, from: &deck2Subs)
            afterDrawSize -= 5
            XCTAssertEqual(draw.count, 5)
            XCTAssertEqual(deck2Subs.count, afterDrawSize)
        } catch {
            // should not reach here
            XCTFail("unexpected error trying to draw cards")
        }
        
        // test draw amounts larger than amount of cards left in a deck
        do {
            staticTestDeck1 = Deck.createDeck()
            // try drawing 1 more than the size of a single sub-deck
            try _ = Deck.drawCards(drawAmount: deckSize + 1, from: &staticTestDeck1)
        } catch DeckError.insufficientCardsRemaining(let cardsDrawn, let message) {
            XCTAssertEqual(cardsDrawn.count, deckSize)
            XCTAssertEqual(staticTestDeck1.count, 0)
            print(message)
        } catch {
            // should not reach here
            XCTFail("unexpected error trying to draw cards")
        }
        do {
            staticTestDeck1 = Deck.createDeck()
            // try drawing way more than the size of a single sub-deck
            try _ = Deck.drawCards(drawAmount: deckSize * 3, from: &staticTestDeck1)
        } catch DeckError.insufficientCardsRemaining(let cardsDrawn, let message) {
            XCTAssertEqual(cardsDrawn.count, deckSize)
            XCTAssertEqual(staticTestDeck1.count, 0)
            print(message)
        } catch {
            // should not reach here
            XCTFail("unexpected error trying to draw cards")
        }
        do {
            staticTestDeck1 = Deck.createDeck()
            // try drawing in increments (50 picked arbitrarily)
            try _ = Deck.drawCards(drawAmount: 50, from: &staticTestDeck1)
            try _ = Deck.drawCards(drawAmount: 50, from: &staticTestDeck1)
        } catch DeckError.insufficientCardsRemaining(let cardsDrawn, let message) {
            XCTAssertEqual(cardsDrawn.count, deckSize-50)
            XCTAssertEqual(staticTestDeck1.count, 0)
            print(message)
        } catch {
            // should not reach here
            XCTFail("unexpected error trying to draw cards")
        }
    }
    
    func testRandomDraw() {
        do {
            let draw1 = try testDeck1.drawRandomCard()
            let draw2 = try testDeck2.drawRandomCard()
            
            /*
             There is a 1/2704 chance that the below assertion
             will fail due to the same card being drawn from both
             52 card decks
             
             XCTAssertNotEqual(draw1, draw2)
             
             */
            
            XCTAssertEqual(testDeck1.deckSize, deckSize - 1)
            XCTAssertEqual(testDeck1.deckSize, testDeck2.deckSize)
            
            let newDraw1 = try testDeck1.drawRandomCard()
            let newDraw2 = try testDeck2.drawRandomCard()
            XCTAssertNotEqual(draw1, newDraw1)
            XCTAssertNotEqual(draw2, newDraw2)
            XCTAssertEqual(testDeck1.deckSize, deckSize - 2)
            XCTAssertEqual(testDeck1.deckSize, testDeck2.deckSize)
        } catch {
            // should not reach here
            XCTFail("unexpected error trying to draw random card")
        }
        
        // test for when deck has single card left
        do {
            testDeck1 = Deck()
            try _ = testDeck1.drawCards(drawAmount: testDeck1.deckSize-1)
            let lastCard = testDeck1!.deckCards[0]
            let lastDraw = try testDeck1!.drawRandomCard()
            
            XCTAssertEqual(lastCard, lastDraw)
            XCTAssertEqual(testDeck1.deckSize, 0)
        } catch {
            // should not reach here
            XCTFail("unexpected error trying to draw random card")
        }
        
        // test for when deck is empty
        do {
            try _ = testDeck1.drawRandomCard()
            XCTFail(expectedErrorStr)
        } catch DeckError.drawFromEmptyDeck {
            print("successfully caught expected error")
        } catch {
            // should not reach here
            XCTFail("unexpected error trying to draw random card")
        }
    }
    
    func testStaticRandomDraw() {
        var staticTestDeck1 = [Card]()
        var staticTestDeck2 = [Card]()
        
        do {
            staticTestDeck1 = Deck.createShuffledDeck()
            staticTestDeck2 = Deck.createShuffledDeck()
            let draw1 = try Deck.drawRandomCard(&staticTestDeck1)
            let draw2 = try Deck.drawRandomCard(&staticTestDeck2)
            
            /*
             There is a 1/2704 chance that the below assertion
             will fail due to the same card being drawn from both
             52 card decks
             
             XCTAssertNotEqual(draw1, draw2)
             
             */
            
            XCTAssertEqual(staticTestDeck1.count, deckSize - 1)
            XCTAssertEqual(staticTestDeck1.count, staticTestDeck2.count)
            
            let newDraw1 = try Deck.drawRandomCard(&staticTestDeck1)
            let newDraw2 = try Deck.drawRandomCard(&staticTestDeck2)
            XCTAssertNotEqual(draw1, newDraw1)
            XCTAssertNotEqual(draw2, newDraw2)
            XCTAssertEqual(staticTestDeck1.count, deckSize - 2)
            XCTAssertEqual(staticTestDeck1.count, staticTestDeck2.count)
        } catch {
            // should not reach here
            XCTFail("unexpected error trying to draw random card")
        }
        
        // test for when deck has single card left
        do {
            staticTestDeck1 = Deck.createShuffledDeck()
            try _ = Deck.drawCards(drawAmount: staticTestDeck1.count-1, from: &staticTestDeck1)
            let lastCard = staticTestDeck1[0]
            let lastDraw = try Deck.drawRandomCard(&staticTestDeck1)
            
            XCTAssertEqual(lastCard, lastDraw)
            XCTAssertTrue(staticTestDeck1.isEmpty)
        } catch {
            // should not reach here
            XCTFail("unexpected error trying to draw random card")
        }
        
        // test for when deck is empty
        do {
            try _ = Deck.drawRandomCard(&staticTestDeck1)
            XCTFail(expectedErrorStr)
        } catch DeckError.drawFromEmptyDeck {
            print("successfully caught expected error")
        } catch {
            // should not reach here
            XCTFail("unexpected error trying to draw random card")
        }
    }
    
    func testShuffle() {
        let manDeckOrig = manuallyCreateDeck()
        
        // test class shuffle
        let manDeckShuffle = Deck.shuffle(deck: manDeckOrig)
        XCTAssertNotEqual(manDeckOrig, manDeckShuffle)
        let shuffledDeck = Deck.shuffle(deck: testDeck1.deckCards)
        XCTAssertNotEqual(shuffledDeck, testDeck1.deckCards)
        
        // test instance shuffle
        XCTAssertEqual(testDeck1, testDeck2)
        testDeck2.shuffle()
        XCTAssertNotEqual(testDeck2, testDeck1)
        
    }
    
    func testDetermineHighestRank() {
        // test with an array of a single card
        var highestRank = Deck.determineHighestRank(in: [testDeck1.deckCards[0]])
        XCTAssertEqual(highestRank, testDeck1.deckCards[0].rank)
        
        highestRank = Deck.determineHighestRank(in: [testDeck1.deckCards[31]])
        XCTAssertEqual(highestRank, testDeck1.deckCards[31].rank)
        
        // test with an array of 2 sequential cards
        var cards = [Card(suitValue: .clubs, rankValue: .two), Card(suitValue: .clubs, rankValue: .three)]
        highestRank = Deck.determineHighestRank(in: cards)
        XCTAssertEqual(highestRank, Card.Rank.three)
        // reverse order and test
        highestRank = Deck.determineHighestRank(in: [cards[1]] + [cards[0]])
        XCTAssertEqual(highestRank, Card.Rank.three)
        // increase card sequence
        cards = [Card(suitValue: .clubs, rankValue: .three), Card(suitValue: .clubs, rankValue: .four)]
        highestRank = Deck.determineHighestRank(in: cards)
        XCTAssertEqual(highestRank, Card.Rank.four)
        // reverse order and test
        highestRank = Deck.determineHighestRank(in: [cards[1]] + [cards[0]])
        XCTAssertEqual(highestRank, Card.Rank.four)
        // increase card sequence
        cards = [Card(suitValue: .clubs, rankValue: .four), Card(suitValue: .clubs, rankValue: .five)]
        highestRank = Deck.determineHighestRank(in: cards)
        XCTAssertEqual(highestRank, Card.Rank.five)
        // reverse order and test
        highestRank = Deck.determineHighestRank(in: [cards[1]] + [cards[0]])
        XCTAssertEqual(highestRank, Card.Rank.five)
        // increase card sequence
        cards = [Card(suitValue: .clubs, rankValue: .five), Card(suitValue: .clubs, rankValue: .six)]
        highestRank = Deck.determineHighestRank(in: cards)
        XCTAssertEqual(highestRank, Card.Rank.six)
        // reverse order and test
        highestRank = Deck.determineHighestRank(in: [cards[1]] + [cards[0]])
        XCTAssertEqual(highestRank, Card.Rank.six)
        // increase card sequence
        cards = [Card(suitValue: .clubs, rankValue: .six), Card(suitValue: .clubs, rankValue: .seven)]
        highestRank = Deck.determineHighestRank(in: cards)
        XCTAssertEqual(highestRank, Card.Rank.seven)
        // reverse order and test
        highestRank = Deck.determineHighestRank(in: [cards[1]] + [cards[0]])
        XCTAssertEqual(highestRank, Card.Rank.seven)
        // increase card sequence
        cards = [Card(suitValue: .clubs, rankValue: .seven), Card(suitValue: .clubs, rankValue: .eight)]
        highestRank = Deck.determineHighestRank(in: cards)
        XCTAssertEqual(highestRank, Card.Rank.eight)
        // reverse order and test
        highestRank = Deck.determineHighestRank(in: [cards[1]] + [cards[0]])
        XCTAssertEqual(highestRank, Card.Rank.eight)
        // increase card sequence
        cards = [Card(suitValue: .clubs, rankValue: .eight), Card(suitValue: .clubs, rankValue: .nine)]
        highestRank = Deck.determineHighestRank(in: cards)
        XCTAssertEqual(highestRank, Card.Rank.nine)
        // reverse order and test
        highestRank = Deck.determineHighestRank(in: [cards[1]] + [cards[0]])
        XCTAssertEqual(highestRank, Card.Rank.nine)
        // increase card sequence
        cards = [Card(suitValue: .clubs, rankValue: .nine), Card(suitValue: .clubs, rankValue: .ten)]
        highestRank = Deck.determineHighestRank(in: cards)
        XCTAssertEqual(highestRank, Card.Rank.ten)
        // reverse order and test
        highestRank = Deck.determineHighestRank(in: [cards[1]] + [cards[0]])
        XCTAssertEqual(highestRank, Card.Rank.ten)
        // increase card sequence
        cards = [Card(suitValue: .clubs, rankValue: .ten), Card(suitValue: .clubs, rankValue: .jack)]
        highestRank = Deck.determineHighestRank(in: cards)
        XCTAssertEqual(highestRank, Card.Rank.jack)
        // reverse order and test
        highestRank = Deck.determineHighestRank(in: [cards[1]] + [cards[0]])
        XCTAssertEqual(highestRank, Card.Rank.jack)
        // increase card sequence
        cards = [Card(suitValue: .clubs, rankValue: .jack), Card(suitValue: .clubs, rankValue: .queen)]
        highestRank = Deck.determineHighestRank(in: cards)
        XCTAssertEqual(highestRank, Card.Rank.queen)
        // reverse order and test
        highestRank = Deck.determineHighestRank(in: [cards[1]] + [cards[0]])
        XCTAssertEqual(highestRank, Card.Rank.queen)
        // increase card sequence
        cards = [Card(suitValue: .clubs, rankValue: .queen), Card(suitValue: .clubs, rankValue: .king)]
        highestRank = Deck.determineHighestRank(in: cards)
        XCTAssertEqual(highestRank, Card.Rank.king)
        // reverse order and test
        highestRank = Deck.determineHighestRank(in: [cards[1]] + [cards[0]])
        XCTAssertEqual(highestRank, Card.Rank.king)
        // increase card sequence
        cards = [Card(suitValue: .clubs, rankValue: .king), Card(suitValue: .clubs, rankValue: .ace)]
        highestRank = Deck.determineHighestRank(in: cards)
        XCTAssertEqual(highestRank, Card.Rank.ace)
        // reverse order and test
        highestRank = Deck.determineHighestRank(in: [cards[1]] + [cards[0]])
        XCTAssertEqual(highestRank, Card.Rank.ace)
        
        // test highest and lowest ranked cards
        cards = [Card(suitValue: .clubs, rankValue: .ace), Card(suitValue: .clubs, rankValue: .two)]
        highestRank = Deck.determineHighestRank(in: cards)
        XCTAssertEqual(highestRank, Card.Rank.ace)
        // reverse order and test
        highestRank = Deck.determineHighestRank(in: [cards[1]] + [cards[0]])
        XCTAssertEqual(highestRank, Card.Rank.ace)
        
        // test with array of cards that have the same rank
        cards = [Card(suitValue: .clubs, rankValue: .ten), Card(suitValue: .spades, rankValue: .ten)]
        highestRank = Deck.determineHighestRank(in: cards)
        XCTAssertEqual(highestRank, Card.Rank.ten)
        // reverse order and test
        highestRank = Deck.determineHighestRank(in: [cards[1]] + [cards[0]])
        XCTAssertEqual(highestRank, Card.Rank.ten)
        
        // test with entire deck of cards
        highestRank = Deck.determineHighestRank(in: testDeck1.deckCards)
        XCTAssertEqual(highestRank, Card.Rank.ace)
        
        // test with entire shuffled deck
        var deck = Deck.createShuffledDeck()
        highestRank = Deck.determineHighestRank(in: deck)
        XCTAssertEqual(highestRank, Card.Rank.ace)
        
        // test with deck with multiple sub-decks
        deck = Deck.createShuffledDeck(numSubDecks: 3)
        highestRank = Deck.determineHighestRank(in: deck)
        XCTAssertEqual(highestRank, Card.Rank.ace)
    }

    /**
     Manually creates a deck of 52 cards containing all Card suits and all Card ranks per suit
     
     - Returns: An array that holds a single full deck of cards
     */
    fileprivate func manuallyCreateDeck() -> [Card] {
        // manually create a deck
        var deck: [Card] = []
        // aces
        deck.append(Card(suitValue: .clubs, rankValue: .ace))
        deck.append(Card(suitValue: .diamonds, rankValue: .ace))
        deck.append(Card(suitValue: .hearts, rankValue: .ace))
        deck.append(Card(suitValue: .spades, rankValue: .ace))
        // twos
        deck.append(Card(suitValue: .clubs, rankValue: .two))
        deck.append(Card(suitValue: .diamonds, rankValue: .two))
        deck.append(Card(suitValue: .hearts, rankValue: .two))
        deck.append(Card(suitValue: .spades, rankValue: .two))
        // threes
        deck.append(Card(suitValue: .clubs, rankValue: .three))
        deck.append(Card(suitValue: .diamonds, rankValue: .three))
        deck.append(Card(suitValue: .hearts, rankValue: .three))
        deck.append(Card(suitValue: .spades, rankValue: .three))
        // fours
        deck.append(Card(suitValue: .clubs, rankValue: .four))
        deck.append(Card(suitValue: .diamonds, rankValue: .four))
        deck.append(Card(suitValue: .hearts, rankValue: .four))
        deck.append(Card(suitValue: .spades, rankValue: .four))
        // fives
        deck.append(Card(suitValue: .clubs, rankValue: .five))
        deck.append(Card(suitValue: .diamonds, rankValue: .five))
        deck.append(Card(suitValue: .hearts, rankValue: .five))
        deck.append(Card(suitValue: .spades, rankValue: .five))
        // sixes
        deck.append(Card(suitValue: .clubs, rankValue: .six))
        deck.append(Card(suitValue: .diamonds, rankValue: .six))
        deck.append(Card(suitValue: .hearts, rankValue: .six))
        deck.append(Card(suitValue: .spades, rankValue: .six))
        // sevens
        deck.append(Card(suitValue: .clubs, rankValue: .seven))
        deck.append(Card(suitValue: .diamonds, rankValue: .seven))
        deck.append(Card(suitValue: .hearts, rankValue: .seven))
        deck.append(Card(suitValue: .spades, rankValue: .seven))
        // eights
        deck.append(Card(suitValue: .clubs, rankValue: .eight))
        deck.append(Card(suitValue: .diamonds, rankValue: .eight))
        deck.append(Card(suitValue: .hearts, rankValue: .eight))
        deck.append(Card(suitValue: .spades, rankValue: .eight))
        // nines
        deck.append(Card(suitValue: .clubs, rankValue: .nine))
        deck.append(Card(suitValue: .diamonds, rankValue: .nine))
        deck.append(Card(suitValue: .hearts, rankValue: .nine))
        deck.append(Card(suitValue: .spades, rankValue: .nine))
        // tens
        deck.append(Card(suitValue: .clubs, rankValue: .ten))
        deck.append(Card(suitValue: .diamonds, rankValue: .ten))
        deck.append(Card(suitValue: .hearts, rankValue: .ten))
        deck.append(Card(suitValue: .spades, rankValue: .ten))
        // jacks
        deck.append(Card(suitValue: .clubs, rankValue: .jack))
        deck.append(Card(suitValue: .diamonds, rankValue: .jack))
        deck.append(Card(suitValue: .hearts, rankValue: .jack))
        deck.append(Card(suitValue: .spades, rankValue: .jack))
        // queens
        deck.append(Card(suitValue: .clubs, rankValue: .queen))
        deck.append(Card(suitValue: .diamonds, rankValue: .queen))
        deck.append(Card(suitValue: .hearts, rankValue: .queen))
        deck.append(Card(suitValue: .spades, rankValue: .queen))
        // kings
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

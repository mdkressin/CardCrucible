//
//  Deck.swift
//  CardCrucible
//
//  Created by Matthew Kressin on 7/9/20.
//  Copyright © 2020 Matthew Kressin. All rights reserved.
//

import Foundation

/**
 A main deck containing 0-10 (inclusive) sub-decks, with each sub-deck containing all 52 individual cards
 
 - Requires: Card struct from Card.swift
 
 - Note:
    - The main deck is an array containing all the cards of its sub-decks, and not the sub-decks themselves
        - A main deck with a single sub-deck will consist of an array of 52 cards
        - A main deck with two sub-decks will consist of an array of 104 cards, and so on
 */
struct Deck: Equatable {
    /**
     Ensures that there is an upper and lower limit for the amount of sub-decks allowed for
     the main deck
     
     Upper limit is 10. Lower limit is 0.
     */
    @propertyWrapper
    struct AllowedNumSubDecks {
        /// The maximum amount of sub-decks allowed
        static let maxNumSubDecks = 10
        /// The minimum amount of sub-decks allowed
        static let minNumSubDecks = 0
        /// The number of sub-decks that has been forced within the minimum and
        /// maximum constraints
        var numSubDecks: Int
        init(wrappedValue: Int) {
            numSubDecks = min(wrappedValue, AllowedNumSubDecks.maxNumSubDecks)
            numSubDecks = max(numSubDecks, AllowedNumSubDecks.minNumSubDecks)
        }
        
        var wrappedValue: Int {
            get { return numSubDecks }
            set {
                numSubDecks = min(newValue, AllowedNumSubDecks.maxNumSubDecks)
                numSubDecks = max(numSubDecks, AllowedNumSubDecks.minNumSubDecks)
            }
        }
    }
    
    /// The default amount of cards inside a single sub-deck
    static let defaultDeckSize = 52
    
    /// The main deck consisting of potentially several sub-decks
    private var decks: [Card] = []
    /// Getter for the main deck.
    var deck: [Card] {
        get { return decks }
    }
    /// Getter for the amount of cards in the main deck
    var deckSize: Int {
        get { decks.count }
    }
    /// The number of sub-decks this instance is using.
    @AllowedNumSubDecks private var numSubDecks: Int
    
    /**
     Initializes a new deck that has a specified number of sub-decks within it.
     
     - Parameter numSubDecks: The number of subdecks within the main deck. Each sub-deck is itself a full deck containing 52 cards.
     */
    init(numSubDecks: Int = 1) {
        self.numSubDecks = numSubDecks
        createDeck()
    }
    
    /**
     Creates the cards and adds them to the overall deck according to the amount of decks
     specified during initialization of the instance.
     
     - Returns: The deck that was created that contains the amount of sub-decks
     specified during initialization
     */
    @discardableResult
    mutating func createDeck() -> [Card] {
        // erase current decks if they exist
        decks.removeAll()
        
        // loop to create sub-decks
        for _ in 0..<numSubDecks {
            for suit in Card.Suit.allCases {
                for rank in Card.Rank.allCases {
                    decks.append(Card(suitValue: suit, rankValue: rank))
                }
            }
            
        }
        return deck
    }
    
    // TODO: create a fresh deck that has already been shuffled
    @discardableResult
    mutating func createShuffledDeck() -> [Card] {
        return []
    }
    
    // TODO: shuffle the cards in the deck
    @discardableResult
    mutating func shuffle() -> [Card] {
        return []
    }
    
    // TODO: allow card to be drawn from deck
    /**
     Draw the card from the top of the deck (0th index)
     */
    mutating func drawCard() throws -> Card {
        guard deckSize > 0 else {
            #if DEBUG
                debugPrint("inside drawCard but there aren't any cards left to draw")
            #endif
            throw DeckError.drawFromEmptyDeck
        }
        return decks.removeFirst()
    }
    
    // TODO: allow multiple cards to be drawn from the top of the deck (start at 0th index)
    mutating func drawCards(drawAmount: Int) throws -> [Card]  {
        guard drawAmount > 0 else {
            throw DeckError.negativeDrawAttempt
        }
        
        var drawnCards: [Card] = []
        guard drawAmount <= deckSize else {
            drawnCards = decks
            decks.removeAll()
            throw DeckError.insufficientCardsRemaining(cardsDrawn: drawnCards, message: "attempted to draw \(drawAmount) cards but there were only \(drawnCards.count) cards in the deck")
        }
        
        for _ in 0..<drawAmount {
            try drawnCards.append(drawCard())
        }
        return drawnCards
    }
    
    // TODO: allow card to be drawn randomly from deck
    mutating func drawRandomCard() throws -> [Card] {
        throw DeckError.drawFromEmptyDeck
    }
    
    // TODO: allow multiple cards to be drawn randomly from deck
    mutating func drawRandomCards(drawAmount: Int) throws -> [Card] {
        throw DeckError.insufficientCardsRemaining()
    }
    
    static func ==(left: Deck, right: Deck) -> Bool {
        guard left.numSubDecks == right.numSubDecks else {
            return false
        }

        return left.decks =/ right.decks
    }
}

enum DeckError: Error {
    case drawFromEmptyDeck
    case insufficientCardsRemaining(cardsDrawn: [Card] = [], message: String = "")
    case negativeDrawAttempt
}

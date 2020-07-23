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
        get { decks }
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
    /**
     Shuffle the main deck of cards by changing the ordering of the card array.
     
     The ordering of the main deck is guaranteed to change so long as it is not an empty deck.
     
     - Returns: The shuffled main deck
     */
    @discardableResult
    mutating func shuffle() -> [Card] {
        guard deckSize > 0 else {
            return []
        }
        // ensure that the ordering of the main deck is changed
        let tempDeck = decks
        while tempDeck == decks {
            decks.shuffle()
        }
        return deck
    }
    /**
     Shuffle a deck of cards by changing the ordering of the card array.
     
     The ordering of the deck is guaranteed to change so long as it is not an empty deck.
     
     - Parameter deck: The array of cards to shuffle the ordering of
     - Returns: The shuffled deck of cards
     */
    static func shuffle(deck: [Card]) -> [Card] {
        guard deck.count > 0 else {
            return []
        }
        // ensure that the ordering of the deck is changed
        var shuffledDeck = deck
        while shuffledDeck == deck {
            shuffledDeck.shuffle()
        }
        return shuffledDeck
    }
    
    /**
     Draw the card from the top of the main deck (0th index)
     
     - Throws: 'DeckError.drawFromEmptyDeck'
                if there are no more cards in the main deck to draw
                (deckSize is 0)
     
     - Returns: The top card (0th index) of the main deck
     */
    mutating func drawCard() throws -> Card {
        guard deckSize > 0 else {
            throw DeckError.drawFromEmptyDeck
        }
        return decks.removeFirst()
    }

    /**
     Allow multiple cards to be drawn from the top of the deck (starting at the 0th index)
     
     - Parameter drawAmount: The number of cards to draw from the deck
     
     - Throws:
        - 'DeckError.negativeDrawAttempt' if the draw amount is less than 0
        - 'DeckError.insufficientCardsRemaining' if the draw amount is greater than the
            amount of cards in  the deck
     
     - Returns: An array of the cards that were drawn from the main deck.
     */
    mutating func drawCards(drawAmount: Int) throws -> [Card]  {
        guard drawAmount > 0 else {
            throw DeckError.negativeDrawAttempt
        }
        
        var drawnCards: [Card] = []
        guard drawAmount <= deckSize else {
            // draw the remaining cards from the main deck
            drawnCards = decks
            decks.removeAll()
            throw DeckError.insufficientCardsRemaining(cardsDrawn: drawnCards, message: "attempted to draw \(drawAmount) cards but there were only \(drawnCards.count) cards in the deck")
        }
        
        for _ in 0..<drawAmount {
            try drawnCards.append(drawCard())
        }
        return drawnCards
    }
    
    /**
     Allow card to be drawn randomly from deck.
     
     Uses Array.randomElement function to apply randomness
     
     - Throws: 'DeckError.drawFromEmptyDeck'
                 if there are no more cards in the main deck to draw
                 (deckSize is 0)
     
     - Returns: The random card that was removed from the main deck
     */
    mutating func drawRandomCard() throws -> Card {
        guard deckSize > 0 else {
            throw DeckError.drawFromEmptyDeck
        }
        return decks.remove(at: decks.firstIndex(of: decks.randomElement()!)!)
    }
    
    /**
     Allow multiple cards to be drawn from the top of the deck (starting at the 0th index)
     
     - Parameter drawAmount: The number of cards to draw from the deck
     
     - Throws:
     - 'DeckError.negativeDrawAttempt' if the draw amount is less than 0
     - 'DeckError.insufficientCardsRemaining' if the draw amount is greater than the
     amount of cards in  the deck
     
     - Returns: An array of the cards that were randomly drawn from the main deck.
     */
    mutating func drawRandomCards(drawAmount: Int) throws -> [Card] {
        guard drawAmount > 0 else {
            throw DeckError.negativeDrawAttempt
        }
        
        var drawnCards: [Card] = []
        guard drawAmount <= deckSize else {
            // randomly draw the remaining cards from the main deck
            for _ in 0..<deckSize {
                try drawnCards.append(drawRandomCard())
            }
            throw DeckError.insufficientCardsRemaining(cardsDrawn: drawnCards, message: "attempted to draw \(drawAmount) cards but there were only \(drawnCards.count) cards in the deck")
        }
        
        for _ in 0..<drawAmount {
            try drawnCards.append(drawRandomCard())
        }
        return drawnCards
    }
    
    static func ==(left: Deck, right: Deck) -> Bool {
        // both decks should have the same number of sub-decks
        guard left.numSubDecks == right.numSubDecks else {
            return false
        }
        // check if the card arrays are equal
        return left.decks =/ right.decks
    }
}

/// Possible errors that can arise from using the Deck struct
enum DeckError: Error {
    /// There are 0 cards inside the deck being drawn from.
    case drawFromEmptyDeck
    /**
     The draw amount is greater than the amount of cards in the deck.
     
     - Associated Values:
        - cardsDrawn: The cards that were successfully drawn before the deck ran out of cards
        - message: The reason for the thrown error
     */
    case insufficientCardsRemaining(cardsDrawn: [Card] = [], message: String = "")
    /// Tried to draw a negative amount of cards from a deck
    case negativeDrawAttempt
}

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
    
    // MARK: Properties
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
    /// Getter for the main deck (also a setter if the main deck is empty).
    var deckCards: [Card] {
        get { decks }
        set {
            if decks.isEmpty {
                decks = newValue
            }
        }
    }
    /// Getter for the amount of cards in the main deck
    var deckSize: Int {
        get { decks.count }
    }
    /// The number of sub-decks this instance is using.
    @AllowedNumSubDecks private var numSubDecks: Int
    
    // MARK: Initialization
    
    /**
     Initializes a new deck that has a specified number of sub-decks within it and has the possibility of being shuffled by default.
     
     - Parameters:
        - numSubDecks: The number of subdecks within the main deck. Each sub-deck is itself a full deck containing 52 cards.
        - shuffle: Creates a shuffled deck if true, otherwise just creates a deck that will always have the same ordering when created
     */
    init(numSubDecks: Int = 1, shuffle: Bool = false) {
        self.numSubDecks = numSubDecks
        if shuffle {
            createShuffledDeck(numSubDecks: self.numSubDecks)
        } else {
            createDeck(numSubDecks: self.numSubDecks)
        }
    }
    
    // MARK: Methods
    
    /**
     Determines the highest card rank inside an array of cards
     
     - Parameter cards: The cards to examine and determine the highest card rank amongst the cards
     
     - Precondition: `cards` must not be empty
     
     - Returns: The highest card rank amongst `cards`
     
     - Note: The card rank of "Ace" is determined as the highest possible card rank instead of as the lowest possible rank
     */
    static func determineHighestRank(in cards: [Card]) -> Card.Rank {
        precondition(!cards.isEmpty, "An empty array does not possess a highest ranked card")
        
        var highestRank = Card.Rank.two
        for card in cards {
            if highestRank < card.rank {
                highestRank = card.rank
            }
        }
        return highestRank
    }
    /**
     Creates the cards for the main deck according to the specified number of sub-decks.
     
     This function creates a new main deck for this Deck instance
     
     - Parameter numSubDecks: The number of sub-decks you want the created deck to contain (a sub-deck consists of 52 cards). The range for the amount of sub-decks is 0-10 inclusive.
     - Returns: The deck containing the specified amount of sub-decks that was created
     */
    @discardableResult
    mutating func createDeck(numSubDecks: Int) -> [Card] {
        // erase current decks if they exist
        decks.removeAll()
        // change the number of sub-decks
        self.numSubDecks = numSubDecks
        
        // loop to create sub-decks
        for _ in 0 ..< self.numSubDecks {
            for rank in Card.Rank.allCases {
                for suit in Card.Suit.allCases {
                    decks.append(Card(suitValue: suit, rankValue: rank))
                }
            }
            
        }
        return deckCards
    }
    /**
     Creates the cards for a main deck according to the specified number of sub-decks.
     
     - Parameter numSubDecks: The number of sub-decks you want the created deck to contain (a sub-deck consists of 52 cards). The range for the amount of sub-decks is 0-10 inclusive.
     - Returns: The deck containing the specified amount of sub-decks that was created
     */
    @discardableResult
    static func createDeck(numSubDecks: Int = 1) -> [Card] {
        // as of 07/23/20: 'Property wrappers are not yet supported on local properties'
        // enforce sub-deck amount limits
        var subDecks = min(numSubDecks, AllowedNumSubDecks.maxNumSubDecks)
        subDecks = max(numSubDecks, AllowedNumSubDecks.minNumSubDecks)
        
        // the deck being created
        var deck = [Card]()
        
        // set the size of the array
        deck.reserveCapacity(subDecks * Deck.defaultDeckSize)
        
        // loop to create sub-decks
        for _ in 0 ..< subDecks {
            for suit in Card.Suit.allCases {
                for rank in Card.Rank.allCases {
                    deck.append(Card(suitValue: suit, rankValue: rank))
                }
            }
            
        }
        return deck
    }
    
    /**
     Create a fresh, shuffled deck that contains the specified amount of sub-decks.
     
     The created and shuffled deck becomes the new main deck for this instance.
     
     - Note: Calling this function is equivalent to:
        ~~~
        var newDeck = Deck(numSubDecks: someNumber0to10)
        var shuffledDeck = newDeck.shuffle()
        ~~~
     or
        ~~~
        var newDeck = Deck().createDeck(numSubDecks: someNumber0to10)
        var shuffledDeck = newDeck.shuffle()
        ~~~
     
     - Parameter numSubDecks: The number of sub-decks you want the created deck to contain (a sub-deck consists of 52 cards). The range for the amount of sub-decks is 0-10 inclusive.
     - Returns: The new deck after it has been shuffled.
     */
    @discardableResult
    mutating func createShuffledDeck(numSubDecks: Int = 1) -> [Card] {
        createDeck(numSubDecks: numSubDecks)
        return shuffle()
    }
    
    /**
     Create a fresh, shuffled deck that contains the specified amount of sub-decks.
     
     - Note: Calling this function is equivalent to:
     
        ~~~
        var newDeck = Deck.createDeck(numSubDecks: someNumber0to10)
        var shuffledDeck = Deck.shuffle(deck: newDeck)
        ~~~
     
     - Parameter numSubDecks: The number of sub-decks you want the created deck to contain (a sub-deck consists of 52 cards). The range for the amount of sub-decks is 0-10 inclusive.
     - Returns: The new deck after it has been shuffled.
     */
    @discardableResult
    static func createShuffledDeck(numSubDecks: Int = 1) -> [Card] {
        Deck.shuffle(deck: Deck.createDeck(numSubDecks: numSubDecks))
    }
    /**
     Shuffle the main deck of cards by changing the ordering of the card array.
     
     The main deck itself is mutated and a copy of the result is returnded by the function. The ordering of the main deck is guaranteed to change so long as it is not an empty deck.
     
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
        return deckCards
    }
    /**
     Shuffle a deck of cards by changing the ordering of the card array.
     
     The ordering of the deck is guaranteed to change so long as it is not an empty deck.
     
     - Parameter deck: The array of cards to shuffle the ordering of
     - Returns: The shuffled deck of cards
     */
    @discardableResult
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
     Draw the card from the top of the passed in deck (0th index)
     
     - Throws: 'DeckError.drawFromEmptyDeck'
     if there are no more cards in the main deck to draw
     (deckSize is 0)
     - Parameter from: The card array to draw a card from
     - Returns: The top card (0th index) of the passed in deck
     */
    static func drawCard(from: inout [Card]) throws -> Card {
        guard from.count > 0 else {
            throw DeckError.drawFromEmptyDeck
        }
        return from.removeFirst()
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
        
        for _ in 0 ..< drawAmount {
            try drawnCards.append(drawCard())
        }
        return drawnCards
    }
    
    /**
     Allow multiple cards to be drawn from the top of the passed in deck (starting at the 0th index)
     
     - Parameters:
        - drawAmount: The number of cards to draw from the deck
        - from: The card array from which to draw cards from.
     
     - Throws:
        - 'DeckError.negativeDrawAttempt' if the draw amount is less than 0
        - 'DeckError.insufficientCardsRemaining' if the draw amount is greater than the
     amount of cards in  the deck
     
     - Returns: An array of the cards that were drawn from the passed in deck.
     */
    static func drawCards(drawAmount: Int, from: inout [Card]) throws -> [Card]  {
        guard drawAmount > 0 else {
            throw DeckError.negativeDrawAttempt
        }
        
        var drawnCards: [Card] = []
        guard drawAmount <= from.count else {
            // draw the remaining cards from the main deck
            drawnCards = from
            from.removeAll()
            throw DeckError.insufficientCardsRemaining(cardsDrawn: drawnCards, message: "attempted to draw \(drawAmount) cards but there were only \(drawnCards.count) cards in the deck")
        }
        
        for _ in 0 ..< drawAmount {
            try drawnCards.append(Deck.drawCard(from: &from))
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
     Allow card to be drawn randomly from an array of cards.
     
     Uses Array.randomElement function to apply randomness
     
     - Parameter from: The array of cards to draw randomly from
     
     - Throws: 'DeckError.drawFromEmptyDeck'
     if there are no more cards in the array of cards to draw
     
     - Returns: The random card that was removed from the array of cards
     */
    static func drawRandomCard(_ from: inout [Card]) throws -> Card {
        guard !from.isEmpty else {
            throw DeckError.drawFromEmptyDeck
        }
        return from.remove(at: from.firstIndex(of: from.randomElement()!)!)
    }
    
    /**
     Allow multiple cards to be drawn randomly from the deck
     
     - Parameter drawAmount: The number of cards to draw randomly from the deck
     
     - Throws:
        - 'DeckError.negativeDrawAttempt' if the draw amount is less than 0
        - 'DeckError.insufficientCardsRemaining' if the draw amount is greater than the
     amount of cards in the deck
     
     - Returns: An array of the cards that were randomly drawn from the main deck.
     */
    mutating func drawRandomCards(drawAmount: Int) throws -> [Card] {
        guard drawAmount > 0 else {
            throw DeckError.negativeDrawAttempt
        }
        
        var drawnCards: [Card] = []
        guard drawAmount <= deckSize else {
            // randomly draw the remaining cards from the main deck
            for _ in 0 ..< deckSize {
                try drawnCards.append(drawRandomCard())
            }
            throw DeckError.insufficientCardsRemaining(cardsDrawn: drawnCards, message: "attempted to draw \(drawAmount) cards but there were only \(drawnCards.count) cards in the deck")
        }
        
        for _ in 0 ..< drawAmount {
            try drawnCards.append(drawRandomCard())
        }
        return drawnCards
    }
    
    /**
     Allow multiple cards to be drawn randomly from an array of cards
     
     - Parameters:
        - drawAmount: The number of cards to draw randomly from an array of cards
        - from: The array of cards to draw randomly from
     
     - Throws:
        - 'DeckError.negativeDrawAttempt' if the draw amount is less than 0
        - 'DeckError.insufficientCardsRemaining' if the draw amount is greater than the
     amount of cards in array of cards
     
     - Returns: An array of the cards that were randomly drawn from the array of cards.
     */
    static func drawRandomCards(drawAmount: Int, from: inout [Card]) throws -> [Card] {
        guard drawAmount > 0 else {
            throw DeckError.negativeDrawAttempt
        }
        
        var drawnCards: [Card] = []
        guard drawAmount <= from.count else {
            // randomly draw the remaining cards from the array of cards
            for _ in 0 ..< from.count {
                try drawnCards.append(Deck.drawRandomCard(&from))
            }
            throw DeckError.insufficientCardsRemaining(cardsDrawn: drawnCards, message: "attempted to draw \(drawAmount) cards but there were only \(drawnCards.count) cards in the array of cards")
        }
        
        for _ in 0 ..< drawAmount {
            try drawnCards.append(Deck.drawRandomCard(&from))
        }
        return drawnCards
    }
    
    /**
     Compares two Deck objects to see if they are equivalent
     
     - Parameters:
        - left: A Deck object to compare
        - right: A Deck objec to compare
     
     - Returns: True if the two Deck objects possess the same amount of sub-decks and have equivalent card arrays, false otherwise.
     */
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

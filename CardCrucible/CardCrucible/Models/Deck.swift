//
//  Deck.swift
//  CardCrucible
//
//  Created by Matthew Kressin on 7/9/20.
//  Copyright © 2020 Matthew Kressin. All rights reserved.
//

import Foundation

/// A deck containing a multiple of all 52 individual cards
struct Deck {
    
    // Mark: - SizeConstraints
    
    /// Ensures that there is an upper and lower limit for the amount of sub-decks allowed
    /// for the main deck
    @propertyWrapper
    struct MultipleOf52Limit {
        /// The maximum amount of sub-decks allowed
        let maxNumDecks = 10
        /// The minimum amount of sub-decks allowed
        let minNumDecks = 0
        /// The number of sub-decks that has been forced within the minimum and
        /// maximum constraints
        var numDecks: Int
        init(wrappedValue: Int) {
            numDecks = min(wrappedValue, maxNumDecks)
            numDecks = max(numDecks, minNumDecks)
        }
        
        var wrappedValue: Int {
            get { return numDecks }
            set {
                numDecks = min(newValue, maxNumDecks)
                numDecks = max(numDecks, minNumDecks)
            }
        }
    }
    /// The default amount of cards inside a single deck
    let defaultDeckSize = 52
    
    private var decks: [Card]?
    var deck: [Card]? {
        get { return decks }
    }
    /// The number of sub-decks this instance is using.
    @MultipleOf52Limit private var numDecks: Int
    
    /**
     Initializes a new deck that has a specified number of sub-decks within it.
     
     - Parameter numDecks: The number of subdecks within the main deck. Each sub-deck is itself a full deck containing 52 cards.
     */
    init(numDecks: Int = 1) {
        self.numDecks = numDecks
        createDeck()
    }
    
    /**
     Creates the cards and adds them to the overall deck according to the amount of decks
     specified during initialization of the instance.
     
     - Returns: The deck that was created that contains the amount of sub-decks
     specified during initialization
     */
    @discardableResult
    mutating func createDeck() -> [Card]? {
        // loop to create sub-decks
        for _ in 0...numDecks {
            for suit in Card.Suit.allCases {
                for rank in Card.Rank.allCases {
                    decks!.append(Card(suitValue: suit, rankValue: rank))
                }
            }
            
        }
        return deck
    }
    
    // TODO: allow card to be drawn from deck
    func drawCard() {
        
    }
    // TODO: allow multiple cards to be drawn
    func drawCards(drawAmount: Int) {
        
    }
    
    // TODO: shuffle the cards in the deck
    func shuffle() {
        
    }
}

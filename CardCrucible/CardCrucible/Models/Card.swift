//
//  Card.swift
//  CardCrucible/Models
//
//  Created by Matthew Kressin on 7/7/20.
//  Copyright © 2020 Matthew Kressin. All rights reserved.
//

import Foundation
import SwiftUI
import SwiftyJSON

/// An object used in multiple games, consisting of a Card suit and a Card rank
struct Card {
    /// The Suit of the card
    enum Suit: String, CaseIterable {
        case clubs = "Clubs", diamonds = "Diamonds", hearts = "Hearts",
            spades = "Spades"
    }
    
    /// The Rank of the card
    enum Rank: String, CaseIterable {
        case ace
        case two, three, four, five, six, seven, eight, nine, ten
        case jack, queen, king
        
        /**
         Returns the default, numeric value associated with the passed in rank
         
         - Parameter rank: The Card rank to get the numeric value of.
         
         - Returns: The default, numeric value of the passed in rank
         */
        static func defaultValue(rank: Rank) -> Int {
            switch rank {
            case .ace:
                return 1
            case .two:
                return 2
            case .three:
                return 3
            case .four:
                return 4
            case .five:
                return 5
            case .six:
                return 6
            case .seven:
                return 7
            case .eight:
                return 8
            case .nine:
                return 9
            case .ten:
                return 10
            case .jack, .queen, .king:
                return 10
            }
        }
        
        /**
         Get the equivalent rank of the passed in string
         
         - Parameter stringRank: The string equivalent of a Card rank.
         
         - Returns: The Card rank equivalent of the passed in string if the string is
                    valid, otherwise nil
         */
        static func fromString(stringRank: String) -> Rank? {
            switch stringRank {
            case "ace":
                return Rank.ace
            case "two":
                return Rank.two
            case "three":
                return Rank.three
            case "four":
                return Rank.four
            case "five":
                return Rank.five
            case "six":
                return Rank.six
            case "seven":
                return Rank.seven
            case "eight":
                return Rank.eight
            case "nine":
                return Rank.nine
            case "ten":
                return Rank.ten
            case "jack":
                return Rank.jack
            case "queen":
                return Rank.queen
            case "king":
                return Rank.king
            default:
                return nil
            }
        }
    }
    
    /// The suit that the card belongs to,
    let suit: Suit
    /// The rank that the card possesses.
    let rank: Rank
    /// The value associated with the card's rank.
    let cardValue: Int
    /// The description of the card's suit, rank, and card value.
    var description: String {
        get {
            return "Card is the \(self.rank.rawValue) of \(self.suit.rawValue) with a value of \(cardValue)"
        }
    }
    
    /// The name of the image to be used to display the card
    fileprivate let imageName: String
    /// JSON object containing the image names for all 52 cards in a deck
    fileprivate static var cardsJSON: JSON? = readInJSON(fileName: "cardData")
    
    /// Initializes a playing card
    ///
    /// - Parameters:
    ///   - suitValue: The suit of the card ("clubs", "diamonds", "heart", "spades")
    ///   - rankValue: The rank of the card (Ace, two, three, ..., ten, jack, queen,
    ///                 king)
    init(suitValue: Suit, rankValue: Rank) {
        self.suit = suitValue
        self.rank = rankValue
        self.cardValue = Rank.defaultValue(rank: rankValue)
        self.imageName = Card.getImageName(suit: suitValue, rank: rankValue)
    }
    
    /**
     Create a JSON object by reading in the data from the file of the passed in name.
     
     - Requires: [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON)
     
     - Parameter fileName: The name of the file to read the data from.
     
     - Returns: A JSON object of the data read in from the specified file, or nil if an
     error occurred.
     
     - Note: Using code from [stackoverflow answer](https://stackoverflow.com/a/28644494)
     */
    fileprivate static func readInJSON(fileName: String) -> JSON? {
        if let path = Bundle.main.path(forResource: fileName,
                                       ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let jsonObj = try JSON(data: data)
                return jsonObj
            } catch let error {
                print("parse error: \(error.localizedDescription)")
                return nil
            }
        } else {
            print("Invalid filename/path.")
            return nil
        }
    }
    
    /**
     Gets the image name of the card to display.
     
     - Important: Will throw a fatalError() if Card.cardsJSON is nil.
     
     - Parameters:
         - suit: The suit of the card to display.
         - rank: The rank of the card to display.
     
     - Returns: The name of the card image corresponding to the passed in suit and Rank.
     */
    fileprivate static func getImageName(suit: Suit, rank: Rank) -> String {
        guard Card.cardsJSON != nil else {
            fatalError("error trying to read in card image names")
        }
        return Card.cardsJSON![suit.rawValue][rank.rawValue].stringValue
    }
    
    /// Allows cards to be compared against each other based on their Card Rank
    ///
    ///Ace \< two \< three \< ... \< ten \< jack \< queen \< king
    ///
    /// - Parameters:
    ///   - left: The Card on the left of the less-than sign
    ///   - right: The Card on the right of the less-than sign
    ///
    /// - Returns: True if the Card on the left is less-than the Card on the right, otherwise false
    static func <(left: Card, right: Card) -> Bool {
        // only need to address special case for face cards
        if (left.cardValue != 10 || right.cardValue != 10) {
            return left.cardValue < right.cardValue
        }
        // check if cards have the same rank
        else if (left.rank == right.rank) {
            return false
        }
        // check if left card is a ten and right is a face card
        else if (left.rank == Rank.ten) {
            return true
        }
        // check if right card is a ten a left is a face card
        else if (right.rank == Rank.ten) {
            return false
        }
        // check if left card is a jack (smallest valued face card)
        else if (left.rank == Rank.jack) {
            return (right.rank != Rank.ten)
        }
        // check if left card is a king (largest valued face card)
        else if (left.rank == Rank.king) {
            return false
        }
        // left card is a queen and right card is either a jack or king, so we
        // can switch the ordering and return the opposite result
        else {
            return !(right < left)
        }
    }
}

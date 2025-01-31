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
struct Card: Equatable, Comparable {
    /// The Suit of the card
    enum Suit: String, CaseIterable, Comparable {
        case clubs = "Clubs", diamonds = "Diamonds", hearts = "Hearts",
            spades = "Spades"
        
        static func < (lhs: Card.Suit, rhs: Card.Suit) -> Bool {
            lhs.rawValue < rhs.rawValue
        }
    }
    
    /// The Rank of the card
    enum Rank: Int, CaseIterable, Comparable {
        case two = 2, three, four, five, six, seven, eight, nine, ten
        case jack, queen, king
        case ace
        
        /**
         Get the equivalent rank of the passed in string
         
         - Parameter stringRank: The string equivalent of a Card rank.
         
         - Returns: The Card rank equivalent of the passed in string if the string is
                    valid, otherwise nil
         */
        static func fromString(stringRank: String) -> Rank? {
            switch stringRank.lowercased() {
            case "two", "2":
                return .two
            case "three", "3":
                return .three
            case "four", "4":
                return .four
            case "five", "5":
                return .five
            case "six", "6":
                return .six
            case "seven", "7":
                return .seven
            case "eight", "8":
                return .eight
            case "nine", "9":
                return .nine
            case "ten", "10":
                return .ten
            case "jack", "j":
                return .jack
            case "queen", "q":
                return .queen
            case "king", "k":
                return .king
            case "ace", "a":
                return .ace
            default:
                return nil
            }
        }
        
        /**
         Converts the given rank to its equivalent String value
         
         - Parameter rank: The rank to convert to a string
         
         - Returns: The String equivalent of the passed in Rank
         */
        static func toString(rank: Rank) -> String {
            switch rank {
                case .ace:
                    return "Ace"
                case .two:
                    return "Two"
                case .three:
                    return "Three"
                case .four:
                    return "Four"
                case .five:
                    return "Five"
                case .six:
                    return "Six"
                case .seven:
                    return "Seven"
                case .eight:
                    return "Eight"
                case .nine:
                    return "Nine"
                case .ten:
                    return "Ten"
                case .jack:
                    return "Jack"
                case .queen:
                    return "Queen"
                case .king:
                    return "King"
            }
        }
        
        static func < (lhs: Card.Rank, rhs: Card.Rank) -> Bool {
            lhs.rawValue < rhs.rawValue
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
            return "Card is the \(Rank.toString(rank: self.rank)) of \(self.suit.rawValue)"
        }
    }
    /// String value representing the card's rank and suit
    var name: String {
        get {
            imageName
        }
    }
    
    /// The name of the image to be used to display the card
    fileprivate let imageName: String
    /// JSON object containing the image names for all 52 cards in a deck
    fileprivate static var cardsJSON: JSON? = readInJSON(fileName: "cardData")
    
    // MARK: Initialization
    
    /// Initializes a playing card
    ///
    /// - Parameters:
    ///   - suitValue: The suit of the card ("clubs", "diamonds", "heart", "spades")
    ///   - rankValue: The rank of the card (Ace, two, three, ..., ten, jack, queen,
    ///                 king)
    init(suitValue: Suit, rankValue: Rank) {
        self.suit = suitValue
        self.rank = rankValue
        self.cardValue = self.rank.rawValue
        self.imageName = Card.getImageName(suit: suitValue, rank: rankValue)
    }
    
    // MARK: Methods
    
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
        return Card.cardsJSON![suit.rawValue][Rank.toString(rank: rank)].stringValue
    }
    
    /**
     Constructs a string containing all of the cards inside of the card array and then prints the string.
     
     - Parameter cards: The array of cards to print
     */
    internal static func printCards(_ cards: [Card]) {
        var msg = "cards: ["
        for card in cards {
            msg += "\"\(card.imageName)\","
        }
        msg = msg.prefix(msg.count-1) + "]"
        print(msg)
    }
    
    /**
     Two cards are the same if they possess the same suit, rank, and card value
     */
    static func ==(left: Card, right: Card) -> Bool {
        left.suit == right.suit && left.rank == right.rank && left.cardValue == right.cardValue
    }
    /// Compare the card values of two cards
    static func < (left: Card, right: Card) -> Bool {
        left.cardValue < right.cardValue
    }
}

extension Card {
    var image: Image {
        Image(imageName)
    }
}
infix operator =/ : AssignmentPrecedence
func =/(left: [Card], right: [Card]) -> Bool {
    guard left.count == right.count else {
        return false
    }
    for i in 0..<left.count {
        if left[i] != right[i] {
            return false
        }
    }
    return true
}

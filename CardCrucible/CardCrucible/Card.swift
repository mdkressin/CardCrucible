//
//  Card.swift
//  CardCrucible
//
//  Created by Matthew Kressin on 7/7/20.
//  Copyright © 2020 Matthew Kressin. All rights reserved.
//

import Foundation

struct Card {
    // The Suit of the card
    enum Suit: String {
        case clubs = "Clubs", diamonds = "Diamonds", hearts = "Hearts",
            spades = "Spades"
    }
    
    // The Rank of the card
    enum Rank: String {
        case ace
        case two, three, four, five, six, seven, eight, nine
        case jack, queen, king
        
        /*
         Returns the default value associated with the passed in rank
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
            case .jack, .queen, .king:
                return 10
            }
        }
        
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
    
    
    let suit: Suit
    let rank: Rank
    let cardValue: Int
    
    init(suit: Suit, rank: Rank) {
        self.suit = suit
        self.rank = rank
        self.cardValue = Rank.defaultValue(rank: rank)
    }
    
    /*
     jack < queen < king
     */
    static func <(left: Card, right: Card) -> Bool {
        // only need to address special case for face cards
        if (left.cardValue != 10 || right.cardValue != 10) {
            return left.cardValue < right.cardValue
        }
        // check if cards have the same rank
        else if (left.rank == right.rank) {
            return false
        }
        // check if left card is a jack (smallest valued face card)
        else if (left.rank == Rank.jack) {
            return true
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

//
//  Player.swift
//  CardCrucible
//
//  Created by Matthew Kressin on 7/26/20.
//  Copyright © 2020 Matthew Kressin. All rights reserved.
//

import Foundation

/**
 A representation of a person who is participating in a card game.
 */
class Player: Hashable, Comparable, NSCopying {
    // MARK: Properties
    
    /// The name of the player
    var name: String
    /// The unique id of the player
    let playerID: UUID
    /// Gets the unique string representing the player's id
    var id: String {
        get { playerID.uuidString }
    }
    /// The cards that the player holds (a.k.a. hand)
    var cards: [Card]
    /// The number of cards the player currently has
    var numCards: Int {
        get { cards.count }
    }
    /// The player's score in the game
    var score: Int?
    /// The last card that was played by the player
    var lastPlayedCard: Card?
    
    // MARK: Initialization
    
    /**
    Initializes a brand new player with the given name as well as a unique id and an empty array of cards or it can be used by subclasses to transform a Player object into an object of one of its subclasses
     
     ~~~
     // new Player:
     let player = Player("player's name")
     
     // use in sub-class
     class SubPlayer: Player {
        init(_ player: Player) {
            super.init(player.name, player.playerID, player.cards)
            // other initialization stuff for sub-class
        }
     }
     ~~~
     
     - Parameters:
        - name: The name of the player
        - id: The unique id to be used for the player. If a UUID value is given, then that value is used as the id, otherwise a unique id is generated
        - cards: The cards that player possesses. If a value is given, then the value is used for the cards that the player will start off with, otherwise it is an empty array of cards
     */
    init(_ name: String, _ id: UUID = UUID(), _ cards: [Card] = [Card]()) {
        self.name = name
        self.playerID = id
        self.cards = cards
    }
    
    // MARK: Methods
    /**
     Adds a new card to the cards that the player already has
     
     - Parameter newCard: The new card to add to the player's cards
     */
    func addToCards(_ newCard: Card) {
        cards.append(newCard)
    }
    
    /**
     Adds a group of new cards to the cards that the player already has
     
     - Parameter newCards: The new cards to add to the player's cards
     */
    func addToCards(_ newCards: [Card]) {
        cards += newCards
    }
    
    /**
     A shallow evaluation of whether two Player objects represent the same player.
     
     - Parameters:
        - lhs: A player object to compare
        - rhs: A player object to compare
     
     - Returns: True if the two Player objects have the same id and name, false otherwise
     */
    static func ==(lhs: Player, rhs: Player) -> Bool {
        lhs.playerID == rhs.playerID && lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(playerID)
    }
    /**
     Allows a sense of ordering to be applied to Player objects
     
     - Parameters:
        - lhs: A player object to compare
        - rhs: A player object to compare
     
     - Returns: True if the player on the left has an id that is less than the player on the right, false otherwise.
     */
    static func < (lhs: Player, rhs: Player) -> Bool {
        lhs.id < rhs.id
    }
    /**
     A deeper evaluation of whether two Player objects represent  the same player.
     
     The two player objects are first compared using the shallow evaluation and if it returns true, then it compares the cards that the two players possess the same cards.
     
     - Parameters:
        - lhs: A player object to compare
        - rhs: A player object to compare
     
     - Returns: True if the two Player objects possess the same id, name, and cards, false otherwise.
     */
    static func =/ (lhs: Player, rhs: Player) -> Bool {
        return lhs == rhs && (lhs.cards =/ rhs.cards)
    }
    /**
     Construct a copy of the Player object and return it
     
     - Returns: An identical copy of the Player
     */
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Player(name, playerID, cards)
        return copy
    }
}


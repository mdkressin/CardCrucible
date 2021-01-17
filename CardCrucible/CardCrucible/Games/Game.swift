//
//  Game.swift
//  CardCrucible
//
//  Created by Matthew Kressin on 7/26/20.
//  Copyright © 2020 Matthew Kressin. All rights reserved.
//

import Foundation

/**
 The minimal logic behind a card game.
 
 - Important: This class does not provide any functionality for a card game besides providing a deck of cards and an array of players that are participating in the game (includes functions to add player(s) to the array of players).
 */
class Game: CardGame {
    // MARK: Properties
    
    /// The deck of cards to be used during the game
    var gameDeck: Deck
    /// Getter for the cards inside of `gameDeck`
    var deckCards: [Card] {
        get { gameDeck.deckCards }
    }
    /// The number of players participating in the game
    var numPlayers: Int {
        get { players.count }
    }
    
    /// The players participating in the game
    var players = [String: Player]()
    
    /// Flag to see if the game is still in progress or the game is over
    var gameover = false
    
    // MARK: Initialization
    /**
     Initializes a new game with a deck containing the specified amount of subdecks
     
     - Parameter numSubDecks: The number of sub-decks that the main deck should contain
     */
    required init(numSubDecks: Int = 1) {
        gameDeck = Deck(numSubDecks: numSubDecks, shuffle: true)
    }
    
    /**
     Initializes a new game with a deck containing the specified amount of subdecks and with the given players
     
     - Parameters:
        - numSubDecks: The number of sub-decks that the main deck should contain
        - withPlayers: The players that will participate in the game
     */
    convenience init(numSubDecks: Int = 1, withPlayers: [Player]) {
        self.init(numSubDecks: numSubDecks)
        addPlayers(players: withPlayers)
    }
    
    // MARK: Methods
    
    /**
     Adds the given player to the game
     
     - Parameter player: The player to add to the game
     */
    func addPlayer(player: Player) {
        players[player.id] = player
    }
    /**
     Adds a list of players to the game
     
     - Parameter players: The list of players to add to the game
     */
    func addPlayers(players: [Player]) {
        for player in players {
            addPlayer(player: player)
        }
    }
    
    /**
     Abstract method to be implemented by subclasses
     
     - Warning: Method will cause a runtime error if not overriden by method in its subclass
     */
    func dealCards() {
        // Implemented by subclasses
        preconditionFailure("This method must be overwritten")
    }
    
    /**
     Abstract method to be implemented by subclasses
     
     - Warning: Method will cause a runtime error if not overriden by method in its subclass
     */
    func startGame() {
        // Implemented by subclasses
        preconditionFailure("This method must be overwritten")
    }
}

/**
 Signifies different possible events that can occur during a game.
 */
enum GameEvent: Error {
    /**
     The game or round ended in a war
     
     - Associated Value:
        - `players`: The ids of the participating players who ended up in a draw
     */
    case draw(players: [String])
}

/**
 The basic requirements that a card game should adhere to
 */
protocol CardGame {
    /// Initialize a card game
    init(numSubDecks: Int)
    /// Add a player to the game
    func addPlayer(player: Player)
    /// Distribute the game's deck of cards according to the rules of the game being played
    func dealCards()
    /// Start the game
    func startGame()
}

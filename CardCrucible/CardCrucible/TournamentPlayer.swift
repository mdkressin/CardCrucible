//
//  WarPlayer.swift
//  CardCrucible
//
//  Created by Matthew Kressin on 12/25/20.
//  Copyright © 2020 Matthew Kressin. All rights reserved.
//

import Foundation

/**
 A type of player that is participating in a card game that involves elimination
 
 - Note: The player is not necessarily a part of a tournament and it is also possible that the game being played allows for the join again after elimination
 */
class TournamentPlayer: Player {
    
    // MARK: Properties
    /// Whether the player has been eliminated from the game or not
    fileprivate var eliminated = false
    /// Gets whether player has been eliminated yet and sets whether players has been eliminated yet
    var isEliminated: Bool {
        get { eliminated }
        set { eliminated = newValue }
    }
    /// Gets whether player has not been eliminated yet and sets whether players has not been eliminated yet
    var isNotEliminated: Bool {
        get { !eliminated }
        set { eliminated = !newValue }
    }
    
    // MARK: Initialization
    /**
     Create a new TournamentPlayer object
     
     - Parameter name: The name of the player
     */
    init(_ name: String) {
        super.init(name)
    }
    /**
     Construct a TournamentPlayer object from a Player object
     
     - Parameter player: The player to construct a TournamentPlayer object of
     */
    init(_ player: Player) {
        super.init(player.name, player.playerID, player.cards)
    }
    /**
     Construct a new TournamentPlayer object
     
     - Parameters:
        - name: The name for the player
        - id: The id for the player. If no id is provided, then a unique id is generated for the player
        - cards: The cards the player will possess. If no cards are provided, then the player is given an empty array of cards
     */
    override init(_ name: String, _ id: UUID = UUID(), _ cards: [Card] = [Card]()) {
        super.init(name, id, cards)
    }

    // MARK: Methods
    /**
     Takes an array of Players and returns them as an array of TournamentPlayers
     
     - parameter players: The list of players to transform into TournamentPlayers
     
     - returns: The given array of Players as an array of TournamentPlayers
     */
    static func toTournamentPlayers(_ players: [Player]) -> [TournamentPlayer] {
        var newPlayers = [TournamentPlayer]()
        for player in players {
            newPlayers.append(TournamentPlayer(player))
        }
        return newPlayers
    }
    
    /**
     Construct a copy of the TournamentPlayer object and return it
     
     - Returns: An identical copy of the TournamentPlayer
     */
    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = TournamentPlayer(name, playerID, cards)
        return copy
    }
}

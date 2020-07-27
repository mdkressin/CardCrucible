//
//  Game.swift
//  CardCrucible
//
//  Created by Matthew Kressin on 7/26/20.
//  Copyright © 2020 Matthew Kressin. All rights reserved.
//

import Foundation

class Game {
    // MARK: Properties
    
    var deck: Deck
    var numPlayers: Int {
        get { players.count }
    }
    
    var players: [Player] = []
    
    var gameover = false
    
    // MARK: Initialization
    init(numSubDecks: Int = 1) {
        deck = Deck(numSubDecks: numSubDecks, shuffle: true)
    }
    
    // MARK: Methods
    func addPlayer(player: Player) {
        
    }
    func addPlayers(players: [Player]) {
        
    }
}

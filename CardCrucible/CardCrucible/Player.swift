//
//  Player.swift
//  CardCrucible
//
//  Created by Matthew Kressin on 7/26/20.
//  Copyright © 2020 Matthew Kressin. All rights reserved.
//

import Foundation

class Player {
    // MARK: Properties
    
    var name: String
    
    var cards: [Card]?
    
    // MARK: Initialization
    init(name: String) {
        self.name = name
    }
}

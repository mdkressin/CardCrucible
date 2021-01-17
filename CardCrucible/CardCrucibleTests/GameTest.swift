//
//  GameTest.swift
//  CardCrucibleTests
//
//  Created by Matthew Kressin on 12/29/20.
//  Copyright © 2020 Matthew Kressin. All rights reserved.
//

import XCTest
@testable import CardCrucible

class GameTest: XCTestCase {
    
    private let deckSize = 52
    private var game1: Game!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        game1 = Game()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGameInit() throws {
        // check that default initialization of Game works as expected
        XCTAssertEqual(game1.gameDeck.deckSize, deckSize)
        XCTAssertEqual(game1.numPlayers, 0)
        
        // Test initialization with two sub-decks
        let game2 = Game(numSubDecks: 2)
        XCTAssertEqual(game2.gameDeck.deckSize, deckSize * 2)
        XCTAssertEqual(game2.numPlayers, 0)
        
        // test initializing a game with a set of players
        let playerNames = ["a", "b", "c", "d"]
        var players = [Player]()
        for name in playerNames {
            players.append(Player(name))
        }
        let game3 = Game(numSubDecks: 1, withPlayers: players)
        XCTAssertEqual(game3.gameDeck.deckSize, deckSize)
        XCTAssertEqual(game3.numPlayers, players.count)
    }
    
    func testAddPlayer() {
        // Check that default game initialization has expected 0 players
        XCTAssertEqual(game1.numPlayers, 0)
        
        var testPlayer = Player("test player 1")
        game1.addPlayer(player: testPlayer)
        XCTAssertEqual(game1.numPlayers, 1)
        XCTAssertEqual(game1.players[testPlayer.id], testPlayer)
        
        testPlayer = Player("test player 2")
        game1.addPlayer(player: testPlayer)
        XCTAssertEqual(game1.numPlayers, 2)
        XCTAssertEqual(game1.players[testPlayer.id], testPlayer)
        
        testPlayer = Player("test player 3")
        game1.addPlayer(player: testPlayer)
        XCTAssertEqual(game1.numPlayers, 3)
        XCTAssertEqual(game1.players[testPlayer.id], testPlayer)
    }
    
    func testAddPlayers() {
        // Check that default game initialization has expected 0 players
        XCTAssertEqual(game1.numPlayers, 0)
        
        // test adding a set of players to the game
        let playerNames = ["a", "b", "c", "d"]
        var players = [Player]()
        for name in playerNames {
            players.append(Player(name))
        }
        game1.addPlayers(players: players)
        XCTAssertEqual(game1.numPlayers, players.count)
        XCTAssertEqual(game1.players[players[0].id], players[0])
        XCTAssertEqual(game1.players[players[1].id], players[1])
        XCTAssertEqual(game1.players[players[2].id], players[2])
        XCTAssertEqual(game1.players[players[3].id], players[3])
    }

    /*
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    */
}

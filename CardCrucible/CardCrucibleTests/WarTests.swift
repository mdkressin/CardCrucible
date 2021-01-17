//
//  WarTests.swift
//  CardCrucibleTests
//
//  Created by Matthew Kressin on 12/30/20.
//  Copyright © 2020 Matthew Kressin. All rights reserved.
//

import XCTest
@testable import CardCrucible

class WarTests: XCTestCase {

    private let deckSize = Deck.defaultDeckSize
    private var game1: War!
    private var player1: TournamentPlayer!
    private var player2: TournamentPlayer!
    private var player3: TournamentPlayer!
    
    private enum situations: String {
        case p1SoleHighCard, p2SoleHighCard, p3SoleHighCard
        case p1p2HighCards, p1p3HighCards, p2p3HighCards
        case p1p2p3HighCards
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        game1 = War()
        player1 = TournamentPlayer("player 1")
        player2 = TournamentPlayer("player 2")
        player3 = TournamentPlayer("player 3")
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testWarInit() throws {
        // test that war has expected deck size and empty player list
        XCTAssertEqual(game1.gameDeck.deckSize, deckSize)
        XCTAssertTrue(game1.players.isEmpty)
        
        // test creating war with deck containing multiple sub-decks
        var testGame = War(numSubDecks: 3)
        XCTAssertEqual(testGame.gameDeck.deckSize, deckSize * 3)
        XCTAssertTrue(testGame.players.isEmpty)
        
        // test creating game with an array of players
        let playerNames = ["a", "b", "c", "d"]
        var players = [Player]()
        for name in playerNames {
            players.append(Player(name))
        }
        testGame = War(numSubDecks: 1, withPlayers: players)
        XCTAssertEqual(testGame.gameDeck.deckSize, deckSize)
        XCTAssertEqual(testGame.numPlayers, players.count)
        // check that players were properly converted to TournamentPlayers
        for (_, player) in testGame.players {
            XCTAssertTrue(player is TournamentPlayer)
        }
        
        // test creating game with an array of players as TournamentPlayers
        players = [Player]()
        for name in playerNames {
            players.append(TournamentPlayer(name))
        }
        testGame = War(numSubDecks: 1, withPlayers: players)
        XCTAssertEqual(testGame.gameDeck.deckSize, deckSize)
        XCTAssertEqual(testGame.numPlayers, players.count)
        // check that players were properly converted to TournamentPlayers
        for (_, player) in testGame.players {
            XCTAssertTrue(player is TournamentPlayer)
        }
        
        // test creating game with an array of TournamentPlayers
        players = [TournamentPlayer]()
        for name in playerNames {
            players.append(TournamentPlayer(name))
        }
        testGame = War(numSubDecks: 1, withPlayers: players)
        XCTAssertEqual(testGame.gameDeck.deckSize, deckSize)
        XCTAssertEqual(testGame.numPlayers, players.count)
        // check that players were properly converted to TournamentPlayers
        for (_, player) in testGame.players {
            XCTAssertTrue(player is TournamentPlayer)
        }
    }
    
    func testAddPlayer() {
        // Check that default game initialization has expected 0 players
        XCTAssertTrue(game1.players.isEmpty)
        
        // test method with TournamentPlayers
        var testPlayer1 = TournamentPlayer("test player 1")
        game1.addPlayer(player: testPlayer1)
        XCTAssertEqual(game1.numPlayers, 1)
        XCTAssertEqual(game1.players[testPlayer1.id], testPlayer1)
        XCTAssertTrue(game1.players[testPlayer1.id] is TournamentPlayer)
        
        testPlayer1 = TournamentPlayer("test player 2")
        game1.addPlayer(player: testPlayer1)
        XCTAssertEqual(game1.numPlayers, 2)
        XCTAssertEqual(game1.players[testPlayer1.id], testPlayer1)
        XCTAssertTrue(game1.players[testPlayer1.id] is TournamentPlayer)
        
        testPlayer1 = TournamentPlayer("test player 3")
        game1.addPlayer(player: testPlayer1)
        XCTAssertEqual(game1.numPlayers, 3)
        XCTAssertEqual(game1.players[testPlayer1.id], testPlayer1)
        XCTAssertTrue(game1.players[testPlayer1.id] is TournamentPlayer)
        
        // test with Players (i.e. that Player is converted to TournamentPlayer)
        var testPlayer2 = Player("test player 4")
        game1.addPlayer(player: testPlayer2)
        XCTAssertEqual(game1.numPlayers, 4)
        XCTAssertEqual(game1.players[testPlayer2.id], testPlayer2)
        XCTAssertTrue(game1.players[testPlayer2.id] is TournamentPlayer)
        
        testPlayer2 = Player("test player 5")
        game1.addPlayer(player: testPlayer2)
        XCTAssertEqual(game1.numPlayers, 5)
        XCTAssertEqual(game1.players[testPlayer2.id], testPlayer2)
        XCTAssertTrue(game1.players[testPlayer2.id] is TournamentPlayer)
        
        testPlayer2 = Player("test player 6")
        game1.addPlayer(player: testPlayer2)
        XCTAssertEqual(game1.numPlayers, 6)
        XCTAssertEqual(game1.players[testPlayer2.id], testPlayer2)
        XCTAssertTrue(game1.players[testPlayer2.id] is TournamentPlayer)
        
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
        // check that players have the expected type
        for (_, player) in game1.players {
            XCTAssertTrue(player is TournamentPlayer)
        }
        
        // test adding a set of players as TournamentPlayers to the game
        players = [Player]()
        for name in playerNames {
            players.append(TournamentPlayer(name + name))
        }
        game1.addPlayers(players: players)
        XCTAssertEqual(game1.numPlayers, players.count * 2)
        XCTAssertEqual(game1.players[players[0].id], players[0])
        XCTAssertEqual(game1.players[players[1].id], players[1])
        XCTAssertEqual(game1.players[players[2].id], players[2])
        XCTAssertEqual(game1.players[players[3].id], players[3])
        // check that players have the expected type
        for (_, player) in game1.players {
            XCTAssertTrue(player is TournamentPlayer)
        }
        
        // test adding a set of TournamentPlayers to the game
        players = [TournamentPlayer]()
        for name in playerNames {
            players.append(TournamentPlayer(name + name + name))
        }
        game1.addPlayers(players: players)
        XCTAssertEqual(game1.numPlayers, players.count * 3)
        XCTAssertEqual(game1.players[players[0].id], players[0])
        XCTAssertEqual(game1.players[players[1].id], players[1])
        XCTAssertEqual(game1.players[players[2].id], players[2])
        XCTAssertEqual(game1.players[players[3].id], players[3])
        // check that players have the expected type
        for (_, player) in game1.players {
            XCTAssertTrue(player is TournamentPlayer)
        }
        
        // test adding a mixture of Players and TournamentPlayers to the game
        players = [Player]()
        var i = 0
        for name in playerNames {
            if i % 2 == 0 {
                players.append(Player(name + name + name + name))
            } else {
                players.append(TournamentPlayer(name + name + name + name))
            }
            i += 1
        }
        game1.addPlayers(players: players)
        XCTAssertEqual(game1.numPlayers, players.count * 4)
        XCTAssertEqual(game1.players[players[0].id], players[0])
        XCTAssertEqual(game1.players[players[1].id], players[1])
        XCTAssertEqual(game1.players[players[2].id], players[2])
        XCTAssertEqual(game1.players[players[3].id], players[3])
        // check that players have the expected type
        for (_, player) in game1.players {
            XCTAssertTrue(player is TournamentPlayer)
        }
    }
    
    func testDealCards() {
        // make sure that no cards are dealt if there are no players in the game
        //game1.dealCards()
        //XCTAssertEqual(game1.gameDeck.deckSize, deckSize)
        
        // add TournamentPlayers to the game
        let playerNames = ["a", "b", "c", "d"]
        var players = [TournamentPlayer]()
        for name in playerNames {
            players.append(TournamentPlayer(name))
        }
        game1.addPlayers(players: players)
        
        // deal the cards
        game1.dealCards()
        // make sure that all the cards in the gameDeck were dealt
        XCTAssertTrue(game1.deckCards.isEmpty)
        for player in game1.players.values {
            // This test only works if the deck size is dividable by the number of players
            XCTAssertEqual(player.numCards, deckSize / game1.numPlayers)
        }
        // since only a single sub-deck was used, check that players have unique cards
        for id in game1.players.keys {
            for o_id in game1.players.keys {
                if id != o_id {
                    for card in game1.players[id]!.cards {
                        if game1.players[o_id]!.cards.contains(card) {
                            XCTFail()
                        }
                    }
                }
            }
        }
    }
    
    func testPlaceCards() {

        // add players to the game and deal them cards
        game1.addPlayers(players: [player1, player2])
        game1.dealCards()
        
        // make copy of players to check that expected changes were made
        let origPlayer1 = player1.copy() as! TournamentPlayer
        let origPlayer2 = player2.copy() as! TournamentPlayer
        XCTAssertTrue(player1 =/ origPlayer1)
        XCTAssertTrue(player2 =/ origPlayer2)
        
        // have players place their cards for the round
        var roundCards: [String: [Card]]
        var cards: [Card]
        (roundCards, cards) = game1.placeCards()
        // make sure that players are no longer the same as their copies
        XCTAssertFalse(player1 =/ origPlayer1)
        XCTAssertFalse(player2 =/ origPlayer2)
        
        // compare the cards in the card array returned to the card array values returned in roundCards
        var compareCards = [Card]()
        for card in roundCards.values {
            // there should only be a single card in the card array
            compareCards.append(card[0])
        }
        // check that there are the same amount of cards in roundCards as in cards
        XCTAssertEqual(cards.count, compareCards.count)
        for card in cards {
            // check that both arrays contain the same cards
            XCTAssertTrue(compareCards.contains(card))
        }
        
        // check that it was the first card that was drawn from the player's cards
        XCTAssertEqual(roundCards[player1.id]![0], origPlayer1.cards[0])
        XCTAssertEqual(roundCards[player2.id]![0], origPlayer2.cards[0])
        
        // check that a player is eliminated if they no longer have cards to play
        XCTAssertTrue(player1.isNotEliminated)
        _ = try! Deck.drawCards(drawAmount: player1.numCards, from: &player1.cards)
        _ = game1.placeCards()
        XCTAssertTrue(player1.isEliminated)
        
        // check that can still place cards from the player that is not eliminated
        XCTAssertTrue(player2.isNotEliminated)
        let numCards = player2.numCards
        _ = game1.placeCards()
        XCTAssertEqual(player2.numCards, numCards - 1)
        
    }
    
    func testDetermineHighCardHolders2Players() {

        // add players to the game and deal them cards
        game1.addPlayers(players: [player1, player2])
        game1.dealCards()
        
        for _ in 0 ..< deckSize/2 {
            // determine which player had the high card in the round
            let p1Card = player1.cards[0]
            let p2Card = player2.cards[0]
            var p1HighCard = true
            var equal = false
            if p1Card < p2Card {
                p1HighCard = false
            } else if p2Card < p1Card {
                p1HighCard = true
            } else {
                // cards were the same
                p1HighCard = false
                equal = true
            }
            
            // have players place their cards
            var roundCards: [String: [Card]]
            (roundCards, _) = game1.placeCards()
            
            // determine which player(s) have the high card for the rouhd
            let highCardHolder = game1.determineHighCardHolders(&roundCards)
            
            // check results
            if equal {
                XCTAssertEqual(highCardHolder.count, 2)
            } else if p1HighCard {
                XCTAssertEqual(highCardHolder[0], player1.id)
            } else {
                XCTAssertEqual(highCardHolder[0], player2.id)
            }
        }
    }
    
    func testDetermineHighCardHolders3Players() {
        // add players to the game and deal them cards
        game1.addPlayers(players: [player1, player2, player3])
        game1.dealCards()
        
        var situation: situations = .p1SoleHighCard
        for _ in 0 ..< Int(deckSize/3) {
            // determine which player had the high card in the round
            let p1Card = player1.cards[0]
            let p2Card = player2.cards[0]
            let p3Card = player3.cards[0]
            
            if p1Card < p2Card && p2Card < p3Card {
                // player3 has high card
                situation = .p3SoleHighCard
            } else if p2Card < p1Card && p1Card < p3Card {
                // player3 has high card
                situation = .p3SoleHighCard
            } else if p1Card.rank == p2Card.rank && p1Card < p3Card {
                // player3 has high card
                situation = .p3SoleHighCard
            } else if p1Card < p3Card && p3Card < p2Card {
                // player2 has high card
                situation = .p2SoleHighCard
            } else if p3Card < p1Card && p1Card < p2Card {
                // player2 has high card
                situation = .p2SoleHighCard
            } else if p1Card.rank == p3Card.rank && p1Card < p2Card {
                // player2 has high card
                situation = .p2SoleHighCard
            } else if p2Card < p3Card && p3Card < p1Card {
                // player1 has high card
                situation = .p1SoleHighCard
            } else if p3Card < p2Card && p2Card < p1Card {
                // player1 has high card
                situation = .p1SoleHighCard
            } else if p2Card.rank == p3Card.rank && p2Card < p1Card {
                // player1 has high card
                situation = .p1SoleHighCard
            } else if p1Card.rank == p2Card.rank && p3Card < p1Card {
                // player1 and player2 both have the high card
                situation = .p1p2HighCards
            } else if p1Card.rank == p3Card.rank && p2Card < p1Card {
                // player1 and player3 both have the high card
                situation = .p1p3HighCards
            } else if p2Card.rank == p3Card.rank && p1Card < p2Card {
                // player2 and player3 both have the high card
                situation = .p2p3HighCards
            } else if p1Card.rank == p2Card.rank && p2Card.rank == p3Card.rank {
                // all three players have cards with equal ranks
                situation = .p1p2p3HighCards
            }
            
            // have players place their cards
            var roundCards: [String: [Card]]
            (roundCards, _) = game1.placeCards()
            
            // determine which player(s) have the high card for the rouhd
            let highCardHolder = game1.determineHighCardHolders(&roundCards)
            
            // check results
            switch situation {
                case .p1SoleHighCard:
                    XCTAssertEqual(highCardHolder[0], player1.id)
                case .p2SoleHighCard:
                    XCTAssertEqual(highCardHolder[0], player2.id)
                case .p3SoleHighCard:
                    XCTAssertEqual(highCardHolder[0], player3.id)
                case .p1p2HighCards:
                    XCTAssertEqual(highCardHolder.count, 2)
                    XCTAssertTrue(highCardHolder.contains(player1.id))
                    XCTAssertTrue(highCardHolder.contains(player2.id))
                case .p1p3HighCards:
                    XCTAssertEqual(highCardHolder.count, 2)
                    XCTAssertTrue(highCardHolder.contains(player1.id))
                    XCTAssertTrue(highCardHolder.contains(player3.id))
                case .p2p3HighCards:
                    XCTAssertEqual(highCardHolder.count, 2)
                    XCTAssertTrue(highCardHolder.contains(player2.id))
                    XCTAssertTrue(highCardHolder.contains(player3.id))
                case .p1p2p3HighCards:
                    XCTAssertEqual(highCardHolder.count, 3)
                    XCTAssertTrue(highCardHolder.contains(player1.id))
                    XCTAssertTrue(highCardHolder.contains(player2.id))
                    XCTAssertTrue(highCardHolder.contains(player3.id))
            }
        }
    }
    
    func testDetermineHighCardHoldersMultipleDecks() {
        let numSubdecks = 5
        
        // create new game with the players and deal the cards
        game1 = War(numSubDecks: numSubdecks, withPlayers: [player1, player2, player3])
        game1.dealCards()
        
        var situation: situations = .p1SoleHighCard
        for _ in 0 ..< Int(numSubdecks*deckSize/3) {
            // determine which player had the high card in the round
            let p1Card = player1.cards[0]
            let p2Card = player2.cards[0]
            let p3Card = player3.cards[0]
            
            if p1Card < p2Card && p2Card < p3Card {
                // player3 has high card
                situation = .p3SoleHighCard
            } else if p2Card < p1Card && p1Card < p3Card {
                // player3 has high card
                situation = .p3SoleHighCard
            } else if p1Card.rank == p2Card.rank && p1Card < p3Card {
                // player3 has high card
                situation = .p3SoleHighCard
            } else if p1Card < p3Card && p3Card < p2Card {
                // player2 has high card
                situation = .p2SoleHighCard
            } else if p3Card < p1Card && p1Card < p2Card {
                // player2 has high card
                situation = .p2SoleHighCard
            } else if p1Card.rank == p3Card.rank && p1Card < p2Card {
                // player2 has high card
                situation = .p2SoleHighCard
            } else if p2Card < p3Card && p3Card < p1Card {
                // player1 has high card
                situation = .p1SoleHighCard
            } else if p3Card < p2Card && p2Card < p1Card {
                // player1 has high card
                situation = .p1SoleHighCard
            } else if p2Card.rank == p3Card.rank && p2Card < p1Card {
                // player1 has high card
                situation = .p1SoleHighCard
            } else if p1Card.rank == p2Card.rank && p3Card < p1Card {
                // player1 and player2 both have the high card
                situation = .p1p2HighCards
            } else if p1Card.rank == p3Card.rank && p2Card < p1Card {
                // player1 and player3 both have the high card
                situation = .p1p3HighCards
            } else if p2Card.rank == p3Card.rank && p1Card < p2Card {
                // player2 and player3 both have the high card
                situation = .p2p3HighCards
            } else if p1Card.rank == p2Card.rank && p2Card.rank == p3Card.rank {
                // all three players have cards with equal ranks
                situation = .p1p2p3HighCards
            }
            
            // have players place their cards
            var roundCards: [String: [Card]]
            (roundCards, _) = game1.placeCards()
            
            // determine which player(s) have the high card for the rouhd
            let highCardHolder = game1.determineHighCardHolders(&roundCards)
            
            // check results
            switch situation {
                case .p1SoleHighCard:
                    XCTAssertEqual(highCardHolder[0], player1.id)
                case .p2SoleHighCard:
                    XCTAssertEqual(highCardHolder[0], player2.id)
                case .p3SoleHighCard:
                    XCTAssertEqual(highCardHolder[0], player3.id)
                case .p1p2HighCards:
                    XCTAssertEqual(highCardHolder.count, 2)
                    XCTAssertTrue(highCardHolder.contains(player1.id))
                    XCTAssertTrue(highCardHolder.contains(player2.id))
                case .p1p3HighCards:
                    XCTAssertEqual(highCardHolder.count, 2)
                    XCTAssertTrue(highCardHolder.contains(player1.id))
                    XCTAssertTrue(highCardHolder.contains(player3.id))
                case .p2p3HighCards:
                    XCTAssertEqual(highCardHolder.count, 2)
                    XCTAssertTrue(highCardHolder.contains(player2.id))
                    XCTAssertTrue(highCardHolder.contains(player3.id))
                case .p1p2p3HighCards:
                    XCTAssertEqual(highCardHolder.count, 3)
                    XCTAssertTrue(highCardHolder.contains(player1.id))
                    XCTAssertTrue(highCardHolder.contains(player2.id))
                    XCTAssertTrue(highCardHolder.contains(player3.id))
            }
        }
    }
    
    func testDetermineHighCardHolderFromDraw() {
        var testHolders = [String: [Card]]()
        
        game1.addPlayers(players: [player1, player2])
        
        // test with cards of rank two
        player1.addToCards(Card(suitValue: .clubs, rankValue: .two))
        player2.addToCards(Card(suitValue: .hearts, rankValue: .two))
        testHolders[player1.id] = player1.cards
        testHolders[player2.id] = player2.cards
        
        var highCardHolders = game1.determineHighCardHolders(&testHolders, true)
        
        XCTAssertTrue(highCardHolders.count == 1)
        XCTAssertEqual(highCardHolders[0], player2.id)
        
        resetPlayers()
        testHolders = [String: [Card]]()
        // test cards that are equal
        player1.addToCards(Card(suitValue: .clubs, rankValue: .two))
        player2.addToCards(Card(suitValue: .clubs, rankValue: .two))
        testHolders[player1.id] = player1.cards
        testHolders[player2.id] = player2.cards
        
        highCardHolders = game1.determineHighCardHolders(&testHolders, true)
        XCTAssertTrue(highCardHolders.count == 2)
        
        resetPlayers()
        testHolders = [String: [Card]]()
        // test with 3 players
        game1.addPlayer(player: player3)
        player1.addToCards(Card(suitValue: .clubs, rankValue: .two))
        player2.addToCards(Card(suitValue: .hearts, rankValue: .two))
        player3.addToCards(Card(suitValue: .diamonds, rankValue: .two))
        testHolders[player1.id] = player1.cards
        testHolders[player2.id] = player2.cards
        testHolders[player3.id] = player3.cards
        
        highCardHolders = game1.determineHighCardHolders(&testHolders, true)
        
        XCTAssertTrue(highCardHolders.count == 1)
        XCTAssertEqual(highCardHolders[0], player2.id)
        
        resetPlayers()
        testHolders = [String: [Card]]()
        // test 2 of 3 players have equal cards but there is a winner
        player1.addToCards(Card(suitValue: .clubs, rankValue: .two))
        player2.addToCards(Card(suitValue: .clubs, rankValue: .two))
        player3.addToCards(Card(suitValue: .diamonds, rankValue: .two))
        testHolders[player1.id] = player1.cards
        testHolders[player2.id] = player2.cards
        testHolders[player3.id] = player3.cards
        
        highCardHolders = game1.determineHighCardHolders(&testHolders, true)
        XCTAssertTrue(highCardHolders.count == 1)
        XCTAssertEqual(highCardHolders[0], player3.id)
        
        resetPlayers()
        testHolders = [String: [Card]]()
        // test 2 of 3 players have equal cards and there is no winner
        player1.addToCards(Card(suitValue: .clubs, rankValue: .two))
        player2.addToCards(Card(suitValue: .diamonds, rankValue: .two))
        player3.addToCards(Card(suitValue: .diamonds, rankValue: .two))
        testHolders[player1.id] = player1.cards
        testHolders[player2.id] = player2.cards
        testHolders[player3.id] = player3.cards
        
        highCardHolders = game1.determineHighCardHolders(&testHolders, true)
        XCTAssertTrue(highCardHolders.count == 2)
        XCTAssertTrue(highCardHolders.contains(player2.id))
        XCTAssertTrue(highCardHolders.contains(player3.id))
        XCTAssertFalse(highCardHolders.contains(player1.id))
        
    }
    
    func testWarBasic() {
        game1.addPlayers(players: [player1, player2])
        // add 2 cards to players cards (the second card is the only card evaluated)
        // give player1 winning cards
        let cards1 = [Card(suitValue: .clubs, rankValue: .ten), Card(suitValue: .clubs, rankValue: .ace)]
        let cards2 = [Card(suitValue: .clubs, rankValue: .seven), Card(suitValue: .clubs, rankValue: .king)]
        player1.addToCards(cards1)
        player2.addToCards(cards2)
        
        var highCardHolders = [player1.id, player2.id]
        var cards = [Card]()
        do {
            try game1.war(highCardHolders, &cards)
        } catch GameEvent.draw {
            XCTFail("Somehow the game ended up as a draw")
        } catch {
            XCTFail("unknown tiebreaking error")
        }
        
        XCTAssertEqual(player1.cards.count, cards1.count + cards2.count)
        
        // reset players
        resetPlayers()
        
        // switch which player has winning cards
        player1.addToCards(cards2)
        player2.addToCards(cards1)
        
        highCardHolders = [player1.id, player2.id]
        cards = [Card]()
        do {
            try game1.war(highCardHolders, &cards)
        } catch GameEvent.draw {
            XCTFail("Somehow the game ended up as a draw")
        } catch {
            XCTFail("unknown tiebreaking error")
        }
        
        XCTAssertEqual(player2.cards.count, cards1.count + cards2.count)
    }
    
    func testMultipleWars() {
        var numCards = 0
        
        game1.addPlayers(players: [player1, player2])
        
        // add cards that will result in a second war
        player1.addToCards([Card(suitValue: .clubs, rankValue: .two), Card(suitValue: .clubs, rankValue: .three)])
        player2.addToCards([Card(suitValue: .diamonds, rankValue: .two), Card(suitValue: .diamonds, rankValue: .three)])
        // add cards that will result in player1 winning
        player1.addToCards([Card(suitValue: .clubs, rankValue: .king), Card(suitValue: .clubs, rankValue: .ace)])
        player2.addToCards([Card(suitValue: .diamonds, rankValue: .jack), Card(suitValue: .diamonds, rankValue: .queen)])
        
        numCards = player1.numCards + player2.numCards
        
        let highCardHolders = [player1.id, player2.id]
        var cards = [Card]()
        do {
            try game1.war(highCardHolders, &cards)
        } catch GameEvent.draw {
            XCTFail("Somehow the game ended up as a draw")
        } catch {
            XCTFail("unknown tiebreaking error")
        }
        
        XCTAssertEqual(player1.numCards, numCards)
        XCTAssertTrue(player1.isNotEliminated)
        XCTAssertTrue(player2.cards.isEmpty)
        XCTAssertTrue(player2.isNotEliminated)
        
        
        // reset players and card count
        resetPlayers()
        numCards = 0
        
        // add cards that will result in a second war
        player1.addToCards([Card(suitValue: .clubs, rankValue: .two), Card(suitValue: .clubs, rankValue: .three)])
        player2.addToCards([Card(suitValue: .diamonds, rankValue: .two), Card(suitValue: .diamonds, rankValue: .three)])
        // test situation where player1 has enough cards for war but player2 does not have any
        player1.addToCards([Card(suitValue: .clubs, rankValue: .king), Card(suitValue: .clubs, rankValue: .ace)])
        
        numCards = player1.numCards + player2.numCards
        
        cards = [Card]()
        do {
            try game1.war(highCardHolders, &cards)
        } catch GameEvent.draw {
            XCTFail("Somehow the game ended up as a draw")
        } catch {
            XCTFail("unknown tiebreaking error")
        }
        
        XCTAssertEqual(player1.numCards, numCards)
        XCTAssertTrue(player1.isNotEliminated)
        XCTAssertTrue(player2.cards.isEmpty)
        XCTAssertTrue(player2.isEliminated)
        
        // reset players and card count
        resetPlayers()
        numCards = 0
        
        // add cards that will result in a second war
        player1.addToCards([Card(suitValue: .clubs, rankValue: .two), Card(suitValue: .clubs, rankValue: .three)])
        player2.addToCards([Card(suitValue: .diamonds, rankValue: .two), Card(suitValue: .diamonds, rankValue: .three)])
        // test situation where player1 has enough cards for war but player2 only has one
        player1.addToCards([Card(suitValue: .clubs, rankValue: .king), Card(suitValue: .clubs, rankValue: .ace)])
        player2.addToCards(Card(suitValue: .diamonds, rankValue: .ace))
        
        numCards = player1.numCards + player2.numCards
        
        cards = [Card]()
        do {
            try game1.war(highCardHolders, &cards)
        } catch GameEvent.draw {
            XCTFail("Somehow the game ended up as a draw")
        } catch {
            XCTFail("unknown tiebreaking error")
        }
        
        XCTAssertEqual(player1.numCards, numCards)
        XCTAssertTrue(player1.isNotEliminated)
        XCTAssertTrue(player2.cards.isEmpty)
        XCTAssertTrue(player2.isEliminated)
        
    }
    
    func testWarDraw() {
        game1.addPlayers(players: [player1, player2])
        
        let highCardHolders = [player1.id, player2.id]
        var cards = [Card]()
        // test both players in tiebreaker having no cards remaining
        do {
            try game1.war(highCardHolders, &cards)
            XCTFail("tiebreaker should throw a draw error")
        } catch GameEvent.draw {
            XCTAssertTrue(player1.isEliminated)
            XCTAssertTrue(player2.isEliminated)
            XCTAssertTrue(player1.cards.isEmpty)
            XCTAssertTrue(player2.cards.isEmpty)
        } catch {
            XCTFail("unknown tiebreaking error")
        }
        
        // reset players status
        resetPlayers()
        
        // test both players have a single card of equivalent rank
        player1.addToCards(Card(suitValue: .clubs, rankValue: .two))
        player2.addToCards(Card(suitValue: .diamonds, rankValue: .two))
        do {
            try game1.war(highCardHolders, &cards)
            XCTFail("tiebreaker should throw a draw error")
        } catch GameEvent.draw {
            XCTAssertTrue(player1.isEliminated)
            XCTAssertTrue(player2.isEliminated)
            XCTAssertTrue(player1.cards.isEmpty)
            XCTAssertTrue(player2.cards.isEmpty)
        } catch {
            XCTFail("unknown tiebreaking error")
        }
        
        // reset players
        resetPlayers()
        
        // add cards that will result in a second war that ends in a draw
        player1.addToCards([Card(suitValue: .clubs, rankValue: .eight), Card(suitValue: .clubs, rankValue: .three)])
        player2.addToCards([Card(suitValue: .diamonds, rankValue: .six), Card(suitValue: .diamonds, rankValue: .three)])
        cards = [Card]()
        do {
            try game1.war(highCardHolders, &cards)
            XCTFail("tiebreaker should throw a draw error")
        } catch GameEvent.draw {
            XCTAssertTrue(player1.isEliminated)
            XCTAssertTrue(player2.isEliminated)
            XCTAssertTrue(player1.cards.isEmpty)
            XCTAssertTrue(player2.cards.isEmpty)
        } catch {
            XCTFail("unknown tiebreaking error")
        }
        
        // reset players
        resetPlayers()
        
        // test war on default deck with two players (shuold end in a draw)
        game1.gameDeck.createDeck(numSubDecks: 1)
        game1.dealCards()
        cards = [Card]()
        do {
            try game1.war(highCardHolders, &cards)
            XCTFail("tiebreaker should throw a draw error")
        } catch GameEvent.draw {
            XCTAssertTrue(player1.isEliminated)
            XCTAssertTrue(player2.isEliminated)
            XCTAssertTrue(player1.cards.isEmpty)
            XCTAssertTrue(player2.cards.isEmpty)
        } catch {
            XCTFail("unknown tiebreaking error")
        }
        
    }
    /*
    func testWar() {
        game1.addPlayers(players: [player1, player2, player3])
        game1.startGame()
    }
 */
    fileprivate func resetPlayers() {
        player1.isNotEliminated = true
        player1.cards.removeAll()
        player2.isNotEliminated = true
        player2.cards.removeAll()
        player3.isNotEliminated = true
        player3.cards.removeAll()
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

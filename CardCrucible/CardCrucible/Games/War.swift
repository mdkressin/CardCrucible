//
//  War.swift
//  CardCrucible
//
//  Created by Matthew Kressin on 12/19/20.
//  Copyright © 2020 Matthew Kressin. All rights reserved.
//

import Foundation

/**
 Split the deck equally between all players and then be the first player to collect all the cards in the deck
 
 - Note: See [War Rules](https://bicyclecards.com/how-to-play/war/) for more information on how to play the game
 */
class War: Game {
    
    // MARK: Properties
    /// The number of cards a player must have in order to participate in war
    static let cardsNeededForWar = 2
    /// The id of the player who won the round
    var roundWinner: String?
    
    // MARK: Initialization
    
    /**
     Initializes a new game with a deck containing the specified amount of subdecks
     
     - Parameter numSubDecks: The amount of sup-decks that the game deck will contain
     */
    required init(numSubDecks: Int = 1) {
        super.init(numSubDecks: numSubDecks)
    }
    
    /**
     Initializes a new game with a deck containing the specified amount of subdecks and with the given players
     
     - Parameters:
         - numSubDecks: The number of sub-decks that the main deck should contain
         - withPlayers: The players that will participate in the game
     */
    convenience init(numSubDecks: Int = 1, withPlayers: [TournamentPlayer]) {
        self.init(numSubDecks: numSubDecks)
        self.addPlayers(players: withPlayers)
    }
    
    /**
     Initializes a new game with a deck containing the specified amount of subdecks and with the given players
     
     This initializer converts the given array of players into a new array of TournamentPlayers with matching names, ids, and cards.
     
     - Parameters:
         - numSubDecks: The number of sub-decks that the main deck should contain
         - withPlayers: The players that will participate in the game
     */
    convenience init(numSubDecks: Int = 1, withPlayers: [Player]) {
        let newPlayers = TournamentPlayer.toTournamentPlayers(withPlayers)
        self.init(numSubDecks: numSubDecks, withPlayers: newPlayers)
    }
    
    // MARK: Methods
    
    /**
     Adds the given player to the game as a TournamentPlayer
     
     - Note: The new TournamentPlayer contains a matching name, id, and cards
     
     - Parameter player: The player to add to the game
     */
    override func addPlayer(player: Player) {
        if let aPlayer = player as? TournamentPlayer {
            players[player.id] = aPlayer
        } else {
            players[player.id] = TournamentPlayer(player)
        }
    }
    /**
     Adds a list of players to the game as TournamentPlayers
     
     - Note: Uses the method `warObj.addPlayer()` to convert the players from Players into TournamentPlayers
     
     - Parameter players: The list of players to add to the game
     */
    override func addPlayers(players: [Player]) {
        for player in players {
            self.addPlayer(player: player)
        }
    }
    /**
     Continuously deals cards to all players in the game until the main deck is empty, then returns
     
     - Precondition: There is at least one player in the game
     */
    override func dealCards() {
        // Ensure that their are players in the game before dealing cards
        precondition(!players.isEmpty, "There are no players in the game to deal cards to")
        
        while true {
            // Cycle through players, dealing each a card unless there are no more cards in the deck
            for id in players.keys.sorted() {
                do {
                    if let player = players[id] as? TournamentPlayer {
                        if player.isNotEliminated {
                            try player.addToCards(gameDeck.drawCard())
                        }
                    }
                } catch DeckError.drawFromEmptyDeck {
                    return
                } catch {
                    fatalError("Unknown error dealing cards")
                }
            }
        }
    }
    
    /**
     Start a game of War between 2 or more players!
     
     - Precondition: There are at least 2 players in the game
     */
    override func startGame() {
        precondition(numPlayers > 1, "There are not enough players to start a game")
        dealCards()
        while !gameover {
            startRound()
            if let winner = roundWinner {
                print("round winner: \(players[winner]!.name)")
            }
        }
        
        // declare the winner of the game if there is one
        if let winnerId = roundWinner {
            print("The game is over. The winner is \(players[winnerId]!.name)")
        } else {
            print("The game is over but there is no winner")
        }
    }
    
    /**
     Draws the top card from the cards that each player participating in the game still possesses. If there are no more cards, it then draws from the discard pile associated with the player. If the discard pile is also empty, then it eliminates the player from the game.
     
     - Precondition: The players participating in the game are of type `TournamentPlayer`
     
     - Returns: A dictionary with keys of player ids and values of the card that player used this round as well as the list of all the cards played during the round.
     */
    internal func placeCards() -> ([String: [Card]], [Card]) {
        var roundCards  = [String: [Card]]()
        var cards = [Card]()
        
        for aPlayer in players.values.sorted() {
            
            if let player = aPlayer as? TournamentPlayer {
                // check to see if player is still in the game
                if player.isNotEliminated {
                    do {
                        // draw player's card
                        let card = try Deck.drawCard(from: &player.cards)
                        roundCards[player.id] = [card]
                        cards.append(card)
                        // update the last card that the player played
                        player.lastPlayedCard = card
                    } catch DeckError.drawFromEmptyDeck {
                        // player is out of cards, remove player from game
                        player.isEliminated = true
                    } catch {
                        fatalError("player \(player.id): unknown error in round of War")
                    }
                }
            } else {
                preconditionFailure("player should be a TournamentPlayer but is not")
            }
        }
        return (roundCards, cards)
    }
    
    /**
     Determines the player(s) that possessed the highest ranking card in the round
     
     This function first determines the highest card rank amongst the current round's cards using `Deck.determineHighestRank()`. It then examines the cards from all the players and collects the ids of the players that played cards with matching ranks of the determined highest card rank during the round.
     
     There is a special case where this function can also be used to determine which players placed the cards that had the highest suit in the event of a draw and one final attempt is being made to determine a round winner.
     
     - Parameters:
        - roundCards: A dictionary with keys corresponding to player ids and values corresponding to the card that the player placed in the round
        - determineFromDraw: Signifies whether this method is determining the high card holders between players who ended up in a draw
     
     - Returns: The ids of the players who played the highest ranked card in the round
     
     */
    internal func determineHighCardHolders(_ roundCards: inout [String : [Card]], _ determineFromDraw: Bool = false) -> [String] {
        // Hold the ids of players
        var highCardHolders = [String]()
        
        // check to see if determining the high card holders of a draw game event
        if determineFromDraw {
            // collect the ids of players who placed a card whose suit was not less than the suit of any other cards placed during the round
            for (id, cards) in roundCards {
                // flag to signify that this player's card's suit is not less than the suit of any other player's card
                var isHighCardHolder = true
                // compare against other players' cards
                for (o_id, o_cards) in roundCards {
                    if id != o_id {
                        if let player = players[id] as? TournamentPlayer {
                            if player.isNotEliminated {
                                if cards[0].suit < o_cards[0].suit {
                                    isHighCardHolder = false
                                }
                            }
                        }
                    }
                }
                if isHighCardHolder {
                    highCardHolders.append(id)
                }
            }
            
            return highCardHolders
        }
        
        
        // collect the cards to be used when determining the highCardHolders
        var cards = [Card]()
        for (id, rCards) in roundCards {
            if let player = players[id] as? TournamentPlayer {
                if player.isNotEliminated {
                    cards.append(rCards[rCards.count-1])
                }
            }
            
        }
        // Find the highest ranked card among the eligible cards
        let highestRank = Deck.determineHighestRank(in: cards)
        
        // Collect the player ids of players who used cards matching the highest card rank
        for (id, cards) in roundCards {
            if let player = players[id] as? TournamentPlayer {
                if player.isNotEliminated && cards[cards.count-1].rank == highestRank {
                    highCardHolders.append(id)
                }
            }
        }
        
        return highCardHolders
    }
    
    /**
     Players must war to determine a round winner, with the winner receiving all of the cards used during the duration of the war..
     
     There are two kinds of situations that can occur when two or more players go to war.
        1. _One or more players possess enough cards to participate in a complete round of war._ In this situation, if any of the other players do not have enough cards left to participate in a complete war, then they are eliminated from the game and their cards are added to the array of `prizeCards` to be given to the eventual winner of the war. The remaining players place down the necessary amount of cards needed to war, with the final card that each player placed used to determine the outcome of the war. If a player's final placed card is the sole card with the highest rank, then that player wins the war and all cards in `prizeCards` are added to that player's cards. Otherwise, all players in the war who placed final cards of the highest, equivalent rank participate in another war.
        2. _None of the players have enough cards to participate in a complete round of war._ In this situation, the players participating in the war use of all of their remaining to war. Any players that have less cards remaining than other players are eliminated from the game and have all of their cards added to `prizeCards`. The players who have not been eliminated then compare the final cards that they place. If there is a sole final card that has the highest rank in the war, then the player who placed the card wins the war and all cards in `prizeCards` are added to their cards. Otherwise, the war ends in a draw
     
     - Throws: `GameEvent.draw` if there are no more cards that the players are able to put into play but there is no round winner
     
     - Precondition: All players are of type `TournamentPlayer`
     
     - Parameters:
        - highCardHolders: The ids of the players who possessed cards of equivalent ranks and that were also the highest ranked cards in the round
        - prizeCards: The cards used during the entire round that will be given to the final winner of the round
     */
    internal func war(_ highCardHolders: [String], _ prizeCards: inout [Card]) throws {
        print("at war")
        
        var warParticipants = [String: [Card]]()
        var noSuccessfulDraws = true // true if unable to draw anymore cards from players in highCardHolders, false otherwise
        var enoughCards = false // flag to signify that at least one player in highCardHolders has 2 or more cards
        for id in highCardHolders {
            if let player = players[id] as? TournamentPlayer {
                if player.numCards >= War.cardsNeededForWar {
                    noSuccessfulDraws = gotoWar(highCardHolders, &prizeCards, &warParticipants)
                    enoughCards = true
                    break
                }
            } else {
                preconditionFailure("round winning player does not exist as a TournamentPlayer in War game")
            }
        }
        
        if !enoughCards {
            noSuccessfulDraws = limitedWar(highCardHolders, &prizeCards, &warParticipants)
        }
        
        if noSuccessfulDraws {
            roundWinner = nil
            throw GameEvent.draw(players: highCardHolders)
        }
        
        let newHighCardHolders = determineHighCardHolders(&warParticipants)
        
        // determine the winner of the round
        if newHighCardHolders.count == 1 {
            // only one player played a card whose rank was greater than the ranks of all other cards in the round
            if let player = players[newHighCardHolders[0]] as? TournamentPlayer {
                player.addToCards(prizeCards)
                roundWinner = player.id
                // player would have been automatically removed if they participated in a limited war so add them back to the game since they won the war
                if !enoughCards {
                    player.isNotEliminated = true
                }
            } else {
                preconditionFailure("round winning player does not exist as a TournamentPlayer in War game")
            }
        } else {
            // draw, two or more players played cards with equivalent ranks but whose ranks were greater than the ranks of all other tiebreaker cards
            // participate in another tie-breaker
            try war(newHighCardHolders, &prizeCards)
        }
    }
    
    /**
     Players that are at war do not possess enough cards to participate in a complete war so a limited version of a complete war is performed. This method draws all of the remaining cards that the players participating in the war possess
     
     - Parameters:
        - highCardHolders: The ids of the players who possessed cards of equivalent ranks and that were also the highest ranked cards in the round
        - prizeCards: The cards used during the entire round that will be given to the final winner of the round
        - participants: The ids of the players participating in the war and the cards that they used in the war
     
     - Returns: True if method was able to draw at least one card from one of the war participants, false otherwise
     */
    fileprivate func limitedWar(_ highCardHolders: [String], _ prizeCards: inout [Card], _ participants: inout [String: [Card]]) -> Bool {

        
        var noSuccessfulDraws = true
        for id in highCardHolders {
            if let player = players[id] as? TournamentPlayer {
                if player.isNotEliminated {
                    do {
                        var drawnCard: Card?
                        
                        // check if key-value already exists for key "id"
                        if var cards = participants[id] {
                            // try to add to the value associated with the key
                            drawnCard = try Deck.drawCard(from: &player.cards)
                            cards.append(drawnCard!)
                            participants[id] = cards
                        } else {
                            // try to add a new key-value pair to the dictionary
                            drawnCard = try Deck.drawCard(from: &player.cards)
                            participants[id] = [drawnCard!]
                        }
                        // update the last played card for the player
                        player.lastPlayedCard = drawnCard
                        // at least one card was successfully drawn
                        noSuccessfulDraws = false
                    } catch DeckError.drawFromEmptyDeck {
                        // player has insufficient cards remaining, remove player from the game
                        player.isEliminated = true
                    } catch {
                        fatalError("unexpected error in War tiebreaker with players having insufficient cards remaining to complete a full tiebreaker")
                    }
                    // add the cards drawn from the player to the current collection of prize cards for the round winner
                    if participants[id] != nil && !participants[id]!.isEmpty {
                        prizeCards += participants[id]!
                    }
                }
            }
        }
        return noSuccessfulDraws
    }
    
    /**
     Tries to draw the amount of cards needed to war from all of the participants of the war.
     
     - Parameters:
        - highCardHolders: The ids of the players who possessed cards of equivalent ranks and that were also the highest ranked cards in the round
        - prizeCards: The cards used during the entire round that will be given to the final winner of the round
        - participants: The ids of the players participating in the war and the cards that they used in the war
     
     - Returns: True if method was able to draw at least one card from one of the war participants, false otherwise
     */
    fileprivate func gotoWar(_ highCardHolders: [String], _ prizeCards: inout [Card], _ participants: inout [String: [Card]]) -> Bool {
        var noSuccessfulDraws = true
        for id in highCardHolders {
            if let player = players[id] as? TournamentPlayer {
                do {
                    // draw cards to use in the tiebreaker from the player's remaining cards
                    let cards = try Deck.drawCards(drawAmount: War.cardsNeededForWar, from: &player.cards)
                    participants[id] = cards
                    // update the last card played by the player
                    player.lastPlayedCard = cards[cards.count-1]
                    // At least one card was successfully drawn
                    noSuccessfulDraws = false
                } catch DeckError.insufficientCardsRemaining(let cardsDrawn, _) {
                    // player has insufficient cards remaining, remove player from the game and give their remaining cards to the winner of the round
                    player.isEliminated = true
                    participants[id] = cardsDrawn
                    // if the player had at least one card remaining, then update the last played card for the player to that card
                    if !cardsDrawn.isEmpty {
                        player.lastPlayedCard = cardsDrawn[cardsDrawn.count-1]
                    }
                } catch {
                    fatalError("unexpected error in War tiebreaker")
                }
                // add the cards drawn from the player to the current collection of prize cards for the round winner
                if participants[id] != nil && !participants[id]!.isEmpty {
                    prizeCards += participants[id]!
                }
            }
        }
        return noSuccessfulDraws
    }
    
    /**
     Checks to see if the game is over and updates the `gameover` property
     */
    func updateGameStatus() {
        var numPlayersNotEliminated = 0
        for aPlayer in players.values {
            if let player = aPlayer as? TournamentPlayer {
                if player.isNotEliminated {
                    numPlayersNotEliminated += 1
                }
            }
            if numPlayersNotEliminated > 1 {
                return
            }
        }
        if numPlayersNotEliminated == 1 || numPlayersNotEliminated == numPlayers {
            gameover = true
        }
    }
    
    /**
     Has all players place a card during the round and then determines the high card holders of the round and whether there is a round winner or that two or more players need to participate in a war.
     */
    func startRound() {
        
        var roundCards  = [String: [Card]]()
        var cards = [Card]()
        
        (roundCards, cards) = placeCards()
        var msg = ""
        for (id, cards) in roundCards {
            let name = players[id]!.name
            let card = cards[0].name
            msg += "\(name) played \(card). "
        }
        print(msg)
        
        var highCardHolders = determineHighCardHolders(&roundCards)
        
        // determine the winner of the round
        if highCardHolders.count == 1 {
            // only one player played a card whose rank was greater than the ranks of all other cards in the round
            if let player = players[highCardHolders[0]] as? TournamentPlayer {
                player.addToCards(cards)
                roundWinner = player.id
            } else {
                preconditionFailure("round winning player does not exist as a TournamentPlayer in War game")
            }
        } else {
            // two or more players played cards with equivalent ranks but whose ranks were greater than the ranks of all other cards in the round
            //participate in war
            do {
                try war(highCardHolders, &cards)
            } catch GameEvent.draw(let playerIds) {
                // special tie-breaker
                // war has ended without a clear round winner so use the last card that each player who participated in the last iteration of the war placed to try and determine a winner (have to use card suits since cards will be of equivilent ranks in the event of a draw
                
                var lastPlayedCards = [String: [Card]]()
                for id in playerIds {
                    if let player = players[id] as? TournamentPlayer {
                        if let card = player.lastPlayedCard {
                            lastPlayedCards[id] = [card]
                        }
                    } else {
                        preconditionFailure("player does not exist as a TournamentPlayer in War game")
                    }
                }
                highCardHolders = determineHighCardHolders(&lastPlayedCards, true)
                
                // determine the winner after the draw
                if highCardHolders.count == 1 {
                    // only one player played a card whose suit was greater than the suits of all other cards that ended up in a draw
                    if let player = players[highCardHolders[0]] as? TournamentPlayer {
                        // players who ended up in a draw would have been eliminated from the game since they were unable to place any more cards, but this player won the special tie-breaker so they get to remain in the game
                        player.isNotEliminated = true
                        player.addToCards(cards)
                        roundWinner = player.id
                    } else {
                        preconditionFailure("round winning player does not exist as a TournamentPlayer in War game")
                    }
                } else {
                    // still unable to determine a winner. eliminate players who ended in draw and distribute the cards used during the round to all players who have not been eliminated from the game
                    gameDeck.deckCards = cards
                    dealCards()
                }
            } catch {
                fatalError("unknown tiebreaking error")
            }
        }
        
        updateGameStatus()
    }
}

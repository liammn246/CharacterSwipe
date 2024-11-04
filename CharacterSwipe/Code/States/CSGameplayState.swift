//
//  CSGameplayState.swift
//  CharacterSwipe
//
//  Created by Liam Nagel on 10/29/24.
//

import GameplayKit
import SpriteKit


class CSGameplayState: CSGameState {

    
    override func didEnter(from previousState: GKState?) {

    }
        class gameBoard {
            var gameBoard = [[0, 0, 0, 0],
                             [0, 0, 0, 0],
                             [0, 0, 0, 0],
                             [0, 0, 0, 0]]
            init(gameBoard: [[Int]] = [[0, 0, 0, 0],
                                       [0, 0, 0, 0],
                                       [0, 0, 0, 0],
                                       [0, 0, 0, 0]]) {
                self.gameBoard = gameBoard
                self.gameBoard[Int.random(in: 0..<4)][Int.random(in: 0..<4)] = [2, 4].randomElement()!
                while(true) {
                    let randomRow = Int.random(in: 0..<4)
                    let randomColumn = Int.random(in: 0..<4)
                    
                    if gameBoard[randomRow][randomColumn] == 0 {
                        self.gameBoard[randomRow][randomColumn] = [2, 4].randomElement()!
                        break
                    }
                }
            }
            //TODO: TEST THIS CODE ONCE THE PROJECT WILL RUN; MARK BLOCKS TO AVOID DOUBLE MERGES WITH A SECOND ARRAY
            func swipe(direction: String) {
                var mergeBoard = [[true, true, true, true],
                                  [true, true, true, true],
                                  [true, true, true, true],
                                  [true, true, true, true]]
                while(true) {
                    let randomRow = Int.random(in: 0..<4)
                    let randomColumn = Int.random(in: 0..<4)
                    
                    if gameBoard[randomRow][randomColumn] == 0 {
                        self.gameBoard[randomRow][randomColumn] = [2, 4].randomElement()!
                        break
                    }
                    if direction == "right" {
                        //shift right
                        for i in 0..<4 {
                            for r in 0..<4 {
                                for c in stride(from: 3,to: 0,by: -1) {
                                    if gameBoard[r][c] == 0 {
                                        gameBoard[r][c] = gameBoard[r][c-1]
                                        gameBoard[r][c-1] = 0
                                    }
                                }
                            }
                        }
                        
                        //merge right
                        for r in 0..<4 {
                            for c in stride(from: 3, to: 0, by: -1) {
                                if gameBoard[r][c] == gameBoard[r][c-1] && mergeBoard[r][c] && mergeBoard[r][c-1] {
                                    gameBoard[r][c] *= 2
                                    gameBoard[r][c-1] = 0
                                    mergeBoard[r][c] = false
                                    for c in stride(from: 3, to: 0, by: -1) {
                                        if gameBoard[r][c] == 0 {
                                            gameBoard[r][c] = gameBoard[r][c-1]
                                            gameBoard[r][c-1] = 0
                                        }
                                    }
                                }
                            }
                        }
                        
                    }
                    else if direction == "left" {
                        //shift left
                        for i in 0..<4 {
                            for r in 0..<4 {
                                for c in 0..<4 {
                                    if gameBoard[r][c] == 0 {
                                        gameBoard[r][c] = gameBoard[r][c+1]
                                        gameBoard[r][c+1] = 0
                                    }
                                }
                            }
                        }
                        //merge left
                        for i in 0..<4 {
                            for r in 0..<4 {
                                for c in 0..<4 {
                                    if gameBoard[r][c] == gameBoard[r][c+1] && mergeBoard[r][c] && mergeBoard[r][c+1] {
                                        gameBoard[r][c] *= 2
                                        gameBoard[r][c+1] = 0
                                        mergeBoard[r][c] = false
                                        for c in stride(from: 3, to: 0, by: -1) {
                                            if gameBoard[r][c] == 0 {
                                                gameBoard[r][c] = gameBoard[r][c+1]
                                                gameBoard[r][c+1] = 0
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else if direction == "up" {
                        //shift up
                        for i in 0..<4 {
                            for c in 0..<4 {
                                for r in 0..<4 {
                                    if gameBoard[r][c] == 0 {
                                        gameBoard[r][c] = gameBoard[r+1][c]
                                        gameBoard[r+1][c] = 0
                                    }
                                }
                            }
                        }
                        //merge up
                        for c in 0..<4 {
                            for r in 0..<4 {
                                if gameBoard[r][c] == gameBoard[r+1][c] && mergeBoard[r][c] && mergeBoard[r+1][c] {
                                    gameBoard[r][c] *= 2
                                    gameBoard[r+1][c] = 0
                                    mergeBoard[r][c] = false
                                    for r in 0..<4 {
                                        if gameBoard[r][c] == 0 {
                                            gameBoard[r][c] = gameBoard[r+1][c]
                                            gameBoard[r+1][c] = 0
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else if direction == "down" {
                        //shift down
                        for i in 0..<4 {
                            for c in 0..<4 {
                                for r in 3...0 {
                                    if gameBoard[r][c] == 0 {
                                        gameBoard[r][c] = gameBoard[r-1][c]
                                        gameBoard[r-1][c] = 0
                                    }
                                }
                            }
                        }
                        
                        //merge down
                        for c in 0..<4 {
                            for r in 3...0  {
                                if gameBoard[r][c] == gameBoard[r-1][c] && mergeBoard[r][c] && mergeBoard[r-1][c] {
                                    gameBoard[r][c] *= 2
                                    gameBoard[r-1][c] = 0
                                    mergeBoard[r][c] = false
                                    for r in 3...0 {
                                        if gameBoard[r][c] == 0 {
                                            gameBoard[r][c] = gameBoard[r-1][c]
                                            gameBoard[r-1][c] = 0
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

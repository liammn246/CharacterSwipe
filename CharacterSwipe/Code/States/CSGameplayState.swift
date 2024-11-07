//
//  CSGameplayState.swift
//  CharacterSwipe
//
//  Created by Liam Nagel on 10/29/24.
//

//Tap mechanics go here
//Code that changes depending on state

import GameplayKit
import SpriteKit


class CSGameplayState: CSGameState {
    
    override func didEnter(from previousState: GKState?) {
        
    }
    class gameBoard {
        //TODO swipe function
        
        var board = [[0, 0, 0, 0],
                     [0, 0, 0, 0],
                     [0, 0, 0, 0],
                     [0, 0, 0, 0]]
        init(board: [[Int]] = [[0, 0, 0, 0],
                                   [0, 0, 0, 0],
                                   [0, 0, 0, 0],
                                   [0, 0, 0, 0]]) {
            self.board = board
            self.board[Int.random(in: 0..<4)][Int.random(in: 0..<4)] = [2, 4].randomElement()!
            while(true) {
                let randomRow = Int.random(in: 0..<4)
                let randomColumn = Int.random(in: 0..<4)
                
                if board[randomRow][randomColumn] == 0 {
                    self.board[randomRow][randomColumn] = [2, 4].randomElement()!
                    break
                }
            }
        }
        func boardMove(direction: String) -> [[Int]] {
            var gameBoard = self.board
            var mergeBoard = [[true, true, true, true],
                              [true, true, true, true],
                              [true, true, true, true],
                              [true, true, true, true]]
            if direction == "right" {
                //shift right
                for _ in 0..<4 {
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
                for _ in 0..<4 {
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
                for _ in 0..<4 {
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
                for _ in 0..<4 {
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
                for _ in 0..<4 {
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
            return gameBoard
        }
        func swipe(direction: String) {
            var testBoard = boardMove(direction: direction)
            if testBoard != board {
                board = testBoard
                while(true) {
                    let randomRow = Int.random(in: 0..<4)
                    let randomColumn = Int.random(in: 0..<4)
                    
                    if board[randomRow][randomColumn] == 0 {
                        self.board[randomRow][randomColumn] = [2, 4].randomElement()!
                        break
                    }
                    //TODO update main board
                }
                if board == boardMove(direction:"right") && board == boardMove(direction:"left") && board == boardMove(direction:"up") && board == boardMove(direction: "down") {
                    //TODO lose condition
                    
                }
            }
        }
    }
}

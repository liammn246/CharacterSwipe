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
    
    // Game board instance
    var gameBoard: GameBoard
    
    init(gameScene: CSGameScene, gameBoard: GameBoard) {
        self.gameBoard = gameBoard
        super.init(gameScene: gameScene)
    }
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        // Initialize or reset game board here if needed
        print("Gameplay state entered.")
    }
    
    // Handle swipe action
    func swipe(direction: String) {
        let movedBoard = gameBoard.boardMove(direction: direction)
        
        if movedBoard != gameBoard.board {
            gameBoard.board = movedBoard
            
            // Place a random tile after each valid move
            gameBoard.placeRandomTile()
            
            // Check for game over condition after the move
            if gameBoard.isGameOver() {
                stateMachine?.enter(CSLoseState.self)
            }
        }
    }
}

class GameBoard {
    
    var board: [[Int]]
    
    init(board: [[Int]] = [[0, 0, 0, 0],
                           [0, 0, 0, 0],
                           [0, 0, 0, 0],
                           [0, 0, 0, 0]]) {
        self.board = board
        self.placeRandomTile() // Place an initial random tile when the game starts
    }
    
    // Add a random tile to an empty spot
    func placeRandomTile() {
        var emptySpaces: [(Int, Int)] = []
        for row in 0..<4 {
            for col in 0..<4 {
                if board[row][col] == 0 {
                    emptySpaces.append((row, col))
                }
            }
        }
        
        if !emptySpaces.isEmpty {
            let randomSpot = emptySpaces.randomElement()!
            let randomValue = [2, 4].randomElement()!
            board[randomSpot.0][randomSpot.1] = randomValue
        }
    }
    
    // Check if the game is over
    func isGameOver() -> Bool {
        for row in 0..<4 {
            for col in 0..<4 {
                if board[row][col] == 0 {
                    return false
                }
                if col < 3 && board[row][col] == board[row][col + 1] {
                    return false
                }
                if row < 3 && board[row][col] == board[row + 1][col] {
                    return false
                }
            }
        }
        return true
    }
    
    // Move and merge tiles based on direction
    func boardMove(direction: String) -> [[Int]] {
        var newBoard = self.board
        var merged = Array(repeating: Array(repeating: false, count: 4), count: 4)
        
        switch direction {
        case "right":
            for r in 0..<4 {
                var row = newBoard[r].filter { $0 != 0 }
                var i = row.count - 1
                while i > 0 {
                    if row[i] == row[i - 1] && !merged[r][i] && !merged[r][i - 1] {
                        row[i] *= 2
                        row[i - 1] = 0
                        merged[r][i] = true
                    }
                    i -= 1
                }
                row = row.filter { $0 != 0 }
                newBoard[r] = Array(repeating: 0, count: 4 - row.count) + row
            }
        case "left":
            for r in 0..<4 {
                var row = newBoard[r].filter { $0 != 0 }
                var i = 0
                while i < row.count - 1 {
                    if row[i] == row[i + 1] && !merged[r][i] && !merged[r][i + 1] {
                        row[i] *= 2
                        row[i + 1] = 0
                        merged[r][i] = true
                    }
                    i += 1
                }
                row = row.filter { $0 != 0 }
                newBoard[r] = row + Array(repeating: 0, count: 4 - row.count)
            }
        case "up":
            for c in 0..<4 {
                var col = (0..<4).map { newBoard[$0][c] }.filter { $0 != 0 }
                var i = 0
                while i < col.count - 1 {
                    if col[i] == col[i + 1] && !merged[i][c] && !merged[i + 1][c] {
                        col[i] *= 2
                        col[i + 1] = 0
                        merged[i][c] = true
                    }
                    i += 1
                }
                col = col.filter { $0 != 0 }
                for r in 0..<4 {
                    newBoard[r][c] = r < col.count ? col[r] : 0
                }
            }
        case "down":
            for c in 0..<4 {
                var col = (0..<4).map { newBoard[$0][c] }.filter { $0 != 0 }
                var i = col.count - 1
                while i > 0 {
                    if col[i] == col[i - 1] && !merged[i][c] && !merged[i - 1][c] {
                        col[i] *= 2
                        col[i - 1] = 0
                        merged[i][c] = true
                    }
                    i -= 1
                }
                col = col.filter { $0 != 0 }
                for r in 0..<4 {
                    newBoard[r][c] = r < col.count ? col[r] : 0
                }
            }
        default:
            break
        }
        
        return newBoard
    }
}

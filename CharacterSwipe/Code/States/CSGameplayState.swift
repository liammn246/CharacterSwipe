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
                        
                    }
                    else if direction == "left" {

                    }
                    else if direction == "up" {

                    }
                    else if direction == "down" {

                    }
                }
            }
        }
    }

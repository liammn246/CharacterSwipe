//
//  CSGameScreen.swift
//  CharacterSwipe
//
//  Created by Liam Nagel on 10/29/24.
//

import Foundation

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
        self.gameBoard[Int.random(in 0...2)][Int.random(in 0...2)] = [2, 4].randomElement()!
    }
    
}

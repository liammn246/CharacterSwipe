//
//  GameBoard.swift
//  CharacterSwipe
//
//  Created by Liam Nagel on 11/2/24.
//
import SpriteKit

class CSGameBoard: SKSpriteNode {
    let rows = 4
    let columns = 4
    let tileSideLength: CGFloat = 90
    let spacing: CGFloat = 5
    var gameBoardMatrix = [[2, 4, 8, 16],
                           [32, 64, 128, 256],
                           [512, 1024, 2048, 4096],
                           [8192, 0, 0, 0]]
    
    //THIS IS THE FUNCTION THAT RUNS IN THE BEGINNING
    init(size: CGSize) {
        super.init(texture: nil, color: .clear, size: size)
        initializeBoardValues()
        setupGrid()
        updateTiles()
        //TODO: Take in user input here and call set gameBoardMatrix equal to the boardMove function in the given direction

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func boardMove(direction: String) -> [[Int]] {
        var gameBoard = gameBoardMatrix
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
    
    private func setupGrid() {
        // Existing setup code for creating tiles and naming them by "tile_row_col"
        for row in 0..<rows {
            for col in 0..<columns {
                let tileNode = SKSpriteNode(color: .lightGray, size: CGSize(width: tileSideLength, height: tileSideLength))
                tileNode.position = calculateTilePosition(row: row, col: col)
                tileNode.name = "tile_\(row)_\(col)"
                addChild(tileNode)
            }
        }
    }
    private func calculateTilePosition(row: Int, col: Int) -> CGPoint {
        let gridWidth = CGFloat(columns) * (tileSideLength + spacing) - spacing
        let gridHeight = CGFloat(rows) * (tileSideLength + spacing) - spacing
        let xPosition = CGFloat(col) * (tileSideLength + spacing) - gridWidth / 2 + tileSideLength / 2
        let yPosition = CGFloat(3-row) * (tileSideLength + spacing) - gridHeight / 2 + tileSideLength / 2
        return CGPoint(x: xPosition, y: yPosition)
    }
    
    // 2. Place updateTiles() method here
    func updateTiles() {
        for row in 0..<rows {
            for col in 0..<columns {
                let tileName = "tile_\(row)_\(col)"
                if let tileNode = childNode(withName: tileName) as? SKSpriteNode {
                    let value = gameBoardMatrix[row][col]
                    tileNode.removeAllChildren() // Clear existing label
                    
                    if value != 0 {
                        tileNode.texture = getTextureForValue(value)
                    } else {
                        tileNode.color = .lightGray //Default tile
                    }
                }
            }
        }
    }
    
    func initializeBoardValues() {
        self.gameBoardMatrix = [[0, 0, 0, 0],
                                [0, 0, 0, 0],
                                [0, 0, 0, 0],
                                [0, 0, 0, 0]]
        gameBoardMatrix[Int.random(in: 0..<4)][Int.random(in: 0..<4)] = [2, 4].randomElement()!
        while(true) {
            let randomRow = Int.random(in: 0..<4)
            let randomColumn = Int.random(in: 0..<4)
            
            if gameBoardMatrix[randomRow][randomColumn] == 0 {
                gameBoardMatrix[randomRow][randomColumn] = [2, 4].randomElement()!
                break
            }
        }
    }
    
    func updateBoard(matrix: [[Int]]) {
        gameBoardMatrix = matrix
        updateTiles()
    }
        
        private let tileTextures: [Int: String] = [
            2: "tile_1",
            4: "tile_2",
            8: "tile_3",
            16: "tile_4",
            32: "tile_5",
            64: "tile_6",
            128: "tile_7",
            256: "tile_8",
            512: "tile_9",
            1024: "tile_10",
            2048: "tile_11",
            4096: "tile_12",
            8192: "tile_13",
        ]
        
        private func getTextureForValue(_ value: Int) -> SKTexture? {
            // Return the texture for the given value, if it exists
            if let textureName = tileTextures[value] {
                return SKTexture(imageNamed: textureName)
            }
            return nil // Return nil if no texture is available for the value
        }
    }


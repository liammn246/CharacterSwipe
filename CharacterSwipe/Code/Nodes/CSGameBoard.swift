import SpriteKit

class CSGameBoard: SKSpriteNode {
    weak var gameScene: CSGameScene!
    var score_tile: SKSpriteNode!
    var score = 0
    let rows = 4
    let columns = 4
    let tileSideLength: CGFloat = 90
    let spacing: CGFloat = 5
    var gameBoardMatrix = [[2, 4, 8, 16],
                           [32, 64, 128, 256],
                           [512, 1024, 2048, 4096],
                           [8192, 0, 0, 0]]
    
    // Initialize
    init(size: CGSize) {
        super.init(texture: nil, color: .clear, size: size)
        initializeBoardValues()
        setupGrid()
        updateTiles()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // Board Move function (no changes)
    func boardMove(direction: String) -> [[Int]] {
        var gameBoard = gameBoardMatrix
        var mergeBoard = Array(repeating: Array(repeating: true, count: 4), count: 4)

        switch direction {
        case "right":
            for r in 0..<4 {
                // Shift right
                for _ in 0..<3 {
                    for c in stride(from: 3, to: 0, by: -1) {
                        if gameBoard[r][c] == 0 && gameBoard[r][c-1] != 0 {
                            gameBoard[r][c] = gameBoard[r][c-1]
                            gameBoard[r][c-1] = 0
                        }
                    }
                }

                // Merge right
                for c in stride(from: 3, to: 0, by: -1) {
                    if gameBoard[r][c] == gameBoard[r][c-1] && mergeBoard[r][c] && mergeBoard[r][c-1] {
                        gameBoard[r][c] *= 2
                        gameBoard[r][c-1] = 0
                        mergeBoard[r][c] = false
                        score += gameBoard[r][c]

                        // Animate merging tile (only merging tiles get this animation)
                        let tileNode = childNode(withName: "tile_\(r)_\(c)") as! SKSpriteNode
                        let scaleUp = SKAction.scale(to: 1.2, duration: 0.1)
                        let scaleDown = SKAction.scale(to: 1.0, duration: 0.1)
                        let bounce = SKAction.sequence([scaleUp, scaleDown])
                        tileNode.run(SKAction.sequence([bounce]))
                    }
                }

                // Shift again after merging
                for _ in 0..<3 {
                    for c in stride(from: 3, to: 0, by: -1) {
                        if gameBoard[r][c] == 0 {
                            gameBoard[r][c] = gameBoard[r][c-1]
                            gameBoard[r][c-1] = 0
                        }
                    }
                }
            }

        case "left":
            for r in 0..<4 {
                // Shift left
                for _ in 0..<3 {
                    for c in 0..<3 {
                        if gameBoard[r][c] == 0 && gameBoard[r][c+1] != 0 {
                            gameBoard[r][c] = gameBoard[r][c+1]
                            gameBoard[r][c+1] = 0
                        }
                    }
                }

                // Merge left
                for c in 0..<3 {
                    if gameBoard[r][c] == gameBoard[r][c+1] && mergeBoard[r][c] && mergeBoard[r][c+1] {
                        gameBoard[r][c] *= 2
                        gameBoard[r][c+1] = 0
                        mergeBoard[r][c] = false
                        score += gameBoard[r][c]

                        // Animate merging tile (only merging tiles get this animation)
                        let tileNode = childNode(withName: "tile_\(r)_\(c)") as! SKSpriteNode
                        let scaleUp = SKAction.scale(to: 1.2, duration: 0.1)
                        let scaleDown = SKAction.scale(to: 1.0, duration: 0.1)
                        let bounce = SKAction.sequence([scaleUp, scaleDown])
                        tileNode.run(SKAction.sequence([bounce]))
                    }
                }

                // Shift again after merging
                for _ in 0..<3 {
                    for c in 0..<3 {
                        if gameBoard[r][c] == 0 {
                            gameBoard[r][c] = gameBoard[r][c+1]
                            gameBoard[r][c+1] = 0
                        }
                    }
                }
            }

        case "up":
            for c in 0..<4 {
                // Shift up
                for _ in 0..<3 {
                    for r in 0..<3 {
                        if gameBoard[r][c] == 0 && gameBoard[r+1][c] != 0 {
                            gameBoard[r][c] = gameBoard[r+1][c]
                            gameBoard[r+1][c] = 0
                        }
                    }
                }

                // Merge up
                for r in 0..<3 {
                    if gameBoard[r][c] == gameBoard[r+1][c] && mergeBoard[r][c] && mergeBoard[r+1][c] {
                        gameBoard[r][c] *= 2
                        gameBoard[r+1][c] = 0
                        mergeBoard[r][c] = false
                        score += gameBoard[r][c]

                        // Animate merging tile (only merging tiles get this animation)
                        let tileNode = childNode(withName: "tile_\(r)_\(c)") as! SKSpriteNode
                        let scaleUp = SKAction.scale(to: 1.2, duration: 0.1)
                        let scaleDown = SKAction.scale(to: 1.0, duration: 0.1)
                        let bounce = SKAction.sequence([scaleUp, scaleDown])
                        tileNode.run(SKAction.sequence([bounce]))
                    }
                }

                // Shift again after merging
                for _ in 0..<3 {
                    for r in 0..<3 {
                        if gameBoard[r][c] == 0 {
                            gameBoard[r][c] = gameBoard[r+1][c]
                            gameBoard[r+1][c] = 0
                        }
                    }
                }
            }

        case "down":
            for c in 0..<4 {
                // Shift down
                for _ in 0..<3 {
                    for r in stride(from: 3, to: 0, by: -1) {
                        if gameBoard[r][c] == 0 && gameBoard[r-1][c] != 0 {
                            gameBoard[r][c] = gameBoard[r-1][c]
                            gameBoard[r-1][c] = 0
                        }
                    }
                }

                // Merge down
                for r in stride(from: 3, to: 0, by: -1) {
                    if gameBoard[r][c] == gameBoard[r-1][c] && mergeBoard[r][c] && mergeBoard[r-1][c] {
                        gameBoard[r][c] *= 2
                        gameBoard[r-1][c] = 0
                        mergeBoard[r][c] = false
                        score += gameBoard[r][c]

                        // Animate merging tile (only merging tiles get this animation)
                        let tileNode = childNode(withName: "tile_\(r)_\(c)") as! SKSpriteNode
                        let scaleUp = SKAction.scale(to: 1.2, duration: 0.1)
                        let scaleDown = SKAction.scale(to: 1.0, duration: 0.1)
                        let bounce = SKAction.sequence([scaleUp, scaleDown])
                        tileNode.run(SKAction.sequence([bounce]))
                    }
                }

                // Shift again after merging
                for _ in 0..<3 {
                    for r in stride(from: 3, to: 0, by: -1) {
                        if gameBoard[r][c] == 0 {
                            gameBoard[r][c] = gameBoard[r-1][c]
                            gameBoard[r-1][c] = 0
                        }
                    }
                }
            }

        default:
            break
        }

        // Return the updated board state
        return gameBoard
    }



    // Handle swipe input
    func onUserInput(direction: String) {
        let newBoard = boardMove(direction: direction)
        
        if newBoard != gameBoardMatrix {
            gameBoardMatrix = newBoard
            addRandomTile()
            updateTiles()
            
            if let gameplayState = gameScene.context?.stateMachine?.currentState as? CSGameplayState {
                gameplayState.updateScoreLabel(newScore: score)
            }
        }
        
        // Check for game over condition
        if boardMove(direction: "left") == gameBoardMatrix &&
            boardMove(direction: "right") == gameBoardMatrix &&
            boardMove(direction: "up") == gameBoardMatrix &&
            boardMove(direction: "down") == gameBoardMatrix {
            print("Game Over -- attempting to transition to CSLoseState")
            gameScene.context?.stateMachine?.enter(CSLoseState.self)
        }
    }
    
    private func setupGrid() {
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
    
    // Update tiles on the board (with animation)
    func updateTiles() {
        for row in 0..<rows {
            for col in 0..<columns {
                let tileName = "tile_\(row)_\(col)"
                if let tileNode = childNode(withName: tileName) as? SKSpriteNode {
                    let value = gameBoardMatrix[row][col]
                    tileNode.removeAllChildren() // Clear existing label
                    tileNode.texture = getTextureForValue(value)
                    
                    // Animate tile movement (use calculated position)
                    let moveAction = SKAction.move(to: calculateTilePosition(row: row, col: col), duration: 0.1)
                    tileNode.run(moveAction)
                }
            }
        }
    }
    
    // Initialize board values (no changes)
    func initializeBoardValues() {
        score = 0
        self.gameBoardMatrix = [[0, 0, 0, 0],
                                [0, 0, 0, 0],
                                [0, 0, 0, 0],
                                [0, 0, 0, 0]]
        gameBoardMatrix[Int.random(in: 0..<3)][Int.random(in: 0..<3)] = [2, 4].randomElement()!
        while(true) {
            let randomRow = Int.random(in: 0..<3)
            let randomColumn = Int.random(in: 0..<3)
            if gameBoardMatrix[randomRow][randomColumn] == 0 {
                gameBoardMatrix[randomRow][randomColumn] = [2, 4].randomElement()!
                break
            }
        }
    }
    
    // Add a random tile to an empty space (no changes)
    func addRandomTile() {
        while(true) {
            let randomRow = Int.random(in: 0..<4)
            let randomColumn = Int.random(in: 0..<4)
            if gameBoardMatrix[randomRow][randomColumn] == 0 {
                gameBoardMatrix[randomRow][randomColumn] = [2, 2, 2, 2, 2, 2, 2, 2, 2, 4].randomElement()!
                break
            }
        }
    }

    // Return texture based on value (no changes)
    func getTextureForValue(_ value: Int) -> SKTexture? {
        let tileTextures: [Int: String] = [
            0: "tile_0",
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
        if let textureName = tileTextures[value] {
            return SKTexture(imageNamed: textureName)
        }
        return nil
    }
}

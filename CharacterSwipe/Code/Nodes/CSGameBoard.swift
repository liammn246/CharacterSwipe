import SpriteKit
import Foundation

class CSGameBoard: SKSpriteNode {
    weak var gameScene: CSGameScene!
    var score_tile: SKSpriteNode!
    var score = 0
    var powerUpScore = 0
    let rows = 4
    let columns = 4
    let tileSideLength: CGFloat = 70
    let spacing: CGFloat = 5
    var gameBoardMatrix = [[2, 4, 8, 16],
                           [32, 64, 128, 256],
                           [512, 1024, 2048, 4096],
                           [8192, 0, 0, 0]]
    var tileMatrix = [[nil, nil, nil, nil],
                      [nil, nil, nil, nil],
                      [nil, nil, nil, nil],
                      [nil, nil, nil, nil]]
    var updatePowerup = false
    var powerUpNode = SKSpriteNode()
    var powerUpActive = false
    var cancelButton: SKSpriteNode?
    var powerUpType: String?
    var powerUpMultiplier = 250
    var progressBarBackground: SKSpriteNode!
    var progressBar: SKSpriteNode!
    
    // Initialize
    init(size: CGSize) {
        super.init(texture: nil, color: .clear, size: size)
        initializeBoardValues()
        setupGrid()
        updateTiles()
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func boardMove(direction: String) -> [[Int]] {
        var gameBoard = gameBoardMatrix
        var mergedTiles = Array(repeating: Array(repeating: false, count: columns), count: rows)

        func animateTileMove(from: (row: Int, col: Int), to: (row: Int, col: Int)) {
            if let tileNode = tileMatrix[from.row][from.col] as? SKSpriteNode {
                let moveAction = SKAction.move(to: calculateTilePosition(row: to.row, col: to.col), duration: 0.1)
                tileNode.run(moveAction)
                tileMatrix[to.row][to.col] = tileNode
                tileMatrix[from.row][from.col] = nil
            }
        }

        func animateTileMerge(at: (row: Int, col: Int), value: Int) {
            if let tileNode = tileMatrix[at.row][at.col] as? SKSpriteNode {
                let scaleUp = SKAction.scale(to: 1.2, duration: 0.1)
                let scaleDown = SKAction.scale(to: 1.0, duration: 0.1)
                let bounce = SKAction.sequence([scaleUp, scaleDown])
                tileNode.run(bounce)
                tileNode.texture = getTextureForValue(value)
            }
        }

        // Process moves based on the direction
        switch direction {
        case "right":
            for r in 0..<rows {
                var target = columns - 1
                for c in stride(from: columns - 1, through: 0, by: -1) {
                    if gameBoard[r][c] != 0 {
                        // Move tile to the furthest available position
                        if c != target {
                            gameBoard[r][target] = gameBoard[r][c]
                            gameBoard[r][c] = 0
                            animateTileMove(from: (r, c), to: (r, target))
                        }
                        // Check for merge
                        if target < columns - 1, gameBoard[r][target] == gameBoard[r][target + 1], !mergedTiles[r][target + 1] {
                            gameBoard[r][target + 1] *= 2
                            gameBoard[r][target] = 0
                            score += gameBoard[r][target + 1]
                            updatePowerUps(scoreChange: gameBoard[r][target + 1])
                            mergedTiles[r][target + 1] = true
                            animateTileMerge(at: (r, target + 1), value: gameBoard[r][target + 1])
                            
                            // Remove the old tile after the merge
                            if let tileNode = tileMatrix[r][target] as? SKSpriteNode {
                                tileNode.removeFromParent()
                                tileMatrix[r][target] = nil
                            }
                        } else {
                            target -= 1
                        }
                    }
                }
            }

        case "left":
            for r in 0..<rows {
                var target = 0
                for c in 0..<columns {
                    if gameBoard[r][c] != 0 {
                        // Move tile to the furthest available position
                        if c != target {
                            gameBoard[r][target] = gameBoard[r][c]
                            gameBoard[r][c] = 0
                            animateTileMove(from: (r, c), to: (r, target))
                        }
                        // Check for merge
                        if target > 0, gameBoard[r][target] == gameBoard[r][target - 1], !mergedTiles[r][target - 1] {
                            gameBoard[r][target - 1] *= 2
                            gameBoard[r][target] = 0
                            score += gameBoard[r][target - 1]
                            updatePowerUps(scoreChange: gameBoard[r][target - 1])
                            mergedTiles[r][target - 1] = true
                            animateTileMerge(at: (r, target - 1), value: gameBoard[r][target - 1])
                            
                            // Remove the old tile after the merge
                            if let tileNode = tileMatrix[r][target] as? SKSpriteNode {
                                tileNode.removeFromParent()
                                tileMatrix[r][target] = nil
                            }
                        } else {
                            target += 1
                        }
                    }
                }
            }

        case "up":
            for c in 0..<columns {
                var target = 0
                for r in 0..<rows {
                    if gameBoard[r][c] != 0 {
                        // Move tile to the furthest available position
                        if r != target {
                            gameBoard[target][c] = gameBoard[r][c]
                            gameBoard[r][c] = 0
                            animateTileMove(from: (r, c), to: (target, c))
                        }
                        // Check for merge
                        if target > 0, gameBoard[target][c] == gameBoard[target - 1][c], !mergedTiles[target - 1][c] {
                            gameBoard[target - 1][c] *= 2
                            gameBoard[target][c] = 0
                            score += gameBoard[target - 1][c]
                            updatePowerUps(scoreChange: gameBoard[target - 1][c])
                            mergedTiles[target - 1][c] = true
                            animateTileMerge(at: (target - 1, c), value: gameBoard[target - 1][c])
                            
                            // Remove the old tile after the merge
                            if let tileNode = tileMatrix[target][c] as? SKSpriteNode {
                                tileNode.removeFromParent()
                                tileMatrix[target][c] = nil
                            }
                        } else {
                            target += 1
                        }
                    }
                }
            }

        case "down":
            for c in 0..<columns {
                var target = rows - 1
                for r in stride(from: rows - 1, through: 0, by: -1) {
                    if gameBoard[r][c] != 0 {
                        // Move tile to the furthest available position
                        if r != target {
                            gameBoard[target][c] = gameBoard[r][c]
                            gameBoard[r][c] = 0
                            animateTileMove(from: (r, c), to: (target, c))
                        }
                        // Check for merge
                        if target < rows - 1, gameBoard[target][c] == gameBoard[target + 1][c], !mergedTiles[target + 1][c] {
                            gameBoard[target + 1][c] *= 2
                            gameBoard[target][c] = 0
                            score += gameBoard[target + 1][c]
                            updatePowerUps(scoreChange: gameBoard[target + 1][c])
                            mergedTiles[target + 1][c] = true
                            animateTileMerge(at: (target + 1, c), value: gameBoard[target + 1][c])
                            
                            // Remove the old tile after the merge
                            if let tileNode = tileMatrix[target][c] as? SKSpriteNode {
                                tileNode.removeFromParent()
                                tileMatrix[target][c] = nil
                            }
                        } else {
                            target -= 1
                        }
                    }
                }
            }

        default:
            break
        }

        return gameBoard
    }
    
    // Handle swipe input
    func onUserInput(direction: String) {
        // Perform the actual move
        let newBoard = boardMove(direction: direction)
        if newBoard != gameBoardMatrix {
            gameBoardMatrix = newBoard
            addRandomTile()
            updateTiles()
            
            gameScene.updateScoreLabel(newScore: score)
        }

        // Check for game over
        if !canMakeMove() {
            print("Game Over -- attempting to transition to CSLoseState")
            gameScene.context?.stateMachine?.enter(CSLoseState.self)
        }
    }

    // Helper to check if any moves are possible
    private func canMakeMove() -> Bool {
        let originalBoard = gameBoardMatrix // Save current state

        // Test moves in all directions without modifying the actual game state
        for direction in ["left", "right", "up", "down"] {
            if boardMoveSimulated(direction: direction, board: originalBoard) != originalBoard {
                return true // A move is possible
            }
        }

        return false // No valid moves
    }

    // Simulate a move without modifying the actual game state
    private func boardMoveSimulated(direction: String, board: [[Int]]) -> [[Int]] {
        var simulatedBoard = board
        var mergedTiles = Array(repeating: Array(repeating: false, count: columns), count: rows)

        switch direction {
        case "right":
            for r in 0..<rows {
                for c in stride(from: columns - 1, through: 0, by: -1) {
                    if simulatedBoard[r][c] == 0 {
                        for k in stride(from: c - 1, through: 0, by: -1) {
                            if simulatedBoard[r][k] != 0 {
                                simulatedBoard[r][c] = simulatedBoard[r][k]
                                simulatedBoard[r][k] = 0
                                break
                            }
                        }
                    }
                    if c > 0, simulatedBoard[r][c] == simulatedBoard[r][c - 1], !mergedTiles[r][c] {
                        simulatedBoard[r][c] *= 2
                        simulatedBoard[r][c - 1] = 0
                        mergedTiles[r][c] = true
                    }
                }
            }
        case "left":
            for r in 0..<rows {
                for c in 0..<columns {
                    if simulatedBoard[r][c] == 0 {
                        for k in (c + 1)..<columns {
                            if simulatedBoard[r][k] != 0 {
                                simulatedBoard[r][c] = simulatedBoard[r][k]
                                simulatedBoard[r][k] = 0
                                break
                            }
                        }
                    }
                    if c < columns - 1, simulatedBoard[r][c] == simulatedBoard[r][c + 1], !mergedTiles[r][c] {
                        simulatedBoard[r][c] *= 2
                        simulatedBoard[r][c + 1] = 0
                        mergedTiles[r][c] = true
                    }
                }
            }
        case "up":
            for c in 0..<columns {
                for r in 0..<rows {
                    if simulatedBoard[r][c] == 0 {
                        for k in (r + 1)..<rows {
                            if simulatedBoard[k][c] != 0 {
                                simulatedBoard[r][c] = simulatedBoard[k][c]
                                simulatedBoard[k][c] = 0
                                break
                            }
                        }
                    }
                    if r < rows - 1, simulatedBoard[r][c] == simulatedBoard[r + 1][c], !mergedTiles[r][c] {
                        simulatedBoard[r][c] *= 2
                        simulatedBoard[r + 1][c] = 0
                        mergedTiles[r][c] = true
                    }
                }
            }
        case "down":
            for c in 0..<columns {
                for r in stride(from: rows - 1, through: 0, by: -1) {
                    if simulatedBoard[r][c] == 0 {
                        for k in stride(from: r - 1, through: 0, by: -1) {
                            if simulatedBoard[k][c] != 0 {
                                simulatedBoard[r][c] = simulatedBoard[k][c]
                                simulatedBoard[k][c] = 0
                                break
                            }
                        }
                    }
                    if r > 0, simulatedBoard[r][c] == simulatedBoard[r - 1][c], !mergedTiles[r][c] {
                        simulatedBoard[r][c] *= 2
                        simulatedBoard[r - 1][c] = 0
                        mergedTiles[r][c] = true
                    }
                }
            }
        default:
            break
        }

        return simulatedBoard
    }

    
    private func setupGrid() {
        for row in 0..<rows {
            for col in 0..<columns {
                if tileMatrix[row][col] is SKSpriteNode {
                    (tileMatrix[row][col] as! SKSpriteNode).position = calculateTilePosition(row: row, col: col)
                    (tileMatrix[row][col] as! SKSpriteNode).size = CGSize(width: tileSideLength, height: tileSideLength)
                    addChild(tileMatrix[row][col] as! SKSpriteNode)
                }
            }
        }
    }
    
    private func calculateTilePosition(row: Int, col: Int) -> CGPoint {
        let gridWidth = CGFloat(columns) * (tileSideLength + spacing) - spacing
        let gridHeight = CGFloat(rows) * (tileSideLength + spacing) - spacing
        let xPosition = CGFloat(col) * (tileSideLength + spacing) - gridWidth / 2 + tileSideLength / 2
        let yPosition = (CGFloat(3-row) * (tileSideLength + spacing) - gridHeight / 2 + tileSideLength / 2)-100
 
        return CGPoint(x: xPosition, y: yPosition)
    }
    
    // Update tiles on the board (with animation)
    func updateTiles() {
        for row in 0..<rows {
            for col in 0..<columns {
                let tileName = "tile_\(row)_\(col)"
                if let tileNode = childNode(withName: tileName) as? SKSpriteNode {
                    let value = gameBoardMatrix[row][col]
                    
                    // Set texture or skip for empty tiles
                    tileNode.texture = getTextureForValue(value)
                    
                    // Skip movement for empty tiles
                    if value == 0 { continue }
                    
                    // Animate only if position changes
                    let targetPosition = calculateTilePosition(row: row, col: col)
                    if tileNode.position != targetPosition {
                        let moveAction = SKAction.move(to: targetPosition, duration: 0.1)
                        tileNode.run(moveAction)
                    }
                }
            }
        }
    }
    
    // Initialize board values (no changes)
    func initializeBoardValues() {
        score = 0
        powerUpScore = 0
        powerUpMultiplier = 250
        print("Powerup multiplier is 250")
        setupProgressBar()
        updateProgressBar()
        self.gameBoardMatrix = [[0, 0, 0, 0],
                                [0, 0, 0, 0],
                                [0, 0, 0, 0],
                                [0, 0, 0, 0]]
        let randomRow = Int.random(in: 0..<3)
        let randomColumn = Int.random(in: 0..<3)
        gameBoardMatrix[randomRow][randomColumn] = [2, 4].randomElement()!
        tileMatrix[randomRow][randomColumn] = SKSpriteNode(texture: getTextureForValue(gameBoardMatrix[randomRow][randomColumn]))
        while(true) {
            let randomRow = Int.random(in: 0..<3)
            let randomColumn = Int.random(in: 0..<3)
            if gameBoardMatrix[randomRow][randomColumn] == 0 {
                gameBoardMatrix[randomRow][randomColumn] = [2, 4].randomElement()!
                tileMatrix[randomRow][randomColumn] = SKSpriteNode(texture: getTextureForValue(gameBoardMatrix[randomRow][randomColumn]))
                break
            }
        }
    }
    
    // Add a random tile to an empty space (no changes)
    func addRandomTile() {
        while true {
            let randomRow = Int.random(in: 0..<4)
            let randomColumn = Int.random(in: 0..<4)
            if gameBoardMatrix[randomRow][randomColumn] == 0 {
                // Assign a random value to the tile (e.g., 2 or 4)
                gameBoardMatrix[randomRow][randomColumn] = [2, 2, 2, 2, 2, 2, 2, 2, 2, 4].randomElement()!
                
                // Create the new tile node
                let newTileNode = SKSpriteNode(texture: getTextureForValue(gameBoardMatrix[randomRow][randomColumn]))
                newTileNode.position = calculateTilePosition(row: randomRow, col: randomColumn)
                newTileNode.size = CGSize(width: tileSideLength, height: tileSideLength)
                tileMatrix[randomRow][randomColumn] = newTileNode
                addChild(newTileNode)
                
                // Add bounce animation to the new tile
                let scaleUp = SKAction.scale(to: 1.2, duration: 0.1)
                let scaleDown = SKAction.scale(to: 1.0, duration: 0.1)
                let bounce = SKAction.sequence([scaleUp, scaleDown])
                newTileNode.run(bounce)
                
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
    
    func removeTile(atRow row: Int, column col: Int) {
        gameBoardMatrix[row][col] = 0
        updateTiles()
    }
    
    func upgradeTile(atRow row: Int, column col: Int) {
        gameBoardMatrix[row][col] *= 2
        updateTiles()
    }
    func updatePowerUps(scoreChange: Int) {
        if powerUpScore < powerUpMultiplier && powerUpScore + scoreChange >= powerUpMultiplier {
            let mynum = Int.random(in: 0...2)
            progressBarBackground.isHidden = true
            
            if mynum == -1 {
                print("x powerup")
                powerUpNode = SKSpriteNode(imageNamed: "delete_powerup")
                powerUpType = "XPowerup"
            }
            else if mynum > 0 {
                print("2x powerup")
                powerUpNode = SKSpriteNode(imageNamed: "2xPowerup")
                powerUpType = "2xPowerup"
            }
            else if maxValue() >= 8 {
                powerUpNode = SKSpriteNode(imageNamed: "tile_"+String(log2(Double(maxValue()))-2))
                powerUpType = "TileAddPowerup"
                updatePowerup = true
            }
            else {
                updatePowerUps(scoreChange: scoreChange)
            }
            powerUpNode.size = CGSize(width: size.width / 3.5, height: size.width / 4)
            powerUpNode.position = CGPoint(x: size.width / 3.5, y: size.height / 1.57)
            powerUpNode.zPosition = 11
            addChild(powerUpNode)
            powerUpScore += scoreChange
        }
        else {
            powerUpScore += scoreChange
            updateProgressBar()
        }
        if updatePowerup {
            powerUpNode.removeFromParent()
            print("powerup updated")
            powerUpNode = SKSpriteNode(imageNamed: "tile_"+String(log2(Double(maxValue()))-2))
            powerUpNode.position = CGPoint(x: size.width / 3.5, y: size.height / 1.57)
            powerUpNode.size = CGSize(width: size.width / 5, height: size.width / 5)
            powerUpNode.zPosition = CGFloat(score)
            addChild(powerUpNode)
        }
    }
    
    func maxValue() -> Int {
        var maxValue = 0
        for r in 0..<4 {
            for c in 0..<4 {
                if gameBoardMatrix[r][c] > maxValue {
                    maxValue = gameBoardMatrix[r][c]
                }
            }
        }
        return maxValue
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        handleTouch(at: location)
    }
    
    func activatePowerUp() {
        powerUpActive = true
        
        // Call specific power-up function based on the type
        if powerUpType == "XPowerup" {
            handleXPowerUp()
        } else if powerUpType == "2xPowerup" {
            handle2xPowerUp()
        } else {
            handleTileAddPowerUp()
        }
        
        powerUpNode.removeFromParent()
        // Add cancel button
        addCancelButton()
    }
    // Add cancel button to the board
    func addCancelButton() {
        cancelButton = SKSpriteNode(color: .red, size: CGSize(width: size.width / 5, height: size.width / 5))
        cancelButton?.position = CGPoint(x: size.width / 3.5, y: size.height / 1.57) // Adjust position as needed
        cancelButton?.zPosition = 10000
        cancelButton?.name = "CancelButton"
        addChild(cancelButton!)
    }

    // Deactivate power-up and remove cancel button
    func deactivatePowerUp() {
        powerUpScore = 0
        powerUpMultiplier *= 2
        powerUpActive = false
        powerUpType = ""
        cancelButton?.removeFromParent()
        cancelButton = nil
        powerUpNode.removeFromParent() // Remove power-up node after use
        updateProgressBar()
        powerUpNode.removeFromParent()
        progressBarBackground.isHidden = false
    }

    // Specific power-up handlers (empty for now)
    func handleXPowerUp() {
        print("X Power-Up activated!")
        // Logic for X power-up
    }

    func handle2xPowerUp() {
        print("2x Power-Up activated!")
        // Logic for 2x power-up
    }

    func handleTileAddPowerUp() {
        print("Tile Add Power-Up activated!")
        // Logic for upgrading a tile
    }
}
extension CSGameBoard {
    func handleTouch(at location: CGPoint) {
        // Check if the touch hit the power-up node
        if powerUpNode.contains(location) && powerUpNode.parent != nil {
            activatePowerUp()
            return
        }
        
        // Check if the touch hit the cancel button
        if let cancelButton = cancelButton, cancelButton.contains(location) {
            print("Cancelled powerup")
            powerUpActive = false
            cancelButton.removeFromParent()
            addChild(powerUpNode)
        }
        
        if powerUpType == "XPowerup" && powerUpActive == true {
            // Identify which tile was tapped
            for row in 0..<rows {
                for col in 0..<columns {
                    let tileName = "tile_\(row)_\(col)"
                    if let tileNode = childNode(withName: tileName) as? SKSpriteNode, tileNode.contains(location) {
                        let value = gameBoardMatrix[row][col]
                        
                        // Check if the tapped tile is not the highest value
                        if value != maxValue() && value > 0 {
                            print("Removing tile at (\(row), \(col)) with value \(value)")
                            removeTile(atRow: row, column: col)
                            powerUpType = ""
                            powerUpActive = false
                            deactivatePowerUp() // Remove power-up UI
                            return
                        } else {
                            print("Cannot remove the highest-value tile!")
                        }
                    }
                }
            }
        }
        if powerUpType == "2xPowerup" && powerUpActive {
            // Identify which tile was tapped
            for row in 0..<rows {
                for col in 0..<columns {
                    let tileName = "tile_\(row)_\(col)"
                    if let tileNode = childNode(withName: tileName) as? SKSpriteNode, tileNode.contains(location) {
                        let value = gameBoardMatrix[row][col]
                        
                        // Check if the tapped tile is not the highest value
                        if value < (maxValue()/2) && value > 0 {
                            gameBoardMatrix[row][col] *= 2 // Double the tile value
                            (tileMatrix[row][col] as! SKSpriteNode).texture = getTextureForValue(gameBoardMatrix[row][col])
                            print("Doubled tile at (\(row), \(col)) to \(gameBoardMatrix[row][col])")
                            deactivatePowerUp() // Deactivate the power-up
                            return
                        } else {
                            print("Cannot double the highest-value tile!")
                        }
                    }
                }
            }
        }
        
        if powerUpType == "TileAddPowerup" && powerUpActive {
            for row in 0..<rows {
                for col in 0..<columns {
                    // Only allow placement on empty spaces
                    if gameBoardMatrix[row][col] == 0 {
                        let tilePosition = calculateTilePosition(row: row, col: col)
                        
                        // Check if the touch is within the bounds of this empty tile
                        if CGRect(x: tilePosition.x - tileSideLength / 2,
                                  y: tilePosition.y - tileSideLength / 2,
                                  width: tileSideLength,
                                  height: tileSideLength).contains(location) {
                            
                            // Add a tile two levels below the max value
                            let newTileValue = maxValue() / 4
                            gameBoardMatrix[row][col] = newTileValue
                            print("Added tile at (\(row), \(col)) with value \(newTileValue)")
                            tileMatrix[row][col] = SKSpriteNode(texture: getTextureForValue(newTileValue)) // Refresh the board
                            (tileMatrix[row][col] as! SKSpriteNode).position = calculateTilePosition(row: row, col: col)
                            (tileMatrix[row][col] as! SKSpriteNode).size = CGSize(width: tileSideLength, height: tileSideLength)
                            addChild(tileMatrix[row][col] as! SKSpriteNode)
                            
                            // Deactivate the power-up after placing the tile
                            deactivatePowerUp() // Properly remove the power-up UI
                            updatePowerup = false
                            return
                        }
                    }
                }
            }
            print("Invalid location! Tap an empty space to place the new tile.")
        }
    }
    func setupProgressBar() {
        // Create the background asset
        let assetTexture = SKTexture(imageNamed: "powerup_base")
        progressBarBackground = SKSpriteNode(texture: assetTexture, size: CGSize(width: size.width / 5, height: size.width / 5)) // A square size
        progressBarBackground.position = CGPoint(x: size.width / 3.5, y: size.height / 1.57)
        progressBarBackground.zPosition = 10
        addChild(progressBarBackground)
        

        progressBar = SKSpriteNode(color: .black, size: CGSize(width: progressBarBackground.size.width, height: progressBarBackground.size.height)) // Initially covers the background
        progressBar.anchorPoint = CGPoint(x: 0.5, y: 0) // Anchor at bottom-center
        progressBar.position = CGPoint(x: 0, y: -progressBarBackground.size.height / 2) // Start at the bottom
        progressBar.alpha = 0.7 // Slightly opaque to create the revealing effect
        progressBar.zPosition = 11
        progressBarBackground.addChild(progressBar)
    }
    
    func updateProgressBar() {
        let progress = min(CGFloat(powerUpScore) / CGFloat(powerUpMultiplier), 1.0) // Clamp progress to a max of 1.0
        progressBar.size.height = progressBarBackground.size.height * (1.0 - progress) // Shrink from top to bottom
        progressBar.position.y = -progressBarBackground.size.height / 2 // Adjust position to stay anchored
    }
}

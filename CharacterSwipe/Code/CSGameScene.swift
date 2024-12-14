//  CSGameScene.swift
//  CharacterSwipe
//
//  Created by Liam Nagel on 10/24/24.
//
import AVFoundation
import SpriteKit

class CSGameScene: SKScene {
    var scorePop: SKLabelNode!
    
    var rectangleBackground: SKShapeNode!
    var scoreLabel: SKLabelNode!
    var background2: SKShapeNode!
    var background3: SKShapeNode!
    var scoreTile: SKShapeNode!
    weak var context: CSGameContext?
    var gameBoard: CSGameBoard!
    let maxOpacity: CGFloat = 1.0
    let startingOpacity: CGFloat = 0.3
    private var audioPlayer: AVAudioPlayer?
    
    private func playSwipeSound() {
        print("Attempting to play sound")
        guard let url = Bundle.main.url(forResource: "swipeSound", withExtension: "mp3") else {
            print("Swipe sound file not found")
            return
        }
        do {
            // Initialize the audio player
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            
            // Set the volume (0.0 is mute, 1.0 is the maximum)
            audioPlayer?.volume = 0.1
            
            // Play the sound
            audioPlayer?.play()
            print("Playing sound")
        } catch {
            print("Error playing swipe sound: \(error)")
        }
    }


    // SwipeDetector instance
    let swipeDetector = SwipeDetector()
    
    init(context: CSGameContext, size: CGSize) {
        self.context = context
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        // Delegate touch to game board if applicable
        if let gameBoard = gameBoard, !gameBoard.isHidden {
            let locationInBoard = touch.location(in: gameBoard)
            gameBoard.handleTouch(at: locationInBoard)
        }

        // Handle touches in specific states
        if let startState = context?.stateMachine?.currentState as? CSStartState {
            startState.handleTouch(at: location)
        } else if let loseState = context?.stateMachine?.currentState as? CSLoseState {
            loseState.handleTouch(at: location)
        }
    }

    
    func calculateUnlockedIndex(for maxValue: Int) -> Int {
        // Assuming tiles correspond to powers of 2 (e.g., tile_1 = 2, tile_2 = 4, etc.)
        return Int(log2(Double(maxValue)))
    }
    // Function to update tile opacity
    func updateTileOpacity() {
        guard let maxValue = gameBoard?.maxValue() else {
            print("Game board not initialized or has no values")
            return
        }

        // Calculate the highest unlocked index based on maxValue
        let highestUnlockedIndex = calculateUnlockedIndex(for: maxValue)

        // Track the previous highest unlocked index (this can be stored elsewhere if needed)
        let previousHighestUnlockedIndex = context?.previousHighestUnlockedIndex ?? -1

        // Update opacity for tiles
        background3.children.forEach { node in
            if let tile = node as? SKSpriteNode,
               let tileName = tile.name,
               let tileIndexString = tileName.split(separator: "_").last,
               let tileIndex = Int(tileIndexString) {

                // Determine the new opacity for the tile
                let isUnlocked = tileIndex <= highestUnlockedIndex
                let newOpacity: CGFloat = isUnlocked ? maxOpacity : startingOpacity

                // Only animate the newly unlocked tile
                if isUnlocked && tileIndex > previousHighestUnlockedIndex {
                    // Apply pop animation for the newly unlocked tile
                    let opacityAction = SKAction.fadeAlpha(to: newOpacity, duration: 0.2)

                    // Apply the pop animation (scale up and down)
                    let scaleUp = SKAction.scale(to: 1.2, duration: 0.1)
                    let scaleDown = SKAction.scale(to: 1.0, duration: 0.1)
                    let scaleSequence = SKAction.sequence([scaleUp, scaleDown])

                    // Combine the opacity and scale animations
                    let group = SKAction.group([opacityAction, scaleSequence])

                    // Run the animation
                    tile.run(group)
                } else {
                    // Just update opacity without animation for other tiles
                    tile.alpha = newOpacity
                }
            }
        }

        // Update the previous highest unlocked index after the opacity update
        context?.previousHighestUnlockedIndex = highestUnlockedIndex
    }


    override func didMove(to view: SKView) {
        super.didMove(to: view)
        context?.stateMachine?.enter(CSStartState.self)
        
        rectangleBackground = SKShapeNode(rectOf: CGSize(width: 320, height: 320), cornerRadius: 20)
        rectangleBackground.fillColor = SKColor(red: 28/255, green: 28/255, blue: 28/255, alpha: 1)
        rectangleBackground.strokeColor = SKColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1)
        rectangleBackground.lineWidth = 3 // Border thickness
        rectangleBackground.position = CGPoint(x: size.width / 2, y: size.height / 3) // WHEN MOVING THE MATRIX, ONLY USE HERE
        rectangleBackground.zPosition = -4
        rectangleBackground.isHidden = true
        addChild(rectangleBackground)
        
        // Set up the game board
        let boardSize = CGSize(width: 300, height: 300)
        gameBoard = CSGameBoard(size: boardSize)
        gameBoard.position = CGPoint(x: 0, y: size.height / 8.8)
        gameBoard.gameScene = self
        gameBoard.zPosition = 1
        gameBoard.isHidden = true  // Start hidden
        rectangleBackground.addChild(gameBoard)

        
         
         

        background2 = SKShapeNode(rectOf: CGSize(width: 320, height: 80), cornerRadius: 10)
        background2.fillColor = SKColor(red: 28/255, green: 28/255, blue: 28/255, alpha: 1)
        background2.position = CGPoint(x: size.width / 2, y: size.height / 1.5)
        background2.strokeColor = SKColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1) //border
        background2.lineWidth = 3 // Border thickness
        background2.name = "scoreTile"
        background2.isHidden = true
        addChild(background2)

        
        // Adjust scoreTile settings as before
        scoreTile = SKShapeNode(rectOf: CGSize(width: 90, height: 50), cornerRadius: 25) // Adjust
        scoreTile.fillColor = SKColor(red: 63/255, green: 63/255, blue: 63/255, alpha: 1)
        scoreTile.strokeColor = SKColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1) //border
        scoreTile.lineWidth = 3 // Border thickness
        scoreTile.zPosition = 9 // Set zPosition to layer it properly
        scoreTile.isHidden = true
        scoreTile.position = CGPoint(x: -80, y: 0) // Adjust x to move left; keep y at 0 for vertical centering
        background2.addChild(scoreTile)

        // Adjust scoreLabel settings
        scoreLabel = SKLabelNode(text: "0")
        scoreLabel.fontColor = .white
        scoreLabel.zPosition = 10
        scoreLabel.fontSize = 24
        scoreLabel.fontName = "Arial-BoldMT"
        scoreLabel.verticalAlignmentMode = .center // Ensures vertical centering
        scoreLabel.horizontalAlignmentMode = .left // Align text to the left
        scoreLabel.position = CGPoint(x: -30, y: 0) // Move left to align with the left side of the scoreTile
        scoreLabel.isHidden = true
        scoreTile.addChild(scoreLabel) // Add label as a child of the tile


        background3 = SKShapeNode(rectOf: CGSize(width: 250, height: 25), cornerRadius: 10)
        background3.fillColor = SKColor(red: 28/255, green: 28/255, blue: 28/255, alpha: 1)
        background3.position = CGPoint(x: size.width / 2, y: size.height / 1.767)
        background3.strokeColor = SKColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1) //border
        background3.lineWidth = 3 // Border thickness
        background3.name = "scoreTile"
        background3.isHidden = true
        background3.zPosition = 10
        addChild(background3)
        
        // Generate the tile names directly based on asset naming convention
        let numberOfTiles = 13
        let tileWidth: CGFloat = 10 // Tile dimensions (adjust as needed)
        let tileHeight: CGFloat = 10
        let spacing: CGFloat = 8 // Space between tiles

        // Create and add tiles
        for i in 1...numberOfTiles { // Start from 1 to match asset naming
            let tileName = "tile_\(i)" // Match asset names
            let tile = SKSpriteNode(imageNamed: tileName)
            tile.size = CGSize(width: tileWidth, height: tileHeight)
            tile.position = CGPoint(
                x: -CGFloat(numberOfTiles - 1) / 2 * (tileWidth + spacing) + CGFloat(i - 1) * (tileWidth + spacing),
                y: 0
            )
            tile.zPosition = background3.zPosition + 1 // Ensure it's above the background

            // Set initial opacity
            tile.alpha = startingOpacity
            tile.name = tileName // Assign a name to identify the tile
            background3.addChild(tile)
            

        }

        // Example: Unlock tiles up to tile_5 (can be dynamically triggered in the game)


        // Add swipe functionality
        setupSwipeGestures()
        
    }
    
    func getGameBoard() -> CSGameBoard? {
        return gameBoard
    }
    
    // MARK: - Show/Hide Game Board
    func showGameBoard() {
        gameBoard.isHidden = false
        rectangleBackground.isHidden = false
        scoreTile.isHidden = false
        scoreLabel.isHidden = false
        background2.isHidden = false
        background3.isHidden = false
    
    }
    
    func hideGameBoard() {
        gameBoard.isHidden = true
        rectangleBackground.isHidden = true
        scoreTile.isHidden = true
        scoreLabel.isHidden = true
        background2.isHidden = true
        background3.isHidden = true
    }
    
    func updateScoreLabel(newScore: Int) {
        guard let scoreLabel = scoreLabel else { return }

        // Create a floating label to show the old score
        let floatingLabel: SKLabelNode
        if let currentScore = Int(scoreLabel.text ?? "0") {
            floatingLabel = SKLabelNode(text: "+ " + String(newScore - currentScore))
        } else {
            floatingLabel = SKLabelNode(text: "+ " + String(newScore))
        }
        if Int(scoreLabel.text ?? "0") != newScore {
            floatingLabel.fontName = scoreLabel.fontName
            floatingLabel.fontSize = scoreLabel.fontSize + 5
            floatingLabel.fontColor = scoreLabel.fontColor
            floatingLabel.position = scoreLabel.position
            floatingLabel.zPosition = scoreLabel.zPosition
            scoreLabel.parent?.addChild(floatingLabel)

            // Update the score label text
            scoreLabel.text = "\(newScore)"

            // Create the floating, scaling, and fading animations
            let floatUp = SKAction.moveBy(x: 0, y: 20, duration: 0.5)
            let fadeOut = SKAction.fadeOut(withDuration: 0.5)
            let scaleUp = SKAction.scale(to: 1.5, duration: 0.25) // Scale up to 1.5x
            let scaleDown = SKAction.scale(to: 1.0, duration: 0.25) // Scale back to 1x
            let scalingSequence = SKAction.sequence([scaleUp, scaleDown])

            // Combine all animations into a group
            let group = SKAction.group([floatUp, fadeOut, scalingSequence])
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([group, remove])

            // Run the animation
            floatingLabel.run(sequence)
        }
    }

    
    // MARK: - Swipe Detection Setup
    private func setupSwipeGestures() {
        swipeDetector.addSwipeGestures(to: self)
        
        swipeDetector.onSwipeUp = { [weak self] in
            guard let self = self, self.context?.stateMachine?.currentState is CSGameplayState else { return }
            self.gameBoard.onUserInput(direction: "up")
            self.updateTileOpacity()
            self.playSwipeSound() // Play sound on swipe up
        }
        
        swipeDetector.onSwipeDown = { [weak self] in
            guard let self = self, self.context?.stateMachine?.currentState is CSGameplayState else { return }
            self.gameBoard.onUserInput(direction: "down")
            self.updateTileOpacity()
            self.playSwipeSound() // Play sound on swipe down
        }
        
        swipeDetector.onSwipeLeft = { [weak self] in
            guard let self = self, self.context?.stateMachine?.currentState is CSGameplayState else { return }
            self.gameBoard.onUserInput(direction: "left")
            self.updateTileOpacity()
            self.playSwipeSound() // Play sound on swipe left
        }
        
        swipeDetector.onSwipeRight = { [weak self] in
            guard let self = self, self.context?.stateMachine?.currentState is CSGameplayState else { return }
            self.gameBoard.onUserInput(direction: "right")
            self.updateTileOpacity()
            self.playSwipeSound() // Play sound on swipe right
        }
    }

    
    // Handle swipe and pass to the gameplay state
    private func handleSwipe(direction: UISwipeGestureRecognizer.Direction) {
        print("Swiped in direction: \(direction)")
        
        // Pass swipe action to CSGameplayState
        if let gameplayState = context?.stateMachine?.currentState as? CSGameplayState {
            print("Called state machine for swipe")
        }
    }
    
    // MARK: - Refresh Game Board
    func updateTiles() {
        gameBoard.updateTiles() // Ensure CSGameBoard has a method to refresh its tiles
    }
}

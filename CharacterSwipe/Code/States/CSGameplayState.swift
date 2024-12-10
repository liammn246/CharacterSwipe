import GameplayKit
import SpriteKit

class CSGameplayState: CSGameState {
    private var scoreLabel: SKLabelNode? // Step 1: Add a property to hold a reference to the score label
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        
        
        
        print("Entering gameplay state, showing game board")
        gameScene.showGameBoard()
        
        // Create background
        let gameplayBackground = SKSpriteNode(imageNamed: "gameplayBackground")
        gameplayBackground.position = CGPoint(x: gameScene.size.width / 2, y: gameScene.size.height / 2)
        gameplayBackground.size = gameScene.size // Fill the scene
        gameplayBackground.zPosition = -100
        gameplayBackground.name = "gameplayBackground" // Name it for easy removal
        gameScene.addChild(gameplayBackground)
        
        
 
        let rectangleBackground = SKShapeNode(rectOf: CGSize(width: 320, height: 320), cornerRadius: 20) // Adjust
        rectangleBackground.fillColor = SKColor(red: 28/255, green: 28/255, blue: 28/255, alpha: 1)
        rectangleBackground.strokeColor = SKColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1) //border
        rectangleBackground.lineWidth = 5 // Border thickness
        rectangleBackground.position = CGPoint(x: gameScene.size.width / 2, y: gameScene.size.height / 1.81)
        rectangleBackground.zPosition = -1 // Set zPosition to layer it properly
        gameScene.addChild(rectangleBackground)
        
        
        // Create a red background tile for the score label
        let scoreTile = SKSpriteNode(color: .red, size: CGSize(width: 200, height: 50))
        scoreTile.position = CGPoint(x: gameScene.size.width / 2, y: gameScene.size.height / 6)
        scoreTile.name = "scoreTile"
        
        // Create the actual score label
        let scoreLabel = SKLabelNode(text: "SCORE: 0")
        scoreLabel.fontColor = .white
        scoreLabel.fontSize = 24
        scoreLabel.position = CGPoint(x: 0, y: -scoreTile.size.height / 4) // Center label inside the tile
        
        
        scoreTile.addChild(scoreLabel)
        gameScene.addChild(scoreTile)
        
        self.scoreLabel = scoreLabel
        
        print("Displaying Score")
    }
    
    override func willExit(to nextState: GKState) {
        super.willExit(to: nextState)
        
        print("Exiting gameplay state, hiding game board")
        gameScene.hideGameBoard()
        
    }

    func updateScoreLabel(newScore: Int) {
        scoreLabel?.text = "SCORE: \(newScore)"
    }
    
}

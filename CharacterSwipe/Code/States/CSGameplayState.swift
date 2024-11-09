import GameplayKit
import SpriteKit

class CSGameplayState: CSGameState {
    private var scoreLabel: SKLabelNode? // Step 1: Add a property to hold a reference to the score label
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
    
        print("Entering gameplay state, showing game board")
        gameScene.showGameBoard()

        // Create a red background tile for the score label
        let scoreTile = SKSpriteNode(color: .red, size: CGSize(width: 200, height: 50))
        scoreTile.position = CGPoint(x: gameScene.size.width / 2, y: gameScene.size.height / 4)
        scoreTile.name = "scoreTile"
        
        // Create the actual score label
        let scoreLabel = SKLabelNode(text: "SCORE: 0")
        scoreLabel.fontColor = .white
        scoreLabel.fontSize = 24
        scoreLabel.position = CGPoint(x: 0, y: -scoreTile.size.height / 4) // Center label inside the tile
        
        // Add the label to the score tile
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

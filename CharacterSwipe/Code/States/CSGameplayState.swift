import GameplayKit
import SpriteKit

class CSGameplayState: CSGameState {
    private var scoreLabel: SKLabelNode? // Step 1: Add a property to hold a reference to the score label
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        
        
        
        print("Entering gameplay state, showing game board")
        gameScene.showGameBoard()
        updateBackground()
        
        // Create a red background tile for the score label
        let scoreTile = SKSpriteNode(color: .red, size: CGSize(width: 200, height: 50))
        scoreTile.position = CGPoint(x: gameScene.size.width / 2, y: gameScene.size.height / 4)
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
    func updateBackground() {
        
        // Determine the background image based on the max value
        if let maxValue = gameScene.getGameBoard()?.maxValue() {
            let backgroundImageName = backgroundForValue(maxValue)
            let newBackground = SKSpriteNode(imageNamed: backgroundImageName)
            
            newBackground.position = CGPoint(x: gameScene.size.width / 2, y: gameScene.size.height / 2)
            newBackground.size = gameScene.size
            newBackground.zPosition = -1
            gameScene.addChild(newBackground)
            
            
        }
    func backgroundForValue(_ value: Int) -> String {
            switch value {
            case 0...16:
                return "sunny"
            case 32...128:
                return "deep"
            case 256...1024:
                return "hell"
            case 2048...8192:
                return "stars"
            default:
                return "sunny" // For values like 8192+
            }
        }
    }
    func updateScoreLabel(newScore: Int) {
        scoreLabel?.text = "SCORE: \(newScore)"
    }
    
}

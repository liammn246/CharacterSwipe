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
        
        
 
       
    }
    
    override func willExit(to nextState: GKState) {
        super.willExit(to: nextState)
        

        
    }
    
}

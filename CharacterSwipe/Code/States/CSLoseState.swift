import GameplayKit
import SpriteKit

class CSLoseState: CSGameState {
    
    private var overlayNode: SKSpriteNode?
    var gameBoard: CSGameBoard!
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        gameBoard = gameScene.getGameBoard()
        
        // Create a semi-transparent dark overlay
        let overlay = SKSpriteNode(color: UIColor.black.withAlphaComponent(0.7), size: gameScene.size)
        overlay.position = CGPoint(x: gameScene.size.width / 2, y: gameScene.size.height / 2)
        overlay.zPosition = 100
        overlay.isUserInteractionEnabled = false // Ensure overlay does not block touches
        gameScene.addChild(overlay)
        overlayNode = overlay
        
        // Apply blur effect using SKEffectNode
        let blurEffect = SKEffectNode()
        blurEffect.filter = CIFilter(name: "CIGaussianBlur", parameters: ["inputRadius": 10])
        blurEffect.shouldRasterize = true
        
        // Capture a snapshot of the game scene
        if let texture = gameScene.view?.texture(from: gameScene) {
            let snapshot = SKSpriteNode(texture: texture)
            snapshot.size = gameScene.size
            snapshot.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            snapshot.position = CGPoint(x: 0, y: 0) // Center inside blurEffect
            blurEffect.addChild(snapshot)
        }
        
        // Center the blur effect on the overlay
        blurEffect.position = CGPoint(x: 0, y: 0)
        overlay.addChild(blurEffect)
        
        // Add the restart button ABOVE the overlay
        let restartButton = SKSpriteNode(color: .red, size: CGSize(width: 200, height: 50))
        restartButton.position = CGPoint(x: gameScene.size.width / 2, y: gameScene.size.height / 2 - 100)
        restartButton.name = "restartButton"
        restartButton.zPosition = 101 // Ensure it is above the overlay
        
        let restartLabel = SKLabelNode(text: "Restart Game")
        restartLabel.fontColor = .white
        restartLabel.fontSize = 24
        restartLabel.position = CGPoint(x: 0, y: -restartButton.size.height / 4)
        restartButton.addChild(restartLabel)
        
        gameScene.addChild(restartButton) // Add button directly to the scene
        
        print("Lose state entered: Displaying Restart Button with blur")
    }
    
    
    func startGame() {
        print("Restart button tapped, transitioning to gameplay state")
        stateMachine?.enter(CSGameplayState.self)
        overlayNode?.removeFromParent()
        if let restartButton = gameScene.childNode(withName: "restartButton") {
            restartButton.removeFromParent()
        }
    }
    
    func handleTouch(at location: CGPoint) {
        if let restartButton = gameScene.childNode(withName: "restartButton"), restartButton.contains(location) {
            startGame()
            gameBoard.initializeBoardValues()
            gameScene.updateTiles()
        }
    }
}

import GameplayKit
import SpriteKit

class CSLoseState: CSGameState {
    
    private var overlayNode: SKSpriteNode?
    private var rectangleBackgroundEnd: SKShapeNode!
    private var end_rectangle_dec: SKShapeNode!// Make this a property to access it later
    var gameBoard: CSGameBoard!
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        
        create_lose_board()
        
        func create_lose_board() {
            gameBoard = gameScene.getGameBoard()
            
            rectangleBackgroundEnd = SKShapeNode(rectOf: CGSize(width: 350, height: 800), cornerRadius: 20)
            rectangleBackgroundEnd.fillColor = SKColor(red: 28/255, green: 28/255, blue: 28/255, alpha: 1)
            rectangleBackgroundEnd.strokeColor = SKColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1)
            rectangleBackgroundEnd.lineWidth = 3 // Border thickness
            rectangleBackgroundEnd.position = CGPoint(x: gameScene.size.width / 2, y: gameScene.size.height / 2)
            rectangleBackgroundEnd.zPosition = 100 // Ensure it's above other nodes
            gameScene.addChild(rectangleBackgroundEnd)

            end_rectangle_dec = SKShapeNode(rectOf: CGSize(width: 280, height: 400), cornerRadius: 20)
            end_rectangle_dec.fillColor = SKColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1)
            end_rectangle_dec.strokeColor = SKColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1)
            end_rectangle_dec.position = CGPoint(x: 0, y: 30)
            end_rectangle_dec.zPosition = 100 // Ensure it's above other nodes
            rectangleBackgroundEnd.addChild(end_rectangle_dec)

            // Create the restart button
            let restartButton = SKShapeNode(rectOf: CGSize(width: 200, height: 50), cornerRadius: 10) // Rounded corners
            restartButton.fillColor = .red
            restartButton.strokeColor = SKColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1) // Gray outline
            restartButton.lineWidth = 3 // Stroke width
            restartButton.position = CGPoint(x: 0, y: -210) // Centered relative to rectangleBackgroundEnd
            restartButton.name = "restartButton" // Set a name for the button
            restartButton.zPosition = 101
            
            // Create the restart label
            let restartLabel = SKLabelNode(text: "Restart Game")
            restartLabel.fontColor = .white
            restartLabel.fontName = "Arial-BoldMT"
            restartLabel.fontSize = 24
            restartLabel.verticalAlignmentMode = .center // Center text vertically
            restartLabel.horizontalAlignmentMode = .center // Center text horizontally
            restartLabel.position = CGPoint(x: 0, y: 0) // Centered relative to restartButton
            restartButton.addChild(restartLabel)
            
            // Add the restart button to the rectangle
            rectangleBackgroundEnd.addChild(restartButton)
            
            print("Lose state entered: Displaying Restart Button with blur")
        }
    }
    func startGame() {
        print("Restart button tapped, transitioning to gameplay state")
        stateMachine?.enter(CSGameplayState.self)
        overlayNode?.removeFromParent()
        
        // Remove rectangle background when restarting
        rectangleBackgroundEnd.removeFromParent()
    }
    
    func handleTouch(at location: CGPoint) {
        let convertedLocation = rectangleBackgroundEnd.convert(location, from: gameScene)

        if let restartButton = rectangleBackgroundEnd.childNode(withName: "restartButton"),
           restartButton.contains(convertedLocation) {
            print("Restart button tapped")
            gameBoard.initializeBoardValues()
            gameBoard.setupGrid()
            gameScene.updateTiles()
            startGame()
        } else {
            print("Touched outside of restart button")
        }
    }

}

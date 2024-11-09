import SpriteKit
import GameplayKit

class CSGameState: GKState {
    unowned let gameScene: CSGameScene

    init(gameScene: CSGameScene) {
        self.gameScene = gameScene
        super.init()
    }
}

class CSStartState: CSGameState {
    private var startButton: SKSpriteNode?

    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)

        // Check if the start button already exists
        if startButton == nil {
            // Create the start button
            startButton = SKSpriteNode(color: .red, size: CGSize(width: 200, height: 50))
            startButton?.position = CGPoint(x: gameScene.size.width / 2, y: gameScene.size.height / 2 - 100)
            startButton?.name = "startButton"

            // Create a label for the button
            let startLabel = SKLabelNode(text: "Start Game")
            startLabel.fontColor = .white
            startLabel.fontSize = 24
            startLabel.position = CGPoint(x: 0, y: -startButton!.size.height / 4) // Adjust label position

            // Add the label to the button node
            startButton?.addChild(startLabel)

            // Add the button to the scene
            if let startButton = startButton {
                gameScene.addChild(startButton)
            }
        }

        // Make sure the button is visible when entering this state
        startButton?.isHidden = false

        print("Start state entered: Displaying Start Button")
    }

    override func willExit(to nextState: GKState) {
        super.willExit(to: nextState)

        // Hide the start button when transitioning to another state
        startButton?.isHidden = true
    }

    func startGame() {
        print("Start button tapped, transitioning to gameplay state")
        stateMachine?.enter(CSGameplayState.self)
    }

    func handleTouch(at location: CGPoint) {
        if let startButton = startButton, startButton.contains(location) {
            startGame()
        }
    }
}

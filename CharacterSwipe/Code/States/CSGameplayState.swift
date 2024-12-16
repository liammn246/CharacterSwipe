import GameplayKit
import SpriteKit
import AVFoundation // Import AVFoundation for audio playback

class CSGameplayState: CSGameState {
    private var scoreLabel: SKLabelNode? // Step 1: Add a property to hold a reference to the score label
    var gameBoard: CSGameBoard!
    private var backgroundMusicPlayer: AVAudioPlayer? // Property to hold the audio player

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
        
        // Play background music
        playBackgroundMusic()
    }
    
    private func playBackgroundMusic() {
        guard let musicURL = Bundle.main.url(forResource: "Sleepy", withExtension: "m4a") else {
            print("Error: Could not find music file Sleepy.m4a")
            return
        }
        
        do {
            backgroundMusicPlayer = try AVAudioPlayer(contentsOf: musicURL)
            backgroundMusicPlayer?.numberOfLoops = -1 // Loop indefinitely
            backgroundMusicPlayer?.volume = 0.2 // Set a comfortable volume
            backgroundMusicPlayer?.play()
        } catch {
            print("Error: Could not play background music: \(error.localizedDescription)")
        }
    }
    
    override func willExit(to nextState: GKState) {
        super.willExit(to: nextState)
        
        // Stop background music
        backgroundMusicPlayer?.stop()
        backgroundMusicPlayer = nil
    }
}

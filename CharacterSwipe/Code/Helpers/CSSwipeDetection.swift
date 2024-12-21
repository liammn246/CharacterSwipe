//
//  swipeDetection.swift
//  CharacterSwipe
//
//  Created by Adam Neulander on 11/7/24.
//

import SpriteKit

class CSSwipeDetector {
    var onSwipeUp: (() -> Void)?
    var onSwipeDown: (() -> Void)?
    var onSwipeLeft: (() -> Void)?
    var onSwipeRight: (() -> Void)?
    

    func addSwipeGestures(to scene: SKScene) {
        let directions: [UISwipeGestureRecognizer.Direction] = [.up, .down, .left, .right]
        
        for direction in directions {
            let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
            swipeGesture.direction = direction
            scene.view?.addGestureRecognizer(swipeGesture)
        }
    }
    
    @objc private func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case .up: onSwipeUp?()
        case .down: onSwipeDown?()
        case .left: onSwipeLeft?()
        case .right: onSwipeRight?()
        default: break
        }
    }
}

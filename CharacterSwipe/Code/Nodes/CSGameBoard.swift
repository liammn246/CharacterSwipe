//
//  GameBoard.swift
//  CharacterSwipe
//
//  Created by Liam Nagel on 11/2/24.
//
import SpriteKit

class CSGameBoard: SKSpriteNode {
    let rows = 4
    let columns = 4
    let tileSideLength: CGFloat = 70
    let spacing: CGFloat = 10
    
    init(size: CGSize) {
            // Initialize with a clear color and a custom size for the game board
            super.init(texture: nil, color: .clear, size: size)
        setupGrid()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupGrid()
    }
    
    private func setupGrid() {
        // Calculate the overall grid size based on tile size and spacing
        let gridWidth = CGFloat(columns) * (tileSideLength + spacing) - spacing
        let gridHeight = CGFloat(rows) * (tileSideLength + spacing) - spacing
        
        for row in 0..<rows {
            for col in 0..<columns {
                let xPosition = CGFloat(col) * (tileSideLength + spacing) - gridWidth / 2 + tileSideLength / 2
                let yPosition = CGFloat(row) * (tileSideLength + spacing) - gridHeight / 2 + tileSideLength / 2
                
                // Create a tile as a square SKSpriteNode
                let tileNode = SKSpriteNode(color: .lightGray, size: CGSize(width: tileSideLength, height: tileSideLength))
                tileNode.position = CGPoint(x: xPosition, y: yPosition)
                
                // Optionally, add a name or tag to identify each tile (e.g., "tile_0_0")
                tileNode.name = "tile_\(row)_\(col)"
                
                addChild(tileNode)
            }
        }
    }
}

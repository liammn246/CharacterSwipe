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
    let tileSideLength: CGFloat = 90
    let spacing: CGFloat = 5
    var gameBoardMatrix = [[0, 1, 2, 3],
                           [4, 5, 6, 7],
                           [8, 9, 10, 11],
                           [12, 13, 0, 0]]
    
    init(size: CGSize) {
        super.init(texture: nil, color: .clear, size: size)
        setupGrid()
        updateTiles() // Initialize display based on the empty matrix
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupGrid() {
        // Existing setup code for creating tiles and naming them by "tile_row_col"
        for row in 0..<rows {
            for col in 0..<columns {
                let tileNode = SKSpriteNode(color: .lightGray, size: CGSize(width: tileSideLength, height: tileSideLength))
                tileNode.position = calculateTilePosition(row: row, col: col)
                tileNode.name = "tile_\(row)_\(col)"
                addChild(tileNode)
            }
        }
    }
    private func calculateTilePosition(row: Int, col: Int) -> CGPoint {
        let gridWidth = CGFloat(columns) * (tileSideLength + spacing) - spacing
        let gridHeight = CGFloat(rows) * (tileSideLength + spacing) - spacing
        let xPosition = CGFloat(col) * (tileSideLength + spacing) - gridWidth / 2 + tileSideLength / 2
        let yPosition = CGFloat(3-row) * (tileSideLength + spacing) - gridHeight / 2 + tileSideLength / 2
        return CGPoint(x: xPosition, y: yPosition)
    }
    
    // 2. Place updateTiles() method here
    func updateTiles() {
        for row in 0..<rows {
            for col in 0..<columns {
                let tileName = "tile_\(row)_\(col)"
                if let tileNode = childNode(withName: tileName) as? SKSpriteNode {
                    let value = gameBoardMatrix[row][col]
                    tileNode.removeAllChildren() // Clear existing label
                    
                    if value != 0 {
                        tileNode.texture = getTextureForValue(value)
                        } else {
                            tileNode.color = .lightGray //Default tile
                        }
                    }
                }
            }
        }
        
    private let tileTextures: [Int: String] = [
            1: "tile_1",
            2: "tile_2",
            3: "tile_3",
            4: "tile_4",
            5: "tile_5",
            6: "tile_6",
            7: "tile_7",
            8: "tile_8",
            9: "tile_9",
            10: "tile_10",
            11: "tile_11",
            12: "tile_12",
            13: "tile_13",
        ]
    
    private func getTextureForValue(_ value: Int) -> SKTexture? {
            // Return the texture for the given value, if it exists
            if let textureName = tileTextures[value] {
                return SKTexture(imageNamed: textureName)
            }
            return nil // Return nil if no texture is available for the value
        }
    }

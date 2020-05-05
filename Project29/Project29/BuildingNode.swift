//
//  BuildingNode.swift
//  Project29
//
//  Created by Kevin Ngo on 2020-05-04.
//  Copyright © 2020 Kevin Ngo. All rights reserved.
//

import SpriteKit
import UIKit

class BuildingNode: SKSpriteNode {
    var currentImage: UIImage!
    
    func setup() {
        name = "building"

        currentImage = drawBuilding(size: size)
        texture = SKTexture(image: currentImage)

        configurePhysics()
    }

    func configurePhysics() {
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.isDynamic = false
        physicsBody?.categoryBitMask = CollisionTypes.building.rawValue
        physicsBody?.contactTestBitMask = CollisionTypes.banana.rawValue
    }
    
    func drawBuilding(size: CGSize) -> UIImage {
        // Create new CG context the size of our building
        let renderer = UIGraphicsImageRenderer(size: size)
        let img = renderer.image { ctx in
            // Fill it with a rectangle that's one of 3 colors
            let rectangle = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            let color: UIColor

            switch Int.random(in: 0...2) {
            case 0:
                color = UIColor(hue: 0.502, saturation: 0.98, brightness: 0.67, alpha: 1)
            case 1:
                color = UIColor(hue: 0.999, saturation: 0.99, brightness: 0.67, alpha: 1)
            default:
                color = UIColor(hue: 0, saturation: 0, brightness: 0.67, alpha: 1)
            }

            color.setFill()
            ctx.cgContext.addRect(rectangle)
            ctx.cgContext.drawPath(using: .fill)

            // Draw windows all over the building in one of two colors (yellow or gray)
            let lightOnColor = UIColor(hue: 0.190, saturation: 0.67, brightness: 0.99, alpha: 1)
            let lightOffColor = UIColor(hue: 0, saturation: 0, brightness: 0.34, alpha: 1)

            for row in stride(from: 10, to: Int(size.height - 10), by: 40) {
                for col in stride(from: 10, to: Int(size.width - 10), by: 40) {
                    if Bool.random() {
                        lightOnColor.setFill()
                    } else {
                        lightOffColor.setFill()
                    }

                    ctx.cgContext.fill(CGRect(x: col, y: row, width: 15, height: 20))
                }
            }

            // Pull out result as UIImage and return it for use elsewhere
        }

        return img
    }

    func hitAt(point: CGPoint) {
        let convertedPoint = CGPoint(x: point.x + size.width / 2.0, y: abs(point.y - (size.height / 2.0)))

        let renderer = UIGraphicsImageRenderer(size: size)
        let img = renderer.image { ctx in
            currentImage.draw(at: CGPoint(x: 0, y: 0))

            ctx.cgContext.addEllipse(in: CGRect(x: convertedPoint.x - 32, y: convertedPoint.y - 32, width: 64, height: 64))
            ctx.cgContext.setBlendMode(.clear)
            ctx.cgContext.drawPath(using: .fill)
        }

        texture = SKTexture(image: img)
        currentImage = img

        configurePhysics()
    }
    
}

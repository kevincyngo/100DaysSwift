//
//  MovingTarget.swift
//  Milestone-Project16-18
//
//  Created by Kevin Ngo on 2020-04-13.
//  Copyright © 2020 Kevin Ngo. All rights reserved.
//

import UIKit
import SpriteKit

class MovingTarget: SKNode {
    var targetNode: SKSpriteNode!
    var isHit = false
    
    var isLeftSpawn: Bool!
    
    
    func configure(at position: CGPoint, isLeftSpawn: Bool) {
        self.position = position
        self.isLeftSpawn = isLeftSpawn
        
        let target = Int.random(in: 1...3)
        self.name = String(target)
        targetNode = SKSpriteNode(imageNamed: "target\(target-1)")
        targetNode.position = CGPoint(x: 0, y: 0)
//        charNode.name = "character"
        addChild(targetNode)
    }
    
    func hit() {
        isHit = true
        targetNode.removeFromParent()
    }
    
    func move() {
        let speed = Double.random(in: 2...5)
        
        if isLeftSpawn {
            targetNode.run(SKAction.sequence([SKAction.moveBy(x: 1200, y: 0, duration: speed)
            , SKAction.removeFromParent()]))
        } else {
            targetNode.run(SKAction.sequence([SKAction.moveBy(x: -1200, y: 0, duration: speed)
            , SKAction.removeFromParent()]))
        }
        
    }
    
}

//
//  GameScene.swift
//  Project11
//
//  Created by Kevin Ngo on 2020-03-30.
//  Copyright © 2020 Kevin Ngo. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    //equivalent of UIKit's viewDidLoad() method
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background.jpg")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        //adds physics body to the whole scene that is a line on each edge, effectively acting as a container for the scene
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
        makeBouncer(at: CGPoint(x: 0, y: 0))
        makeBouncer(at: CGPoint(x: 256, y: 0))
        makeBouncer(at: CGPoint(x: 512, y: 0))
        makeBouncer(at: CGPoint(x: 768, y: 0))
        makeBouncer(at: CGPoint(x: 1024, y: 0))
    }
    
    func makeBouncer(at position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2.0)
        
        //when this is true, the object will be moved by physics simulator based on gravity and collision
        //when this is false, the object will collide with other things, but won't be moved as a result
        bouncer.physicsBody?.isDynamic = false
        addChild(bouncer)
    }
    
    //method gets called in UIKit and SpriteKit whenever someone starts touching their device
    //its possible they touch with multiple fingers at the same time, so we pass a Set<UITouch>
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            let location = touch.location(in: self)
            let ball = SKSpriteNode(imageNamed: "ballRed")
            ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
            //restitution = bounciness (range is 0 to 1)
            ball.physicsBody?.restitution = 0.4
            ball.position = location
            addChild(ball)
        }
        
        
// MARK: - LESSON: Falling boxes: SKSpriteNode, UITouch, SKPhysicsBody
//        //we want to know where the scene was touched, so we use conditional typecast plus
//        // if let to pull out any of the screen touches from the touches set
//        if let touch = touches.first {
//            //use location to find where the touch occurred in relation to self (the game scene)
//            let location = touch.location(in: self)
//            let box = SKSpriteNode(color: UIColor.red, size: CGSize(width: 64, height: 64))
//
//            //adds a physics body to the body that is a rectangle of the same size as the box
//            box.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 64, height: 64))
//            box.position = location
//            addChild(box)
//        }
    }
}

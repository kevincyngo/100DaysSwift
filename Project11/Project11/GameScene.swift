//
//  GameScene.swift
//  Project11
//
//  Created by Kevin Ngo on 2020-03-30.
//  Copyright © 2020 Kevin Ngo. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var scoreLabel: SKLabelNode!
    
    let BALL_COLORS = ["ballBlue", "ballYellow", "ballPurple", "ballGrey", "ballRed", "ballCyan", "ballGreen"]
    let MAX_BALLS = 5
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var editLabel: SKLabelNode!
    
    var numBalls = 0
    
    var editingMode: Bool = false {
        didSet {
            if editingMode {
                editLabel.text = "Done"
            } else {
                editLabel.text = "Edit"
            }
        }
    }
    
    //equivalent of UIKit's viewDidLoad() method
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background.jpg")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        //adds physics body to the whole scene that is a line on each edge, effectively acting as a container for the scene
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self
        makeBouncer(at: CGPoint(x: 0, y: 0))
        makeBouncer(at: CGPoint(x: 256, y: 0))
        makeBouncer(at: CGPoint(x: 512, y: 0))
        makeBouncer(at: CGPoint(x: 768, y: 0))
        makeBouncer(at: CGPoint(x: 1024, y: 0))
        
        makeSlot(at: CGPoint(x: 128, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 384, y: 0), isGood: false)
        makeSlot(at: CGPoint(x: 640, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 896, y: 0), isGood: false)
        
        //setup score label
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 980, y: 700)
        addChild(scoreLabel)
        
        //setup edit label
        editLabel = SKLabelNode(fontNamed: "Chalkduster")
        editLabel.text = "Edit"
        editLabel.position = CGPoint(x: 80, y: 700)
        addChild(editLabel)
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
    
    func makeSlot(at position: CGPoint, isGood: Bool) {
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode
        
        if isGood {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            slotBase.name = "good"
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name = "bad"
        }
        
        slotBase.position = position
        slotGlow.position = position
        
        let spin = SKAction.rotate(byAngle: .pi, duration: 10)
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)
        
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody?.isDynamic = false
        
        addChild(slotBase)
        addChild(slotGlow)
    }
    
    func collisionBetween(ball: SKNode, object: SKNode) {
        if object.name == "good" {
            destroy(object: ball)
            score += 1
        } else if object.name == "bad" {
            destroy(object: ball)
            score -= 1
        //CHALLENGE 3
        } else if object.name == "box" {
            destroy(object: object)
        }
    }

    func destroy(object: SKNode) {
        if object.name == "ball" {
            if let fireParticles = SKEmitterNode(fileNamed: "FireParticles") {
                fireParticles.position = object.position
                addChild(fireParticles)
            }
            numBalls -= 1
        }
        
        object.removeFromParent()
    }
    
    //called when two bodies contact eachother
    func didBegin(_ contact: SKPhysicsContact) {
        //use guard to check that both bodyA and bodyB have nodes attached
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA.name == "ball" {
            collisionBetween(ball: nodeA, object: nodeB)
        } else if nodeB.name == "ball" {
            collisionBetween(ball: nodeB, object: nodeA)
        }
    }
    //method gets called in UIKit and SpriteKit whenever someone starts touching their device
    //its possible they touch with multiple fingers at the same time, so we pass a Set<UITouch>
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            let location = touch.location(in: self)
            let objects = nodes(at: location)
            
            if objects.contains(editLabel) {
                editingMode.toggle()
            } else {
                if editingMode {
                    // create a box
                    let size = CGSize(width: Int.random(in: 16...128), height: 16)
                    let box = SKSpriteNode(color: UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1), size: size)
                    box.zRotation = CGFloat.random(in: 0...3)
                    box.position = location
                    box.name = "box"
                    box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
                    box.physicsBody?.isDynamic = false
                    addChild(box)
                    
                } else {
                    //CHALLENGE 2 (only create balls if clicked at upper 40% of screen)
                    if location.y >= UIScreen.main.bounds.height*0.6 && numBalls < 5 {
                        // create a ball (CHALLENGE 1)
                        let ball = SKSpriteNode(imageNamed: BALL_COLORS[Int.random(in:0..<BALL_COLORS.count)])
                        ball.name = "ball"
                        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
                        
                        //collisionBitMask -> which nodes should I bump into? (by default it's set to everything)
                        //contactTestBitMask -> which collisions do you want to know about? (by default it's set to nothing)
                        ball.physicsBody!.contactTestBitMask = ball.physicsBody!.collisionBitMask
                        
                        //restitution = bounciness (range is 0 to 1)
                        ball.physicsBody?.restitution = 0.4
                        ball.position = location
                        
                        numBalls += 1
                        print(numBalls)
                        
                        addChild(ball)
                    }
                }
                
                
                
            }
            
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

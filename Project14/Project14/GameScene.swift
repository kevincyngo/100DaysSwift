//
//  GameScene.swift
//  Project14
//
//  Created by Kevin Ngo on 2020-04-05.
//  Copyright © 2020 Kevin Ngo. All rights reserved.
//

import SpriteKit
import GameplayKit
import SpriteKit

class GameScene: SKScene {
    var gameScore: SKLabelNode!
    var popupTime = 0.85
    
    var score = 0 {
        didSet {
            gameScore.text = "Score \(score)"
        }
    }
    
    var slots = [WhackSlot]()
    
    var finalScore: SKLabelNode!
    
    //limited to 30 roudns of enemies, each round is one call to createEnemy()
    var numRounds = 0
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "whackBackground")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        gameScore = SKLabelNode(fontNamed: "Chalkduster")
        gameScore.text = "Score 0"
        gameScore.position = CGPoint(x: 8, y: 8)
        gameScore.horizontalAlignmentMode = .left
        gameScore.fontSize = 48
        addChild(gameScore)
        
        for i in 0 ..< 5 { createSlot(at: CGPoint(x: 100 + (i * 170), y: 410)) }
        for i in 0 ..< 4 { createSlot(at: CGPoint(x: 180 + (i * 170), y: 320)) }
        for i in 0 ..< 5 { createSlot(at: CGPoint(x: 100 + (i * 170), y: 230)) }
        for i in 0 ..< 4 { createSlot(at: CGPoint(x: 180 + (i * 170), y: 140)) }
        
        createEnemy()
    }

    //this method finds any touches, find where it was tapped, then get node array of all nodes at that point
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        
        for node in tappedNodes {
            guard let whackSlot = node.parent?.parent as? WhackSlot else { continue }
            if !whackSlot.isVisible { continue }
            if whackSlot.isHit { continue }
            whackSlot.hit()
            
            if node.name == "charFriend" {
                //shouldn't have whacked this penguin
                score -= 5
                
                run(SKAction.playSoundFileNamed("whackBad.caf", waitForCompletion: false))
                smokeEffect(whackSlot)
            } else if node.name == "charEnemy" {
                //should have whacked this one
                whackSlot.charNode.xScale = 0.85
                whackSlot.charNode.yScale = 0.85
                score += 1
                
                run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
                smokeEffect(whackSlot)
            }
        }
    }
    
    func smokeEffect(_ whackSlot: WhackSlot) {
        if let particles = SKEmitterNode(fileNamed: "smokeParticle.sks") {
            
            particles.position = whackSlot.position
            addChild(particles)
        }
        
    }
    
    func createSlot(at position: CGPoint) {
        let slot = WhackSlot()
        slot.configure(at: position)
        addChild(slot)
        slots.append(slot)
    }
    
    func createEnemy() {
        numRounds += 1
        
        if numRounds >= 30 {
            for slot in slots {
                slot.hide()
            }
            
            let gameOver = SKSpriteNode(imageNamed: "gameOver")
            gameOver.position = CGPoint(x: 512, y: 384)
            gameOver.zPosition = 1
            addChild(gameOver)
            
            finalScore = SKLabelNode(fontNamed: "Chalkduster")
            finalScore.text = "Final " + gameScore.text!
            finalScore.position = CGPoint(x: 512, y: 304)
//            finalScore.horizontalAlignmentMode = .left
            finalScore.zPosition = 1
            finalScore.fontSize = 48
            gameScore.text = ""
            addChild(finalScore)
            
            return
        }
        
        popupTime *= 0.991
        
        slots.shuffle()
        slots[0].show(hideTime: popupTime)
        
        if Int.random(in: 0...12) > 4 { slots[1].show(hideTime: popupTime) }
        if Int.random(in: 0...12) > 8 { slots[2].show(hideTime: popupTime) }
        if Int.random(in: 0...12) > 10 { slots[3].show(hideTime: popupTime) }
        if Int.random(in: 0...12) > 11 { slots[4].show(hideTime: popupTime) }

        let minDelay = popupTime / 2.0
        let maxDelay = popupTime * 2
        let delay = Double.random(in: minDelay...maxDelay)
        
        //calls itself so we only need to call createEnemy() once in didMove(to: )
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.createEnemy()
        }
    }    
}

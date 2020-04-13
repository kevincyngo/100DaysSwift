//
//  GameScene.swift
//  Milestone-Project16-18
//
//  Created by Kevin Ngo on 2020-04-13.
//  Copyright © 2020 Kevin Ngo. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var timerLabel: SKLabelNode!
    var timer = 0 {
        didSet {
            timerLabel.text = "\(timer)"
        }
    }
        
    var gameTimer: Timer?
    
    let MAX_VISIBLE_WIDTH = 1024
    let MAX_VISIBLE_HEIGHT = 768
    let LEFT_SPAWN_WIDTH = -100
    let RIGHT_SPAWN_WIDTH = 1124
    
    override func didMove(to view: SKView) {
        
        //Add background
        let background = SKSpriteNode(imageNamed: "wood-background")
        background.position = CGPoint(x: MAX_VISIBLE_WIDTH/2, y: MAX_VISIBLE_HEIGHT/2)
        background.scale(to: CGSize(width: MAX_VISIBLE_WIDTH, height: MAX_VISIBLE_HEIGHT))
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        //Add score tracking
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        score = 0
        
        timerLabel = SKLabelNode(fontNamed: "Chalkduster")
        timerLabel.position = CGPoint(x:MAX_VISIBLE_WIDTH/2, y: MAX_VISIBLE_HEIGHT - 50)
        addChild(timerLabel)
        timer = 5
        
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(createTarget), userInfo: nil, repeats: true)
        
    }
    
    @objc func createTarget() {
        let row = Int.random(in: 0...2)
        let startingPosition = Int.random(in: 0...3)
        let movingTarget = MovingTarget()
        if startingPosition % 2 == 0 {
            movingTarget.configure(at: CGPoint(x: LEFT_SPAWN_WIDTH, y: 150 + row*200), isLeftSpawn: true)
        } else {
            movingTarget.configure(at: CGPoint(x: RIGHT_SPAWN_WIDTH, y: 150 + row*200), isLeftSpawn: false)
        }
        addChild(movingTarget)
        movingTarget.move()
        
        if (timer == 0) {
            gameOver()
        }
        timer -= 1
        
    }
    
    func gameOver() {
        gameTimer?.invalidate()
        for node in children {
            node.removeFromParent()
        }
        
        //Add background
        let background = SKSpriteNode(imageNamed: "curtains")
        background.position = CGPoint(x: MAX_VISIBLE_WIDTH/2, y: MAX_VISIBLE_HEIGHT/2)
        background.scale(to: CGSize(width: MAX_VISIBLE_WIDTH, height: MAX_VISIBLE_HEIGHT))
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        let gameOverImage = SKSpriteNode(imageNamed: "game-over")
        gameOverImage.position = CGPoint(x: MAX_VISIBLE_WIDTH/2, y: MAX_VISIBLE_HEIGHT/2)
        addChild(gameOverImage)
        
        let finalScoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        finalScoreLabel.text = "Final score: \(score)"
        finalScoreLabel.position = CGPoint(x: MAX_VISIBLE_WIDTH/2, y: MAX_VISIBLE_HEIGHT/2 - 100)
        addChild(finalScoreLabel)
    }
    
    //
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        /*
         for node in children {
             if node.position.x < -300 {
                 node.removeFromParent()
             }
         }

         if !isGameOver {
             score += 1
         }
         */
    }
    
    //this method finds any touches, find where it was tapped, then get node array of all nodes at that point
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        
        // guard let whackSlot = node.parent?.parent as? WhackSlot else { continue }
        for node in tappedNodes {
            guard let target = node as? MovingTarget else { continue }
            
            target.hit()
            
            score += 1*(Int(target.name ?? "1") ?? 1)
            return
        }
    }
}

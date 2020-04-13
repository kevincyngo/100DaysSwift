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
        
    var bulletsSprites = [SKSpriteNode]()
    
    var bulletsRemaining = 3
    
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
        scoreLabel.position = CGPoint(x: 32, y: 32)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        score = 0
        
        let shots0 = SKSpriteNode(imageNamed: "shots0")
        shots0.position = CGPoint(x: 950, y: 32)
        
        let shots1 = SKSpriteNode(imageNamed: "shots1")
        shots1.position = CGPoint(x: 950, y: 32)
        
        let shots2 = SKSpriteNode(imageNamed: "shots2")
        shots2.position = CGPoint(x: 950, y: 32)
        
        let shots3 = SKSpriteNode(imageNamed: "shots3")
        shots3.position = CGPoint(x: 950, y: 32)
        
        bulletsSprites.append(shots0)
        bulletsSprites.append(shots1)
        bulletsSprites.append(shots2)
        bulletsSprites.append(shots3)

        addChild(bulletsSprites[0])
        addChild(bulletsSprites[1])
        addChild(bulletsSprites[2])
        addChild(bulletsSprites[3])
        
        bulletsSprites[0].isHidden = true
        bulletsSprites[1].isHidden = true
        bulletsSprites[2].isHidden = true
        
        timerLabel = SKLabelNode(fontNamed: "Chalkduster")
        timerLabel.position = CGPoint(x:MAX_VISIBLE_WIDTH/2, y: MAX_VISIBLE_HEIGHT - 50)
        addChild(timerLabel)
        timer = 60
        
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(createTarget), userInfo: nil, repeats: true)
        
    }
    
    @objc func createTarget() {
        let row = Int.random(in: 0...2)
        let startingPosition = Int.random(in: 0...3)
        let movingTarget = MovingTarget()
        if startingPosition % 2 == 0 {
            movingTarget.configure(at: CGPoint(x: LEFT_SPAWN_WIDTH, y: 250 + row*100), isLeftSpawn: true)
        } else {
            movingTarget.configure(at: CGPoint(x: RIGHT_SPAWN_WIDTH, y: 250 + row*100), isLeftSpawn: false)
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
    

    func reload(_ bulletAmt: Int) {
        for bullet in bulletsSprites {
            bullet.isHidden = true
        }
        bulletsSprites[bulletAmt].isHidden = false
        
    }
    
    //this method finds any touches, find where it was tapped, then get node array of all nodes at that point
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        
        if location.y <= 200 || location.y >= 600 {
            bulletsRemaining = 3
        } else {
            if bulletsRemaining == 0 {
                return
            }
            bulletsRemaining = max(0, bulletsRemaining-1)
        }
        reload(bulletsRemaining)

        // guard let whackSlot = node.parent?.parent as? WhackSlot else { continue }
        for node in tappedNodes {
            guard let target = node as? MovingTarget else { continue }
            
            target.hit()
            
            score += 1*(Int(target.name ?? "1") ?? 1)
            return
        }
    }
}

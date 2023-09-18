//
//  HowToPowerUp.swift
//  GOALZ
//
//  Created by Carter Stambaugh on 7/15/19.
//  Copyright © 2019 Carter Stambaugh. All rights reserved.
//


import Foundation
import SpriteKit

class HowToPowerUp: SKScene, SKPhysicsContactDelegate{
    
    struct physicsCategories{
        static let none : UInt32 = 0
        static let Ball : UInt32 = 0b1
        static let Defender : UInt32 = 0b10
        static let fire : UInt32 = 0b100
        static let goal : UInt32 = 0b1000
        
    }
    
    let ball = SKSpriteNode(imageNamed: "lightGrayBlueBall")
    let firePowerUp = SKSpriteNode(imageNamed: "firePowerUp")
    let firePowerUpIcon = SKSpriteNode(imageNamed: "firePowerUp")
    let powerUpNumLabel = SKLabelNode(fontNamed: "The Bold Font")
    let GameGoal = SKSpriteNode(imageNamed: "Goal")
    let hand = SKSpriteNode(imageNamed: "MoveHand")
    
    override func didMove(to view: SKView) {
        
        
        
        physicsWorld.contactDelegate = self
        
        firePowerUpIcon.position = CGPoint(x: self.size.width*0.74, y: self.size.height * 0.05)
        firePowerUpIcon.setScale(0.5)
        firePowerUpIcon.alpha = 0.3
        firePowerUpIcon.zPosition = 100
        self.addChild(firePowerUpIcon)
        
        
        powerUpNumLabel.text = "\(0)"
        powerUpNumLabel.fontSize = 30
        powerUpNumLabel.fontColor = SKColor.white
        powerUpNumLabel.alpha = 0.3
        powerUpNumLabel.position = CGPoint(x: self.size.width * 0.76, y: self.size.height * 0.03)
        powerUpNumLabel.zPosition = 101
        self.addChild(powerUpNumLabel)
        
        
        let background = SKSpriteNode(imageNamed: "MainMenuBackground")
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        
        let back = SKSpriteNode(imageNamed: "back-1")
        back.setScale(1)
        back.position = CGPoint(x: self.size.width * 0.25, y: self.size.height*0.9)
        back.zPosition = 1
        back.name = "back"
        self.addChild(back)
        
        
        let howToBack = SKSpriteNode(imageNamed: "HowToBackground2")
        howToBack.setScale(2)
        howToBack.position = CGPoint(x: self.size.width * 0.5, y: self.size.height*0.45)
        howToBack.zPosition = 1
        self.addChild(howToBack)
        
        
        
        
        ball.setScale(0.35)
        ball.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.25)
        ball.zPosition = 70
        self.addChild(ball)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
        ball.physicsBody?.collisionBitMask = physicsCategories.none
        ball.physicsBody?.categoryBitMask = physicsCategories.Ball
        ball.physicsBody?.contactTestBitMask = physicsCategories.Defender | physicsCategories.goal
        ball.physicsBody?.affectedByGravity = false
        
        
        firePowerUp.setScale(0.5)
        firePowerUp.position = CGPoint(x: self.size.width*0.3, y: self.size.height*0.5)
        firePowerUp.zPosition = 69
        self.addChild(firePowerUp)
        firePowerUp.physicsBody = SKPhysicsBody(circleOfRadius: firePowerUp.size.width / 2.0)
        firePowerUp.physicsBody?.categoryBitMask = physicsCategories.fire
        firePowerUp.physicsBody?.contactTestBitMask = physicsCategories.Ball
        firePowerUp.physicsBody?.collisionBitMask = physicsCategories.none
        firePowerUp.physicsBody?.isDynamic = false
        firePowerUp.physicsBody?.affectedByGravity = false
        
        hand.setScale(0.2)
        hand.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.22)
        hand.zPosition = 4
        self.addChild(hand)
        
        let yard_Box = SKSpriteNode(imageNamed: "18yard_box")
        yard_Box.setScale(0.8)
        yard_Box.position = CGPoint(x: self.size.width*0.5, y: (self.size.height*0.695))
        yard_Box.zPosition = 2
        self.addChild(yard_Box)
        
        
        let sixBox = SKSpriteNode(imageNamed: "sixBox")
        sixBox.setScale(0.8)
        sixBox.position = CGPoint(x: self.size.width*0.5, y: (self.size.height*0.72))
        sixBox.zPosition = 3
        self.addChild(sixBox)
        
        let next = SKSpriteNode(imageNamed: "next")
        next.setScale(1.0)
        next.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.1)
        next.zPosition = 4
        next.name = "Next"
        self.addChild(next)
        
        let Deffender = SKSpriteNode(imageNamed: "Line")
        Deffender.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: Deffender.size.width - 10, height: 10.0))
        Deffender.setScale(3)
        Deffender.physicsBody?.affectedByGravity = false
        Deffender.physicsBody?.categoryBitMask = physicsCategories.Defender
        Deffender.physicsBody?.contactTestBitMask = physicsCategories.Ball
        Deffender.physicsBody?.collisionBitMask = physicsCategories.Ball
        Deffender.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.5)
        Deffender.physicsBody!.restitution = 1
        Deffender.physicsBody!.friction = 0
        Deffender.physicsBody?.isDynamic = true
        Deffender.zPosition = 3
        Deffender.physicsBody!.allowsRotation = false
        Deffender.physicsBody?.mass = 0.001
        self.addChild(Deffender)
        
        /*
         let moveDeffenderLeft = SKAction.moveTo(x: self.size.width*0.46, duration: 2.0)
         let moveDeffenderRight = SKAction.moveTo(x: self.size.width*0.65, duration: 3.0)
         let moveDeffenderSeq = SKAction.sequence([ moveDeffenderRight,moveDeffenderLeft])*/
        
        //Deffender.run(moveDeffenderSeq)
        
        let GameGoal = SKSpriteNode(imageNamed: "Goal")
        GameGoal.setScale(2)
        GameGoal.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.78)
        
        GameGoal.zPosition = 1
        self.addChild(GameGoal)
        print(ball.position)
        print(GameGoal.position)
        GameGoal.physicsBody = SKPhysicsBody(circleOfRadius: 10)
        GameGoal.physicsBody?.affectedByGravity = false
        GameGoal.physicsBody?.categoryBitMask = physicsCategories.goal
        GameGoal.physicsBody?.contactTestBitMask = physicsCategories.Ball
        //hand Actions
        GameGoal.physicsBody?.isDynamic = false
        let moveHandRight = SKAction.move(to: CGPoint(x: self.size.width*0.55, y: self.size.height*0.22), duration: 1.0)
        let fadeOut = SKAction.fadeAlpha(by: -0.7, duration: 0.5)
        
        
        let dashedLine = SKSpriteNode(imageNamed: "dashedline")
        dashedLine.setScale(0.5)
        dashedLine.position = ball.position
        dashedLine.anchorPoint = CGPoint(x: 0.5, y: 0)
        dashedLine.zPosition = 200
        dashedLine.alpha = 1
        self.addChild(dashedLine)
        
        //dashed Line actions
        let dashedLineRotateLeft = SKAction.rotate(byAngle: 3.14159 / 4.15, duration: 1.0)
        let deleteLine = SKAction.removeFromParent()
        
        //ball actions
        let moveBall = SKAction.move(to: firePowerUp.position, duration: 0.8)
        
        
        hand.run(SKAction.sequence([moveHandRight, fadeOut]))
        dashedLine.run(SKAction.sequence([dashedLineRotateLeft, deleteLine]))
        
        let instructionLabel = SKLabelNode(fontNamed: "The Bold Font")
        instructionLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        instructionLabel.position = CGPoint( x: self.size.width * 0.5, y: self.size.height * 0.18)
        instructionLabel.text = "Hit the Fire Power Up"
        instructionLabel.zPosition = 10
        instructionLabel.zPosition = 20
        instructionLabel.fontColor = SKColor.white
        self.addChild(instructionLabel)
        
        let instructionLabel2 = SKLabelNode(fontNamed: "The Bold Font")
        instructionLabel2.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        instructionLabel2.position = CGPoint( x: self.size.width * 0.5, y: self.size.height * 0.16)
        instructionLabel2.text = "to BLAST BY Defenders"
        instructionLabel2.zPosition = 10
        instructionLabel2.zPosition = 20
        instructionLabel2.fontColor = SKColor.white
        self.addChild(instructionLabel2)
        let fadeIn = SKAction.fadeAlpha(by: -0.7, duration: 0.5)
        let fadeOut1 = SKAction.fadeAlpha(by: 0.7, duration: 0.5)
        let fadeOutSeq = SKAction.sequence([fadeIn, fadeOut1])
        instructionLabel.run(SKAction.repeatForever(fadeOutSeq))
        instructionLabel2.run(SKAction.repeatForever(fadeOutSeq))
        
        
        delay(1.5){
            self.ball.run(moveBall)
        }
    }
    
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        var body1 = SKPhysicsBody()
        var body2 = SKPhysicsBody()
        if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask){
            body1 = contact.bodyA
            body2 = contact.bodyB
        }
        else{
            body1 = contact.bodyB
            body2 = contact.bodyA
        }
        if (body1.categoryBitMask == physicsCategories.Ball && body2.categoryBitMask == physicsCategories.fire){
            /*ball.removeAllActions()
             ball.physicsBody!.contactTestBitMask = 0
             ball.physicsBody!.collisionBitMask = 0
             ball.physicsBody!.velocity = CGVector(dx: 0, dy: 0)*/
            let fadeOut = SKAction.fadeOut(withDuration: 0.6)
            let fadeOut2 = SKAction.fadeOut(withDuration: 1.0)
            let fadeIn = SKAction.fadeIn(withDuration: 0.8)
            self.ball.run(fadeOut)
            self.firePowerUp.run(fadeOut2)
            firePowerUp.removeFromParent()
            delay(1.0){
                self.ball.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.25)
                //self.ball.texture = SKTexture(imageNamed: "fire")
                self.ball.run(fadeIn)
                
            }
            firePowerUpIcon.alpha = 1
            powerUpNumLabel.alpha = 1
            powerUpNumLabel.text = "\(1)"
            let handMoveRight = SKAction.move(to: CGPoint(x: firePowerUpIcon.position.x, y: firePowerUpIcon.position.y - 20) , duration: 0.7)
            hand.run(handMoveRight)
            hand.zPosition = 102
            let handMoveLeft = SKAction.move(to: CGPoint(x: self.size.width*0.5, y: self.size.height*0.24), duration: 1.3)
            delay(1.0){
                self.hand.alpha = 1
            }
            delay(2.0){
               // self.ball.texture = SKTexture(imageNamed: "fire")
                
                self.firePowerUpIcon.alpha = 0.3
                self.powerUpNumLabel.alpha = 0.3
                self.powerUpNumLabel.text = "\(0)"
                self.hand.run(handMoveLeft)
                self.delay(1.0){
                    self.hand.alpha = 0.3
                }
            }
            delay(3.6){
                self.ball.zRotation = 3.14159
                self.ball.physicsBody?.applyForce(CGVector(dx: 0, dy: 7000))
            }
            
        }
        if (body1.categoryBitMask == physicsCategories.Ball && body2.categoryBitMask == physicsCategories.goal){
            self.ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            
        }
    }
    
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches{
            
            let pointOfTouch = touch.location(in: self)
            let nodeITapped = atPoint(pointOfTouch)
            
            
            if nodeITapped.name == "back"
            {
                let sceneToMoveTo = HowToFeatures(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
            }
            
            
            
            if nodeITapped.name == "Next"
            {
                let sceneToMoveTo = HowToSafetyZone(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
            }
        }
        
    }
}

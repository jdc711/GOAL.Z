//
//  HowToFeatures.swift
//  GOALZ
//
//  Created by Carter Stambaugh on 7/15/19.
//  Copyright © 2019 Carter Stambaugh. All rights reserved.
//

import Foundation
import SpriteKit

class HowToFeatures: SKScene, SKPhysicsContactDelegate{
    
    struct physicsCategories{
        static let none : UInt32 = 0
        static let Ball : UInt32 = 0b1
        static let Defender : UInt32 = 0b10
        static let Teleporation : UInt32 = 0b100
    }
    
    let ball = SKSpriteNode(imageNamed: "lightGrayBlueBall")
    let instantGoal = SKSpriteNode(imageNamed: "instantGoal")
    let GameGoal = SKSpriteNode(imageNamed: "Goal")
    
    override func didMove(to view: SKView) {
        
        
        
        physicsWorld.contactDelegate = self
        
        
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
        
        
        
        let next = SKSpriteNode(imageNamed: "next")
        next.setScale(1.0)
        next.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.1)
        next.zPosition = 4
        next.name = "Next"
        self.addChild(next)
        
        
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
        ball.physicsBody?.contactTestBitMask = physicsCategories.Teleporation
        ball.physicsBody?.affectedByGravity = false
        
        
        instantGoal.setScale(0.2)
        instantGoal.position = CGPoint(x: self.size.width*0.3, y: self.size.height*0.5)
        instantGoal.zPosition = 69
        self.addChild(instantGoal)
        instantGoal.physicsBody = SKPhysicsBody(circleOfRadius: instantGoal.size.width / 2.0)
        instantGoal.physicsBody?.categoryBitMask = physicsCategories.Teleporation
        instantGoal.physicsBody?.contactTestBitMask = physicsCategories.Ball
        instantGoal.physicsBody?.collisionBitMask = physicsCategories.none
        instantGoal.physicsBody?.isDynamic = false
        instantGoal.physicsBody?.affectedByGravity = false
        
        let hand = SKSpriteNode(imageNamed: "MoveHand")
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
        
        
        let GameGoal = SKSpriteNode(imageNamed: "Goal")
        GameGoal.setScale(2)
        GameGoal.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.78)
        //GameGoal.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 210, height: 0.1), center: GameGoal.position )
        GameGoal.zPosition = 4
        self.addChild(GameGoal)
        
        //hand Actions
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
        let moveBall = SKAction.move(to: instantGoal.position, duration: 0.8)
        
        hand.run(SKAction.sequence([moveHandRight, fadeOut]))
        dashedLine.run(SKAction.sequence([dashedLineRotateLeft, deleteLine]))
        
        let instructionLabel = SKLabelNode(fontNamed: "The Bold Font")
        instructionLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        instructionLabel.position = CGPoint( x: self.size.width * 0.5, y: self.size.height * 0.18)
        instructionLabel.text = "Hit the teleportation portal"
        instructionLabel.zPosition = 10
        instructionLabel.zPosition = 20
        instructionLabel.fontColor = SKColor.white
        self.addChild(instructionLabel)
        
        let instructionLabel2 = SKLabelNode(fontNamed: "The Bold Font")
        instructionLabel2.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        instructionLabel2.position = CGPoint( x: self.size.width * 0.5, y: self.size.height * 0.16)
        instructionLabel2.text = "to instantly score a GOAL!"
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
        if (body1.categoryBitMask == physicsCategories.Ball && body2.categoryBitMask == physicsCategories.Teleporation){
            /*ball.removeAllActions()
             ball.physicsBody!.contactTestBitMask = 0
             ball.physicsBody!.collisionBitMask = 0
             ball.physicsBody!.velocity = CGVector(dx: 0, dy: 0)*/
            let fadeOut = SKAction.fadeOut(withDuration: 0.6)
            let fadeOut2 = SKAction.fadeOut(withDuration: 1.0)
            let fadeIn = SKAction.fadeIn(withDuration: 0.8)
            let fadeIn2 = SKAction.fadeIn(withDuration: 0.5)
            //let fadeOut3 = SKAction.fadeOut(withDuration: 2.0)
            self.ball.run(fadeOut)
            self.instantGoal.run(fadeOut2)
            
            delay(1.0){
                self.ball.position = CGPoint(x: self.size.width*0.5, y: self.size.height * 0.78)
                
                
                self.instantGoal.position = self.GameGoal.position
                self.instantGoal.run(fadeIn2)
                self.ball.run(fadeIn)
                self.delay(0.5){
                    
                    print("sdsdd")
                    self.instantGoal.run(fadeOut2)
                }
            }
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
                let sceneToMoveTo = HowToPlay(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
            }
            
            
            if nodeITapped.name == "Next"
            {
                let sceneToMoveTo = HowToPowerUp(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
            }
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
    }
    
    
    
}

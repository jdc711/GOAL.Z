//
//  HowToPlay.swift
//  GOALZ
//
//  Created by Carter Stambaugh on 7/15/19.
//  Copyright © 2019 Carter Stambaugh. All rights reserved.
//

import Foundation
import SpriteKit

class HowToPlay: SKScene {
    
    
    
    
    override func didMove(to view: SKView) {
        
        
    
        let background = SKSpriteNode(imageNamed: "MainMenuBackground")
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        /*let howToPlay = SKSpriteNode(imageNamed: "HowtoPlay")
         howToPlay.setScale(1.2)
         howToPlay.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.85)
         howToPlay.zPosition = 1
         self.addChild(howToPlay)
         */
        
        let back = SKSpriteNode(imageNamed: "back-1")
        back.setScale(1)
        back.position = CGPoint(x: self.size.width * 0.25, y: self.size.height*0.9)
        back.zPosition = 1
        back.name = "back"
        if (playedBefore){
            self.addChild(back)
        }
        
        let howToBack = SKSpriteNode(imageNamed: "HowToBackground2")
        howToBack.setScale(2)
        howToBack.position = CGPoint(x: self.size.width * 0.5, y: self.size.height*0.45)
        howToBack.zPosition = 1
        self.addChild(howToBack)
        
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
        GameGoal.zPosition = 4
        self.addChild(GameGoal)
        
        let hand = SKSpriteNode(imageNamed: "MoveHand")
        hand.setScale(0.2)
        hand.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.28)
        hand.alpha = 0.3
        hand.zPosition = 4
        self.addChild(hand)
        
        let next = SKSpriteNode(imageNamed: "next")
        next.setScale(1.0)
        next.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.1)
        next.zPosition = 4
        next.name = "Next"
        self.addChild(next)
        
        let instructionLabel = SKLabelNode(fontNamed: "The Bold Font")
        instructionLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        instructionLabel.position = CGPoint( x: self.size.width * 0.5, y: self.size.height * 0.20)
        instructionLabel.text = "Touch and hold onto the ball to aim "
        instructionLabel.zPosition = 5
        instructionLabel.zPosition = 20
        instructionLabel.fontColor = SKColor.white
        self.addChild(instructionLabel)
        
        
        let instructionLabel2 = SKLabelNode(fontNamed: "The Bold Font")
        instructionLabel2.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        instructionLabel2.position = CGPoint( x: self.size.width * 0.5, y: self.size.height * 0.20)
        instructionLabel2.text = "Let go of the ball to shoot! The ball will travel "
        instructionLabel2.zPosition = 5
        instructionLabel2.zPosition = 20
        instructionLabel2.fontColor = SKColor.white
        
        let instructionLabel3 = SKLabelNode(fontNamed: "The Bold Font")
        instructionLabel3.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        instructionLabel3.position = CGPoint( x: self.size.width * 0.5, y: self.size.height * 0.18)
        instructionLabel3.text = "along the direction of the dotted line "
        instructionLabel3.zPosition = 5
        instructionLabel3.zPosition = 20
        instructionLabel3.fontColor = SKColor.white
        let fadeIn = SKAction.fadeAlpha(by: -0.7, duration: 0.5)
        let fadeOut = SKAction.fadeAlpha(by: 0.7, duration: 0.5)
        let fadeOutSeq = SKAction.sequence([fadeIn, fadeOut])
        instructionLabel.run(SKAction.repeatForever(fadeOutSeq))
        
        delay(5.1){
            instructionLabel.alpha = 1
            instructionLabel.removeFromParent()
            self.addChild(instructionLabel2)
            self.addChild(instructionLabel3)
            instructionLabel3.run(SKAction.repeatForever(fadeOutSeq))
            instructionLabel2.run(SKAction.repeatForever(fadeOutSeq))
            
        }
        
        
        
        let moveHandLeft = SKAction.moveTo(x: self.size.width*0.3, duration: 1.7)
        let moveHandRight = SKAction.moveTo(x: self.size.width*0.70, duration: 3.4)
        let moveHandMiddle = SKAction.moveTo(x: self.size.width*0.51, duration: 1.7)
        //let moveHandBack = SKAction.moveTo(y: self.size.height*0.18, duration: 1.1)
        // let moveHandFront = SKAction.moveTo(y: self.size.height*0.22, duration: 0.7)
        let changehand = SKAction.fadeAlpha(by: -0.7, duration: 0.5)
        let changehand2 = SKAction.fadeAlpha(by: 0.7, duration: 0.1)
        
        let moveHandSequence = SKAction.sequence([changehand2, moveHandLeft, moveHandRight, moveHandMiddle,changehand])
        hand.run(moveHandSequence)
        
        
        let ball = SKSpriteNode(imageNamed: "lightGrayBlueBall")
        ball.setScale(0.35)
        ball.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.30)
        ball.zPosition = 5
        self.addChild(ball)
        
        
        let moveBall = SKAction.moveTo(y: self.size.height*0.77, duration: 1.2)
        let takeYourTime = SKAction.moveTo(y: self.size.height*0.30, duration: 7.0)
        //let moveBack = SKAction.moveTo(y: self.size.height*0.22, duration: 1.1)//
        let moveBallSeq = SKAction.sequence([takeYourTime, moveBall])
        ball.run(moveBallSeq)
        
        
        let dashedLine = SKSpriteNode(imageNamed: "dashedline")
        dashedLine.setScale(0.5)
        dashedLine.position = ball.position
        dashedLine.anchorPoint = CGPoint(x: 0.5, y: 0)
        // dashedLine.position.y = hand.position.y + dashedLine.size.height / 2
        dashedLine.zPosition = 200
        dashedLine.alpha = 1
        self.addChild(dashedLine)
        
        
        let moveDashedLineLeft = SKAction.rotate(byAngle: -3.14/2.0, duration: 1.8)
        let moveDashedLineRight = SKAction.rotate(byAngle: 3.14, duration: 3.4)
        let moveDashedLineMiddle = SKAction.rotate(byAngle: -3.14/2.0, duration: 1.75)
        //let moveDashedLineBack = SKAction.moveTo(y: self.size.height*0.22, duration: 0.3)
        let delete = SKAction.hide()
        let moveDashedLineSeq = SKAction.sequence([moveDashedLineLeft,moveDashedLineRight,moveDashedLineMiddle,delete])
        dashedLine.run(moveDashedLineSeq)
        
        
        let Deffender = SKSpriteNode(imageNamed: "Line")
        Deffender.setScale(2)
        Deffender.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.5)
        Deffender.zPosition = 3
        self.addChild(Deffender)
        
        
        let moveDeffenderLeft = SKAction.moveTo(x: self.size.width*0.35, duration: 2.0)
        let moveDeffenderRight = SKAction.moveTo(x: self.size.width*0.65, duration: 3.5)
        let moveDeffenderSeq = SKAction.sequence([moveDeffenderLeft, moveDeffenderRight,moveDeffenderLeft,moveDeffenderLeft,moveDeffenderRight,moveDeffenderLeft,moveDeffenderLeft,moveDeffenderRight])
        
        
        Deffender.run(moveDeffenderSeq)
        
        
        
        
        
        
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
                let sceneToMoveTo = MainMenuScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
            }
            
            
            if nodeITapped.name == "Next"
            {
                let sceneToMoveTo = HowToFeatures(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
            }
            
            
        }
        
        
    }
}

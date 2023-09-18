//
//  NewLevelScene.swift
//  GOALZ
//
//  Created by Carter Stambaugh on 7/15/19.
//  Copyright © 2019 Carter Stambaugh. All rights reserved.
//
import Foundation
import SpriteKit

class NewLevelScene : SKScene {
    
     let transitionBackground = SKSpriteNode(imageNamed: "MainMenuBackground")
    
    
    override func didMove(to view: SKView){
        
        
        
        
        let LevelLabel = SKLabelNode(fontNamed: "The Bold Font")
        LevelLabel.text = "Level"
        LevelLabel.fontSize = 160
        LevelLabel.fontColor = SKColor.white
        LevelLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        LevelLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.5)
        LevelLabel.zPosition = 1
        LevelLabel.alpha = 0
        self.addChild(LevelLabel)
        
        
        
        
        let firstArena = SKLabelNode(fontNamed: "The Bold Font")
        firstArena.text = "Level"
        firstArena.fontColor = SKColor.white
        firstArena.fontSize = 135
        firstArena.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.8)
        firstArena.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        firstArena.zPosition = 3
        firstArena.isHidden = true
        self.addChild(firstArena)
        
        
        let firstArena2 = SKLabelNode(fontNamed: "The Bold Font")
        firstArena2.text = "Arena"
        firstArena2.fontColor = SKColor.white
        firstArena2.fontSize = 135
        firstArena2.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.7)
        firstArena2.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        firstArena2.zPosition = 3
        firstArena2.isHidden = true
        self.addChild(firstArena2)
        
        
        
        
        
        
        let Arena = SKLabelNode(fontNamed: "The Bold Font")
        Arena.text = "Water Arena"
        Arena.fontColor = SKColor.white
        Arena.fontSize = 135
        Arena.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        Arena.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.8)
        Arena.zPosition = 3
        Arena.isHidden = true
        self.addChild(Arena)
        
        
        
        
        let FireArena = SKLabelNode(fontNamed: "The Bold Font")
        FireArena.text = "Fire Arena"
        FireArena.fontColor = SKColor.white
        FireArena.fontSize = 135
        FireArena.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        FireArena.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.8)
        FireArena.zPosition = 3
        FireArena.isHidden = true
        self.addChild(FireArena)
    
       /* let waterBackground = SKSpriteNode(imageNamed: "WaterBackground")
        waterBackground.size = self.size
        waterBackground.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.5)
        waterBackground.zPosition = -1
        waterBackground.alpha = 0.5
        waterBackground.isHidden = true
        self.addChild(waterBackground)
        */
        
        let numLabel = SKLabelNode(fontNamed: "The Bold Font")
        numLabel.text = "\(gameLevel)"
        numLabel.fontSize = 260
        numLabel.fontColor = SKColor.white
        numLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        numLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.35)
        numLabel.zPosition = 1
        numLabel.alpha = 0
        //numLabel.run(SKAction.rotate(byAngle: -1.400, duration: 0.1))
        self.addChild(numLabel)
        
        
        transitionBackground.size = self.size
        transitionBackground.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.5)
        transitionBackground.zPosition = -1
        self.addChild(transitionBackground)
        
        let fadeInLevel = SKAction.fadeIn(withDuration: 0.3)
        let fadeInNum = SKAction.fadeIn(withDuration: 0.3)
        //let rotateNum = SKAction.rotate(byAngle: 1.400, duration: 0.6)
        LevelLabel.run(fadeInLevel)
        delay(0.3){
            numLabel.run(fadeInNum)
            //numLabel.run(rotateNum)
        }
        let newScene = GameScene(size: self.size)
        newScene.scaleMode = self.scaleMode
        
        let sceneTransition = SKTransition.fade(withDuration: 0.3)
        delay(0.8){
            self.view!.presentScene(newScene, transition: sceneTransition)
        }
        
        if (arenaNum == 1){
            firstArena.isHidden = false
            firstArena2.isHidden = false            //LevelLabel.position = CGPoint(x: self.size.width*0.55, y: self.size.height*0.)
            //numLabel.fontSize = 160
            //numLabel.position = CGPoint(x: self.size.width*0.65, y: self.size.height*0.85)
        }
        
        if (arenaNum == 2){
            Arena.isHidden = false
           // waterBackground.isHidden = false
            transitionBackground.texture = SKTexture(imageNamed: "WaterBackground")
            LevelLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.6)
            numLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.45)
        }
        
        if (arenaNum == 3){
            
            FireArena.isHidden = false
    
            LevelLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.6)
        
            numLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.45)
            
    
        }
    
    }
    

    func delay(_ delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
}

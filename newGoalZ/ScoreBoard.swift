//
//  ScoreBoard.swift
//  GOALZ
//
//  Created by Carter Stambaugh on 7/15/19.
//  Copyright © 2019 Carter Stambaugh. All rights reserved.
//


import Foundation
import SpriteKit
import AVFoundation

class ScoreBoard: SKScene {
    
    let scoreLabel = SKLabelNode(fontNamed: "The Bold Font")
   
 
    let arena_1_label = SKLabelNode(fontNamed: "The Bold Font")
    let arena_2_label = SKLabelNode(fontNamed: "The Bold Font")
    let arena_3_label = SKLabelNode(fontNamed: "The Bold Font")
    let arena_4_label = SKLabelNode(fontNamed: "The Bold Font")
    let arena_5_label = SKLabelNode(fontNamed: "The Bold Font")
    let arena_6_label = SKLabelNode(fontNamed: "The Bold Font")
    
    
    let arena1 = SKSpriteNode(imageNamed: "arena_1_unlocked")
    let arena2 = SKSpriteNode(imageNamed: "arena_2_locked")
    let arena3 = SKSpriteNode(imageNamed: "arena_3_locked")
    let arena4 = SKSpriteNode(imageNamed: "arena_4_locked")
    let arena5 = SKSpriteNode(imageNamed: "arena_5_locked")
    let arena6 = SKSpriteNode(imageNamed: "arena_6_locked")
    
    
    
    override func didMove(to view: SKView) {
        
        let back1 = SKSpriteNode(imageNamed: "back-1")
        back1.setScale(1)
        back1.position = CGPoint(x: self.size.width*0.25, y: self.size.height*0.85)
        back1.alpha = 0.2
        back1.zPosition = 1
        self.addChild(back1)
       
        let back = SKSpriteNode(imageNamed: "exit")
        back.setScale(1)
        back.position = CGPoint(x: self.size.width * 0.25, y: self.size.height*0.92)
        back.zPosition = 1
        back.name = "back"
        self.addChild(back)
        
        let label = SKSpriteNode(imageNamed: "Achievments")
        label.setScale(0.85)
        label.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.85)
        label.zPosition = 1
        self.addChild(label)
        
        let next = SKSpriteNode(imageNamed: "next")
        next.setScale(1)
        next.alpha = 0.3
        next.position = CGPoint(x: self.size.width*0.75, y: self.size.height*0.85)
        next.zPosition = 3
        self.addChild(next)
        
        let background = SKSpriteNode(imageNamed: "MainMenuBackground")
        background.size = self.size
        background.zPosition = -1
        background.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.5)
        self.addChild(background)
        
        
     
        arena1.setScale(0.7)
        arena1.position = CGPoint(x: self.size.width*0.3, y: self.size.height*0.49)
        arena1.zPosition = 1
        self.addChild(arena1)
        
      
        arena2.setScale(0.7)
        arena2.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.49)
        arena2.zPosition = 1
        self.addChild(arena2)
        
        
        arena3.setScale(0.7)
        arena3.position = CGPoint(x: self.size.width*0.7, y: self.size.height*0.49)
        arena3.zPosition = 1
        self.addChild(arena3)
        
        
        arena4.setScale(0.7)
        arena4.position = CGPoint(x: self.size.width*0.3, y: self.size.height*0.16)
        arena4.zPosition = 1
        self.addChild(arena4)
        
      
        arena5.setScale(0.7)
        arena5.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.16)
        arena5.zPosition = 1
        self.addChild(arena5)
        
       
        arena6.setScale(0.7)
        arena6.position = CGPoint(x: self.size.width*0.7, y: self.size.height*0.16)
        arena6.zPosition = 1
        self.addChild(arena6)
        
        scoreLabel.fontSize = 100
        scoreLabel.fontColor = SKColor.white
        scoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.75)
        scoreLabel.zPosition = 3
        self.addChild(scoreLabel)
        
        let defaults = UserDefaults()
        var highScoreNumber = defaults.integer(forKey: "highScoreSaved")
        if gameLevel > highScoreNumber{
            highScoreNumber = gameLevel
            defaults.set(highScoreNumber, forKey: "highScoreSaved")
        }
      //  let defaults = UserDefaults()
      //  var highScoreNumber = defaults.integer(forKey: "highScoreSaved")
       // if gameLevel > highScoreNumber{
       //     highScoreNumber = gameLevel
      //      defaults.set(highScoreNumber, forKey: "highScoreSaved")
      //  }
         let highScoreLabel = SKLabelNode(fontNamed: "The Bold Font")
        highScoreLabel.text = "High Score: \(highScoreNumber)"
        highScoreLabel.fontSize = 125
        highScoreLabel.color = SKColor.yellow
        highScoreLabel.zPosition = 3
        highScoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.7)
        self.addChild(highScoreLabel)
       
        
        if (highScoreNumber > 25) {
            arena2.texture = SKTexture(imageNamed: "arena_2_unlocked")
        }
        
        if (highScoreNumber > 50 ) {
            arena3.texture = SKTexture(imageNamed: "arena_3_unlocked")
        }
      
       
       /* arena_1_label.text = "Arena 1"
        arena_1_label.fontSize = 35
        arena_1_label.color = SKColor.white
        arena_1_label.zPosition = 3
        arena_1_label.position = CGPoint(x: self.arena1.position.x, y: self.arena1.position.y + (self.arena1.position.y/3))
        self.addChild(arena_1_label)
        
        arena_2_label.text = "Aqua Arena"
        arena_2_label.fontSize = 35
        arena_2_label.color = SKColor.white
        arena_2_label.zPosition = 3
        arena_2_label.position = CGPoint(x: self.arena2.position.x, y: self.arena2.position.y + (self.arena2.position.y/3))
        self.addChild(arena_2_label)
        
        arena_3_label.text = "Fire Arena"
        arena_3_label.fontSize = 35
        arena_3_label.color = SKColor.white
        arena_3_label.zPosition = 3
        arena_3_label.position = CGPoint(x: self.arena3.position.x, y: self.arena3.position.y + (self.arena3.position.y/3))
        self.addChild(arena_3_label)
        
        arena_4_label.text = "Space Arena"
        arena_4_label.fontSize = 35
        arena_4_label.color = SKColor.white
        arena_4_label.zPosition = 5
        arena_4_label.position = CGPoint(x: self.arena4.position.x, y: self.arena4.position.y + (self.arena4.position.y))
        self.addChild(arena_4_label)
        
        arena_5_label.text = "Coming Soon"
        arena_5_label.fontSize = 35
        arena_5_label.color = SKColor.white
        arena_5_label.zPosition = 5
        arena_5_label.position = CGPoint(x: self.arena5.position.x, y: self.arena5.position.y + (self.arena5.position.y))
        self.addChild(arena_5_label)
        
        arena_6_label.text = "Comming Soon"
        arena_6_label.fontSize = 35
        arena_6_label.color = SKColor.white
        arena_6_label.zPosition = 5
        arena_6_label.position = CGPoint(x: self.arena6.position.x, y: self.arena6.position.y + (self.arena6.position.y))
        self.addChild(arena_6_label)
        
        */
        
        
        
        
        
        
        
        
        
        
        
        

    }
    
  /*  func incrementLabel(to endValue: Int) {
        
        
       
        
        var duration: Double = 0.0
        if (gameLevel == 2){
            duration = 0.2
        }
        else if (gameLevel == 3){
            duration = 0.3
        }
        else if (gameLevel == 4){
            duration = 0.35
        }
        else if (gameLevel <= 10){
            duration = 0.5
        }
        else if (gameLevel <= 25){
            duration = 0.7
        }
        else if (gameLevel <= 35){
            duration = 0.9
        }
        
        //let duration: Double = 0.5 //seconds
        DispatchQueue.global().async {
            for i in 0 ..< (endValue + 1) {
                let sleepTime = UInt32(duration/Double(endValue) * 1000000.0)
                usleep(sleepTime)
                DispatchQueue.main.async {
                    self.highScoreLabel.text = "Score: \(i)"
                }
            }
        }
        
        
        
    }*/
   
    
    
    
    
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
            
            
            
            
        }
    }
}

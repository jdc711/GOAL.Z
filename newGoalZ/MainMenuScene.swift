//
//  MainMenuScene.swift
//  GOALZ
//
//  Created by Carter Stambaugh on 7/15/19.
//  Copyright © 2019 Carter Stambaugh. All rights reserved.
//
//
import Foundation
import SpriteKit
import AVFoundation
import CoreGraphics



//var backingAudio = AVAudioPlayer()
let defaults = UserDefaults()

var playedBefore = defaults.bool(forKey: "playedBefore")
var sound: Bool = true
var currentGameState: gameState = gameState.beforeGame
 var backingAudio : AVAudioPlayer?

class MainMenuScene: SKScene, SKPhysicsContactDelegate {
    
    var coins = defaults.integer(forKey: "coinsSaved")
    var firePowerUps = defaults.integer(forKey: "firePowerUps")
    
    let startButton = SKLabelNode(fontNamed: "The Bold Font")
    let Ball = SKSpriteNode(imageNamed: "green ball")
    let noSound = SKSpriteNode(imageNamed: "noSound")
    
    //var backingAudio : AVAudioPlayer?
       
   
       private func initializePlayer() -> AVAudioPlayer? {
              guard let path = Bundle.main.path(forResource: "goalzMAINMENU", ofType: "wav") else {
                  return nil
              }

              return try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
          }
    
    
    
    override func didMove(to view: SKView){
        
        coins = defaults.integer(forKey: "coinsSaved")
        
        currentGameState = gameState.beforeGame
        let coinPic = SKSpriteNode(imageNamed: "Coin")
        coinPic.setScale(0.3)
        coinPic.position = CGPoint(x: self.size.width*0.25, y: self.size.height*0.90)
        coinPic.zPosition = 10
        self.addChild(coinPic)
        
        
        let created = SKSpriteNode(imageNamed: "Created")
        created.setScale(0.7)
        created.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.05)
        created.zPosition = 2
        created.alpha = 1.0
        self.addChild(created)
        
        
        //let coinsNum = SKLabelNode(fontNamed: "The Bold Font")
        coinsNum.text = " \(coins)"
        coinsNum.fontSize = 60
        coinsNum.color = SKColor.coinNumber
        coinsNum.zPosition = 1
        coinsNum.alpha = 1
        coinsNum.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        coinsNum.position =  CGPoint(x: self.size.width*0.285, y: self.size.height*0.889)
        self.addChild(coinsNum)
        
       backingAudio = initializePlayer()
               backingAudio?.numberOfLoops = -1
               backingAudio?.play()
        
        if sound == false{
            backingAudio?.stop()
        }
        
        
        physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -3)
        let background = SKSpriteNode(imageNamed: "MainMenuBackground")
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        let homeBall = SKSpriteNode(imageNamed: "homeBall")
        homeBall.setScale(0.35)
        homeBall.alpha = 3
        homeBall.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.57)
        self.addChild(homeBall)
        
        
        
        let title = SKLabelNode(fontNamed: "The Bold Font")
        title.fontSize = 130
        title.text = "Goalz"
        title.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.78)
        title.zPosition = 1
        self.addChild(title)
        
    
        let noAdds = SKSpriteNode(imageNamed: "ThumbsUp")
        noAdds.setScale(0.9)
        noAdds.position = CGPoint(x: self.size.width*0.7, y:self.size.height*0.25)
        noAdds.zPosition = 1
        noAdds.name = "NoAdds"
        self.addChild(noAdds)
        
        
        let moreBall = SKSpriteNode(imageNamed: "MoreBall")
        moreBall.setScale(0.85)
        moreBall.position = CGPoint(x: self.size.width*0.56, y:self.size.height*0.25)
        moreBall.zPosition = 1
        moreBall.name = "moreBall"
        self.addChild(moreBall)
        
        
        
        
        startButton.fontSize = 110
        startButton.name = "startButton"
        startButton.fontColor = SKColor.white
        startButton.text = "Tap to Begin"
        startButton.position = CGPoint(x: self.size.width*0.50, y:self.size.height*0.38)
        startButton.zPosition = 101
        self.addChild(startButton)
        
        
        let fadeIn = SKAction.fadeIn(withDuration: 0.8)
        let fadeOut = SKAction.fadeOut(withDuration: 0.8)
        
        
        
        
        startButton.run(SKAction.repeatForever(SKAction.sequence([fadeIn, fadeOut])))
        
        
        if sound == false{
            noSound.texture = SKTexture(imageNamed: "PlayMusic")
        }
        
        
        noSound.setScale(0.8)
        noSound.name = "mute"
        noSound.position = CGPoint(x: self.size.width*0.30, y: self.size.height*0.25)
        noSound.zPosition = 1
        
        
        self.addChild(noSound)
        
        
        let scoreBoard = SKSpriteNode(imageNamed: "scoreboard")
        scoreBoard.setScale(0.8)
        scoreBoard.position = CGPoint(x: self.size.width*0.43, y: self.size.height*0.25)
        scoreBoard.zPosition = 1
        scoreBoard.name = "scoreBoard"
        self.addChild(scoreBoard)
        
        
        let mainMenuGoal = SKSpriteNode(imageNamed: "Goal")
        mainMenuGoal.setScale(2.5)
        mainMenuGoal.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.7)
        mainMenuGoal.zPosition = 1
        self.addChild(mainMenuGoal)
        
        
        let info = SKSpriteNode(imageNamed: "info")
        info.setScale(0.35)
        info.position = CGPoint(x: self.size.width*0.75, y: self.size.height*0.905)
        info.zPosition = 1
        info.name = "info"
        self.addChild(info)
        
        
        //gameTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        //gameTableView.isHidden = true
        // view.addSubview(gameTableView)
        // gameTableView.reloadData()
        
        
    }
    
    
    
    
    
    
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
    
    
    // var gameTableView = GameRoomTableView()
    private var label : SKLabelNode?
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        for touch: AnyObject in touches{
            
            
            let pointOfTouch = touch.location(in: self)
            let nodeITapped = atPoint(pointOfTouch)
            
            
            if nodeITapped.name == "startButton"
            {
                
                coinsNum.removeFromParent()
              //  backingAudio.stop()
                if (!playedBefore){
                    let sceneToMoveTo = HowToPlay(size: self.size)
                    sceneToMoveTo.scaleMode = self.scaleMode
                    let myTransition = SKTransition.doorsOpenHorizontal(withDuration: 1.0)
                    self.view!.presentScene(sceneToMoveTo, transition: myTransition)
                }
                    
                    
                    
                    
                else{
                    
                    let sceneToMoveTo = NewLevelScene(size: self.size)
                    sceneToMoveTo.scaleMode = self.scaleMode
                    let myTransition = SKTransition.doorsOpenHorizontal(withDuration: 0.8)
                    self.view!.presentScene(sceneToMoveTo, transition: myTransition)
                }
                
                
            }
            
            
            if nodeITapped.name == "info"
            {
                coinsNum.removeFromParent()
                
                let sceneToMoveTo = HowToPlay(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
            }
            if nodeITapped.name == "NoAdds"
            {
                let va = self.view?.window?.rootViewController
                
                
                let urlString = NSURL(string: "https://apps.apple.com/us/app/GOAL.Z/id1473082797")
                let object = [urlString]
                
                
                let activityVC:UIActivityViewController = UIActivityViewController(activityItems: object as [Any], applicationActivities: nil)
                
                
                va?.present(activityVC, animated: true, completion: nil)
                
                
                
             
                
            }
            
            
            if nodeITapped.name == "moreBall"
            {
                
                coinsNum.removeFromParent()
                
                self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
                if let label = self.label {
                    label.alpha = 0.0
                    label.run(SKAction.fadeIn(withDuration: 2.0))
                }
                let sceneToMoveTo = CoinStore(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
                
                
                //  gameTableView.isHidden = false
                // Table setup
                
                
            }
            
            
            if nodeITapped.name == "scoreBoard"
            {
                coinsNum.removeFromParent()
                
                let sceneToMoveTo = ScoreBoard(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
                
                
            }
            
            
            
            
            if nodeITapped.name == "mute"
            {
                if sound == false{
                    sound = true
                  backingAudio?.play()
                    
                    
                    
                    
                    
                    
                    
                    
                    noSound.texture = SKTexture(imageNamed: "noSound")
                }
                else{
                    sound = false
                    backingAudio?.pause()
                    noSound.texture = SKTexture(imageNamed: "PlayMusic")
                }
            }
            
            
            
            
        }
    }
}

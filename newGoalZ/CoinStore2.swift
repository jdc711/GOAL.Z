//
//  CoinStore2.swift
//  GOALZ
//
//  Created by Carter Stambaugh on 7/31/19.
//  Copyright © 2019 Carter Stambaugh. All rights reserved.
//

import Foundation
import SpriteKit
import StoreKit
import CoreGraphics


var purchased_ball_13 = defaults.bool(forKey: "purchased_ball_13")
var purchased_ball_14 = defaults.bool(forKey: "purchased_ball_14")
var purchased_ball_15 = defaults.bool(forKey: "purchased_ball_15")
var purchased_ball_16 = defaults.bool(forKey: "purchased_ball_16")
var purchased_ball_17 = defaults.bool(forKey: "purchased_ball_17")
var purchased_ball_18 = defaults.bool(forKey: "purchased_ball_18")
var purchased_ball_19 = defaults.bool(forKey: "purchased_ball_19")
var purchased_ball_20 = defaults.bool(forKey: "purchased_ball_20")
var purchased_ball_21 = defaults.bool(forKey: "purchased_ball_21")
var purchased_ball_22 = defaults.bool(forKey: "purchased_ball_22")
var purchased_ball_23 = defaults.bool(forKey: "purchased_ball_23")
var purchased_ball_24 = defaults.bool(forKey: "purchased_ball_24")
var purchased_ball_25 = defaults.bool(forKey: "purchased_ball_25")
var purchased_ball_26 = defaults.bool(forKey: "purchased_ball_26")
var purchased_ball_27 = defaults.bool(forKey: "purchased_ball_27")
var purchased_ball_28 = defaults.bool(forKey: "purchased_ball_28")
var purchased_ball_29 = defaults.bool(forKey: "purchased_ball_29")
var purchased_ball_30 = defaults.bool(forKey: "purchased_ball_30")

class CoinStore2: SKScene, SKPaymentTransactionObserver {
    
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        
        
        
        for transaction in transactions{
            
            
            
            
            if transaction.transactionState == .purchased{
                
                
                
                
                print ("Transaction successful!")
                SKPaymentQueue.default().finishTransaction(transaction)
            }
            else if transaction.transactionState == .failed{
                
                
                
                
                if let error = transaction.error{
                    let errorDescription = error.localizedDescription
                    print ("Transaction failed!: \(errorDescription)")
                    
                    
                    
                    
                    
                    
                    
                    
                }
                SKPaymentQueue.default().finishTransaction(transaction)
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    let currentball = SKSpriteNode(imageNamed: "currentBall")
    var coins = defaults.integer(forKey: "coinsSaved")
    var firePowerUps = defaults.integer(forKey: "firePowerUps")
    
    
    let coinsNum = SKLabelNode(fontNamed: "The Bold Font")
    let coinPic = SKSpriteNode(imageNamed: "Coin")
    let coinLabel = SKSpriteNode(imageNamed: "CoinLabel")
    let ballSkins = SKSpriteNode(imageNamed: "BallSkins")
    let powerPic = SKSpriteNode(imageNamed: "firePowerUp")
    let powerNum = SKLabelNode(fontNamed: "The Bold Font")
    
    
    let circle_frame_1 = SKSpriteNode(imageNamed: "BlueBall")
    let circle_frame_2 = SKSpriteNode(imageNamed: "BlueBall")
    let circle_frame_3 = SKSpriteNode(imageNamed: "BlueBall")
    
    
    
    
    
    
    
    
    
    
    let ball_13 = GameConstants.StringConstant.ball_13
    let ball_14 = GameConstants.StringConstant.ball_14
    let ball_15 = GameConstants.StringConstant.ball_15
    let ball_16 = GameConstants.StringConstant.ball_16
    let ball_17 = GameConstants.StringConstant.ball_17
    let ball_18 = GameConstants.StringConstant.ball_18
    let ball_19 = GameConstants.StringConstant.ball_19
    let ball_20 = GameConstants.StringConstant.ball_20
    let ball_21 = GameConstants.StringConstant.ball_21
    let ball_22 = GameConstants.StringConstant.ball_22
    let ball_23 = GameConstants.StringConstant.ball_23
    let ball_24 = GameConstants.StringConstant.ball_24
    let ball_25 = GameConstants.StringConstant.ball_25
    let ball_26 = GameConstants.StringConstant.ball_26
    let ball_27 = GameConstants.StringConstant.ball_27
    let ball_28 = GameConstants.StringConstant.ball_28
    let ball_29 = GameConstants.StringConstant.ball_29
    let ball_30 = GameConstants.StringConstant.ball_30
    
    
    
    
    var previousCoins = defaults.integer(forKey: "coinsSaved")
    var currentAddFireUp = defaults.integer(forKey: "AddFire")
    
    
    func incrementLabel(to endValue: Int) {
        let duration: Double = 1.3
        
        
        //let duration: Double = 0.5 //seconds
        DispatchQueue.global().async {
            for i in 0 ..< (endValue + 1) {
                let sleepTime = UInt32(duration/Double(endValue) * 1000000.0)
                usleep(sleepTime)
                DispatchQueue.main.async {
                    self.coinsNum.text = " \(i + self.previousCoins)"
                }
            }
        }
    }
    
    
    func decrementLabel(to endValue: Int) {
        let duration: Double = 1.3
        
        
        //let duration: Double = 0.5 //seconds
        DispatchQueue.global().async {
            for i in (0 ..< (endValue + 1)) {
                let sleepTime = UInt32(duration/Double(endValue) * 1000000.0)
                usleep(sleepTime)
                DispatchQueue.main.async {
                    self.coinsNum.text = " \(self.previousCoins - i)"
                }
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    override func didMove(to view: SKView) {
        
        
        coins = defaults.integer(forKey: "coinsSaved")
        
        self.addChild(currentball)
        
        
        if (purchased_ball_13){
            ball_13.texture = SKTexture(imageNamed: "ball_13_unlock")
        }
        if (purchased_ball_14){
            ball_14.texture = SKTexture(imageNamed: "ball_14_unlock")
        }
        if (purchased_ball_15){
            ball_15.texture = SKTexture(imageNamed: "ball_15_unlock")
        }
        if (purchased_ball_16){
            ball_16.texture = SKTexture(imageNamed: "ball_16_unlock")
        }
        if (purchased_ball_17){
            ball_17.texture = SKTexture(imageNamed: "ball_17_unlock")
        }
        if (purchased_ball_18){
            ball_18.texture = SKTexture(imageNamed: "ball_18_unlock")
        }
        if (purchased_ball_19){
            ball_19.texture = SKTexture(imageNamed: "ball_19_unlock")
        }
        if (purchased_ball_20){
            ball_20.texture = SKTexture(imageNamed: "ball_20_unlock")
        }
        if (purchased_ball_21){
            ball_21.texture = SKTexture(imageNamed: "ball_21_unlock")
        }
        if (purchased_ball_22){
            ball_22.texture = SKTexture(imageNamed: "ball_22_unlock")
        }
        if (purchased_ball_23){
            ball_23.texture = SKTexture(imageNamed: "ball_23_unlock")
        }
        if (purchased_ball_24){
            ball_24.texture = SKTexture(imageNamed: "ball_24_unlock")
        }
        if (purchased_ball_25){
            ball_25.texture = SKTexture(imageNamed: "ball_25_unlock")
        }
        if (purchased_ball_26){
            ball_26.texture = SKTexture(imageNamed: "ball_26_unlock")
        }
        if (purchased_ball_27){
            ball_27.texture = SKTexture(imageNamed: "ball_27_unlock")
        }
        if (purchased_ball_28){
            ball_28.texture = SKTexture(imageNamed: "ball_28_unlock")
            CoinDustEmitter()
        }
        if (purchased_ball_29){
            ball_29.texture = SKTexture(imageNamed: "ball_28_unlock")
            Coin_29_Emitter()
        }
        if (purchased_ball_30){
            ball_30.texture = SKTexture(imageNamed: "ball_28_unlock")
            Coin_30_Emitter()
        }
        
        
        
        
        SKPaymentQueue.default().add(self)
        
        
        
        
        let background = SKSpriteNode(imageNamed: "MainMenuBackground")
        background.size = self.size
        background.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.5)
        background.zPosition = -1
        self.addChild(background)
        
        
        
        
        
        
        
        
        let shop = SKSpriteNode(imageNamed: "shop")
        shop.setScale(2)
        shop.position = CGPoint(x: self.size.width * 0.5, y: self.size.height*0.855)
        shop.zPosition = 1
        self.addChild(shop)
        
        
        
        
        let back1 = SKSpriteNode(imageNamed: "back-1")
        back1.setScale(1)
        back1.position = CGPoint(x: self.size.width*0.25, y: self.size.height*0.85)
        back1.alpha = 1
        back1.zPosition = 1
        back1.name = "back-1"
        self.addChild(back1)
        
        
        let next = SKSpriteNode(imageNamed: "next")
        next.setScale(1)
        next.alpha = 0.2
        next.position = CGPoint(x: self.size.width*0.75, y: self.size.height*0.85)
        next.zPosition = 3
        next.name = "next"
        self.addChild(next)
        
        
        ball_13.setScale(0.7)
        ball_13.position = CGPoint(x: self.size.width*0.3, y: self.size.height*0.70)
        ball_13.zPosition = 1
        ball_13.name = "ball_13"
        self.addChild(ball_13)
        
        
        ball_14.setScale(0.7)
        ball_14.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.70)
        ball_14.zPosition = 1
        ball_14.name = "ball_14"
        self.addChild(ball_14)
        
        
        ball_15.setScale(0.7)
        ball_15.position = CGPoint(x: self.size.width*0.7, y: self.size.height*0.70)
        ball_15.zPosition = 1
        ball_15.name = "ball_15"
        self.addChild(ball_15)
        
        
        ball_16.setScale(0.7)
        ball_16.position = CGPoint(x: self.size.width*0.3, y: self.size.height*0.58)
        ball_16.zPosition = 1
        ball_16.name = "ball_16"
        self.addChild(ball_16)
        
        
        ball_17.setScale(0.7)
        ball_17.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.58)
        ball_17.zPosition = 1
        ball_17.name = "ball_17"
        self.addChild(ball_17)
        
        
        
        
        
        
        
        
        ball_18.setScale(0.7)
        ball_18.position = CGPoint(x: self.size.width*0.7, y: self.size.height*0.58)
        ball_18.zPosition = 1
        ball_18.name = "ball_18"
        self.addChild(ball_18)
        
        
        
        
        
        
        
        
        
        
        
        
        ball_19.setScale(0.7)
        ball_19.position = CGPoint(x: self.size.width*0.3, y: self.size.height*0.46)
        ball_19.zPosition = 1
        ball_19.name = "ball_19"
        self.addChild(ball_19)
        
        
        
        
        
        
        
        
        ball_20.setScale(0.7)
        ball_20.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.46)
        ball_20.zPosition = 1
        ball_20.name = "ball_20"
        self.addChild(ball_20)
        
        
        
        
        
        
        
        
        ball_21.setScale(0.7)
        ball_21.position = CGPoint(x: self.size.width*0.7, y: self.size.height*0.46)
        ball_21.zPosition = 1
        ball_21.name = "ball_21"
        self.addChild(ball_21)
        
        
        
        
        
        
        
        
        ball_22.setScale(0.7)
        ball_22.position = CGPoint(x: self.size.width*0.3, y: self.size.height*0.34)
        ball_22.zPosition = 1
        ball_22.name = "ball_22"
        self.addChild(ball_22)
        
        
        
        
        
        
        
        
        ball_23.setScale(0.7)
        ball_23.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.34)
        ball_23.zPosition = 1
        ball_23.name = "ball_23"
        self.addChild(ball_23)
        
        
        
        
        
        ball_24.setScale(0.7)
        ball_24.position = CGPoint(x: self.size.width*0.7, y: self.size.height*0.34)
        ball_24.zPosition = 1
        ball_24.name = "ball_24"
        self.addChild(ball_24)
        
        
        
        
        
        
        
        
        ball_25.setScale(0.7)
        ball_25.position = CGPoint(x: self.size.width*0.3, y: self.size.height*0.22)
        ball_25.zPosition = 1
        ball_25.name = "ball_25"
        self.addChild(ball_25)
        
        
        
        
        
        
        
        
        ball_26.setScale(0.7)
        ball_26.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.22)
        ball_26.zPosition = 1
        ball_26.name = "ball_26"
        self.addChild(ball_26)
        
        
        
        
        
        
        
        
        ball_27.setScale(0.7)
        ball_27.position = CGPoint(x: self.size.width*0.7, y: self.size.height*0.22)
        ball_27.zPosition = 1
        ball_27.name = "ball_27"
        self.addChild(ball_27)
        
        
        
        
        
        
        
        
        ball_28.setScale(0.7)
        ball_28.position = CGPoint(x: self.size.width*0.3, y: self.size.height*0.1)
        ball_28.zPosition = 1
        ball_28.name = "ball_28"
        self.addChild(ball_28)
        
        
        
        
        
        
        
        
        
        
        ball_29.setScale(0.7)
        ball_29.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.1)
        ball_29.zPosition = 1
        ball_29.name = "ball_29"
        self.addChild(ball_29)
        
        
        
        
        
        
        
        
        
        
        ball_30.setScale(0.7)
        ball_30.position = CGPoint(x: self.size.width*0.7, y: self.size.height*0.1)
        ball_30.zPosition = 1
        ball_30.name = "ball_30"
        self.addChild(ball_30)
        
        
        if (purchased_ball_28){
            
            
            CoinDustEmitter()
        }
        if (purchased_ball_29){
            
            
            Coin_29_Emitter()
        }
        if (purchased_ball_30){
            
            
            Coin_30_Emitter()
        }
        
        
        circle_frame_1.setScale(0.7)
        circle_frame_1.position = CGPoint(x: self.ball_28.position.x, y: self.ball_28.position.y)
        circle_frame_1.name = "frame_1"
        circle_frame_1.zPosition = 5
        circle_frame_1.alpha = 0
        self.addChild(circle_frame_1)
        
        
        circle_frame_2.setScale(0.7)
        circle_frame_2.position = CGPoint(x: self.ball_29.position.x, y: self.ball_29.position.y)
        circle_frame_2.name = "frame_2"
        circle_frame_2.zPosition = 5
        circle_frame_2.alpha = 0
        self.addChild(circle_frame_2)
        
        
        circle_frame_3.setScale(0.7)
        circle_frame_3.position = CGPoint(x: self.ball_30.position.x, y: self.ball_30.position.y)
        circle_frame_3.name = "frame_3"
        circle_frame_3.zPosition = 5
        circle_frame_3.alpha = 0
        self.addChild(circle_frame_3)
        
        
        
        
        coinPic.setScale(0.4)
        coinPic.position = CGPoint(x: self.size.width*0.55, y: self.size.height*0.913)
        coinPic.zPosition = 10
        self.addChild(coinPic)
        
        
        coinsNum.text = " \(coins)"
        coinsNum.fontSize = 65
        coinsNum.color = SKColor.white
        coinsNum.zPosition = 1
        coinsNum.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        coinsNum.position =  CGPoint(x: self.size.width*0.71, y: self.size.height*0.9)
        self.addChild(coinsNum)
        
        
        powerPic.setScale(0.45)
        powerPic.position = CGPoint(x: self.size.width/2.73, y: self.size.height*0.913)
        powerPic.zPosition = 10
        self.addChild(powerPic)
        
        
        powerNum.text = " \(firePowerUps)"
        powerNum.fontSize = 65
        powerNum.color = SKColor.white
        powerNum.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        powerNum.position = CGPoint(x: self.size.width/2.0, y: self.size.height*0.9)
        self.addChild(powerNum)
        
        
        
        
        
        
        currentball.setScale(0.7)
        currentball.zPosition = 3
        //self.addChild(currentball)
        if (currentBallNumber == 13){
            currentball.position = CGPoint(x: ball_13.position.x, y: ball_13.position.y)
        }
        else if (currentBallNumber == 14){
            currentball.position = CGPoint(x: ball_14.position.x, y: ball_14.position.y)
        }
        else if (currentBallNumber == 15){
            currentball.position = CGPoint(x: ball_15.position.x, y: ball_15.position.y)
        }
        else if (currentBallNumber == 16){
            currentball.position = CGPoint(x: ball_16.position.x, y: ball_16.position.y)
        }
        else if (currentBallNumber == 17){
            currentball.position = CGPoint(x: ball_17.position.x, y: ball_17.position.y)
        }
        else if (currentBallNumber == 18){
            currentball.position = CGPoint(x: ball_18.position.x, y: ball_18.position.y)
        }
        else if (currentBallNumber == 19){
            currentball.position = CGPoint(x: ball_19.position.x, y: ball_19.position.y)
        }
        else if (currentBallNumber == 20){
            currentball.position = CGPoint(x: ball_20.position.x, y: ball_20.position.y)
        }
        else if (currentBallNumber == 21){
            currentball.position = CGPoint(x: ball_21.position.x, y: ball_21.position.y)
        }
        else if (currentBallNumber == 22){
            currentball.position = CGPoint(x: ball_22.position.x, y: ball_22.position.y)
        }
        else if (currentBallNumber == 23){
            currentball.position = CGPoint(x: ball_23.position.x, y: ball_23.position.y)
        }
        else if (currentBallNumber == 24){
            currentball.position = CGPoint(x: ball_24.position.x, y: ball_24.position.y)
        }
        else if (currentBallNumber == 25){
            currentball.position = CGPoint(x: ball_25.position.x, y: ball_25.position.y)
        }
        else if (currentBallNumber == 26){
            currentball.position = CGPoint(x: ball_26.position.x, y: ball_26.position.y)
        }
        else if (currentBallNumber == 27){
            currentball.position = CGPoint(x: ball_27.position.x, y: ball_27.position.y)
        }
        else if (currentBallNumber == 28){
            currentball.position = CGPoint(x: ball_28.position.x, y: ball_28.position.y)
        }
        else if (currentBallNumber == 29){
            currentball.position = CGPoint(x: ball_29.position.x, y: ball_29.position.y)
        }
        else if (currentBallNumber == 30){
            currentball.position = CGPoint(x: ball_30.position.x, y: ball_30.position.y)
        }
        
        
        
        
        
        
        
        
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    func spawnCoin(){
        
        
        
        
        
        
        
        
        let oneCoin = SKSpriteNode(imageNamed: "Coin")
        oneCoin.setScale(0.4)
        oneCoin.position = CGPoint(x: self.coinPic.position.x, y: self.coinPic.position.y + 200)
        oneCoin.zPosition = 20
        self.addChild(oneCoin)
        
        
        
        
        
        
        
        
        let moveCoin = SKAction.moveTo(y: self.coinPic.position.y, duration: 0.3)
        let deleteCoin = SKAction.removeFromParent()
        let coinSound = SKAction.playSoundFileNamed("coinSound.wav", waitForCompletion: true)
        let coinSeq = SKAction.sequence([moveCoin,deleteCoin,coinSound])
        oneCoin.run(coinSeq)
        
        
        
        
    }
    
    
    
    
    func failed_purchased() {
        
        
        let shake_right = SKAction.moveTo(x: self.size.width*0.72, duration: 0.1)
        let shake_left = SKAction.moveTo(x: self.size.width*0.7, duration: 0.1)
        let shake_right_repeat = SKAction.moveTo(x: self.size.width*0.72, duration: 0.1)
        let shake_left_repeat = SKAction.moveTo(x: self.size.width*0.7, duration: 0.1)
        
        
        
        
        let shake_seq = SKAction.sequence([shake_right,shake_left,shake_right_repeat,shake_left_repeat])
        coinsNum.run(shake_seq)
        
        
    }
    
    
    
    
    
    
    
    
    
    
    func deleteCoin(){
        
        
        
        
        
        
        
        
        let oneCoin = SKSpriteNode(imageNamed: "Coin")
        oneCoin.setScale(0.4)
        oneCoin.position = CGPoint(x: self.coinPic.position.x, y: self.coinPic.position.y)
        oneCoin.zPosition = 2
        self.addChild(oneCoin)
        
        
        
        
        
        
        
        
        let moveCoin = SKAction.moveTo(y: self.size.height+100, duration: 0.3)
        let deleteCoin = SKAction.removeFromParent()
        let coinSound = SKAction.playSoundFileNamed("coinSound.wav", waitForCompletion: false)
        let deleteCoinSeq = SKAction.sequence([moveCoin,deleteCoin,coinSound])
        oneCoin.run(deleteCoinSeq)
        
        
        
        
    }
    
    
    var coinbool = false
    
    
    func CoinDustEmitter() {
        
        
        coinbool = true
        if let sparky = ParticleHelper.addParticleEffect(name: GameConstants.StringConstant.ball_28_particle, particlePositionRange: CGVector(dx: 0.2, dy: 0.2), position: CGPoint(x: ball_28.position.x, y: ball_28.position.y)) {
            sparky.zPosition = 2
            sparky.setScale(0.65)
            self.addChild(sparky)
            
            
            
            
        }
        
        
        
    }
    
    
    var ball_29_bool = false
    
    
    func Coin_29_Emitter() {
        
        
        ball_29_bool = true
        
        
        if let sparky = ParticleHelper.addParticleEffect(name: GameConstants.StringConstant.ball_29_particle, particlePositionRange: CGVector(dx: 0.001, dy: 0.001), position: CGPoint(x: ball_29.position.x, y: ball_29.position.y)) {
            sparky.zPosition = 3
            sparky.setScale(0.35)
            self.addChild(sparky)
            
            
        }
        
        
    }
    
    
    var ball_30_bool = false
    
    
    func Coin_30_Emitter() {
        
        
        ball_30_bool = true
        if let sparky = ParticleHelper.addParticleEffect(name: GameConstants.StringConstant.ball_30_particle, particlePositionRange: CGVector(dx: 0.08, dy: 0.08), position: CGPoint(x: ball_30.position.x, y: ball_30.position.y)) {
            sparky.zPosition = 2
            sparky.setScale(0.65)
            self.addChild(sparky)
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
            
            
            
            
            
            
            
            
            
            
            
            
            if nodeITapped.name == "5Coins"
            {
                
                
                spawnCoin()
                coins += 1
                coinsNum.text = " \(coins)"
                delay(0.05){
                    self.spawnCoin()
                    self.coins += 1
                    self.coinsNum.text = " \(self.coins)"
                }
                delay(0.1){
                    self.spawnCoin()
                    self.coins += 1
                    self.coinsNum.text = " \(self.coins)"
                }
                delay(0.15){
                    self.spawnCoin()
                    self.coins += 1
                    self.coinsNum.text = " \(self.coins)"
                }
                delay(0.2){
                    self.spawnCoin()
                    self.coins += 1
                    self.coinsNum.text = " \(self.coins)"
                }
                
                
                
                
                
                
                
                
                
                
                
                
            }
            if nodeITapped.name == "25Coins"
            {
                spawnCoin()
                
                
                
                
                coins += 1
                coinsNum.text = " \(coins)"
                delay(0.05){
                    self.spawnCoin()
                    self.coins += 1
                    self.coinsNum.text = " \(self.coins)"
                }
                delay(0.1){
                    self.spawnCoin()
                    self.coins += 1
                    self.coinsNum.text = " \(self.coins)"
                }
                delay(0.15){
                    self.spawnCoin()
                    self.coins += 1
                    self.coinsNum.text = " \(self.coins)"
                }
                delay(0.2){
                    self.spawnCoin()
                    self.coins += 1
                    self.coinsNum.text = " \(self.coins)"
                }
                delay(0.25){
                    self.spawnCoin()
                    self.coins += 1
                    self.coinsNum.text = " \(self.coins)"
                }
                delay(0.3){
                    self.spawnCoin()
                    self.coins += 1
                    self.coinsNum.text = " \(self.coins)"
                }
                delay(0.35){
                    self.spawnCoin()
                    self.coins += 1
                    self.coinsNum.text = " \(self.coins)"
                }
                delay(0.4){
                    self.spawnCoin()
                    self.coins += 1
                    self.coinsNum.text = " \(self.coins)"
                }
                delay(0.45){
                    self.spawnCoin()
                    self.coins += 1
                    self.coinsNum.text = " \(self.coins)"
                }
                delay(0.5){
                    self.spawnCoin()
                    self.coins += 1
                    self.coinsNum.text = " \(self.coins)"
                }
                delay(0.55){
                    self.spawnCoin()
                    self.coins += 1
                    self.coinsNum.text = " \(self.coins)"
                }
                delay(0.6){
                    self.spawnCoin()
                    self.coins += 1
                    self.coinsNum.text = " \(self.coins)"
                }
                delay(0.65){
                    self.spawnCoin()
                    self.coins += 1
                    self.coinsNum.text = " \(self.coins)"
                }
                delay(0.7){
                    self.spawnCoin()
                    self.coins += 1
                    self.coinsNum.text = " \(self.coins)"
                }
                delay(0.75){
                    self.spawnCoin()
                    self.coins += 1
                    self.coinsNum.text = " \(self.coins)"
                }
                delay(0.8){
                    self.spawnCoin()
                    self.coins += 1
                    self.coinsNum.text = " \(self.coins)"
                }
                delay(0.85){
                    self.spawnCoin()
                    self.coins += 1
                    self.coinsNum.text = " \(self.coins)"
                }
                delay(0.9){
                    self.spawnCoin()
                    self.coins += 1
                    self.coinsNum.text = " \(self.coins)"
                }
                delay(0.95){
                    self.spawnCoin()
                    self.coins += 1
                    self.coinsNum.text = " \(self.coins)"
                }
                delay(1.0){
                    self.spawnCoin()
                    self.coins += 1
                    self.coinsNum.text = " \(self.coins)"
                }
                delay(1.05){
                    self.spawnCoin()
                    self.coins += 1
                    self.coinsNum.text = " \(self.coins)"
                }
                delay(1.1){
                    self.spawnCoin()
                    self.coins += 1
                    self.coinsNum.text = " \(self.coins)"
                }
                delay(1.15){
                    self.spawnCoin()
                    self.coins += 1
                    self.coinsNum.text = " \(self.coins)"
                }
                delay(1.2){
                    self.spawnCoin()
                    self.coins += 1
                    self.coinsNum.text = " \(self.coins)"
                }
                
                
                
                
            }
            if nodeITapped.name == "100Coins"
            {
                
                
                
                
                
                
                
                
                coins += 100
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
            }
            
            
            
            
            
            if nodeITapped.name == "back-1"
            {
                
                
                
                
                let sceneToMoveTo = CoinStore(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let specialTransition = SKTransition.push(with: SKTransitionDirection.right, duration: 0.5)
                
                
                
                
                self.view!.presentScene(sceneToMoveTo, transition: specialTransition)
                
                
                
                
                
                
                
                
            }
            
            
            
            
            
            
            if nodeITapped.name == "ball_13"
            {
                
                
                
                
                
                
                if (coins >= 500 && !purchased_ball_13){
                    defaults.set(true, forKey: "purchased_ball_13")
                    purchased_ball_13 = true
                    
                    
                    deleteCoin()
                    ball_13.texture = SKTexture(imageNamed: "ball_13_unlock")
                    previousCoins = coins
                    coins -= 500
                    
                    
                    decrementLabel(to: 500 )
                    defaults.set(coins, forKey: "coinsSaved")
                    
                    
                }
                
                
                if (coins <= 500) {
                    failed_purchased()
                }
                if (purchased_ball_13){
                    currentball.position = CGPoint(x: ball_13.position.x, y: ball_13.position.y)
                    defaults.set(13, forKey: "currentBallNumber")
                    currentBallNumber = 13
                    
                    
                    GameConstants.StringConstant.currentBallIdentity = "ball_13"
                }
                
                
                
                
                
                
            }
            if nodeITapped.name == "ball_14"
            {
                
                
                
                
                
                
                if (coins >= 500 && !purchased_ball_14){
                    defaults.set(true, forKey: "purchased_ball_14")
                    purchased_ball_14 = true
                    
                    
                    deleteCoin()
                    ball_14.texture = SKTexture(imageNamed: "ball_14_unlock")
                    previousCoins = coins
                    coins -= 500
                    
                    
                    decrementLabel(to: 500 )
                    defaults.set(coins, forKey: "coinsSaved")
                    
                    
                }
                if (coins <= 500) {
                    failed_purchased()
                }
                
                
                
                
                if (purchased_ball_14){
                    currentball.position = CGPoint(x: ball_14.position.x, y: ball_14.position.y)
                    defaults.set(14, forKey: "currentBallNumber")
                    currentBallNumber = 14
                    
                    
                    GameConstants.StringConstant.currentBallIdentity = "ball_14"
                }
                
                
            }
            
            
            
            
            
            
            
            
            if nodeITapped.name == "ball_15"
            {
                
                
                
                
                
                
                
                
                if (coins >= 500 && !purchased_ball_15){
                    defaults.set(true, forKey: "purchased_ball_15")
                    purchased_ball_15 = true
                    
                    
                    deleteCoin()
                    ball_15.texture = SKTexture(imageNamed: "ball_15_unlock")
                    previousCoins = coins
                    coins -= 500
                    
                    
                    decrementLabel(to: 500 )
                    defaults.set(coins, forKey: "coinsSaved")
                    
                    
                }
                
                
                if (coins <= 500) {
                    failed_purchased()
                }
                
                
                
                if (purchased_ball_15){
                    currentball.position = CGPoint(x: ball_15.position.x, y: ball_15.position.y)
                    defaults.set(15, forKey: "currentBallNumber")
                    currentBallNumber = 15
                    
                    
                    GameConstants.StringConstant.currentBallIdentity = "ball_15"
                }
                
                
            }
            
            
            
            
            
            
            
            
            if nodeITapped.name == "ball_16"
            {
                
                
                
                
                
                
                if (coins >= 500 && !purchased_ball_16){
                    defaults.set(true, forKey: "purchased_ball_16")
                    purchased_ball_16 = true
                    
                    
                    deleteCoin()
                    ball_16.texture = SKTexture(imageNamed: "ball_16_unlock")
                    previousCoins = coins
                    coins -= 500
                    
                    
                    decrementLabel(to: 500 )
                    defaults.set(coins, forKey: "coinsSaved")
                    
                    
                }
                
                
                if (coins <= 500) {
                    failed_purchased()
                }
                
                
                if (purchased_ball_16){
                    currentball.position = CGPoint(x: ball_16.position.x, y: ball_16.position.y)
                    defaults.set(16, forKey: "currentBallNumber")
                    currentBallNumber = 16
                    
                    
                    GameConstants.StringConstant.currentBallIdentity = "ball_16"
                }
                
                
                
                
                
                
            }
            if nodeITapped.name == "ball_17"
            {
                
                
                
                
                
                
                if (coins >= 500 && !purchased_ball_17){
                    defaults.set(true, forKey: "purchased_ball_17")
                    purchased_ball_17 = true
                    
                    
                    deleteCoin()
                    ball_17.texture = SKTexture(imageNamed: "ball_17_unlock")
                    previousCoins = coins
                    coins -= 500
                    
                    
                    decrementLabel(to: 500 )
                    defaults.set(coins, forKey: "coinsSaved")
                    
                    
                }
                
                
                if (coins <= 500) {
                    failed_purchased()
                }
                
                
                if (purchased_ball_17){
                    currentball.position = CGPoint(x: ball_17.position.x, y: ball_17.position.y)
                    defaults.set(17, forKey: "currentBallNumber")
                    currentBallNumber = 17
                    
                    
                    GameConstants.StringConstant.currentBallIdentity = "ball_17"
                }
                
                
                
                
            }
            if nodeITapped.name == "ball_18"
            {
                
                
                
                
                
                
                
                
                if (coins >= 500 && !purchased_ball_18){
                    defaults.set(true, forKey: "purchased_ball_18")
                    purchased_ball_18 = true
                    
                    
                    deleteCoin()
                    ball_18.texture = SKTexture(imageNamed: "ball_18_unlock")
                    previousCoins = coins
                    coins -= 500
                    
                    
                    decrementLabel(to: 500 )
                    defaults.set(coins, forKey: "coinsSaved")
                    
                    
                }
                
                
                if (coins <= 500) {
                    failed_purchased()
                }
                
                
                if (purchased_ball_18){
                    currentball.position = CGPoint(x: ball_18.position.x, y: ball_18.position.y)
                    defaults.set(18, forKey: "currentBallNumber")
                    currentBallNumber = 18
                    
                    
                    GameConstants.StringConstant.currentBallIdentity = "ball_18"
                }
                
                
                
                
                
                
                
                
            }
            if nodeITapped.name == "ball_19"
            {
                
                
                
                
                
                
                
                
                if (coins >= 1000 && !purchased_ball_19){
                    defaults.set(true, forKey: "purchased_ball_19")
                    purchased_ball_19 = true
                    
                    
                    deleteCoin()
                    ball_19.texture = SKTexture(imageNamed: "ball_19_unlock")
                    previousCoins = coins
                    coins -= 1000
                    
                    
                    decrementLabel(to: 1000 )
                    defaults.set(coins, forKey: "coinsSaved")
                    
                    
                }
                
                
                if (coins <= 1000) {
                    
                    
                    failed_purchased()
                    
                    
                }
                
                
                
                
                
                
                if (purchased_ball_19){
                    currentball.position = CGPoint(x: ball_19.position.x, y: ball_19.position.y)
                    defaults.set(19, forKey: "currentBallNumber")
                    currentBallNumber = 19
                    
                    
                    GameConstants.StringConstant.currentBallIdentity = "ball_19"
                }
                
                
                
                
            }
            if nodeITapped.name == "ball_20"
            {
                
                
                
                
                
                
                
                
                if (coins >= 1000 && !purchased_ball_20){
                    defaults.set(true, forKey: "purchased_ball_20")
                    purchased_ball_20 = true
                    
                    
                    deleteCoin()
                    ball_20.texture = SKTexture(imageNamed: "ball_20_unlock")
                    previousCoins = coins
                    coins -= 1000
                    
                    
                    decrementLabel(to: 1000 )
                    defaults.set(coins, forKey: "coinsSaved")
                    
                    
                }
                if (coins <= 1000) {
                    
                    
                    failed_purchased()
                    
                    
                }
                
                
                
                
                
                
                if (purchased_ball_20){
                    currentball.position = CGPoint(x: ball_20.position.x, y: ball_20.position.y)
                    defaults.set(20, forKey: "currentBallNumber")
                    currentBallNumber = 20
                    
                    
                    GameConstants.StringConstant.currentBallIdentity = "ball_20"
                }
                
                
                
                
                
                
            }
            if nodeITapped.name == "ball_21"
            {
                
                
                
                
                
                
                if (coins >= 1000 && !purchased_ball_21){
                    defaults.set(true, forKey: "purchased_ball_21")
                    purchased_ball_21 = true
                    
                    
                    deleteCoin()
                    ball_21.texture = SKTexture(imageNamed: "ball_21_unlock")
                    previousCoins = coins
                    coins -= 1000
                    
                    
                    decrementLabel(to: 1000 )
                    defaults.set(coins, forKey: "coinsSaved")
                    
                    
                }
                
                
                if (coins <= 1000) {
                    failed_purchased()
                }
                
                
                if (purchased_ball_21){
                    currentball.position = CGPoint(x: ball_21.position.x, y: ball_21.position.y)
                    defaults.set(21, forKey: "currentBallNumber")
                    currentBallNumber = 21
                    
                    
                    GameConstants.StringConstant.currentBallIdentity = "ball_21"
                }
            }
            if nodeITapped.name == "ball_22"
            {
                
                
                
                
                
                
                if (coins >= 1000 && !purchased_ball_22){
                    defaults.set(true, forKey: "purchased_ball_22")
                    purchased_ball_22 = true
                    
                    
                    deleteCoin()
                    ball_22.texture = SKTexture(imageNamed: "ball_22_unlock")
                    previousCoins = coins
                    coins -= 1000
                    
                    
                    decrementLabel(to: 1000 )
                    defaults.set(coins, forKey: "coinsSaved")
                    
                    
                }
                
                
                if (coins <= 1000) {
                    failed_purchased()
                }
                
                
                if (purchased_ball_22){
                    currentball.position = CGPoint(x: ball_22.position.x, y: ball_22.position.y)
                    defaults.set(22, forKey: "currentBallNumber")
                    currentBallNumber = 22
                    
                    
                    GameConstants.StringConstant.currentBallIdentity = "ball_22"
                }
                
                
                
                
            }
            if nodeITapped.name == "ball_23"
            {
                
                
                
                
                
                
                if (coins >= 1000 && !purchased_ball_23){
                    defaults.set(true, forKey: "purchased_ball_23")
                    purchased_ball_23 = true
                    
                    
                    deleteCoin()
                    ball_23.texture = SKTexture(imageNamed: "ball_23_unlock")
                    previousCoins = coins
                    coins -= 1000
                    
                    
                    decrementLabel(to: 1000 )
                    defaults.set(coins, forKey: "coinsSaved")
                    
                    
                }
                
                
                if (coins <= 1000) {
                    failed_purchased()
                }
                
                
                if (purchased_ball_23){
                    currentball.position = CGPoint(x: ball_23.position.x, y: ball_23.position.y)
                    defaults.set(23, forKey: "currentBallNumber")
                    currentBallNumber = 23
                    
                    
                    GameConstants.StringConstant.currentBallIdentity = "ball_23"
                }
                
                
                
                
            }
            if nodeITapped.name == "ball_24"
            {
                
                
                
                
                if (coins >= 1000 && !purchased_ball_24){
                    defaults.set(true, forKey: "purchased_ball_24")
                    purchased_ball_24 = true
                    
                    
                    deleteCoin()
                    ball_24.texture = SKTexture(imageNamed: "ball_24_unlock")
                    previousCoins = coins
                    coins -= 1000
                    
                    
                    decrementLabel(to: 1000 )
                    defaults.set(coins, forKey: "coinsSaved")
                    
                    
                }
                
                
                if (coins <= 1000) {
                    failed_purchased()
                }
                
                
                
                
                if (purchased_ball_24){
                    currentball.position = CGPoint(x: ball_24.position.x, y: ball_24.position.y)
                    defaults.set(24, forKey: "currentBallNumber")
                    currentBallNumber = 24
                    
                    
                    GameConstants.StringConstant.currentBallIdentity = "ball_24"
                }
                
                
                
                
                
                
            }
            if nodeITapped.name == "ball_25"
            {
                
                
                
                
                if (coins >= 2500 && !purchased_ball_25){
                    defaults.set(true, forKey: "purchased_ball_25")
                    purchased_ball_25 = true
                    
                    
                    deleteCoin()
                    ball_25.texture = SKTexture(imageNamed: "ball_25_unlock")
                    previousCoins = coins
                    coins -= 2500
                    
                    
                    decrementLabel(to: 2500 )
                    defaults.set(coins, forKey: "coinsSaved")
                    
                    
                }
                
                
                
                
                if (coins <= 2500) {
                    failed_purchased()
                }
                
                
                
                
                if (purchased_ball_25){
                    currentball.position = CGPoint(x: ball_25.position.x, y: ball_25.position.y)
                    defaults.set(25, forKey: "currentBallNumber")
                    currentBallNumber = 25
                    
                    
                    GameConstants.StringConstant.currentBallIdentity = "ball_25"
                }
                
                
                
                
                
                
            }
            if nodeITapped.name == "ball_26"
            {
                
                
                
                
                
                
                if (coins >= 2500 && !purchased_ball_26){
                    defaults.set(true, forKey: "purchased_ball_26")
                    purchased_ball_26 = true
                    
                    
                    deleteCoin()
                    ball_26.texture = SKTexture(imageNamed: "ball_26_unlock")
                    previousCoins = coins
                    coins -= 2500
                    
                    
                    decrementLabel(to: 2500 )
                    defaults.set(coins, forKey: "coinsSaved")
                    
                    
                }
                
                
                
                
                if (coins <= 2500) {
                    failed_purchased()
                }
                
                
                
                
                if (purchased_ball_26){
                    currentball.position = CGPoint(x: ball_26.position.x, y: ball_26.position.y)
                    defaults.set(26, forKey: "currentBallNumber")
                    currentBallNumber = 26
                    
                    
                    GameConstants.StringConstant.currentBallIdentity = "ball_26"
                }
                
                
                
                
                
                
                
                
            }
            if (nodeITapped.name == "ball_27")
            {
                
                
                
                
                
                
                
                
                if (coins >= 2500 && !purchased_ball_27){
                    defaults.set(true, forKey: "purchased_ball_27")
                    purchased_ball_27 = true
                    
                    
                    deleteCoin()
                    ball_27.texture = SKTexture(imageNamed: "ball_27_unlock")
                    previousCoins = coins
                    coins -= 2500
                    
                    
                    decrementLabel(to: 2500 )
                    defaults.set(coins, forKey: "coinsSaved")
                    
                    
                }
                
                
                
                
                if (coins <= 2500) {
                    failed_purchased()
                }
                
                
                
                
                if (purchased_ball_27){
                    currentball.position = CGPoint(x: ball_27.position.x, y: ball_27.position.y)
                    defaults.set(27, forKey: "currentBallNumber")
                    currentBallNumber = 27
                    
                    
                    GameConstants.StringConstant.currentBallIdentity = "ball_27"
                }
                
                
                
                
                
                
                
                
            }
            if (nodeITapped.name == "ball_28" || nodeITapped.name == "frame_1")
            {
                
                
                
                
                
                
                
                
                if (coins >= 5000 && !purchased_ball_28){
                    defaults.set(true, forKey: "purchased_ball_28")
                    purchased_ball_28 = true
                    CoinDustEmitter()
                    deleteCoin()
                    ball_28.texture = SKTexture(imageNamed: "ball_29_unlock")
                    previousCoins = coins
                    coins -= 5000
                    
                    
                    decrementLabel(to: 5000 )
                    defaults.set(coins, forKey: "coinsSaved")
                    
                    
                }
                
                
                if (coins <= 5000) {
                    failed_purchased()
                }
                
                
                
                
                if (purchased_ball_28){
                    currentball.position = CGPoint(x: ball_28.position.x, y: ball_28.position.y)
                    
                    
                    defaults.set(28, forKey: "currentBallNumber")
                    currentBallNumber = 28
                    
                    
                    GameConstants.StringConstant.currentBallIdentity = "ball_28"
                }
                
                
                
                
                
                
            }
            if (nodeITapped.name == "ball_29" || nodeITapped.name == "frame_2")
            {
                
                
                
                
                
                
                
                
                if (coins >= 5000 && !purchased_ball_29){
                    defaults.set(true, forKey: "purchased_ball_29")
                    purchased_ball_29 = true
                    
                    
                    deleteCoin()
                    ball_29.texture = SKTexture(imageNamed: "ball_29_unlock")
                    previousCoins = coins
                    coins -= 5000
                    
                    
                    decrementLabel(to: 5000)
                    defaults.set(coins, forKey: "coinsSaved")
                    
                    
                }
                
                
                
                
                if (coins <= 5000) {
                    failed_purchased()
                }
                
                
                
                
                if (purchased_ball_29){
                    currentball.position = CGPoint(x: ball_29.position.x, y: ball_29.position.y)
                    defaults.set(29, forKey: "currentBallNumber")
                    currentBallNumber = 29
                    
                    
                    
                    
                    GameConstants.StringConstant.currentBallIdentity = "ball_29"
                }
                
                
                
                
                
                
            }
            if (nodeITapped.name == "ball_30" || nodeITapped.name == "frame_3")
            {
                
                
                
                
                
                
                
                
                if (coins >= 5000 && !purchased_ball_30){
                    defaults.set(true, forKey: "purchased_ball_30")
                    purchased_ball_30 = true
                    deleteCoin()
                    ball_30.texture = SKTexture(imageNamed: "ball_30_unlock")
                    previousCoins = coins
                    coins -= 5000
                    
                    
                    decrementLabel(to: 5000 )
                    defaults.set(coins, forKey: "coinsSaved")
                    
                    
                }
                
                
                if (coins <= 5000) {
                    failed_purchased()
                }
                
                
                
                
                
                
                if (purchased_ball_30){
                    currentball.position = CGPoint(x: ball_30.position.x, y: ball_30.position.y)
                    defaults.set(30, forKey: "currentBallNumber")
                    currentBallNumber = 30
                    
                    
                    GameConstants.StringConstant.currentBallIdentity = "ball_30"
                }
                
                
            }
            
            
            
            
            
            
            
            
        }
        
        
        
        
        
        
        
        
    }
    
    
    
    
}

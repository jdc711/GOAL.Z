//
//  CoinStore.swift
//  GOALZ
//
//  Created by Carter Stambaugh on 7/15/19.


import Foundation

import SpriteKit

import StoreKit

import CoreGraphics

//import GoogleMobileAds



var purchased_ball_1 = defaults.bool(forKey: "purchased_ball_1")
var purchased_ball_2 = defaults.bool(forKey: "purchased_ball_2")
var purchased_ball_3 = defaults.bool(forKey: "purchased_ball_3")
var purchased_ball_4 = defaults.bool(forKey: "purchased_ball_4")
var purchased_ball_5 = defaults.bool(forKey: "purchased_ball_5")
var purchased_ball_6 = defaults.bool(forKey: "purchased_ball_6")
var purchased_ball_7 = defaults.bool(forKey: "purchased_ball_7")
var purchased_ball_8 = defaults.bool(forKey: "purchased_ball_8")
var purchased_ball_9 = defaults.bool(forKey: "purchased_ball_9")
var purchased_ball_10 = defaults.bool(forKey: "purchased_ball_10")
var purchased_ball_11 = defaults.bool(forKey: "purchased_ball_11")
var purchased_ball_12 = defaults.bool(forKey: "purchased_ball_12")
var currentBallNumber = defaults.integer(forKey: "currentBallNumber")
var firePrice = 10
var addedfire = 1


class CoinStore: SKScene, SKPaymentTransactionObserver {
    
     var coins = defaults.integer(forKey: "coinsSaved")
    
    
    
       let productID = "GOALZ.SmallCoins.099"
       
       let productID2 = "GOALZ.mediumCoinPackage.5.00"
       
       let productID3 = "GOALZ.LargeCoinPackage.25.00"
       
    let productID4 = "GOALZ.ultimatecoinpackage.50.00"
    
    
    let currentball = SKSpriteNode(imageNamed: "currentBall")
    
   
    
    var firePowerUps = defaults.integer(forKey: "firePowerUps")
    
    var fireBuy = defaults.integer(forKey: "fireBuy")
    
    
    let ball_1 = GameConstants.StringConstant.ball_1
    
    let ball_2 = GameConstants.StringConstant.ball_2
    
    let ball_3 = GameConstants.StringConstant.ball_3
    
    let ball_4 = GameConstants.StringConstant.ball_4
    
    let ball_5 = GameConstants.StringConstant.ball_5
    
    let ball_6 = GameConstants.StringConstant.ball_6
    
    let ball_7 = GameConstants.StringConstant.ball_7
    
    let ball_8 = GameConstants.StringConstant.ball_8
    
    let ball_9 = GameConstants.StringConstant.ball_9
    
    let ball_10 = GameConstants.StringConstant.ball_10
    
    let ball_11 = GameConstants.StringConstant.ball_11
    
    let ball_12 = GameConstants.StringConstant.ball_12
    
    
    
    
    
    let watchVideo = SKSpriteNode(imageNamed: "watchVideo")
    
    
    
    let coinsNum1 = SKLabelNode(fontNamed: "The Bold Font")
    
    let coinPic = SKSpriteNode(imageNamed: "Coin")
    
    
    
    
    
    
    
    
    
    let powerPic = SKSpriteNode(imageNamed: "firePowerUp")
    
    let powerNum = SKLabelNode(fontNamed: "The Bold Font")
    
    let fire = SKSpriteNode(imageNamed: "fire_more")
    
    let fireNum = SKLabelNode(fontNamed: "The Bold Font")
    
    
    
    
    
    let buyFirePrice = SKLabelNode(fontNamed: "The Bold Font")
    
    let addFire = SKLabelNode(fontNamed: "The Bold Font")
    
    
    
    
    
    
    
    
    
    var previousCoins = defaults.integer(forKey: "coinsSaved")
    
    var perviousPowerUp = defaults.integer(forKey: "firePowerUps")
    
    var perviousFireUp = defaults.integer(forKey: "firePrice")
    
    var currentAddFireUp = defaults.integer(forKey: "AddFire")
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func incrementLabel(to endValue: Int) {
        
        let duration: Double = 1.3
        
        
        
        
        
        
        
        
        
        //let duration: Double = 0.5 //seconds
        
        DispatchQueue.global().async {
            
            for i in 0 ..< (endValue + 1) {
                
                let sleepTime = UInt32(duration/Double(endValue) * 1000000.0)
                
                usleep(sleepTime)
                
                DispatchQueue.main.async {
                    
                    self.coinsNum1.text = " \(i + self.previousCoins)"
                    
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
                    
                    self.coinsNum1.text = " \(self.previousCoins - i)"
                    
                }
                
            }
            
        }
        
    }
    
    
    
    
    
    
    
    func incrementFireBuy(to endValue: Int) {
        
        let duration: Double = 0.1
        
        
        
        
        
        
        
        
        
        //let duration: Double = 0.5 //seconds
        
        DispatchQueue.global().async {
            
            for i in 0 ..< (endValue + 1) {
                
                let sleepTime = UInt32(duration/Double(endValue) * 1000000.0)
                
                usleep(sleepTime)
                
                DispatchQueue.main.async {
                    
                    self.buyFirePrice.text = "\(i + self.perviousFireUp)"
                    
                }
                
            }
            
        }
        
    }
    
    
    
    
    
    
    
    
    
    func decrementFireBuy(to endValue: Int) {
        
        let duration: Double = 0.1
        
        
        
        
        
        
        
        
        
        //let duration: Double = 0.5 //seconds
        
        DispatchQueue.global().async {
            
            for i in (0 ..< (endValue + 1)) {
                
                let sleepTime = UInt32(duration/Double(endValue) * 1000000.0)
                
                usleep(sleepTime)
                
                DispatchQueue.main.async {
                    
                    self.buyFirePrice.text = "\(self.perviousFireUp - i)"
                    
                }
                
            }
            
        }
        
    }
    
    
    
    
    
    func incrementFireAdd(to endValue: Int) {
        
        let duration: Double = 0.1
        
        
        
        //let duration: Double = 0.5 //seconds
        
        DispatchQueue.global().async {
            
            for i in 0 ..< (endValue + 1) {
                
                let sleepTime = UInt32(duration/Double(endValue) * 1000000.0)
                
                usleep(sleepTime)
                
                DispatchQueue.main.async {
                    
                    self.addFire.text = "\(i + self.currentAddFireUp)"
                    
                }
                
            }
            
        }
        
    }
    
    
    
    
    
    
    
    
    
    func decrementFireSubtract(to endValue: Int) {
        
        let duration: Double = 0.1
        
        
        
        
        
        
        
        
        
        //let duration: Double = 0.5 //seconds
        
        DispatchQueue.global().async {
            
            for i in (0 ..< (endValue + 1)) {
                
                let sleepTime = UInt32(duration/Double(endValue) * 1000000.0)
                
                usleep(sleepTime)
                
                DispatchQueue.main.async {
                    
                    self.addFire.text = "\(self.currentAddFireUp - i)"
                    
                }
                
            }
            
        }
        
    }
    
    
    
    
    
    
    
    
    
    func add_total_firePowerUps(to endValue: Int) {
        
        
        
        
        
        let duration: Double = 0.2
        
        
        
        
        
        DispatchQueue.global().async {
            
            for i in (0 ..< (endValue + 1)) {
                
                let sleepTime = UInt32(duration/Double(endValue) * 1000000.0)
                
                usleep(sleepTime)
                
                DispatchQueue.main.async {
                    
                    self.powerNum.text = "\(i + self.perviousPowerUp)"
                    
                }
                
            }
            
            
            
            
            
        }
        
        
        
        
        
    }
    
    
    
    
    
    func subtract_total_firePowerUps(to endValue: Int) {
        
        
        
        
        
        let duration: Double = 0.2
        
        
        

        DispatchQueue.global().async {
            
            for i in (0 ..< (endValue + 1)) {
                
                let sleepTime = UInt32(duration/Double(endValue) * 1000000.0)
                
                usleep(sleepTime)
                
                DispatchQueue.main.async {
                    
                    self.fireNum.text = "\(self.perviousPowerUp - i)"
                    
                }
                
            }
            
            
            
            
            
        }
        
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    override func didMove(to view: SKView) {
        
        SKPaymentQueue.default().add(self)
        
        coins = defaults.integer(forKey: "coinsSaved")
       
        
        prevGameLevel = gameLevel
        
        if (currentGameState != gameState.paused){
            currentGameState = gameState.beforeGame
        }
        self.enumerateChildNodes(withName: "coinsNum1"){
            
            (coinNum, stop) in
            
            coinNum.removeFromParent()
            
            
            
        }
        
        
        
        ContinuePlaying = false
        
        
        
        self.addChild(currentball)
        
        
        
        
        
        
        
        
        
        if (purchased_ball_2){
            
            ball_2.texture = SKTexture(imageNamed: "ball_2_unlock")
            
        }
        
        if (purchased_ball_3){
            
            ball_3.texture = SKTexture(imageNamed: "ball_3_unlock")
            
        }
        
        if (purchased_ball_4){
            
            ball_4.texture = SKTexture(imageNamed: "ball_4_unlock")
            
        }
        
        if (purchased_ball_5){
            
            ball_5.texture = SKTexture(imageNamed: "ball_5_unlock")
            
        }
        
        if (purchased_ball_6){
            
            ball_6.texture = SKTexture(imageNamed: "ball_6_unlock")
            
        }
        
        if (purchased_ball_7){
            
            ball_7.texture = SKTexture(imageNamed: "ball_7_unlock")
            
        }
        
        if (purchased_ball_8){
            
            ball_8.texture = SKTexture(imageNamed: "ball_8_unlock")
            
        }
        
        if (purchased_ball_9){
            
            ball_9.texture = SKTexture(imageNamed: "ball_9_unlock")
            
        }
        
        if (purchased_ball_10){
            
            ball_10.texture = SKTexture(imageNamed: "ball_10_unlock")
            
        }
        
        if (purchased_ball_11){
            
            ball_11.texture = SKTexture(imageNamed: "ball_11_unlock")
            
        }
        
        if (purchased_ball_12){
            
            ball_12.texture = SKTexture(imageNamed: "ball_12_unlock")
            
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
     
        
        
        
        
        
        
        
        
        
        let back = SKSpriteNode(imageNamed: "exit")
        
        back.setScale(1)
        
        back.position = CGPoint(x: self.size.width * 0.25, y: self.size.height*0.92)
        
        back.zPosition = 1
        
        back.name = "back"
        
        self.addChild(back)
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
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
        
        back1.alpha = 0.1
        
        back1.zPosition = 1
        
        self.addChild(back1)
        
        
        
        
        
        
        
        
        
        let next = SKSpriteNode(imageNamed: "next")
        
        next.setScale(1)
        
        next.alpha = 1
        
        next.position = CGPoint(x: self.size.width*0.75, y: self.size.height*0.85)
        
        next.zPosition = 3
        
        next.name = "next"
        
        self.addChild(next)
        
        
        
     //   let Current_Ad = SKSpriteNode(imageNamed: "Current_Ad")
      //  Current_Ad.position = CGPoint(x: vide, y: <#T##CGFloat#>)
        
        
        
        
        
        
        watchVideo.setScale(0.75)
        
        watchVideo.position = CGPoint(x: self.size.width*0.3505, y: self.size.height*0.63)
        
        watchVideo.zPosition = 1
        
        watchVideo.name = "watchVideo"
        
        watchVideo.isHidden = false
        
        self.addChild(watchVideo)
        
        
        
        
        
        
        
        
        
        fire.setScale(0.75)
        
        fire.position = CGPoint(x: self.size.width*0.6505, y: self.size.height*0.63)
        
        fire.zPosition = 1
        
        self.addChild(fire)
        
        
        
        
        
        let fireBack = SKSpriteNode(imageNamed: "back_1")
        
        fireBack.setScale(0.7)
        
        fireBack.position = CGPoint(x: self.size.width*0.555, y: self.size.height*0.66)
        
        fireBack.zPosition = 2
        
        fireBack.name = "fireBack"
        
        self.addChild(fireBack)
        
        
        
        
        
        let fireNext = SKSpriteNode(imageNamed: "next_1")
        
        fireNext.setScale(0.7)
        
        fireNext.position = CGPoint(x: self.size.width*0.605, y: self.size.height*0.66)
        
        fireNext.zPosition = 2
        
        fireNext.name = "fireNext"
        
        self.addChild(fireNext)
        
        
        
        
        
        
        
        
        
        fireNum.text = ""
        
        fireNum.fontSize = 55
        
        fireNum.position = CGPoint(x: self.size.width*0.65, y: self.size.height*0.65)
        
        fireNum.zPosition = 2
        
        fireNum.alpha = 1
        
        self.addChild(fireNum)
        
        
        
        
        
        buyFirePrice.text = "\(firePrice)"
        
        buyFirePrice.fontSize = 45
        
        buyFirePrice.position = CGPoint(x: self.size.width*0.66, y: self.size.height*0.652)
        
        buyFirePrice.zPosition = 2
        
        buyFirePrice.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        
        self.addChild(buyFirePrice)
        
        
        
        
        
        addFire.text = "\(addedfire)"
        
        addFire.fontSize = 55
        
        addFire.position = CGPoint(x: self.fire.position.x, y: self.size.height*0.59)
        
        addFire.zPosition = 3
        
        addFire.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        
        self.addChild(addFire)
        
        
        
        
        
        let buy_Fire_Button = SKSpriteNode(imageNamed: "buy_Fire_Button")
        
        buy_Fire_Button.setScale(0.75)
        
        buy_Fire_Button.position = CGPoint(x: self.fire.position.x, y: self.size.height*0.6)
        
        buy_Fire_Button.zPosition = 2
        
        buy_Fire_Button.name = "Buy_Fire"
        
        buy_Fire_Button.alpha = 1
        
        self.addChild(buy_Fire_Button)
        
        
        
        
        
        let line = SKSpriteNode(imageNamed: "break")
        
        line.setScale(1)
        
        line.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.545)
        
        line.zPosition = 1
        
        self.addChild(line)
        
        
        
        
        
        let oneDollar = SKSpriteNode(imageNamed: "oneDollar")
        
        oneDollar.setScale(0.75)
        
        oneDollar.position = CGPoint(x: self.size.width*0.3, y: self.size.height*0.75)
        
        oneDollar.zPosition = 1
        
        oneDollar.name = "oneDollar"
        
        self.addChild(oneDollar)
        
        
        
        
        
        let threeDollar = SKSpriteNode(imageNamed: "medcoin")
        
        threeDollar.setScale(0.75)
        
        threeDollar.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.75)
        
        threeDollar.zPosition = 1
        
        threeDollar.name = "fiveHundredDollars"
        
        self.addChild(threeDollar)
        
        
        
        
        
        let tenDollar = SKSpriteNode(imageNamed: "sevenDollars")
        
        tenDollar.setScale(0.75)
        
        tenDollar.position = CGPoint(x: self.size.width*0.7, y: self.size.height*0.75)
        
        tenDollar.zPosition = 1
        
        tenDollar.name = "sevenDollars"
        
        self.addChild(tenDollar)
        
        
        
        
        
        ball_1.setScale(0.7)
        
        ball_1.position = CGPoint(x: self.size.width*0.3, y: self.size.height*0.46)
        
        ball_1.zPosition = 1
        
        ball_1.name = "ball_1"
        
        self.addChild(ball_1)
        
        
        
        
        
        ball_2.setScale(0.7)
        
        ball_2.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.46)
        
        ball_2.zPosition = 1
        
        ball_2.name = "ball_2"
        
        self.addChild(ball_2)
        
        
        
        
        
        
        
        
        
        ball_3.setScale(0.7)
        
        ball_3.position = CGPoint(x: self.size.width*0.7, y: self.size.height*0.46)
        
        ball_3.zPosition = 1
        
        ball_3.name = "ball_3"
        
        self.addChild(ball_3)
        
        
        
        
        
        ball_4.setScale(0.7)
        
        ball_4.position = CGPoint(x: self.size.width*0.3, y: self.size.height*0.34)
        
        ball_4.zPosition = 1
        
        ball_4.name = "ball_4"
        
        self.addChild(ball_4)
        
        
        
        
        
        ball_5.setScale(0.7)
        
        ball_5.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.34)
        
        ball_5.zPosition = 1
        
        ball_5.name = "ball_5"
        
        self.addChild(ball_5)
        
        
        
        
        
        ball_6.setScale(0.7)
        
        ball_6.position = CGPoint(x: self.size.width*0.7, y: self.size.height*0.34)
        
        ball_6.zPosition = 1
        
        ball_6.name = "ball_6"
        
        self.addChild(ball_6)
        
        
        
        
        
        ball_7.setScale(0.7)
        
        ball_7.position = CGPoint(x: self.size.width*0.3, y: self.size.height*0.22)
        
        ball_7.zPosition = 1
        
        ball_7.name = "ball_7"
        
        self.addChild(ball_7)
        
        
        
        
        
        
        
        
        
        
        ball_8.setScale(0.7)
        
        ball_8.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.22)
        
        ball_8.zPosition = 1
        
        ball_8.name = "ball_8"
        
        self.addChild(ball_8)
        
        
        
        
        
        ball_9.setScale(0.7)
        
        ball_9.position = CGPoint(x: self.size.width*0.7, y: self.size.height*0.22)
        
        ball_9.zPosition = 1
        
        ball_9.name = "ball_9"
        
        self.addChild(ball_9)
        
        
        ball_10.setScale(0.7)
        
        ball_10.position = CGPoint(x: self.size.width*0.3, y: self.size.height*0.1)
        
        ball_10.zPosition = 1
        
        ball_10.name = "ball_10"
        
        self.addChild(ball_10)
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        ball_11.setScale(0.7)
        
        ball_11.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.1)
        
        ball_11.zPosition = 1
        
        ball_11.name = "ball_11"
        
        self.addChild(ball_11)
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        ball_12.setScale(0.7)
        
        ball_12.position = CGPoint(x: self.size.width*0.7, y: self.size.height*0.1)
        
        ball_12.zPosition = 1
        
        ball_12.name = "ball_12"
        
        self.addChild(ball_12)
        
        
        
        
        
        
        
        
        
        coinPic.setScale(0.4)
        
        coinPic.position = CGPoint(x: self.size.width*0.55, y: self.size.height*0.913)
        
        coinPic.zPosition = 10
        
        self.addChild(coinPic)
        
        
        
        
        
        coinsNum1.text = " \(coins)"
        
        coinsNum1.name = "coinsNum1"
        
        coinsNum1.fontSize = 65
        
        coinsNum1.isHidden = false
        
        coinsNum1.isPaused = false
        
        coinsNum1.alpha = 1
        
        coinsNum1.color = SKColor.white
        
        coinsNum1.zPosition = 1
        
        coinsNum1.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        
        coinsNum1.position =  CGPoint(x: self.size.width*0.71, y: self.size.height*0.9)
        
        self.addChild(coinsNum1)
        
        
        
        
        
        powerPic.setScale(0.45)
        
        powerPic.position = CGPoint(x: self.size.width/2.7, y: self.size.height*0.913)
        
        powerPic.zPosition = 10
        
        self.addChild(powerPic)
        
        
        
        
        
        powerNum.text = " \(firePowerUps)"
        
        powerNum.fontSize = 65
        
        powerNum.color = SKColor.white
        
        powerNum.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        
        powerNum.position = CGPoint(x: self.size.width/2.36, y: self.size.height*0.9)
        
        self.addChild(powerNum)
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        currentball.setScale(0.7)
        
        currentball.zPosition = 3
        
        print(currentBallNumber)
        
        if (currentBallNumber == 2){
            
            currentball.position = CGPoint(x: ball_2.position.x, y: ball_2.position.y)
            
        }
            
        else if (currentBallNumber == 3){
            
            currentball.position = CGPoint(x: ball_3.position.x, y: ball_3.position.y)
            
        }
            
        else if (currentBallNumber == 4){
            
            currentball.position = CGPoint(x: ball_4.position.x, y: ball_4.position.y)
            
        }
            
        else if (currentBallNumber == 5){
            
            currentball.position = CGPoint(x: ball_5.position.x, y: ball_5.position.y)
            
            
            
            
            
            
            
            
            
        }
            
        else if (currentBallNumber == 6){
            
            currentball.position = CGPoint(x: ball_6.position.x, y: ball_6.position.y)
            
        }
            
        else if (currentBallNumber == 7){
            
            currentball.position = CGPoint(x: ball_7.position.x, y: ball_7.position.y)
            
            
            
            
            
            
            
            
            
        }
            
        else if (currentBallNumber == 8){
            
            currentball.position = CGPoint(x: ball_8.position.x, y: ball_8.position.y)
            
        }
            
        else if (currentBallNumber == 9){
            
            currentball.position = CGPoint(x: ball_9.position.x, y: ball_9.position.y)
            
        }
            
        else if (currentBallNumber == 10){
            
            currentball.position = CGPoint(x: ball_10.position.x, y: ball_10.position.y)
            
        }
            
        else if (currentBallNumber == 11){
            
            currentball.position = CGPoint(x: ball_11.position.x, y: ball_11.position.y)
            
        }
            
        else if (currentBallNumber == 12){
            
            currentball.position = CGPoint(x: ball_12.position.x, y: ball_12.position.y)
            
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
    
    
    
    
    
    func failed_purchased() {
        
        
        
        
        
        let shake_right = SKAction.moveTo(x: self.size.width*0.72, duration: 0.1)
        
        let shake_left = SKAction.moveTo(x: self.size.width*0.7, duration: 0.1)
        
        let shake_right_repeat = SKAction.moveTo(x: self.size.width*0.72, duration: 0.1)
        
        let shake_left_repeat = SKAction.moveTo(x: self.size.width*0.7, duration: 0.1)
        
        
        
        
        
        
        
        let shake_seq = SKAction.sequence([shake_right,shake_left,shake_right_repeat,shake_left_repeat])
        
        coinsNum1.run(shake_seq)
        
        
        
        
        
    }
    
    
    
    
    
    func buy_tier_1_ball() {
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
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
    
    var brake = false
    
    
    
    
    
    
    
    
    
    func particle() {
        
        
        
        
        
        
        
        
        
        
        
        brake = true
        
        
        
        
        
        
        
        
        
        if let sparky = ParticleHelper.addParticleEffect(name: GameConstants.StringConstant.coinParticle, particlePositionRange: CGVector(dx: 30.0, dy: 30.0), position: CGPoint(x: ball_2.position.x, y: ball_2.position.y)) {
            
            sparky.zPosition = 2
            
            
            
            
            
            
            
            
            
            
            
            self.addChild(sparky)
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
        }
        
        
        
        
        
        
        
        
        
    }
    
    
    
    
    
    func coin_move_2() {
        
        
        
        
        
        // let coin_move = SKAction.move(by: CGPoint(x: self.ball_2.position.x, y: self.ball_2.position.y), duration: 0.4)
        
        
        
        
        
        let coin_move = SKAction.moveBy(x: self.ball_2.position.x, y: self.ball_2.position.y, duration: 1.0)
        
        
        
        
        
        // coinPic.addChild(coin_move)
        
        coinPic.run(coin_move)
        
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        
        let when = DispatchTime.now() + delay
        
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
   
    
    
    var smallcoin = false
    
    var medcoin = false
    
    var largecoin = false
    
    
    func restorePurchases() {
        
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
        
        
    }
    
    
    
    
    func buySmallCoin(){
        
        
        smallcoin = false
        
        
        if SKPaymentQueue.canMakePayments(){
            
            
          
            
            let paymentRequest = SKMutablePayment()
            
            paymentRequest.productIdentifier = productID
            
            SKPaymentQueue.default().add(paymentRequest)
            
            restorePurchases()
            
            
          
            smallcoin = true
            
        } else {
            
            print("User can't make purchase")
            
        }
        
    }
    
    
    func buyMedCoin(){
        
        
        medcoin = false
        
        if SKPaymentQueue.canMakePayments(){
            
            let paymentRequest = SKMutablePayment()
            
            paymentRequest.productIdentifier = productID2
            
            SKPaymentQueue.default().add(paymentRequest)
            
            
            medcoin = true
            
            
        } else {
            
            print("User can't make purchase")
            
        }
        
    }
    
    func buyBigCoin(){
        
        
    largecoin = false
        
        
        if SKPaymentQueue.canMakePayments(){
            
            let paymentRequest = SKMutablePayment()
            
            paymentRequest.productIdentifier = productID3
            
            SKPaymentQueue.default().add(paymentRequest)
            
            largecoin = true
          //  SKPaymentQueue.default().add(paymentRequest)
              
            
            
            
            
        } else {
            
            print("User can't make purchase")
            
        }
        
    }
    
    func buyUltiCoin(){
        
        
        
        largecoin = false
        
        
        
        if SKPaymentQueue.canMakePayments(){
            
            
            let paymentRequest = SKMutablePayment()
            
            paymentRequest.productIdentifier = productID4
            
            SKPaymentQueue.default().add(paymentRequest)
           
            largecoin = true
        }
        
         else
            {
            print("User can't make purchase")
                }
            
        
    }
        
    
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        
        
        for transaction in transactions{
            
            
            
            
            
           // if transaction.transactionState == .purchased{
               
            if transaction.transactionState == .purchased {
                
                
    
        
                if (smallcoin == true) {
                    
                    spawnCoin()
                    
                    coins += 200
                    
                    previousCoins = coins
                    
                    defaults.set(coins, forKey: "coinsSaved")
                    
                    incrementLabel(to: 200 )
                    
                    print("tytrgdfgx")
                    
                    smallcoin = false
                    
               
                }
                
                
                
                else if (medcoin == true) {
                    
                    
                    
                    spawnCoin()
                    
                    coins += 500
                    
                    previousCoins = coins
                    
                    defaults.set(coins, forKey: "coinsSaved")
                    
                    incrementLabel(to: 500 )
                
                    medcoin = false
                    
                    
                    
                }
                
                
               else if (largecoin == true) {
                    
            
                    spawnCoin()
                    
                    previousCoins = coins
                    
                    coins += 1000
                    
                    defaults.set(coins, forKey: "coinsSaved")
                    
                    incrementLabel(to: 1000 )
                    
                    largecoin = false
                    
            
                }
                
                
                
                delay(0.05){
                    
                    self.spawnCoin()
                    
                }
                
                delay(0.1){
                    
                    self.spawnCoin()
                    
                    
                    
                }
                
                delay(0.15){
                    
                    self.spawnCoin()
                    
                    
                    
                    
                    
                    
                    
                    
                    
                }
                
                delay(0.2){
                    
                    self.spawnCoin()
                    
                    
                    
                    
                    
                    
                    
                    
                    
                }
                
                delay(0.25){
                    
                    self.spawnCoin()
                    
                    
                    
                    
                    
                    
                    
                    
                    
                }
                
                delay(0.3){
                    
                    self.spawnCoin()
                    
                    
                    
                    
                    
                    
                    
                    
                    
                }
                
                delay(0.35){
                    
                    self.spawnCoin()
                    
                    
                    
                    
                    
                    
                    
                    
                    
                }
                
                delay(0.4){
                    
                    self.spawnCoin()
                    
                    
                    
                    
                    
                    
                    
                    
                    
                }
                
                delay(0.45){
                    
                    self.spawnCoin()
                    
                    
                    
                    
                    
                    
                    
                    
                    
                }
                
                delay(0.5){
                    
                    self.spawnCoin()
                    
                    
                    
                    
                    
                    
                    
                    
                    
                }
                
                delay(0.55){
                    
                    self.spawnCoin()
                    
                    
                    
                    
                    
                    
                    
                    
                    
                }
                
                delay(0.6){
                    
                    self.spawnCoin()
                    
                    
                    
                    
                    
                    
                    
                    
                    
                }
                
                delay(0.65){
                    
                    self.spawnCoin()
                    
                }
                
                delay(0.7){
                    
                    self.spawnCoin()
                    
                    
                    
                    
                    
                    
                    
                    
                    
                }
                
                delay(0.75){
                    
                    self.spawnCoin()
                    
                    
                    
                    
                    
                    
                    
                    
                    
                }
                
                delay(0.8){
                    
                    self.spawnCoin()
                    
                    
                    
                    
                    
                    
                    
                    
                    
                }
                
                delay(0.85){
                    
                    self.spawnCoin()
                    
                    
                    
                    
                    
                    
                    
                    
                    
                }
                
                delay(0.9){
                    
                    self.spawnCoin()
                    
                    
                    
                    
                    
                    
                    
                    
                    
                }
                
                delay(0.95){
                    
                    self.spawnCoin()
                    
                    
                    
                    
                    
                    
                    
                    
                    
                }
                
                delay(1.0){
                    
                    self.spawnCoin()
                    
                    
                    
                    
                    
                    
                    
                    
                    
                }
                
                delay(1.05){
                    
                    self.spawnCoin()
                    
                    
                    
                    
                    
                    
                    
                    
                    
                }
                
                delay(1.1){
                    
                    self.spawnCoin()
                    
                    
                    
                    
                    
                    
                    
                    
                    
                }
                
                delay(1.15){
                    
                    self.spawnCoin()
                    
                    
                    
                    
                    
                    
                    
                    
                    
                }
                
                delay(1.2){
                    
                    self.spawnCoin()
                    
                    
                    
                    
                    
                    
                    
                    
                    
                }
                
                delay(1.25){
                    
                    self.spawnCoin()
                    
                    
                    
                    
                    
                    
                    
                    
                    
                }
                
                delay(1.3){
                    
                    self.spawnCoin()
                    
                    
                    
                    
                    
                    
                    
                    
                    
                }
                
                
                
                
                
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
    
    
    
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        
        for touch: AnyObject in touches{
            
            
            
            
            
            let pointOfTouch = touch.location(in: self)
            
            let nodeITapped = atPoint(pointOfTouch)
            
            
            
            if nodeITapped.name == "oneDollar"
                
            {
                
                
             //   IAPManager.
                
                smallcoin = true
                
                buySmallCoin()
                
    
                
            }
            
            
            
            
            
            
            if nodeITapped.name == "next"
                
            {
                
                let sceneToMoveTo = CoinStore2(size: self.size)
                
                sceneToMoveTo.scaleMode = self.scaleMode
                
                let specialTransition = SKTransition.push(with: SKTransitionDirection.left, duration: 0.5)
                
                
                
                self.view!.presentScene(sceneToMoveTo, transition: specialTransition)
                
            
                
            }
            
            
            
        
            
            if nodeITapped.name == "fiveHundredDollars"
                
            {
                
                
                
                
                
                
                
                medcoin = true
                
                buyMedCoin()
                
                
                
                
                
                
                
                
                
            }
            
            
            
            if nodeITapped.name == "watchVideo"  {
                
                
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showVideoRewardAd"), object: nil)
                
                
            }
            
            
            
            if nodeITapped.name == "sevenDollars"
                
            {
                
                largecoin = true
                
                buyUltiCoin()
                
            }
            
            
            
            if nodeITapped.name == "fireNext" {
                
                
                
                
                
                perviousFireUp = firePrice
                
                firePrice += 10
                
                incrementFireBuy(to: 10)
                
                defaults.set(firePrice, forKey: "firePrice")
                
                
                
                
                
                currentAddFireUp = addedfire
                
                addedfire += 1
                
                incrementFireAdd(to: 1)
                
                defaults.set(addedfire, forKey: "AddFire")
                
                
                
                
                
            }
            
            
            
            
            
            if nodeITapped.name == "fireBack" {
                
                
                
                
                
                
                
                
                
                if (firePrice > 10) {
                    
                    perviousFireUp = firePrice
                    
                    firePrice -= 10
                    
                    decrementFireBuy(to: 10)
                    
                    defaults.set(firePrice, forKey: "firePrice")
                    
                    
                    
                    currentAddFireUp = addedfire
                    
                    addedfire -= 1
                    
                    decrementFireSubtract(to: 1)
                    
                    defaults.set(addedfire, forKey: "AddFire")
                    
                    
                    
                    
                    
                }
                    
                else {
                    
                    failed_purchased()
                    
                }
                
                
                
                
                
            }
            
            if nodeITapped.name == "Buy_Fire" {
                
                
                
                
                
                if (coins >= firePrice) {
                    
                    
                    
                    
                    
                    print("fireBought!")
                    
                    previousCoins = coins;
                    
                    perviousPowerUp = firePowerUps
                    
                    coins -= firePrice
                    
                    firePowerUps += addedfire
                    
                    
                    
                    defaults.set(coins, forKey: "coinsSaved")
                    
                    decrementLabel(to: firePrice)
                    
                    
                    
                    add_total_firePowerUps(to: addedfire)
                    
                    defaults.set(firePowerUps, forKey: "firePowerUps")
                    
                    addedfire = 1
                    
                    firePrice = 10
                    
                    addFire.text = "1"
                    
                    buyFirePrice.text = "10"
                    
                    
                    
                    
                    
                    
                    
                }
                
                
                
                if (coins < firePrice) {
                    
                    
                    
                    
                    
                    failed_purchased()
                    
                }
                
                
                
                
                
            }
            
            
            
            if nodeITapped.name == "back" {
                
                
                
                
                
                if (currentGameState == gameState.paused){
                    
                    let sceneToMoveTo = GameScene(size: self.size)
                    
                    sceneToMoveTo.scaleMode = self.scaleMode
                    
                    let myTransition = SKTransition.fade(withDuration: 0.5)
                    
                    self.view!.presentScene(sceneToMoveTo, transition: myTransition)
                    
                }
                    
                else{
                    
                    let sceneToMoveTo = MainMenuScene(size: self.size)
                    
                    sceneToMoveTo.scaleMode = self.scaleMode
                    
                    let myTransition = SKTransition.fade(withDuration: 0.5)
                    
                    self.view!.presentScene(sceneToMoveTo, transition: myTransition)
                    
                }
                
            }
            
            
            
            
            
            if nodeITapped.name == "ball_1"{
                
                
                
                currentball.position = CGPoint(x: ball_1.position.x, y: ball_1.position.y)
                
                GameConstants.StringConstant.currentBallIdentity = "lightGrayBlueBall"
                
                defaults.set(1, forKey: "currentBallNumber")
                
                currentBallNumber = 1
                
            }
            
            
            
            if nodeITapped.name == "ball_2"
                
            {
                
                
            
                if (coins >= 200 && !purchased_ball_2){
                    
                    
                    defaults.set(true, forKey: "purchased_ball_2")
                    
                    purchased_ball_2 = true
                    
                    coin_move_2()
                    
                    deleteCoin()
                    
                    ball_2.texture = SKTexture(imageNamed: "ball_2_unlock")
            
                  
                    previousCoins = coins
                    
                    coins -= 200
                    
                    coin_move_2()
                    decrementLabel(to: 200 )
                    
                    defaults.set(coins, forKey: "coinsSaved")
                    
                    
                    

                }
                
                
                
                
                
                if (coins <= 200) {
                    
                    failed_purchased()
                    
                }
                
                
                
                
                
                if (purchased_ball_2)
                    
                {
                    
                    currentball.position = CGPoint(x: ball_2.position.x, y: ball_2.position.y)
                    
                    defaults.set(2, forKey: "currentBallNumber")
                    
                    currentBallNumber = 2
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    GameConstants.StringConstant.currentBallIdentity = "OrangeBall"
                    
                }
                
                
                
                
                
                
                
                
                
            }
            
            
            
            
            
            
            
            
            
            
            
            
            
            if nodeITapped.name == "ball_3"
                
            {
                
                
                
                
                
                
                
                
                
                if (coins >= 200 && !purchased_ball_3){
                    
                    defaults.set(true, forKey: "purchased_ball_3")
                    
                    purchased_ball_3 = true
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    deleteCoin()
                    
                    ball_3.texture = SKTexture(imageNamed: "ball_3_unlock")
                    
                    previousCoins = coins
                    
                    coins -= 200
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    decrementLabel(to: 200 )
                    
                    defaults.set(coins, forKey: "coinsSaved")
                    
                    
                    
                    
                    
                }
                
                
                
                
                
                if (coins <= 200) {
                    
                    failed_purchased()
                    
                }
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                if (purchased_ball_3){
                    
                    currentball.position = CGPoint(x: ball_3.position.x, y: ball_3.position.y)
                    
                    defaults.set(3, forKey: "currentBallNumber")
                    
                    currentBallNumber = 3
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    GameConstants.StringConstant.currentBallIdentity = "GreenBall"
                    
                }
                
                
                
                
                
                
                
                
                
            }
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            if nodeITapped.name == "ball_4"
                
            {
                
                
                
                
                
                
                
                
                
                if (coins >= 200 && !purchased_ball_4){
                    
                    defaults.set(true, forKey: "purchased_ball_4")
                    
                    purchased_ball_4 = true
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    deleteCoin()
                    
                    ball_4.texture = SKTexture(imageNamed: "ball_4_unlock")
                    
                    previousCoins = coins
                    
                    coins -= 200
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    decrementLabel(to: 200 )
                    
                    defaults.set(coins, forKey: "coinsSaved")
                    
                }
                
                
                
                
                
                
                
                
                
                
                
                
                
                if (coins <= 200) {
                    
                    failed_purchased()
                    
                }
                
                
                
                
                
                
                
                
                
                if (purchased_ball_4){
                    
                    currentball.position = CGPoint(x: ball_4.position.x, y: ball_4.position.y)
                    
                    defaults.set(4, forKey: "currentBallNumber")
                    
                    currentBallNumber = 4
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    GameConstants.StringConstant.currentBallIdentity = "RedBall"
                    
                }
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
            }
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            if nodeITapped.name == "ball_5"
                
            {
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                if (coins >= 200 && !purchased_ball_5){
                    
                    defaults.set(true, forKey: "purchased_ball_5")
                    
                    purchased_ball_5 = true
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    deleteCoin()
                    
                    ball_5.texture = SKTexture(imageNamed: "ball_5_unlock")
                    
                    previousCoins = coins
                    
                    coins -= 200
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    decrementLabel(to: 200 )
                    
                    defaults.set(coins, forKey: "coinsSaved")
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                }
                
                if (coins <= 200) {
                    
                    failed_purchased()
                    
                }
                
                
                
                
                
                
                
                
                
                if (purchased_ball_5){
                    
                    currentball.position = CGPoint(x: ball_5.position.x, y: ball_5.position.y)
                    
                    GameConstants.StringConstant.currentBallIdentity = "YellowBall"
                    
                    defaults.set(5, forKey: "currentBallNumber")
                    
                    currentBallNumber = 5
                    
                    
                    
                    
                    
                    
                    
                    
                    
                }
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
            }
            
            if nodeITapped.name == "ball_6"
                
            {
                
                
                
                
                
                
                
                
                
                if (coins >= 200 && !purchased_ball_6){
                    
                    defaults.set(true, forKey: "purchased_ball_6")
                    
                    defaults.set(6, forKey: "currentBallNumber")
                    
                    purchased_ball_6 = true
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    deleteCoin()
                    
                    ball_6.texture = SKTexture(imageNamed: "ball_6_unlock")
                    
                    previousCoins = coins
                    
                    coins -= 200
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    decrementLabel(to: 200 )
                    
                    defaults.set(coins, forKey: "coinsSaved")
                    
                    
                    
                    
                    
                    
                    
                    
                    
                }
                
                if (coins <= 200) {
                    
                    failed_purchased()
                    
                }
                
                
                
                
                
                if (purchased_ball_6){
                    
                    currentball.position = CGPoint(x: ball_6.position.x, y: ball_6.position.y)
                    
                    GameConstants.StringConstant.currentBallIdentity = "BlueBall"
                    
                    defaults.set(6, forKey: "currentBallNumber")
                    
                    currentBallNumber = 6
                    
                }
                
                
                
                
                
                
                
                
                
            }
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            if nodeITapped.name == "ball_7"
                
            {
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                if (coins >= 200 && !purchased_ball_7){
                    
                    defaults.set(true, forKey: "purchased_ball_7")
                    
                    defaults.set(7, forKey: "currentBallNumber")
                    
                    purchased_ball_7 = true
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    deleteCoin()
                    
                    ball_7.texture = SKTexture(imageNamed: "ball_7_unlock")
                    
                    previousCoins = coins
                    
                    coins -= 200
                    
                    decrementLabel(to: 200 )
                    
                    defaults.set(coins, forKey: "coinsSaved")
                    
                }
                
                if (coins <= 200) {
                    
                    failed_purchased()
                    
                }
                
                
                
                
                
                
                
                
                
                if (purchased_ball_7){
                    
                    currentball.position = CGPoint(x: ball_7.position.x, y: ball_7.position.y)
                    
                    GameConstants.StringConstant.currentBallIdentity = "PinkBall"
                    
                    defaults.set(7, forKey: "currentBallNumber")
                    
                    currentBallNumber = 7
                    
                }
                
                
                
                
                
                
                
                
                
            }
            
            if nodeITapped.name == "ball_8"
                
            {
                
                
                
                
                
                
                
                
                
                if (coins >= 200 && !purchased_ball_8){
                    
                    defaults.set(true, forKey: "purchased_ball_8")
                    
                    defaults.set(8, forKey: "currentBallNumber")
                    
                    purchased_ball_8 = true
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    ball_8.texture = SKTexture(imageNamed: "ball_8_unlock")
                    
                    previousCoins = coins
                    
                    coins -= 200
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    decrementLabel(to: 200 )
                    
                    defaults.set(coins, forKey: "coinsSaved")
                    
                }
                
                if (coins <= 200) {
                    
                    failed_purchased()
                    
                }
                
                
                
                
                
                
                
                
                
                if (purchased_ball_8){
                    
                    currentball.position = CGPoint(x: ball_8.position.x, y: ball_8.position.y)
                    
                    GameConstants.StringConstant.currentBallIdentity = "PurpleBall"
                    
                    defaults.set(8, forKey: "currentBallNumber")
                    
                    currentBallNumber = 8
                    
                }
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
            }
            
            if nodeITapped.name == "ball_9"
                
            {
                
                
                
                
                
                if (coins >= 200 && !purchased_ball_9){
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    ball_9.texture = SKTexture(imageNamed: "ball_9_unlock")
                    
                    previousCoins = coins
                    
                    coins -= 200
                    
                    defaults.set(true, forKey: "purchased_ball_9")
                    
                    defaults.set(9, forKey: "currentBallNumber")
                    
                    purchased_ball_9 = true
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    decrementLabel(to: 200 )
                    
                    defaults.set(coins, forKey: "coinsSaved")
                    
                }
                
                
                
                
                
                if (coins <= 200) {
                    
                    failed_purchased()
                    
                }
                
                
                
                
                
                
                
                
                
                if (purchased_ball_9){
                    
                    currentball.position = CGPoint(x: ball_9.position.x, y: ball_9.position.y)
                    
                    GameConstants.StringConstant.currentBallIdentity = "TurquoiseBall"
                    
                    defaults.set(9, forKey: "currentBallNumber")
                    
                    currentBallNumber = 9
                    
                }
                
            }
            
            
            
            
            
            if nodeITapped.name == "ball_10" {
                
                
                
                
                
                if (coins >= 500 && !purchased_ball_10){
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    ball_10.texture = SKTexture(imageNamed: "ball_10_unlock")
                    
                    previousCoins = coins
                    
                    coins -= 500
                    
                    defaults.set(true, forKey: "purchased_ball_10")
                    
                    defaults.set(10, forKey: "currentBallNumber")
                    
                    purchased_ball_10 = true
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    decrementLabel(to: 500 )
                    
                    defaults.set(coins, forKey: "coinsSaved")
                    
                }
                
                
                
                
                
                if (coins <= 500) {
                    
                    failed_purchased()
                    
                }
                
                
                
                
                
                if (purchased_ball_10){
                    
                    currentball.position = CGPoint(x: ball_10.position.x, y: ball_10.position.y)
                    
                    GameConstants.StringConstant.currentBallIdentity = "ball_10"
                    
                    defaults.set(10, forKey: "currentBallNumber")
                    
                    currentBallNumber = 10
                    
                }
                
                
                
                
                
            }
            
            
            
            
            
            if nodeITapped.name == "ball_11" {
                
                
                
                
                
                if (coins >= 500 && !purchased_ball_11){
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    ball_11.texture = SKTexture(imageNamed: "ball_11_unlock")
                    
                    previousCoins = coins
                    
                    coins -= 500
                    
                    defaults.set(true, forKey: "purchased_ball_11")
                    
                    defaults.set(11, forKey: "currentBallNumber")
                    
                    purchased_ball_11 = true
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    decrementLabel(to: 500 )
                    
                    defaults.set(coins, forKey: "coinsSaved")
                    
                    
                    
                    
                    
                }
                
                
                
                
                
                if (coins <= 500) {
                    
                    failed_purchased()
                    
                }
                
                
                
                
                
                if (purchased_ball_11){
                    
                    
                    
                    
                    
                    currentball.position = CGPoint(x: ball_11.position.x, y: ball_11.position.y)
                    
                    GameConstants.StringConstant.currentBallIdentity = "ball_11"
                    
                    defaults.set(11, forKey: "currentBallNumber")
                    
                    currentBallNumber = 11
                    
                    
                    
                    
                    
                }
                
            }
            
            
            
            
            
            
            
            
            
            if nodeITapped.name == "ball_12" {
                
                
                
                
                
                if (coins >= 500 && !purchased_ball_12){
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    ball_12.texture = SKTexture(imageNamed: "ball_12_unlock")
                    
                    previousCoins = coins
                    
                    coins -= 500
                    
                    defaults.set(true, forKey: "purchased_ball_12")
                    
                    defaults.set(12, forKey: "currentBallNumber")
                    
                    purchased_ball_12 = true
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    decrementLabel(to: 500 )
                    
                    defaults.set(coins, forKey: "coinsSaved")
                    
                    
                    
                    
                    
                }
                
                
                
                
                
                if (coins <= 500) {
                    
                    failed_purchased()
                    
                }
                
                
                
                
                
                
                
                
                
                if (purchased_ball_12){
                    
                    currentball.position = CGPoint(x: ball_12.position.x, y: ball_12.position.y)
                    
                    GameConstants.StringConstant.currentBallIdentity = "ball_12"
                    
                    defaults.set(12, forKey: "currentBallNumber")
                    
                    currentBallNumber = 12
                    
                    
                    
                    
                    
                    
                    
                    
                    
                }
                
                
                
                
                
            }
            
            
            
            
            
            
            
            
            
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

//  Copyright © 2019 Carter Stambaugh. All rights reserved.
import Foundation

import SpriteKit

import AVFoundation

//import GoogleMobileAds

var prevGameLevel = gameLevel





class GameOverScene: SKScene {
    

    private func initializePlayer() -> AVAudioPlayer? {
        guard let path = Bundle.main.path(forResource: "gameOverMusic", ofType: "wav") else {
            return nil
        }

        return try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
    }
    

    

    

    var coins = defaults.integer(forKey: "coinsSaved")
    

    var firePowerUps = defaults.integer(forKey: "firePowerUps")
    

    

    

    let restartLabel = SKSpriteNode(imageNamed: "RestartOver")
    

    let continuePlaying = SKSpriteNode(imageNamed: "ContinuePlaying")
    let continuePlayingText = SKLabelNode(fontNamed: "TheBoldFont")
    

    let noSound = SKSpriteNode(imageNamed: "noSound")
    

    let shapeLayer = CAShapeLayer()
    

    var flag: Bool = false
    

    let scoreLabel = SKLabelNode(fontNamed: "The Bold Font")
    

    let gameCoinCount = SKLabelNode(fontNamed: "TheBoldFont")
    

    let gamePowerCount = SKLabelNode(fontNamed: "TheBoldFont")
    

         let coinLabel = SKLabelNode(fontNamed: "TheBoldFont")
    

    

    

    let powerUpNumLabel = SKLabelNode(fontNamed: "TheBoldFont")
    

    let coinPic = SKSpriteNode(imageNamed: "Coin")
    

    let powerUp = SKSpriteNode(imageNamed: "firePowerUp")
    

    

    

    

    

    

    

    

    

    var previousCoins = defaults.integer(forKey: "coinsSaved")
    

    var currentAddFireUp = defaults.integer(forKey: "AddFire")
    

    //var contiuneADD : GADRewardBasedVideoAd!
    

    //let request : GADRequest = GADRequest()
    

    

    

    override func didMove(to view: SKView) {
        

      //  continuePlayingText.text = "10 coins"
       // continuePlayingText.fontSize = 150
        prevGameLevel = gameLevel
        

       

        

        

        

        coinsNum.removeFromParent()
        

        

        

        // contiuneADD = GADRewardBasedVideoAd.sharedInstance()
        

        

        

        // contiuneADD.load(request,withAdUnitID: "ca-app-pub-8167229834723556/1382382209")
        

        // contiuneADD.delegate = self
        

        

        

        backingAudio = initializePlayer()
        

        

        backingAudio?.numberOfLoops = -1
        

        

        

        

        

        backingAudio?.play()
        

        

        

        

        

        

        

        

        

        if sound == false{
            

            

            

            

            

            backingAudio?.stop()
            

            

            

            

            

        }
        

        

        

        

        

        

        

        

        

        

        

        

        

        let background = SKSpriteNode(imageNamed: "MainMenuBackground")
        

        background.size = self.size
        

        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        

        background.zPosition = 0
        

        self.addChild(background)
        

        

        

        

        

        let gameOverLabel = SKLabelNode(fontNamed: "The Bold Font")
        

        gameOverLabel.text = "Game Over"
        

        gameOverLabel.fontSize = 120
        

        gameOverLabel.color = SKColor.clear
        

        gameOverLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.65)
        

        gameOverLabel.zPosition = 1
        

        self.addChild(gameOverLabel)
        

        

        

        

        

        

        

        

        

        coinPic.setScale(0.55)
        

        coinPic.position = CGPoint(x: self.size.width*0.6, y: self.size.height*0.903)
        

        coinPic.zPosition = 10
        

        self.addChild(coinPic)
        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        powerUp.setScale(0.6)
        

        powerUp.position = CGPoint(x: self.size.width*0.3, y: self.size.height*0.903)
        

        powerUp.zPosition = 10
        

        self.addChild(powerUp)
        

        

        

        

        

        scoreLabel.fontSize = 75
        

        scoreLabel.fontColor = SKColor.white
        

        scoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.6)
        

        scoreLabel.zPosition = 1
        

        self.addChild(scoreLabel)
        

        

        

        

        

        

        

        

        

        gameCoinCount.text = "\(coinCount )"
        

        gameCoinCount.fontSize = 52
        

        gameCoinCount.fontColor = SKColor.white
        

        gameCoinCount.isHidden = true
        

        //gameCoinCount.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        

        gameCoinCount.position = CGPoint(x: self.size.width*0.65, y: self.size.height*0.805)
        

        gameCoinCount.zPosition = 101
        

        self.addChild(gameCoinCount)
        

        

        

        

        

        gamePowerCount.fontSize = 55
        

        gamePowerCount.fontColor = SKColor.white
        

        gamePowerCount.position = CGPoint(x: self.size.width*0.4, y: self.size.height * 0.805)
        

        gamePowerCount.zPosition = 101
        

        gamePowerCount.isHidden = true
        

        self.addChild(gamePowerCount)
        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        func decrementLabel(to endValue: Int) {
            

            let duration: Double = 0.5
            

            

            

            

            

            //let duration: Double = 0.5 //seconds
            

            DispatchQueue.global().async {
                

                for i in (0 ..< (endValue + 1)) {
                    

                    let sleepTime = UInt32(duration/Double(endValue) * 1000000.0)
                    

                    usleep(sleepTime)
                    

                    DispatchQueue.main.async {
                        

                        self.gameCoinCount.text = " \(coinCount - i)"
                        

                    }
                    

                }
                

            }
            

        }
        

        

        

        

        

        func incrementLabel(to endValue: Int) {
            

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
                        

                        self.scoreLabel.text = "Score: \(i)"
                        

                    }
                    

                }
                

            }
            

        }
        

        if gameLevel != 1{
            

            incrementLabel(to: gameLevel - 1)
            

            

            

            

            

            

            

            

            

        }
            

        else{
            

            scoreLabel.text = "Score: 0"
            

        }
        

        

        

        

        

        

        

        

        

        func incrementtotalCoin(to endValue: Int) {
            

            let duration: Double = 0.8
            

            

            

            

            

            

            

            

            

            //let duration: Double = 0.5 //seconds
            

            DispatchQueue.global().async {
                

                for i in 0 ..< (endValue + 1) {
                    

                    let sleepTime = UInt32(duration/Double(endValue) * 1000000.0)
                    

                    usleep(sleepTime)
                    

                    DispatchQueue.main.async {
                        

                        coinsNum.text = " \(self.coins - coinCount + i)"
                        

                    }
                    

                }
                

            }
            

        }
        

        

        

        

        

        

        

        

        

        

        

        

        

        func incrementtotalFire(to endValue: Int) {
            

            let duration: Double = 0.8
            

            

            

            

            

            

            

            

            

            //let duration: Double = 0.5 //seconds
            

            DispatchQueue.global().async {
                

                for i in 0 ..< (endValue + 1) {
                    

                    let sleepTime = UInt32(duration/Double(endValue) * 1000000.0)
                    

                    usleep(sleepTime)
                    

                    DispatchQueue.main.async {
                        

                        self.powerUpNumLabel.text = " \(self.firePowerUps - powerUpCount + i)"
                        

                    }
                    

                }
                

            }
            

        }
        

        

        

        

        

        

        

        

        

        func decrementFireLabel(to endValue: Int) {
            

            let duration: Double = 0.8
            

            

            

            

            

            

            

            

            

            //let duration: Double = 0.5 //seconds
            

            DispatchQueue.global().async {
                

                for i in (0 ..< (endValue + 1)) {
                    

                    let sleepTime = UInt32(duration/Double(endValue) * 1000000.0)
                    

                    usleep(sleepTime)
                    

                    DispatchQueue.main.async {
                        

                        self.gamePowerCount.text = " \(powerUpCount - i)"
                        

                    }
                    

                }
                

            }
            

        }
        

        

        

        

        

        let defaults = UserDefaults()
        

        var highScoreNumber = defaults.integer(forKey: "highScoreSaved")
        

        if gameLevel > highScoreNumber{
            

            highScoreNumber = gameLevel
            

            defaults.set(highScoreNumber, forKey: "highScoreSaved")
            

        }
        

        let highScoreLabel = SKLabelNode(fontNamed: "The Bold Font")
        

        highScoreLabel.text = "High Score: \(highScoreNumber)"
        

        highScoreLabel.fontSize = 75
        

        highScoreLabel.color = SKColor.white
        

        highScoreLabel.zPosition = 1
        

        highScoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.55)
        

        self.addChild(highScoreLabel)
        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        coinsNum.text = " \(coins - coinCount)"
        

        coinsNum.fontSize = 65
        

        coinsNum.color = SKColor.white
        

        coinsNum.zPosition = 1
        

        

        

        

        

        coinsNum.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        

        coinsNum.position =  CGPoint(x: self.size.width*0.77, y:  self.size.height*0.89)
        

        self.addChild(coinsNum)
        

        

        

        

        

        if (coinCount > 0){
            

            incrementtotalCoin(to: coinCount )
            

            decrementLabel(to: coinCount)
            

        }
        

        if (firePowerUps >= powerUpCount){
            

            powerUpNumLabel.text = "\(firePowerUps - powerUpCount)"
            

        }
            

        else{
            

            powerUpNumLabel.text = "0"
            

        }
        

        powerUpNumLabel.fontSize = 65
        

        powerUpNumLabel.fontColor = SKColor.white
        

        powerUpNumLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        

        powerUpNumLabel.position = CGPoint(x: self.size.width * 0.4, y: self.size.height*0.89)
        

        powerUpNumLabel.zPosition = 101
        

        

        

        

        

        self.addChild(powerUpNumLabel)
        

        

        

        

        

        

        

        

        

        if (powerUpCount > 0){
            

            incrementtotalFire(to: powerUpCount )
            

            decrementFireLabel(to: powerUpCount)
            

        }
        

        

        

        

        

        

        

        

        

        let mainMenuOver = SKSpriteNode(imageNamed: "MainMenuOver")
        

        mainMenuOver.setScale(1.4)
        

        mainMenuOver.zPosition = 4
        

        mainMenuOver.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.41)
        

        mainMenuOver.name = "mainMenuOver"
        

        self.addChild(mainMenuOver)
        

        

        

        

        

        restartLabel.setScale(1.4)
        

        restartLabel.zPosition = 1
        

        restartLabel.name = "RestartOver"
        

        restartLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.48)
        

        self.addChild(restartLabel)
        

        

        

        

        

        continuePlaying.setScale(1.3)
        

        continuePlaying.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.28)
        

        continuePlaying.zPosition = 1
        

        continuePlaying.name = "ContinuePlaying"
        

        self.addChild(continuePlaying)
        

   

        coinLabel.position = CGPoint(x: continuePlaying.position.x, y: self.size.height*0.15)
        coinLabel.zPosition = 20
        coinLabel.text = "10 COINS"
        coinLabel.fontSize = 60
        coinLabel.isHidden = false
        self.addChild(coinLabel)
        

        

        continuePlayingText.position = CGPoint(x: continuePlaying.position.x, y: continuePlaying.position.y - 110)
        

        continuePlayingText.fontSize = 20
        

        continuePlayingText.zPosition = 20
        

        self.addChild(continuePlayingText)
        

        

        shapeLayer.zPosition = 20
        

        

        

        

        

        

        

        

        

        let center = CGPoint(x: view.center.x, y: view.center.y*1.44) //view.center CGPoint(x: self.size.width*0.5, y: self.size.height*0.20)
        

        let circularPath = UIBezierPath(arcCenter: center, radius: continuePlaying.size.width / 4.82, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        

        shapeLayer.path = circularPath.cgPath
        

        shapeLayer.strokeEnd = 0
        

        shapeLayer.strokeColor = UIColor.continueLineTrace.cgColor
        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        if arenaNum == 2 {
            

            shapeLayer.strokeColor = UIColor.waterLineContinueTrace.cgColor
            

        }
        

        

        

        

        

        shapeLayer.lineWidth = 8.0
        

        shapeLayer.zPosition = 100
        

        shapeLayer.fillColor = UIColor.clear.cgColor
        

        shapeLayer.lineCap = CAShapeLayerLineCap.round
        

        shapeLayer.name = "fuck"
        

        view.layer.addSublayer(shapeLayer)
        

        

        

        

        

        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        

        basicAnimation.toValue = 1
        

        basicAnimation.duration = 4.20
        

        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        

        basicAnimation.isRemovedOnCompletion = false
        

        delay(0.5){
            

            self.shapeLayer.add(basicAnimation, forKey: "basic")
            

        }
        

        

        

        

        

        delay(3.7){
            

            self.shapeLayer.removeFromSuperlayer()
            

            self.continuePlaying.removeFromParent()
            self.continuePlayingText.removeFromParent()
            self.loadItems()
            

            self.flag = true
            

        }
        

        

        

        

        

        

        

        

        

        if (arenaNum == 2){
            

            background.texture = SKTexture(imageNamed: "WaterBackground")
            

        }
        

        

        

        

        

        

        

        

        

        if (arenaNum == 3){
            

            background.texture = SKTexture(imageNamed: "FireBackground")
            

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
    

    

    

    

    

    

    

    

    

    

    

    

    

    

    

    

    

    func loadItems(){
        

        

        

        

        

      

        

        coinLabel.isHidden = true
        

        

        

        

        

        

        

       // gameLevel = 1
        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        let noAdds = SKSpriteNode(imageNamed: "ThumbsUp")
        

        noAdds.setScale(0.9)
        

        noAdds.position = CGPoint(x: self.size.width*0.7, y:self.size.height*0.3)
        

        noAdds.zPosition = 1
        

        noAdds.name = "NoAdds"
        

        self.addChild(noAdds)
        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        let moreBall = SKSpriteNode(imageNamed: "MoreBall")
        

        moreBall.setScale(0.9)
        

        moreBall.position = CGPoint(x: self.size.width*0.56, y:self.size.height*0.3)
        

        moreBall.zPosition = 1
        

        moreBall.name = "moreBall"
        

        self.addChild(moreBall)
        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        let scoreBoard = SKSpriteNode(imageNamed: "scoreboard")
        

        scoreBoard.setScale(0.8)
        

        scoreBoard.position = CGPoint(x: self.size.width*0.43, y: self.size.height*0.3)
        

        scoreBoard.zPosition = 1
        

        scoreBoard.name = "scoreBoard"
        

        self.addChild(scoreBoard)
        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        if sound == false{
            

            noSound.texture = SKTexture(imageNamed: "PlayMusic")
            

            

            

            

            

            

            

            

            

            

            

            

            

            

            

            

            

            

            

            

            

            

            

            

            

            

            

            

            

            

            

            

            

        }
        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        noSound.setScale(0.8)
        

        noSound.name = "mute"
        

        noSound.position = CGPoint(x: self.size.width*0.30, y: self.size.height*0.3)
        

        noSound.zPosition = 1
        

        self.addChild(noSound)
        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

        

    }
    

    

    

    

    

    

    

    

    

    

    

    

    

    

    

    

    

    

    

    

    

    

    

    

    

    

    

    

    

    

    

    

    

    func delay(_ delay:Double, closure:@escaping ()->()) {
        

        let when = DispatchTime.now() + delay
        

        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
        

    }
    

    

    

    

    

    

    

    

    

    

    

    

    

    

    

    

    

    

    

    

    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        

        for touch: AnyObject in touches{
            

            

            

            

            

            

            

            

            

            

            

            

            

            

            

            

            

            let pointOfTouch = touch.location(in: self)
            

            let nodeITapped = atPoint(pointOfTouch)
            

            

            

            

            

            

            

            

            

            if nodeITapped.name == "mainMenuOver"
                

            {
                

                gameLevel = 1
                prevGameLevel = 1
                

                coinsNum.removeFromParent()
                

                shapeLayer.removeFromSuperlayer()
                

                self.continuePlaying.removeFromParent()
                self.continuePlayingText.removeFromParent()
                let sceneToMoveTo = MainMenuScene(size: self.size)
                

                sceneToMoveTo.scaleMode = self.scaleMode
                

                let myTransition = SKTransition.fade(withDuration: 0.5)
                

                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
                

                

                

                

                

                

                

                

                

            }
            

            

            

            

            

            

            

            

            

            

            

            

            

            if restartLabel.contains(pointOfTouch)
                

            {
                

                coinsNum.removeFromParent()
                

                ContinuePlaying = false
                

                shapeLayer.removeFromSuperlayer()
                

                self.continuePlaying.removeFromParent()
                self.continuePlayingText.removeFromParent()
                let sceneToMoveTo = NewLevelScene(size: self.size)
                

                sceneToMoveTo.scaleMode = self.scaleMode
                

                gameLevel = 1
                prevGameLevel = 1
                gameDifficulty = 1
                

                numOfInitDef = 1
                

                arenaNum = 1
                

                //firePowerUps = 0
                

                coinCount = 0
                

                powerUpCount = 0
                

                let myTransition = SKTransition.fade(withDuration: 0.5)
                

                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
                

            }
            

            

            

            

            

            

            

            

            

            

            

            

            

            if continuePlaying.contains(pointOfTouch) && flag == false && defaults.integer(forKey: "coinsSaved") >= 10
                

            {
                

                

                coins = coins - 10
                defaults.set(coins, forKey: "coinsSaved")
            //coinsNum.removeFromParent()
                

             coinsNum.removeFromParent()
             

             ContinuePlaying = true
             

             shapeLayer.removeFromSuperlayer()
             

             self.continuePlaying.removeFromParent()
             self.continuePlayingText.removeFromParent()
             gameLevel = prevGameLevel
             let sceneToMoveTo = NewLevelScene(size: self.size)
             

             sceneToMoveTo.scaleMode = self.scaleMode
         

             

        

            

             

             let myTransition = SKTransition.fade(withDuration: 0.5)
             

             self.view!.presentScene(sceneToMoveTo, transition: myTransition)
                

                

                

                

                

                

                

                

                

                

                

                

                

            }
            

            

            

            

            

            

            

            

            

            if nodeITapped.name == "info"
                

            {
                

                backingAudio?.stop()
                

                let sceneToMoveTo = HowToPlay(size: self.size)
                

                sceneToMoveTo.scaleMode = self.scaleMode
                

                let myTransition = SKTransition.fade(withDuration: 0.5)
                

                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
                

            }
            

            

            

            

            

            

            

            

            

            if nodeITapped.name == "NoAdds" {
                

                

                

                

                

                let va = self.view?.window?.rootViewController
                

                

                

                

                

                let urlString = NSURL(string: "https://apps.apple.com/us/app/GOAL.Z/id1473082797")
                

                let object = [urlString]
                

                

                

                

                

                let activityVC:UIActivityViewController = UIActivityViewController(activityItems: object as [Any], applicationActivities: nil)
                

                

                

                

                

                va?.present(activityVC, animated: true, completion: nil)
                

            }
            

            

            

            

            

            

            

            

            

            

            

            

            

            

            

            

            

            

            

            

            

            

            

            

            

            

            

            

            

            

            

            

            

            

            

            

            

            

            

            

            

            

            

            

            

            

            

            

            

            

            

            

            

            if nodeITapped.name == "moreBall"
                

            {
                

                coinsNum.removeFromParent()
                

                backingAudio?.stop()
                

                let sceneToMoveTo = CoinStore(size: self.size)
                

                sceneToMoveTo.scaleMode = self.scaleMode
                

                let myTransition = SKTransition.fade(withDuration: 0.5)
                

                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
                

            }
            

            

            

            

            

            /*   if nodeITapped.name == "ContinuePlaying" {
             
             
             
             
             
             if (videoAd.isReady){
             
             print("yoyoyo")
             
             
             
             NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showVideoRewardAd"), object: nil)
             
             }
             
             
             
             }*/
            

            if nodeITapped.name == "fuck" {
                

                

                

                

                

                

                

                

                

                

                

                

                

                // if (videoAd.isReady){
                

                //  NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showVideoRewardAd"), object: nil)
                

                //}
                

                

                

                

                

            }
            

            

            

            

            

            

            

            

            

            

            

            if nodeITapped.name == "scoreBoard"
                

            {
                

                backingAudio?.stop()
                

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

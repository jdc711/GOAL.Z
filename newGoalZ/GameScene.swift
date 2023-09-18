//
//  GameScene.swift
//  GOALZ
//  Created by Carter Stambaugh on 7/15/19.
//  Copyright © 2019 Carter Stambaugh. All rights reserved.
import SpriteKit
import GameplayKit
import AVFoundation
import CoreGraphics

var gameLevel = 1
var coinCount = 0
var powerUpCount = 0
var gameDifficulty = 1
var gameOver = 1
var health = 3
var arenaNum = 1
var numOfInitDef = 1
var totalDef = 1
var Continue: Bool = false
var ContinuePlaying: Bool = false
var coinsNum = SKLabelNode(fontNamed: "The Bold Font")

var switchDirection: Bool = false
var firstWallHit: Bool = false

enum gameState{
    case paused  //paused
    case beforeGame
    case inGame  //durning the game
    case afterGame //after the game
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    let gameArea: CGRect
    var shotBall: Bool = false
    var coins = defaults.integer(forKey: "coinsSaved")
    var firePowerUps = defaults.integer(forKey: "firePowerUps")
    
    
    
    override init(size: CGSize) {
        let maxAspectRatio: CGFloat = 16.0/9.0
        let playableWidth = size.height / maxAspectRatio
        let margin = (size.width - playableWidth)/2
        gameArea = CGRect (x: margin, y: 0, width: playableWidth, height: size.height)
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var projectileIsDragged = false
    var touchCurrentPoint: CGPoint!
    var touchStartingPoint: CGPoint!
    var wallCollisionNum = 0
    var outerpostCollisionNum = 0
    var touchedOuterPost: Bool = false
    var touchedGoal: Bool = false
    var touchedInnerPost: Bool = false
    var currentlyOnFire: Bool = false //whether or not user is currently using firePowerUp; allows fire image to rotate in direction of ball's trajectory
    var inSafetyArea: Bool = false
    var fireLoc1 = CGPoint() //to find angle fire image needs to rotate
    var fireLoc2 = CGPoint() //same thing ^
    
    
    
    
    
    
    struct Settings {
        struct Metrics {
            static var projectileRadius = CGFloat()
            static var projectileRestPosition = CGPoint()
            static let projectileTouchThreshold = CGFloat(200)
            static let projectileSnapLimit = CGFloat(10)
            static var forceMultiplier = CGFloat(40.0)
            static let rLimit = CGFloat(50)
        }
        struct Game {
            static let gravity = CGVector(dx: 0,dy: 0)
        }
    }
    
    
    struct physicsCategories{
        static let None : UInt32 = 0
        static let ball : UInt32 = 0b1
        static let goal : UInt32 = 0b10
        static let vertPost1 : UInt32 = 0b100
        static let vertPost2 : UInt32 = 0b1000
        static let horiPost : UInt32 =      0b10000
        static let leftBorder : UInt32 =    0b100000
        static let rightBorder : UInt32 =   0b1000000
        static let defender : UInt32 =      0b10000000
        static let topBorder : UInt32 =     0b100000000
        static let bottomBorder : UInt32 =  0b1000000000
        static let QuickGoal : UInt32 =     0b10000000000
        static let outerPost1 : UInt32 =    0b100000000000
        static let outerPost2 : UInt32 =    0b1000000000000
        static let fire : UInt32 =          0b10000000000000
        static let useFireButton : UInt32 = 0b100000000000000
        static let bubble : UInt32 = 0b1000000000000000
        static let useBubbleButton : UInt32 = 0b10000000000000000
        static let rock : UInt32 =            0b100000000000000000
        static let SafetyArea : UInt32 =      0b1000000000000000000
        static let coin : UInt32 = 0b10000000000000000000
        static let blackHole : UInt32 = 0b100000000000000000000
        static let metior : UInt32 =    0b1000000000000000000000
        static let resistantDefender : UInt32 =    0b10000000000000000000000
    }
    
    
    
    
    
    
    
    
    let GameBall = SKSpriteNode(imageNamed: GameConstants.StringConstant.currentBallIdentity)
    let GameGoal = SKSpriteNode(imageNamed: "Goal")
    let horizontalPost = SKNode()
    let verticalPost1 = SKNode()
    let verticalPost2 = SKNode()
    let outerPost1 = SKNode()
    let outerPost2 = SKNode()
    let leftBorder = SKNode()
    let rightBorder = SKNode()
    let gameScoreLabel = SKLabelNode(fontNamed: "The Bold Font")
    let powerUpNumLabel = SKLabelNode(fontNamed: "The Bold Font")
    let PausedTitle = SKLabelNode(fontNamed: "TheBoldFont")
    let scored = SKSpriteNode(imageNamed: "Scored")
    let gameCoinCount = SKLabelNode(fontNamed: "TheBoldFont")
    let gamePowerCount = SKLabelNode(fontNamed: "TheBoldFont")
    let resume = SKSpriteNode(imageNamed: "Continue")
    let restart = SKSpriteNode(imageNamed: "RestartOver")
    let mainMenu = SKSpriteNode(imageNamed: "MainMenuOver")
    let pauseButton = SKSpriteNode(imageNamed: "PauseButton")
    let noSound = SKSpriteNode(imageNamed: "noSound")
    let noAdds = SKSpriteNode(imageNamed:"ThumbsUp")
    let ThumbsUp = SKSpriteNode(imageNamed: "ThumbsUp")
    let topBorder = SKNode()
    let bottomBorder = SKNode()
    let startingLine = SKSpriteNode(imageNamed: "StartingLine")
    let GoalLine = SKSpriteNode(imageNamed: "StartingLine")
    let yard_Box = SKSpriteNode(imageNamed: "18yard_box")
    let sixBox = SKSpriteNode(imageNamed: "sixBox")
    let sideLineLeft = SKSpriteNode(imageNamed: "sideLine")
    let sideLineRight = SKSpriteNode(imageNamed: "sideLine")
    let endline = SKSpriteNode(imageNamed: "StartingLine")
    let circle = SKSpriteNode(imageNamed: "Circle")
    let Missed = SKSpriteNode(imageNamed: "Missed")
    let dashedLine = SKSpriteNode(imageNamed: "speed1")
    let useFirePowerUp = SKSpriteNode(imageNamed: "firePowerUp")
    let wallSound =
        SKAction.playSoundFileNamed("wallSound.wav", waitForCompletion: false)
    let postSound = SKAction.playSoundFileNamed("postSound.wav", waitForCompletion: false)
    let flameSound = SKAudioNode(fileNamed:"flame.wav")
    let explosionSound = SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: false)
    let bubbleSound = SKAction.playSoundFileNamed("bubbleSound1.wav", waitForCompletion: true)
    let bubbleHitDefSound = SKAction.playSoundFileNamed("bubbleHitDefSound.wav", waitForCompletion: false)
    let coinSound = SKAction.playSoundFileNamed("coinSound.wav", waitForCompletion: false)
    let safetyAreaSound = SKAction.playSoundFileNamed("safetyArea.wav", waitForCompletion: false)
 
    let scoreBoard = SKSpriteNode(imageNamed: "scoreboard")
    let moreBall = SKSpriteNode(imageNamed: "MoreBall")
    let coinPic = SKSpriteNode(imageNamed: "Coin")
    
    let lives1 = SKSpriteNode(imageNamed: "Lives")
    let lives2 = SKSpriteNode(imageNamed: "Lives")
    let lives3 = SKSpriteNode(imageNamed: "Lives")
    
    

    
    
    func random() ->CGFloat {
        return CGFloat(Float(arc4random()) / 4294967296)
    }
    
    
    
    
    
    
    
    
    func random(min: CGFloat, max: CGFloat ) -> CGFloat{
        return random() * (max - min) + min
    }
    
    
    
    
    
    
    
    
    var lastUpdateTime:TimeInterval = 0
    var deltaFrameTime:TimeInterval = 0
    var amountToMovePerSec: CGFloat = 600.0
    
    
    
    
    
    
    
    
    override func update(_ currentTime: TimeInterval){
        if (arenaNum == 4){
            
            
            
            
            
            
            
            
            if lastUpdateTime == 0{
                lastUpdateTime = currentTime
            }
            else {
                deltaFrameTime = currentTime - lastUpdateTime
                lastUpdateTime = currentTime
            }
            let amountToMoveBackground = amountToMovePerSec * CGFloat(deltaFrameTime)
            self.enumerateChildNodes(withName: "Background"){
                background, stop in
                if currentGameState == gameState.inGame{
                    background.position.y -= amountToMoveBackground
                }
                if background.position.y < -self.size.height{
                    background.position.y += self.size.height * 2
                }
            }
        }
        
        
        
        
        
        
        
        
    }
    
    
    
    
    
    private func initializePlayer1() -> AVAudioPlayer? {
        guard let path = Bundle.main.path(forResource: "goalztheme1", ofType: "wav") else {
            return nil
        }

        return try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
    }
    private func initializePlayer2() -> AVAudioPlayer? {
        guard let path = Bundle.main.path(forResource: "waterMusic", ofType: "wav") else {
            return nil
        }

        return try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
    }
    private func initializePlayer3() -> AVAudioPlayer? {
        guard let path = Bundle.main.path(forResource: "lavatheme", ofType: "wav") else {
            return nil
        }

        return try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
    }
    private func initializePlayer4() -> AVAudioPlayer? {
        guard let path = Bundle.main.path(forResource: "mainSongbetter", ofType: "wav") else {
            return nil
        }

        return try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
    }
    
    
    
    override func didMove(to view: SKView) {
       
        self.enumerateChildNodes(withName: "coinsNum"){
            (coinNum, stop) in
            coinNum.removeFromParent()
            
            
        }
        
        coins = defaults.integer(forKey: "coinsSaved")
        
        
        // print (GameBall.size)
        coinsNum.isHidden = false
        prevGameLevel = gameLevel
        if (gameLevel < 26){
            arenaNum = 1
            
            
        }
        if (gameLevel >= 26 && gameLevel < 51){
            arenaNum = 2
            
            
           
            
        }
        if (gameLevel >= 51 && gameLevel < 75){
            arenaNum = 3
            
            
            
            
            
            
            
            
        }
        if (gameLevel >= 75 && gameLevel < 101){
            arenaNum = 4
        }
        
        
        
        

       
        
        
        
        
        currentGameState = gameState.inGame
        
        
        // firePowerUps = 10
        GameBall.scale(to: CGSize(width: 58, height: 58))
        
        
        
        
        
        
        
        
        if (currentBallNumber == 2){
            GameConstants.StringConstant.currentBallIdentity = "OrangeBall"
            
            
            
            
            
            
            
            
        }
        else if (currentBallNumber == 3){
            GameConstants.StringConstant.currentBallIdentity = "GreenBall"
            
            
            
            
            
            
            
            
        }
        else if (currentBallNumber == 4){
            GameConstants.StringConstant.currentBallIdentity = "RedBall"
            
            
            
            
            
            
            
            
        }
        else if (currentBallNumber == 5){
            GameConstants.StringConstant.currentBallIdentity = "YellowBall"
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
        }
        else if (currentBallNumber == 6){
            GameConstants.StringConstant.currentBallIdentity = "BlueBall"
            
            
            
            
            
            
            
            
        }
        else if (currentBallNumber == 7){
            GameConstants.StringConstant.currentBallIdentity = "PinkBall"
            
            
            
            
        }
        else if (currentBallNumber == 8){
            GameConstants.StringConstant.currentBallIdentity = "ball_8"
            
            
            
            
        }
        else if (currentBallNumber == 9){
            GameConstants.StringConstant.currentBallIdentity = "ball_9"
            
            
            
            
            
            
            
            
        }
        else if (currentBallNumber == 10){
            GameConstants.StringConstant.currentBallIdentity = "ball_10"
            
            
            
            
            
            
            
            
        }
        else if (currentBallNumber == 11){
            GameConstants.StringConstant.currentBallIdentity = "ball_11"
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
        }
        else if (currentBallNumber == 12){
            GameConstants.StringConstant.currentBallIdentity = "ball_12"
            
            
            
            
            
            
            
            
        }
        else if (currentBallNumber == 13){
            GameConstants.StringConstant.currentBallIdentity = "ball_13"
            
            
            
            
            
            
            
            
        }
        else if (currentBallNumber == 14){
            GameConstants.StringConstant.currentBallIdentity = "ball_14"
            
            
            
            
            
            
            
            
        }
        else if (currentBallNumber == 15){
            GameConstants.StringConstant.currentBallIdentity = "ball_15"
            
            
            
            
            
            
            
            
        }
        else if (currentBallNumber == 16){
            GameConstants.StringConstant.currentBallIdentity = "ball_16"
            
            
            
            
            
            
            
            
        }
        else if (currentBallNumber == 17){
            GameConstants.StringConstant.currentBallIdentity = "ball_17"
            
            
            
            
            
            
            
            
        }
        else if (currentBallNumber == 18){
            GameConstants.StringConstant.currentBallIdentity = "ball_18"
            
            
            
            
            
            
            
            
        }
        else if (currentBallNumber == 19){
            GameConstants.StringConstant.currentBallIdentity = "ball_19"
            
            
            
            
            
            
            
            
        }
        else if (currentBallNumber == 20){
            GameConstants.StringConstant.currentBallIdentity = "ball_20"
            
            
            
            
            
            
            
            
        }
        else if (currentBallNumber == 21){
            GameConstants.StringConstant.currentBallIdentity = "ball_21"
            
            
            
            
            
            
            
            
        }
        else if (currentBallNumber == 22){
            GameConstants.StringConstant.currentBallIdentity = "ball_22"
            
            
            
            
            
            
            
            
        }
        else if (currentBallNumber == 23){
            GameConstants.StringConstant.currentBallIdentity = "ball_23"
            
            
            
            
            
            
            
            
        }
        else if (currentBallNumber == 24){
            GameConstants.StringConstant.currentBallIdentity = "ball_24"
            
            
            
            
            
            
            
            
        }
        else if (currentBallNumber == 25){
            GameConstants.StringConstant.currentBallIdentity = "ball_25"
            
            
            
            
            
            
            
            
        }
        else if (currentBallNumber == 26){
            GameConstants.StringConstant.currentBallIdentity = "ball_26"
            
            
            
            
            
            
            
            
        }
        else if (currentBallNumber == 27){
            GameConstants.StringConstant.currentBallIdentity = "ball_27"
            
            
            
            
            
            
            
            
        }
        else if (currentBallNumber == 28){
            GameConstants.StringConstant.currentBallIdentity = "ball_29"
            GameBall.alpha = 0
            // Coin_28_Emitter()
            
            
            
            
        }
        else if (currentBallNumber == 29){
            GameConstants.StringConstant.currentBallIdentity = "ball_29"
            // Coin_29_Emitter()
            GameBall.alpha = 0
            
            
            
            
        }
        else if (currentBallNumber == 30){
            GameConstants.StringConstant.currentBallIdentity = "ball_30"
            // Coin_30_Emitter()
            GameBall.alpha = 0
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        GameBall.texture = SKTexture(imageNamed: GameConstants.StringConstant.currentBallIdentity)
        
        
        
        
        
        
        
        
        
        
        
        
        
        if (gameLevel == 1 ){
            
            
            
            
            
            
            
            
            backingAudio = initializePlayer1()
            
            
            
            
            
            
            
            
            
            
            
            backingAudio?.numberOfLoops = -1
            
            
            
            
            
            
            
            
            backingAudio?.play()
        }
        else if (gameLevel == 26){
            
            
            backingAudio = initializePlayer2()
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            backingAudio?.numberOfLoops = -1
            backingAudio?.play()
        }
        else if (gameLevel == 51){
           
            
            backingAudio = initializePlayer3()
            
            
            
            
            
            
            
            
            
            
            
            backingAudio?.numberOfLoops = -1
            backingAudio?.play()
        }
        else if (gameLevel == 76){
           backingAudio = initializePlayer4()
            
            
            
            
            backingAudio?.numberOfLoops = -1
            backingAudio?.play()
        }
        
        
        
        
        
        
        
        
        if (ContinuePlaying){
            ContinuePlaying = false
            if (arenaNum == 1){
                backingAudio = initializePlayer1()
                
                
                
                
                
                
                backingAudio?.numberOfLoops = -1
                
                
                
                
                
                
                
                
                backingAudio?.play()
            }
            else if (arenaNum == 2){
               backingAudio = initializePlayer2()
                
                
                
                
                
                backingAudio?.numberOfLoops = -1
                
                
                
                
                
                
                
                
                backingAudio?.play()
            }
            else if (arenaNum == 3){
               backingAudio = initializePlayer3()
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                backingAudio?.numberOfLoops = -1
                
                
                
                
                
                
                
                
                backingAudio?.play()
            }
            else if (arenaNum == 4){
               backingAudio = initializePlayer4()
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                backingAudio?.numberOfLoops = -1
                
                
                
                
                
                
                
                
                backingAudio?.play()
                //circle.isHidden = true
                // sixBox.isHidden = true
                
                
                
                
                
                
                
                
            }
        }
        
        
        
        
        
        
        
        
        if sound == false{
            backingAudio?.stop()
        }
        
       
        physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = (CGVector(dx: 0, dy: 0))
        
        Settings.Metrics.projectileRestPosition = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.145)
        
        touchedOuterPost = false
        touchedGoal = false
        touchedInnerPost = false
        
        coinPic.setScale(0.25)
        coinPic.position = CGPoint(x: self.size.width*0.25, y: self.size.height*0.935)
        coinPic.zPosition = 10
        self.addChild(coinPic)
        
      
        
        coinsNum.text = " \(coins)"
        coinsNum.fontSize = 52
        coinsNum.color = SKColor.white
        coinsNum.zPosition = 1
        coinsNum.alpha = 1
        coinsNum.name = "coinsNum"
        coinsNum.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        coinsNum.position =  CGPoint(x: self.size.width*0.285, y: self.size.height*0.925)
        self.addChild(coinsNum)
        
        
        for i in 0...1 {
            let background = SKSpriteNode(imageNamed: "background")
            if (arenaNum == 1){ //black gloosy field
                background.texture = SKTexture(imageNamed: "MainMenuBackground")
            }
            if (arenaNum == 2) // water/ocean field
            {
                background.zPosition = 1
                background.texture = SKTexture(imageNamed: "WaterBackground")
            }
            if (arenaNum == 3){
                background.texture = SKTexture(imageNamed: "FireBackground")
            }
            if (arenaNum == 4){
                background.texture = SKTexture(imageNamed: "spaceBackground")
                
                
                
                
                
                
                
                
            }
            background.name = "Background"
            background.size = self.size
            background.anchorPoint = CGPoint(x: 0.5, y: 0)
            background.position = CGPoint(x: self.size.width/2, y: self.size.height * CGFloat(i))
            background.zPosition = -3
            self.addChild(background)
        }
        
      
        //set velocity of ball appropiate to the arena map
        if ( arenaNum == 2){ //in water arena, ball goes slower
            Settings.Metrics.forceMultiplier = 25
        }
        else{
            Settings.Metrics.forceMultiplier = 40.0
        }
       
        
        startingLine.setScale(1)
        startingLine.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.12)
        startingLine.zPosition = -1
        self.addChild(startingLine)
      
        startingLine.isHidden = false
        if (arenaNum == 4){
            startingLine.isHidden = true
            
            
        }
        if (arenaNum == 3){
            startingLine.isHidden = true
            
            
        }
        
        if (arenaNum == 2) {
            startingLine.isHidden = true
        }
        
        
        GoalLine.setScale(1)
        GoalLine.position = CGPoint (x: self.size.width*0.5, y: self.size.height*0.869)
        GoalLine.zPosition = -1
        
        
        if (arenaNum == 2) {
            GoalLine.texture = SKTexture(imageNamed: "stickGoalLine")
            GoalLine.size = CGSize(width: self.size.width*0.8, height: 20)
        }
        
        if (arenaNum == 3) {
            
        
            GoalLine.isHidden = true
            
            
            
        }
        
        
        
        
        
        if (arenaNum == 4){
            
            GoalLine.texture = SKTexture(imageNamed: "spaceGoalLine")
            GoalLine.size = CGSize(width: self.size.width*0.8, height: 5)
            
            let flash = SKAction.animate(with: [SKTexture(imageNamed: "spaceGoalLine"), SKTexture(imageNamed:"spaceLine2")], timePerFrame: 0.01)
            
            
            let flashing = SKAction.animate(with: [SKTexture(imageNamed: "spaceLine2"),SKTexture(imageNamed: "spaceGoalLine")], timePerFrame: 0.01)
            
            
            let seq = SKAction.sequence([flash,flashing])
            
            
            let forever = SKAction.repeatForever(seq)
            

            
            GoalLine.run(forever)
            
          
        }
        self.addChild(GoalLine)
        
        
        yard_Box.setScale(1)
        yard_Box.position = CGPoint(x: self.size.width*0.5, y: (self.size.height*0.80))
        yard_Box.zPosition = -1
        yard_Box.isHidden = false
        
        
        
        
        if (arenaNum == 1) {
            yard_Box.texture = SKTexture(imageNamed: "18yard_box")
            
            
        }
        if (arenaNum == 2){
            // yard_Box.texture = SKTexture(imageNamed: "Water18yard_box")
            yard_Box.isHidden = true
            

            
        }
            
            if (arenaNum == 3){
            yard_Box.isHidden = true
            
            
            
            
            }
            
            
    
        
        if (arenaNum == 4){
            yard_Box.isHidden = true
            
            
            
            
        }
        
        
        self.addChild(yard_Box)
        
        
        sixBox.setScale(1)
        sixBox.position = CGPoint(x: self.size.width*0.5, y: (self.size.height*0.83))
        sixBox.zPosition = -1
        sixBox.isHidden = false
        
        
        
        
        if (arenaNum == 1) {
            sixBox.texture = SKTexture(imageNamed: "sixBox")
        }
        if (arenaNum == 2){
            // sixBox.texture = SKTexture(imageNamed: "WaterSixBox")
            sixBox.isHidden = true
            sixBox.zPosition = -1
            
            
        }
            if (arenaNum == 3){
            // sixBox.texture = SKTexture(imageNamed: "WaterSixBox")
            sixBox.isHidden = true
           
            
            
            }
            
        
        
        
        
        
        
        
        
        
        if (arenaNum == 4){
            sixBox.isHidden = true
            
            
            
            
            
            
            
            
        }
        self.addChild(sixBox)
        
        
        
        
        
        
        
        
        sideLineLeft.setScale(1)
        sideLineLeft.position = CGPoint(x: 0 + 300, y: (self.size.height*0.38))
        sideLineLeft.zPosition = 2
        sideLineLeft.isHidden = false
        
        
        if (arenaNum == 2) {
            
            
            sideLineLeft.setScale(1.5)
            sideLineLeft.texture = SKTexture(imageNamed: "stickSideLineRight")
            sideLineLeft.size = CGSize(width: 60, height: self.size.height - self.size.height * 0.2)
            sideLineLeft.position = CGPoint(x: 0 + 310, y: (self.size.height*0.515))
            
            
        }
        
        if (arenaNum == 3) {
            
            
           sideLineLeft.isHidden = true
            
            
        }
        if (arenaNum == 4){
            
            
            
            
            sideLineLeft.setScale(1.5)
            sideLineLeft.texture = SKTexture(imageNamed: "spaceLine")
            sideLineLeft.size = CGSize(width: 5, height: self.size.height)
            sideLineLeft.position = CGPoint(x: 0 + 300, y: (self.size.height*0.37))
            
            
            let flash = SKAction.animate(with: [SKTexture(imageNamed: "spaceLine"), SKTexture(imageNamed:"spaceLine3")], timePerFrame: 0.01)
            
            
            let flashing = SKAction.animate(with: [SKTexture(imageNamed: "spaceLine3"),SKTexture(imageNamed: "spaceLine")], timePerFrame: 0.01)
            
            
            let seq = SKAction.sequence([flash,flashing])
            
            
            let forever = SKAction.repeatForever(seq)
            
            
            
            
            sideLineLeft.run(forever)
            
            
            let cube = SKSpriteNode(imageNamed: "cube")
            cube.setScale(0.25)
            cube.zPosition = 100
            cube.position = CGPoint(x: sideLineLeft.position.x, y: GoalLine.position.y)
            self.addChild(cube)
            
            
            
            
            
        }
        
        
        self.addChild(sideLineLeft)
        
        
        
        
        sideLineRight.setScale(1)
        sideLineRight.position = CGPoint(x: self.size.width - 300, y: (self.size.height*0.38))
        sideLineRight.zPosition = 2
        sideLineRight.isHidden = false
        
        if (arenaNum == 2) {
            
            /*
             sideLineLeft.setScale(1.5)
             sideLineLeft.texture = SKTexture(imageNamed: "stickSideLineRight")
             sideLineLeft.size = CGSize(width: 60, height: self.size.height - self.size.height * 0.2)
             sideLineLeft.position = CGPoint(x: 0 + 310, y: (self.size.height*0.515))
 */
            sideLineRight.setScale(1.5)
            sideLineRight.texture = SKTexture(imageNamed: "stickSideLineRight")
            sideLineRight.size = CGSize(width: 60, height: self.size.height - self.size.height * 0.2)
            sideLineRight.position = CGPoint(x: self.size.width - 319, y: (self.size.height*0.515))
            
            
        }
        if (arenaNum == 3) {
            
            
            sideLineRight.isHidden = true
            
            
        }
        
        
        if (arenaNum == 4){
            
            
            sideLineRight.setScale(1.5)
            sideLineRight.texture = SKTexture(imageNamed: "spaceLine")
            sideLineRight.size = CGSize(width: 5, height: self.size.height)
            sideLineRight.position = CGPoint(x: self.size.width - 310, y: (self.size.height*0.37))
            
            
            let flash = SKAction.animate(with: [SKTexture(imageNamed: "spaceLine"), SKTexture(imageNamed:"spaceLine2")], timePerFrame: 0.01)
            
            
            let flashing = SKAction.animate(with: [SKTexture(imageNamed: "spaceLine2"),SKTexture(imageNamed: "spaceLine")], timePerFrame: 0.01)
            
            
            let seq = SKAction.sequence([flash,flashing])
            
            
            let forever = SKAction.repeatForever(seq)
            
            
            
            
            sideLineRight.run(forever)
            
            
            let rightcube = SKSpriteNode(imageNamed: "cube")
            rightcube.setScale(0.25)
            rightcube.zPosition = 100
            rightcube.position = CGPoint(x: sideLineRight.position.x, y: GoalLine.position.y)
            self.addChild(rightcube)
            
            
            
            
            
            
            
            
        }
        self.addChild(sideLineRight)
        
        
        if (arenaNum == 1){
            circle.texture = SKTexture(imageNamed: "Circle")
        }
        if (arenaNum == 2){
            //   circle.texture = SKTexture(imageNamed: "WaterCircle")
            circle.isHidden = true
            circle.zPosition = -1
        
        }
        
        
        
        
        
        
        
        
        circle.setScale(0.7)
        circle.position = CGPoint(x: self.size.width*0.5, y: (self.size.height*0.12))
        circle.zPosition = -2
        if (arenaNum == 3){
            circle.isHidden = true
            
            
            
        }
        if (arenaNum == 4){
            circle.isHidden = true
            
            
            
        }
        self.addChild(circle)
        
        
        
        
        
        
        
        
        resume.setScale(1.3)
        resume.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.59)
        resume.zPosition = 1
        resume.name = "Continue"
        self.addChild(resume)
        resume.isHidden = true
        
        
        setupSlingshot()
        
        
        
        restart.setScale(1.3)
        restart.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.52)
        restart.zPosition = 1
        restart.name = "restart"
        self.addChild(restart)
        restart.isHidden = true
        
        
        
        
        
        
        
        
        mainMenu.setScale(1.3)
        mainMenu.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.45)
        mainMenu.zPosition = 1
        mainMenu.name = "MainMenu"
        self.addChild(mainMenu)
        mainMenu.isHidden = true
        
        
        
        
        
        
        
        
        leftBorder.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: 285 , y: 0), to: CGPoint(x:  285 , y: self.size.height))
        leftBorder.physicsBody!.categoryBitMask = physicsCategories.leftBorder
        leftBorder.physicsBody!.contactTestBitMask = physicsCategories.ball | physicsCategories.defender | physicsCategories.rock | physicsCategories.resistantDefender
        leftBorder.physicsBody!.collisionBitMask = physicsCategories.ball | physicsCategories.defender | physicsCategories.rock | physicsCategories.resistantDefender
        leftBorder.physicsBody!.friction = 0
        leftBorder.physicsBody!.restitution = 1
        self.addChild(leftBorder)
        rightBorder.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: self.size.width - 285 , y: 0), to: CGPoint(x: self.size.width - 285 , y: self.size.height))
        rightBorder.physicsBody!.categoryBitMask = physicsCategories.rightBorder
        rightBorder.physicsBody!.contactTestBitMask = physicsCategories.ball | physicsCategories.defender | physicsCategories.rock | physicsCategories.resistantDefender
        rightBorder.physicsBody!.collisionBitMask = physicsCategories.ball | physicsCategories.defender | physicsCategories.rock | physicsCategories.resistantDefender
        
        
        
        
        
        
        
        
        rightBorder.physicsBody!.friction = 0
        rightBorder.physicsBody!.restitution = 1
        self.addChild(rightBorder)
        
        
        
        
        
        
        
        
        topBorder.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: -100, y: self.size.height + 100), to: CGPoint(x: self.size.width + 100, y: self.size.height + 100))
        // topBorder.physicsBody!.collisionBitMask = physicsCategories.TopBorder
        topBorder.physicsBody!.categoryBitMask = physicsCategories.topBorder
        topBorder.physicsBody!.contactTestBitMask = physicsCategories.ball
        //topBorder.physicsBody!.collisionBitMask = physicsCategories.ball
        topBorder.physicsBody!.friction = 0
        topBorder.zPosition = 2
        topBorder.physicsBody?.restitution = 0
        topBorder.physicsBody!.isDynamic = false
        self.addChild(topBorder)
        
        
        
        
        
        
        
        
        bottomBorder.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: -100, y: -100),  to: CGPoint(x: self.size.width + 100, y: -100))
        // topBorder.physicsBody!.collisionBitMask = physicsCategories.TopBorder
        bottomBorder.physicsBody!.categoryBitMask = physicsCategories.bottomBorder
        bottomBorder.physicsBody!.contactTestBitMask = physicsCategories.ball
        //topBorder.physicsBody!.collisionBitMask = physicsCategories.ball
        bottomBorder.physicsBody!.friction = 0
        bottomBorder.physicsBody?.restitution = 0
        bottomBorder.physicsBody!.isDynamic = false
        self.addChild(bottomBorder)
        
        
        
        
        
        
        
        
        GameBall.physicsBody = SKPhysicsBody(circleOfRadius: GameBall.frame.size.width / 2.0)
        GameBall.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.145)
        GameBall.zPosition = 101
        /// print(GameBall.physicsBody!.mass)
        GameBall.physicsBody!.mass = 1
        GameBall.physicsBody!.restitution = 1.0
        GameBall.physicsBody!.friction = 0
        GameBall.physicsBody!.isDynamic = true
        GameBall.physicsBody!.affectedByGravity = false
        GameBall.physicsBody!.linearDamping = 0
        GameBall.physicsBody!.allowsRotation = true
        GameBall.name = "ball"
        GameBall.physicsBody!.categoryBitMask = physicsCategories.ball
        GameBall.physicsBody!.usesPreciseCollisionDetection = true
        GameBall.physicsBody!.collisionBitMask =  physicsCategories.horiPost | physicsCategories.vertPost1 | physicsCategories.vertPost2 | physicsCategories.leftBorder | physicsCategories.rightBorder | physicsCategories.defender | physicsCategories.rock | physicsCategories.metior | physicsCategories.resistantDefender
        GameBall.physicsBody!.contactTestBitMask = physicsCategories.goal | physicsCategories.horiPost | physicsCategories.vertPost1 | physicsCategories.vertPost2 | physicsCategories.leftBorder | physicsCategories.rightBorder | physicsCategories.defender | physicsCategories.QuickGoal | physicsCategories.fire | physicsCategories.bubble | physicsCategories.rock | physicsCategories.SafetyArea | physicsCategories.coin | physicsCategories.resistantDefender
        self.addChild(GameBall)
        
        
        
        
        if (currentBallNumber == 28){
            GameConstants.StringConstant.currentBallIdentity = "ball_29"
            Coin_28_Emitter()
            
            
            
            
        }
        else if (currentBallNumber == 29){
            GameConstants.StringConstant.currentBallIdentity = "ball_29"
            Coin_29_Emitter()
            
            
            
            
            
            
            
            
        }
        else if (currentBallNumber == 30){
            GameConstants.StringConstant.currentBallIdentity = "ball_30"
            Coin_30_Emitter()
        }
        
        
        
        
        
        
        
        
        Settings.Metrics.projectileRadius = GameBall.size.width / 2.0
        GameGoal.setScale(3)
        GameGoal.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 210, height: 0.1), center: CGPoint(x: GameGoal.position.x, y: GameGoal.position.y - 10) )
        GameGoal.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.92)
        GameGoal.zPosition = 2
        GameGoal.physicsBody!.restitution = 0
        GameGoal.physicsBody!.friction = 0
        GameGoal.name = "goal"
        GameGoal.physicsBody!.isDynamic = false
        GameGoal.physicsBody!.categoryBitMask = physicsCategories.goal
        GameGoal.physicsBody!.contactTestBitMask = physicsCategories.ball
        self.addChild(GameGoal)
        
        
        if (arenaNum == 2) {
            GameGoal.texture = SKTexture(imageNamed: "StickGoal")
            GameGoal.size = CGSize(width: GameGoal.size.width, height: GameGoal.size.height * 0.6)
            GameGoal.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.91)
            
        }
        
        if (arenaNum == 3) {
        
            GameGoal.texture = SKTexture(imageNamed: "lavaGoal")
            GameGoal.size = CGSize(width: GameGoal.size.width + (GameGoal.size.width * 0.6), height: GameGoal.size.height/3)
            GameGoal.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.89)
            
       
            
        }
        
        
        
        
        if (arenaNum == 4) {
            
            
            GameGoal.texture = SKTexture(imageNamed: "spaceGoal")
            GameGoal.size = CGSize(width: GameGoal.size.width, height: GameGoal.size.height * 0.6)
            GameGoal.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.915)
            //
            let flash = SKAction.animate(with: [SKTexture(imageNamed: "SpaceGoalLaser"), SKTexture(imageNamed:"spaceGoal")], timePerFrame: 0.01)
            
            
            let flashing = SKAction.animate(with: [SKTexture(imageNamed: "spaceGoal"),SKTexture(imageNamed: "SpaceGoalLaser")], timePerFrame: 0.01)
            
            
            let seq = SKAction.sequence([flash,flashing])
            
            
            let forever = SKAction.repeatForever(seq)
            
            
            
            
            GameGoal.run(forever)
            
            
        }
        
        
        
        
        
        
        Missed.setScale(3)
        Missed.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.92)
        Missed.zPosition = 3
        Missed.isHidden = true
        self.addChild(Missed)
        
        
        if (arenaNum == 2 || arenaNum == 3 || arenaNum == 4) {
            Missed.isHidden = true
            Missed.removeFromParent()
            
        }
        
        
        scored.setScale(3)
        scored.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.92)
        scored.zPosition = 3
        scored.isHidden = true
        self.addChild(scored)
        
        
        if (arenaNum == 2) {
            
            scored.isHidden = true
        }
        if (arenaNum == 3) {
            
            scored.isHidden = true
        }
        if (arenaNum == 4) {
           // scored.removeFromParent()
            scored.isHidden = true
            
        }
        
        
        pauseButton.setScale(0.7)
        pauseButton.position = CGPoint(x: self.size.width*0.75, y: self.size.height * 0.935)
        pauseButton.zPosition = 100
        pauseButton.name = "pausedButtonMenu"
        self.addChild(pauseButton)
        
        
        PausedTitle.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.7)
        PausedTitle.color = UIColor.white
        PausedTitle.text = "Paused"
        PausedTitle.zPosition = 200
        PausedTitle.fontSize = 150
        PausedTitle.isHidden = true
        self.addChild(PausedTitle)
        
        
        noSound.setScale(0.8)
        noSound.name = "mute"
        noSound.position = CGPoint(x: self.size.width*0.30, y: self.size.height*0.35)
        noSound.zPosition = 1
        noSound.isHidden = true
        self.addChild(noSound)
        
        
        noAdds.setScale(0.9)
        noAdds.position = CGPoint(x: self.size.width*0.7, y:self.size.height*0.35)
        noAdds.zPosition = 1
        noAdds.name = "NoAdds"
        noAdds.isHidden = true
        self.addChild(noAdds)
        
        
        moreBall.setScale(0.8)
        moreBall.position = CGPoint(x: self.size.width*0.56, y:self.size.height*0.35)
        moreBall.zPosition = 1
        moreBall.isHidden = true
        moreBall.name = "moreBall"
        self.addChild(moreBall)
        
        
        scoreBoard.setScale(0.8)
        scoreBoard.position = CGPoint(x: self.size.width*0.43, y: self.size.height*0.35)
        scoreBoard.zPosition = 1
        scoreBoard.isHidden = true
        scoreBoard.name = "scoreBoard"
        self.addChild(scoreBoard)
        
        
        verticalPost1.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: GameGoal.position.x - GameGoal.size.width/2 + 20, y: GameGoal.position.y + GameGoal.size.height/4), to: CGPoint(x: GameGoal.position.x - GameGoal.size.width/2 + 20, y: 1800.0))
        verticalPost1.physicsBody!.categoryBitMask = physicsCategories.vertPost1
        verticalPost1.physicsBody!.collisionBitMask = physicsCategories.ball
        verticalPost1.physicsBody!.contactTestBitMask = physicsCategories.ball
        verticalPost1.physicsBody!.restitution = 1
        verticalPost1.physicsBody!.isDynamic = false
        verticalPost1.physicsBody!.friction = 0
        self.addChild(verticalPost1)
        
        
        verticalPost2.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: GameGoal.position.x + GameGoal.size.width/2 - 20, y: GameGoal.position.y + GameGoal.size.height/4), to: CGPoint(x: GameGoal.position.x + GameGoal.size.width/2 - 20, y: 1800.0))
        verticalPost2.physicsBody!.categoryBitMask = physicsCategories.vertPost2
        verticalPost2.physicsBody!.collisionBitMask = physicsCategories.ball
        verticalPost2.physicsBody!.contactTestBitMask = physicsCategories.ball
        verticalPost2.physicsBody!.restitution = 1
        verticalPost2.physicsBody!.isDynamic = false
        verticalPost2.physicsBody!.friction = 0
        self.addChild(verticalPost2)
        
        
        outerPost1.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: GameGoal.position.x - GameGoal.size.width/2 , y: GameGoal.position.y + GameGoal.size.height/4 ), to: CGPoint(x: GameGoal.position.x - GameGoal.size.width/2 , y: 1835.0))
        outerPost1.physicsBody!.categoryBitMask = physicsCategories.outerPost1
        outerPost1.physicsBody!.collisionBitMask = physicsCategories.ball
        outerPost1.physicsBody!.contactTestBitMask = physicsCategories.ball
        outerPost1.physicsBody!.restitution = 1
        outerPost1.physicsBody!.isDynamic = false
        outerPost1.physicsBody!.friction = 0
        self.addChild(outerPost1)
        
        
        outerPost2.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: GameGoal.position.x + GameGoal.size.width/2 , y: GameGoal.position.y + GameGoal.size.height/4 ), to: CGPoint(x: GameGoal.position.x + GameGoal.size.width/2, y: 1835.0))
        outerPost2.physicsBody!.categoryBitMask = physicsCategories.outerPost2
        outerPost2.physicsBody!.collisionBitMask = physicsCategories.ball
        outerPost2.physicsBody!.contactTestBitMask = physicsCategories.ball
        outerPost2.physicsBody!.restitution = 1
        outerPost2.physicsBody!.isDynamic = false
        outerPost2.physicsBody!.friction = 0
        self.addChild(outerPost2)
        
        
        horizontalPost.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: GameGoal.position.x - GameGoal.size.width/2, y: GameGoal.position.y + GameGoal.size.height/4), to: CGPoint(x: GameGoal.position.x + GameGoal.size.width/2, y:GameGoal.position.y + GameGoal.size.height/4))
        horizontalPost.physicsBody!.categoryBitMask = physicsCategories.horiPost
        horizontalPost.physicsBody!.contactTestBitMask = physicsCategories.ball
        horizontalPost.physicsBody!.collisionBitMask = physicsCategories.ball
        horizontalPost.physicsBody!.restitution = 1
        horizontalPost.physicsBody!.friction = 0
        horizontalPost.physicsBody!.isDynamic = false
        horizontalPost.zPosition = 1
        self.addChild(horizontalPost)
        
        
        powerUpNumLabel.text = "\(firePowerUps)"
        powerUpNumLabel.fontSize = 30
        powerUpNumLabel.fontColor = SKColor.white
        powerUpNumLabel.position = CGPoint(x: self.size.width * 0.76, y: self.size.height * 0.03)
        powerUpNumLabel.zPosition = 101
        self.addChild(powerUpNumLabel)
        
        
        gameScoreLabel.text = "Lvl \(gameLevel)"
        gameScoreLabel.fontSize = 55
        gameScoreLabel.fontColor = SKColor.white
        gameScoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        gameScoreLabel.position = CGPoint(x: self.size.width * 0.62, y: self.size.height * 0.925)
        gameScoreLabel.zPosition = 100
        self.addChild(gameScoreLabel)
        
        
        dashedLine.setScale(0.5)
        dashedLine.position = GameBall.position
        dashedLine.anchorPoint = CGPoint(x: 0.5, y: 1)
        dashedLine.position = GameBall.position
        dashedLine.position.y = GameBall.position.y + dashedLine.size.height / 2
        dashedLine.zPosition = 200
        dashedLine.alpha = 1
        dashedLine.isHidden = true
        self.addChild(dashedLine)
        
        
        if (currentBallNumber == 25){
            //   GameConstants.StringConstant.currentBallIdentity = "ball_25"
            dashedLine.texture = SKTexture(imageNamed: "speed1_gold")
        }
        
        
        if (arenaNum == 2){
            useFirePowerUp.texture = SKTexture(imageNamed: "BubbleNumber")
        }
        
        
        
        
        
        
        
        
        useFirePowerUp.setScale(0.45)
        useFirePowerUp.position = CGPoint(x: self.size.width*0.74, y: self.size.height * 0.05)
        useFirePowerUp.zPosition = 100
        useFirePowerUp.name = "fireButton"
        self.addChild(useFirePowerUp)
        
        
        
        
        
        
        
        
        if (firePowerUps == 0){
            useFirePowerUp.alpha = 0.3
            powerUpNumLabel.alpha = 0.3
        }
        
        
        
        
        
        
        
        
        var hardDuration = TimeInterval()
        switch gameLevel{
            
        
        case 1: hardDuration = 10
        
        
        numOfInitDef = 1
        totalDef = 1
        createCoin()
        createCoin()
        createCoin()
        InstantGoal()
        
        
        
        
        if (arenaNum == 1 || arenaNum == 3){
            createFire()
            }
            
            
        case 2: hardDuration = 3
        
        
        numOfInitDef = 2
        totalDef = 2
        createCoin()
        createFire()
            //createSafetyArea()
            
            
        case 3: hardDuration = 3
        
        
        
        
        numOfInitDef = 2
        totalDef = 3
        //InstantGoal()
        createFire()
        createCoin()
        createCoin()
        createSafetyArea()
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        if (arenaNum == 2 || arenaNum == 3){
            createFire()
            createCoin()
            createCoin()
            }
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
        case 4: hardDuration = 3
        
        
        numOfInitDef = 2
        totalDef = 3
        createCoin()
        createCoin()
        createFire()
            
            // createSafetyArea()
            
            
            
            
        
            
            
        case 5: hardDuration = 5
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        numOfInitDef = 3
        totalDef = 3
        createCoin()
        createCoin()
        createFire()
        createFire()
        
        createSafetyArea()
        InstantGoal()
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        if (arenaNum == 2 || arenaNum == 3){
            createFire()
            }
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
        case 6: hardDuration = 10
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        numOfInitDef = 3
        totalDef = 3
        createCoin()
        createCoin()
        createCoin()
        // InstantGoal()
        createSafetyArea()
        createFire()
        createFire()
        createFire()
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
        case 7: hardDuration = 8
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        numOfInitDef = 3
        totalDef = 3
        createFire()
        createCoin()
        createCoin()
        createFire()
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
        case 8: hardDuration = 4
        
        
        numOfInitDef = 4
        totalDef = 4
        createCoin()
        createCoin()
        InstantGoal()
        createSafetyArea()
        
        
        if (arenaNum == 2 || arenaNum == 3){
            createFire()
        }
        createFire()
            
            
        case 9: hardDuration = 2
        
        
        numOfInitDef = 4
        totalDef = 6
        InstantGoal()
        createFire()
        createCoin()
        createCoin()
        createCoin()
        createCoin()
        createSafetyArea()
        createSafetyArea()
            
        case 10: hardDuration = 1
        
        
        numOfInitDef = 4
        createFire()
        createCoin()
        createCoin()
        totalDef = 6
        createCoin()
        createCoin()
        createSafetyArea()
        createFire()
            
            
        case 11: hardDuration = 4
        
        
        numOfInitDef = 3
        InstantGoal()
        createCoin()
        createFire()
        createCoin()
        totalDef = 3
        createFire()
            
            
            
            
        case 12: hardDuration = 3
        numOfInitDef = 3
        // InstantGoal()
        totalDef = 3
        
        
        createSafetyArea()
        createFire()
        createFire()
            
            
        case 13: hardDuration = 3
        numOfInitDef = 4
        createSafetyArea()
        createCoin()
        createCoin()
        totalDef = 4
        createFire()
        createFire()
            
            
        case 14: hardDuration = 1
        numOfInitDef = 4
        createCoin()
        createCoin()
        createCoin()
        totalDef = 5
        createFire()
        createFire()
        createFire()
        
        
        createSafetyArea()
            
            
        case 15: hardDuration = 1
        numOfInitDef = 5
        InstantGoal()
        createCoin()
        createCoin()
        createCoin()
        createCoin()
        createFire()
        createFire()
        
        
        
        
        
        
        
        
        totalDef = 5
        createSafetyArea()
        
        createSafetyArea()
            
            
            
        case 16: hardDuration = 3
        numOfInitDef = 5
        createCoin()
        totalDef = 5
        createFire()
        createFire()
        
        
        createSafetyArea()
            
            
            
            
        case 17: hardDuration = 6
        numOfInitDef = 5
        createSafetyArea()
        createSafetyArea()
        totalDef = 7
        
        createFire()
        createFire()
            
            
            
        case 18: hardDuration = 6
        numOfInitDef = 6
        InstantGoal()
        createCoin()
        createCoin()
        createCoin()
        createCoin()
        totalDef = 6
        createSafetyArea()
        createFire()
        createFire()
            
        case 19: hardDuration = 1
        numOfInitDef = 6
        InstantGoal()
        totalDef = 8
        createSafetyArea()
        createSafetyArea()
        createFire()
        createFire()
        createFire()
            
        case 20: hardDuration = 1
        numOfInitDef = 7
        createFire()
        createFire()
        
        
        
        
        
        
        
        
        createCoin()
        createCoin()
        totalDef = 8
        createCoin()
        createCoin()
        createCoin()
        
        
        
        
        
        
        
        
        
        
        
        
        createSafetyArea()
        createSafetyArea()
            
            
            
            
        case 21: hardDuration = 3
        numOfInitDef = 7
        InstantGoal()
        createFire()
        createCoin()
        totalDef = 8
        createSafetyArea()
            
            
            
        case 22: hardDuration = 3
        
        
        numOfInitDef = 8
        totalDef = 8
        createCoin()
        createCoin()
        createSafetyArea()
        createFire()
        createFire()
            
            
            
        case 23: hardDuration = 4
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        numOfInitDef = 8
        totalDef = 9
        createSafetyArea()
        createFire()
        createFire()
        
        
        InstantGoal()
            
            
        case 24: hardDuration = 4
        numOfInitDef = 9
        totalDef = 9
        createCoin()
        createSafetyArea()
        
        
        createSafetyArea()
        createSafetyArea()
        createSafetyArea()
        createFire()
        createFire()
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
        case 25: hardDuration = 5
        numOfInitDef = 10
        totalDef = 10
        createFire()
        InstantGoal()
        createCoin()
        createCoin()
        createCoin()
        createCoin()
        createCoin()
        createCoin()
        createCoin()
        createCoin()
        createSafetyArea()
        createSafetyArea()
        createSafetyArea()
        createFire()
        createFire()
        createFire()
        createFire()
            
            
        case 26: hardDuration = 10
        
        
        numOfInitDef = 1
        totalDef = 1
        createCoin()
        createCoin()
        createCoin()
        InstantGoal()
        createFire()
        
        
        
        
        if (arenaNum == 1 || arenaNum == 3){
            createFire()
            }
            
            
        case 27: hardDuration = 3
        
        
        numOfInitDef = 2
        totalDef = 2
        createCoin()
        createFire()
            //createSafetyArea()
            
            
        case 28: hardDuration = 3
        
        
        
        
        numOfInitDef = 2
        totalDef = 3
        //InstantGoal()
        createFire()
        createCoin()
        createCoin()
        createSafetyArea()
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        if (arenaNum == 2 || arenaNum == 3){
            createFire()
            createCoin()
            createCoin()
            }
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
        case 29: hardDuration = 3
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        numOfInitDef = 2
        totalDef = 3
        createCoin()
        createCoin()
        createSafetyArea()
        
        createFire()
        
        createFire()
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
        case 30: hardDuration = 5
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        numOfInitDef = 3
        totalDef = 3
        createCoin()
        createCoin()
        createSafetyArea()
        InstantGoal()
        createFire()
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        if (arenaNum == 2 || arenaNum == 3){
            createFire()
            }
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
        case 31: hardDuration = 10
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        numOfInitDef = 3
        totalDef = 3
        createCoin()
        createCoin()
        createCoin()
        // InstantGoal()
        createSafetyArea()
        
        createFire()
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
        case 32: hardDuration = 8
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        numOfInitDef = 3
        totalDef = 3
        createFire()
        createCoin()
        createCoin()
        createFire()
            
        createSafetyArea()
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
        case 33: hardDuration = 4
        
        
        numOfInitDef = 4
        totalDef = 4
        createCoin()
        createCoin()
        InstantGoal()
        createSafetyArea()
        createSafetyArea()
        
        
        if (arenaNum == 2 || arenaNum == 3){
            createFire()
        }
        createFire()
            
            
        case 34: hardDuration = 2
        
        
        numOfInitDef = 4
        totalDef = 6
        InstantGoal()
        createFire()
        createCoin()
        createCoin()
        createCoin()
        createCoin()
        createSafetyArea()
        createSafetyArea()
            
            
        case 35: hardDuration = 1
        
        
        numOfInitDef = 4
        InstantGoal()
        createFire()
        createCoin()
        createCoin()
        totalDef = 6
        createCoin()
        createCoin()
            createSafetyArea()
           
            
            
        case 36: hardDuration = 4
        
        
        numOfInitDef = 3
        InstantGoal()
        createCoin()
        createFire()
        createSafetyArea()
        createSafetyArea()
        createCoin()
        totalDef = 3
            
            
            
            
        case 37: hardDuration = 3
        numOfInitDef = 3
        // InstantGoal()
        totalDef = 3
        
        
        createSafetyArea()
        
        createCoin()
        createCoin()
        createCoin()
        case 38: hardDuration = 3
        numOfInitDef = 4
        createSafetyArea()
        createCoin()
        createCoin()
        totalDef = 4
        createFire()
        createFire()
            
            
        case 39: hardDuration = 1
        numOfInitDef = 4
        createCoin()
        createCoin()
        createCoin()
        totalDef = 5
        
        createFire()
        createSafetyArea()
        createSafetyArea()
            
            
            
        case 40: hardDuration = 1
        numOfInitDef = 5
        InstantGoal()
        createCoin()
        createCoin()
        createCoin()
        createCoin()
        
        createFire()
        createFire()
        
        createSafetyArea()
        
        totalDef = 5
        createSafetyArea()
            
            
            
            
        case 41: hardDuration = 3
        numOfInitDef = 5
        createCoin()
        totalDef = 5
        
        createFire()
        createFire()
        createFire()
        
        createSafetyArea()
        InstantGoal()
        createCoin()
        createCoin()
        createCoin()
            
            
            
        case 42: hardDuration = 6
        numOfInitDef = 5
        createSafetyArea()
        createSafetyArea()
        totalDef = 7
        
        createCoin()
        createCoin()
        createCoin()
            
            
        case 43: hardDuration = 6
        numOfInitDef = 6
        InstantGoal()
        createCoin()
        createCoin()
        createCoin()
        createCoin()
        totalDef = 6
        createSafetyArea()
        createFire()
            
        case 44: hardDuration = 1
        numOfInitDef = 6
        InstantGoal()
        totalDef = 8
        createSafetyArea()
        createSafetyArea()
        createCoin()
        createCoin()
        createCoin()
        createFire()
            
        case 45: hardDuration = 1
        numOfInitDef = 7
        
        
        
        
        
        
        createFire()
        createFire()
        createFire()
        createFire()
        createFire()
        
        createSafetyArea()
        createCoin()
        createCoin()
        totalDef = 8
        createCoin()
        createCoin()
        createCoin()
        createCoin()
        createCoin()
        createCoin()
        createCoin()
        createCoin()
        createCoin()
        
        
        
        
        
        
        
        
        
        
        
        createSafetyArea()
        createSafetyArea()
            
            
            
            
        case 46: hardDuration = 3
        numOfInitDef = 7
        InstantGoal()
        createFire()
        createCoin()
        totalDef = 8
        createSafetyArea()
            
            
            
        case 47: hardDuration = 3
        
        
        numOfInitDef = 8
        totalDef = 8
        createCoin()
        createCoin()
        createSafetyArea()
        createFire()
            
            
            
        case 48: hardDuration = 4
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        numOfInitDef = 8
        totalDef = 9
        createSafetyArea()
        createFire()
        createFire()
        createCoin()
        createCoin()
        createCoin()
        
        InstantGoal()
            
            
        case 49: hardDuration = 4
        numOfInitDef = 9
        totalDef = 9
        createCoin()
        createSafetyArea()
        
        
        createSafetyArea()
        createSafetyArea()
        createSafetyArea()
        createFire()
        createFire()
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
        case 50: hardDuration = 5
        numOfInitDef = 10
        totalDef = 10
        createFire()
        InstantGoal()
        createCoin()
        createCoin()
        createCoin()
        createCoin()
        createCoin()
        createSafetyArea()
        createSafetyArea()
        createSafetyArea()
            
            
            
            
        case 51: hardDuration = 10
        
        
        numOfInitDef = 1
        totalDef = 1
        createCoin()
        createCoin()
        createCoin()
        
        createFire()
        
        if (arenaNum == 1 || arenaNum == 3){
            createFire()
            }
            
            
        case 52: hardDuration = 3
        
        
        numOfInitDef = 1
        totalDef = 2
        createCoin()
        createCoin()
        createCoin()
        createCoin()
        createFire()
        //createSafetyArea()
        createFire()
        createFire()
            
            
        case 53: hardDuration = 3
        
        
        
        
        numOfInitDef = 2
        totalDef = 2
        //InstantGoal()
        createFire()
        createCoin()
        createCoin()
        createSafetyArea()
        
        
        createFire()
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        if (arenaNum == 2 || arenaNum == 3){
            createFire()
            createCoin()
            createCoin()
            }
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
        case 54: hardDuration = 3
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        numOfInitDef = 2
        totalDef = 3
        createCoin()
        createCoin()
        // createSafetyArea()
        
        createFire()
        createFire()
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
        case 55: hardDuration = 5
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        numOfInitDef = 2
        totalDef = 3
        createCoin()
        createCoin()
        createSafetyArea()
        createFire()
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        if (arenaNum == 2 || arenaNum == 3){
            createFire()
        }
        createFire()
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
        case 56: hardDuration = 10
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        createFire()
        
        numOfInitDef = 3
        totalDef = 3
        createCoin()
        createCoin()
        createCoin()
        // InstantGoal()
        createSafetyArea()
        InstantGoal()
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
        case 57: hardDuration = 8
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        numOfInitDef = 3
        totalDef = 4
        createFire()
        createCoin()
        createCoin()
        createSafetyArea()
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
        case 58: hardDuration = 4
        
        
        numOfInitDef = 3
        totalDef = 4
        createCoin()
        createCoin()
        InstantGoal()
        
        
        if (arenaNum == 2 || arenaNum == 3){
            createFire()
            }
            
            
        case 59: hardDuration = 2
        
        
        numOfInitDef = 3
        totalDef = 5
        InstantGoal()
        createFire()
        createCoin()
        createCoin()
        createCoin()
        createCoin()
        createSafetyArea()
        createSafetyArea()
            
            
        case 60: hardDuration = 1
        
        
        numOfInitDef = 4
        InstantGoal()
        createFire()
        createCoin()
        createCoin()
        totalDef = 5
        createCoin()
        createCoin()
            
            
        case 61: hardDuration = 4
        
        
        numOfInitDef = 3
        // InstantGoal()
        createCoin()
        createFire()
        createCoin()
        totalDef = 3
            
            
            
            
        case 62: hardDuration = 3
        numOfInitDef = 3
        // InstantGoal()
        totalDef = 4
        createCoin()
        createCoin()
        createCoin()
        
        createSafetyArea()
        createFire()
            
            
        case 63: hardDuration = 3
        numOfInitDef = 4
        InstantGoal()
        createCoin()
        createCoin()
        totalDef = 4
            
            
        case 64: hardDuration = 1
        numOfInitDef = 4
        InstantGoal()
        createCoin()
        createCoin()
        createCoin()
        totalDef = 4
        createFire()
        createFire()
            
            
            
            
        case 65: hardDuration = 1
        numOfInitDef = 5
        //InstantGoal()
        createCoin()
        createCoin()
        createCoin()
        createCoin()
        createFire()
        createFire()
        
        
        
        
        
        
        
        
        totalDef = 5
        createSafetyArea()
            
            
            
            
        case 66: hardDuration = 3
        numOfInitDef = 3
        InstantGoal()
        createCoin()
        totalDef = 5
        
        
        createSafetyArea()
        createSafetyArea()
        
        createFire()
            
            
            
        case 67: hardDuration = 6
        numOfInitDef = 3
        InstantGoal()
        createSafetyArea()
        totalDef = 5
        createFire()
        createCoin()
        createCoin()
        createCoin()
            
            
            
        case 68: hardDuration = 6
        numOfInitDef = 4
        //InstantGoal()
        createCoin()
        createCoin()
        createCoin()
        createCoin()
        totalDef = 4
        createSafetyArea()
        createFire()
        createFire()
        createFire()
            
        case 69: hardDuration = 1
        numOfInitDef = 4
        //InstantGoal()
        totalDef = 5
        createSafetyArea()
        createFire()
        createCoin()
        createCoin()
        createCoin()
        createSafetyArea()
        case 70: hardDuration = 1
        numOfInitDef = 7
        
        
        
        
        
        
        createFire()
        
        
        createCoin()
        createCoin()
        totalDef = 9
        createCoin()
        createCoin()
        createCoin()
        
        
        
        
        
        
        
        
        
        
        
        
        createSafetyArea()
        createSafetyArea()
            
            
            
            
        case 71: hardDuration = 3
        numOfInitDef = 4
        InstantGoal()
        createFire()
        createCoin()
        totalDef = 6
        createSafetyArea()
        createSafetyArea()
        createSafetyArea()
            
            
        case 72: hardDuration = 3
        
        
        numOfInitDef = 5
        totalDef = 5
        createCoin()
        createCoin()
        createSafetyArea()
        createSafetyArea()
        createSafetyArea()
        createFire()
        createFire()
            
            
        case 73: hardDuration = 4
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        numOfInitDef = 5
        totalDef = 7
        createSafetyArea()
        createFire()
        
        
        InstantGoal()
            
            
        case 74: hardDuration = 4
        numOfInitDef = 6
        totalDef = 7
        createCoin()
        createSafetyArea()
        
        
        createSafetyArea()
        createSafetyArea()
        createSafetyArea()
        createFire()
        createFire()
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
        case 75: hardDuration = 5
        numOfInitDef = 6
        totalDef = 7
        createFire()
        InstantGoal()
        createCoin()
        createCoin()
        createCoin()
        createCoin()
           createSafetyArea()
        createCoin()
        
        createSafetyArea()
        
        createFire()
        createFire()
        createFire()
        createFire()
        createFire()
            
            
            
            
        case 76: hardDuration = 5
        numOfInitDef = 1
        totalDef = 1
        createFire()
        InstantGoal()
        createCoin()
        createCoin()
        createCoin()
        createCoin()
        createCoin()
        createSafetyArea()
        createSafetyArea()
        createSafetyArea()
            
            
        case 77: hardDuration = 10
        
        
        numOfInitDef = 1
        totalDef = 1
        createCoin()
        createCoin()
        createCoin()
        createFire()
        createFire()
        createFire()
           createSafetyArea()
        
        
        if (arenaNum == 1 || arenaNum == 3){
            createFire()
            }
            
            
        case 78: hardDuration = 3
        
        
        numOfInitDef = 1
        totalDef = 2
        createCoin()
        createCoin()
        createCoin()
        createCoin()
        createFire()
           createSafetyArea()
        //createSafetyArea()
        createBlackHole()
            
        case 79: hardDuration = 3
           createSafetyArea()
           createSafetyArea()
        
        
        
        numOfInitDef = 2
        totalDef = 2
        //InstantGoal()
        createFire()
        createCoin()
        createCoin()
        createSafetyArea()
        createCoin()
        createCoin()
        createCoin()
         createBlackHole()
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        if (arenaNum == 2 || arenaNum == 3){
            createFire()
            createCoin()
            createCoin()
        }
        createFire()
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
        case 80: hardDuration = 3
        
        
        
        
        
        
        
           createSafetyArea()
           createSafetyArea()
        
        
        
        
        
        
        createFire()
        createFire()
        InstantGoal()
        
        numOfInitDef = 2
        totalDef = 3
        createCoin()
        createCoin()
        createCoin()
        createCoin()
        createCoin()
        // createSafetyArea()
        createBlackHole()
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
        case 81: hardDuration = 5
        
        
        
        
        
        
        
        
        
        
           createSafetyArea()
        
        
        
        
        
        numOfInitDef = 2
        totalDef = 3
        createCoin()
        createCoin()
        createCoin()
        createCoin()
        createCoin()
        createSafetyArea()
        createBlackHole()
        
        createBlackHole()
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        if (arenaNum == 2 || arenaNum == 3){
            createFire()
        }
        
        createFire()
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
        case 82: hardDuration = 10
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        numOfInitDef = 3
        totalDef = 3
        createCoin()
        createCoin()
        createCoin()
        // InstantGoal()
        createSafetyArea()
        InstantGoal()
        createBlackHole()
        createBlackHole()
            
               createSafetyArea()
            
            
               createSafetyArea()
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
        case 83: hardDuration = 8
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        numOfInitDef = 3
        totalDef = 3
        createFire()
        createCoin()
        createCoin()
        createSafetyArea()
        
        createBlackHole()
        createBlackHole()
        createBlackHole()
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
        case 84: hardDuration = 4
        
        
        numOfInitDef = 3
        totalDef = 4
        createCoin()
        createCoin()
           createSafetyArea()
           createSafetyArea()
        InstantGoal()
        
        createFire()
        
        if (arenaNum == 2 || arenaNum == 3){
            createFire()
        }
        
        createBlackHole()
            
        case 85: hardDuration = 2
        
        
        numOfInitDef = 3
        totalDef = 5
        InstantGoal()
        createFire()
        createCoin()
        createCoin()
        createCoin()
        createCoin()
        createSafetyArea()
        createSafetyArea()
        createBlackHole()
        createBlackHole()
            
            
        case 86: hardDuration = 1
        
        
        numOfInitDef = 4
        InstantGoal()
        createFire()
        createCoin()
        createCoin()
        totalDef = 5
        createCoin()
        createCoin()
        createBlackHole()
        createSafetyArea()
            
            
        case 87: hardDuration = 4
        
        
        numOfInitDef = 4
        // InstantGoal()
        createCoin()
        createFire()
        createCoin()
        createSafetyArea()
        totalDef = 5
           createSafetyArea()
        
        createBlackHole()
            
            
            
        case 88: hardDuration = 3
        numOfInitDef = 3
        // InstantGoal()
        totalDef = 4
        createBlackHole()
        createBlackHole()
        createFire()
        createCoin()
        createCoin()
        createSafetyArea()
        createCoin()
               createSafetyArea()
            
            
            
        case 89: hardDuration = 3
        numOfInitDef = 4
        InstantGoal()
        createCoin()
        createCoin()
        totalDef = 4
        createBlackHole()
        createFire()
               createSafetyArea()
               createSafetyArea()
            
            
        case 90: hardDuration = 1
        numOfInitDef = 4
        InstantGoal()
        createCoin()
        createCoin()
        createCoin()
        totalDef = 4
        createFire()
        createFire()
           createSafetyArea()
           createSafetyArea()
        
        
        createBlackHole()
            
            
        case 91: hardDuration = 1
        numOfInitDef = 5
        //InstantGoal()
        createCoin()
        createCoin()
        createCoin()
        createCoin()
        createFire()
        
           createSafetyArea()
           createSafetyArea()
        createBlackHole()
        createBlackHole()
        
        
        
        
        
        totalDef = 5
        createSafetyArea()
            
            
            
            
        case 92: hardDuration = 3
        numOfInitDef = 3
        InstantGoal()
        createCoin()
        totalDef = 5
        createFire()
       
        
        
        createSafetyArea()
        createSafetyArea()
        
        createBlackHole()
        createBlackHole()
            
            
            
        case 93: hardDuration = 6
        numOfInitDef = 3
        InstantGoal()
        createSafetyArea()
        totalDef = 5
        createFire()
        
        createBlackHole()
        createBlackHole()
        createBlackHole()
        createCoin()
        createCoin()
        createCoin()
        createCoin()
        createCoin()
        createCoin()
        createCoin()
        createCoin()
            
            
        case 94: hardDuration = 6
        numOfInitDef = 4
        //InstantGoal()
        createCoin()
        createCoin()
        createCoin()
        createCoin()
        totalDef = 4
        createSafetyArea()
        createBlackHole()
        createFire()
            
        case 95: hardDuration = 1
        numOfInitDef = 4
        //InstantGoal()
        totalDef = 5
        createSafetyArea()
        createSafetyArea()
        createFire()
        createCoin()
        createCoin()
        createCoin()
        createCoin()
        createCoin()
        createCoin()
        createCoin()
        createCoin()
        case 96: hardDuration = 1
        numOfInitDef = 7
        createFire()
        
        
        createBlackHole()
        createBlackHole()
        
        
        
        
        
        
        createCoin()
        createCoin()
        totalDef = 9
        createCoin()
        createCoin()
        createCoin()
        
        
        
        
        
        createBlackHole()
        
        
        
        
        
        
        
        createSafetyArea()
        createSafetyArea()
        createCoin()
        createCoin()
        createCoin()
        createCoin()
        createCoin()
        createCoin()
        createCoin()
        createCoin()
            
            
            
        case 97: hardDuration = 3
        numOfInitDef = 4
        InstantGoal()
        createFire()
        createCoin()
        totalDef = 6
        createSafetyArea()
        createSafetyArea()
        createSafetyArea()
        createBlackHole()
        createBlackHole()
        createBlackHole()
    
        createFire()
        createCoin()
        createCoin()
        createCoin()
        createCoin()
        createCoin()
        createCoin()
        createCoin()
        createCoin()
            
        case 98: hardDuration = 3
        
        
        numOfInitDef = 5
        totalDef = 5
        createCoin()
        createCoin()
        createSafetyArea()
        createSafetyArea()
        createSafetyArea()
        createBlackHole()
        createBlackHole()
        createFire()
        createFire()
        createCoin()
        createCoin()
        createCoin()
        createCoin()
        createCoin()
        createCoin()
        createCoin()
        createCoin()
            
        case 99: hardDuration = 4
        
        numOfInitDef = 5
        totalDef = 7
        createSafetyArea()
        createFire()
        createFire()
        createCoin()
        createCoin()
        createCoin()
        createCoin()
        createCoin()
        createCoin()
        createCoin()
        createCoin()
        
        InstantGoal()
            
            
        case 100: hardDuration = 4
        numOfInitDef = 6
        totalDef = 7
        createCoin()
        createCoin()
        createCoin()
        createCoin()
        createCoin()
        createCoin()
        createCoin()
        createCoin()
        
        createSafetyArea()
        
        
        createSafetyArea()
        createSafetyArea()
        createSafetyArea()
        
        createFire()
        createFire()
        createFire()
        createFire()
        
        createBlackHole()
        createBlackHole()
        createBlackHole()
        createBlackHole()
            
            
        default:
            hardDuration = 0.5
            numOfInitDef = 4
            totalDef = 8
            print("Cannot find hard info")
        }
        
        
        
        
        
        
        
        
        var switchDefender: Bool = true
        
        let spawn2 = SKAction.run(SpawnResistantDefender)
        let spawn = SKAction.run(SpawnDefender)
        let initialSpawn = SKAction.run(SpawnInitialDefender)
        let initialSpawn2 = SKAction.run(SpawnInitialResistantDefender)
        
        
        
        
        for _ in 0 ... numOfInitDef - 1{
            if (switchDefender){
                switchDefender = false
                self.run(initialSpawn)
            }
            else{
                switchDefender = true
                if ((gameLevel > 10 && gameLevel <= 25) || (gameLevel > 35 && gameLevel <= 50) || (gameLevel > 60 && gameLevel <= 75) || (gameLevel > 85 && gameLevel <= 100) ){
                    self.run(initialSpawn2)
                }
                else{
                    self.run(initialSpawn)
                }
            }
        }
        
        let WaitToSpawn = SKAction.wait(forDuration: hardDuration)
        let spawnSeq = SKAction.sequence([ WaitToSpawn, spawn])
        let spawnSeq2 = SKAction.sequence([ WaitToSpawn, spawn2])
        if totalDef != numOfInitDef{
            
            
            for _ in 0 ... totalDef - numOfInitDef - 1 {
                if switchDefender{
                    switchDefender = false
                    self.run(spawnSeq, withKey: "spawningDeffenders1")
                }
                else{
                    switchDefender = true
                    if ((gameLevel > 10 && gameLevel <= 25) || (gameLevel > 35 && gameLevel <= 50) || (gameLevel > 60 && gameLevel <= 75) || (gameLevel > 85 && gameLevel <= 100) ){
                        self.run(spawnSeq2, withKey: "spawningDeffenders2")
                    }
                    else{
                        self.run(spawnSeq, withKey: "spawningDeffenders1")
                    }
                }
            }
        }
        
        
        if (arenaNum == 3){
            
            let spawn = SKAction.run(SpawnRock)
    
            for _ in 0 ... numOfInitDef - 1{
                self.run(spawn)
            
            }
            
            var WaitToSpawn = SKAction.wait(forDuration: 7.0)
           
            if (gameLevel > 50){
                WaitToSpawn = SKAction.wait(forDuration: 5.0)
                
                let flash = SKAction.animate(with: [SKTexture(imageNamed: "lavaGoalExplode"), SKTexture(imageNamed:"lavaGoal")], timePerFrame: 0.01)
                
                
                let flashing = SKAction.animate(with: [SKTexture(imageNamed: "lavaGoal"),SKTexture(imageNamed: "lavaGoalExplode")], timePerFrame: 5.0)
                
                
                let seq = SKAction.sequence([flash,flashing])
                
                
                let forever = SKAction.repeatForever(seq)
                
                
                
                GameGoal.run(forever)
                
                
    
                
                
            }
            if (gameLevel > 55){
                WaitToSpawn = SKAction.wait(forDuration: 10.0)
               
                
                let flash = SKAction.animate(with: [SKTexture(imageNamed: "lavaGoalExplode"), SKTexture(imageNamed:"lavaGoal")], timePerFrame: 0.01)
                
                
                let flashing = SKAction.animate(with: [SKTexture(imageNamed: "lavaGoal"),SKTexture(imageNamed: "lavaGoalExplode")], timePerFrame: 10.0)
                
                
                let seq = SKAction.sequence([flash,flashing])
                
                
                let forever = SKAction.repeatForever(seq)
                
                
                
                GameGoal.run(forever)
                
            }
            if (gameLevel > 60){
                WaitToSpawn = SKAction.wait(forDuration: 9.5)
               
                let flash = SKAction.animate(with: [SKTexture(imageNamed: "lavaGoalExplode"), SKTexture(imageNamed:"lavaGoal")], timePerFrame: 0.01)
                
                
                let flashing = SKAction.animate(with: [SKTexture(imageNamed: "lavaGoal"),SKTexture(imageNamed: "lavaGoalExplode")], timePerFrame: 9.5)
                
                
                let seq = SKAction.sequence([flash,flashing])
                
                
                let forever = SKAction.repeatForever(seq)
                
                
                
                GameGoal.run(forever)
                
            }
            if (gameLevel > 76){
                WaitToSpawn = SKAction.wait(forDuration: 5.0)
               
                
                let flash = SKAction.animate(with: [SKTexture(imageNamed: "lavaGoalExplode"), SKTexture(imageNamed:"lavaGoal")], timePerFrame: 0.01)
                
                
                let flashing = SKAction.animate(with: [SKTexture(imageNamed: "lavaGoal"),SKTexture(imageNamed: "lavaGoalExplode")], timePerFrame: 5.0)
                
                
                let seq = SKAction.sequence([flash,flashing])
                
                
                let forever = SKAction.repeatForever(seq)
                
                
                
                GameGoal.run(forever)
                
            }
            let spawnSeq = SKAction.sequence([ WaitToSpawn, spawn, spawn, spawn])
            
            
            self.run(SKAction.repeatForever(spawnSeq))
        }
        
        
        if (arenaNum == 4){
            let spawn = SKAction.run(SpawnMetior)
            
            
            for _ in 0 ... numOfInitDef - 1{
                self.run(spawn)
            }
            
            
            var WaitToSpawn = SKAction.wait(forDuration: 7.0)
            if (gameLevel > 75){
                WaitToSpawn = SKAction.wait(forDuration: 5.0)
            }
            if (gameLevel > 85){
                WaitToSpawn = SKAction.wait(forDuration: 3.0)
            }
            if (gameLevel > 90){
                WaitToSpawn = SKAction.wait(forDuration: 1.5)
            }
            if (gameLevel > 95){
                WaitToSpawn = SKAction.wait(forDuration: 0.5)
            }
            let spawnSeq = SKAction.sequence([ WaitToSpawn, spawn, spawn, spawn])
            self.run(SKAction.repeatForever(spawnSeq))
        }
    }
    
    
    func addLevel(){
        gameDifficulty += 1
        gameLevel += 1
    }
    
    
    var dashedLineHidden = Bool()
    var noGoal = Bool()
    
    
    
    
    
    
    
    
    func pausedScene(){
        
        
        
        currentGameState = gameState.paused
        
        
        coinsNum.removeFromParent()
        
        self.isPaused = true
        
        
        backingAudio?.pause()
       if dashedLine.isHidden == true{
            dashedLineHidden = true
        }
        else{
            dashedLineHidden = false
        }
        
       
        if Missed.isHidden == true{
            noGoal = true
        }
        else{
            noGoal = false
        }
        
        
        if currentlyOnFire && sound == true{ //flame sound was previously on before going to pause screen
            flameSound.removeFromParent()
        }
        if self.action(forKey: "bubble") != nil{
            self.removeAction(forKey: "bubble")
        }
        
        
        
        useFirePowerUp.isPaused = true
        
        

        for node in self.children{
            node.isHidden = true
        }
        
        
        if sound == false{
            noSound.texture = SKTexture(imageNamed: "PlayMusic")
        }
        
        
        
        
        self.enumerateChildNodes(withName: "background"){ //loop through all exisiting
            (backgrounD, stop) in
            backgrounD.isPaused = false
        }
        self.enumerateChildNodes(withName: "FireBackground"){ //loop through all exisiting
            (backgrounD, stop) in
            backgrounD.isPaused = false
        }
        self.enumerateChildNodes(withName: "WaterBackground"){ //loop through all exisiting
            (backgrounD, stop) in
            backgrounD.isPaused = false
        }
        //self.enumerateChildNodes(withName: "background"){ //loop through all exisiting
        //    (backgrounD, stop) in
        //    backgrounD.isPaused = false
       // }
        restart.isPaused = false
        restart.isHidden = false
        mainMenu.isPaused = false
        mainMenu.isHidden = false
        resume.isPaused = false
        resume.isHidden = false
        PausedTitle.isHidden = false
        noSound.isPaused = false
        noSound.isHidden = false
        noAdds.isHidden = false
        noAdds.isPaused = false
        scoreBoard.isHidden = false
        scoreBoard.isPaused = false
        moreBall.isHidden = false
        moreBall.isHidden = false
        
        
        
        
        if (arenaNum == 1){
            //setting alpha position of game items
            
            
            sixBox.isHidden = false
            sixBox.isPaused = false
            sixBox.alpha = 0.3
            yard_Box.isHidden = false
            yard_Box.isPaused = false
            yard_Box.alpha = 0.3
            circle.isHidden = false
            circle.isPaused = false
            circle.alpha = 0.3
            GoalLine.isHidden = false
            GoalLine.isPaused = false
            GoalLine.alpha = 0.3
            GoalLine.zPosition = -1
            startingLine.isHidden = false
            startingLine.isPaused = true
            startingLine.alpha = 0.3
            sideLineLeft.isHidden = false
            sideLineLeft.isPaused = true
            sideLineLeft.alpha = 0.3
            sideLineRight.isHidden = false
            sideLineRight.isPaused = true
            sideLineRight.alpha = 0.3
    
        }
        if (arenaNum == 2){
            //setting alpha position of game items
            sixBox.isHidden = true
            
            
            // sixBox.alpha = 0.3
            yard_Box.isHidden = true
            // yard_Box.isPaused = false
            // yard_Box.alpha = 0.3
            circle.isHidden = true
            // circle.isPaused = false
            //circle.alpha = 0.3
            GoalLine.isHidden = false
            GoalLine.isPaused = false
            GoalLine.alpha = 0.3
            GoalLine.zPosition = -1
            startingLine.isHidden = true
            //startingLine.isPaused = true
            // startingLine.alpha = 0.3
            sideLineLeft.isHidden = false
            sideLineLeft.isPaused = true
            sideLineLeft.alpha = 0.3
            sideLineRight.isHidden = false
            sideLineRight.isPaused = true
            sideLineRight.alpha = 0.3
        }
        if (arenaNum == 3){
            //setting alpha position of game items
            sixBox.isHidden = true
            //sixBox.isPaused = true
            // sixBox.alpha = 0.3
            yard_Box.isHidden = true
            // yard_Box.isPaused = false
            // yard_Box.alpha = 0.3
            circle.isHidden = true
            // circle.isPaused = false
            //circle.alpha = 0.3
            GoalLine.isHidden = false
            GoalLine.isPaused = false
            GoalLine.alpha = 0.3
            GoalLine.zPosition = -1
            startingLine.isHidden = true
            //startingLine.isPaused = true
            // startingLine.alpha = 0.3
            sideLineLeft.isHidden = false
            sideLineLeft.isPaused = true
            sideLineLeft.alpha = 0.3
            sideLineRight.isHidden = false
            sideLineRight.isPaused = true
            sideLineRight.alpha = 0.3
            
        }
        if (arenaNum == 4){
            //setting alpha position of game items
            
            
            sixBox.isHidden = true
            //sixBox.isPaused = true
           // sixBox.alpha = 0.3
            yard_Box.isHidden = true
           // yard_Box.isPaused = false
           // yard_Box.alpha = 0.3
            circle.isHidden = true
           // circle.isPaused = false
            //circle.alpha = 0.3
            GoalLine.isHidden = false
            GoalLine.isPaused = false
            GoalLine.alpha = 0.3
            GoalLine.zPosition = -1
            startingLine.isHidden = true
            //startingLine.isPaused = true
           // startingLine.alpha = 0.3
            sideLineLeft.isHidden = false
            sideLineLeft.isPaused = true
            sideLineLeft.alpha = 0.3
            sideLineRight.isHidden = false
            sideLineRight.isPaused = true
            sideLineRight.alpha = 0.3
            
        }
        
        
        
        
        
        
        
        GameGoal.isHidden = false
        GameGoal.isHidden = false
        GameGoal.alpha = 0.3
        GameBall.isHidden = false
        GameBall.isPaused = false
        GameBall.alpha = 0.3
        gameScoreLabel.isHidden = false
        gameScoreLabel.isPaused = false
        gameScoreLabel.alpha = 0.3
        powerUpNumLabel.isHidden = false
        powerUpNumLabel.isPaused = false
        powerUpNumLabel.alpha = 0.3
        useFirePowerUp.isHidden = false
        useFirePowerUp.isPaused = false
        useFirePowerUp.alpha = 0.3
        coinPic.isHidden = false
        coinPic.isPaused = false
        coinPic.alpha = 0.3
        coinsNum.isHidden = false
        coinsNum.isPaused = false
        coinsNum.alpha = 0.3
        pauseButton.isHidden = false
        pauseButton.alpha = 0.3
        
        
        self.enumerateChildNodes(withName: "fire"){ //loop through all exisiting
            (fire, stop) in
            fire.isHidden = false
            fire.isPaused = false
            fire.alpha = 0.3
        }
        
        
        self.enumerateChildNodes(withName: "coin"){ //loop through all exisiting
            (fire, stop) in
            fire.isHidden = false
            fire.isPaused = false
            fire.alpha = 0.3
        }
        self.enumerateChildNodes(withName: "PurpleGoal"){ //loop through all exisiting
            (fire, stop) in
            fire.isHidden = false
            fire.isPaused = false
            fire.alpha = 0.3
        }
        self.enumerateChildNodes(withName: "PurpleGoal"){ //loop through all exisiting
            (fire, stop) in
            fire.isHidden = false
            fire.isPaused = false
            fire.alpha = 0.3
        }
        self.enumerateChildNodes(withName: "blackHole"){ //loop through all exisiting
            (fire, stop) in
            fire.isHidden = false
            fire.isPaused = false
            fire.alpha = 0.3
        }
        
        
        
        
        currentGameState = gameState.paused
    }
    
    
    
    
    
    
    
    
    
    
    
    
    func resumeScene(){
        
        self.addChild(coinsNum)
        
        currentGameState = gameState.inGame
       
        self.isPaused = false
        
        
        
        
        if sound == true {
            backingAudio?.play()
        }
        for node in self.children{
            node.isHidden = false
        }
        if (sound == true && currentlyOnFire && arenaNum == 2){
            self.run(SKAction.repeatForever(bubbleSound), withKey: "bubble")
        }
        if sound == true && currentlyOnFire && (arenaNum == 1 || arenaNum == 3 || arenaNum == 4){
            self.addChild(flameSound)
        }
        if noGoal{
            Missed.isHidden = true
        }
        if dashedLineHidden{
            dashedLine.isHidden = true
        }
        scored.isHidden = true
        self.enumerateChildNodes(withName: "background"){ //loop through all exisiting
            (backgrounD, stop) in
            backgrounD.isHidden = false
            backgrounD.isPaused = false
        }
        
        
        
        
        restart.isPaused = true
        restart.isHidden = true
        PausedTitle.isHidden = true
        mainMenu.isPaused = true
        mainMenu.isHidden = true
        resume.isPaused = true
        resume.isHidden = true
        noSound.isPaused = true
        noSound.isHidden = true
        noAdds.isHidden = true
        noAdds.isPaused = true
        scoreBoard.isHidden = true
        scoreBoard.isPaused = true
        moreBall.isPaused = true
        moreBall.isHidden = true
        useFirePowerUp.isPaused = false
        if (arenaNum == 1){
            sideLineRight.isHidden = false
            sideLineLeft.isHidden = false
            sixBox.isHidden = false
            GoalLine.alpha = 1
            leftBorder.alpha = 1
            rightBorder.alpha = 1
            sixBox.alpha = 1
            yard_Box.alpha = 1
            circle.alpha = 1
            startingLine.alpha = 1
            sideLineLeft.alpha = 1
            sideLineRight.alpha = 1
            
            
        }
        if (arenaNum == 2){
            sideLineRight.isHidden = false
            sideLineLeft.isHidden = false
            sixBox.isHidden = true
            GoalLine.alpha = 1
            leftBorder.alpha = 1
            rightBorder.alpha = 1
            sixBox.alpha = 1
            yard_Box.isHidden = true
           circle.isHidden = true
            startingLine.isHidden = true
           
        
            
            
            sideLineLeft.alpha = 1
            sideLineRight.alpha = 1
            
            
        }
        if (arenaNum == 3){
            sideLineRight.isHidden = true
            sideLineLeft.isHidden = true
            
            sixBox.isHidden = true
            GoalLine.isHidden = true
            GoalLine.alpha = 1
            leftBorder.alpha = 1
            rightBorder.alpha = 1
            sixBox.alpha = 1
            yard_Box.isHidden = true
            circle.isHidden = true
            startingLine.isHidden = true
            
           
            
            
        }
        if (arenaNum == 4){
            
            sideLineRight.isHidden = false
            sideLineLeft.isHidden = false
            
            sixBox.isHidden = true
            GoalLine.isHidden = false
            GoalLine.alpha = 1
            leftBorder.alpha = 1
            rightBorder.alpha = 1
            sixBox.alpha = 1
            yard_Box.isHidden = true
            circle.isHidden = true
            startingLine.isHidden = true
            
            sideLineLeft.alpha = 1
            sideLineRight.alpha = 1
            
        }
        GameGoal.alpha = 1
        GameBall.alpha = 1
        coinsNum.alpha = 1
        pauseButton.alpha = 1
        useFirePowerUp.alpha = 1
        powerUpNumLabel.alpha = 1
        gameScoreLabel.alpha = 1
        coinPic.alpha = 1
        
        
        
        
        
        
        
        
        self.enumerateChildNodes(withName: "fire"){ //loop through all exisiting
            (fire, stop) in
            
            
            
            
            
            
            
            
            fire.alpha = 1
        }
        self.enumerateChildNodes(withName: "coin"){ //loop through all exisiting
            (fire, stop) in
            
            
            fire.alpha = 1
        }
        self.enumerateChildNodes(withName: "instantGoal"){ //loop through all exisiting
            (fire, stop) in
            
            
            fire.alpha = 1
        }
        
        
        
        
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func gameOver(){
        
        
        
        coinsNum.removeFromParent()
        
        
        
        
        currentGameState = gameState.afterGame
        //GameBall.isPaused = true
        
      //  gameLevel
        
        
        backingAudio?.stop()
        let sceneToMoveTo = GameOverScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        let myTransition = SKTransition.fade(withDuration: 0.5)
        self.view!.presentScene(sceneToMoveTo, transition: myTransition)
    }
    
    
    
    
    
    
    
    
    func setupSlingshot() {
        
        
        
        
        
        
        
        
        GameBall.position = Settings.Metrics.projectileRestPosition
        
        
        
        
        
        
        
        
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
        if (body1.categoryBitMask == physicsCategories.ball && body2.categoryBitMask == physicsCategories.goal ){
            
            
          
            
            
            StartNewLevel()
           
            
            touchedGoal = true
            
            
            if (arenaNum == 1) {
                let changeTexture = SKAction.setTexture(SKTexture(imageNamed: "Scored"))
                
                
                body2.node?.run(changeTexture)
                
                
            }
            if (arenaNum == 4){
                scored.isHidden = true
                scored.removeFromParent()
            }
            if (arenaNum == 2) {
                scored.isHidden = true
            }
            if (arenaNum == 3) {
                scored.isHidden = true
            }
            
            
            
            
            GameBall.physicsBody?.linearDamping = 65
            
            
            
            
            
            
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        if (body1.categoryBitMask == physicsCategories.ball && (body2.categoryBitMask == physicsCategories.horiPost)){
            //print("ball hit horiz post")
            //GameBall.physicsBody!.linearDamping = 100
        }
        if (body1.categoryBitMask == physicsCategories.ball && (body2.categoryBitMask == physicsCategories.vertPost1)){
            touchedInnerPost = true
            if (sound == true){
                self.run(postSound)
            }
            //  print("ball hit left post")
            //GameBall.physicsBody!.linearDamping = 100
            if (currentlyOnFire && arenaNum != 2){
                // let angle = atan2((GameBall.physicsBody?.velocity.dx)!, (GameBall.physicsBody?.velocity.dy)!)
                let emitter = self.childNode(withName: "MyParticle")
                //if (firstWallHit){
                emitter!.run(SKAction.rotate(byAngle: 3.14159 / 1.7, duration: 0.0001))
                
                
                
                
                
                
                
                
            }
            
            
            
            
            
            
            
            
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        if (body1.categoryBitMask == physicsCategories.ball && (body2.categoryBitMask == physicsCategories.vertPost2)){
            touchedInnerPost = true
            if (sound == true){
                self.run(postSound)
            }
            //  print("ball hit right post")
            //GameBall.physicsBody!.linearDamping = 100
            
            
            
            
            
            
            
            
            if (currentlyOnFire && arenaNum != 2){
                // let angle = atan2((GameBall.physicsBody?.velocity.dx)!, (GameBall.physicsBody?.velocity.dy)!)
                let emitter = self.childNode(withName: "MyParticle")
                //if (firstWallHit){
                emitter!.run(SKAction.rotate(byAngle: -3.14149 / 1.7, duration: 0.0001))
                
                
                
                
                
                
                
                
            }
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
        }
        
        
        
        
        
        
        
        
        if (body1.categoryBitMask == physicsCategories.ball && (body2.categoryBitMask == physicsCategories.topBorder)){
            
            health -= 1
            
            
            lives1.alpha = 0.1
            lives2.alpha = 0.1
            lives3.alpha = 0.1
            
            
            
            GameBall.physicsBody!.linearDamping = 1000
            Missed.isHidden = false
            if ( !touchedGoal){
                gameOver()
            }
            
            
            if (arenaNum == 4){
                smokeParticle()
            }
        }
        
        
        
        
        
        
        
        
        if  (body1.categoryBitMask == physicsCategories.ball && (body1.categoryBitMask == physicsCategories.outerPost1 || (body2.categoryBitMask == physicsCategories.outerPost2))){
            touchedOuterPost = true
            outerpostCollisionNum = outerpostCollisionNum + 1
            if outerpostCollisionNum >= 20{
                
                
                
                
                
                
                
                
                self.Missed.isHidden = false
                self.gameOver()
            }
            
            
            
            
            
            
            
            
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        if (body1.categoryBitMask == physicsCategories.ball && (body2.categoryBitMask == physicsCategories.bottomBorder)){
            //  print("ball hit bottom Border")
            GameBall.physicsBody!.linearDamping = 1000
            Missed.isHidden = false
            gameOver()
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        if (body1.categoryBitMask == physicsCategories.ball && (body2.categoryBitMask == physicsCategories.QuickGoal)){
            GameBall.removeAllActions()
            GameBall.physicsBody!.contactTestBitMask = 0
            GameBall.physicsBody!.collisionBitMask = 0
            GameBall.physicsBody!.velocity = CGVector(dx: 0, dy: 0)
            teleportation()
            instantGoalEmitter()
            
            
            
            
        }
        
        
        
        
        
        
        
        
        if (body1.categoryBitMask == physicsCategories.ball && (body2.categoryBitMask == physicsCategories.blackHole)){
            GameBall.removeAllActions()
            GameBall.physicsBody!.contactTestBitMask = 0
            GameBall.physicsBody!.collisionBitMask = 0
            GameBall.physicsBody!.velocity = CGVector(dx: 0, dy: 0)
            blackHole()
            
            
            
            
            
            
            
            
        }
        
        
        
        
        
        
        
        
        if (body1.categoryBitMask == physicsCategories.ball && (body2.categoryBitMask ==
            physicsCategories.fire)){
            FireDustEmitter()
            if (currentBallNumber == 26){
                powerUpCount += 2
            }
            else {
                powerUpCount += 1
            }
            inSafetyArea = false
            shotBall = false
            let fadeOut = SKAction.fadeOut(withDuration: 0.2)
            let fadeIn = SKAction.fadeIn(withDuration: 0.2)
            let fireFade = SKAction.sequence([fadeOut])
            if (body2.node != nil){
                body2.node?.run(fireFade)
            }
            
            
            
            
            useFirePowerUp.alpha = 1
            // powerUpNumLabel.text = "\(firePowerUps)"
            //powerUpNumLabel.isHidden = true
            powerUpNumLabel.run(SKAction.sequence([fadeOut, fadeIn]))
            delay(0.2){
                // self.powerUpNumLabel.isHidden = false
                if (currentBallNumber == 26){
                    self.firePowerUps = self.firePowerUps + 2
                }
                else {
                    self.firePowerUps = self.firePowerUps + 1
                }
                defaults.set(self.firePowerUps, forKey: "firePowerUps")
                self.powerUpNumLabel.text = "\(self.firePowerUps)"
            }
            
            
            
            
            body2.node?.removeFromParent()
        }
        
        
        
        
        
        
        
        
        if (body1.categoryBitMask == physicsCategories.ball && (body2.categoryBitMask == physicsCategories.leftBorder)){
            // print("ball hit left Border")
            if (currentlyOnFire && arenaNum != 2){
                // let angle = atan2((GameBall.physicsBody?.velocity.dx)!, (GameBall.physicsBody?.velocity.dy)!)
                let emitter = self.childNode(withName: "MyParticle")
                //if (firstWallHit){
                emitter!.run(SKAction.rotate(byAngle: -3.14159 / 1.5, duration: 0.0001))
            }
            if (sound == true){
                self.run(wallSound)
            }
            wallCollisionNum = wallCollisionNum + 1
            if wallCollisionNum >= 20{
                self.Missed.isHidden = false
                self.gameOver()
            }
            if (arenaNum == 4){
                smokeParticle()
            }
        }
        
        
        
        
        if (body1.categoryBitMask == physicsCategories.ball && (body2.categoryBitMask == physicsCategories.rightBorder)){
            //  print("ball hit right Border")
            if (currentlyOnFire && arenaNum != 2){
                let emitter = self.childNode(withName: "MyParticle")
                emitter!.run(SKAction.rotate(byAngle: 3.14159 / 1.5, duration: 0.0001))
            }
            
            
            
            
            if (sound == true){
                self.run(wallSound)
            }
            wallCollisionNum = wallCollisionNum + 1
            if wallCollisionNum >= 20{
                delay(0.5){
                    self.Missed.isHidden = false
                    self.gameOver()
                }
            }
            if (arenaNum == 4){
                smokeParticle()
            }
        }
        
        
        
        
        if (body1.categoryBitMask == physicsCategories.ball) && (body2.categoryBitMask == physicsCategories.defender){
            if (sound == true && currentlyOnFire && (arenaNum == 1 || arenaNum == 3)){
                self.run(explosionSound)
            }
            if (sound == true && (arenaNum == 2)){
                self.run(bubbleHitDefSound)
            }
            
            
            
            
            if (sound == true && !currentlyOnFire){
                self.run(wallSound)
            }
        }
        
        
        
        
        if (body1.categoryBitMask == physicsCategories.ball) && (body2.categoryBitMask == physicsCategories.rock){
        }
        
        
        
        
        
        
        
        
        if ((body2.categoryBitMask == physicsCategories.defender || body2.categoryBitMask == physicsCategories.resistantDefender) && body1.categoryBitMask == physicsCategories.rightBorder){
            delay (0.5){
                
                
                
                
                
                
                
                
                if (body2.velocity.dx) > CGFloat(-300.0){ //after colliding with right border, check the defender's speed going to left; if its slower than 300, then increase to speed of 300
                    //print ("speed left")
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    body2.velocity.dx = -300.0
                }
            }
            if (arenaNum == 2){
                
                
                
                
                
                
                
                
                var changeTextureDefender = SKAction.setTexture(SKTexture(imageNamed: "SharkFlip"))
                
                
                
                
                if (body2.node?.name == "resistantDefender" || body2.node?.name == "newresistantDefender"){
                    changeTextureDefender =  SKAction.setTexture(SKTexture(imageNamed: "BlackSharkFlip"))
                }
                
                
                
                
                
                
                
                
                body2.node?.run(changeTextureDefender)
                body2.node?.alpha = 1.0
            }
        }
        if ((body2.categoryBitMask == physicsCategories.defender || body2.categoryBitMask == physicsCategories.resistantDefender) && body1.categoryBitMask == physicsCategories.leftBorder){
            delay (0.5){
                if (body2.velocity.dx) < CGFloat(300.0){//after colliding with left border, check the defender's speed going to right; if its slower than 300, then increase to speed of 300
                    //  print ("speed right")
                    body2.velocity.dx = 300.0
                }
            }
            if (arenaNum == 2){
                var changeTextureDefender = SKAction.setTexture(SKTexture(imageNamed: "Shark"))
                
                
                
                
                if (body2.node?.name == "resistantDefender" || body2.node?.name == "newresistantDefender"){
                    changeTextureDefender =  SKAction.setTexture(SKTexture(imageNamed: "BlackShark"))
                }
                body2.node?.run(changeTextureDefender)
            }
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
        }
        if (body1.categoryBitMask == physicsCategories.ball && body2.categoryBitMask == physicsCategories.SafetyArea && body2.node?.name != "currentSafetyArea" ){
            SafetyDustEmitter()
            
            
            let changeTexture = SKAction.setTexture(SKTexture(imageNamed: "current_SafteyArea"))
            body2.node?.run(changeTexture)
            
            
            
            
            
            
            
            
            self.enumerateChildNodes(withName: "currentSafetyArea"){
                (safety, stop) in
                safety.name = "player"
            }
            body2.node?.name = "currentSafetyArea"
            
            
            
            
            
            
            shotBall = false
            if (sound == true){
                self.run(safetyAreaSound)
            }
            Settings.Metrics.projectileRestPosition = body2.node!.position
            // shootFromSafetyArea = true
            GameBall.physicsBody?.contactTestBitMask = physicsCategories.goal | physicsCategories.horiPost | physicsCategories.vertPost1 | physicsCategories.vertPost2 | physicsCategories.leftBorder | physicsCategories.rightBorder | physicsCategories.QuickGoal | physicsCategories.fire | physicsCategories.coin | physicsCategories.SafetyArea | physicsCategories.resistantDefender
            GameBall.removeAllActions()
            GameBall.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            let moveBallToSafetyArea = SKAction.move(to: body2.node!.position, duration: 0.8)
            GameBall.run(moveBallToSafetyArea)
        }
        if (body1.categoryBitMask == physicsCategories.ball && body2.categoryBitMask == physicsCategories.coin){
            
            
            
            
            
            
            
            
            CoinDustEmitter()
            if (currentBallNumber == 27){
                coinCount += 2
            }
            else{
                coinCount += 1
                
            }
            //print("coinCount")
            
            
            
            
            
            
            
            
            if (sound){
                self.run(coinSound)
            }
            let fadeOut = SKAction.fadeOut(withDuration: 0.5)
            let fireFade = SKAction.sequence([fadeOut])
            if (body2.node != nil){
                body2.node?.run(fireFade)
            }
            if (currentBallNumber == 27){
                coins = coins + 2
                defaults.set(coins, forKey: "coinsSaved")
            }
            else{
                coins = coins + 100
                defaults.set(coins, forKey: "coinsSaved")
                
            }
            
            coinsNum.text = " \(coins)"
            body2.node?.removeFromParent()

            
            
        }
    }
    
    
    
    
    
    
    
    
    func SpawnMetior() {
        
        
        var samePos : Bool = true
        var randYStart = random(min: gameArea.minY + gameArea.size.height*0.10, max: gameArea.maxY - gameArea.size.height * 0.10)
        
        
        let randYEnd = random(min: gameArea.minY + gameArea.size.height*0.10, max: gameArea.maxY - gameArea.size.height * 0.10)
        
        
        
        
        while samePos{   //set random y position
            //print("loop")
            var flag: Bool = false
            self.enumerateChildNodes(withName: "defender"){ //loop through all exisiting defenders
                //if the new spawning defender
                //has y position that is close to another exisitng defender's y pos,
                //then generate a new random y pos and go through loop again
                (defender, stop) in
                if randYStart >= defender.position.y - 20 && randYStart <= defender.position.y + 20   {
                    flag = true
                }
            }
            self.enumerateChildNodes(withName: "player"){ //loop through all exisiting defenders
                //if the new spawning defender
                //has y position that is close to another exisitng defender's y pos,
                //then generate a new random y pos and go through loop again
                (defender, stop) in
                if randYStart >= defender.position.y - 60 && randYStart <= defender.position.y + 60   {
                    flag = true
                }
            }
            
            
            if flag == true{
                randYStart = random(min: gameArea.minY + gameArea.size.height*0.45, max: gameArea.maxY - gameArea.size.height * 0.30)
            }
            else{ //if new randY pos steers clear of exisitng defenders y positions, spawn defender at new random loc
                samePos = false
            }
        }
        
        
        let startPt1 = CGPoint(x: self.size.width + 100, y: randYStart)
        let startPt2 = CGPoint(x: -100, y: randYStart)
        var metior = SKSpriteNode()
        let dx1 = startPt1.x - startPt2.x
        let dy = randYStart - randYEnd
        let dx2  = startPt2.x - startPt1.x
        let amountRotated1 = atan2(dy, dx1)
        let amountRotated2 = atan2(dy, dx2)
        
        
        
        
        metior = SKSpriteNode(imageNamed: "metior_1")
        metior.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: metior.size.width - 10, height: 10.0))
        metior.physicsBody!.mass = 1
        metior.setScale(0.75)
        if (switchDirection){
            metior.position = startPt1
        }
        else{
            metior.position = startPt2
        }
        
        
        metior.zPosition = 101
        metior.physicsBody!.affectedByGravity = false
        metior.physicsBody!.categoryBitMask = physicsCategories.metior
        metior.physicsBody!.collisionBitMask = physicsCategories.SafetyArea
        metior.physicsBody!.contactTestBitMask = physicsCategories.SafetyArea
        metior.physicsBody!.isDynamic = true
        metior.physicsBody!.allowsRotation = false
        metior.name = "Metior"
        metior.physicsBody!.restitution = 1
        metior.physicsBody!.friction = 0
        metior.alpha = 1
        let fadeIn = SKAction.fadeIn(withDuration: 0.08)
        let fadeOut = SKAction.fadeOut(withDuration: 0.08)
        let seq = SKAction.sequence([fadeIn,fadeOut, fadeIn, fadeOut, fadeIn, fadeIn,fadeOut, fadeIn, fadeOut, fadeIn])
        GameBall.physicsBody?.collisionBitMask = physicsCategories.horiPost | physicsCategories.vertPost1 | physicsCategories.vertPost2 | physicsCategories.leftBorder | physicsCategories.rightBorder
        GameBall.physicsBody?.contactTestBitMask = physicsCategories.goal | physicsCategories.horiPost | physicsCategories.vertPost1 | physicsCategories.vertPost2 | physicsCategories.leftBorder | physicsCategories.rightBorder | physicsCategories.QuickGoal | physicsCategories.fire | physicsCategories.SafetyArea | physicsCategories.coin
        
        
        
        
        
        
        
        
        if (currentlyOnFire){ //if ball is on fire, then make defender vulnerbale to be knocked out
            metior.physicsBody!.collisionBitMask = physicsCategories.ball
            metior.physicsBody!.contactTestBitMask = physicsCategories.ball
        }
        self.addChild(metior)
        metior.run(seq)
        
        
        
         
        var moveDeffender = SKAction.move(to: CGPoint(x: -100, y: randYEnd + 100), duration: 5.0)
        var moveDeffenderRight = SKAction.move(to: CGPoint(x: self.size.width + 100, y: randYEnd + 100), duration: 5.0)
        let moveSeq = SKAction.sequence([moveDeffender, SKAction.removeFromParent()])
        let moveSeq2 = SKAction.sequence([moveDeffenderRight, SKAction.removeFromParent()])

        if (gameLevel > 90){
            moveDeffender = SKAction.move(to: CGPoint(x: -100, y: randYEnd + 100), duration: 4.0)
            moveDeffenderRight = SKAction.move(to: CGPoint(x: self.size.width + 100, y: randYEnd + 100), duration: 4.0)

        }
        if (gameLevel > 95){
            moveDeffender = SKAction.move(to: CGPoint(x: -100, y: randYEnd + 100), duration: 2.5)
            moveDeffenderRight = SKAction.move(to: CGPoint(x: self.size.width + 100, y: randYEnd + 100), duration: 2.5)

        }
        
        
        
        
        delay(0.88){
            if (!self.currentlyOnFire){ //if gameBall is not currently on fire, after 1.5 seconds of temporary inability of newly
                self.GameBall.physicsBody!.collisionBitMask =  physicsCategories.horiPost | physicsCategories.vertPost1 | physicsCategories.vertPost2 | physicsCategories.leftBorder | physicsCategories.rightBorder | physicsCategories.defender | physicsCategories.rock | physicsCategories.metior | physicsCategories.resistantDefender
                self.GameBall.physicsBody!.contactTestBitMask = physicsCategories.goal | physicsCategories.horiPost | physicsCategories.vertPost1 | physicsCategories.vertPost2 | physicsCategories.leftBorder | physicsCategories.rightBorder | physicsCategories.defender | physicsCategories.QuickGoal | physicsCategories.fire | physicsCategories.bubble | physicsCategories.rock | physicsCategories.SafetyArea | physicsCategories.metior | physicsCategories.resistantDefender
            }
            if (switchDirection){
                metior.texture = SKTexture(imageNamed: "metior_1_flip")
                metior.run(moveSeq)
                switchDirection = false
                metior.zRotation = amountRotated1
            }
            else{
                metior.run(moveSeq2)
                switchDirection = true
                metior.zRotation = amountRotated2 + 3.14159
            }
        }
        
        
        
        
    }
    
    
    
    
    func SpawnRock(){
        
        
        
        
        //  print("rock loop")
        
        
        
        
        var randXStart = random(min: gameArea.minX , max: gameArea.maxX )
        let randXEnd = random(min: gameArea.minX, max: gameArea.maxX)
        var samePos : Bool = true
        
        
        
        
        while samePos{   //set random y position
            
            
            
            
            var flag: Bool = false
            
            
            
            
            if randXStart >= GameBall.position.y - 200 && randXStart <= GameBall.position.y + 200   {
                flag = true
            }
            
            
            
            
            if flag == true{
                randXStart = random(min: gameArea.minX + gameArea.size.height*0.45, max: gameArea.maxX - gameArea.size.height * 0.30)
            }
            else{ //if new randY pos steers clear of exisitng defenders y positions, spawn defender at new random loc
                samePos = false
            }
        }
        
        
        
        
        let startPt = CGPoint(x: randXStart, y: self.size.height * 1.1)
        let endPt = CGPoint(x: randXEnd, y: self.size.height * -0.2)
        var rock = SKSpriteNode(imageNamed: "Rock1")
        
        
        
        
        
        rock.position = startPt
        rock.zPosition = 500
        rock = SKSpriteNode(imageNamed: "Rock1")
        rock.physicsBody = SKPhysicsBody(circleOfRadius: rock.size.width*0.5)
        rock.setScale(1.7)
        rock.position = startPt
        rock.physicsBody!.affectedByGravity = false
        rock.physicsBody!.categoryBitMask = physicsCategories.rock
        rock.physicsBody!.collisionBitMask =  physicsCategories.leftBorder | physicsCategories.rightBorder
        rock.physicsBody!.contactTestBitMask =  physicsCategories.leftBorder | physicsCategories.rightBorder
        rock.physicsBody!.isDynamic = true
        rock.physicsBody!.allowsRotation = false
        rock.name = "rock"
        rock.physicsBody!.affectedByGravity = true
        rock.physicsBody!.restitution = 1
        rock.physicsBody!.friction = 0
        rock.alpha = 1
        if (currentlyOnFire){ //if ball is on fire, then make defender vulnerbale to be knocked out
            rock.physicsBody!.collisionBitMask = physicsCategories.leftBorder | physicsCategories.rightBorder | physicsCategories.ball
            rock.physicsBody!.contactTestBitMask = physicsCategories.leftBorder | physicsCategories.rightBorder | physicsCategories.ball
        }
        self.addChild(rock)
        let moverock = SKAction.move(to: endPt, duration: 4.0)
        let deleteRock = SKAction.removeFromParent()
        let rockSeq = SKAction.sequence([moverock, deleteRock])
        
        
        
        
        
        
        rock.run(rockSeq)
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func SpawnDefender(){
        var samePos : Bool = true
        var randYStart = random(min: gameArea.minY + gameArea.size.height*0.25, max: gameArea.maxY - gameArea.size.height * 0.13)
        
        
        if ((gameLevel > 0 && gameLevel <= 5) || (gameLevel > 25 &&  gameLevel <=  30) || (gameLevel > 50 && gameLevel <= 55) || (gameLevel > 75 && gameLevel <= 80) ){
            randYStart = random(min: gameArea.minY + gameArea.size.height*0.45, max: gameArea.maxY - gameArea.size.height * 0.45)
        }
        else if ((gameLevel > 5 && gameLevel <= 10) || (gameLevel > 30 &&  gameLevel <=  35) || (gameLevel > 55 && gameLevel <= 60) || (gameLevel > 80 && gameLevel <= 85) ){
            randYStart = random(min: gameArea.minY + gameArea.size.height*0.37, max: gameArea.maxY - gameArea.size.height * 0.32)
        }
        else if ((gameLevel > 10 && gameLevel <= 20) || (gameLevel > 35 &&  gameLevel <=  45) || (gameLevel > 60 && gameLevel <= 70) || (gameLevel > 85 && gameLevel <= 95) ){
            randYStart = random(min: gameArea.minY + gameArea.size.height*0.3, max: gameArea.maxY - gameArea.size.height * 0.25)
        }
        else if ((gameLevel > 20 && gameLevel <= 25) || (gameLevel > 45 &&  gameLevel <=  50) || (gameLevel > 70 && gameLevel <= 75) || (gameLevel > 95 && gameLevel <= 100) ){
            randYStart = random(min: gameArea.minY + gameArea.size.height*0.2, max: gameArea.maxY - gameArea.size.height * 0.13)
        }
        
        
        var randXStart = random(min:  gameArea.size.width * 0.3, max: gameArea.size.width * 0.7)
        
        
        if ((gameLevel > 0 && gameLevel <= 5) || (gameLevel > 25 &&  gameLevel <=  30) || (gameLevel > 50 && gameLevel <= 55) || (gameLevel > 75 && gameLevel <= 80) ){
            randXStart = random(min:  gameArea.size.width * 0.45, max: gameArea.size.width * 0.55)        }
        else if ((gameLevel > 5 && gameLevel <= 10) || (gameLevel > 30 &&  gameLevel <=  35) || (gameLevel > 55 && gameLevel <= 60) || (gameLevel > 80 && gameLevel <= 85) ){
            randXStart = random(min:  gameArea.size.width * 0.4, max: gameArea.size.width * 0.6)        }
            
            
        else if ((gameLevel > 10 && gameLevel <= 20) || (gameLevel > 35 &&  gameLevel <=  45) || (gameLevel > 60 && gameLevel <= 70) || (gameLevel > 85 && gameLevel <= 95) ){
            randXStart = random(min:  gameArea.size.width * 0.35, max: gameArea.size.width * 0.65)        }
        else if ((gameLevel > 20 && gameLevel <= 25) || (gameLevel > 45 &&  gameLevel <=  50) || (gameLevel > 70 && gameLevel <= 75) || (gameLevel > 95 && gameLevel <= 100) ){
            randXStart = random(min:  gameArea.size.width * 0.3, max: gameArea.size.width * 0.7)        }
        
        
        
        
        while samePos{   //set random y position
            //print("loop")
            var flag: Bool = false
            self.enumerateChildNodes(withName: "defender"){ //loop through all exisiting defenders
                //if the new spawning defender
                //has y position that is close to another exisitng defender's y pos,
                //then generate a new random y pos and go through loop again
                (defender, stop) in
                if randYStart >= defender.position.y - 20 && randYStart <= defender.position.y + 20   {
                    flag = true
                }
            }
            self.enumerateChildNodes(withName: "resistantDefender"){ //loop through all exisiting defenders
                //if the new spawning defender
                //has y position that is close to another exisitng defender's y pos,
                //then generate a new random y pos and go through loop again
                (defender, stop) in
                if randYStart >= defender.position.y - 20 && randYStart <= defender.position.y + 20   {
                    flag = true
                }
            }
            self.enumerateChildNodes(withName: "newdefender"){ //loop through all exisiting defenders
                //if the new spawning defender
                //has y position that is close to another exisitng defender's y pos,
                //then generate a new random y pos and go through loop again
                (defender, stop) in
                if randYStart >= defender.position.y - 20 && randYStart <= defender.position.y + 20   {
                    flag = true
                }
            }
            self.enumerateChildNodes(withName: "newresistantDefender"){ //loop through all exisiting defenders
                //if the new spawning defender
                //has y position that is close to another exisitng defender's y pos,
                //then generate a new random y pos and go through loop again
                (defender, stop) in
                if randYStart >= defender.position.y - 20 && randYStart <= defender.position.y + 20   {
                    flag = true
                }
            }
            self.enumerateChildNodes(withName: "player"){ //loop through all exisiting defenders
                
                
                
                
                
                
                
                
                (defender, stop) in
                if randYStart >= defender.position.y - 60 && randYStart <= defender.position.y + 60   {
                    flag = true
                }
            }
            
            
            
            
            
            
            
            
            if flag == true{
                
                
                if ((gameLevel > 0 && gameLevel <= 5) || (gameLevel > 25 &&  gameLevel <=  30) || (gameLevel > 50 && gameLevel <= 55) || (gameLevel > 75 && gameLevel <= 80) ){
                    randYStart = random(min: gameArea.minY + gameArea.size.height*0.45, max: gameArea.maxY - gameArea.size.height * 0.45)
                }
                else if ((gameLevel > 5 && gameLevel <= 10) || (gameLevel > 30 &&  gameLevel <=  35) || (gameLevel > 55 && gameLevel <= 60) || (gameLevel > 80 && gameLevel <= 85) ){
                    randYStart = random(min: gameArea.minY + gameArea.size.height*0.37, max: gameArea.maxY - gameArea.size.height * 0.32)
                }
                else if ((gameLevel > 10 && gameLevel <= 20) || (gameLevel > 35 &&  gameLevel <=  45) || (gameLevel > 60 && gameLevel <= 70) || (gameLevel > 85 && gameLevel <= 95) ){
                    randYStart = random(min: gameArea.minY + gameArea.size.height*0.3, max: gameArea.maxY - gameArea.size.height * 0.25)
                }
                else if ((gameLevel > 20 && gameLevel <= 25) || (gameLevel > 45 &&  gameLevel <=  50) || (gameLevel > 70 && gameLevel <= 75) || (gameLevel > 95 && gameLevel <= 100) ){
                    randYStart = random(min: gameArea.minY + gameArea.size.height*0.2, max: gameArea.maxY - gameArea.size.height * 0.13)
                }
            }
            else{ //if new randY pos steers clear of exisitng defenders y positions, spawn defender at new random loc
                samePos = false
            }
        }
        samePos = true
        while samePos{   //set random x position
            // print("LLLoop")
            var flag: Bool = false
            self.enumerateChildNodes(withName: "defender"){ //loop through all exisiting defenders
                //if the new spawning defender
                //has y position that is close to another exisitng defender's y pos,
                //then generate a new random y pos and go through loop again
                (defender, stop) in
                if randXStart >= defender.position.x - 30 && randXStart <= defender.position.x + 30  {
                    flag = true
                }
            }
            self.enumerateChildNodes(withName: "resistantDefender"){ //loop through all exisiting defenders
                //if the new spawning defender
                //has y position that is close to another exisitng defender's y pos,
                //then generate a new random y pos and go through loop again
                (defender, stop) in
                if randXStart >= defender.position.x - 30 && randXStart <= defender.position.x + 30  {
                    flag = true
                }
            }
            self.enumerateChildNodes(withName: "newdefender"){ //loop through all exisiting defenders
                //if the new spawning defender
                //has y position that is close to another exisitng defender's y pos,
                //then generate a new random y pos and go through loop again
                (defender, stop) in
                if randXStart >= defender.position.x - 30 && randXStart <= defender.position.x + 30  {
                    flag = true
                }
            }
            self.enumerateChildNodes(withName: "newresistantDefender"){ //loop through all exisiting defenders
                //if the new spawning defender
                //has y position that is close to another exisitng defender's y pos,
                //then generate a new random y pos and go through loop again
                (defender, stop) in
                if randXStart >= defender.position.x - 30 && randXStart <= defender.position.x + 30  {
                    flag = true
                }
            }
            if flag == true{
                if ((gameLevel > 0 && gameLevel <= 5) || (gameLevel > 25 &&  gameLevel <=  30) || (gameLevel > 50 && gameLevel <= 55) || (gameLevel > 75 && gameLevel <= 80) ){
                    randXStart = random(min:  gameArea.size.width * 0.45, max: gameArea.size.width * 0.55)        }
                else if ((gameLevel > 5 && gameLevel <= 10) || (gameLevel > 30 &&  gameLevel <=  35) || (gameLevel > 55 && gameLevel <= 60) || (gameLevel > 80 && gameLevel <= 85) ){
                    randXStart = random(min:  gameArea.size.width * 0.4, max: gameArea.size.width * 0.6)        }
                    
                    
                else if ((gameLevel > 10 && gameLevel <= 20) || (gameLevel > 35 &&  gameLevel <=  45) || (gameLevel > 60 && gameLevel <= 70) || (gameLevel > 85 && gameLevel <= 95) ){
                    randXStart = random(min:  gameArea.size.width * 0.35, max: gameArea.size.width * 0.65)        }
                else if ((gameLevel > 20 && gameLevel <= 25) || (gameLevel > 45 &&  gameLevel <=  50) || (gameLevel > 70 && gameLevel <= 75) || (gameLevel > 95 && gameLevel <= 100) ){
                    randXStart = random(min:  gameArea.size.width * 0.3, max: gameArea.size.width * 0.7)        }
                
                
            }
            else{ //if new randY pos steers clear of exisitng defenders y positions, spawn defender at new random loc
                samePos = false
            }
        }
        
        
        
        
        
        
        
        
        let startPt = CGPoint(x: randXStart, y: randYStart)
        var Defender = SKSpriteNode()
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        if (arenaNum == 1 || arenaNum == 3 ){
            
            
            
            
            
            
            
            
            Defender = SKSpriteNode(imageNamed: "Line")
            Defender.setScale(3)
        }
        
        
        
        
        
        
        
        
        if (arenaNum == 2){ //defenders are sharks
            
            
            Defender = SKSpriteNode(imageNamed: "Shark")
            Defender.setScale(2.0)
        }
        
        
        if (arenaNum == 4){
            
            Defender = SKSpriteNode(imageNamed: "stardeffenders")
            Defender.setScale(0.35)
        }
        
        
        
        
        
        
        
        
        
        Defender.position = startPt
        Defender.zPosition = 301
        
        
        
        
        
        
        
        
        Defender.name = "newdefender"
        
        
        
        
        Defender.alpha = 0
        let fadeIn = SKAction.fadeIn(withDuration: 0.08)
        let fadeOut = SKAction.fadeOut(withDuration: 0.08)
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        let seq = SKAction.sequence([fadeIn,fadeOut, fadeIn, fadeOut, fadeIn, fadeIn])
        //temporarily make defender unable to knock out gameBall
        /*GameBall.physicsBody?.collisionBitMask = physicsCategories.horiPost | physicsCategories.vertPost1 | physicsCategories.vertPost2 | physicsCategories.leftBorder | physicsCategories.rightBorder
         GameBall.physicsBody?.contactTestBitMask = physicsCategories.goal | physicsCategories.horiPost | physicsCategories.vertPost1 | physicsCategories.vertPost2 | physicsCategories.leftBorder | physicsCategories.rightBorder | physicsCategories.QuickGoal | physicsCategories.fire | physicsCategories.SafetyArea | physicsCategories.coin*/
        
        
        
        
        self.addChild(Defender)
        if (arenaNum == 1){
            Defender.run(seq)
        }
        else if (arenaNum == 2){
            Defender.run(SKAction.fadeIn(withDuration: 2.0))
        }
        let moveDeffender = SKAction.applyImpulse(CGVector(dx: -2000, dy: 0), duration: 1.0)
        let moveDeffenderRight = SKAction.applyImpulse(CGVector(dx: 2000, dy: 0), duration: 1.0)
        
        
        
        
        if (arenaNum != 2){
            delay(0.56){
                
                
                
                
                
                
                
                
                
                
                
                
                if (arenaNum == 1 || arenaNum == 3 || arenaNum == 4){
                    
                    
                    
                    
                    
                    
                    
                    
                    Defender.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: Defender.size.width - 20, height: 20.0))
                }
                
                
                
                
                
                
                
                
                
                
                
                
                if (arenaNum == 2){ //defenders are sharks
                    Defender.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: Defender.size.width - 20, height: 30.0))
                }
                
                
                
                
                
                
                
                
                
                
                
                
                Defender.physicsBody!.mass = 5
                Defender.physicsBody!.affectedByGravity = false
                Defender.physicsBody!.categoryBitMask = physicsCategories.defender
                Defender.physicsBody!.collisionBitMask =  physicsCategories.leftBorder | physicsCategories.rightBorder | physicsCategories.SafetyArea
                Defender.physicsBody!.contactTestBitMask =  physicsCategories.leftBorder | physicsCategories.rightBorder | physicsCategories.SafetyArea
                Defender.physicsBody!.isDynamic = true
                Defender.physicsBody!.allowsRotation = false
                Defender.name = "defender"
                Defender.physicsBody!.restitution = 1
                Defender.physicsBody!.friction = 0
                
                
                
                
                
                
                
                
                if (self.currentlyOnFire){ //if ball is on fire, then make defender vulnerbale to be knocked out
                    Defender.physicsBody!.collisionBitMask = physicsCategories.leftBorder | physicsCategories.rightBorder | physicsCategories.ball | physicsCategories.resistantDefender
                    Defender.physicsBody!.contactTestBitMask = physicsCategories.leftBorder | physicsCategories.rightBorder | physicsCategories.ball | physicsCategories.resistantDefender
                }
                
                
                
                
                if (switchDirection == false){
                    Defender.run(moveDeffender)
                    if (arenaNum == 2){
                        Defender.texture = SKTexture(imageNamed: "SharkFlip")
                    }
                    switchDirection = true
                }
                else{
                    Defender.run(moveDeffenderRight)
                    switchDirection = false
                }
            }
        }
        else if (arenaNum == 2){
            if (switchDirection == false){
                Defender.run(SKAction.move(by: CGVector(dx: -60, dy: 0), duration: 1.5))
                Defender.texture = SKTexture(imageNamed: "SharkFlip")
                
                
                
                
                // switchDirection = true
            }
            else{
                Defender.run(SKAction.move(by: CGVector(dx: 60, dy: 0), duration: 1.5))
                Defender.texture = SKTexture(imageNamed: "Shark")
                // switchDirection = false
            }
            delay(1.5){
                
                
                
                
                Defender.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: Defender.size.width - 20, height: 30.0))
                
                
                
                
                Defender.physicsBody!.mass = 5
                Defender.physicsBody!.affectedByGravity = false
                Defender.physicsBody!.categoryBitMask = physicsCategories.defender
                Defender.physicsBody!.collisionBitMask =  physicsCategories.leftBorder | physicsCategories.rightBorder | physicsCategories.SafetyArea
                Defender.physicsBody!.contactTestBitMask =  physicsCategories.leftBorder | physicsCategories.rightBorder | physicsCategories.SafetyArea
                Defender.physicsBody!.isDynamic = true
                Defender.physicsBody!.allowsRotation = false
                Defender.name = "defender"
                Defender.physicsBody!.restitution = 1
                Defender.physicsBody!.friction = 0
                
                
                
                
                
                
                
                
                if (self.currentlyOnFire){ //if ball is on fire, then make defender vulnerbale to be knocked out
                    Defender.physicsBody!.collisionBitMask = physicsCategories.leftBorder | physicsCategories.rightBorder | physicsCategories.ball | physicsCategories.resistantDefender
                    Defender.physicsBody!.contactTestBitMask = physicsCategories.leftBorder | physicsCategories.rightBorder | physicsCategories.ball | physicsCategories.resistantDefender
                }
                
                
                
                
                if (switchDirection == false){
                    Defender.run(moveDeffender)
                    Defender.texture = SKTexture(imageNamed: "SharkFlip")
                    
                    
                    
                    
                    switchDirection = true
                }
                else{
                    Defender.run(moveDeffenderRight)
                    Defender.texture = SKTexture(imageNamed: "Shark")
                    
                    
                    
                    
                    switchDirection = false
                }
            }
        }
    }
    
    
    
    
    func SpawnResistantDefender(){
        
        var samePos : Bool = true
        var randYStart = random(min: gameArea.minY + gameArea.size.height*0.25, max: gameArea.maxY - gameArea.size.height * 0.13)
        
        
        if ((gameLevel > 0 && gameLevel <= 5) || (gameLevel > 25 &&  gameLevel <=  30) || (gameLevel > 50 && gameLevel <= 55) || (gameLevel > 75 && gameLevel <= 80) ){
            randYStart = random(min: gameArea.minY + gameArea.size.height*0.45, max: gameArea.maxY - gameArea.size.height * 0.45)
        }
        else if ((gameLevel > 5 && gameLevel <= 10) || (gameLevel > 30 &&  gameLevel <=  35) || (gameLevel > 55 && gameLevel <= 60) || (gameLevel > 80 && gameLevel <= 85) ){
            randYStart = random(min: gameArea.minY + gameArea.size.height*0.37, max: gameArea.maxY - gameArea.size.height * 0.32)
        }
        else if ((gameLevel > 10 && gameLevel <= 20) || (gameLevel > 35 &&  gameLevel <=  45) || (gameLevel > 60 && gameLevel <= 70) || (gameLevel > 85 && gameLevel <= 95) ){
            randYStart = random(min: gameArea.minY + gameArea.size.height*0.3, max: gameArea.maxY - gameArea.size.height * 0.25)
        }
        else if ((gameLevel > 20 && gameLevel <= 25) || (gameLevel > 45 &&  gameLevel <=  50) || (gameLevel > 70 && gameLevel <= 75) || (gameLevel > 95 && gameLevel <= 100) ){
            randYStart = random(min: gameArea.minY + gameArea.size.height*0.2, max: gameArea.maxY - gameArea.size.height * 0.13)
        }
        var randXStart = random(min:  gameArea.size.width * 0.5, max: gameArea.size.width * 0.8)
        if ((gameLevel > 0 && gameLevel <= 5) || (gameLevel > 25 &&  gameLevel <=  30) || (gameLevel > 50 && gameLevel <= 55) || (gameLevel > 75 && gameLevel <= 80) ){
            randXStart = random(min:  gameArea.size.width * 0.45, max: gameArea.size.width * 0.55)        }
        else if ((gameLevel > 5 && gameLevel <= 10) || (gameLevel > 30 &&  gameLevel <=  35) || (gameLevel > 55 && gameLevel <= 60) || (gameLevel > 80 && gameLevel <= 85) ){
            randXStart = random(min:  gameArea.size.width * 0.4, max: gameArea.size.width * 0.6)        }
            
            
        else if ((gameLevel > 10 && gameLevel <= 20) || (gameLevel > 35 &&  gameLevel <=  45) || (gameLevel > 60 && gameLevel <= 70) || (gameLevel > 85 && gameLevel <= 95) ){
            randXStart = random(min:  gameArea.size.width * 0.35, max: gameArea.size.width * 0.65)        }
        else if ((gameLevel > 20 && gameLevel <= 25) || (gameLevel > 45 &&  gameLevel <=  50) || (gameLevel > 70 && gameLevel <= 75) || (gameLevel > 95 && gameLevel <= 100) ){
            randXStart = random(min:  gameArea.size.width * 0.3, max: gameArea.size.width * 0.7)        }
        
        
        
        
        
        
        while samePos{   //set random y position
            //print("loop")
            var flag: Bool = false
            self.enumerateChildNodes(withName: "defender"){ //loop through all exisiting defenders
                //if the new spawning defender
                //has y position that is close to another exisitng defender's y pos,
                //then generate a new random y pos and go through loop again
                (defender, stop) in
                if randYStart >= defender.position.y - 20 && randYStart <= defender.position.y + 20   {
                    flag = true
                }
            }
            self.enumerateChildNodes(withName: "resistantDefender"){ //loop through all exisiting defenders
                //if the new spawning defender
                //has y position that is close to another exisitng defender's y pos,
                //then generate a new random y pos and go through loop again
                (defender, stop) in
                if randYStart >= defender.position.y - 20 && randYStart <= defender.position.y + 20   {
                    flag = true
                }
            }
            self.enumerateChildNodes(withName: "newresistantDefender"){ //loop through all exisiting defenders
                //if the new spawning defender
                //has y position that is close to another exisitng defender's y pos,
                //then generate a new random y pos and go through loop again
                (defender, stop) in
                if randYStart >= defender.position.y - 20 && randYStart <= defender.position.y + 20   {
                    flag = true
                }
            }
            self.enumerateChildNodes(withName: "newdefender"){ //loop through all exisiting defenders
                //if the new spawning defender
                //has y position that is close to another exisitng defender's y pos,
                //then generate a new random y pos and go through loop again
                (defender, stop) in
                if randYStart >= defender.position.y - 20 && randYStart <= defender.position.y + 20   {
                    flag = true
                }
            }
            self.enumerateChildNodes(withName: "player"){ //loop through all exisiting defenders
                
                
                
                
                
                
                
                
                (defender, stop) in
                if randYStart >= defender.position.y - 60 && randYStart <= defender.position.y + 60   {
                    flag = true
                }
            }
            
            
            
            
            
            
            
            
            if flag == true{
                
                
                if ((gameLevel > 0 && gameLevel <= 5) || (gameLevel > 25 &&  gameLevel <=  30) || (gameLevel > 50 && gameLevel <= 55) || (gameLevel > 75 && gameLevel <= 80) ){
                    randYStart = random(min: gameArea.minY + gameArea.size.height*0.45, max: gameArea.maxY - gameArea.size.height * 0.45)
                }
                else if ((gameLevel > 5 && gameLevel <= 10) || (gameLevel > 30 &&  gameLevel <=  35) || (gameLevel > 55 && gameLevel <= 60) || (gameLevel > 80 && gameLevel <= 85) ){
                    randYStart = random(min: gameArea.minY + gameArea.size.height*0.37, max: gameArea.maxY - gameArea.size.height * 0.32)
                }
                else if ((gameLevel > 10 && gameLevel <= 20) || (gameLevel > 35 &&  gameLevel <=  45) || (gameLevel > 60 && gameLevel <= 70) || (gameLevel > 85 && gameLevel <= 95) ){
                    randYStart = random(min: gameArea.minY + gameArea.size.height*0.3, max: gameArea.maxY - gameArea.size.height * 0.25)
                }
                else if ((gameLevel > 20 && gameLevel <= 25) || (gameLevel > 45 &&  gameLevel <=  50) || (gameLevel > 70 && gameLevel <= 75) || (gameLevel > 95 && gameLevel <= 100) ){
                    randYStart = random(min: gameArea.minY + gameArea.size.height*0.2, max: gameArea.maxY - gameArea.size.height * 0.13)
                }
            }
            else{ //if new randY pos steers clear of exisitng defenders y positions, spawn defender at new random loc
                samePos = false
            }
        }
        samePos = true
        while samePos{   //set random x position
            // print("LLLoop")
            var flag: Bool = false
            self.enumerateChildNodes(withName: "defender"){ //loop through all exisiting defenders
                //if the new spawning defender
                //has y position that is close to another exisitng defender's y pos,
                //then generate a new random y pos and go through loop again
                (defender, stop) in
                if randXStart >= defender.position.x - 30 && randXStart <= defender.position.x + 30  {
                    flag = true
                }
            }
            self.enumerateChildNodes(withName: "resistantDefender"){ //loop through all exisiting defenders
                //if the new spawning defender
                //has y position that is close to another exisitng defender's y pos,
                //then generate a new random y pos and go through loop again
                (defender, stop) in
                if randXStart >= defender.position.x - 30 && randXStart <= defender.position.x + 30  {
                    flag = true
                }
            }
            self.enumerateChildNodes(withName: "newresistantDefender"){ //loop through all exisiting defenders
                //if the new spawning defender
                //has y position that is close to another exisitng defender's y pos,
                //then generate a new random y pos and go through loop again
                (defender, stop) in
                if randXStart >= defender.position.x - 30 && randXStart <= defender.position.x + 30  {
                    flag = true
                }
            }
            self.enumerateChildNodes(withName: "newdefender"){ //loop through all exisiting defenders
                //if the new spawning defender
                //has y position that is close to another exisitng defender's y pos,
                //then generate a new random y pos and go through loop again
                (defender, stop) in
                if randXStart >= defender.position.x - 30 && randXStart <= defender.position.x + 30  {
                    flag = true
                }
            }
            if flag == true{
                if ((gameLevel > 0 && gameLevel <= 5) || (gameLevel > 25 &&  gameLevel <=  30) || (gameLevel > 50 && gameLevel <= 55) || (gameLevel > 75 && gameLevel <= 80) ){
                    randXStart = random(min:  gameArea.size.width * 0.45, max: gameArea.size.width * 0.55)        }
                else if ((gameLevel > 5 && gameLevel <= 10) || (gameLevel > 30 &&  gameLevel <=  35) || (gameLevel > 55 && gameLevel <= 60) || (gameLevel > 80 && gameLevel <= 85) ){
                    randXStart = random(min:  gameArea.size.width * 0.4, max: gameArea.size.width * 0.6)        }
                    
                    
                else if ((gameLevel > 10 && gameLevel <= 20) || (gameLevel > 35 &&  gameLevel <=  45) || (gameLevel > 60 && gameLevel <= 70) || (gameLevel > 85 && gameLevel <= 95) ){
                    randXStart = random(min:  gameArea.size.width * 0.35, max: gameArea.size.width * 0.65)        }
                else if ((gameLevel > 20 && gameLevel <= 25) || (gameLevel > 45 &&  gameLevel <=  50) || (gameLevel > 70 && gameLevel <= 75) || (gameLevel > 95 && gameLevel <= 100) ){
                    randXStart = random(min:  gameArea.size.width * 0.3, max: gameArea.size.width * 0.7)        }
                
                
            }
            else{ //if new randY pos steers clear of exisitng defenders y positions, spawn defender at new random loc
                samePos = false
            }
        }
        
        
        
        
        
        
        
        
        let startPt = CGPoint(x: randXStart, y: randYStart)
        var Defender = SKSpriteNode()
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        if (arenaNum == 1 || arenaNum == 3){
            
            
            
            
            Defender = SKSpriteNode(imageNamed: "blackLine")
            Defender.setScale(3)
        }
        
        
        
        
        
        
        
        
        if (arenaNum == 2){ //defenders are sharks
            Defender = SKSpriteNode(imageNamed: "BlackShark")
            Defender.setScale(2.0)
        }
        
        
        if (arenaNum == 4){
            
            Defender = SKSpriteNode(imageNamed: "stardeffenders")
            Defender.setScale(0.35)
         
        }
        
        
        
        
        
        
        
        
        
        
        Defender.position = startPt
        Defender.zPosition = 301
        
        
        
        
        Defender.name = "newresistantDefender"
        
        
        
        
        Defender.alpha = 0
        let fadeIn = SKAction.fadeIn(withDuration: 0.08)
        let fadeOut = SKAction.fadeOut(withDuration: 0.08)
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        let seq = SKAction.sequence([fadeIn,fadeOut, fadeIn, fadeOut, fadeIn, fadeIn])
        
        
        
        
        
        
        
        
        
        
        
        
        self.addChild(Defender)
        if arenaNum == 1{
            Defender.run(seq)
        }
        else if (arenaNum == 2){
            Defender.run(SKAction.fadeIn(withDuration: 2.0))
        }
        let moveDeffender = SKAction.applyImpulse(CGVector(dx: -2000, dy: 0), duration: 1.0)
        let moveDeffenderRight = SKAction.applyImpulse(CGVector(dx: 2000, dy: 0), duration: 1.0)
        
        
        
        
        
        
        
        
        if (arenaNum != 2){
            
            
            
            
            delay(0.56){
                
                
                
                
                if (arenaNum == 1 || arenaNum == 3 || arenaNum == 4){
                    
                    
                    
                    
                    Defender.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: Defender.size.width, height: 20.0))
                }
                
                
                
                
                
                
                
                
                
                
                
                
                Defender.physicsBody!.mass = 5
                Defender.physicsBody!.affectedByGravity = false
                Defender.physicsBody!.categoryBitMask = physicsCategories.resistantDefender
                Defender.physicsBody!.collisionBitMask =  physicsCategories.leftBorder | physicsCategories.rightBorder | physicsCategories.SafetyArea
                Defender.physicsBody!.contactTestBitMask =  physicsCategories.leftBorder | physicsCategories.rightBorder | physicsCategories.SafetyArea
                Defender.physicsBody!.isDynamic = true
                Defender.physicsBody!.allowsRotation = false
                Defender.name = "resistantDefender"
                Defender.physicsBody!.restitution = 1
                Defender.physicsBody!.friction = 0
                
                
                
                
                if (switchDirection == false){
                    Defender.run(moveDeffender)
                    
                    
                    
                    
                    switchDirection = true
                }
                else{
                    Defender.run(moveDeffenderRight)
                    switchDirection = false
                }
            }
        }
        else if (arenaNum == 2){
            if (switchDirection == false){
                Defender.run(SKAction.move(by: CGVector(dx: -60, dy: 0), duration: 1.5))
                Defender.texture = SKTexture(imageNamed: "BlackSharkFlip")
                
                
                
                
                //switchDirection = true
            }
            else{
                Defender.run(SKAction.move(by: CGVector(dx: 60, dy: 0), duration: 1.5))
                Defender.texture = SKTexture(imageNamed: "BlackShark")
                //switchDirection = false
            }
            delay(1.5){
                
                
                
                
                Defender.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: Defender.size.width, height: 30.0))
                Defender.physicsBody!.mass = 5
                Defender.physicsBody!.affectedByGravity = false
                Defender.physicsBody!.categoryBitMask = physicsCategories.resistantDefender
                Defender.physicsBody!.collisionBitMask =  physicsCategories.leftBorder | physicsCategories.rightBorder | physicsCategories.SafetyArea
                Defender.physicsBody!.contactTestBitMask =  physicsCategories.leftBorder | physicsCategories.rightBorder | physicsCategories.SafetyArea
                Defender.physicsBody!.isDynamic = true
                Defender.physicsBody!.allowsRotation = false
                Defender.name = "resistantDefender"
                Defender.physicsBody!.restitution = 1
                Defender.physicsBody!.friction = 0
                
                
                
                
                if (switchDirection == false){
                    Defender.run(moveDeffender)
                    Defender.texture = SKTexture(imageNamed: "BlackSharkFlip")
                    
                    
                    
                    
                    switchDirection = true
                }
                else{
                    Defender.run(moveDeffenderRight)
                    Defender.texture = SKTexture(imageNamed: "BlackShark")
                    
                    
                    
                    
                    switchDirection = false
                }
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    func SpawnInitialDefender(){
        
        
        
        
        var samePos : Bool = true
        var randYStart = random(min: gameArea.minY + gameArea.size.height*0.25, max: gameArea.maxY - gameArea.size.height * 0.13)
        
        
        if ((gameLevel > 0 && gameLevel <= 5) || (gameLevel > 25 &&  gameLevel <=  30) || (gameLevel > 50 && gameLevel <= 55) || (gameLevel > 75 && gameLevel <= 80) ){
            randYStart = random(min: gameArea.minY + gameArea.size.height*0.45, max: gameArea.maxY - gameArea.size.height * 0.45)
        }
        else if ((gameLevel > 5 && gameLevel <= 10) || (gameLevel > 30 &&  gameLevel <=  35) || (gameLevel > 55 && gameLevel <= 60) || (gameLevel > 80 && gameLevel <= 85) ){
            randYStart = random(min: gameArea.minY + gameArea.size.height*0.37, max: gameArea.maxY - gameArea.size.height * 0.32)
        }
        else if ((gameLevel > 10 && gameLevel <= 20) || (gameLevel > 35 &&  gameLevel <=  45) || (gameLevel > 60 && gameLevel <= 70) || (gameLevel > 85 && gameLevel <= 95) ){
            randYStart = random(min: gameArea.minY + gameArea.size.height*0.3, max: gameArea.maxY - gameArea.size.height * 0.25)
        }
        else if ((gameLevel > 20 && gameLevel <= 25) || (gameLevel > 45 &&  gameLevel <=  50) || (gameLevel > 70 && gameLevel <= 75) || (gameLevel > 95 && gameLevel <= 100) ){
            randYStart = random(min: gameArea.minY + gameArea.size.height*0.2, max: gameArea.maxY - gameArea.size.height * 0.13)
        }
        var randXStart = random(min:  gameArea.size.width * 0.3, max: gameArea.size.width * 0.7)
        if ((gameLevel > 0 && gameLevel <= 5) || (gameLevel > 25 &&  gameLevel <=  30) || (gameLevel > 50 && gameLevel <= 55) || (gameLevel > 75 && gameLevel <= 80) ){
            randXStart = random(min:  gameArea.size.width * 0.45, max: gameArea.size.width * 0.55)        }
        else if ((gameLevel > 5 && gameLevel <= 10) || (gameLevel > 30 &&  gameLevel <=  35) || (gameLevel > 55 && gameLevel <= 60) || (gameLevel > 80 && gameLevel <= 85) ){
            randXStart = random(min:  gameArea.size.width * 0.4, max: gameArea.size.width * 0.6)        }
            
            
        else if ((gameLevel > 10 && gameLevel <= 20) || (gameLevel > 35 &&  gameLevel <=  45) || (gameLevel > 60 && gameLevel <= 70) || (gameLevel > 85 && gameLevel <= 95) ){
            randXStart = random(min:  gameArea.size.width * 0.35, max: gameArea.size.width * 0.65)        }
        else if ((gameLevel > 20 && gameLevel <= 25) || (gameLevel > 45 &&  gameLevel <=  50) || (gameLevel > 70 && gameLevel <= 75) || (gameLevel > 95 && gameLevel <= 100) ){
            randXStart = random(min:  gameArea.size.width * 0.3, max: gameArea.size.width * 0.7)        }
        
        
        
        
        
        
        while samePos{   //set random y position
            //print("loop")
            var flag: Bool = false
            self.enumerateChildNodes(withName: "defender"){ //loop through all exisiting defenders
                //if the new spawning defender
                //has y position that is close to another exisitng defender's y pos,
                //then generate a new random y pos and go through loop again
                (defender, stop) in
                if randYStart >= defender.position.y - 20 && randYStart <= defender.position.y + 20   {
                    flag = true
                }
            }
            self.enumerateChildNodes(withName: "resistantDefender"){ //loop through all exisiting defenders
                //if the new spawning defender
                //has y position that is close to another exisitng defender's y pos,
                //then generate a new random y pos and go through loop again
                (defender, stop) in
                if randYStart >= defender.position.y - 20 && randYStart <= defender.position.y + 20   {
                    flag = true
                }
            }
            self.enumerateChildNodes(withName: "newdefender"){ //loop through all exisiting defenders
                //if the new spawning defender
                //has y position that is close to another exisitng defender's y pos,
                //then generate a new random y pos and go through loop again
                (defender, stop) in
                if randYStart >= defender.position.y - 20 && randYStart <= defender.position.y + 20   {
                    flag = true
                }
            }
            self.enumerateChildNodes(withName: "newresistantDefender"){ //loop through all exisiting defenders
                //if the new spawning defender
                //has y position that is close to another exisitng defender's y pos,
                //then generate a new random y pos and go through loop again
                (defender, stop) in
                if randYStart >= defender.position.y - 20 && randYStart <= defender.position.y + 20   {
                    flag = true
                }
            }
            self.enumerateChildNodes(withName: "player"){ //loop through all exisiting defenders
                
                
                
                
                
                
                
                
                (defender, stop) in
                if randYStart >= defender.position.y - 60 && randYStart <= defender.position.y + 60   {
                    flag = true
                }
            }
            
            
            
            
            
            
            
            
            if flag == true{
                
                
                if ((gameLevel > 0 && gameLevel <= 5) || (gameLevel > 25 &&  gameLevel <=  30) || (gameLevel > 50 && gameLevel <= 55) || (gameLevel > 75 && gameLevel <= 80) ){
                    randYStart = random(min: gameArea.minY + gameArea.size.height*0.45, max: gameArea.maxY - gameArea.size.height * 0.45)
                }
                else if ((gameLevel > 5 && gameLevel <= 10) || (gameLevel > 30 &&  gameLevel <=  35) || (gameLevel > 55 && gameLevel <= 60) || (gameLevel > 80 && gameLevel <= 85) ){
                    randYStart = random(min: gameArea.minY + gameArea.size.height*0.37, max: gameArea.maxY - gameArea.size.height * 0.32)
                }
                else if ((gameLevel > 10 && gameLevel <= 20) || (gameLevel > 35 &&  gameLevel <=  45) || (gameLevel > 60 && gameLevel <= 70) || (gameLevel > 85 && gameLevel <= 95) ){
                    randYStart = random(min: gameArea.minY + gameArea.size.height*0.3, max: gameArea.maxY - gameArea.size.height * 0.25)
                }
                else if ((gameLevel > 20 && gameLevel <= 25) || (gameLevel > 45 &&  gameLevel <=  50) || (gameLevel > 70 && gameLevel <= 75) || (gameLevel > 95 && gameLevel <= 100) ){
                    randYStart = random(min: gameArea.minY + gameArea.size.height*0.2, max: gameArea.maxY - gameArea.size.height * 0.13)
                }
            }
            else{ //if new randY pos steers clear of exisitng defenders y positions, spawn defender at new random loc
                samePos = false
            }
        }
        samePos = true
        while samePos{   //set random x position
            // print("LLLoop")
            var flag: Bool = false
            self.enumerateChildNodes(withName: "defender"){ //loop through all exisiting defenders
                //if the new spawning defender
                //has y position that is close to another exisitng defender's y pos,
                //then generate a new random y pos and go through loop again
                (defender, stop) in
                if randXStart >= defender.position.x - 30 && randXStart <= defender.position.x + 30  {
                    flag = true
                }
            }
            self.enumerateChildNodes(withName: "resistantDefender"){ //loop through all exisiting defenders
                //if the new spawning defender
                //has y position that is close to another exisitng defender's y pos,
                //then generate a new random y pos and go through loop again
                (defender, stop) in
                if randXStart >= defender.position.x - 30 && randXStart <= defender.position.x + 30  {
                    flag = true
                }
            }
            self.enumerateChildNodes(withName: "newdefender"){ //loop through all exisiting defenders
                //if the new spawning defender
                //has y position that is close to another exisitng defender's y pos,
                //then generate a new random y pos and go through loop again
                (defender, stop) in
                if randXStart >= defender.position.x - 30 && randXStart <= defender.position.x + 30  {
                    flag = true
                }
            }
            self.enumerateChildNodes(withName: "newresistantDefender"){ //loop through all exisiting defenders
                //if the new spawning defender
                //has y position that is close to another exisitng defender's y pos,
                //then generate a new random y pos and go through loop again
                (defender, stop) in
                if randXStart >= defender.position.x - 30 && randXStart <= defender.position.x + 30  {
                    flag = true
                }
            }
            if flag == true{
                if ((gameLevel > 0 && gameLevel <= 5) || (gameLevel > 25 &&  gameLevel <=  30) || (gameLevel > 50 && gameLevel <= 55) || (gameLevel > 75 && gameLevel <= 80) ){
                    randXStart = random(min:  gameArea.size.width * 0.45, max: gameArea.size.width * 0.55)        }
                else if ((gameLevel > 5 && gameLevel <= 10) || (gameLevel > 30 &&  gameLevel <=  35) || (gameLevel > 55 && gameLevel <= 60) || (gameLevel > 80 && gameLevel <= 85) ){
                    randXStart = random(min:  gameArea.size.width * 0.4, max: gameArea.size.width * 0.6)        }
                    
                    
                else if ((gameLevel > 10 && gameLevel <= 20) || (gameLevel > 35 &&  gameLevel <=  45) || (gameLevel > 60 && gameLevel <= 70) || (gameLevel > 85 && gameLevel <= 95) ){
                    randXStart = random(min:  gameArea.size.width * 0.35, max: gameArea.size.width * 0.65)        }
                else if ((gameLevel > 20 && gameLevel <= 25) || (gameLevel > 45 &&  gameLevel <=  50) || (gameLevel > 70 && gameLevel <= 75) || (gameLevel > 95 && gameLevel <= 100) ){
                    randXStart = random(min:  gameArea.size.width * 0.3, max: gameArea.size.width * 0.7)        }
                
                
            }
            else{ //if new randY pos steers clear of exisitng defenders y positions, spawn defender at new random loc
                samePos = false
            }
        }
        
        
        
        
        
        
        
        
        let startPt = CGPoint(x: randXStart, y: randYStart)
        var Defender = SKSpriteNode()
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        if (arenaNum == 1 || arenaNum == 3){
         
            Defender = SKSpriteNode(imageNamed: "Line")
            Defender.setScale(3)
        }
        
      
        if (arenaNum == 2){ //defenders are sharks
            Defender = SKSpriteNode(imageNamed: "Shark")
            Defender.setScale(2.0)
        }
        
        
        
        if (arenaNum == 4){
            
            Defender = SKSpriteNode(imageNamed: "stardeffenders")
            Defender.setScale(0.35)
        }
        
        
        
        
        
        
        
        
        
        Defender.position = startPt
        Defender.zPosition = 301
        
        
        
        
        
        
        
        
        Defender.name = "newdefender"
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        self.addChild(Defender)
        let moveDeffender = SKAction.applyImpulse(CGVector(dx: -2000, dy: 0), duration: 1.0)
        let moveDeffenderRight = SKAction.applyImpulse(CGVector(dx: 2000, dy: 0), duration: 1.0)
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        if (arenaNum == 1 || arenaNum == 3 || arenaNum == 4){
            
            
            
            
            
            
            
            
            Defender.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: Defender.size.width - 20, height: 20.0))
        }
        
        
        
        
        
        
        
        
        
        
        
        
        if (arenaNum == 2){ //defenders are sharks
            Defender.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: Defender.size.width - 20, height: 30.0))
        }
        
        
        
        
        
        
        
        
        
        
        
        
        Defender.physicsBody!.mass = 5
        Defender.physicsBody!.affectedByGravity = false
        Defender.physicsBody!.categoryBitMask = physicsCategories.defender
        Defender.physicsBody!.collisionBitMask =  physicsCategories.leftBorder | physicsCategories.rightBorder | physicsCategories.SafetyArea
        Defender.physicsBody!.contactTestBitMask =  physicsCategories.leftBorder | physicsCategories.rightBorder | physicsCategories.SafetyArea
        Defender.physicsBody!.isDynamic = true
        Defender.physicsBody!.allowsRotation = false
        Defender.name = "defender"
        Defender.physicsBody!.restitution = 1
        Defender.physicsBody!.friction = 0
        
        
        
        
        
        
        
        
        if (self.currentlyOnFire){ //if ball is on fire, then make defender vulnerbale to be knocked out
            Defender.physicsBody!.collisionBitMask = physicsCategories.leftBorder | physicsCategories.rightBorder | physicsCategories.ball | physicsCategories.resistantDefender
            Defender.physicsBody!.contactTestBitMask = physicsCategories.leftBorder | physicsCategories.rightBorder | physicsCategories.ball | physicsCategories.resistantDefender
        }
        
        
        
        
        if (switchDirection == false){
            Defender.run(moveDeffender)
            if (arenaNum == 2){
                Defender.texture = SKTexture(imageNamed: "SharkFlip")
            }
            switchDirection = true
        }
        else{
            Defender.run(moveDeffenderRight)
            switchDirection = false
        }
    }
    
    
    
    
    
    
    
    
    func SpawnInitialResistantDefender(){
        
        
        
        
        var samePos : Bool = true
        var randYStart = random(min: gameArea.minY + gameArea.size.height*0.25, max: gameArea.maxY - gameArea.size.height * 0.30)
        
        
        if ((gameLevel > 0 && gameLevel <= 5) || (gameLevel > 25 &&  gameLevel <=  30) || (gameLevel > 50 && gameLevel <= 55) || (gameLevel > 75 && gameLevel <= 80) ){
            randYStart = random(min: gameArea.minY + gameArea.size.height*0.45, max: gameArea.maxY - gameArea.size.height * 0.45)
        }
        else if ((gameLevel > 5 && gameLevel <= 10) || (gameLevel > 30 &&  gameLevel <=  35) || (gameLevel > 55 && gameLevel <= 60) || (gameLevel > 80 && gameLevel <= 85) ){
            randYStart = random(min: gameArea.minY + gameArea.size.height*0.37, max: gameArea.maxY - gameArea.size.height * 0.32)
        }
        else if ((gameLevel > 10 && gameLevel <= 20) || (gameLevel > 35 &&  gameLevel <=  45) || (gameLevel > 60 && gameLevel <= 70) || (gameLevel > 85 && gameLevel <= 95) ){
            randYStart = random(min: gameArea.minY + gameArea.size.height*0.3, max: gameArea.maxY - gameArea.size.height * 0.25)
        }
        else if ((gameLevel > 20 && gameLevel <= 25) || (gameLevel > 45 &&  gameLevel <=  50) || (gameLevel > 70 && gameLevel <= 75) || (gameLevel > 95 && gameLevel <= 100) ){
            randYStart = random(min: gameArea.minY + gameArea.size.height*0.2, max: gameArea.maxY - gameArea.size.height * 0.13)
        }
        var randXStart = random(min:  gameArea.size.width * 0.5, max: gameArea.size.width * 0.8)
        if ((gameLevel > 0 && gameLevel <= 5) || (gameLevel > 25 &&  gameLevel <=  30) || (gameLevel > 50 && gameLevel <= 55) || (gameLevel > 75 && gameLevel <= 80) ){
            randXStart = random(min:  gameArea.size.width * 0.45, max: gameArea.size.width * 0.55)        }
        else if ((gameLevel > 5 && gameLevel <= 10) || (gameLevel > 30 &&  gameLevel <=  35) || (gameLevel > 55 && gameLevel <= 60) || (gameLevel > 80 && gameLevel <= 85) ){
            randXStart = random(min:  gameArea.size.width * 0.4, max: gameArea.size.width * 0.6)        }
            
            
        else if ((gameLevel > 10 && gameLevel <= 20) || (gameLevel > 35 &&  gameLevel <=  45) || (gameLevel > 60 && gameLevel <= 70) || (gameLevel > 85 && gameLevel <= 95) ){
            randXStart = random(min:  gameArea.size.width * 0.35, max: gameArea.size.width * 0.65)        }
        else if ((gameLevel > 20 && gameLevel <= 25) || (gameLevel > 45 &&  gameLevel <=  50) || (gameLevel > 70 && gameLevel <= 75) || (gameLevel > 95 && gameLevel <= 100) ){
            randXStart = random(min:  gameArea.size.width * 0.3, max: gameArea.size.width * 0.7)        }
        
        
        
        
        
        
        while samePos{   //set random y position
            //print("loop")
            var flag: Bool = false
            self.enumerateChildNodes(withName: "defender"){ //loop through all exisiting defenders
                //if the new spawning defender
                //has y position that is close to another exisitng defender's y pos,
                //then generate a new random y pos and go through loop again
                (defender, stop) in
                if randYStart >= defender.position.y - 20 && randYStart <= defender.position.y + 20   {
                    flag = true
                }
            }
            self.enumerateChildNodes(withName: "resistantDefender"){ //loop through all exisiting defenders
                //if the new spawning defender
                //has y position that is close to another exisitng defender's y pos,
                //then generate a new random y pos and go through loop again
                (defender, stop) in
                if randYStart >= defender.position.y - 20 && randYStart <= defender.position.y + 20   {
                    flag = true
                }
            }
            self.enumerateChildNodes(withName: "newresistantDefender"){ //loop through all exisiting defenders
                //if the new spawning defender
                //has y position that is close to another exisitng defender's y pos,
                //then generate a new random y pos and go through loop again
                (defender, stop) in
                if randYStart >= defender.position.y - 20 && randYStart <= defender.position.y + 20   {
                    flag = true
                }
            }
            self.enumerateChildNodes(withName: "newdefender"){ //loop through all exisiting defenders
                //if the new spawning defender
                //has y position that is close to another exisitng defender's y pos,
                //then generate a new random y pos and go through loop again
                (defender, stop) in
                if randYStart >= defender.position.y - 20 && randYStart <= defender.position.y + 20   {
                    flag = true
                }
            }
            self.enumerateChildNodes(withName: "player"){ //loop through all exisiting defenders
                
                
                
                
                
                
                
                
                (defender, stop) in
                if randYStart >= defender.position.y - 60 && randYStart <= defender.position.y + 60   {
                    flag = true
                }
            }
            if flag == true{
                
                if ((gameLevel > 0 && gameLevel <= 5) || (gameLevel > 25 &&  gameLevel <=  30) || (gameLevel > 50 && gameLevel <= 55) || (gameLevel > 75 && gameLevel <= 80) ){
                    randYStart = random(min: gameArea.minY + gameArea.size.height*0.45, max: gameArea.maxY - gameArea.size.height * 0.45)
                }
                else if ((gameLevel > 5 && gameLevel <= 10) || (gameLevel > 30 &&  gameLevel <=  35) || (gameLevel > 55 && gameLevel <= 60) || (gameLevel > 80 && gameLevel <= 85) ){
                    randYStart = random(min: gameArea.minY + gameArea.size.height*0.37, max: gameArea.maxY - gameArea.size.height * 0.32)
                }
                else if ((gameLevel > 10 && gameLevel <= 20) || (gameLevel > 35 &&  gameLevel <=  45) || (gameLevel > 60 && gameLevel <= 70) || (gameLevel > 85 && gameLevel <= 95) ){
                    randYStart = random(min: gameArea.minY + gameArea.size.height*0.3, max: gameArea.maxY - gameArea.size.height * 0.25)
                }
                else if ((gameLevel > 20 && gameLevel <= 25) || (gameLevel > 45 &&  gameLevel <=  50) || (gameLevel > 70 && gameLevel <= 75) || (gameLevel > 95 && gameLevel <= 100) ){
                    randYStart = random(min: gameArea.minY + gameArea.size.height*0.2, max: gameArea.maxY - gameArea.size.height * 0.13)
                }
            }
            else{ //if new randY pos steers clear of exisitng defenders y positions, spawn defender at new random loc
                samePos = false
            }
        }
        samePos = true
        while samePos{   //set random x position
            // print("LLLoop")
            var flag: Bool = false
            self.enumerateChildNodes(withName: "defender"){ //loop through all exisiting defenders
                //if the new spawning defender
                //has y position that is close to another exisitng defender's y pos,
                //then generate a new random y pos and go through loop again
                (defender, stop) in
                if randXStart >= defender.position.x - 30 && randXStart <= defender.position.x + 30  {
                    flag = true
                }
            }
            self.enumerateChildNodes(withName: "resistantDefender"){ //loop through all exisiting defenders
                //if the new spawning defender
                //has y position that is close to another exisitng defender's y pos,
                //then generate a new random y pos and go through loop again
                (defender, stop) in
                if randXStart >= defender.position.x - 30 && randXStart <= defender.position.x + 30  {
                    flag = true
                }
            }
            self.enumerateChildNodes(withName: "newresistantDefender"){ //loop through all exisiting defenders
                //if the new spawning defender
                //has y position that is close to another exisitng defender's y pos,
                //then generate a new random y pos and go through loop again
                (defender, stop) in
                if randXStart >= defender.position.x - 30 && randXStart <= defender.position.x + 30  {
                    flag = true
                }
            }
            self.enumerateChildNodes(withName: "newdefender"){ //loop through all exisiting defenders
                //if the new spawning defender
                //has y position that is close to another exisitng defender's y pos,
                //then generate a new random y pos and go through loop again
                (defender, stop) in
                if randXStart >= defender.position.x - 30 && randXStart <= defender.position.x + 30  {
                    flag = true
                }
            }
            if flag == true{
                if ((gameLevel > 0 && gameLevel <= 5) || (gameLevel > 25 &&  gameLevel <=  30) || (gameLevel > 50 && gameLevel <= 55) || (gameLevel > 75 && gameLevel <= 80) ){
                    randXStart = random(min:  gameArea.size.width * 0.45, max: gameArea.size.width * 0.55)        }
                else if ((gameLevel > 5 && gameLevel <= 10) || (gameLevel > 30 &&  gameLevel <=  35) || (gameLevel > 55 && gameLevel <= 60) || (gameLevel > 80 && gameLevel <= 85) ){
                    randXStart = random(min:  gameArea.size.width * 0.4, max: gameArea.size.width * 0.6)        }
                    
                    
                else if ((gameLevel > 10 && gameLevel <= 20) || (gameLevel > 35 &&  gameLevel <=  45) || (gameLevel > 60 && gameLevel <= 70) || (gameLevel > 85 && gameLevel <= 95) ){
                    randXStart = random(min:  gameArea.size.width * 0.35, max: gameArea.size.width * 0.65)        }
                else if ((gameLevel > 20 && gameLevel <= 25) || (gameLevel > 45 &&  gameLevel <=  50) || (gameLevel > 70 && gameLevel <= 75) || (gameLevel > 95 && gameLevel <= 100) ){
                    randXStart = random(min:  gameArea.size.width * 0.3, max: gameArea.size.width * 0.7)        }
            }
            else{ //if new randY pos steers clear of exisitng defenders y positions, spawn defender at new random loc
                samePos = false
            }
        }
        
        
        
        
        
        
        
        
        let startPt = CGPoint(x: randXStart, y: randYStart)
        var Defender = SKSpriteNode()
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        if (arenaNum == 1 || arenaNum == 3){
            
            
            
            Defender = SKSpriteNode(imageNamed: "blackLine")
            Defender.setScale(3)
        }
        
        
        
        
        
        
        
        
        if (arenaNum == 2){ //defenders are sharks
            Defender = SKSpriteNode(imageNamed: "BlackShark")
            Defender.setScale(2.0)
        }
        
        
        if (arenaNum == 4){
            
            Defender = SKSpriteNode(imageNamed: "stardeffenders")
            Defender.setScale(0.35)
        }
        
        
        
        
        
        
        
        
        
        
        Defender.position = startPt
        Defender.zPosition = 301
        
        
        
        
        Defender.name = "newresistantDefender"
        
        
        
        
        self.addChild(Defender)
        let moveDeffender = SKAction.applyImpulse(CGVector(dx: -2000, dy: 0), duration: 1.0)
        let moveDeffenderRight = SKAction.applyImpulse(CGVector(dx: 2000, dy: 0), duration: 1.0)
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        if (arenaNum == 1 || arenaNum == 3 || arenaNum == 4){
            
            
            
            
            
            
            
            
            Defender.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: Defender.size.width, height: 20.0))
        }
        
        
        
        
        
        
        
        
        if (arenaNum == 2){ //defenders are sharks
            Defender.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: Defender.size.width, height: 30.0))
        }
        
        
        
        
        
        
        
        
        
        
        
        
        Defender.physicsBody!.mass = 5
        Defender.physicsBody!.affectedByGravity = false
        Defender.physicsBody!.categoryBitMask = physicsCategories.resistantDefender
        Defender.physicsBody!.collisionBitMask =  physicsCategories.leftBorder | physicsCategories.rightBorder | physicsCategories.SafetyArea
        Defender.physicsBody!.contactTestBitMask =  physicsCategories.leftBorder | physicsCategories.rightBorder | physicsCategories.SafetyArea
        Defender.physicsBody!.isDynamic = true
        Defender.physicsBody!.allowsRotation = false
        Defender.name = "resistantDefender"
        Defender.physicsBody!.restitution = 1
        Defender.physicsBody!.friction = 0
        
        
        if (switchDirection == false){
            Defender.run(moveDeffender)
            if (arenaNum == 2){
                Defender.texture = SKTexture(imageNamed: "BlackSharkFlip")
            }
            switchDirection = true
        }
        else{
            Defender.run(moveDeffenderRight)
            switchDirection = false
        }
    }
    
    
   let instantGoalZ = SKSpriteNode(imageNamed: "instantGoal")
    
    
    func InstantGoal(){
        
        
        if (arenaNum == 2 || arenaNum == 3 || arenaNum == 4) {
            scored.isHidden = true
        }
        
        let randYStart = random(min: gameArea.minY + gameArea.size.height*0.60, max: gameArea.maxY - gameArea.size.height * 0.20)
        let randXStart = random(min: gameArea.minX + gameArea.size.width * 0.1, max: gameArea.maxX - gameArea.size.width * 0.10)
        
        let startPt = CGPoint(x: randXStart, y: randYStart)
        
        instantGoalZ.name = "PurpleBall"
        instantGoalZ.setScale(0.2)
        instantGoalZ.position = startPt
        instantGoalZ.zPosition = 102
        instantGoalZ.physicsBody = SKPhysicsBody(circleOfRadius: instantGoalZ.self.size.width / 2.3)
        instantGoalZ.physicsBody!.affectedByGravity = false
        instantGoalZ.physicsBody!.categoryBitMask = physicsCategories.QuickGoal
        instantGoalZ.physicsBody!.contactTestBitMask =  physicsCategories.ball
        instantGoalZ.physicsBody!.isDynamic = false
        instantGoalZ.physicsBody!.restitution = 0
        instantGoalZ.physicsBody!.friction = 0
        self.addChild(instantGoalZ)
        
        
        // instantGoalEmitter()
    }
    
    func createBlackHole(){
        
        let randYStart = random(min: gameArea.minY + gameArea.size.height*0.60, max: gameArea.maxY - gameArea.size.height * 0.20)
        let randXStart = random(min: gameArea.minX + gameArea.size.width * 0.1, max: gameArea.maxX - gameArea.size.width * 0.10)
        let blackHole = SKSpriteNode(imageNamed: "blackHole")
        
       
        let startPt = CGPoint(x: randXStart, y: randYStart)
        
        
        blackHole.name = "blackHole"
        blackHole.setScale(0.2)
        blackHole.position = startPt
        blackHole.zPosition = 102
        blackHole.physicsBody = SKPhysicsBody(circleOfRadius: blackHole.self.size.width*0.4)
        blackHole.physicsBody!.affectedByGravity = false
        blackHole.physicsBody!.categoryBitMask = physicsCategories.blackHole
        blackHole.physicsBody!.contactTestBitMask =  physicsCategories.ball
        blackHole.physicsBody!.isDynamic = false
        blackHole.physicsBody!.restitution = 0
        blackHole.physicsBody!.friction = 0
        self.addChild(blackHole)
    }
    
    
    
    
    func createFire(){  //creates the fire powerUp node, if gameBall hits this, then player gets a fire powerUp
        let randYStart = random(min: gameArea.minY + gameArea.size.height*0.60, max: gameArea.maxY - gameArea.size.height * 0.20)
        let randXStart = random(min: gameArea.minX + gameArea.size.width * 0.2, max: gameArea.maxX - gameArea.size.width * 0.10)
        
        
        
        
        
        
        
        
        let startPt = CGPoint(x: randXStart, y: randYStart)
        let fire = SKSpriteNode(imageNamed: "firePowerUp")
        
        
        
        
        
        
        
        
        if (arenaNum == 2){
            fire.texture = SKTexture(imageNamed: "BubbleNumber")
            
            
        }
        fire.setScale(0.45)
        fire.name = "fire"
        fire.position = startPt
        fire.zPosition = 200
        fire.physicsBody = SKPhysicsBody(circleOfRadius: fire.self.size.width*0.5)
        fire.physicsBody!.affectedByGravity = false
        fire.physicsBody!.categoryBitMask = physicsCategories.fire
        fire.physicsBody!.contactTestBitMask =  physicsCategories.ball
        fire.physicsBody!.collisionBitMask = physicsCategories.ball
        fire.physicsBody!.isDynamic = false
        fire.physicsBody!.restitution = 0
        fire.physicsBody!.friction = 0
        self.addChild(fire)
    }
    
    
    
    
    
    
    
    
    func createCoin(){  //creates the fire powerUp node, if gameBall hits this, then player gets a fire powerUp
        let randYStart = random(min: gameArea.minY + gameArea.size.height*0.60, max: gameArea.maxY - gameArea.size.height * 0.20)
        let randXStart = random(min: gameArea.minX + gameArea.size.width * 0.1, max: gameArea.maxX - gameArea.size.width * 0.10)
        let coinNode = SKSpriteNode(imageNamed: "Coin")
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        let startPt = CGPoint(x: randXStart, y: randYStart)
        
        
        
        
        
        
        
        
        
        coinNode.setScale(0.4)
        coinNode.name = "coin"
        coinNode.alpha = 1
        coinNode.position = startPt
        coinNode.zPosition = 102
        coinNode.physicsBody = SKPhysicsBody(circleOfRadius: coinNode.self.size.width*0.5)
        coinNode.physicsBody!.affectedByGravity = false
        coinNode.physicsBody!.categoryBitMask = physicsCategories.coin
        coinNode.physicsBody!.contactTestBitMask =  physicsCategories.ball
        coinNode.physicsBody!.collisionBitMask = physicsCategories.ball
        coinNode.physicsBody!.isDynamic = false
        
        
        
        
        coinNode.physicsBody!.restitution = 0
        coinNode.physicsBody!.friction = 0
        self.addChild(coinNode)
    }
    
    
    func hitCoin(){
        
        
        if (sound){
            self.run(coinSound)
        }
        let fadeOut = SKAction.fadeOut(withDuration: 0.5)
        let fireFade = SKAction.sequence([fadeOut])
        let Coin = self.childNode(withName: "coin")
        if (Coin != nil){
            Coin?.run(fireFade)
        }
        coins = coins + 1
        defaults.set(coins, forKey: "coinsSaved")
        coinsNum.text = " \(coins)"
        Coin?.removeFromParent()
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
    }
    
    
    
    
    
    
    
    
    func hitFire(){ // after the gameBall hits the firePowerUp,
        //particle()
        inSafetyArea = false
        shotBall = false
        // Settings.Metrics.projectileRestPosition = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.145)
        let fadeOut = SKAction.fadeOut(withDuration: 0.2)
        let fadeIn = SKAction.fadeIn(withDuration: 0.2)
        let fireFade = SKAction.sequence([fadeOut])
        let fire = self.childNode(withName: "fire")
        if (fire != nil){
            fire?.run(fireFade)
        }
        
        
        useFirePowerUp.alpha = 1
        // powerUpNumLabel.text = "\(firePowerUps)"
        //powerUpNumLabel.isHidden = true
        powerUpNumLabel.run(SKAction.sequence([fadeOut, fadeIn]))
        delay(0.2){
            // self.powerUpNumLabel.isHidden = false
            self.firePowerUps = self.firePowerUps + 1
            defaults.set(self.firePowerUps, forKey: "firePowerUps")
            self.powerUpNumLabel.text = "\(self.firePowerUps)"
            
            
            
        }
        
        
        // fire?.removeFromParent()
        
        
        
    }
    
    
    func createSafetyArea(){
        
        let SafetyArea = SKSpriteNode(imageNamed: "safetyArea")
        SafetyArea.name = "player"
        var samePos: Bool = true
        
        
        var randYStart = random(min: gameArea.minY + gameArea.size.height*0.20, max: gameArea.maxY - gameArea.size.height * 0.20)
        let randXStart = random(min: gameArea.minX + gameArea.size.width * 0.20, max: gameArea.maxX - gameArea.size.width * 0.20)
        
        
        while samePos{
            // print("safetyarea loop")
            var flag: Bool = false
            self.enumerateChildNodes(withName: "player"){ //loop through all exisiting defenders
                
                
                (SafetyArea, stop) in
                if randYStart >= SafetyArea.position.y - 150 && randYStart <= SafetyArea.position.y + 150  {
                    flag = true
                }
            }
            self.enumerateChildNodes(withName: "fire"){ //loop through all exisiting defenders
                
                (SafetyArea, stop) in
                if randYStart >= SafetyArea.position.y - 50 && randYStart <= SafetyArea.position.y + 50  {
                    flag = true
                }
            }
            self.enumerateChildNodes(withName: "PurpleBall"){ //loop through all exisiting defenders
                
                (SafetyArea, stop) in
                if randYStart >= SafetyArea.position.y - 50 && randYStart <= SafetyArea.position.y + 50  {
                    flag = true
                }
            }
            self.enumerateChildNodes(withName: "defender"){ //loop through all exisiting defenders
                //if the new spawning defender
                //has y position that is close to another exisitng defender's y pos,
                //then generate a new random y pos and go through loop again
                (defender, stop) in
                if randYStart >= defender.position.y - 50 && randYStart <= defender.position.y + 50   {
                    flag = true
                }
            }
            self.enumerateChildNodes(withName: "resistantDefender"){ //loop through all exisiting defenders
                //if the new spawning defender
                //has y position that is close to another exisitng defender's y pos,
                //then generate a new random y pos and go through loop again
                (defender, stop) in
                if randYStart >= defender.position.y - 50 && randYStart <= defender.position.y + 50   {
                    flag = true
                }
            }
            self.enumerateChildNodes(withName: "newdefender"){ //loop through all exisiting defenders
                //if the new spawning defender
                //has y position that is close to another exisitng defender's y pos,
                //then generate a new random y pos and go through loop again
                (defender, stop) in
                if randYStart >= defender.position.y - 50 && randYStart <= defender.position.y + 50   {
                    flag = true
                }
            }
            self.enumerateChildNodes(withName: "newresistantDefender"){ //loop through all exisiting defenders
                //if the new spawning defender
                //has y position that is close to another exisitng defender's y pos,
                //then generate a new random y pos and go through loop again
                (defender, stop) in
                if randYStart >= defender.position.y - 50 && randYStart <= defender.position.y + 50   {
                    flag = true
                }
            }
            
            
            if flag == true{
                randYStart = random(min: gameArea.minY + gameArea.size.height*0.45, max: gameArea.maxY - gameArea.size.height * 0.20)
            }
            else{ //if new randY pos steers clear of exisitng player y positions, spawn player at new random loc
                samePos = false
            }
        }
        
        
        
        
        
        
        let startPt = CGPoint(x: randXStart, y: randYStart)
        SafetyArea.setScale(0.18)
        SafetyArea.physicsBody = SKPhysicsBody(circleOfRadius: SafetyArea.size.width / 2.0 )
        SafetyArea.physicsBody?.categoryBitMask = physicsCategories.SafetyArea
        SafetyArea.physicsBody?.collisionBitMask = physicsCategories.None
        SafetyArea.position = startPt
        SafetyArea.zPosition = 100
        self.addChild(SafetyArea)
        
        
        
        
    }
    
    
    
    
    
    
    
    
    func teleportation(){
        
        if (arenaNum == 2 || arenaNum == 3 || arenaNum == 4) {
            scored.isHidden = true
        }
        
        let purp = self.childNode(withName: "PurpleBall")
        
        GameBall.run(SKAction.move(to: purp!.position, duration: 0.8))
        if (currentBallNumber == 28 || currentBallNumber == 29 || currentBallNumber == 30) {
        self.childNode(withName: "ball29")!.run(SKAction.move(to: purp!.position, duration: 0.8))
        }
        
        let fadeOut = SKAction.fadeOut(withDuration: 0.6)
        let fadeOut2 = SKAction.fadeOut(withDuration: 1.0)
        let fadeIn = SKAction.fadeIn(withDuration: 0.6)
        let fadeIn2 = SKAction.fadeIn(withDuration: 0.5)
        //let fadeOut3 = SKAction.fadeOut(withDuration: 2.0)
        delay(0.6){
            self.GameBall.run(fadeOut)
            purp?.run(fadeOut2)
        }
        
        
        delay(1.8){
            self.scored.isHidden = false
            self.GameBall.position = self.scored.position
            purp?.position = self.scored.position
            purp?.run(fadeIn2)
            self.GameBall.run(fadeIn)
            self.delay(0.35){
                purp?.run(fadeOut2)
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    func blackHole(){
        let purp = self.childNode(withName: "blackHole")
        GameBall.run(SKAction.move(to: purp!.position, duration: 0.8))
        let fadeOut = SKAction.fadeOut(withDuration: 0.6)
        
        delay(0.6){
            self.GameBall.run(fadeOut)
        }
        delay(1.5){
            self.gameOver()
        }
        
        
        
    
    }
    
    
    
    var brake = false
    
    
    
    
    
    func particle() {
        
        
        
        
        
        brake = true
        
        
        
        
        if let sparky = ParticleHelper.addParticleEffect(name: GameConstants.StringConstant.particle, particlePositionRange: CGVector(dx: 30.0, dy: 30.0), position: CGPoint(x: GameBall.position.x, y: GameBall.position.y - GameBall.size.height/2)) {
            sparky.zPosition = 10
            //let emitter = self.childNode(withName: "MyParticle")
            sparky.physicsBody = SKPhysicsBody(circleOfRadius: 20)
            sparky.physicsBody?.contactTestBitMask = 0
            sparky.physicsBody?.collisionBitMask = 0
            sparky.physicsBody?.isDynamic = true
            sparky.physicsBody?.allowsRotation = false
            sparky.physicsBody?.mass = 0.00001
            self.addChild(sparky)
            let pinJoint = SKPhysicsJointPin.joint(withBodyA: GameBall.physicsBody!, bodyB: sparky.physicsBody!, anchor: GameBall.position)
            scene?.physicsWorld.add(pinJoint)
            
            
            
            
            
            
            
            
        }
    }
    
    
    var smoke = false
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func smokeParticle() {
        
        
        
        
        
        
        
        
        smoke = true
        
        
        
        
        
        
        if let sparky = ParticleHelper.addParticleEffect(name: GameConstants.StringConstant.smokeParticle, particlePositionRange: CGVector(dx: 5.0, dy: 25.0), position: CGPoint(x: GameBall.position.x, y: GameBall.position.y)) {
            sparky.zPosition = 2
            sparky.setScale(2)
            sparky.run(SKAction.fadeOut(withDuration: 0.4))
            
            
            self.addChild(sparky)
            
            
            
            
            
            
            
            
        }
    }
    
    
    
    
    
    
    
    
    var blue = false
    
    
    
    
    func arena_2_particle() {
        
        
        
        
        
        
        
        
        brake = true
        
        
        
        
        
        
        
        
        if let sparky = ParticleHelper.addParticleEffect(name: GameConstants.StringConstant.blue_particle, particlePositionRange: CGVector(dx: 30.0, dy: 30.0), position: CGPoint(x: GameBall.position.x, y: GameBall.position.y - GameBall.size.height/2)) {
            sparky.zPosition = 2
            //let emitter = self.childNode(withName: "MyParticle")
            sparky.physicsBody = SKPhysicsBody(circleOfRadius: 20)
            sparky.physicsBody?.contactTestBitMask = 0
            sparky.physicsBody?.collisionBitMask = 0
            sparky.physicsBody?.isDynamic = true
            sparky.physicsBody?.allowsRotation = false
            sparky.physicsBody?.mass = 0.00001
            self.addChild(sparky)
            let pinJoint = SKPhysicsJointPin.joint(withBodyA: GameBall.physicsBody!, bodyB: sparky.physicsBody!, anchor: GameBall.position)
            scene?.physicsWorld.add(pinJoint)
            
            
            
            
            
            
            
            
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    var coinbool = false
    
    
    
    
    
    
    func CoinDustEmitter() {
        
        
        
        
        coinbool = true
        
        
        
        
        if let sparky = ParticleHelper.addParticleEffect(name: GameConstants.StringConstant.coinDust, particlePositionRange: CGVector(dx: 5.0, dy: 5.0), position: CGPoint(x: GameBall.position.x, y: GameBall.position.y)) {
            sparky.zPosition = 2
            self.addChild(sparky)
            sparky.run(SKAction.fadeOut(withDuration: 0.4))
            
            
            
            
            
            
        }
        
        
        
        
        
        
    }
    
    
    var instant = false
    
    
    
    
    
    
    func instantGoalEmitter() {
        
        
        
        
        instant = true
        
        
        
        
        if let sparky = ParticleHelper.addParticleEffect(name: GameConstants.StringConstant.instant, particlePositionRange: CGVector(dx: 5.0, dy: 5.0), position: CGPoint(x: instantGoalZ.position.x, y: instantGoalZ.position.y)) {
            sparky.zPosition = 2
            sparky.setScale(0.5)
            self.addChild(sparky)
            sparky.run(SKAction.fadeOut(withDuration: 0.4))
            
            
            
            
            
            
        }
        
        
        
        
        
        
    }
    
    
    var safety = false
    
    
    func SafetyDustEmitter() {
        
        
        
        
        safety = true
        
        
        
        
        if let sparky = ParticleHelper.addParticleEffect(name: GameConstants.StringConstant.safetyParticle, particlePositionRange: CGVector(dx: 5.0, dy: 5.0), position: CGPoint(x: GameBall.position.x, y: GameBall.position.y)) {
            sparky.zPosition = 2
            sparky.setScale(0.5)
            self.addChild(sparky)
            sparky.run(SKAction.fadeOut(withDuration: 0.4))
            
            
            
            
        }
        
        
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    var fireBool = false
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func FireDustEmitter() {
        fireBool = true
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        if let sparky = ParticleHelper.addParticleEffect(name: GameConstants.StringConstant.fireDust, particlePositionRange: CGVector(dx: 5.0, dy: 5.0), position: CGPoint(x: GameBall.position.x, y: GameBall.position.y)) {
            sparky.zPosition = 2
            self.addChild(sparky)
            sparky.run(SKAction.fadeOut(withDuration: 0.4))
        }
    }
    
    
    
    
    
    
    
    
    var ball_28_bool = false
    
    
    
    
    
    
    
    
    func Coin_28_Emitter() {
        
        
        
        
        
        
        
        
        ball_28_bool = true
        if let sparky = ParticleHelper.addParticleEffect(name: GameConstants.StringConstant.ball_28_particle, particlePositionRange: CGVector(dx: 0.1, dy: 0.1), position: CGPoint(x: GameBall.position.x, y: GameBall.position.y)) {
            sparky.zPosition = 2
            sparky.physicsBody = SKPhysicsBody(circleOfRadius: 20)
            sparky.physicsBody?.contactTestBitMask = 0
            sparky.physicsBody?.collisionBitMask = 0
            sparky.physicsBody?.isDynamic = true
            sparky.physicsBody?.allowsRotation = false
            sparky.physicsBody?.mass = 0.00001
            sparky.name = "ball29"
            sparky.setScale(1.0)
            self.addChild(sparky)
            let pinJoint = SKPhysicsJointPin.joint(withBodyA: GameBall.physicsBody!, bodyB: sparky.physicsBody!, anchor: GameBall.position)
            scene?.physicsWorld.add(pinJoint)
            
            
            
            
            
            
            
            
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
    }
    
    
    
    
    
    
    
    
    var ball_29_bool = false
    
    
    
    
    
    
    
    
    func Coin_29_Emitter() {
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        ball_29_bool = true
        if let sparky = ParticleHelper.addParticleEffect(name: GameConstants.StringConstant.ball_29_particle, particlePositionRange: CGVector(dx: 0.01, dy: 0.01), position: CGPoint(x: GameBall.position.x, y: GameBall.position.y)) {
            sparky.zPosition = 3
            
            
            
            sparky.name = "ball29"
            sparky.setScale(0.4)
            
            
            
            
            
            
            
            
            sparky.physicsBody = SKPhysicsBody(circleOfRadius: 20)
            sparky.physicsBody?.contactTestBitMask = 0
            sparky.physicsBody?.collisionBitMask = 0
            sparky.physicsBody?.isDynamic = true
            sparky.physicsBody?.allowsRotation = false
            sparky.physicsBody?.mass = 0.00001
            self.addChild(sparky)
            
            
            
            
            
            
            
            
            let pinJoint = SKPhysicsJointPin.joint(withBodyA: GameBall.physicsBody!, bodyB: sparky.physicsBody!, anchor: GameBall.position)
            scene?.physicsWorld.add(pinJoint)
            
            
            
            
            
            
            
            
        }
        
        
        
        
        
        
        
        
    }
    
    
    
    
    
    
    
    
    var ball_30_bool = false
    
    
    
    
    
    
    
    
    func Coin_30_Emitter() {
        
        
        
        
        ball_30_bool = true
        if let sparky = ParticleHelper.addParticleEffect(name: GameConstants.StringConstant.ball_30_particle, particlePositionRange: CGVector(dx: 0.08, dy: 0.08), position: CGPoint(x: GameBall.position.x, y: GameBall.position.y)) {
            sparky.zPosition = 2
            
            
            
            
            sparky.setScale(0.7)
            sparky.physicsBody = SKPhysicsBody(circleOfRadius: 20)
            sparky.physicsBody?.contactTestBitMask = 0
            sparky.physicsBody?.collisionBitMask = 0
            sparky.physicsBody?.isDynamic = true
            sparky.physicsBody?.allowsRotation = false
            sparky.physicsBody?.mass = 0.00001
            sparky.name = "ball29"
            self.addChild(sparky)
            let pinJoint = SKPhysicsJointPin.joint(withBodyA: GameBall.physicsBody!, bodyB: sparky.physicsBody!, anchor: GameBall.position)
            scene?.physicsWorld.add(pinJoint)
            
            
            
            
            
            
            
            
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func StartNewLevel(){
        
        
        
        
        
        
        coinsNum.removeFromParent()
        
        
        
        
        
        
        
        
        
        if self.action(forKey: "Rock") != nil{
            self.removeAction(forKey: "Rock")
        }
        if self.action(forKey: "bubble") != nil{
            self.removeAction(forKey: "bubble")
        }
        if self.action(forKey: "Metior") != nil{
            self.removeAction(forKey: "Metior")
        }
        
        
        
        
        
        
        
        
        // print(GameBall.size)
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        let newScene = NewLevelScene(size: self.size)
        newScene.scaleMode = self.scaleMode
        let sceneTransition = SKTransition.fade(withDuration: 0.5)
        delay(0.5){
            self.addLevel()
            let specialTransition = SKTransition.doorsOpenHorizontal(withDuration: 0.65)
            
            
            
            
            
            
            
            
            if (gameLevel < 26){
                arenaNum = 1
                
                
            }
            if (gameLevel >= 26 && gameLevel < 51){
                arenaNum = 2
                
                
                
                
                
                
                
                
            }
            if (gameLevel >= 51 && gameLevel < 75){
                arenaNum = 3
                
                
                
                
                
                
                
                
            }
            if (gameLevel >= 75 && gameLevel < 101){
                arenaNum = 4
            }
            
            
            
            
            
            
            
            
            if (gameLevel == 26 || gameLevel == 51 || gameLevel == 75 ){
                self.coins = self.coins + 10
                backingAudio?.stop()
                self.view!.presentScene(newScene, transition: specialTransition )
                self.coins += 25
                defaults.set(self.coins,forKey: "coinsSaved")
            }
            else{
                self.view!.presentScene(newScene, transition: sceneTransition )
            }
        }
        
        
        
        
        
        
        
        
    }
    
    
    
    
    
    
    
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
    
    
    
    
    
    
    
    
    func fingerDistanceFromProjectileRestPosition(projectileRestPosition: CGPoint, fingerPosition: CGPoint) -> CGFloat {
        return sqrt(pow(projectileRestPosition.x - fingerPosition.x,2) + pow(projectileRestPosition.y - fingerPosition.y,2))
    }
    
    
    
    
    
    
    
    
    func projectilePositionForFingerPosition(fingerPosition: CGPoint, projectileRestPosition:CGPoint, rLimit:CGFloat) -> CGPoint {
        let θ = atan2(fingerPosition.x - projectileRestPosition.x, fingerPosition.y - projectileRestPosition.y)
        let cX = sin(θ) * rLimit
        let cY = cos(θ) * rLimit
        return CGPoint(x: cX + projectileRestPosition.x, y: cY + projectileRestPosition.y)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func findAngle(fingerPosition: CGPoint, projectileRestPosition:CGPoint) -> CGFloat {
        let θ = atan2(fingerPosition.x - projectileRestPosition.x, fingerPosition.y - projectileRestPosition.y)
        return -θ
    }
    
    
    
    
    
    
    
    
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        
        
        
        
        
        
        func shouldStartDragging(touchLocation:CGPoint, threshold: CGFloat) -> Bool {
            let distance = fingerDistanceFromProjectileRestPosition(
                projectileRestPosition: Settings.Metrics.projectileRestPosition,
                fingerPosition: touchLocation
            )
            return distance < Settings.Metrics.projectileRadius + threshold
        }
        
        
        
        
        
        
        
        
        if let touch = touches.first {
            let touchLocation = touch.location(in: self)
            if !projectileIsDragged && shouldStartDragging(touchLocation: touchLocation, threshold: Settings.Metrics.projectileTouchThreshold) && !shotBall  {
                touchStartingPoint = touchLocation
                touchCurrentPoint = touchLocation
                projectileIsDragged = true
                dashedLine.position = touchCurrentPoint
                dashedLine.zRotation = findAngle(fingerPosition: touchLocation, projectileRestPosition: Settings.Metrics.projectileRestPosition )
                dashedLine.isHidden = false
            }
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        for touch: AnyObject in touches{
            let pointOfTouch = touch.location(in: self)
            let nodeITapped = atPoint(pointOfTouch)
            
            
            
            
            
            
            
            
            if nodeITapped.name == "pausedButtonMenu" && !projectileIsDragged
            {
                
                
                
                
                pausedScene()
            }
            
            
            
            
            
            
            
            
            if (nodeITapped.name == "fireButton" && !projectileIsDragged) {
                if (firePowerUps > 0 && !currentlyOnFire){
                    
                    firePowerUps = firePowerUps -  1
                    defaults.set(firePowerUps, forKey: "firePowerUps")
                    powerUpNumLabel.text = "\(firePowerUps)"
                    if (firePowerUps == 0){
                        useFirePowerUp.alpha = 0.3
                        powerUpNumLabel.alpha = 0.3
                    }
                    if (arenaNum == 1 || arenaNum == 3 || arenaNum == 4){
                        
                        particle()
                        Settings.Metrics.forceMultiplier = 40
                        self.addChild(flameSound)
                        if sound == false{
                            flameSound.removeFromParent()
                        }
                    }
                    if (arenaNum == 2){
                        let bubble = SKSpriteNode(imageNamed: "bubbleBall")
                        bubble.zPosition = 1
                        bubble.position = GameBall.position
                        //Settings.Metrics.forceMultiplier = 10.0
                        GameBall.alpha = 0.2
                        bubble.physicsBody = SKPhysicsBody(circleOfRadius: bubble.size.width / 2.0)
                        bubble.physicsBody?.categoryBitMask =  physicsCategories.bubble
                        bubble.physicsBody?.collisionBitMask = physicsCategories.horiPost | physicsCategories.vertPost1 | physicsCategories.vertPost2 | physicsCategories.leftBorder | physicsCategories.rightBorder | physicsCategories.resistantDefender
                        bubble.physicsBody?.contactTestBitMask = physicsCategories.goal | physicsCategories.horiPost | physicsCategories.vertPost1 | physicsCategories.vertPost2 | physicsCategories.leftBorder | physicsCategories.rightBorder | physicsCategories.QuickGoal | physicsCategories.fire | physicsCategories.resistantDefender | physicsCategories.metior | physicsCategories.rock
                        self.addChild(bubble)
                        bubble.physicsBody?.mass = 0.001
                        
                        let pinJoint = SKPhysicsJointPin.joint(withBodyA: GameBall.physicsBody!, bodyB: bubble.physicsBody!, anchor: GameBall.position)
                        scene?.physicsWorld.add(pinJoint)
                        if(sound == true){
                            self.run(SKAction.repeatForever(bubbleSound), withKey: "bubble")
                        }
                        Settings.Metrics.forceMultiplier = 40
                    }
                    GameBall.physicsBody?.contactTestBitMask = physicsCategories.goal | physicsCategories.horiPost | physicsCategories.vertPost1 | physicsCategories.vertPost2 | physicsCategories.leftBorder | physicsCategories.rightBorder | physicsCategories.QuickGoal | physicsCategories.fire | physicsCategories.coin | physicsCategories.SafetyArea | physicsCategories.resistantDefender
                    GameBall.physicsBody?.collisionBitMask = physicsCategories.horiPost | physicsCategories.vertPost1 | physicsCategories.vertPost2 | physicsCategories.leftBorder | physicsCategories.rightBorder | physicsCategories.resistantDefender | physicsCategories.metior | physicsCategories.rock
                    currentlyOnFire = true
                    
                    self.enumerateChildNodes(withName: "defender"){
                        defender, stop in
                        defender.physicsBody!.collisionBitMask = physicsCategories.leftBorder | physicsCategories.rightBorder | physicsCategories.ball
                        defender.physicsBody!.contactTestBitMask = physicsCategories.leftBorder | physicsCategories.rightBorder | physicsCategories.ball
                    }
                }
            }
            
            
            
            
            
            
            
            
            if nodeITapped.name == "restart"
            {
                gameLevel = 1
                gameDifficulty = 1
                numOfInitDef = 1
                arenaNum = 1
                currentlyOnFire = false
                //firePowerUps = 0
                backingAudio?.stop()
                let sceneToMoveTo = NewLevelScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.doorsOpenHorizontal(withDuration: 0.8)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
            }
            
            
            
            
            
            
            
            
            if nodeITapped.name == "MainMenu"
            {
                backingAudio?.stop()
              //  game
               // gameDifficulty = 1
               // arenaNum = 1
               /// numOfInitDef = 1
                //firePowerUps = 0
                let sceneToMoveTo = MainMenuScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
            }
            
            
            
            
            
            
            
            
            if nodeITapped.name == "Continue" {
                
                resumeScene()
                
            }
            
            if nodeITapped.name == "NoAdds" {
                let va = self.view?.window?.rootViewController
                
                
                let urlString = NSURL(string: "https://apps.apple.com/us/app/GOAL.Z/id1473082797")
                let object = [urlString]
                
                
                let activityVC:UIActivityViewController = UIActivityViewController(activityItems: object as [Any], applicationActivities: nil)
                
                
                va?.present(activityVC, animated: true, completion: nil)
            }
            
            
            
            
            
            
            if nodeITapped.name == "mute"{
                if sound == false{
                    sound = true
                    if currentGameState != gameState.paused{
                        backingAudio?.play()
                    }
                    noSound.texture = SKTexture(imageNamed: "noSound")
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                }
                else{
                    
                    
                    
                    
                    sound = false
                    backingAudio?.pause()
                    noSound.texture = SKTexture(imageNamed: "PlayMusic")
                }
            }
            
            
            if (nodeITapped == moreBall && currentGameState == gameState.paused){
                backingAudio?.stop()
                
                
                let sceneToMoveTo = CoinStore(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
            }
            if (nodeITapped == scoreBoard && currentGameState == gameState.paused){
                backingAudio?.stop()
                
                
            }
            if (nodeITapped == ThumbsUp && currentGameState == gameState.paused){
                
                
                
                
            }
            
            
        }
    }
    
    
    
    
    
    
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for _: AnyObject in touches{
            
            
            if projectileIsDragged {
                if let touch = touches.first {
                    let touchLocation = touch.location(in: self)
                    let distance = fingerDistanceFromProjectileRestPosition(projectileRestPosition: touchLocation, fingerPosition: touchStartingPoint)
                    if distance < Settings.Metrics.rLimit  {
                        touchCurrentPoint = touchLocation
                    } else {
                        touchCurrentPoint = projectilePositionForFingerPosition(
                            fingerPosition: touchLocation,
                            projectileRestPosition: Settings.Metrics.projectileRestPosition,
                            rLimit: Settings.Metrics.rLimit
                        )
                    }
                    if (distance >= 0 && distance < 30){
                        //dashedLine.texture = SKTexture(imageNamed: "speed1")
                        dashedLine.setScale(0.65)
                        
                        
                        if (distance >= 30 && distance < 35){
                            //dashedLine.texture = SKTexture(imageNamed: "speed1")
                            dashedLine.setScale(075)
                        }
                        if (distance >= 35 && distance < 40){
                            // dashedLine.texture = SKTexture(imageNamed: "speed1")
                            dashedLine.setScale(0.85)
                        }
                        if (distance >= 40 && distance < 45){
                            // dashedLine.texture = SKTexture(imageNamed: "speed1")
                            dashedLine.setScale(0.85)
                        }
                        if (distance >= 45 && distance < 50){
                            //dashedLine.texture = SKTexture(imageNamed: "speed1")
                            dashedLine.setScale(0.85)
                        }
                        
                        if (distance >= 50){
                            // dashedLine.texture = SKTexture(imageNamed: "speed1")
                            dashedLine.setScale(0.9)
                        }
                    }
                    dashedLine.position = GameBall.position
                    dashedLine.zRotation = findAngle(fingerPosition: touchCurrentPoint, projectileRestPosition: Settings.Metrics.projectileRestPosition)
                    if (currentlyOnFire){
                        let emitter = self.childNode(withName: "MyParticle")
                        emitter?.zRotation = findAngle(fingerPosition: touchCurrentPoint, projectileRestPosition: Settings.Metrics.projectileRestPosition) + 3.14159
                        emitter?.position = GameBall.position
                    }
                    
                }
                
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if projectileIsDragged {
            projectileIsDragged = false
            let distance = fingerDistanceFromProjectileRestPosition(projectileRestPosition: touchCurrentPoint, fingerPosition: Settings.Metrics.projectileRestPosition)
            if distance > Settings.Metrics.projectileSnapLimit {
                let vectorX = Settings.Metrics.projectileRestPosition.x - touchCurrentPoint.x
                let vectorY = Settings.Metrics.projectileRestPosition.y - touchCurrentPoint.y
                GameBall.physicsBody?.applyImpulse(
                    CGVector(
                        dx: vectorX * Settings.Metrics.forceMultiplier,
                        dy: vectorY * Settings.Metrics.forceMultiplier
                    )
                )
                dashedLine.isHidden = true
                shotBall = true
                
            } else {
                GameBall.position = Settings.Metrics.projectileRestPosition
                dashedLine.isHidden = true
            }
        }
        
        
    }
    
}

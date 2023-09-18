//
//  GameViewController.swift
//  GOALZ
//
//  Created by Carter Stambaugh on 7/15/19.
//  Copyright © 2019 Carter Stambaugh. All rights reserved.
//
//



import UIKit

//import GoogleMobileAds

import SpriteKit

import GameplayKit

import AVFoundation



class GameViewController: UIViewController{
    
    
    
    var coins = defaults.integer(forKey: "coinsSaved")
    
    let scene = MainMenuScene(size: CGSize(width: 1536, height: 2048))
    
    
   
    override func viewDidLoad() {
        
        
        
        super.viewDidLoad()
        
        
        
        if let view = self.view as! SKView? {
            
    
            view.showsPhysics = false
    
            scene.scaleMode = .aspectFill
            
            view.presentScene(scene)
            
            view.ignoresSiblingOrder = false
            
            view.showsFPS = false
            
            view.showsNodeCount = false
            
            
            
        }
        
        
        /*GADRewardBasedVideoAd.sharedInstance().delegate = self
        GADRewardBasedVideoAd.sharedInstance().load(GADRequest(),
                                                    withAdUnitID: "ca-app-pub-8167229834723556/1382382209")*/
       
    }
}
    
    
/*
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd,
                            
                            didRewardUserWith reward: GADAdReward) {
        
        print("Reward received with currency: \(reward.type), amount \(reward.amount).")
        
       
       
      
        if currentGameState == gameState.afterGame{
            gameLevel = prevGameLevel
            
            if let view = self.view as! SKView? {
                let sceneToMoveTo = GameScene(size: CGSize(width: 1536, height: 2048))
                
                sceneToMoveTo.scaleMode = .aspectFill
                
                let myTransition = SKTransition.fade(withDuration: 0.5)
                
                
                view.presentScene(sceneToMoveTo, transition: myTransition)
            }
        }
        else {
            
            coins = defaults.integer(forKey: "coinsSaved")
            
            coins += 20
            
            defaults.set(coins, forKey: "coinsSaved")
            
            coinsNum.text = "\(coins)"
        }

        
        
    }
    */
    /*
    
    func rewardBasedVideoAdDidReceive(_ rewardBasedVideoAd:GADRewardBasedVideoAd) {
        
        
        
        print("rewardBasedVideoAdDidReceive")
        
    }
    
    
    
    func rewardBasedVideoAdDidOpen(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        
        
        
        print("rewardBasedVideoAdDidOpen")
        
    }
    
    
    
    func rewardBasedVideoAdDidStartPlaying(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        
        
        
        print("rewardBasedVideoAdDidStartPlaying")
        
    }
    
    
    
    func rewardBasedVideoAdDidCompletePlaying(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        
        
        
        
        
        print("rewardBasedVideoAdDidCompletePlaying")
        
        
        
        
        // videoAd.load(request, withAdUnitID: "ca-app-pub-3940256099942544/1712485313")
        
        
        
        
        
        
        
    }
    
    
    
    
    
    func rewardBasedVideoAdDidClose(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        
        
        
        // videoAd.load(request,withAdUnitID: "ca-app-pub-8167229834723556/9575663031")
        
        //  let sceneToMoveTo = MainMenuScene(size: self.size)
        
        //  sceneToMoveTo.scaleMode = self.scaleMode
        
        //  let myTransition = SKTransition.fade(withDuration: 0.5)
        
        //  self.view!.presentScene(sceneToMoveTo, transition: myTransition)
        
       // GADRewardBasedVideoAd.sharedInstance().load(GADRequest(),withAdUnitID: "ca-app-pub-8167229834723556/1382382209")
        
        
        
        
        coinsNum.text = "\(coins)"
        
        
        
        print("ad closed")
        
        
        
        
    }
    
    
    
    //func rewardBasedVideoAdWillLeaveApplication(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        
        //print("rewardBasedVideoAdWillLeaveApplication")
        
   // }
    
    
    
    /*func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd,
                            
                            didFailToLoadWithError error: Error) {
        
        print("ad ready")
        
    }
    
    
    
    @objc func startVideoAd() {
        
        
        
        
        
        
        
        if GADRewardBasedVideoAd.sharedInstance().isReady == true {
            
            
            
            
            GADRewardBasedVideoAd.sharedInstance().present(fromRootViewController: self)
            
            print("coinstore")
            
        }
        
        
        
        
        
    }*/
    
    
    
    
    /*
    
    
    override func viewWillLayoutSubviews() {
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.startVideoAd), name: NSNotification.Name(rawValue: "showVideoRewardAd"), object: nil)
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
 */*/

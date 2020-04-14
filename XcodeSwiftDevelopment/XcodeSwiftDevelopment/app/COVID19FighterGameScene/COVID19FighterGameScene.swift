//
//  COVID19FighterGameScene.swift
//  XcodeSwiftDevelopment
//
//  Created by Team SunStripe on 2020/04/15.
//  Copyright © 2020年 TeamSunstripe. All rights reserved.
//

import Foundation
import SpriteKit

class COVID19FighterGameScene : SKScene,SKPhysicsContactDelegate {
    
    // スコア
    var score = 0
    var scoreLabel : SKLabelNode!
    var scoreList = [100]
    
    var background : SKSpriteNode!
    
    ///
    var player : SKSpriteNode?
    
    /// タイマーセット
    var timer : NSTimer?
    
    /// 落下判定用シェイプ
    var lowestShape : SKShapeNode?
    
    override func didMoveToView(view: SKView) {
        // 下方向に重力を追加
        self.settingGravity()
        
        /// 落下判定用のデリゲート
        self.settingLowest()
        
        // 背景のスプライトを追加
        self.backgroundSpecialty()
        
        // スコアのスプライトを追加
        self.scoreSpecialty()
        // 落下判定の追加
        self.settingLowestShape()
        
        // player 操作できるスプライトを追加
        self.playerSpecialty()
        
        // 落下させるものの準備
        self.randomFallSpecialty()
        
        /// スプライトを一定間隔で落下させる
        self.setTimer()

    }
    
    // 背景のスプライトを追加
    func backgroundSpecialty() {
        let background = SKSpriteNode(imageNamed: "background-COVID-19")
        background.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.5)
        background.size = self.size
        self.addChild(background)
        self.background = background
    }
    
    // スコアのスプライトを追加
    func scoreSpecialty() {
        // スコア用のラベル
        let scoreLabel = SKLabelNode(fontNamed: "Helvetica")
        scoreLabel.position = CGPoint(x: self.size.width * 0.92, y: self.size.height * 0.78)
        scoreLabel.text = "\(score)pt"
        scoreLabel.fontSize = 32
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right // 右寄せ
        scoreLabel.fontColor = UIColor.redColor()
        self.addChild(scoreLabel)
        self.scoreLabel = scoreLabel
    }

    
    // player 操作できるスプライトを追加
    func playerSpecialty() {
        let texture = SKTexture(imageNamed: "player");
        let sprite = SKSpriteNode(texture: texture);
        sprite.position = CGPointMake(self.size.width * 0.5, 100)
        sprite.size = CGSize(width: texture.size().width * 0.5, height: texture.size().height * 0.5)
        
        // テクスチャーからPhysicsBodyを追加
        sprite.physicsBody = SKPhysicsBody(texture: texture,size: sprite.size)
        sprite.physicsBody?.dynamic = false
        self.addChild(sprite)
        self.player = sprite
    }
    
    // スプライトをタッチして動かす
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch:AnyObject = touches.first {
            let location = touch.locationInNode(self)
            let action = SKAction.moveTo(CGPoint(x: location.x, y:100), duration: 0.2)
            self.player?.runAction(action)
        }
    }
    
    // ドラッグ時
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch:AnyObject = touches.first {
            let location = touch.locationInNode(self)
            let action = SKAction.moveTo(CGPoint(x: location.x, y:100), duration: 0.2)
            self.player?.runAction(action)
        }
    }
    
    // 落下させる（ランダム）
    func randomFallSpecialty() {
        let index = 0 // Int(arc4random_uniform(8)) // ランダム変数(0 〜 7)
        /// スコア用のラベルの査定
        self.score += self.scoreList[index]
        if let _ = self.scoreLabel {
            self.scoreLabel?.text = "\(self.score)pt"
        } else {
            print("self.scoreLabel : scoreLabel が設定してません")
        }
        let texture = SKTexture(imageNamed: "COVID-19")//"\(index)");
        let sprite = SKSpriteNode(texture: texture);
        sprite.position = CGPointMake(self.size.width * 0.5, self.size.height)
        sprite.size = CGSize(width: texture.size().width * 0.5, height: texture.size().height * 0.5)
        
        // テクスチャーからPhysicsBodyを追加
        sprite.physicsBody = SKPhysicsBody(texture: texture,size: sprite.size)
        
        self.addChild(sprite)
    }
    
    /// スプライトを落下させる
    // 下方向に重力を追加
    func settingGravity() {
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -0.2);
    }
    
    /// スプライトを一定間隔で落下させよう
    func setTimer () {
        self.timer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: "randomFallSpecialty", userInfo: nil, repeats: true)
    }
    
    /// ゲームオーバー処理を追加しよう
    
    /// 落下判定用のデリゲート
    func settingLowest() {
        self.physicsWorld.contactDelegate = self
    }
    
    /// 落下判定用の設置
    func settingLowestShape() {
        let lowestShape = SKShapeNode(rectOfSize: CGSize(width: self.size.width * 3.0, height: 10))
        let physicsBody = SKPhysicsBody(rectangleOfSize: lowestShape.frame.size)
        physicsBody.dynamic = false
        physicsBody.contactTestBitMask = 0x1 << 1 // 衝突を通知する対応のビットマスクを指定
        lowestShape.physicsBody = physicsBody
        
        self.addChild(lowestShape)
        self.lowestShape = lowestShape
    }
    
    /// 当たり判定
    func didBeginContact(contact: SKPhysicsContact) {
        if contact.bodyA.node == self.lowestShape || contact.bodyB.node == self.lowestShape {
            // gameover()
        }
    }
    
    // ゲームオーバー
    func gameover() {
        let sprite = SKSpriteNode(imageNamed: "gameover")
        sprite.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.5)
        
        self.addChild(sprite)
        
        self.paused = true
        
        self.timer?.invalidate()
    }
    

}
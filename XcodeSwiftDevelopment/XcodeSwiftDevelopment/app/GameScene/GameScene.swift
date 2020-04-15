//
//  GameScene.swift
//  XcodeSwiftDevelopment
//
//  Created by Team SunStripe on 2020/04/14.
//  Copyright © 2020年 TeamSunstripe. All rights reserved.
//

import Foundation
import SpriteKit

class GameScene : SKScene,SKPhysicsContactDelegate {
    
    /// gamePropaty
    var score = 0
    var scoreLabel : SKLabelNode?
    var scoreList = [10,20,30,40,50,60,70,100]
    ///
    var controller : SKSpriteNode?
    
    /// タイマーセット
    var timer : NSTimer?
    
    /// 落下判定用シェイプ
    var lowestShape : SKShapeNode?
    
    override func didMoveToView(view: SKView) {
        
        // 下方向に重力を追加
        self.setupGravity()
        
        /// 落下判定用のデリゲート
        self.setupLowest()
        
        // 背景のスプライトを追加
        self.setupBackgroundSpecialty()
        
        // スコアのスプライトを追加
        self.setupScoreSpecialty()
        // 落下判定の追加
        self.setupLowestShape()
        
        // スワイプで操作できるスプライトを追加
        self.setupControllerSpecialty()
        
        // 落下させるものの準備
        // self.fallSpecialty()
        self.setupRandomFallSpecialty()
        
        /// スプライトを一定間隔で落下させる
        self.setupTimer()
    }
    
    // 背景のスプライトを追加
    func setupBackgroundSpecialty() {
        let background = SKSpriteNode(imageNamed: "background-cloud")
        background.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.5)
        background.size = self.size
        self.addChild(background)
    }
    
    // スコアのスプライトを追加
    func setupScoreSpecialty() {
        // スコア用のラベル
        let scoreLabel = SKLabelNode(fontNamed: "Helvetica")
        scoreLabel.position = CGPoint(x: self.size.width * 0.92, y: self.size.height * 0.78)
        scoreLabel.text = "\(score)pt"
        scoreLabel.fontSize = 32
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right // 右寄せ
        scoreLabel.fontColor = UIColor.orangeColor()
        self.addChild(scoreLabel)
        self.scoreLabel = scoreLabel
    }
    
    // スワイプで操作できるスプライトを追加
    func setupControllerSpecialty() {
        let texture = SKTexture(imageNamed: "goal-keeper");
        let sprite = SKSpriteNode(texture: texture);
        sprite.position = CGPointMake(self.size.width * 0.5, 100)
        sprite.size = CGSize(width: texture.size().width * 0.5, height: texture.size().height * 0.5)
        
        // テクスチャーからPhysicsBodyを追加
        sprite.physicsBody = SKPhysicsBody(texture: texture,size: sprite.size)
        sprite.physicsBody?.dynamic = false
        self.addChild(sprite)
        self.controller = sprite
    }
    
    // スプライトをタッチして動かす
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch:AnyObject = touches.first {
            let location = touch.locationInNode(self)
            let action = SKAction.moveTo(CGPoint(x: location.x, y:100), duration: 0.2)
            self.controller?.runAction(action)
        }
    }
    
    // ドラッグ時
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch:AnyObject = touches.first {
            let location = touch.locationInNode(self)
            let action = SKAction.moveTo(CGPoint(x: location.x, y:100), duration: 0.2)
            self.controller?.runAction(action)
        }
    }
    
    // 落下させる
    func setupFallSpecialty() {
        let texture = SKTexture(imageNamed: "0");
        let sprite = SKSpriteNode(texture: texture);
        sprite.position = CGPointMake(self.size.width * 0.5, self.size.height)
        sprite.size = CGSize(width: texture.size().width * 0.5, height: texture.size().height * 0.5)
        
        // テクスチャーからPhysicsBodyを追加
        sprite.physicsBody = SKPhysicsBody(texture: texture,size: sprite.size)
        
        self.addChild(sprite)
    }
    
    
    // 落下させる（ランダム）
    func setupRandomFallSpecialty() {
        let index = Int(arc4random_uniform(8)) // ランダム変数(0 〜 7)
        /// スコア用のラベルの査定
        self.score += self.scoreList[index]
        if let _ = self.scoreLabel {
            self.scoreLabel?.text = "\(self.score)pt"
        } else {
            print("self.scoreLabel : scoreLabel が設定してません")
        }
        let texture = SKTexture(imageNamed: "\(index)");
        let sprite = SKSpriteNode(texture: texture);
        sprite.position = CGPointMake(self.size.width * 0.5, self.size.height)
        sprite.size = CGSize(width: texture.size().width * 0.5, height: texture.size().height * 0.5)
        
        // テクスチャーからPhysicsBodyを追加
        sprite.physicsBody = SKPhysicsBody(texture: texture,size: sprite.size)
        
        self.addChild(sprite)
    }
    
    /// スプライトを落下させる
    // 下方向に重力を追加
    func setupGravity() {
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -0.2);
    }

    /// スプライトを一定間隔で落下させよう
    func setupTimer () {
        self.timer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: "setupRandomFallSpecialty", userInfo: nil, repeats: true)
    }

    /// ゲームオーバー処理を追加しよう
    
    /// 落下判定用のデリゲート
    func setupLowest() {
        self.physicsWorld.contactDelegate = self
    }

    /// 落下判定用の設置
    func setupLowestShape() {
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
            gameover()
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
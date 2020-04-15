//
//  AnimationGameScene.swift
//  XcodeSwiftDevelopment
//
//  Created by Team SunStripe on 2020/04/14.
//  Copyright © 2020年 TeamSunstripe. All rights reserved.
//

import Foundation
import SpriteKit

class AnimationGameScene : SKScene {
    var player: SKSpriteNode!
    var baseNode: SKNode!
    var crimpNode: SKNode!
    
    /// 衝突判定用のビット値の準備
    struct CategoryType {
        static let None  :UInt32 = (1 << 0) // 設定なし
        static let Player:UInt32 = (1 << 1) // プレイヤー
        static let World :UInt32 = (1 << 2) // 世界観
        static let Crimp :UInt32 = (1 << 3) // 障害物
        static let Score :UInt32 = (1 << 4) // スコア
    }
    
    struct ImageContents {
        // プレイヤー画像
        static let PlayerImages = ["fish00","fish01","fish02","fish03","fish04"]
    }
    
    override func didMoveToView(view: SKView) {
        // 下方向に重力を追加
        self.setupGravity()
        
        // 全ノードのベースとなるノードの作成
        baseNode = SKNode()
        baseNode.speed = 1.0
        self.addChild(baseNode)
        
        // 障害物を追加するノードを生成
        crimpNode = SKNode()
        baseNode.addChild(crimpNode)
        // 背景のスプライトを追加
        self.setupBackgroundOceanSpecialty()
        // 奥行きの表現の岩のスプライトを追加
        self.setupBackgroundWorldSpecialty()
        
        // 地面の設定
        self.setupCeilingAndRoadSpecialty()

        // プレイヤーの設定
        self.setupPlayerSpecialty()
        
        // 障害物の設定
        self.setupCrimpSpecialty()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: AnyObject in touches {
            _ = touch.locationInNode(self)
            // プレイヤーに加えられている力をゼロにする
            player.physicsBody?.velocity = CGVector.zero
            // プレイヤーにy軸方向へ力を加える
            player.physicsBody?.applyForce(CGVector(dx: 0.0, dy: 23.0))
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
    }
    
    override func update(currentTime: NSTimeInterval) {
        
    }
    
    /// スプライトを落下させる
    // 下方向に重力を追加
    func setupGravity() {
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -0.2);
    }
    
    // 背景のスプライトを追加
    // 背景アニメーションの実装
    func setupBackgroundOceanSpecialty() {
        // 背景画像を読み込む
        self.setupWorldTexture(imageNamed: "background-ocean",zPosition : -100,duration : 10.0, point : { (i,sprite) -> (CGPoint) in
            return CGPoint( x:i * sprite.size.width, y: self.frame.size.height / 2.0)
            },category:CategoryType.None)
    }
    
    // 上下の世界を表現
    func setupCeilingAndRoadSpecialty() {
        // 天井画像を読み込む
        self.setupWorldTexture(imageNamed: "ceiling",zPosition : 0,duration : 100.0, point : { (i,sprite) -> (CGPoint) in
            return CGPoint( x:i * sprite.size.width, y: self.frame.size.height - sprite.size.height / 2.0)
            },category:CategoryType.World)
        
        // 地面画像を読み込む
        self.setupWorldTexture(imageNamed: "road",zPosition : 0, duration : 100.0, point : { (i,sprite) -> (CGPoint) in
            return CGPoint( x:i * sprite.size.width, y: sprite.size.height / 2.0)
            },category:CategoryType.World)
    }
    
    // 奥行きの表現
    func setupBackgroundWorldSpecialty() {
        // 岩山（上）画像を読み込む
        self.setupWorldTexture(imageNamed: "rock_upper",zPosition : -50,duration : 20.0, point : { (i,sprite) -> (CGPoint) in
            return CGPoint( x:i * sprite.size.width, y: self.frame.size.height - (sprite.size.height / 2.0))
        },category:CategoryType.None)
        // 岩山（下）画像を読み込む
        self.setupWorldTexture(imageNamed: "rock_under",zPosition : -50,duration : 20.0, point : { (i, sprite) -> (CGPoint) in
            return CGPoint( x:i * sprite.size.width, y: sprite.size.height / 2.0)
        },category:CategoryType.None)
    }
    
    /// 世界を表現するもの
    func setupWorldTexture(imageNamed name: String,zPosition : CGFloat, duration : CGFloat,point spritePosition: (i :CGFloat,sprite :SKSpriteNode) -> (CGPoint),category : UInt32) {
        // 岩山（上）画像を読み込む
        let worldTexture = SKTexture(imageNamed: name)
        worldTexture.filteringMode = .Nearest
        
        // 必要なアニメーションを算出
        let needNumber = 2.0 + (self.frame.size.width / worldTexture.size().width)
        
        // アニメーションを作成
        let moveAnimation  = SKAction.moveByX(-worldTexture.size().width, y: 0.0, duration:NSTimeInterval(worldTexture.size().width / duration))
        let resetAnimation = SKAction.moveByX( worldTexture.size().width, y: 0.0, duration:0.0)
        let repeatForeverAnimation = SKAction.repeatActionForever(SKAction.sequence([moveAnimation, resetAnimation]))
        
        // 画像の配置とアニメーションを設定
        for var i:CGFloat = 0;i < needNumber;++i {
            let sprite = SKSpriteNode(texture: worldTexture)

            if category == CategoryType.None {
                sprite.zPosition = zPosition
            } else {
                // 画像に物理シミュレーションを設定
                sprite.physicsBody = SKPhysicsBody(texture: worldTexture, size: worldTexture.size())
                sprite.physicsBody?.dynamic = false
                sprite.physicsBody?.categoryBitMask = category
            }
            sprite.position = spritePosition(i: i, sprite: sprite)
            sprite.runAction(repeatForeverAnimation)
            baseNode.addChild(sprite)
        }
    }
    
    // プレイヤー画像作成
    func setupPlayerSpecialty() {
        
        // Player のパラパラアニメーション作成に必要な SKTexture クラスの配列を定義
        var playerTexture = [SKTexture]()
        
        // パラパラアニメーションに必要な画像を読み込む
        for imageName in ImageContents.PlayerImages {
            let texture = SKTexture(imageNamed: imageName)
            texture.filteringMode = .Linear
            playerTexture.append(texture)
        }
        
        // パラパラ漫画のアニメーションを作成
        let playerAnimation = SKAction.animateWithTextures(playerTexture, timePerFrame: 0.2)
        let loopAnimation = SKAction.repeatActionForever(playerAnimation);
        
        // キャラクターを生成し、アニメーションを設定
        player = SKSpriteNode(texture: playerTexture[0])
        player.position = CGPoint(x: self.frame.size.width * 0.35, y: self.frame.size.height * 0.6)
        player.runAction(loopAnimation)
        
        /// キャラクターに物理シミュレーションを設定
        player.physicsBody = SKPhysicsBody(texture: playerTexture[0],size:playerTexture[0].size())
        player.physicsBody?.dynamic = true
        player.physicsBody?.allowsRotation = false
        // 自分自身にPlayerカテゴリを設定
        player.physicsBody?.categoryBitMask = CategoryType.Player
        // 衝突相手にWorld と Crimp を設定
        player.physicsBody?.collisionBitMask = CategoryType.World | CategoryType.Crimp
        player.physicsBody?.contactTestBitMask = CategoryType.World | CategoryType.Crimp
        
        self.addChild(player)
    }
    
    // 障害物の作成
    func setupCrimpSpecialty() {
        // 障害物画像
        let crimp = SKTexture(imageNamed: "coral")
        crimp.filteringMode = .Linear
        
        // 移動する距離を算出
        let distanceToMove = CGFloat(self.frame.size.width + 2.0 * crimp.size().width)
        
        // アニメーションを作成
        let moveAnimation = SKAction.moveByX(-distanceToMove, y:0.0, duration:NSTimeInterval(distanceToMove / 100))
        let removeAnimation = SKAction.removeFromParent()
        let crimpAnimation = SKAction.sequence([moveAnimation,removeAnimation])
        
        // 障害物を生成するメソッド
        let newCrimpAnimation = SKAction.runBlock { () -> Void in
            /// 障害物に関するノードを乗せるノードを作成
            let crimpNode = SKNode()
            crimpNode.position = CGPoint(x:self.frame.size.width + crimp.size().width * 2,y:0.0)
            crimpNode.zPosition = -50.0
            
            // 地面から現れる障害物のy座標を算出
            let height = UInt32(self.frame.size.height / 12)
            let y = CGFloat(arc4random_uniform(height * 2) + height)
            
            // 地面から現れる障害物を作成
            let crimpUnder = SKTexture(imageNamed: "stone")
            let under = SKSpriteNode(texture: crimpUnder)
            under.position = CGPoint(x: 0.0, y: y)
            
            // 障害物に物理シミュレーションを設定
            under.physicsBody = SKPhysicsBody(texture: crimpUnder, size: under.size)
            under.physicsBody?.dynamic = false
            under.physicsBody?.categoryBitMask = CategoryType.Crimp
            under.physicsBody?.contactTestBitMask = CategoryType.Player
            
            crimpNode.addChild(under)
            
            // 天井から現れる障害物を作成
            let crimpUpper = SKTexture(imageNamed: "stone")
            let upper = SKSpriteNode(texture: crimpUpper)
            upper.position = CGPoint(x: 0.0, y: y + (under.size.height / 2.0) + 160.0 + (upper.size.height / 2.0))
            
            // 障害物に物理シミュレーションを設定
            upper.physicsBody = SKPhysicsBody(texture: crimpUpper, size: upper.size)
            upper.physicsBody?.dynamic = false
            upper.physicsBody?.categoryBitMask = CategoryType.Crimp
            upper.physicsBody?.contactTestBitMask = CategoryType.Player
            
            crimpNode.addChild(upper)
            
            // スコアをカウントアップするノードを作成
            let scoreNode = SKNode()
            scoreNode.position = CGPoint(x: (upper.size.width / 2.0) + 5.0,y: self.frame.size.height / 2.0)
            // スコアノードに物理シミュレーションを設定
            scoreNode.physicsBody = SKPhysicsBody(texture: crimpUpper, size: upper.size)
            scoreNode.physicsBody?.dynamic = false
            scoreNode.physicsBody?.categoryBitMask = CategoryType.Score
            scoreNode.physicsBody?.contactTestBitMask = CategoryType.Player
            crimpNode.addChild(scoreNode)
            crimpNode.runAction(crimpAnimation)
            self.crimpNode.addChild(crimpNode)
            
        }
        
        let delayAnimation = SKAction.waitForDuration(2.5)
        let repeatForeverAnimation = SKAction.repeatActionForever(SKAction.sequence([newCrimpAnimation , delayAnimation]))

        self.runAction(repeatForeverAnimation)
    }
}
//
//  GameSceneViewController.swift
//  XcodeSwiftDevelopment
//
//  Created by Team SunStripe on 2020/04/14.
//  Copyright © 2020年 TeamSunstripe. All rights reserved.
//

import UIKit
import SpriteKit

class GameSceneViewController : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // シーンの作成
        let scene = GameScene()
        
        // View Controller の view を SKView型として取り出す
        guard let view = self.view as? SKView else {
            print("self.view : SKViewクラスではありません")
            return
        }
        
        // FPS の表示
        view.showsFPS = true
        // ノード数の表示
        view.showsNodeCount = true
        
        // シーンのサイズをビューに合わせる
        scene.size = view.frame.size
        
        // ビュー上にシーンをを表示
        view.presentScene(scene)
    }
}

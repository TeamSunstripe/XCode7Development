//
//  COVID19FighterGameViewController.swift
//  XcodeSwiftDevelopment
//
//  Created by Team SunStripe on 2020/04/15.
//  Copyright © 2020年 TeamSunstripe. All rights reserved.
//

import Foundation
import SpriteKit

class COVID19FighterGameViewController : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // シーンの作成
        let scene = COVID19FighterGameScene()
        
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
        scene.scaleMode = .AspectFill
        scene.size = view.frame.size
        
        // ビュー上にシーンをを表示
        view.presentScene(scene)
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.AllButUpsideDown
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}



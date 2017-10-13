//
//  GameViewController.swift
//  HappyRun
//
//  Created by Tbxark on 13/10/2017.
//  Copyright © 2017 Tbxark. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = TestScene(fileNamed: "TestScene.sks")
        let skView = SKView.init(frame: view.bounds)
        view.addSubview(skView)
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene!.scaleMode = .aspectFill
        skView.presentScene(scene)
    }
}

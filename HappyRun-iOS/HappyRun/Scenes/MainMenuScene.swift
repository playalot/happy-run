//
//  MainMenuScene.swift
//  HappyRun
//
//  Created by Guan Guan on 10/13/17.
//  Copyright © 2017 Tbxark. All rights reserved.
//

import Foundation
import SpriteKit

class MainMenuScene: SKScene {
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "MainMenu")
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(background)
    }
    
    func sceneTapped() {
        let gameScene = BaseGameScene(size: size)
        gameScene.scaleMode = scaleMode
        let reveal = SKTransition.doorsOpenVertical(withDuration: 1.5)
        view?.presentScene(gameScene, transition: reveal)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        sceneTapped()
    }
    
}

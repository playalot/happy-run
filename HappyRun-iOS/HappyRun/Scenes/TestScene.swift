//
//  TestScene.swift
//  HappyRun
//
//  Created by Tbxark on 13/10/2017.
//  Copyright © 2017 Tbxark. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit


class TestScene: BaseGameScene {
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        install(componentSystems: [GKComponentSystem(componentClass: SpriteCompoment.self),
                                   GKComponentSystem(componentClass: PlayerAnimationComponent.self)],
                gameStateMechine: GKStateMachine.init(states: [GKState]()))
    }
    
//    override func update(_ currentTime: TimeInterval) {
//        super.update(currentTime)
//        let deltaTime = currentTime - lastUpdateTimeInterval
//    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard touches.first != nil else { return }
        addPlayer(playerType: PlayerType.ninja)
    }
    
    func addPlayer(playerType: PlayerType) {
        let startPosition = CGPoint(x: -200, y: 500)
        let endPosition = CGPoint(x: 2048, y: 500)
        
        let entity = PlayerEntity(playerType: playerType)

        entity.animationComponent.requestAnimationState = .run
        let node = entity.spriteComponent.node
        node.position = startPosition
        node.run(SKAction.move(to: endPosition, duration: 5))
        addEntity(entity: entity)

    }
    
}


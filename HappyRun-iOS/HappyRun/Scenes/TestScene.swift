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
import SpriteUtils


class TestScene: BaseGameScene {
    
    let cameraNode = SKCameraNode()
    let backgroundNode = InfiniteBackground(imageNames: ["bg1_1", "bg1_2"])
    private var  playRect: CGRect = CGRect.zero
    
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        let maxAspectRatio: CGFloat = 16 / 9.0
        let playableHeight: CGFloat = size.width / maxAspectRatio
        let playableMargin: CGFloat = (size.height - playableHeight) / 2
        playRect = CGRect(x: 0, y: playableMargin, width: size.width, height: playableHeight)
        
        install(componentSystems: [GKComponentSystem(componentClass: SpriteComponent.self),
                                   GKComponentSystem(componentClass: PlayerAnimationComponent.self)],
                gameStateMechine: GKStateMachine(states: [GKState]()))
        
        addChild(cameraNode)
        camera = cameraNode
        cameraNode.run(SKAction.repeatForever(SKAction.move(by: CGVector(dx: 400.0, dy: 0), duration: 1)))
        cameraPosition = CGPoint.init(x: size.width/2, y: size.height/2)

         
//        let testBg = SKSpriteNode.init(imageNamed: "bg1_1")
//        testBg.anchorPoint = CGPoint.zero
//        addNode(node: testBg, toGameLayer: GameLayer.background)
        backgroundNode.moveToLayer(gameLayerNodes[GameLayer.background]!)
//        addNode(node: , toGameLayer: GameLayer.background)
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
//        let deltaTime = currentTime - lastUpdateTimeInterval
        backgroundNode.checkCameraOffset(offset: cameraRect.minX)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: gameLayerNodes[GameLayer.background]!)  else { return }
        addPlayer(playerType: PlayerType.ninja, atPoint: point)
    }
    
    func addPlayer(playerType: PlayerType, atPoint: CGPoint? = nil) {
        let entity = PlayerEntity(playerType: playerType)

        let r = entity.spriteComponent.node.size.width/2
        let startPosition = CGPoint(x: CGFloat.random(min: cameraRect.minX + r, max: cameraRect.maxX - r),
                                    y: CGFloat.random(min: cameraRect.minY + r, max: cameraRect.maxY - r))

        entity.animationComponent.requestAnimationState = .run
        let node = entity.spriteComponent.node
        node.position =  atPoint ?? startPosition
        node.run(SKAction.repeatForever(SKAction.moveBy(x: 420, y: 0, duration: 1)))
        addEntity(entity: entity)

    }
    
}


extension TestScene {
    var overlapAmount: CGFloat {
        if #available(iOS 10.0, *) {
            return 0
        } else {
            guard let view = self.view else {
                return 0
            }
            let scale = view.bounds.size.width / self.size.width
            let scaledHeight = self.size.height * scale
            let scaledOverlap = scaledHeight - view.bounds.size.height
            return scaledOverlap / scale
        }
        
        
    }
    var cameraPosition: CGPoint {
        get {
            return CGPoint(x: cameraNode.position.x, y: cameraNode.position.y + overlapAmount)
        }
        set(position) {
            cameraNode.position = CGPoint(x: position.x, y: position.y - overlapAmount)
        }
    }
    var cameraRect: CGRect {
        return CGRect(x: cameraPosition.x - (size.width / 2) + (size.width - playRect.width) / 2 ,
                      y: cameraPosition.y - (size.height / 2) + (size.height - playRect.height) / 2,
                      width: playRect.width,
                      height: playRect.height)
    }
}


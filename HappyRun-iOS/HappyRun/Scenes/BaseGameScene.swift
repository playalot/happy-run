//
//  BaseGameScene.swift
//  HappyRun
//
//  Created by Tbxark on 13/10/2017.
//  Copyright © 2017 Tbxark. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit


enum GameLayer: CGFloat {

    static let zDeltaForSprites: CGFloat = 10
    
    case background = -100
    case shadows = -50
    case sprites = 0
    case hud = 1000
    case overlay = 1100
    
    var nodeName: String {
        switch self {
        case .background: return "Background"
        case .shadows: return "Shadows"
        case .sprites: return "Sprites"
        case .hud: return "Hud"
        case .overlay: return "Overlay"
        }
    }
    
    static var allLayers: [GameLayer] = [.background, .shadows, .sprites, .hud, .overlay]
}



class BaseGameScene: SKScene {
    
    private(set) var gameStateMechine: GKStateMachine!
    private(set) var gameLayerNodes = [GameLayer: SKNode]()
    private(set) var entities = Set<GKEntity>()
    private(set) var componentSystems = [GKComponentSystem<GKComponent>]()
    private(set) var lastUpdateTimeInterval: TimeInterval = 0

    var viewSize: CGSize {
        return self.view!.frame.size
    }
    var sceneScale: CGFloat {
        let minScale = min(viewSize.width / self.size.width, viewSize.height / self.size.height)
        let maxScale = max(viewSize.width / self.size.width, viewSize.height / self.size.height)
        return sqrt(minScale / maxScale)
    }

    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        loadGameLayers()
    }
    
    private func loadGameLayers() {
        for gameLayer in GameLayer.allLayers {
            let foundNodes = self[gameLayer.nodeName]
            let layerNode = foundNodes.first!
            layerNode.zPosition = gameLayer.rawValue
            gameLayerNodes[gameLayer] = layerNode
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        guard view != nil else { return }
        let deltaTime = currentTime - lastUpdateTimeInterval
        lastUpdateTimeInterval = currentTime
        if isPaused { return }
        gameStateMechine.update(deltaTime: deltaTime)
        for componentSystem in componentSystems {
            componentSystem.update(deltaTime: deltaTime)
        }
    }

    
    final func install(componentSystems: [GKComponentSystem<GKComponent>], gameStateMechine: GKStateMachine) {
        self.componentSystems = componentSystems
        self.gameStateMechine = gameStateMechine
    }
    
    
    func addEntity(entity: GKEntity) {
        entities.insert(entity)
        for componentSystem in componentSystems {
            componentSystem.addComponent(foundIn: entity)
        }
        if let node = entity.component(ofType: SpriteComponent.self)?.node {
            addNode(node: node, toGameLayer: GameLayer.sprites)
            if let shadow = entity.component(ofType: ShadowComponent.self)?.node {
                addNode(node: shadow, toGameLayer: GameLayer.shadows)
                let xRange = SKRange(constantValue: shadow.position.x)
                let yRange = SKRange(constantValue: shadow.position.y)
                let c = SKConstraint.positionX(xRange, y: yRange)
                c.referenceNode = node
                shadow.constraints = [c]
            }
        }
        
    }
    func addNode(node: SKNode, toGameLayer: GameLayer) {
        gameLayerNodes[toGameLayer]!.addChild(node)
    }
}


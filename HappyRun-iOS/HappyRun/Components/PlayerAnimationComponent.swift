//
//  PlayerAnimationComponent.swift
//  HappyRun
//
//  Created by Tbxark on 13/10/2017.
//  Copyright © 2017 Tbxark. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit


enum PlayerAnimationState: String {
    case idle = "Idle"
    case walk = "Walk"
    case hit = "Hit"
    case dead = "Dead"
    case attacking = "Attacking"
    
    static let allStates: [PlayerAnimationState] = [.idle, .walk, .hit, .dead, .attacking]
}

struct PlayerAnimation {
    let animationStete: PlayerAnimationState
    let textures: [SKTexture]
    let repeatTextureForever: Bool
}

class PlayerAnimationComponent: BaseComponent {
    let node: SKSpriteNode
    private var animations: [PlayerAnimationState: PlayerAnimation]
    private(set) var currentAnimation: PlayerAnimation?
    var requestAnimationState: PlayerAnimationState?
    
    init(node: SKSpriteNode, textureSize: CGSize, animations: [PlayerAnimationState: PlayerAnimation]) {
        self.node = node
        self.animations = animations
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func runAnimationForAnimationState(_ state: PlayerAnimationState) {
        let key = "Animation"
        let timePerFrame = TimeInterval(1/30.0)
        if let c = currentAnimation, c.animationStete == state {
            return
        }
        guard let animation = animations[state] else { return }
        node.removeAction(forKey: key)
        var action = SKAction.animate(with: animation.textures, timePerFrame: timePerFrame)
        if animation.repeatTextureForever {
            action = SKAction.repeatForever(action)
        }
        node.run(action, withKey: key)
        currentAnimation = animation
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        if let state = requestAnimationState {
            runAnimationForAnimationState(state)
            requestAnimationState = nil
        }
    }
    
    
    static func animationFromAtlas(altas: SKTextureAtlas,
                                   withImageIdentifier identifier: String,
                                   forAnimationState state: PlayerAnimationState,
                                   repeatForever: Bool) -> PlayerAnimation {
        let texture = altas.textureNames
            .filter({ $0.hasPrefix("\(identifier)__")})
            .sorted()
            .map( { altas.textureNamed($0) } )
        
        return PlayerAnimation(animationStete: state, textures: texture, repeatTextureForever: repeatForever)
    }
    
    static func loadAnimation(textureAtlas: SKTextureAtlas, states: [PlayerAnimationState: Bool]) -> [PlayerAnimationState: PlayerAnimation] {
        var temp = [PlayerAnimationState: PlayerAnimation]()
        for (state, repeatFlag) in states {
            let animations = PlayerAnimationComponent.animationFromAtlas(altas: textureAtlas,
                                                                   withImageIdentifier: state.rawValue,
                                                                   forAnimationState: state,
                                                                   repeatForever: repeatFlag)
            if animations.textures.isEmpty { continue }
            temp[state] = animations
        }
        return temp
    }
    
}


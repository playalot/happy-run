//
//  PlayerEntity.swift
//  HappyRun
//
//  Created by Tbxark on 13/10/2017.
//  Copyright © 2017 Tbxark. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit


enum PlayerType: String {
    case ninja = "ninja"
}

class PlayerEntity: BaseEntity {
    let playerType: PlayerType!
    private(set) var spriteComponent: SpriteCompoment!
    private(set) var animationComponent: PlayerAnimationComponent!
    
    // 376 × 520

    init(playerType: PlayerType) {
        self.playerType = playerType
        super.init()
        let textureAtlas = SKTextureAtlas(named: playerType.rawValue)
        let defaultTexture = textureAtlas.textureNamed("Idle__000.png")
        let textureSize = CGSize(width: 376, height: 520)
        let animations = PlayerAnimationComponent.loadAnimation(textureAtlas: textureAtlas,
                                                          states: [PlayerAnimationState.dead : false,
                                                                   PlayerAnimationState.run : true,
                                                                   PlayerAnimationState.hit  : false])
        
        spriteComponent = SpriteCompoment(entity: self, texture: defaultTexture, size: textureSize)
        animationComponent = PlayerAnimationComponent(node: spriteComponent.node, textureSize: textureSize, animations: animations)
        addComponent(spriteComponent)
        addComponent(animationComponent)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

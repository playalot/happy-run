//
//  ShadowComponent.swift
//  HappyRun
//
//  Created by Tbxark on 13/10/2017.
//  Copyright © 2017 Tbxark. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class ShadowComponent: BaseComponent {
    let node: SKShapeNode
    init(size: CGSize, offset: CGPoint, color: SKColor) {
        node = SKShapeNode(ellipseOf: size)
        node.fillColor = color
        node.strokeColor = color
        node.alpha = 0.2
        node.position = offset
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

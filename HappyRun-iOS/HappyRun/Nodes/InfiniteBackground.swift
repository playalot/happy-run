//
//  InfiniteBackground.swift
//  HappyRun
//
//  Created by Tbxark on 13/10/2017.
//  Copyright © 2017 Tbxark. All rights reserved.
//

import UIKit
import SpriteKit


class InfiniteBackground {

    private var backgroundNodes: (current: SKSpriteNode, next: SKSpriteNode)

    init(imageNames: [String]) {
        let backgroundNodeBuilder: ([String]) -> SKSpriteNode = { sources in
            let main = SKSpriteNode()
            main.anchorPoint = CGPoint.zero
            main.name = "background"

            var last: SKSpriteNode?
            var width: CGFloat = 0
            var height: CGFloat = 0
            for s in sources {
                let bg = SKSpriteNode(imageNamed: s)
                bg.anchorPoint = CGPoint.zero
                let position =  CGPoint(x: last?.size.width ?? 0, y: 0)
                bg.position = position
                last = bg
                main.addChild(bg)
                width += bg.size.width
                height = max(height, bg.size.height)
            }

            main.size = CGSize(width: width, height: height)
            main.zPosition = -1
            return main
        }
        
        let c = backgroundNodeBuilder(imageNames)
        c.position = CGPoint(x: 0, y: 0)
        let n = backgroundNodeBuilder(imageNames)
        n.position = CGPoint(x: c.size.width, y: 0)

        backgroundNodes = (c, n)
    }

    
    func moveToLayer(_ layer: SKNode) {
        for bg in [backgroundNodes.current, backgroundNodes.next] {
            layer.addChild(bg)
        }
    }
    
    func checkCameraOffset(offset: CGFloat) {
        if backgroundNodes.current.position.x + backgroundNodes.current.size.width < offset {
            backgroundNodes.current.position.x = backgroundNodes.next.position.x + backgroundNodes.next.size.width
            let temp = backgroundNodes.next
            backgroundNodes.next = backgroundNodes.current
            backgroundNodes.current = temp
        }
    }
}


//
//  Castle.swift
//  MonsterWars
//
//  Created by Christopher Johnston on 07/11/2018.
//  Copyright © 2018 Razeware LLC. All rights reserved.
//
import SpriteKit
import GameplayKit

class Castle: GKEntity {
    
    init(imageName: String) {
        super.init()
        let spriteComponent = SpriteComponent(texture: SKTexture(imageNamed: imageName))
        addComponent(spriteComponent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

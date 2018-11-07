//
//  EntityManager.swift
//  MonsterWars
//
//  Created by Christopher Johnston on 07/11/2018.
//  Copyright © 2018 Razeware LLC. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class EntityManager {
    lazy var componentSystems: [GKComponentSystem] = {
        let castleSystem = GKComponentSystem(componentClass: CastleComponent.self)
        let moveSystem = GKComponentSystem(componentClass: MoveComponent.self)
        return [castleSystem, moveSystem]
    }()
    
    var entities = Set<GKEntity>()
    let scene: SKScene
    var toRemove = Set<GKEntity>()
    
    init(scene: SKScene) {
        self.scene = scene
    }
    
    func add(_ entity: GKEntity) {
        entities.insert(entity)
        
        if let spriteNode = entity.component(ofType: SpriteComponent.self)?.node {
            scene.addChild(spriteNode)
        }
        
        for componentSystem in componentSystems {
            componentSystem.addComponent(foundIn: entity)
        }
    }
    
    func remove(_ entity: GKEntity) {
        if let spriteNode = entity.component(ofType: SpriteComponent.self)?.node {
            spriteNode.removeFromParent()
        }
        
        entities.remove(entity)
        toRemove.insert(entity)
    }
    
    func update(_ deltaTime: CFTimeInterval) {
        for componentSystem in componentSystems {
            componentSystem.update(deltaTime: deltaTime)
        }
        
        for currentRemove in toRemove {
            for componentSystem in componentSystems {
                componentSystem.removeComponent(foundIn: currentRemove)
            }
        }
        toRemove.removeAll()
    }
    
    func castle(for team: Team) -> GKEntity? {
        for entity in entities {
            if let teamComponent = entity.component(ofType: TeamComponent.self),
                let _ = entity.component(ofType: CastleComponent.self) {
                if teamComponent.team == team {
                    return entity
                }
            }
        }
        return nil
    }
    
    func entities(for team: Team) -> [GKEntity] {
        return entities.compactMap { entity in
            if let teamComponent = entity.component(ofType: TeamComponent.self) {
                if teamComponent.team == team {
                    return entity
                }
            }
            return nil
        }
    }
    
    func moveComponents(for team: Team) -> [MoveComponent] {
        let entitiesToMove = entities(for: team)
        var moveComponents = [MoveComponent]()
        for entity in entitiesToMove {
            if let moveComponent = entity.component(ofType: MoveComponent.self) {
                moveComponents.append(moveComponent)
            }
        }
        return moveComponents
    }
    
    func spawn(team: Team, monster: GKEntity, cost: Int)
    {
        // Find the position of the team's castle component
        guard let teamEntity = castle(for: team),
            let teamCastleComponent = teamEntity.component(ofType: CastleComponent.self),
            let teamSpriteComponent = teamEntity.component(ofType: SpriteComponent.self) else {
                return
        }
        
        // Only spawn if the team has the requisite number of coins
        if teamCastleComponent.coins < cost {
            return
        }
        // Take out the coins, run a spawn sound
        teamCastleComponent.coins -= cost
        scene.run(SoundManager.sharedInstance.soundSpawn)
        
        // Spawn the monster near the team's castle
        if let spriteComponent = monster.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(
                x: teamSpriteComponent.node.position.x,
                y: CGFloat.random(min: scene.size.height * 0.25, max: scene.size.height * 0.75)
            )
            spriteComponent.node.zPosition = 2
        }
        add(monster)
    }
    
    func spawnZap(team: Team) {
        let monster = Zap(team: team, entityManager: self)
        self.spawn(team: team, monster: monster, cost: costZap)
    }
    
    func spawnQuirk(team: Team) {
        // Create the Quirk entity and spawn it near the team's castle
        let monster = Quirk(team: team, entityManager: self)
        self.spawn(team: team, monster: monster, cost: costQuirk)
    }
    
    func spawnMunch(team: Team) {
        let monster = Munch(team: team, entityManager: self)
        self.spawn(team: team, monster: monster, cost: costMunch)
    }
}

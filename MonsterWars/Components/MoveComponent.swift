//
//  MoveComponent.swift
//  MonsterWars
//
//  Created by Christopher Johnston on 07/11/2018.
//  Copyright © 2018 Razeware LLC. All rights reserved.
//

import SpriteKit
import GameplayKit

class MoveComponent: GKAgent2D, GKAgentDelegate {
    let entityManager: EntityManager
    
    init(maxSpeed: Float, maxAcceleration: Float, radius: Float, entityManager: EntityManager) {
        self.entityManager = entityManager
        super.init()
        delegate = self
        self.maxSpeed = maxSpeed
        self.maxAcceleration = maxAcceleration
        self.radius = radius
        print(self.mass)
        self.mass = 0.01
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func agentWillUpdate(_ agent: GKAgent) {
        guard let spriteComponent = entity?.component(ofType: SpriteComponent.self) else {
            return
        }
        
        position = float2(spriteComponent.node.position)
    }
    
    func agentDidUpdate(_ agent: GKAgent) {
        guard let spriteComponent = entity?.component(ofType: SpriteComponent.self) else {
            return
        }
        
        spriteComponent.node.position = CGPoint(position)
    }
    
    func closestMoveComponent(for team: Team) -> GKAgent2D? {
        var closestMoveComponent : GKAgent2D? = nil
        var closestDistance = CGFloat(0)
        let enemyMoveComponents = entityManager.moveComponents(for: team)
        for enemyMoveComponent in enemyMoveComponents {
            let distance = (CGPoint(enemyMoveComponent.position) - CGPoint(position)).length()
            if closestMoveComponent == nil || distance < closestDistance {
                closestMoveComponent = enemyMoveComponent
                closestDistance = distance
            }
        }
        return closestMoveComponent
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        guard let entity = entity,
            let teamComponent = entity.component(ofType: TeamComponent.self) else {
            return
        }
        
        guard let enemyMoveComponent = closestMoveComponent(for: teamComponent.team.oppositeTeam()) else {
            return
        }
        
        let alliedMoveComponents = entityManager.moveComponents(for: teamComponent.team)
        
        behavior = MoveBehaviour(targetSpeed: maxSpeed, seek: enemyMoveComponent, avoid: alliedMoveComponents)
    }
}

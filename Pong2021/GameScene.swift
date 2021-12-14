//
//  GameScene.swift
//  Pong2021
//
//  Created by Christopher Walter on 12/14/21.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene
{
    
    override func didMove(to view: SKView)
    {
        // this is like viewdidLoad!!!!
        let borderBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        borderBody.friction = 0
        self.physicsBody = borderBody
        
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        
        
        
    }
}

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
    
    var theBall = SKNode()
    
    override func didMove(to view: SKView)
    {
        // this is like viewdidLoad!!!!
        
        theBall = self.childNode(withName: "theBall")!
        
        let borderBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        borderBody.friction = 0
        self.physicsBody = borderBody
        
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let location = touches.first?.location(in: self)
        print(location)
        
        theBall.physicsBody?.velocity = CGVector(dx: 0, dy: -1000)
        
        
//        makeNewBall(touchLocation: location!)
//        print(event)
        
        
    }
    
    func makeNewBall(touchLocation: CGPoint)
    {
        let ball = SKSpriteNode(color: UIColor.green, size: CGSize(width: 50, height: 50))
        ball.position = touchLocation
        addChild(ball)
        
        ball.physicsBody = SKPhysicsBody(circleOfRadius: 25)
        ball.physicsBody?.mass = 0.2
        ball.physicsBody?.restitution = 1.0
        ball.physicsBody?.affectedByGravity = false
        ball.physicsBody?.friction = 0
        ball.physicsBody?.allowsRotation = false
        ball.physicsBody?.velocity = CGVector(dx: 0, dy: 150)
        
    }
}

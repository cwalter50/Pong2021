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
    var paddle = SKSpriteNode()
    
    override func didMove(to view: SKView)
    {
        // this is like viewdidLoad!!!!
        paddle = self.childNode(withName: "paddle") as! SKSpriteNode
        theBall = self.childNode(withName: "theBall")!
        
        let borderBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        borderBody.friction = 0
        self.physicsBody = borderBody
        
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        
    }
    
    var isFingerOnPaddle = false
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let location = touches.first?.location(in: self)
        print(location)
        // figure out if you are touching paddle
        if paddle.contains(location!)
        {
            isFingerOnPaddle = true
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        // move paddle left or right with touch location
        let location = touches.first?.location(in: self)
        // figure out if you are touching paddle
        if isFingerOnPaddle == true
        {
            paddle.position = CGPoint(x: location!.x, y: paddle.position.y)
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        // remove finger off paddle
        isFingerOnPaddle = false
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

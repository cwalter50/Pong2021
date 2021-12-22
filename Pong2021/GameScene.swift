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
    var aiPaddle = SKSpriteNode()
    
    
    override func didMove(to view: SKView)
    {
        // this is like viewdidLoad!!!!
        paddle = self.childNode(withName: "paddle") as! SKSpriteNode
        theBall = self.childNode(withName: "theBall")!
        
        let borderBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        borderBody.friction = 0
        self.physicsBody = borderBody
        
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        
        createAIPaddle()

    }
    
    func createAIPaddle()
    {
        aiPaddle = SKSpriteNode(color: UIColor.green, size: CGSize(width: 200, height: 50))
        aiPaddle.position = CGPoint(x: frame.width/2, y: frame.height * 0.9)
        
        // add physics to the paddle
        aiPaddle.physicsBody = SKPhysicsBody(rectangleOf: aiPaddle.size)
        aiPaddle.physicsBody?.affectedByGravity = false
        aiPaddle.physicsBody?.friction = 0
        aiPaddle.physicsBody?.allowsRotation = false
        aiPaddle.physicsBody?.isDynamic = false
        
        addChild(aiPaddle)
        
        run(SKAction.repeatForever(SKAction.sequence([
            SKAction.run(followBall),
            SKAction.wait(forDuration: 0.4)
        ])))
        
    }
    
    func followBall()
    {
        let move = SKAction.moveTo(x: theBall.position.x, duration: 0.4)
        aiPaddle.run(move)
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

//
//  GameScene.swift
//  Pong2021
//
//  Created by Christopher Walter on 12/14/21.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate
{
    
    var theBall = SKNode()
    var paddle = SKSpriteNode()
    var aiPaddle = SKSpriteNode()
    var top = SKSpriteNode()
    var bottom = SKSpriteNode()
    
    var cpuScore = 0
    var myScore = 0
    var scoreLabel = SKLabelNode()
    
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
        createTopandBottom()
        setUpLabels()
        
        physicsWorld.contactDelegate = self
        
        theBall.physicsBody?.categoryBitMask = 1
        top.physicsBody?.categoryBitMask = 2
        bottom.physicsBody?.categoryBitMask = 3
        
        theBall.physicsBody?.contactTestBitMask = 2 | 3
        
        
    }
    
    func setUpLabels()
    {
        scoreLabel = SKLabelNode(fontNamed: "Arial")
        scoreLabel.text = "\(myScore) - \(cpuScore)"
        scoreLabel.position = CGPoint(x: frame.width * 0.90, y: frame.height * 0.5)
        scoreLabel.fontSize = 75
        scoreLabel.zRotation = CGFloat.pi / 2
        scoreLabel.fontColor = UIColor.black
        addChild(scoreLabel)
        
    }
    
    func updateScoreLabels()
    {
        scoreLabel.text = "\(myScore) - \(cpuScore)"
    }
    
    func didBegin(_ contact: SKPhysicsContact)
    {
        print(contact.contactPoint)
        
        if contact.bodyA.categoryBitMask == 1 && contact.bodyB.categoryBitMask == 2
        {
            print("ball hit top")
            myScore += 1
            resetBall()
        }
        if contact.bodyA.categoryBitMask == 2 && contact.bodyB.categoryBitMask == 1
        {
            print("ball hit top")
            myScore += 1
            resetBall()
        }
        if contact.bodyA.categoryBitMask == 1 && contact.bodyB.categoryBitMask == 3
        {
            print("ball hit bottom")
            cpuScore += 1
            resetBall()
        }
        if contact.bodyA.categoryBitMask == 3 && contact.bodyB.categoryBitMask == 1
        {
            print("ball hit bottom")
            cpuScore += 1
            resetBall()
        }
        updateScoreLabels()
        print("MyScore: \(myScore) CPUScore: \(cpuScore)")
    }
    
    func resetBall()
    {
        theBall.physicsBody?.velocity = .zero // stop ball
        let wait = SKAction.wait(forDuration: 1.0) // make the delay
        let sequence = SKAction.sequence([wait, SKAction.run(bringBallToCenter), wait, SKAction.run(pushBall)])
        run(sequence)
    }
    
    func bringBallToCenter()
    {
        theBall.position = CGPoint(x: frame.width/2, y: frame.height/2)
    }
    
    func pushBall()
    {
        var nums = [-200, 200]
        var randomx = nums.randomElement()!
        var randomy = nums.randomElement()!
        theBall.physicsBody?.applyImpulse(CGVector(dx: randomx, dy: randomy))
    }
    
    func createTopandBottom()
    {
        top = SKSpriteNode(color: .red, size: CGSize(width: frame.width, height: 50))
        top.position = CGPoint(x: frame.width / 2, y: frame.height)
        addChild(top)
        top.physicsBody = SKPhysicsBody(rectangleOf: top.frame.size)
        top.physicsBody?.isDynamic = false
        top.name = "top"
        
        bottom = SKSpriteNode(color: .red, size: CGSize(width: frame.width, height: 50))
        bottom.position = CGPoint(x: frame.width / 2, y: 0)
        addChild(bottom)
        bottom.physicsBody = SKPhysicsBody(rectangleOf: bottom.frame.size)
        bottom.physicsBody?.isDynamic = false
        bottom.name = "bottom"
        
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

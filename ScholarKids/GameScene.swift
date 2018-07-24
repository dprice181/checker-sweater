//
//  GameScene.swift
//  ScholarKids
//
//  Created by Doug Price on 5/18/18.
//  Copyright © 2018 Doug Price. All rights reserved.
//

import SpriteKit
import GameplayKit



class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    var viewController: GameViewController!
    
    override func didMove(to view: SKView) {        
        physicsWorld.gravity = .zero
                
        let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
        global.heightWidthRat = size.height/size.width
        
        let wordSelectScene = TitleScene(size: self.size,currentSentenceNum:0,correctAnswers:0,incorrectAnswers:0,currentExtraWordNum:0,sceneType:"Title")
        self.view?.presentScene(wordSelectScene, transition: reveal)
        
//        global.currentGrade = "1"
//        global.currentStudent = "Rachels"
//        let wordSelectScene = WordSelectScene(size: self.size,currentSentenceNum:0,correctAnswers:0,incorrectAnswers:0,currentExtraWordNum:0,sceneType:"Grammar")
//        self.view?.presentScene(wordSelectScene, transition: reveal)
        
        
        /*
        backgroundColor = SKColor.white

        //print(self.size.width,self.size.height)
        let message = "Select the noun from the sentence below"
        let label = SKLabelNode(fontNamed: "Arial")
        label.text = message
        label.fontSize = 20
        label.fontColor = SKColor.black
        label.position = CGPoint(x: self.size.width/2, y: self.size.height*2/3)
        addChild(label)
        
        
        
        var wordAr : [String] = ["The","dog","barked","very","loudly","at","night"]
        let sentLen = GetSentenceLength(wordAr:wordAr)
        
        var i = 0
        var curWordCount = 0
        for word in wordAr
        {
            let len = word.characters.count
            
            //let message2 = "The dog barked very loudly at night."
            //let label2 = SKLabelNode(fontNamed: "Arial")
            labelAr.append(SKLabelNode(fontNamed: "Arial"))
            labelAr[i].name = "word" + String(i)
            labelAr[i].text = word
            labelAr[i].fontSize = 20
            labelAr[i].fontColor = SKColor.blue
            labelAr[i].horizontalAlignmentMode = .left
            labelAr[i].position = CGPoint(x: 20.0 + CGFloat(curWordCount) * (size.width/38.0), y: self.size.height/3)
            addChild(labelAr[i])
            i = i + 1
            curWordCount = curWordCount + len + 1
        }
        */
        
        
        
        /*
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
        */
    }
    
        
    /*
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
 */
}

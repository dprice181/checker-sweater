//
//  TitleScene.swift
//  ScholarKids
//
//  Created by Doug Price on 5/24/18.
//  Copyright © 2018 Doug Price. All rights reserved.
//

import SpriteKit
import GameplayKit


class TitleScene: SKScene {
    
    var startButtonShadow : SKShapeNode = SKShapeNode()
    var startButton : SKShapeNode = SKShapeNode()
    var optionsButtonShadow : SKShapeNode = SKShapeNode()
    var optionsButton : SKShapeNode = SKShapeNode()
    var startButtonLabel = SKLabelNode()
    var optionsButtonLabel = SKLabelNode()
    
    var background = SKSpriteNode(imageNamed: "background3.jpg")
    
    init(size: CGSize, currentSentenceNum:Int, correctAnswers:Int, incorrectAnswers:Int, currentExtraWordNum:Int,sceneType:String) {
        super.init(size: size)
        physicsWorld.gravity = .zero
        
        backgroundColor = SKColor(red: 234/255, green: 230/255, blue: 236/255, alpha: 1)
        
        let fullTitle = SKNode()
        fullTitle.position = CGPoint(x: self.size.width/2, y: self.size.height*2/3)
        fullTitle.zPosition = 100.0
        
        let labelTitle = SKLabelNode(fontNamed: "ChalkDuster")
        labelTitle.text = "Scholar"
        labelTitle.fontSize = 60
        labelTitle.fontColor = SKColor.red
        labelTitle.position = .zero
        labelTitle.zPosition = 100.0
        fullTitle.addChild(labelTitle)
        
        let labelSubtitle = SKLabelNode(fontNamed: "ChalkDuster")
        labelSubtitle.text = "Kids"
        labelSubtitle.fontSize = 60
        labelSubtitle.fontColor = SKColor.red
        labelSubtitle.position = CGPoint(x: 0, y: -self.size.height/12)
        labelSubtitle.zPosition = 100.0
        fullTitle.addChild(labelSubtitle)
        
        addChild(fullTitle)
        
        startButtonShadow = SKShapeNode(rectOf: CGSize(width: self.size.width/2,height: self.size.height*4/48),cornerRadius: 30.0)
        startButtonShadow.name = "sbshadow"
        startButtonShadow.fillColor = SKColor.black
        startButtonShadow.strokeColor = SKColor.black
        startButtonShadow.position = CGPoint(x: self.size.width/2 - 2, y: self.size.height*10/24 + 2)
        addChild(startButtonShadow)
        
        startButton = SKShapeNode(rectOf: CGSize(width: self.size.width/2,height: self.size.height*4/48),cornerRadius: 30.0)
        startButton.name = "startbutton"
        startButton.fillColor = SKColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        startButton.strokeColor = SKColor.red
        startButton.position = CGPoint(x: self.size.width/2, y: self.size.height*10/24)
        addChild(startButton)
        
        startButtonLabel = SKLabelNode(fontNamed: "Arial")
        startButtonLabel.text = "START"
        startButtonLabel.name = "startbuttonlabel"
        startButtonLabel.fontSize = 30
        startButtonLabel.fontColor = SKColor.blue
        startButtonLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*10/24 - self.size.height/96)
        startButtonLabel.zPosition = 100.0
        addChild(startButtonLabel)
        
        optionsButtonShadow = SKShapeNode(rectOf: CGSize(width: self.size.width/2,height: self.size.height*4/48),cornerRadius: 30.0)
        optionsButtonShadow.name = "obshadow"
        optionsButtonShadow.fillColor = SKColor.black
        optionsButtonShadow.strokeColor = SKColor.black
        optionsButtonShadow.position = CGPoint(x: self.size.width/2 - 2, y: self.size.height*7/24 + 2)
        addChild(optionsButtonShadow)
        
        optionsButton = SKShapeNode(rectOf: CGSize(width: self.size.width/2,height: self.size.height*4/48),cornerRadius: 30.0)
        optionsButton.name = "optionsbutton"
        optionsButton.fillColor = SKColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        optionsButton.strokeColor = SKColor.red
        optionsButton.position = CGPoint(x: self.size.width/2, y: self.size.height*7/24)
        addChild(optionsButton)
        
        optionsButtonLabel = SKLabelNode(fontNamed: "Arial")
        optionsButtonLabel.text = "OPTIONS"
        optionsButtonLabel.name = "optionsbuttonlabel"
        optionsButtonLabel.fontSize = 30
        optionsButtonLabel.fontColor = SKColor.blue
        optionsButtonLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*7/24 - self.size.height/96)
        optionsButtonLabel.zPosition = 100.0
        addChild(optionsButtonLabel)
        
        background.position = CGPoint(x: frame.size.width / 2, y: self.size.width/5)
        background.scale(to: CGSize(width: self.size.width*1.1, height: self.size.width/2.4))
        addChild(background)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func TransitionSceneStart()
    {
        let playSound = SKAction.playSoundFileNamed("Correct-answer.mp3", waitForCompletion: false)
        
        let newScene = SKAction.run({
            let reveal = SKTransition.reveal(with:SKTransitionDirection.left, duration:1.0)
            
            let nextScene = PlayerSelectScene(size: self.size,currentSentenceNum:0,correctAnswers:0,incorrectAnswers:0,currentExtraWordNum:0,sceneType:"playerselect")
            self.view?.presentScene(nextScene, transition: reveal)
        
        })
        self.run(SKAction.sequence([playSound,newScene]))
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        let touchLocation = touch.location(in: self)
        let touchedNode = self.atPoint(touchLocation)
        
        if let shapeNode = touchedNode as? SKNode {
            if shapeNode.name?.contains("startbutton") != nil && (shapeNode.name?.contains("startbutton"))!  {
                startButtonShadow.isHidden = true
            }
            else {
                startButtonShadow.isHidden = false
            }
            if shapeNode.name?.contains("optionsbutton") != nil && (shapeNode.name?.contains("optionsbutton"))!  {
                optionsButtonShadow.isHidden = true
            }
            else {
                optionsButtonShadow.isHidden = false
            }
        }
        else {
            startButtonShadow.isHidden = false
            optionsButtonShadow.isHidden = false
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        
        let touchLocation = touch.location(in: self)
        let touchedNode = self.atPoint(touchLocation)
        
        if let shapeNode = touchedNode as? SKNode {
            if shapeNode.name?.contains("startbutton") != nil && (shapeNode.name?.contains("startbutton"))!  {
                startButtonShadow.isHidden = true
            }
            else {
                startButtonShadow.isHidden = false
            }
            if shapeNode.name?.contains("optionsbutton") != nil && (shapeNode.name?.contains("optionsbutton"))!  {
                optionsButtonShadow.isHidden = true
            }
            else {
                optionsButtonShadow.isHidden = false
            }
        }
        else {
            startButtonShadow.isHidden = false
            optionsButtonShadow.isHidden = false
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 1 - Choose one of the touches to work with
        guard let touch = touches.first else {
            return
        }
        
        let touchLocation = touch.location(in: self)
        let touchedNode = self.atPoint(touchLocation)
       
        startButtonShadow.isHidden = false
        optionsButtonShadow.isHidden = false
        
        if let shapeNode = touchedNode as? SKNode {
            if shapeNode.name?.contains("startbutton") != nil && (shapeNode.name?.contains("startbutton"))!  {
                TransitionSceneStart()
            }
            if shapeNode.name?.contains("optionsbutton") != nil && (shapeNode.name?.contains("optionsbutton"))!  {
                
            }
            
        }
    }
}

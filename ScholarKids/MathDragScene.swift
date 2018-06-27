//
//  MathDragScene.swift
//  ScholarKids
//
//  Created by Doug Price on 6/17/18.
//  Copyright © 2018 Doug Price. All rights reserved.
//

import SpriteKit
import GameplayKit

class MathDragScene: SKScene {
    
    var currentExtraWordNum = 0
    var sceneType = ""
    
    let labelTitle = SKLabelNode(fontNamed: "MarkerFelt-Thin")
    let labelSubtitle = SKLabelNode(fontNamed: "MarkerFelt-Thin")
    let labelInstr = SKLabelNode(fontNamed: "Arial")
    var labelInstrShadow = SKLabelNode(fontNamed: "Arial")
    let labelCorrect = SKLabelNode(fontNamed: "Arial")
    var labelCorrectShadow = SKLabelNode(fontNamed: "Arial")
    let labelIncorrect = SKLabelNode(fontNamed: "Arial")
    var labelIncorrectShadow = SKLabelNode(fontNamed: "Arial")
    let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
    
    
    init(size: CGSize, currentSentenceNum:Int, correctAnswers:Int, incorrectAnswers:Int, currentExtraWordNum:Int,sceneType:String) {
        super.init(size: size)
        
        global.currentStudent = "RACHEL"
        
        physicsWorld.gravity = .zero
        backgroundColor = SKColor(red: 234/255, green: 230/255, blue: 236/255, alpha: 1)
        
        global.currentSentenceNum = currentSentenceNum
        global.correctAnswers = correctAnswers
        global.incorrectAnswers = incorrectAnswers
        self.currentExtraWordNum = currentExtraWordNum
        self.sceneType = sceneType
        
        let fullTitle = SKNode()
        fullTitle.position = CGPoint(x: self.size.width/2, y: self.size.height*5/6)
        fullTitle.zPosition = 100.0
                
        labelTitle.text = "WORD PROBLEMS"
        labelTitle.fontSize = 45
        labelTitle.fontColor = SKColor.red
        labelTitle.position = .zero
        labelTitle.zPosition = 100.0
        fullTitle.addChild(labelTitle)
        let labelTitleShadow = CreateShadowLabel(label: labelTitle,offset: 1)
        fullTitle.addChild(labelTitleShadow)
        
        labelSubtitle.text = "Level " + String(global.currentLevel)
        labelSubtitle.fontSize = 40
        labelSubtitle.fontColor = SKColor.red
        labelSubtitle.position = CGPoint(x: 0, y: -self.size.height/18)
        labelSubtitle.zPosition = 100.0
        fullTitle.addChild(labelSubtitle)
        let labelSubtitleShadow = CreateShadowLabel(label: labelSubtitle,offset: 1)
        fullTitle.addChild(labelSubtitleShadow)
        addChild(fullTitle)
        
        
//        let labelWordProblem = SKLabelNode(fontNamed: "MarkerFelt-Thin")
//        labelWordProblem.text = "Alice"
//        labelWordProblem.fontSize = 30
//        labelWordProblem.fontColor = SKColor.blue
//        labelWordProblem.position = CGPoint(x: self.size.width/2, y: self.size.height*12/24)
//        labelWordProblem.zPosition = 100.0
//        addChild(labelWordProblem)
//        let labelWordProblemShadow = CreateShadowLabel(label: labelFirstName,offset: 1)
//        addChild(labelFirstNameShadow)
        
        
        let boxFirstName = SKShapeNode(rectOf: CGSize(width: self.size.width*9/10,height: self.size.height*12/48))
        boxFirstName.name = "boxfirstname"
        //boxFirstName.fillColor =
        boxFirstName.strokeColor = SKColor.blue
        boxFirstName.position = CGPoint(x: self.size.width/2, y: self.size.height*10/24)
        addChild(boxFirstName)
        
        let labelFirstName = SKLabelNode(fontNamed: "MarkerFelt-Thin")
        labelFirstName.text = "Alice"
        labelFirstName.fontSize = 30
        labelFirstName.fontColor = SKColor.blue
        labelFirstName.position = CGPoint(x: self.size.width/2, y: self.size.height*12/24)
        labelFirstName.zPosition = 100.0
        addChild(labelFirstName)
        let labelFirstNameShadow = CreateShadowLabel(label: labelFirstName,offset: 1)
        addChild(labelFirstNameShadow)
        
        let boxSecondName = SKShapeNode(rectOf: CGSize(width: self.size.width*9/10,height: self.size.height*12/48))
        boxSecondName.name = "boxsecondname"
        //boxFirstName.fillColor =
        boxSecondName.strokeColor = SKColor.red
        boxSecondName.position = CGPoint(x: self.size.width/2, y: self.size.height*4/24)
        addChild(boxSecondName)
        
        let labelSecondName = SKLabelNode(fontNamed: "MarkerFelt-Thin")
        labelSecondName.text = global.currentStudent
        labelSecondName.fontSize = 30
        labelSecondName.fontColor = SKColor.red
        labelSecondName.position = CGPoint(x: self.size.width/2, y: self.size.height*6/24)
        labelSecondName.zPosition = 100.0
        addChild(labelSecondName)
        let labelSecondNameShadow = CreateShadowLabel(label: labelSecondName,offset: 1)
        addChild(labelSecondNameShadow)
        
        
        
//        background.position = CGPoint(x: frame.size.width * 5 / 6, y: frame.size.height / 6)
//        background.scale(to: CGSize(width: self.size.width/3, height: self.size.height/3))
//        addChild(background)
        
        let backButton = SKSpriteNode(imageNamed: "BackwardsClean.png")
        backButton.name = "backbutton"
        backButton.position = CGPoint(x: frame.size.width/20, y: self.size.height*18.5/20)
        backButton.scale(to: CGSize(width: self.size.width/10, height: self.size.width/10))
        addChild(backButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 1 - Choose one of the touches to work with
        guard let touch = touches.first else {
            return
        }                
        
        let touchLocation = touch.location(in: self)
        let touchedNode = self.atPoint(touchLocation)
//        if let labelNode = touchedNode as? SKLabelNode {
//            if labelNode.name == "word"  {
//                var correctAnswerSelected = false
//                for correctAnswer in correctAnswerAr {
//                    if labelNode == labelAr[correctAnswer] {
//                        CorrectAnswerSelected()
//                        correctAnswerSelected = true
//                    }
//                }
//                if (correctAnswerSelected == false) {
//                    IncorrectAnswerSelected()
//                }
//            }
//        }
//        else
        if let shapeNode = touchedNode as? SKNode {
            if shapeNode.name?.contains("backbutton") != nil && (shapeNode.name?.contains("backbutton"))!  {
                TransitionBackFromScene(myScene: self)
            }
            if shapeNode.name?.contains("home") != nil && (shapeNode.name?.contains("home"))!  {
                TransitionBackFromScene(myScene: self)
            }
            if shapeNode.name?.contains("retry") != nil && (shapeNode.name?.contains("retry"))!  {
                let playSound = SKAction.playSoundFileNamed("QuizRight.wav", waitForCompletion: false)
                TransitionScene(playSound:playSound,duration:0.0)
            }
            if shapeNode.name?.contains("next") != nil && (shapeNode.name?.contains("next"))!  {
                global.currentLevel = global.currentLevel + 1
                let playSound = SKAction.playSoundFileNamed("QuizRight.wav", waitForCompletion: false)
                TransitionScene(playSound:playSound,duration:0.0)
            }
        }
    }
    
    func TransitionScene(playSound: SKAction,duration: TimeInterval)
    {
        for child in global.overlayNode.children {
            child.removeFromParent()
        }
        global.overlayNode.removeFromParent()
        global.currentSentenceNum = global.currentSentenceNum + 1
        
        let wait = SKAction.wait(forDuration: duration)
        
        let newScene = SKAction.run({
            let reveal = SKTransition.reveal(with:SKTransitionDirection.left, duration:1.0)
            if (global.currentSentenceNum % 6) < 3 {
                let nextScene = MathDrawScene(size: self.size,currentSentenceNum:global.currentSentenceNum,correctAnswers:global.correctAnswers,incorrectAnswers:global.incorrectAnswers,currentExtraWordNum:self.currentExtraWordNum,sceneType:self.sceneType)
                self.view?.presentScene(nextScene, transition: reveal)
            }
            else {
                let nextScene = MathDragScene(size: self.size,currentSentenceNum:global.currentSentenceNum,correctAnswers:global.correctAnswers,incorrectAnswers:global.incorrectAnswers,currentExtraWordNum:self.currentExtraWordNum,sceneType:self.sceneType)
                self.view?.presentScene(nextScene, transition: reveal)
            }
        })
        self.run(SKAction.sequence([playSound,wait,newScene]))
    }
}

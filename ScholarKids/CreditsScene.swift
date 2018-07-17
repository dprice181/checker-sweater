//
//  CreditsScene.swift
//  ScholarKids
//
//  Created by Doug Price on 7/16/18.
//  Copyright © 2018 Doug Price. All rights reserved.
//

import SpriteKit
import GameplayKit

class CreditsScene: SKScene {   
    init(size: CGSize, currentSentenceNum:Int, correctAnswers:Int, incorrectAnswers:Int, currentExtraWordNum:Int,sceneType:String) {
        super.init(size: size)
        
        backgroundColor = SKColor(red: 234/255, green: 230/255, blue: 236/255, alpha: 1)        
        DrawTitle()
        DrawCredits()
        DrawBackButton()
    }
    
    func DrawTitle() {
        let fullTitle = SKNode()
        fullTitle.position = CGPoint(x: self.size.width/2, y: self.size.height*36.5/40)
        fullTitle.zPosition = 100.0
        
        let labelTitle = SKLabelNode(fontNamed: "MarkerFelt-Thin")
        labelTitle.text = "CREDITS"
        labelTitle.fontSize = 50
        labelTitle.fontColor = SKColor.red
        labelTitle.position = .zero
        labelTitle.zPosition = 100.0
        fullTitle.addChild(labelTitle)
        let labelTitleShadow = CreateShadowLabel(label: labelTitle,offset: 1)
        fullTitle.addChild(labelTitleShadow)
        
        addChild(fullTitle)
    }
    
    func DrawCredits() {
        var creditAr = ["Programming","Graphics","Music"]
        var authorAr = ["Douglas Price","Julie Witzmann","Some Dude"]
        
        var offY : CGFloat = self.size.height*38/48
        let offYInc : CGFloat = self.size.height*10/48
        var offX : CGFloat = self.size.width*2/48
        for i in 0..<creditAr.count {
            let labelCredit = SKLabelNode(fontNamed: "Arial")
            labelCredit.text = creditAr[i]
            labelCredit.fontSize = 35
            labelCredit.horizontalAlignmentMode = .left
            labelCredit.fontColor = SKColor.blue
            labelCredit.position = CGPoint(x:offX,y:offY)
            labelCredit.zPosition = 100.0
            addChild(labelCredit)
            let labelCreditShadow = CreateShadowLabel(label: labelCredit,offset: 1)
            addChild(labelCreditShadow)
         
            let labelAuthor = SKLabelNode(fontNamed: "Arial")
            labelAuthor.text = authorAr[i]
            labelAuthor.fontSize = 30
            labelAuthor.horizontalAlignmentMode = .left
            labelAuthor.fontColor = global.realPurple
            labelAuthor.position = CGPoint(x:offX+self.size.width/32,y:offY - self.size.height*3/48)
            labelAuthor.zPosition = 100.0
            addChild(labelAuthor)
            let labelAuthorShadow = CreateShadowLabel(label: labelAuthor,offset: 1)
            addChild(labelAuthorShadow)
            
            offY = offY - offYInc
        }
    }
    
    func DrawBackButton() {
        let backButton = SKSpriteNode(imageNamed: "BackwardsClean.png")
        backButton.name = "backbutton"
        backButton.position = CGPoint(x: frame.size.width/20, y: self.size.height*19/20)
        backButton.scale(to: CGSize(width: self.size.width/10, height: self.size.width/10))
        addChild(backButton)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        let touchLocation = touch.location(in: self)
        let buttonNode = self.atPoint(touchLocation)
        
        if buttonNode.name?.contains("backbutton") != nil && (buttonNode.name?.contains("backbutton"))!  {
            TransitionBack()
        }
    }
    
    func TransitionBack()
    {
        for child in global.overlayNode.children {
            child.removeFromParent()
        }
        global.overlayNode.removeFromParent()
        let playSound = SKAction.playSoundFileNamed("QuizRight.wav", waitForCompletion: false)
        let newScene = SKAction.run({
            let reveal = SKTransition.reveal(with:SKTransitionDirection.left, duration:1.0)
            
            let nextScene = OptionsScene(size: self.size,currentSentenceNum:0,correctAnswers:0,incorrectAnswers:0,currentExtraWordNum:0,sceneType:"Options")
            self.view?.presentScene(nextScene, transition: reveal)
            
        })
        self.run(SKAction.sequence([playSound,newScene]))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

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
    
    var buttonBackground : SKShapeNode = SKShapeNode()
    var startButtonShadow : SKShapeNode = SKShapeNode()
    var startButton : SKShapeNode = SKShapeNode()
    var optionsButtonShadow : SKShapeNode = SKShapeNode()
    var optionsButton : SKShapeNode = SKShapeNode()
    var startButtonLabel = SKLabelNode()
    var optionsButtonLabel = SKLabelNode()
    var background = SKSpriteNode(imageNamed: "background3.jpg")
    
    var labelTitle = SKLabelNode()
    var labelTitleShadow = SKLabelNode()
    var labelSubtitle = SKLabelNode()
    var labelSubtitleShadow = SKLabelNode()
    let text1 = ["S", "c", "h", "o", "l", "a", "r"]
    let text2 = ["K", "i", "d", "s"]
    var titleLabelText = ""
    var subtitleLabelText = ""
    var calls : Int = 0
    var timer : Timer!

    init(size: CGSize, currentSentenceNum:Int, correctAnswers:Int, incorrectAnswers:Int, currentExtraWordNum:Int,sceneType:String) {
        super.init(size: size)
        physicsWorld.gravity = .zero
        
        backgroundColor = SKColor(red: 234/255, green: 230/255, blue: 236/255, alpha: 1)
        
        timer = Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(self.updateLabelText), userInfo: nil, repeats: true)
        
        ReadAndSetOptions()
        if global.musicOption < 2 && !global.musicStarted {
            let dictToSend: [String: String] = ["fileToPlay": "BackgroundMusic" ]
            NotificationCenter.default.post(name: Notification.Name(rawValue: "PlayBackgroundSound"), object: self, userInfo:dictToSend)            
        }
        
        DrawTitle()
        DrawButtons()
        
        if global.heightWidthRat < 1.5 {
            background.position = CGPoint(x: frame.size.width / 2, y: self.size.width/7.5)
        }
        else {
            background.position = CGPoint(x: frame.size.width / 2, y: self.size.width/5)
        }
        background.scale(to: CGSize(width: self.size.width*1.1, height: self.size.width/2.4))
        background.zPosition = -100
        addChild(background)
    }
    
    func ReadAndSetOptions() {
        CreateOptionsFileIfNecessary()
        ReadOptionsFile()
        UpdateOptions()
    }
    
    func DrawTitle() {
        let fullTitle = SKNode()
        fullTitle.position = CGPoint(x: self.size.width/2, y: self.size.height*3/4)
        fullTitle.zPosition = 100.0
        
        labelTitle = SKLabelNode(fontNamed: "MarkerFelt-Thin")
        labelTitle.text = titleLabelText
        labelTitle.fontSize = GetFontSize(size:80)
        labelTitle.fontColor = SKColor.red
        labelTitle.position = .zero
        labelTitle.zPosition = 100.0
        fullTitle.addChild(labelTitle)
        labelTitleShadow = CreateShadowLabel(label: labelTitle,offset: GetFontSize(size:2))
        fullTitle.addChild(labelTitleShadow)
        
        labelSubtitle = SKLabelNode(fontNamed: "MarkerFelt-Thin")
        labelTitle.text = subtitleLabelText
        labelSubtitle.fontSize = GetFontSize(size:80)
        labelSubtitle.fontColor = SKColor.red
        labelSubtitle.position = CGPoint(x: 0, y: -self.size.height/10)
        labelSubtitle.zPosition = 100.0
        fullTitle.addChild(labelSubtitle)
        labelSubtitleShadow = CreateShadowLabel(label: labelSubtitle,offset: GetFontSize(size:2))
        fullTitle.addChild(labelSubtitleShadow)
        addChild(fullTitle)
    }
    
    func DrawButtons() {
        var cornerSize :CGFloat = 20
        if global.heightWidthRat < 1.5 {
            cornerSize = 40
        }
        buttonBackground = SKShapeNode(rectOf: CGSize(width: self.size.width*3/4,height: self.size.height*16/48),cornerRadius: GetCornerSize(size:cornerSize,max:CGSize(width: self.size.width*3/4,height: self.size.height*16/48)))
        buttonBackground.name = "buttonbackground"
        buttonBackground.fillColor = SKColor(red: 200/255, green: 200/255, blue: 245/255, alpha: 0.6)
        buttonBackground.strokeColor = SKColor.purple
        buttonBackground.position = CGPoint(x: self.size.width/2, y: self.size.height*10/24)
        buttonBackground.zPosition = -1.0
        addChild(buttonBackground)
        
        var cornerSizeButton :CGFloat = 30
        if global.heightWidthRat < 1.5 {
            cornerSizeButton = 50
        }
        startButtonShadow = SKShapeNode(rectOf: CGSize(width: self.size.width/2,height: self.size.height*4/48),cornerRadius: GetCornerSize(size:cornerSizeButton,max:CGSize(width: self.size.width/2,height: self.size.height*4/48)))
        startButtonShadow.name = "sbshadow"
        startButtonShadow.fillColor = SKColor.black
        startButtonShadow.strokeColor = SKColor.black
        startButtonShadow.position = CGPoint(x: self.size.width/2 - GetFontSize(size:2.5), y: self.size.height*11.5/24 + GetFontSize(size:2.5))
        addChild(startButtonShadow)
        
        startButton = SKShapeNode(rectOf: CGSize(width: self.size.width/2,height: self.size.height*4/48),cornerRadius: GetCornerSize(size:cornerSizeButton,max:CGSize(width: self.size.width/2,height: self.size.height*4/48)))
        startButton.name = "startbutton"
        startButton.fillColor = SKColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        startButton.strokeColor = SKColor.purple
        startButton.position = CGPoint(x: self.size.width/2, y: self.size.height*11.5/24)
        addChild(startButton)
        
        startButtonLabel = SKLabelNode(fontNamed: "Arial")
        startButtonLabel.text = "START"
        startButtonLabel.name = "startbuttonlabel"
        startButtonLabel.fontSize = GetFontSize(size:30)
        startButtonLabel.fontColor = global.realPurple
        startButtonLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*11.3/24 - self.size.height/96)
        startButtonLabel.zPosition = 100.0
        addChild(startButtonLabel)
        addChild(CreateShadowLabel(label: startButtonLabel,offset: GetFontSize(size:1)))
        
        optionsButtonShadow = SKShapeNode(rectOf: CGSize(width: self.size.width/2,height: self.size.height*4/48),cornerRadius: GetCornerSize(size:cornerSizeButton,max:CGSize(width: self.size.width/2,height: self.size.height*4/48)))
        optionsButtonShadow.name = "obshadow"
        optionsButtonShadow.fillColor = SKColor.black
        optionsButtonShadow.strokeColor = SKColor.black
        optionsButtonShadow.position = CGPoint(x: self.size.width/2 - GetFontSize(size:2.5), y: self.size.height*8.5/24 + GetFontSize(size:2.5))
        addChild(optionsButtonShadow)
        
        optionsButton = SKShapeNode(rectOf: CGSize(width: self.size.width/2,height: self.size.height*4/48),cornerRadius: GetCornerSize(size:cornerSizeButton,max:CGSize(width: self.size.width/2,height: self.size.height*4/48)))
        optionsButton.name = "optionsbutton"
        optionsButton.fillColor = SKColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        optionsButton.strokeColor = SKColor.purple
        optionsButton.position = CGPoint(x: self.size.width/2, y: self.size.height*8.5/24)
        addChild(optionsButton)
        
        optionsButtonLabel = SKLabelNode(fontNamed: "Arial")
        optionsButtonLabel.text = "OPTIONS"
        optionsButtonLabel.name = "optionsbuttonlabel"
        optionsButtonLabel.fontSize = GetFontSize(size:30)
        optionsButtonLabel.fontColor = global.realPurple
        optionsButtonLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*8.3/24 - self.size.height/96)
        optionsButtonLabel.zPosition = 100.0
        addChild(optionsButtonLabel)
        addChild(CreateShadowLabel(label: optionsButtonLabel,offset: GetFontSize(size:1)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateLabelText() {
        if calls < text1.count {
            titleLabelText += text1[calls]
            labelTitle.text = titleLabelText
            labelTitleShadow.text = titleLabelText
            calls += 1
        }
        else if calls >= text1.count && calls < text1.count+text2.count {
            subtitleLabelText += text2[calls-text1.count]
            labelSubtitle.text = subtitleLabelText
            labelSubtitleShadow.text = subtitleLabelText
            calls += 1
        }
        else {
            timer.invalidate()
        }
    }
    
    func TransitionSceneStart() {
        var playSound = SKAction.playSoundFileNamed("QuizRight.wav", waitForCompletion: false)
        if global.soundOption == 2 {
            playSound = SKAction.wait(forDuration: 0.0001)
        }
        
        let newScene = SKAction.run({
            let reveal = SKTransition.reveal(with:SKTransitionDirection.left, duration:1.0)
            
            let nextScene = PlayerSelectScene(size: self.size,currentSentenceNum:0,correctAnswers:0,incorrectAnswers:0,currentExtraWordNum:0,sceneType:"PlayerSelect")
            self.view?.presentScene(nextScene, transition: reveal)
        })
        self.run(SKAction.sequence([playSound,newScene]))
    }
    
    func TransitionSceneOptions() {
        var playSound = SKAction.playSoundFileNamed("QuizRight.wav", waitForCompletion: false)
        if global.soundOption == 2 {
            playSound = SKAction.wait(forDuration: 0.0001)
        }
        
        let newScene = SKAction.run({
            let reveal = SKTransition.reveal(with:SKTransitionDirection.left, duration:1.0)
            
            let nextScene = OptionsScene(size: self.size,currentSentenceNum:0,correctAnswers:0,incorrectAnswers:0,currentExtraWordNum:0,sceneType:"Options")
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
                TransitionSceneOptions()
            }            
        }
    }
}

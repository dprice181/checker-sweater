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
    
    let SELECTTEXT_FONTSIZE : CGFloat = 17.0
    
    var currentExtraWordNum = 0
    
    let labelTitle = SKLabelNode(fontNamed: "MarkerFelt-Thin")
    let labelSubtitle = SKLabelNode(fontNamed: "MarkerFelt-Thin")
    let labelInstr = SKLabelNode(fontNamed: "Arial")
    var labelInstrShadow = SKLabelNode(fontNamed: "Arial")
    let labelCorrect = SKLabelNode(fontNamed: "Arial")
    var labelCorrectShadow = SKLabelNode(fontNamed: "Arial")
    let labelIncorrect = SKLabelNode(fontNamed: "Arial")
    var labelIncorrectShadow = SKLabelNode(fontNamed: "Arial")
    let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
    var wordAr : [String] = []
    
    let labelCountFirstName = SKLabelNode(fontNamed: "MarkerFelt-Thin")
    let labelCount2FirstName = SKLabelNode(fontNamed: "MarkerFelt-Thin")
    
    var labelCountFirstNameShadow = SKLabelNode(fontNamed: "MarkerFelt-Thin")
    var labelCount2FirstNameShadow = SKLabelNode(fontNamed: "MarkerFelt-Thin")
    
    let labelCountSecondName = SKLabelNode(fontNamed: "MarkerFelt-Thin")
    let labelCount2SecondName = SKLabelNode(fontNamed: "MarkerFelt-Thin")
    
    var labelCountSecondNameShadow = SKLabelNode(fontNamed: "MarkerFelt-Thin")
    var labelCount2SecondNameShadow = SKLabelNode(fontNamed: "MarkerFelt-Thin")
    //var submitButtonShadow = SKShapeNode()
    var submitButtonShadow = SKSpriteNode()
    var labelTitleShadow = SKLabelNode()
    var labelSubtitleShadow = SKLabelNode()
    
    var sentence = ""
    var person1Answer = -1
    var person1Answer2 = -1
    var person2Answer = -1
    var person2Answer2 = -1
    var person3Answer = -1
    
    let NPCGenderAr = ["F","M","F","M","F","M","F","M"]
    let NPCAr = ["Alice","Bob","Susan","Gary","Deborah","Steve","Kathy","David"]
    let itemAr = ["cookies","pies","cakes","pencils","books"]
    
    var item = "cookies"
    var item2 = "pies"
    var person1 = "Alice"
    
    var A = -1
    var B = -1
    var X = 0
    var Y = 0
    var Z = -1
    var W = 0
    
    var itemNodeAr = [SKSpriteNode]()
    var selectedNode = SKSpriteNode()
    var itemTouched = false
    var boxFirstName = SKShapeNode()
    var boxSecondName = SKShapeNode()
    var labelWordProblemAr = [SKLabelNode]()
    var labelWordProblemShadowAr = [SKLabelNode]()
    var studentStartsWithGoods = false
    var answerSelected = false
    let nodeDefinition = SKNode()
    
    var startsWithThere : CGFloat = 0
    
    init(size: CGSize, currentSentenceNum:Int, correctAnswers:Int, incorrectAnswers:Int, currentExtraWordNum:Int,sceneType:String) {
        super.init(size: size)
        
        physicsWorld.gravity = .zero
        backgroundColor = SKColor(red: 234/255, green: 230/255, blue: 236/255, alpha: 1)
        
        self.currentExtraWordNum = currentExtraWordNum
        global.sceneType = sceneType
        
        GetSentence()
        
        DrawTitle()
        DrawSentence()
        DrawItems()
        DrawFirstBox()
        DrawSecondBox()
        DrawCorrectLabels()
        DrawSubmitButton()
        DrawBackButton(scene:self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func DrawTitle() {
        let fullTitle = SKNode()
        fullTitle.position = CGPoint(x: self.size.width/2, y: self.size.height*8.95/10)
        fullTitle.zPosition = 100.0
        
        labelTitle.text = "WORD PROBLEMS"
        labelTitle.fontSize = GetFontSize(size:37)
        labelTitle.fontColor = SKColor.red
        labelTitle.position = .zero
        labelTitle.zPosition = 100.0
        fullTitle.addChild(labelTitle)
        labelTitleShadow = CreateShadowLabel(label: labelTitle,offset: GetFontSize(size:1))
        fullTitle.addChild(labelTitleShadow)
        
        labelSubtitle.text = "Level " + String(global.currentLevel)
        labelSubtitle.fontSize = GetFontSize(size:36)
        labelSubtitle.fontColor = SKColor.red
        labelSubtitle.position = CGPoint(x: 0, y: -self.size.height/18)
        labelSubtitle.zPosition = 100.0
        fullTitle.addChild(labelSubtitle)
        labelSubtitleShadow = CreateShadowLabel(label: labelSubtitle,offset: GetFontSize(size:1))
        fullTitle.addChild(labelSubtitleShadow)
        addChild(fullTitle)
    }
    
    func DrawSubmitButton() {
        let submitButton = SKSpriteNode(imageNamed: "RedButtonSmall.png")
        submitButton.scale(to: CGSize(width: (self.size.width/5.5),height: (self.size.height*2.5/48)))
        submitButton.name = "submitbutton"
        submitButton.zPosition = 101.0
        submitButton.position = CGPoint(x: self.size.width*8.5/10, y: self.size.height*2.8/48)
        addChild(submitButton)
        
        submitButtonShadow = SKSpriteNode(imageNamed: "RedButtonSmallShadow.png")
        submitButtonShadow.scale(to: CGSize(width: (self.size.width/5.5),height: (self.size.height*2.5/48)))
        submitButtonShadow.name = "bshadow"
        submitButtonShadow.position = CGPoint(x: self.size.width*8.5/10-GetFontSize(size:1.5), y: self.size.height*2.8/48+GetFontSize(size:1.5))
        submitButtonShadow.zPosition = 100.0
        addChild(submitButtonShadow)
        
        let submitLabel = SKLabelNode(fontNamed: "Arial")
        submitLabel.name = "submitbutton"
        submitLabel.fontSize = GetFontSize(size:15)
        submitLabel.fontColor = SKColor.white
        submitLabel.zPosition = 102.0
        submitLabel.position = CGPoint(x: self.size.width*8.5/10, y: self.size.height*2.8/48 - self.size.height/96)
        submitLabel.text = "Submit"
        addChild(submitLabel)
        addChild(CreateShadowLabel(label: submitLabel,offset: GetFontSize(size:1)))
    }
    
    func DrawCorrectLabels() {
        let scoreNode = SKNode()
        scoreNode.position = CGPoint(x: self.size.width/7, y: size.height*2/48)
        scoreNode.zPosition = 100.0
        
        labelCorrect.text = "Correct : " + String(global.correctAnswers)
        labelCorrect.fontSize = GetFontSize(size:15)
        labelCorrect.fontColor = SKColor.red
        labelCorrect.position = CGPoint(x: 0, y: self.size.height/40)
        scoreNode.addChild(labelCorrect)
        labelCorrectShadow = CreateShadowLabel(label: labelCorrect,offset: GetFontSize(size:1))
        scoreNode.addChild(labelCorrectShadow)
        
        labelIncorrect.text = "Missed : " + String(global.incorrectAnswers)
        labelIncorrect.fontSize = GetFontSize(size:15)
        labelIncorrect.fontColor = SKColor.red
        labelIncorrect.position = .zero
        scoreNode.addChild(labelIncorrect)
        labelIncorrectShadow = CreateShadowLabel(label: labelIncorrect,offset: GetFontSize(size:1))
        scoreNode.addChild(labelIncorrectShadow)
        addChild(scoreNode)
    }
    
    func DrawFirstBox() {
        boxFirstName = SKShapeNode(rectOf: CGSize(width: self.size.width*9/10,height: self.size.height*11/48))
        boxFirstName.name = "boxfirstname"
        boxFirstName.strokeColor = SKColor.blue
        boxFirstName.position = CGPoint(x: self.size.width/2, y: self.size.height*21/48)
        addChild(boxFirstName)
        
        let boxSmallFirstName = SKShapeNode(rectOf: CGSize(width: self.size.width*7/48,height: self.size.height*5.5/48))
        boxSmallFirstName.name = "boxfirstname"
        boxSmallFirstName.strokeColor = SKColor.blue
        boxSmallFirstName.position = CGPoint(x: self.size.width*21/24, y: self.size.height*18.25/48)
        addChild(boxSmallFirstName)
        
        if studentStartsWithGoods {
            labelCountFirstName.text = "0"
        }
        else {
            labelCountFirstName.text = String(X)
        }
        labelCountFirstName.fontColor = SKColor.blue
        if Z > -1 || B > -1 {
            labelCountFirstName.position = CGPoint(x: self.size.width*21/24, y: self.size.height*19.5/48)
            labelCountFirstName.fontSize = GetFontSize(size:20)
        }
        else {
            labelCountFirstName.position = CGPoint(x: self.size.width*21/24, y: self.size.height*18.25/48)
            labelCountFirstName.fontSize = GetFontSize(size:30)
        }
        labelCountFirstName.zPosition = 100.0
        addChild(labelCountFirstName)
        labelCountFirstNameShadow = CreateShadowLabel(label: labelCountFirstName,offset: GetFontSize(size:1))
        addChild(labelCountFirstNameShadow)
        
        if Z > -1 || B > -1 {
            if Z > -1 {
                if studentStartsWithGoods {
                    labelCount2FirstName.text = "0"
                }
                else {
                    labelCount2FirstName.text = String(Z)
                }
            }
            else if B > -1 {
                labelCount2FirstName.text = "0"
            }
            labelCount2FirstName.fontSize = GetFontSize(size:20)
            labelCount2FirstName.fontColor = SKColor.blue
            labelCount2FirstName.position = CGPoint(x: self.size.width*21/24, y: self.size.height*17/48)
            labelCount2FirstName.zPosition = 100.0
            addChild(labelCount2FirstName)
            labelCount2FirstNameShadow = CreateShadowLabel(label: labelCount2FirstName,offset: GetFontSize(size:1))
            addChild(labelCount2FirstNameShadow)
        }
        
        let labelItemFirstName = SKLabelNode(fontNamed: "MarkerFelt-Thin")
        labelItemFirstName.text = item
        labelItemFirstName.fontColor = SKColor.blue
        if Z > -1 || B > -1 {
            labelItemFirstName.fontSize = GetFontSize(size:13)
            labelItemFirstName.position = CGPoint(x: self.size.width*21/24, y: self.size.height*18.5/48)
        }
        else {
            labelItemFirstName.fontSize = GetFontSize(size:15)
            labelItemFirstName.position = CGPoint(x: self.size.width*21/24, y: self.size.height*16.75/48)
        }
        labelItemFirstName.zPosition = 100.0
        addChild(labelItemFirstName)
        let labelItemFirstNameShadow = CreateShadowLabel(label: labelItemFirstName,offset: GetFontSize(size:1))
        addChild(labelItemFirstNameShadow)
        
        if Z > -1 || B > -1 {
            let labelItem2FirstName = SKLabelNode(fontNamed: "MarkerFelt-Thin")
            labelItem2FirstName.text = item2
            labelItem2FirstName.fontSize = GetFontSize(size:13)
            labelItem2FirstName.fontColor = SKColor.blue
            labelItem2FirstName.position = CGPoint(x: self.size.width*21/24, y: self.size.height*16/48)
            labelItem2FirstName.zPosition = 100.0
            addChild(labelItem2FirstName)
            let labelItem2FirstNameShadow = CreateShadowLabel(label: labelItem2FirstName,offset: GetFontSize(size:1))
            addChild(labelItem2FirstNameShadow)
        }
        
        let labelFirstName = SKLabelNode(fontNamed: "MarkerFelt-Thin")
        labelFirstName.text = person1
        labelFirstName.fontSize = GetFontSize(size:30)
        labelFirstName.fontColor = SKColor.blue
        labelFirstName.position = CGPoint(x: self.size.width/2, y: self.size.height*12.3/24)
        labelFirstName.zPosition = 100.0
        addChild(labelFirstName)
        let labelFirstNameShadow = CreateShadowLabel(label: labelFirstName,offset: GetFontSize(size:1))
        addChild(labelFirstNameShadow)
    }
    
    func DrawSecondBox() {
        boxSecondName = SKShapeNode(rectOf: CGSize(width: self.size.width*9/10,height: self.size.height*11/48))
        boxSecondName.name = "boxsecondname"
        boxSecondName.strokeColor = SKColor.red
        boxSecondName.position = CGPoint(x: self.size.width/2, y: self.size.height*10/48)
        addChild(boxSecondName)
        
        let boxSmallSecondName = SKShapeNode(rectOf: CGSize(width: self.size.width*7/48,height: self.size.height*5.5/48))
        boxSmallSecondName.name = "boxsecondname"
        boxSmallSecondName.strokeColor = SKColor.red
        boxSmallSecondName.position = CGPoint(x: self.size.width*21/24, y: self.size.height*7.25/48)
        addChild(boxSmallSecondName)
        
        if Z > -1 || B > -1 {
            labelCountSecondName.fontSize = GetFontSize(size:20)
            labelCountSecondName.position = CGPoint(x: self.size.width*21/24, y: self.size.height*8.5/48)
        }
        else {
            labelCountSecondName.fontSize = GetFontSize(size:30)
            labelCountSecondName.position = CGPoint(x: self.size.width*21/24, y: self.size.height*7.5/48)
        }
        if studentStartsWithGoods {
            labelCountSecondName.text = String(X)
        }
        else {
            labelCountSecondName.text = "0"
        }
        labelCountSecondName.fontColor = SKColor.red
        labelCountSecondName.zPosition = 100.0
        addChild(labelCountSecondName)
        labelCountSecondNameShadow = CreateShadowLabel(label: labelCountSecondName,offset: GetFontSize(size:1))
        addChild(labelCountSecondNameShadow)
        
        if Z > -1 || B > -1 {
            labelCount2SecondName.fontSize = GetFontSize(size:20)
            if Z > -1 {
                if studentStartsWithGoods {
                    labelCount2SecondName.text = String(Z)
                }
                else {
                    labelCount2SecondName.text = "0"
                }
            }
            else if B > -1 {
                labelCount2SecondName.text = "0"
            }
            labelCount2SecondName.fontColor = SKColor.red
            labelCount2SecondName.position = CGPoint(x: self.size.width*21/24, y: self.size.height*6/48)
            labelCount2SecondName.zPosition = 100.0
            addChild(labelCount2SecondName)
            labelCount2SecondNameShadow = CreateShadowLabel(label: labelCount2SecondName,offset: GetFontSize(size:1))
            addChild(labelCount2SecondNameShadow)
        }
        
        let labelItemSecondName = SKLabelNode(fontNamed: "MarkerFelt-Thin")
        labelItemSecondName.text = item
        labelItemSecondName.fontColor = SKColor.red
        if Z > -1 || B > -1 {
            labelItemSecondName.position = CGPoint(x: self.size.width*21/24, y: self.size.height*7.5/48)
            labelItemSecondName.fontSize = GetFontSize(size:13)
        }
        else {
            labelItemSecondName.position = CGPoint(x: self.size.width*21/24, y: self.size.height*5.75/48)
            labelItemSecondName.fontSize = GetFontSize(size:15)
        }
        labelItemSecondName.zPosition = 100.0
        
        addChild(labelItemSecondName)
        let labelItemSecondNameShadow = CreateShadowLabel(label: labelItemSecondName,offset: GetFontSize(size:1))
        addChild(labelItemSecondNameShadow)
        
        if Z > -1 || B > -1 {
            let labelItem2SecondName = SKLabelNode(fontNamed: "MarkerFelt-Thin")
            labelItem2SecondName.text = item2
            labelItem2SecondName.fontColor = SKColor.red
            labelItem2SecondName.position = CGPoint(x: self.size.width*21/24, y: self.size.height*5/48)
            labelItem2SecondName.zPosition = 100.0
            labelItem2SecondName.fontSize = GetFontSize(size:13)
            addChild(labelItem2SecondName)
            let labelItem2SecondNameShadow = CreateShadowLabel(label: labelItem2SecondName,offset: GetFontSize(size:1))
            addChild(labelItem2SecondNameShadow)
        }
        
        let labelSecondName = SKLabelNode(fontNamed: "MarkerFelt-Thin")
        labelSecondName.text = global.currentStudent
        labelSecondName.fontSize = GetFontSize(size:30)
        labelSecondName.fontColor = SKColor.red
        labelSecondName.position = CGPoint(x: self.size.width/2, y: self.size.height*6.8/24)
        labelSecondName.zPosition = 100.0
        addChild(labelSecondName)
        let labelSecondNameShadow = CreateShadowLabel(label: labelSecondName,offset: GetFontSize(size:1))
        addChild(labelSecondNameShadow)
    }
    
    func CheckAnswer() {
        let person1Ans_1 = Int(labelCountFirstName.text!)!
        let person2Ans_1 = Int(labelCountSecondName.text!)!
        var person1Ans_2 = -1
        var person2Ans_2 = -1
        if Z > -1 || B > -1 {
            person1Ans_2 = Int(labelCount2FirstName.text!)!
            person2Ans_2 = Int(labelCount2SecondName.text!)!
        }
        
        if person1Answer == person1Ans_1 && person2Answer == person2Ans_1 && person1Answer2 == person1Ans_2 && person2Answer2 == person2Ans_2{
            CorrectAnswerSelected()
        }
        else {
            IncorrectAnswerSelected()
        }
    }
    
    func RemoveLabels() {
        labelTitle.removeFromParent()
        labelTitleShadow.removeFromParent()
        labelSubtitle.removeFromParent()
        labelSubtitleShadow.removeFromParent()
    }
    
    func CorrectAnswerSelected() {
        answerSelected = true
        
        for label in labelWordProblemAr {
            label.removeFromParent()
        }
        for label in labelWordProblemShadowAr {
            label.removeFromParent()
        }
        labelWordProblemAr[0].position = CGPoint(x: self.size.width/2, y: self.size.height*18/24)
        labelWordProblemAr[0].text = "Answer Is Correct!"
        labelWordProblemAr[0].fontColor = global.blue
        labelWordProblemAr[0].fontSize = GetFontSize(size:30)
        addChild(labelWordProblemAr[0])
        
        labelWordProblemShadowAr[0].position = CGPoint(x: self.size.width/2-1, y: self.size.height*18/24+1)
        labelWordProblemShadowAr[0].text = "Answer Is Correct!"
        labelWordProblemShadowAr[0].fontColor = SKColor.black
        labelWordProblemShadowAr[0].fontSize = GetFontSize(size:30)
        addChild(labelWordProblemShadowAr[0])
        
        global.correctAnswers = global.correctAnswers + 1
        labelCorrect.text = "Correct : " + String(global.correctAnswers)
        labelCorrectShadow.text = "Correct : " + String(global.correctAnswers)
        
        if global.correctAnswers + global.incorrectAnswers >= 12 {
            answerSelected = false  //let them touch the screen again
            DisplayLevelFinished(scene:self)
        }
        else {
            var playSound = SKAction.playSoundFileNamed("QuizRight.wav", waitForCompletion: false)
            if global.soundOption > 0 {
                playSound = SKAction.wait(forDuration: 0.0001)
            }
            TransitionScene(playSound:playSound,duration:1.5)
        }
    }
    
    func IncorrectAnswerSelected() {
        answerSelected = true
        
        for label in labelWordProblemAr {
            label.removeFromParent()
        }
        for label in labelWordProblemShadowAr {
            label.removeFromParent()
        }
        labelWordProblemAr[0].position = CGPoint(x: self.size.width/2, y: self.size.height*18/24)
        labelWordProblemAr[0].text = "Answer Is Incorrect!"
        labelWordProblemAr[0].fontColor = SKColor.red
        labelWordProblemAr[0].fontSize = GetFontSize(size:30)
        addChild(labelWordProblemAr[0])
        
        labelWordProblemShadowAr[0].position = CGPoint(x: self.size.width/2-1, y: self.size.height*18/24+1)
        labelWordProblemShadowAr[0].text = "Answer Is Incorrect!"
        labelWordProblemShadowAr[0].fontColor = SKColor.black
        labelWordProblemShadowAr[0].fontSize = GetFontSize(size:30)
        addChild(labelWordProblemShadowAr[0])
        
        //set the correct answer
        labelCountFirstName.text = String(person1Answer)
        labelCountFirstNameShadow.text = String(person1Answer)
        labelCountSecondName.text = String(person2Answer)
        labelCountSecondNameShadow.text = String(person2Answer)
        labelCountFirstName.fontColor = global.realPurple
        labelCountSecondName.fontColor = global.realPurple
        if Z > -1 || B > -1 {
            labelCount2FirstName.text = String(person1Answer2)
            labelCount2FirstNameShadow.text = String(person1Answer2)
            labelCount2SecondName.text = String(person2Answer2)
            labelCount2SecondNameShadow.text = String(person2Answer2)
            labelCount2FirstName.fontColor = global.realPurple
            labelCount2SecondName.fontColor = global.realPurple
        }
        
        global.incorrectAnswers = global.incorrectAnswers + 1
        labelIncorrect.text = "Missed : " + String(global.incorrectAnswers)
        labelIncorrectShadow.text = "Missed : " + String(global.incorrectAnswers)
        
        if global.correctAnswers + global.incorrectAnswers >= 12 {
            answerSelected = false  //let them touch the screen again
            DisplayLevelFinished(scene:self)
        }
        else {
            var playSound = SKAction.playSoundFileNamed("QuizWrong.wav", waitForCompletion: false)
            if global.soundOption > 0 {
                playSound = SKAction.wait(forDuration: 0.0001)
            }
            TransitionScene(playSound:playSound,duration:4.0)
        }
    }
    
    func DrawItems() {
        var offX = [0.0,frame.size.width/8,-frame.size.width/8,0.0,frame.size.width/8,-frame.size.width/8,0.0,frame.size.width/8,-frame.size.width/8,frame.size.width/4,-frame.size.width/4,frame.size.width/4,
            -frame.size.width/4,frame.size.width/4,-frame.size.width/4]
        offX.append(-frame.size.width*3/8)
        offX.append(-frame.size.width*3/8)
        offX.append(frame.size.width*3/8)
        offX.append(-frame.size.width*3/8)
        offX.append(-frame.size.width*3/8)
        offX.append(frame.size.width*3/8)
        offX.append(-frame.size.width*2/8)
        offX.append(frame.size.width*2/8)
        
        offX.append(frame.size.width * -1.5/8)
        offX.append(frame.size.width * 1.5/8)
        offX.append(frame.size.width * -1.5/8)
        offX.append(frame.size.width * 1.5/8)
        offX.append(frame.size.width * -1.5/8)
        offX.append(frame.size.width * 1.5/8)
        
        offX.append(frame.size.width * -2.5/8)
        offX.append(frame.size.width * -1.5/8)
        offX.append(frame.size.width * -2.5/8)
        offX.append(frame.size.width * 2.5/8)
        offX.append(frame.size.width * -2.5/8)
        offX.append(frame.size.width * 2.5/8)
        
        var offY = [0,0,0,-frame.size.height/18,-frame.size.height/18,-frame.size.height/18,frame.size.height/18,frame.size.height/18,frame.size.height/18,0,0,-frame.size.height/18,-frame.size.height/18,frame.size.height/18]
        offY.append(frame.size.height/18)
        offY.append(0)
        offY.append(-frame.size.height/18)
        offY.append(frame.size.height/18)
        offY.append(frame.size.height/18)
        offY.append(frame.size.height*2/18)
        offY.append(frame.size.height*2/18)
        offY.append(frame.size.height*2/18)
        offY.append(frame.size.height*2/18)
        
        offY.append(0)
        offY.append(0)
        offY.append(-frame.size.height/18)
        offY.append(-frame.size.height/18)
        offY.append(frame.size.height/18)
        offY.append(frame.size.height/18)
        
        offY.append(0)
        offY.append(2*frame.size.height/18)
        offY.append(-frame.size.height/18)
        offY.append(2*frame.size.height/18)
        offY.append(frame.size.height/18)
        offY.append(frame.size.height/18)
        
        
        var offX2 = [0.0,frame.size.width/8,-frame.size.width/8,0.0,frame.size.width/8,-frame.size.width/8,0.0,frame.size.width/8,-frame.size.width/8,frame.size.width/4,-frame.size.width/4,frame.size.width/4,
                    -frame.size.width/4,frame.size.width/4,-frame.size.width/4]
        offX2.append(frame.size.width*3/8)
        offX2.append(frame.size.width*3/8)        
        offX2.append(-frame.size.width*3/8)
        offX2.append(-frame.size.width*3/8)
        offX2.append(frame.size.width*3/8)
        offX2.append(-frame.size.width*3/8)
        offX2.append(-frame.size.width*2.5/8)
        offX2.append(frame.size.width*2.5/8)
        offX2.append(-frame.size.width*1.5/8)
        offX2.append(frame.size.width*1.5/8)
        
        offX2.append(frame.size.width * -1.5/8)
        offX2.append(frame.size.width * 1.5/8)
        offX2.append(frame.size.width * -1.5/8)
        offX2.append(frame.size.width * 1.5/8)
        offX2.append(frame.size.width * -1.5/8)
        offX2.append(frame.size.width * 1.5/8)
        
        offX2.append(frame.size.width * -2.5/8)
        offX2.append(frame.size.width * -1.5/8)
        offX2.append(frame.size.width * -2.5/8)
        offX2.append(frame.size.width * 2.5/8)
        offX2.append(frame.size.width * -2.5/8)
        offX2.append(frame.size.width * 2.5/8)
        
        var offY2 = [0,0,0,-frame.size.height/18,-frame.size.height/18,-frame.size.height/18,frame.size.height/18,frame.size.height/18,frame.size.height/18,0,0,-frame.size.height/18,-frame.size.height/18,frame.size.height/18]
        offY2.append(frame.size.height/18)
        offY2.append(0)
        offY2.append(-frame.size.height/18)
        offY2.append(0)
        offY2.append(-frame.size.height/18)
        offY2.append(frame.size.height/18)
        offY2.append(frame.size.height/18)
        offY2.append(frame.size.height/18)
        offY2.append(frame.size.height/18)
        offY2.append(frame.size.height/18)
        offY2.append(frame.size.height/18)
        
        offY2.append(0)
        offY2.append(0)
        offY2.append(-frame.size.height/18)
        offY2.append(-frame.size.height/18)
        offY2.append(frame.size.height/18)
        offY2.append(frame.size.height/18)
        
        offY2.append(0)
        offY2.append(2*frame.size.height/18)
        offY2.append(-frame.size.height/18)
        offY2.append(2*frame.size.height/18)
        offY2.append(frame.size.height/18)
        offY2.append(frame.size.height/18)
        
        var offYStudent : CGFloat = 0
        if studentStartsWithGoods {
           offYStudent = -self.size.height*11.1/48
        }
        
        if A > 0 {
            for i in 0...A-1 {
                itemNodeAr.append(SKSpriteNode(imageNamed: item + ".png"))
                itemNodeAr[i].name = "item1"
                itemNodeAr[i].position = CGPoint(x: frame.size.width*0.498 + offX2[i%offX.count], y: self.size.height*15.5/24 + offY2[i%offY.count])
                if global.heightWidthRat < 1.5 {
                    itemNodeAr[i].scale(to: CGSize(width: self.size.width/14, height: self.size.width/14))
                }
                else {
                    itemNodeAr[i].scale(to: CGSize(width: self.size.width/10, height: self.size.width/10))
                }
                itemNodeAr[i].zPosition = 301
                addChild(itemNodeAr[i])
            }
        }
        if B > 0 {
            for i in A...A+B-1 {
                itemNodeAr.append(SKSpriteNode(imageNamed: item2 + ".png"))
                itemNodeAr[i].name = "item2"
                itemNodeAr[i].position = CGPoint(x: frame.size.width*0.498 + offX2[i%offX.count], y: self.size.height*15.5/24 + offY2[i%offY.count])
                if global.heightWidthRat < 1.5 {
                    itemNodeAr[i].scale(to: CGSize(width: self.size.width/14, height: self.size.width/14))
                }
                else {
                    itemNodeAr[i].scale(to: CGSize(width: self.size.width/10, height: self.size.width/10))
                }
                itemNodeAr[i].zPosition = 302
                addChild(itemNodeAr[i])
            }
        }
        if X > 0 {
            for i in 0...X-1 {
                itemNodeAr.append(SKSpriteNode(imageNamed: item + ".png"))
                itemNodeAr[i].name = "item1"
                itemNodeAr[i].position = CGPoint(x: frame.size.width*0.498 + offX[i%offX.count], y: self.size.height*9.9/24 + offY[i%offY.count]+offYStudent)
                if global.heightWidthRat < 1.5 {
                    itemNodeAr[i].scale(to: CGSize(width: self.size.width/14, height: self.size.width/14))
                }
                else {
                    itemNodeAr[i].scale(to: CGSize(width: self.size.width/10, height: self.size.width/10))
                }
                itemNodeAr[i].zPosition = 303
                addChild(itemNodeAr[i])
            }
        }
        if Z > 0 {
            for i in X...X+Z-1 {
                itemNodeAr.append(SKSpriteNode(imageNamed: item2 + ".png"))
                itemNodeAr[i].name = "item2"
                itemNodeAr[i].position = CGPoint(x: frame.size.width*0.498 + offX[i%offX.count], y: self.size.height*9.9/24 + offY[i%offY.count]+offYStudent)
                if global.heightWidthRat < 1.5 {
                    itemNodeAr[i].scale(to: CGSize(width: self.size.width/14, height: self.size.width/14))
                }
                else {
                    itemNodeAr[i].scale(to: CGSize(width: self.size.width/10, height: self.size.width/10))
                }
                itemNodeAr[i].zPosition = 304
                addChild(itemNodeAr[i])
            }
        }
    }
    
    func DrawDefinition(definition:String,i:Int,incorrectAnswer:Bool,pos:CGPoint) {
        let fontColor = global.blue
        let fontSize = SELECTTEXT_FONTSIZE
        let position = pos
        let displayWidth = size.width * 9.2 / 10
        let sizeSentence = GetTextSize(text:definition,fontSize:fontSize)
        let sentenceWidth = sizeSentence.width
        
        nodeDefinition.position = position
        nodeDefinition.zPosition = 100.0
        nodeDefinition.name = "choicenode" + String(i)
        
        if sentenceWidth < displayWidth {
            labelWordProblemAr.append(SKLabelNode(fontNamed: "Arial"))
            labelWordProblemAr.last!.text = sentence
            labelWordProblemAr.last!.fontSize = GetFontSize(size:fontSize)
            labelWordProblemAr.last!.fontColor = global.purple
            labelWordProblemAr.last!.position = position
            labelWordProblemAr.last!.zPosition = 100.0
            labelWordProblemAr.last!.name = "spellingdefinition"
            nodeDefinition.addChild(labelWordProblemAr.last!)
            labelWordProblemShadowAr.append(CreateShadowLabel(label: labelWordProblemAr.last!,offset: GetFontSize(size:1)))
            nodeDefinition.addChild(labelWordProblemShadowAr.last!)
        }
        else {  //multi-line definition
            var curX : CGFloat = 0
            var offY : CGFloat = 0
            let offset : CGFloat = GetDefinitionOffset(definition:definition,displayWidth:displayWidth,fontSize:fontSize,incorrectAnswer:incorrectAnswer)
            wordAr = definition.characters.split{$0 == " "}.map(String.init)
            var lineString = ""
            for word in wordAr {
                let sizeWord = GetTextSize(text:word + " ",fontSize:fontSize)
                if curX + sizeWord.width > displayWidth {
                    //next line
                    DrawDefinitionLine(definition:lineString,i:i,offY:offY+offset,fontColor:fontColor,fontSize:fontSize)
                    offY = offY - sizeWord.height
                    curX = 0
                    lineString = ""
                }
                
                if lineString == "" {
                    lineString = word
                }
                else {
                    lineString = lineString + " " + word
                }
                curX = curX + sizeWord.width
            }
            if lineString != "" {
                DrawDefinitionLine(definition:lineString,i:i,offY:offY+offset,fontColor:fontColor,fontSize:fontSize)
            }
        }
    }
    
    func GetDefinitionOffset(definition:String,displayWidth:CGFloat,fontSize:CGFloat,incorrectAnswer:Bool) -> CGFloat {
        var offset : CGFloat = 0
        var numLines = 1
        //get numLines
        var curX : CGFloat = 0
        wordAr = definition.characters.split{$0 == " "}.map(String.init)
        var sizeWord = GetTextSize(text:"best ",fontSize:fontSize)  //get line height
        for word in wordAr {
            sizeWord = GetTextSize(text:word + " ",fontSize:fontSize)
            if curX + sizeWord.width > displayWidth {
                //next line
                numLines = numLines + 1
                curX = 0
            }
            curX = curX + sizeWord.width
        }
        if numLines == 2 || (numLines==1 && incorrectAnswer) {
            offset = sizeWord.height * 0.4
        }
        if numLines == 3 {
            offset = sizeWord.height * 0.75
        }
        if numLines == 4 {
            offset = sizeWord.height * 8 / 7
        }
        if numLines == 5 {
            offset = sizeWord.height * 1.62
        }
        if numLines >= 6 {
            offset = sizeWord.height * 2.15
        }
        return offset
    }
    
    func DrawDefinitionLine(definition:String,i:Int,offY:CGFloat,fontColor:SKColor,fontSize:CGFloat) {
        labelWordProblemAr.append(SKLabelNode(fontNamed: "Arial"))
        labelWordProblemAr.last!.text = definition
        labelWordProblemAr.last!.fontSize = GetFontSize(size:fontSize)
        labelWordProblemAr.last!.fontColor = fontColor
        labelWordProblemAr.last!.position = CGPoint(x: 0,y: offY)
        labelWordProblemAr.last!.zPosition = 100.0
        labelWordProblemAr.last!.name = "spellingdefinition"
        nodeDefinition.addChild(labelWordProblemAr.last!)
        labelWordProblemShadowAr.append(CreateShadowLabel(label: labelWordProblemAr.last!,offset: GetFontSize(size:1)))
        nodeDefinition.addChild(labelWordProblemShadowAr.last!)
    }
    
    func DrawSentence() {
        DrawDefinition(definition:sentence,i:0,incorrectAnswer:false,pos:CGPoint(x: self.size.width/2, y: self.size.height*(17.7+startsWithThere)/24))
        addChild(nodeDefinition)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        let touchLocation = touch.location(in: self)
        let touchedNode = self.atPoint(touchLocation)
        
        if touchedNode.name?.contains("submitbutton") != nil && (touchedNode.name?.contains("submitbutton"))!  {
            submitButtonShadow.isHidden = true
        }
        
        if let shapeNode = touchedNode as? SKSpriteNode {
            if shapeNode.name?.contains("item") != nil && (shapeNode.name?.contains("item"))!  {
                selectedNode = shapeNode
                itemTouched = true
                if touchLocation.x > (boxFirstName.position.x-boxFirstName.frame.width/2) &&
                    touchLocation.x < (boxFirstName.position.x+boxFirstName.frame.width/2) &&
                    touchLocation.y > (boxFirstName.position.y-boxFirstName.frame.height/2) &&
                    touchLocation.y < (boxFirstName.position.y+boxFirstName.frame.height/2) {
                    
                    if shapeNode.name != nil && shapeNode.name!.last == "1" {
                        let newCount = String(Int(labelCountFirstName.text!)! - 1)
                        labelCountFirstName.text = newCount
                        labelCountFirstNameShadow.text = newCount
                    }
                    if shapeNode.name != nil && shapeNode.name!.last == "2" {
                        let newCount = String(Int(labelCount2FirstName.text!)! - 1)
                        labelCount2FirstName.text = newCount
                        labelCount2FirstNameShadow.text = newCount
                    }
                }
                if touchLocation.x > (boxSecondName.position.x-boxSecondName.frame.width/2) &&
                    touchLocation.x < (boxSecondName.position.x+boxSecondName.frame.width/2) &&
                    touchLocation.y > (boxSecondName.position.y-boxSecondName.frame.height/2) &&
                    touchLocation.y < (boxSecondName.position.y+boxSecondName.frame.height/2) {
                    
                    if shapeNode.name != nil && shapeNode.name!.last == "1" {
                        let newCount = String(Int(labelCountSecondName.text!)! - 1)
                        labelCountSecondName.text = newCount
                        labelCountSecondNameShadow.text = newCount
                    }
                    if shapeNode.name != nil && shapeNode.name!.last == "2" {
                        let newCount = String(Int(labelCount2SecondName.text!)! - 1)
                        labelCount2SecondName.text = newCount
                        labelCount2SecondNameShadow.text = newCount
                    }
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        let touchLocation = touch.location(in: self)
        let touchedNode = self.atPoint(touchLocation)
        
        if itemTouched == true {
            selectedNode.position = touchLocation
        }
        else {
            if touchedNode.name?.contains("submitbutton") != nil && (touchedNode.name?.contains("submitbutton"))!  {
                submitButtonShadow.isHidden = true
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        if answerSelected {
            return
        }
        
        let touchLocation = touch.location(in: self)
        let touchedNode = self.atPoint(touchLocation)
        
        submitButtonShadow.isHidden = false
        if touchedNode.name?.contains("submitbutton") != nil && (touchedNode.name?.contains("submitbutton"))!  {
            CheckAnswer()
        }
        
        if itemTouched == true {
            if touchLocation.x > (boxFirstName.position.x-boxFirstName.frame.width/2) &&
               touchLocation.x < (boxFirstName.position.x+boxFirstName.frame.width/2) &&
               touchLocation.y > (boxFirstName.position.y-boxFirstName.frame.height/2) &&
               touchLocation.y < (boxFirstName.position.y+boxFirstName.frame.height/2) {
                
                if selectedNode.name != nil && selectedNode.name!.last == "1" {
                    let newCount = String(Int(labelCountFirstName.text!)! + 1)
                    labelCountFirstName.text = newCount
                    labelCountFirstNameShadow.text = newCount
                }
                if selectedNode.name != nil && selectedNode.name!.last == "2" {
                    let newCount = String(Int(labelCount2FirstName.text!)! + 1)
                    labelCount2FirstName.text = newCount
                    labelCount2FirstNameShadow.text = newCount
                }
            }
            if touchLocation.x > (boxSecondName.position.x-boxSecondName.frame.width/2) &&
                touchLocation.x < (boxSecondName.position.x+boxSecondName.frame.width/2) &&
                touchLocation.y > (boxSecondName.position.y-boxSecondName.frame.height/2) &&
                touchLocation.y < (boxSecondName.position.y+boxSecondName.frame.height/2) {
                
                if selectedNode.name != nil && selectedNode.name!.last == "1" {
                    let newCount = String(Int(labelCountSecondName.text!)! + 1)
                    labelCountSecondName.text = newCount
                    labelCountSecondNameShadow.text = newCount
                }
                if selectedNode.name != nil && selectedNode.name!.last == "2" {
                    let newCount = String(Int(labelCount2SecondName.text!)! + 1)
                    labelCount2SecondName.text = newCount
                    labelCount2SecondNameShadow.text = newCount
                }
            }
        }
        selectedNode = SKSpriteNode()
        itemTouched = false
        
        if let shapeNode = touchedNode as? SKNode {
            if shapeNode.name?.contains("backbutton") != nil && (shapeNode.name?.contains("backbutton"))!  {
                TransitionBackFromScene(myScene: self)
            }
            if shapeNode.name?.contains("home") != nil && (shapeNode.name?.contains("home"))!  {
                TransitionBackFromScene(myScene: self)
            }
            if shapeNode.name?.contains("retry") != nil && (shapeNode.name?.contains("retry"))!  {
                global.currentSentenceNum = 12 * (global.currentLevel-1)
                var playSound = SKAction.playSoundFileNamed("QuizRight.wav", waitForCompletion: false)
                if global.soundOption > 0 {
                    playSound = SKAction.wait(forDuration: 0.0001)
                }
                TransitionScene(playSound:playSound,duration:0.0)
            }
            if shapeNode.name?.contains("next") != nil && (shapeNode.name?.contains("next"))!  {
                global.currentLevel = global.currentLevel + 1
                global.currentSentenceNum = 12 * (global.currentLevel-1)
                var playSound = SKAction.playSoundFileNamed("QuizRight.wav", waitForCompletion: false)
                if global.soundOption > 0 {
                    playSound = SKAction.wait(forDuration: 0.0001)
                }
                TransitionScene(playSound:playSound,duration:0.0)
            }
        }
    }
        
    func GetFilename() -> String {
        if let grade = Int(global.currentGrade) {
            if grade > 8 {
                return "WordProblems8"
            }
        }
        return "WordProblems" + global.currentGrade
    }
    
    func GetSentence() {
        if let path = Bundle.main.path(forResource: GetFilename(), ofType: "txt") {
            let fileText = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
            let lineAr = fileText.components(separatedBy: .newlines)
            global.wordProblemsNum = global.wordProblemsNum % lineAr.count
            if lineAr.count < global.wordProblemsNum {
                return
            }
            let sentenceAr = lineAr[global.wordProblemsNum].characters.split{$0 == "#"}.map(String.init)
            
            global.currentSentenceNum = (global.currentSentenceNum + 1) % lineAr.count  //wrap around at eof
            global.wordProblemsNum = (global.wordProblemsNum + 1) % lineAr.count  //wrap around at eof
            
            if sentenceAr.count < 3 {
                return
            }
            
            var rand = Int(arc4random_uniform(UInt32(NPCAr.count)))
            if NPCAr[rand] == global.currentStudent {
                rand = Int(arc4random_uniform(UInt32(NPCAr.count)))
            }
            if NPCAr[rand] == global.currentStudent {
                rand = Int(arc4random_uniform(UInt32(NPCAr.count)))
            }
            person1 = NPCAr[rand]
            let npcGender = NPCGenderAr[rand]
            
            let rand2 = Int(arc4random_uniform(UInt32(itemAr.count)))
            item = itemAr[rand2]
            
            var rand3 = Int(arc4random_uniform(UInt32(itemAr.count)))
            while (rand3==rand2) {
                rand3 = Int(arc4random_uniform(UInt32(itemAr.count)))
            }
            item2 = itemAr[rand3]
            
            sentence = sentenceAr[0]
            var maxItems = GetMaxItems()
            
            var maxItemsTop = maxItems
            if maxItemsTop > 18 {
                maxItemsTop = 18
            }
            let maxItemsTwoTop = 22
            let maxItemsTwo = 30
            
            var string = "\\A"
            if sentence.range(of:string) != nil {
                A = Int(arc4random_uniform(UInt32(maxItemsTop))+1)
                startsWithThere = 1.0
            }
            string = "\\B"
            if sentence.range(of:string) != nil {
                var maxB = maxItemsTop
                if A + maxItemsTop > maxItemsTwoTop {
                    maxB = maxItemsTwoTop - A
                }
                B = Int(arc4random_uniform(UInt32(maxB))+1)
                startsWithThere = 1.0
            }
            string = "\\V"
            var replaceVString = "\\V"
            if sentence.range(of:string) != nil {
                var maxB = maxItemsTop
                if A + maxItemsTop > maxItemsTwoTop {
                    maxB = maxItemsTwoTop - A
                }
                
                let range = sentence.range(of:string)
                let ind = sentence.index((range?.lowerBound)!, offsetBy: 2)
                if let multiplier = Int(String(sentence[ind])) {
                    B = ( Int(arc4random_uniform(UInt32(maxB))+2) / multiplier ) * multiplier
                    if B < multiplier {
                        B = multiplier
                    }
                }
                else {
                    B = ( Int(arc4random_uniform(UInt32(maxB))+2))
                }
                replaceVString = "\\V" + String(sentence[ind])
                startsWithThere = 1.0
            }
            string = "\\X"
            if sentence.range(of:string) != nil {
                X = Int(arc4random_uniform(UInt32(maxItems))+2)
            }
            string = "\\E"
            if sentence.range(of:string) != nil {
                X = ( Int(arc4random_uniform(UInt32(maxItems))+2) / 2 ) * 2
            }
            string = "\\M"
            var replaceMString = "\\M"
            if sentence.range(of:string) != nil {
                let range = sentence.range(of:string)
                let ind = sentence.index((range?.lowerBound)!, offsetBy: 2)
                if let multiplier = Int(String(sentence[ind])) {
                    X = ( Int(arc4random_uniform(UInt32(maxItems))+2) / multiplier ) * multiplier
                    if X < multiplier {
                        X = multiplier
                    }
                }
                else {
                    X = ( Int(arc4random_uniform(UInt32(maxItems))+2))
                }
                replaceMString = "\\M" + String(sentence[ind])
            }
            string = "\\Q"
            var replaceQString = "\\Q"
            if sentence.range(of:string) != nil {
                let range = sentence.range(of:string)
                let ind = sentence.index((range?.lowerBound)!, offsetBy: 2)
                if let multiplier = Int(String(sentence[ind])) {
                    A = ( Int(arc4random_uniform(UInt32(maxItemsTop))+2) / multiplier ) * multiplier
                    if A < multiplier {
                        A = multiplier
                    }
                }
                else {
                    A = ( Int(arc4random_uniform(UInt32(maxItemsTop))+2))
                }
                replaceQString = "\\Q" + String(sentence[ind])
                startsWithThere = 1.0
            }
            string = "\\Y"
            if sentence.range(of:string) != nil {
                if A > -1 {
                    Y = Int(arc4random_uniform(UInt32(A))+1)
                }
                else {
                    Y = Int(arc4random_uniform(UInt32(X))+1)
                }
            }
            string = "\\Z"
            if sentence.range(of:string) != nil {
                var maxZ = maxItems
                if X + maxItems > maxItemsTwo {
                    maxZ = maxItemsTwo - X
                }
                Z = Int(arc4random_uniform(UInt32(maxZ))+1)
            }
            string = "\\R"
            var replaceRString = "\\R"
            if sentence.range(of:string) != nil {
                var maxZ = maxItems
                if X + maxItems > maxItemsTwo {
                    maxZ = maxItemsTwo - X
                }
                
                let range = sentence.range(of:string)
                let ind = sentence.index((range?.lowerBound)!, offsetBy: 2)
                if let multiplier = Int(String(sentence[ind])) {
                    Z = ( Int(arc4random_uniform(UInt32(maxZ))+2) / multiplier ) * multiplier
                    if Z < multiplier {
                        Z = multiplier
                    }
                }
                else {
                    Z = ( Int(arc4random_uniform(UInt32(maxItems))+2))
                }
                replaceRString = "\\R" + String(sentence[ind])
            }
            string = "\\W"
            if sentence.range(of:string) != nil {
                if B > -1 {
                    W = Int(arc4random_uniform(UInt32(B))+1)
                }
                else {
                    W = Int(arc4random_uniform(UInt32(Z))+1)
                }
            }
            
            studentStartsWithGoods = IsStudentFirst(sentence:sentence)
            ReplaceSentenceKeywords(sentence:&sentence,replaceMString:replaceMString,replaceQString:replaceQString,
                                    replaceRString:replaceRString,replaceVString:replaceVString,npcGender:npcGender)
            
            var ansString = sentenceAr[1]
            ansString = ansString.replacingOccurrences(of: "\\A", with: String(A))
            ansString = ansString.replacingOccurrences(of: "\\B", with: String(B))
            ansString = ansString.replacingOccurrences(of: "\\E", with: String(X))
            ansString = ansString.replacingOccurrences(of: replaceMString, with: String(X))
            ansString = ansString.replacingOccurrences(of: replaceQString, with: String(A))
            ansString = ansString.replacingOccurrences(of: replaceRString, with: String(Z))
            ansString = ansString.replacingOccurrences(of: replaceVString, with: String(B))
            ansString = ansString.replacingOccurrences(of: "\\X", with: String(X))
            ansString = ansString.replacingOccurrences(of: "\\Y", with: String(Y))
            ansString = ansString.replacingOccurrences(of: "\\Z", with: String(Z))
            ansString = ansString.replacingOccurrences(of: "\\W", with: String(W))
            var exp = NSExpression(format: ansString)
            if let result = exp.expressionValue(with: nil, context: nil) as? Int {
                person1Answer = result
            }
            
            ansString = sentenceAr[2]
            ansString = ansString.replacingOccurrences(of: "\\A", with: String(A))
            ansString = ansString.replacingOccurrences(of: "\\B", with: String(B))
            ansString = ansString.replacingOccurrences(of: "\\E", with: String(X))
            ansString = ansString.replacingOccurrences(of: replaceMString, with: String(X))
            ansString = ansString.replacingOccurrences(of: replaceQString, with: String(A))
            ansString = ansString.replacingOccurrences(of: replaceRString, with: String(Z))
            ansString = ansString.replacingOccurrences(of: replaceVString, with: String(B))
            ansString = ansString.replacingOccurrences(of: "\\X", with: String(X))
            ansString = ansString.replacingOccurrences(of: "\\Y", with: String(Y))
            ansString = ansString.replacingOccurrences(of: "\\Z", with: String(Z))
            ansString = ansString.replacingOccurrences(of: "\\W", with: String(W))
            exp = NSExpression(format: ansString)
            if let result = exp.expressionValue(with: nil, context: nil) as? Int {
                if Z > -1 || B > -1 {
                    person1Answer2 = result
                }
                else {
                    person2Answer = result
                }
            }
            
            if sentenceAr.count < 5 {
                return
            }
            ansString = sentenceAr[3]
            ansString = ansString.replacingOccurrences(of: "\\A", with: String(A))
            ansString = ansString.replacingOccurrences(of: "\\B", with: String(B))
            ansString = ansString.replacingOccurrences(of: "\\X", with: String(X))
            ansString = ansString.replacingOccurrences(of: "\\E", with: String(X))
            ansString = ansString.replacingOccurrences(of: replaceMString, with: String(X))
            ansString = ansString.replacingOccurrences(of: replaceQString, with: String(A))
            ansString = ansString.replacingOccurrences(of: replaceRString, with: String(Z))
            ansString = ansString.replacingOccurrences(of: replaceVString, with: String(B))
            ansString = ansString.replacingOccurrences(of: "\\Y", with: String(Y))
            ansString = ansString.replacingOccurrences(of: "\\Z", with: String(Z))
            ansString = ansString.replacingOccurrences(of: "\\W", with: String(W))
            exp = NSExpression(format: ansString)
            if let result = exp.expressionValue(with: nil, context: nil) as? Int {
                person2Answer = result
            }
            
            ansString = sentenceAr[4]
            ansString = ansString.replacingOccurrences(of: "\\A", with: String(A))
            ansString = ansString.replacingOccurrences(of: "\\B", with: String(B))
            ansString = ansString.replacingOccurrences(of: "\\X", with: String(X))
            ansString = ansString.replacingOccurrences(of: "\\E", with: String(X))
            ansString = ansString.replacingOccurrences(of: replaceMString, with: String(X))
            ansString = ansString.replacingOccurrences(of: replaceQString, with: String(A))
            ansString = ansString.replacingOccurrences(of: replaceRString, with: String(Z))
            ansString = ansString.replacingOccurrences(of: replaceVString, with: String(B))
            ansString = ansString.replacingOccurrences(of: "\\Y", with: String(Y))
            ansString = ansString.replacingOccurrences(of: "\\Z", with: String(Z))
            ansString = ansString.replacingOccurrences(of: "\\W", with: String(W))
            exp = NSExpression(format: ansString)
            if let result = exp.expressionValue(with: nil, context: nil) as? Int {
                person2Answer2 = result
            }
        }
        else {
            print("file not found")
        }
    }
    
    func ReplaceSentenceKeywords(sentence:inout String,replaceMString:String,replaceQString:String,replaceRString:String,
                                 replaceVString:String,npcGender:String) {
        var itemNoS = " 1 " + item
        itemNoS.removeLast()
        var item2NoS = " 1 " + item2
        item2NoS.removeLast()
        sentence = sentence.replacingOccurrences(of: "Alice", with: person1)
        sentence = sentence.replacingOccurrences(of: "Student", with: global.currentStudent)
        sentence = sentence.replacingOccurrences(of: "\\A", with: String(A))
        sentence = sentence.replacingOccurrences(of: "\\B", with: String(B))
        sentence = sentence.replacingOccurrences(of: "\\E", with: String(X))
        sentence = sentence.replacingOccurrences(of: replaceMString, with: String(X))
        sentence = sentence.replacingOccurrences(of: replaceQString, with: String(A))
        sentence = sentence.replacingOccurrences(of: replaceRString, with: String(Z))
        sentence = sentence.replacingOccurrences(of: replaceVString, with: String(B))
        sentence = sentence.replacingOccurrences(of: "\\X", with: String(X))
        sentence = sentence.replacingOccurrences(of: "\\Y", with: String(Y))
        sentence = sentence.replacingOccurrences(of: "\\Z", with: String(Z))
        sentence = sentence.replacingOccurrences(of: "\\W", with: String(W))
        sentence = sentence.replacingOccurrences(of: " 1 items2", with: item2NoS)
        sentence = sentence.replacingOccurrences(of: " 1 items", with: itemNoS)
        sentence = sentence.replacingOccurrences(of: "items2", with: item2)
        sentence = sentence.replacingOccurrences(of: "items", with: item)
        if npcGender == "M" {
            sentence = sentence.replacingOccurrences(of: " her ", with: " his ")
        }
    }
    
    func GetMaxItems() -> Int {
        if global.currentGrade == "K" {
            return 10
        }
        if global.currentGrade == "1" {
            return 15
        }
        
        return 22
    }
    
    func IsStudentFirst(sentence:String) -> Bool {
        let studentLen = sentence.index(sentence.startIndex, offsetBy: 7)
        var studentStr = ""
        for index in sentence.characters.indices {
            if index == studentLen {
                studentStr = sentence.substring(to: index)
                break
            }
        }
        if studentStr == "Student" {
            return true
        }
        return false
    }
    
    func TransitionScene(playSound: SKAction,duration: TimeInterval) {
        global.overlayNode.removeAllActions()
        global.overlayNode.removeAllChildren()
        global.overlayNode.removeFromParent()
        
        let wait = SKAction.wait(forDuration: duration)
        
        let newScene = SKAction.run({
            let reveal = SKTransition.reveal(with:SKTransitionDirection.left, duration:1.0)
            if (global.currentSentenceNum % 6) < 3 {
                let nextScene = MathDrawScene(size: self.size,currentSentenceNum:global.wordProblemsNum,correctAnswers:global.correctAnswers,incorrectAnswers:global.incorrectAnswers,currentExtraWordNum:self.currentExtraWordNum,sceneType:global.sceneType)
                self.view?.presentScene(nextScene, transition: reveal)
            }
            else {
                let nextScene = MathDragScene(size: self.size,currentSentenceNum:global.wordProblemsNum,correctAnswers:global.correctAnswers,incorrectAnswers:global.incorrectAnswers,currentExtraWordNum:self.currentExtraWordNum,sceneType:global.sceneType)
                self.view?.presentScene(nextScene, transition: reveal)
            }
        })
        self.run(SKAction.sequence([playSound,wait,newScene]))
    }
}

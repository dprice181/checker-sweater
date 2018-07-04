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
    var wordAr : [String] = []
    
    let labelCountFirstName = SKLabelNode(fontNamed: "MarkerFelt-Thin")
    var labelCountFirstNameShadow = SKLabelNode(fontNamed: "MarkerFelt-Thin")
    let labelCountSecondName = SKLabelNode(fontNamed: "MarkerFelt-Thin")
    let labelCount2SecondName = SKLabelNode(fontNamed: "MarkerFelt-Thin")
    var labelCountSecondNameShadow = SKLabelNode(fontNamed: "MarkerFelt-Thin")
    var submitButtonShadow = SKShapeNode()
    var labelTitleShadow = SKLabelNode()
    var labelSubtitleShadow = SKLabelNode()
    
    
    var sentence = ""
    var person1Answer = -1
    var person2Answer = -1
    var person3Answer = -1
    
    let NPCAr = ["Alice","Bob","Susan","Gary","Deborah","Steve","Kathy","David"]
    let itemAr = ["cookies","pies","cakes","pencils","books"]
    
    var item = "cookies"
    var item2 = "pies"
    var person1 = "Alice"
    
    var X = 0
    var Y = 0
    var Z = 0
    var W = 0
    
    var itemNodeAr = [SKSpriteNode]()
    
    var selectedNode = SKSpriteNode()
    var itemTouched = false
    
    var boxFirstName = SKShapeNode()
    var boxSecondName = SKShapeNode()
    
    var labelWordProblemAr = [SKLabelNode]()
    
    init(size: CGSize, currentSentenceNum:Int, correctAnswers:Int, incorrectAnswers:Int, currentExtraWordNum:Int,sceneType:String) {
        super.init(size: size)
        
        global.currentStudent = "Amandas"
        
        physicsWorld.gravity = .zero
        backgroundColor = SKColor(red: 234/255, green: 230/255, blue: 236/255, alpha: 1)
        
        self.currentExtraWordNum = currentExtraWordNum
        self.sceneType = sceneType
        
        GetSentence()
        
        let fullTitle = SKNode()
        fullTitle.position = CGPoint(x: self.size.width/2, y: self.size.height*9/10)
        fullTitle.zPosition = 100.0
                
        labelTitle.text = "WORD PROBLEMS"
        labelTitle.fontSize = 40
        labelTitle.fontColor = SKColor.red
        labelTitle.position = .zero
        labelTitle.zPosition = 100.0
        fullTitle.addChild(labelTitle)
        labelTitleShadow = CreateShadowLabel(label: labelTitle,offset: 1)
        fullTitle.addChild(labelTitleShadow)
        
        labelSubtitle.text = "Level " + String(global.currentLevel)
        labelSubtitle.fontSize = 36
        labelSubtitle.fontColor = SKColor.red
        labelSubtitle.position = CGPoint(x: 0, y: -self.size.height/18)
        labelSubtitle.zPosition = 100.0
        fullTitle.addChild(labelSubtitle)
        labelSubtitleShadow = CreateShadowLabel(label: labelSubtitle,offset: 1)
        fullTitle.addChild(labelSubtitleShadow)
        addChild(fullTitle)
        
        DrawSentence()
        DrawItems()
        
        boxFirstName = SKShapeNode(rectOf: CGSize(width: self.size.width*9/10,height: self.size.height*12/48))
        boxFirstName.name = "boxfirstname"
        boxFirstName.strokeColor = SKColor.blue
        boxFirstName.position = CGPoint(x: self.size.width/2, y: self.size.height*24/48)
        addChild(boxFirstName)
        
        let boxSmallFirstName = SKShapeNode(rectOf: CGSize(width: self.size.width*7/48,height: self.size.height*5.5/48))
        boxSmallFirstName.name = "boxfirstname"
        boxSmallFirstName.strokeColor = SKColor.blue
        boxSmallFirstName.position = CGPoint(x: self.size.width*21/24, y: self.size.height*20.75/48)
        addChild(boxSmallFirstName)
        
        labelCountFirstName.text = String(X)
        labelCountFirstName.fontSize = 30
        labelCountFirstName.fontColor = SKColor.blue
        labelCountFirstName.position = CGPoint(x: self.size.width*21/24, y: self.size.height*20.75/48)
        labelCountFirstName.zPosition = 100.0
        addChild(labelCountFirstName)
        labelCountFirstNameShadow = CreateShadowLabel(label: labelCountFirstName,offset: 1)
        addChild(labelCountFirstNameShadow)
        
        if Z > 0 {
            let labelItemFirstName = SKLabelNode(fontNamed: "MarkerFelt-Thin")
            labelItemFirstName.text = item
            labelItemFirstName.fontSize = 15
            labelItemFirstName.fontColor = SKColor.blue
            labelItemFirstName.position = CGPoint(x: self.size.width*21/24, y: self.size.height*19.25/48)
            labelItemFirstName.zPosition = 100.0
            addChild(labelItemFirstName)
            let labelItemFirstNameShadow = CreateShadowLabel(label: labelItemFirstName,offset: 1)
            addChild(labelItemFirstNameShadow)
        }
        else {
            let labelItemFirstName = SKLabelNode(fontNamed: "MarkerFelt-Thin")
            labelItemFirstName.text = item
            labelItemFirstName.fontSize = 15
            labelItemFirstName.fontColor = SKColor.blue
            labelItemFirstName.position = CGPoint(x: self.size.width*18/24, y: self.size.height*19.25/48)
            labelItemFirstName.zPosition = 100.0
            addChild(labelItemFirstName)
            let labelItemFirstNameShadow = CreateShadowLabel(label: labelItemFirstName,offset: 1)
            addChild(labelItemFirstNameShadow)
        }
        
        
        let labelFirstName = SKLabelNode(fontNamed: "MarkerFelt-Thin")
        labelFirstName.text = person1
        labelFirstName.fontSize = 30
        labelFirstName.fontColor = SKColor.blue
        labelFirstName.position = CGPoint(x: self.size.width/2, y: self.size.height*14/24)
        labelFirstName.zPosition = 100.0
        addChild(labelFirstName)
        let labelFirstNameShadow = CreateShadowLabel(label: labelFirstName,offset: 1)
        addChild(labelFirstNameShadow)
        
        boxSecondName = SKShapeNode(rectOf: CGSize(width: self.size.width*9/10,height: self.size.height*12/48))
        boxSecondName.name = "boxsecondname"
        boxSecondName.strokeColor = SKColor.red
        boxSecondName.position = CGPoint(x: self.size.width/2, y: self.size.height*12/48)
        addChild(boxSecondName)
        
        let boxSmallSecondName = SKShapeNode(rectOf: CGSize(width: self.size.width*7/48,height: self.size.height*5.5/48))
        boxSmallSecondName.name = "boxsecondname"
        boxSmallSecondName.strokeColor = SKColor.red
        boxSmallSecondName.position = CGPoint(x: self.size.width*21/24, y: self.size.height*8.75/48)
        addChild(boxSmallSecondName)
        
        if Z > 0 {
            labelCountSecondName.fontSize = 15
        }
        else {
            labelCountSecondName.fontSize = 30
        }
        
        labelCountSecondName.text = "0"
        labelCountSecondName.fontColor = SKColor.red
        labelCountSecondName.position = CGPoint(x: self.size.width*21/24, y: self.size.height*8.75/48)
        labelCountSecondName.zPosition = 100.0
        addChild(labelCountSecondName)
        labelCountSecondNameShadow = CreateShadowLabel(label: labelCountSecondName,offset: 1)
        addChild(labelCountSecondNameShadow)
        
        if Z > 0 {
            labelCount2SecondName.text = "0"
            labelCount2SecondName.fontColor = SKColor.red
            labelCount2SecondName.position = CGPoint(x: self.size.width*18/24, y: self.size.height*8.75/48)
            labelCount2SecondName.zPosition = 100.0
            addChild(labelCount2SecondName)
            let labelCount2SecondNameShadow = CreateShadowLabel(label: labelCount2SecondName,offset: 1)
            addChild(labelCount2SecondNameShadow)
        }
        
        
        let labelItemSecondName = SKLabelNode(fontNamed: "MarkerFelt-Thin")
        labelItemSecondName.text = item
        labelItemSecondName.fontColor = SKColor.red
        labelItemSecondName.position = CGPoint(x: self.size.width*21/24, y: self.size.height*7.25/48)
        labelItemSecondName.zPosition = 100.0
        if Z > 0 {
            labelItemSecondName.fontSize = 10
        }
        else {
            labelItemSecondName.fontSize = 15
        }
        addChild(labelItemSecondName)
        let labelItemSecondNameShadow = CreateShadowLabel(label: labelItemSecondName,offset: 1)
        addChild(labelItemSecondNameShadow)
        
        if Z > 0 {
            let labelItemSecondName = SKLabelNode(fontNamed: "MarkerFelt-Thin")
            labelItemSecondName.text = item
            labelItemSecondName.fontColor = SKColor.red
            labelItemSecondName.position = CGPoint(x: self.size.width*21/24, y: self.size.height*7.25/48)
            labelItemSecondName.zPosition = 100.0
            labelItemSecondName.fontSize = 15
            addChild(labelItemSecondName)
            let labelItemSecondNameShadow = CreateShadowLabel(label: labelItemSecondName,offset: 1)
            addChild(labelItemSecondNameShadow)
        }
        
        let labelSecondName = SKLabelNode(fontNamed: "MarkerFelt-Thin")
        labelSecondName.text = global.currentStudent
        labelSecondName.fontSize = 30
        labelSecondName.fontColor = SKColor.red
        labelSecondName.position = CGPoint(x: self.size.width/2, y: self.size.height*8/24)
        labelSecondName.zPosition = 100.0
        addChild(labelSecondName)
        let labelSecondNameShadow = CreateShadowLabel(label: labelSecondName,offset: 1)
        addChild(labelSecondNameShadow)
        
        let submitButton = SKSpriteNode(imageNamed: "RedButtonSmall.png")
        submitButton.scale(to: CGSize(width: self.size.width/5.5,height: self.size.height*2.5/48))
        submitButton.name = "submitbutton"
        submitButton.zPosition = 101.0
        submitButton.position = CGPoint(x: self.size.width*8.5/10, y: self.size.height*1.5/24)
        addChild(submitButton)
        
        submitButtonShadow = SKShapeNode(rectOf: CGSize(width: self.size.width/6,
                                            height: self.size.height*2/48),cornerRadius: 30.0)
        submitButtonShadow.name = "bshadow"
        submitButtonShadow.fillColor = SKColor.black
        submitButtonShadow.strokeColor = SKColor.black
        submitButtonShadow.position = CGPoint(x: self.size.width*8.5/10-1.5, y: self.size.height*1.5/24+1.5)
        submitButtonShadow.zPosition = 100.0
        submitButtonShadow.lineWidth = 2.0
        addChild(submitButtonShadow)
        
        let submitLabel = SKLabelNode(fontNamed: "Arial")
        submitLabel.name = "submitbutton"
        submitLabel.fontSize = 15
        submitLabel.fontColor = SKColor.white
        submitLabel.zPosition = 102.0
        submitLabel.position = CGPoint(x: self.size.width*8.5/10, y: self.size.height*1.5/24 - self.size.height/96)
        submitLabel.text = "Submit"
        addChild(submitLabel)
        addChild(CreateShadowLabel(label: submitLabel,offset: 1))
        
        let backButton = SKSpriteNode(imageNamed: "BackwardsClean.png")
        backButton.name = "backbutton"
        backButton.position = CGPoint(x: frame.size.width/20, y: self.size.height*18.5/20)
        backButton.scale(to: CGSize(width: self.size.width/10, height: self.size.width/10))
        addChild(backButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func CheckAnswer() {
        let person1Ans_1 = Int(labelCountFirstName.text!)!
        let person2Ans_1 = Int(labelCountSecondName.text!)!
        
        if person3Answer != -1 {
//            let person3Ans_1 = Int(labelCountThirdName.text!)! + 1
//            if person1Answer == person1Ans_1 && person2Answer == person2Ans_1 && person3Answer == person3Ans_1 {
//
//            }
        }
        else {
            if person1Answer == person1Ans_1 && person2Answer == person2Ans_1 {
                CorrectAnswerSelected()
            }
            else {
                IncorrectAnswerSelected()
            }
        }
    }
    
    func RemoveLabels() {
        labelTitle.removeFromParent()
        labelTitleShadow.removeFromParent()
    }
    
    func CorrectAnswerSelected() {
        RemoveLabels()
        
        for label in labelWordProblemAr {
            label.removeFromParent()
        }
        labelWordProblemAr[0].position = CGPoint(x: self.size.width/2, y: self.size.height*20/24)
        labelWordProblemAr[0].text = "Answer Is Correct!!!"
        labelWordProblemAr[0].fontColor = SKColor.blue
        labelWordProblemAr[0].fontSize = 30
//        labelTitleShadow2.position = CGPoint(x: self.size.width/2 - 1, y: self.size.height*20/24 + 1)
//        labelTitleShadow2.text = "Answer Is Correct!!!"
//        labelTitleShadow2.fontSize = 30
        
        global.correctAnswers = global.correctAnswers + 1
        labelCorrect.text = "Correct : " + String(global.correctAnswers)
        labelCorrectShadow.text = "Correct : " + String(global.correctAnswers)
        
        if global.correctAnswers + global.incorrectAnswers >= 12 {
            DisplayLevelFinished(scene:self)
        }
        else {
            let playSound = SKAction.playSoundFileNamed("QuizRight.wav", waitForCompletion: false)
            TransitionScene(playSound:playSound,duration:1.5)
        }
    }
    
    func IncorrectAnswerSelected() {
        RemoveLabels()
        
        for label in labelWordProblemAr {
            label.removeFromParent()
        }
        labelWordProblemAr[0].position = CGPoint(x: self.size.width/2, y: self.size.height*20/24)
        labelWordProblemAr[0].text = "Answer Is Incorrect!!!"
        labelWordProblemAr[0].fontColor = SKColor.red
        labelWordProblemAr[0].fontSize = 30
        
        global.incorrectAnswers = global.incorrectAnswers + 1
        labelIncorrect.text = "Missed : " + String(global.incorrectAnswers)
        labelIncorrectShadow.text = "Missed : " + String(global.incorrectAnswers)
        
        if global.correctAnswers + global.incorrectAnswers >= 12 {
            DisplayLevelFinished(scene:self)
        }
        else {
            let playSound = SKAction.playSoundFileNamed("QuizWrong.wav", waitForCompletion: false)
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
        
        for i in 0...X-1 {
            itemNodeAr.append(SKSpriteNode(imageNamed: item + ".png"))
            itemNodeAr[i].name = "item"
            itemNodeAr[i].position = CGPoint(x: frame.size.width/2 + offX[i%offX.count], y: self.size.height*11.5/24 + offY[i%offY.count])
            itemNodeAr[i].scale(to: CGSize(width: self.size.width/9, height: self.size.width/9))
            itemNodeAr[i].zPosition = 301
            addChild(itemNodeAr[i])
        }
        if Z > 0 {
            for i in X...X+Z-1 {
                itemNodeAr.append(SKSpriteNode(imageNamed: item2 + ".png"))
                itemNodeAr[i].name = "item"
                itemNodeAr[i].position = CGPoint(x: frame.size.width/2 + offX[i%offX.count], y: self.size.height*11.5/24 + offY[i%offY.count])
                itemNodeAr[i].scale(to: CGSize(width: self.size.width/9, height: self.size.width/9))
                itemNodeAr[i].zPosition = 301
                addChild(itemNodeAr[i])
            }
        }
    
    }
    
    func DrawSentence() {
        let mySentence: NSString = sentence as NSString
        let sizeSentence: CGSize = mySentence.size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: SELECTTEXT_FONTSIZE)])
        let sentenceWidth = sizeSentence.width
        let sentenceHeight = sizeSentence.height
        var numLines = 1
        var countWordsPerLine = 0
        let displayWidth = size.width * 9 / 10
        if sentenceWidth > displayWidth {
            numLines = Int(sentenceWidth / displayWidth) + 1
            wordAr = sentence.characters.split{$0 == " "}.map(String.init)
            countWordsPerLine = Int(ceil(Double(wordAr.count) / Double(numLines)))
            if countWordsPerLine * (numLines-2) >= wordAr.count {
                numLines = numLines - 2
            }
            else if countWordsPerLine * (numLines-1) >= wordAr.count {
                numLines = numLines - 1
            }
        }
        
        if numLines == 1 {
            labelWordProblemAr.append(SKLabelNode(fontNamed: "Arial"))
            labelWordProblemAr[0].text = sentence
            labelWordProblemAr[0].fontSize = SELECTTEXT_FONTSIZE
            labelWordProblemAr[0].fontColor = global.purple
            labelWordProblemAr[0].position = CGPoint(x: self.size.width/2, y: self.size.height*19/24)
            labelWordProblemAr[0].zPosition = 100.0
            labelWordProblemAr[0].name = "spellingdefinition"
            addChild(labelWordProblemAr[0])
            addChild(CreateShadowLabel(label: labelWordProblemAr[0],offset: 1))
        }
        else {
            var totalWordsSoFar = 0
            for n in 0...numLines-1  {
                var defAr = wordAr.dropFirst(totalWordsSoFar)
                var countWords = countWordsPerLine
                if n == numLines-1 {
                    countWords = wordAr.count - totalWordsSoFar
                }
                else {
                    defAr = defAr.dropLast(wordAr.count - (countWords+totalWordsSoFar))
                }
                let definitionLine = defAr.joined(separator: " ")
                
                labelWordProblemAr.append(SKLabelNode(fontNamed: "Arial"))
                labelWordProblemAr[n].text = definitionLine
                labelWordProblemAr[n].fontSize = SELECTTEXT_FONTSIZE
                labelWordProblemAr[n].fontColor = global.purple
                labelWordProblemAr[n].position = CGPoint(x: self.size.width/2, y: self.size.height*19/24 - sentenceHeight * CGFloat(n))
                labelWordProblemAr[n].zPosition = 100.0
                labelWordProblemAr[n].name = "spellingdefinition"
                addChild(labelWordProblemAr[n])
                addChild(CreateShadowLabel(label: labelWordProblemAr[n],offset: 1))
                totalWordsSoFar = totalWordsSoFar + countWords
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 1 - Choose one of the touches to work with
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
                    
                    let newCount = String(Int(labelCountFirstName.text!)! - 1)
                    labelCountFirstName.text = newCount
                    labelCountFirstNameShadow.text = newCount
                }
                if touchLocation.x > (boxSecondName.position.x-boxSecondName.frame.width/2) &&
                    touchLocation.x < (boxSecondName.position.x+boxSecondName.frame.width/2) &&
                    touchLocation.y > (boxSecondName.position.y-boxSecondName.frame.height/2) &&
                    touchLocation.y < (boxSecondName.position.y+boxSecondName.frame.height/2) {
                    
                    let newCount = String(Int(labelCountSecondName.text!)! - 1)
                    labelCountSecondName.text = newCount
                    labelCountSecondNameShadow.text = newCount
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 1 - Choose one of the touches to work with
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
        // 1 - Choose one of the touches to work with
        guard let touch = touches.first else {
            return
        }                
        
        let touchLocation = touch.location(in: self)
        let touchedNode = self.atPoint(touchLocation)
        
        submitButtonShadow.isHidden = false
        if touchedNode.name?.contains("submitbutton") != nil && (touchedNode.name?.contains("submitbutton"))!  {
            CheckAnswer()
        }
        
        selectedNode = SKSpriteNode()
        if itemTouched == true {
            if touchLocation.x > (boxFirstName.position.x-boxFirstName.frame.width/2) &&
               touchLocation.x < (boxFirstName.position.x+boxFirstName.frame.width/2) &&
               touchLocation.y > (boxFirstName.position.y-boxFirstName.frame.height/2) &&
               touchLocation.y < (boxFirstName.position.y+boxFirstName.frame.height/2) {
                
                let newCount = String(Int(labelCountFirstName.text!)! + 1)
                labelCountFirstName.text = newCount
                labelCountFirstNameShadow.text = newCount
            }
            if touchLocation.x > (boxSecondName.position.x-boxSecondName.frame.width/2) &&
                touchLocation.x < (boxSecondName.position.x+boxSecondName.frame.width/2) &&
                touchLocation.y > (boxSecondName.position.y-boxSecondName.frame.height/2) &&
                touchLocation.y < (boxSecondName.position.y+boxSecondName.frame.height/2) {
                
                let newCount = String(Int(labelCountSecondName.text!)! + 1)
                labelCountSecondName.text = newCount
                labelCountSecondNameShadow.text = newCount
            }
        }
        itemTouched = false
        
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
    
    func GetSentence() {
        if let path = Bundle.main.path(forResource: "WordProblems1", ofType: "txt") {
            let fileText = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
            let lineAr = fileText.components(separatedBy: .newlines)
            if lineAr.count < global.currentSentenceNum {
                return
            }
            let sentenceAr = lineAr[global.currentSentenceNum].characters.split{$0 == "*"}.map(String.init)
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
            let rand2 = Int(arc4random_uniform(UInt32(itemAr.count)))
            item = itemAr[rand2]
            
            var rand3 = Int(arc4random_uniform(UInt32(itemAr.count)))
            while (rand3==rand2) {
                rand3 = Int(arc4random_uniform(UInt32(itemAr.count)))
            }
            item2 = itemAr[rand3]
            
            sentence = sentenceAr[0]
            var string = "Z"
            if sentence.range(of:string) != nil {
                Z = Int(arc4random_uniform(UInt32(X))+1)
            }
            var string2 = "W"
            if sentence.range(of:string2) != nil {
                W = Int(arc4random_uniform(UInt32(Y))+1)
            }
            
            X = Int(arc4random_uniform(UInt32(22))+2)
            Y = Int(arc4random_uniform(UInt32(X))+1)
            
            sentence = sentence.replacingOccurrences(of: "Alice", with: person1)
            sentence = sentence.replacingOccurrences(of: "Student", with: global.currentStudent)
            sentence = sentence.replacingOccurrences(of: "items2", with: item2)
            sentence = sentence.replacingOccurrences(of: "items", with: item)
            sentence = sentence.replacingOccurrences(of: "X", with: String(X))
            sentence = sentence.replacingOccurrences(of: "Y", with: String(Y))
            sentence = sentence.replacingOccurrences(of: "Z", with: String(Z))
            sentence = sentence.replacingOccurrences(of: "W", with: String(W))
            
            var ansString = sentenceAr[1]
            ansString = ansString.replacingOccurrences(of: "X", with: String(X))
            ansString = ansString.replacingOccurrences(of: "Y", with: String(Y))
            ansString = ansString.replacingOccurrences(of: "Z", with: String(Z))
            ansString = ansString.replacingOccurrences(of: "W", with: String(W))
            var exp = NSExpression(format: ansString)
            if let result = exp.expressionValue(with: nil, context: nil) as? Int {
                person1Answer = result
                print("person1Answer=",person1Answer)
            }
            
            ansString = sentenceAr[2]
            ansString = ansString.replacingOccurrences(of: "X", with: String(X))
            ansString = ansString.replacingOccurrences(of: "Y", with: String(Y))
            ansString = ansString.replacingOccurrences(of: "Z", with: String(Z))
            ansString = ansString.replacingOccurrences(of: "W", with: String(W))
            exp = NSExpression(format: ansString)
            if let result = exp.expressionValue(with: nil, context: nil) as? Int {
                person2Answer = result
                print("person2Answer=",person2Answer)
            }
            
            if sentenceAr.count < 4 {
                return
            }
            ansString = sentenceAr[3]
            ansString = ansString.replacingOccurrences(of: "X", with: String(X))
            ansString = ansString.replacingOccurrences(of: "Y", with: String(Y))
            ansString = ansString.replacingOccurrences(of: "Z", with: String(Z))
            ansString = ansString.replacingOccurrences(of: "W", with: String(W))
            exp = NSExpression(format: ansString)
            if let result = exp.expressionValue(with: nil, context: nil) as? Int {
                person3Answer = result
            }
            global.currentSentenceNum = global.currentSentenceNum + 1
        }
        else {
            print("file not found")
        }
    }
    
    func TransitionScene(playSound: SKAction,duration: TimeInterval) {
        for child in global.overlayNode.children {
            child.removeFromParent()
        }
        global.overlayNode.removeFromParent()
        global.currentSentenceNum = global.currentSentenceNum + 1
        
        let wait = SKAction.wait(forDuration: duration)
        
        let newScene = SKAction.run({
            let reveal = SKTransition.reveal(with:SKTransitionDirection.left, duration:1.0)
            if (global.currentSentenceNum % 6) < 3 {
                let nextScene = MathDragScene(size: self.size,currentSentenceNum:global.currentSentenceNum,correctAnswers:global.correctAnswers,incorrectAnswers:global.incorrectAnswers,currentExtraWordNum:self.currentExtraWordNum,sceneType:self.sceneType)
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

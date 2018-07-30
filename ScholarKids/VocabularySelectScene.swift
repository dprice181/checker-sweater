//
//  VocabularySelectScene.swift
//  ScholarKids
//
//  Created by Doug Price on 5/22/18.
//  Copyright © 2018 Doug Price. All rights reserved.
//

import SpriteKit
import GameplayKit


class VocabularySelectScene: SKScene {
    
    let SELECTTEXT_FONTSIZE : CGFloat = 17.0
    
    var nodeDefinitionAr = [SKNode]()
    var choiceboxDefinitionAr = [SKShapeNode]()
    var correctAnswerAr : [Int]  = []
    var sentenceDataAr : [String] = []
    let labelTitle = SKLabelNode(fontNamed: "MarkerFelt-Thin")
    let labelSubtitle = SKLabelNode(fontNamed: "MarkerFelt-Thin")
    var labelTitleShadow = SKLabelNode(fontNamed: "MarkerFelt-Thin")
    var labelSubtitleShadow = SKLabelNode(fontNamed: "MarkerFelt-Thin")
    let labelInstr = SKLabelNode(fontNamed: "Arial")
    var labelInstrShadow = SKLabelNode(fontNamed: "Arial")
    let labelCorrect = SKLabelNode(fontNamed: "Arial")
    let labelIncorrect = SKLabelNode(fontNamed: "Arial")
    var labelCorrectShadow = SKLabelNode(fontNamed: "Arial")
    var labelIncorrectShadow = SKLabelNode(fontNamed: "Arial")
    let labelVocabularyWord = SKLabelNode(fontNamed: "Arial")
    var labelVocabularyWordShadow = SKLabelNode(fontNamed: "Arial")
    let labelSpellingDefinition = SKLabelNode(fontNamed: "Arial")
    var labelSpellingDefinitionShadow = SKLabelNode(fontNamed: "Arial")
    let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
    var sentence = ""
    var correctAnswer = 0
    
    var currentExtraWordNum = 0
    
    
    var wordAr : [String] = []
    var wordAlt1Ar : [String] = []
    var wordAlt2Ar : [String] = []
    
    var spellingDefinition = ""
    var vocabularyWord = ""
    var vocabularyDefinition = ""
    var vocabularyDefinitionAlt1 = ""
    var vocabularyDefinitionAlt2 = ""
    var answerSelected = false
    
    var vocabularyDefinitionAr : [String] = []
    var background = SKSpriteNode(imageNamed: "background4.png")
    
    
     init(size: CGSize, currentSentenceNum:Int, correctAnswers:Int, incorrectAnswers:Int, currentExtraWordNum:Int,sceneType:String) {
        super.init(size: size)
        
        self.currentExtraWordNum = currentExtraWordNum
        global.sceneType = sceneType
        backgroundColor = SKColor(red: 234/255, green: 230/255, blue: 236/255, alpha: 1)
        
        InitLetterStrings()
        GetSentence()
        DrawTitle()
        DrawInstructions()
        DrawScoreNode()
        DrawSentence()
        DrawBackground()
        DrawBackButton()
    }
    
    func DrawSentence() {
        DrawWord()
        
        if global.sceneType == "Spelling" {
            AddSpellingDefinition()
        }
        
        for i in 0...2  {
            var spellingChoice = false
            var spellingOffY : CGFloat = 0
            if global.sceneType == "Spelling" {
                spellingChoice = true
                spellingOffY = -(0.25 / 24) * self.size.height
            }
            DrawDefinition(definition:vocabularyDefinitionAr[i],i:i,incorrectAnswer:false,
                           spellingChoice:spellingChoice,pos:CGPoint(x: self.size.width/2, y: self.size.height*(10-2.5 * CGFloat(i))/24),spellingOffY:spellingOffY,name:"choicelabel")
            DrawChoiceBox(i:i,name:"choicebox")
            addChild(nodeDefinitionAr.last!)
        }
    }
    
    func DrawDefinition(definition:String,i:Int,incorrectAnswer:Bool,spellingChoice:Bool,
                        pos:CGPoint,spellingOffY:CGFloat,name:String) {
        var fontColor = global.lightBlue
        var fontSize = SELECTTEXT_FONTSIZE-1.0
        if incorrectAnswer {
            fontSize = SELECTTEXT_FONTSIZE+3.0
        }
        if spellingChoice {
            fontSize = SELECTTEXT_FONTSIZE+6.0
        }
        let position = pos
        if incorrectAnswer {
            fontColor = SKColor.red
        }
        let displayWidth = size.width * 9.5 / 10
        let sizeSentence = GetTextSize(text:definition,fontSize:fontSize)
        let sentenceWidth = sizeSentence.width
        
        nodeDefinitionAr.append(SKNode())
        nodeDefinitionAr.last!.position = position
        nodeDefinitionAr.last!.zPosition = 100.0
        nodeDefinitionAr.last!.name = "choicenode" + String(i)
        
        if sentenceWidth < displayWidth {
            if incorrectAnswer && global.sceneType=="Spelling" {
                fontSize = GetFontSize(size:28)
            }
            let labelDefinition = SKLabelNode(fontNamed: "Arial")
            labelDefinition.text = definition
            labelDefinition.fontSize = GetFontSize(size:fontSize)
            labelDefinition.fontColor = fontColor
            labelDefinition.position = CGPoint(x:0,y:spellingOffY)
            labelDefinition.zPosition = 100.0
            labelDefinition.name = name + String(i)
            nodeDefinitionAr.last!.addChild(labelDefinition)
            nodeDefinitionAr.last!.addChild(CreateShadowLabel(label: labelDefinition,offset: GetFontSize(size:1)))
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
                    DrawDefinitionLine(definition:lineString,i:i,offY:offY+offset,fontColor:fontColor,
                                       fontSize:fontSize,name:name)
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
                DrawDefinitionLine(definition:lineString,i:i,offY:offY+offset,fontColor:fontColor,
                                   fontSize:fontSize,name:name)
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
    
    func DrawDefinitionLine(definition:String,i:Int,offY:CGFloat,fontColor:SKColor,fontSize:CGFloat,name:String) {
        let labelDefinition = SKLabelNode(fontNamed: "Arial")
        labelDefinition.text = definition
        labelDefinition.fontSize = GetFontSize(size:fontSize)
        labelDefinition.fontColor = fontColor
        labelDefinition.position = CGPoint(x: 0,y: offY)
        labelDefinition.zPosition = 100.0
        labelDefinition.name = name + String(i)
        nodeDefinitionAr.last!.addChild(labelDefinition)
        nodeDefinitionAr.last!.addChild(CreateShadowLabel(label: labelDefinition,offset: GetFontSize(size:1)))
    }
    
    func DrawChoiceBox(i:Int,name:String) {
        choiceboxDefinitionAr.append(SKShapeNode(rectOf: CGSize(width: self.size.width-8,height: self.size.height*5/48)))
        choiceboxDefinitionAr.last!.name = name + String(i)
        choiceboxDefinitionAr.last!.fillColor = global.greyBlue
        choiceboxDefinitionAr.last!.strokeColor = SKColor.purple
        choiceboxDefinitionAr.last!.position = .zero
        nodeDefinitionAr.last!.addChild(choiceboxDefinitionAr[i])
    }
    
    func DrawWord() {
        labelVocabularyWord.text = vocabularyWord
        labelVocabularyWord.fontSize = GetFontSize(size:45)
        labelVocabularyWord.fontColor = global.purple
        if global.sceneType == "Spelling" {
            labelVocabularyWord.position = CGPoint(x: self.size.width/2, y: self.size.height*15/24)
        }
        else {
            labelVocabularyWord.position = CGPoint(x: self.size.width/2, y: self.size.height*13.5/24)
        }
        labelVocabularyWord.zPosition = 100.0
        addChild(labelVocabularyWord)
        labelVocabularyWordShadow = CreateShadowLabel(label: labelVocabularyWord,offset: GetFontSize(size:1))
        addChild(labelVocabularyWordShadow)
    }
    
    func DrawBackButton() {        
        let backButton = SKSpriteNode(imageNamed: "BackwardsClean.png")
        backButton.name = "backbutton"
        backButton.position = CGPoint(x: frame.size.width/20, y: self.size.height*18.5/20)
        backButton.scale(to: CGSize(width: self.size.width/10, height: self.size.width/10))
        addChild(backButton)
    }
    
    func DrawBackground() {
        background.position = CGPoint(x: frame.size.width * 5 / 6, y: frame.size.height / 6)
        background.scale(to: CGSize(width: self.size.width/3, height: self.size.height/3))
        addChild(background)
    }
    
    func DrawTitle() {
        let fullTitle = SKNode()
        fullTitle.position = CGPoint(x: self.size.width/2, y: self.size.height*21/24)
        fullTitle.zPosition = 100.0
        
        if global.sceneType == "Spelling" {
            labelTitle.text = "SPELLING"
            labelTitle.fontSize = GetFontSize(size:55)
        }
        else {
            labelTitle.text = "VOCABULARY"
            labelTitle.fontSize = GetFontSize(size:50)
        }
        
        labelTitle.fontColor = SKColor.red
        labelTitle.position = .zero
        labelTitle.zPosition = 100.0
        fullTitle.addChild(labelTitle)
        labelTitleShadow = CreateShadowLabel(label: labelTitle,offset: GetFontSize(size:1))
        fullTitle.addChild(labelTitleShadow)
        
        labelSubtitle.text = "Level " + String(global.currentLevel)
        labelSubtitle.fontSize = GetFontSize(size:45)
        labelSubtitle.fontColor = SKColor.red
        labelSubtitle.position = CGPoint(x: 0, y: -self.size.height/12)
        labelSubtitle.zPosition = 100.0
        fullTitle.addChild(labelSubtitle)
        labelSubtitleShadow = CreateShadowLabel(label: labelSubtitle,offset: GetFontSize(size:1))
        fullTitle.addChild(labelSubtitleShadow)
        addChild(fullTitle)
    }
    
    func DrawInstructions() {
        if global.sceneType == "Spelling" {
            labelInstr.text = "Select the correct spelling below."
            labelInstr.position = CGPoint(x: self.size.width/2, y: self.size.height*17.5/24)
        }
        else {
            labelInstr.text = "Select the correct definition below."
            labelInstr.position = CGPoint(x: self.size.width/2, y: self.size.height*17/24)
        }
        labelInstr.fontSize = GetFontSize(size:20)
        labelInstr.fontColor = global.realPurple
        
        labelInstr.zPosition = 100.0
        addChild(labelInstr)
        labelInstrShadow = CreateShadowLabel(label: labelInstr,offset: GetFontSize(size:1))
        addChild(labelInstrShadow)
    }
    
    func DrawScoreNode() {
        let scoreNode = SKNode()
        scoreNode.position = CGPoint(x: self.size.width/8, y: self.size.height/24)
        scoreNode.zPosition = 100.0
    
        labelCorrect.text = "Correct : " + String(global.correctAnswers)
        labelCorrect.fontSize = GetFontSize(size:15)
        labelCorrect.fontColor = SKColor.red
        labelCorrect.position = CGPoint(x: 0, y: self.size.height/24)
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func AddSpellingDefinition() {
        spellingDefinition = "(" + spellingDefinition + ")"
        DrawDefinition(definition:spellingDefinition,i:0,incorrectAnswer:false,
                       spellingChoice:false,pos:CGPoint(x: self.size.width/2, y: self.size.height*13/24),
                       spellingOffY:0,name:"spellingDefinition")
        addChild(nodeDefinitionAr.last!)
    }
    
    
    func GetFilename() -> String {
        if let grade = Int(global.currentGrade) {
            if grade > 8 {
                return global.sceneType + "8"
            }
        }
        return global.sceneType + global.currentGrade
    }
    
    func GetSentence() {
        let fileName = GetFilename()
        
        if let path = Bundle.main.path(forResource: fileName, ofType: "txt") {
            let fileText = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
            var lineAr = fileText.components(separatedBy: .newlines)
            global.currentSentenceNum = global.currentSentenceNum % (lineAr.count/2)
            
            if global.sceneType == "Spelling" {
                spellingDefinition = lineAr[global.currentSentenceNum*2+1]
                //spellingDefinition = lineAr[global.spellingSelectNum*2+1]
                
                vocabularyDefinition = lineAr[global.currentSentenceNum*2]  //this is actually the spellingWord
                //vocabularyDefinition = lineAr[global.spellingSelectNum*2]  //this is actually the spellingWord
                var vocabularyWordAr = Misspell(word: vocabularyDefinition)
                vocabularyWord = vocabularyWordAr[0]
                
                correctAnswer = Int(arc4random_uniform(3))
                if correctAnswer==0  {
                    vocabularyDefinitionAr.append(vocabularyDefinition)
                }
                vocabularyDefinitionAr.append(vocabularyWordAr[1])
                if correctAnswer==1  {
                    vocabularyDefinitionAr.append(vocabularyDefinition)
                }
                vocabularyDefinitionAr.append(vocabularyWordAr[2])
                if correctAnswer==2  {
                    vocabularyDefinitionAr.append(vocabularyDefinition)
                }
            }
            else {  //Vocabulary
                //lineAr.shuffle()  //FIX should be done once per launch, not per screen
                
                vocabularyWord = lineAr[global.currentSentenceNum*2]
                //vocabularyWord = lineAr[global.vocabularySelectNum*2]
                vocabularyDefinition = lineAr[global.currentSentenceNum*2 + 1]
                //vocabularyDefinition = lineAr[global.vocabularySelectNum*2 + 1]
                let vocabCount = lineAr.count / 2
                var randomAlt1 = Int(arc4random_uniform(UInt32(vocabCount)))
                while randomAlt1 == global.currentSentenceNum {
                    randomAlt1 = Int(arc4random_uniform(UInt32(vocabCount)))
                }
                var randomAlt2 = Int(arc4random_uniform(UInt32(vocabCount)))
                while randomAlt2 == randomAlt1  || randomAlt2 == global.currentSentenceNum {
                    randomAlt2 = Int(arc4random_uniform(UInt32(vocabCount)))
                }
                vocabularyDefinitionAlt1 = lineAr[randomAlt1*2 + 1]
                vocabularyDefinitionAlt2 = lineAr[randomAlt2*2 + 1]
                
                correctAnswer = Int(arc4random_uniform(3))
                if correctAnswer==0  {
                    vocabularyDefinitionAr.append(vocabularyDefinition)
                }
                vocabularyDefinitionAr.append(vocabularyDefinitionAlt1)
                if correctAnswer==1  {
                    vocabularyDefinitionAr.append(vocabularyDefinition)
                }
                vocabularyDefinitionAr.append(vocabularyDefinitionAlt2)
                if correctAnswer==2  {
                    vocabularyDefinitionAr.append(vocabularyDefinition)
                }
            }
            
            global.currentSentenceNum = (global.currentSentenceNum + 1) % (lineAr.count/2)  //wrap around at eof
            if global.sceneType == "Vocabulary" {
                global.vocabularySelectNum = (global.vocabularySelectNum + 1) % (lineAr.count/2)  //wrap around at eof
            }
            else {  //Spelling
                global.spellingSelectNum = (global.spellingSelectNum + 1) % (lineAr.count/2)  //wrap around at eof                
            }
        }
        else {
            print("file not found")
        }
    }
    
    func GetSentenceLength(wordAr : [String]) -> Int {
        var count = 1  //Add 1 for the period at the end
        for word in wordAr {
            count += (word.characters.count + 1)
        }
        
        return count
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        var selectedBox = SKShapeNode()
        
        let touchLocation = touch.location(in: self)
        let touchedNode = self.atPoint(touchLocation)
        
        if let myNode = touchedNode as? SKLabelNode
        {
            if myNode.name?.contains("choice") != nil  && (myNode.name?.contains("choice"))!  {
                
                if let parent = myNode.parent {
                    for child in parent.children {
                        if (child.name?.contains("choicebox")) != nil && (child.name?.contains("choicebox"))!  {
                            if let myBoxNode = child as? SKShapeNode {
                                myBoxNode.fillColor = global.lightPurple
                                selectedBox = myBoxNode
                            }
                        }
                    }
                }
            }
        }
        if let myNode = touchedNode as? SKShapeNode
        {
            if myNode.name?.contains("choice") != nil && (myNode.name?.contains("choice"))!  {
                myNode.fillColor = global.lightPurple
                selectedBox = myNode
            }
        }
        
        for choicebox in choiceboxDefinitionAr {
            if selectedBox != choicebox  {
                choicebox.fillColor = global.greyBlue
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        var selectedBox = SKShapeNode()
        
        let touchLocation = touch.location(in: self)
        let touchedNode = self.atPoint(touchLocation)
        
        if let myNode = touchedNode as? SKLabelNode {
            if (myNode.name?.contains("choice")) != nil  && (myNode.name?.contains("choice"))!  {
                
                if let parent = myNode.parent {
                    for child in parent.children {
                        if child.name?.contains("choicebox") != nil && (child.name?.contains("choicebox"))!  {
                            if let myBoxNode = child as? SKShapeNode {
                                myBoxNode.fillColor = global.lightPurple
                                selectedBox = myBoxNode
                            }
                        }
                    }
                }
            }
        }
        if let myNode = touchedNode as? SKShapeNode {
            if myNode.name?.contains("choicebox") != nil && (myNode.name?.contains("choicebox"))!  {
                myNode.fillColor = global.lightPurple
                selectedBox = myNode
            }
        }
        
        for choicebox in choiceboxDefinitionAr {
            if selectedBox != choicebox  {
                choicebox.fillColor = global.greyBlue
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 1 - Choose one of the touches to work with
        guard let touch = touches.first else {
            return
        }
        if answerSelected {
            return
        }
        
        let touchLocation = touch.location(in: self)
        let touchedNode = self.atPoint(touchLocation)
        if let myNode = touchedNode as? SKLabelNode {
            if myNode.name?.contains("choice") != nil && (myNode.name?.contains("choice"))!  {
                if myNode.name?.contains(String(correctAnswer)) != nil && (myNode.name?.contains(String(correctAnswer)))!  {
                    CorrectAnswerSelected()
                }
                else  {
                    IncorrectAnswerSelected()
                }
            }
        }
        if let myNode = touchedNode as? SKShapeNode {
            if myNode.name?.contains("choicebox") != nil && (myNode.name?.contains("choicebox"))!  {
                if myNode.name?.contains(String(correctAnswer)) != nil && (myNode.name?.contains(String(correctAnswer)))!  {
                    CorrectAnswerSelected()
                }
                else  {
                    IncorrectAnswerSelected()
                }
            }            
        }
        if let shapeNode = touchedNode as? SKNode {
            if shapeNode.name?.contains("backbutton") != nil && (shapeNode.name?.contains("backbutton"))!  {
                TransitionBackFromScene(myScene: self)
            }
            if shapeNode.name?.contains("home") != nil && (shapeNode.name?.contains("home"))!  {
                TransitionBackFromScene(myScene: self)
            }
            if shapeNode.name?.contains("retry") != nil && (shapeNode.name?.contains("retry"))!  {
                global.currentSentenceNum = 24 * (global.currentLevel-1)
                var playSound = SKAction.playSoundFileNamed("QuizRight.wav", waitForCompletion: false)
                if global.soundOption > 0 {
                    playSound = SKAction.wait(forDuration: 0.0001)
                }
                TransitionScene(playSound:playSound,duration:0.0)
            }
            if shapeNode.name?.contains("next") != nil && (shapeNode.name?.contains("next"))!  {
                global.currentLevel = global.currentLevel + 1
                global.currentSentenceNum = 24 * (global.currentLevel-1)
                var playSound = SKAction.playSoundFileNamed("QuizRight.wav", waitForCompletion: false)
                if global.soundOption > 0 {
                    playSound = SKAction.wait(forDuration: 0.0001)
                }
                TransitionScene(playSound:playSound,duration:0.0)
            }
        }
    }
    
    func TransitionScene(playSound: SKAction,duration: Double) {
        global.overlayNode.removeAllActions()
        global.overlayNode.removeAllChildren()
        global.overlayNode.removeFromParent()
        let wait = SKAction.wait(forDuration: duration)
        
        let newScene = SKAction.run({
            let reveal = SKTransition.reveal(with:SKTransitionDirection.left, duration:1.0)

            if global.sceneType == "Spelling" {
                if (global.currentSentenceNum % 6) < 3 {
                    let nextScene = VocabularySelectScene(size: self.size,currentSentenceNum:global.currentSentenceNum,correctAnswers:global.correctAnswers,incorrectAnswers:global.incorrectAnswers,currentExtraWordNum:self.currentExtraWordNum,sceneType:global.sceneType)
                    self.view?.presentScene(nextScene, transition: reveal)
                }
                else {
                    let nextScene = SpellingDragScene(size: self.size,currentSentenceNum:global.currentSentenceNum,correctAnswers:global.correctAnswers,incorrectAnswers:global.incorrectAnswers,currentExtraWordNum:self.currentExtraWordNum,sceneType:global.sceneType)
                    self.view?.presentScene(nextScene, transition: reveal)
                }
            }
            else {
                if (global.currentSentenceNum % 12) < 9 {
                    let nextScene = VocabularyConnectScene(size: self.size,currentSentenceNum:global.currentSentenceNum,correctAnswers:global.correctAnswers,incorrectAnswers:global.incorrectAnswers,currentExtraWordNum:self.currentExtraWordNum,sceneType:global.sceneType)
                    self.view?.presentScene(nextScene, transition: reveal)
                }
                else {
                    let nextScene = VocabularySelectScene(size: self.size,currentSentenceNum:global.currentSentenceNum,correctAnswers:global.correctAnswers,incorrectAnswers:global.incorrectAnswers,currentExtraWordNum:self.currentExtraWordNum,sceneType:global.sceneType)
                    self.view?.presentScene(nextScene, transition: reveal)
                }
            }
        })
        self.run(SKAction.sequence([playSound,wait,newScene]))
    }
    
    func CorrectAnswerSelected() {
        answerSelected = true
        
        labelInstr.text = "Answer Is Correct!!!"
        labelInstr.fontColor = global.blue
        labelInstr.fontSize = GetFontSize(size:30)
        labelInstrShadow.text = "Answer Is Correct!!!"
        labelInstrShadow.fontSize = GetFontSize(size:30)
        
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
        
        for node in nodeDefinitionAr {
            node.removeFromParent()
        }
        labelInstr.text = "Incorrect, the correct answer is:"
        labelInstrShadow.text = "Incorrect, the correct answer is:"
        labelInstrShadow.fontSize = GetFontSize(size:24)
        labelInstr.fontColor = SKColor.red
        labelInstr.fontSize = GetFontSize(size:24)
        
        global.incorrectAnswers = global.incorrectAnswers + 1
        labelIncorrect.text = "Missed : " + String(global.incorrectAnswers)
        labelIncorrectShadow.text = "Missed : " + String(global.incorrectAnswers)

        DrawDefinition(definition:vocabularyDefinitionAr[correctAnswer],i:correctAnswer,incorrectAnswer:true,
                       spellingChoice:false,pos:CGPoint(x: self.size.width/2, y: self.size.height*11.5 / 24),
                       spellingOffY:0,name:"spellingDefinition")
        addChild(nodeDefinitionAr.last!)
        
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
}


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
    let labelTitle = SKLabelNode(fontNamed: "ChalkDuster")
    let labelSubtitle = SKLabelNode(fontNamed: "ChalkDuster")
    var labelTitleShadow = SKLabelNode(fontNamed: "ChalkDuster")
    var labelSubtitleShadow = SKLabelNode(fontNamed: "ChalkDuster")
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
    
    var correctAnswers = 0
    var incorrectAnswers = 0
    var currentSentenceNum = 0
    var currentExtraWordNum = 0
    var sceneType = ""
    
    var wordAr : [String] = []
    var wordAlt1Ar : [String] = []
    var wordAlt2Ar : [String] = []
    
    var spellingDefinition = ""
    var vocabularyWord = ""
    var vocabularyDefinition = ""
    var vocabularyDefinitionAlt1 = ""
    var vocabularyDefinitionAlt2 = ""
    
    var vocabularyDefinitionAr : [String] = []
    var background = SKSpriteNode(imageNamed: "background4.png")
    
     init(size: CGSize, currentSentenceNum:Int, correctAnswers:Int, incorrectAnswers:Int, currentExtraWordNum:Int,sceneType:String) {
        super.init(size: size)
        
        self.currentSentenceNum = currentSentenceNum
        self.correctAnswers = correctAnswers
        self.incorrectAnswers = incorrectAnswers
        self.currentExtraWordNum = currentExtraWordNum
        self.sceneType = sceneType
        
        InitLetterStrings()
        GetSentence()
        
        backgroundColor = SKColor(red: 234/255, green: 230/255, blue: 236/255, alpha: 1)
        
        let fullTitle = SKNode()
        fullTitle.position = CGPoint(x: self.size.width/2, y: self.size.height*5/6)
        fullTitle.zPosition = 100.0
        
        if sceneType == "Spelling" {
            labelTitle.text = "SPELLING"
        }
        else {
            labelTitle.text = "VOCABULARY"
        }
        labelTitle.fontSize = 35
        labelTitle.fontColor = SKColor.red
        labelTitle.position = .zero
        labelTitle.zPosition = 100.0
        fullTitle.addChild(labelTitle)
        labelTitleShadow = CreateShadowLabel(label: labelTitle,offset: 1)
        fullTitle.addChild(labelTitleShadow)
        
        labelSubtitle.text = "Level " + String(global.currentLevel)
        labelSubtitle.fontSize = 30
        labelSubtitle.fontColor = SKColor.red
        labelSubtitle.position = CGPoint(x: 0, y: -self.size.height/18)
        labelSubtitle.zPosition = 100.0
        fullTitle.addChild(labelSubtitle)
        labelSubtitleShadow = CreateShadowLabel(label: labelSubtitle,offset: 1)
        fullTitle.addChild(labelSubtitleShadow)
        
        addChild(fullTitle)
        
        if sceneType == "Spelling" {
            labelInstr.text = "Select the correct spelling below."
        }
        else {
            labelInstr.text = "Select the correct definition below."
        }
        labelInstr.fontSize = 20
        labelInstr.fontColor = SKColor.purple
        labelInstr.position = CGPoint(x: self.size.width/2, y: self.size.height*17/24)
        labelInstr.zPosition = 100.0
        addChild(labelInstr)
        labelInstrShadow = CreateShadowLabel(label: labelInstr,offset: 1)
        addChild(labelInstrShadow)
        
        let scoreNode = SKNode()
        scoreNode.position = CGPoint(x: self.size.width/8, y: self.size.height/24)
        scoreNode.zPosition = 100.0

        labelCorrect.text = "Correct : " + String(self.correctAnswers)
        labelCorrect.fontSize = 15
        labelCorrect.fontColor = SKColor.red
        labelCorrect.position = CGPoint(x: 0, y: self.size.height/24)
        scoreNode.addChild(labelCorrect)
        labelCorrectShadow = CreateShadowLabel(label: labelCorrect,offset: 1)
        scoreNode.addChild(labelCorrectShadow)
        
        labelIncorrect.text = "Missed : " + String(self.incorrectAnswers)
        labelIncorrect.fontSize = 15
        labelIncorrect.fontColor = SKColor.red
        labelIncorrect.position = .zero
        scoreNode.addChild(labelIncorrect)
        labelIncorrectShadow = CreateShadowLabel(label: labelIncorrect,offset: 1)
        scoreNode.addChild(labelIncorrectShadow)

        addChild(scoreNode)
        
        let displayWidth = size.width * 9 / 10
        
        labelVocabularyWord.text = vocabularyWord
        labelVocabularyWord.fontSize = 45
        labelVocabularyWord.fontColor = SKColor(red: 55/255, green: 15/255, blue: 200/255, alpha: 1)
        if sceneType == "Spelling" {
            labelVocabularyWord.position = CGPoint(x: self.size.width/2, y: self.size.height*14.5/24)
        }
        else {
            labelVocabularyWord.position = CGPoint(x: self.size.width/2, y: self.size.height*13.5/24)
        }
        labelVocabularyWord.zPosition = 100.0
        addChild(labelVocabularyWord)
        labelVocabularyWordShadow = CreateShadowLabel(label: labelVocabularyWord,offset: 1)
        addChild(labelVocabularyWordShadow)
        
        if sceneType == "Spelling" {
            AddSpellingDefinition()
        }

        for i in 0...2  {
            let mySentence: NSString = vocabularyDefinitionAr[i] as NSString
            let sizeSentence: CGSize = mySentence.size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: SELECTTEXT_FONTSIZE)])
            let sentenceWidth = sizeSentence.width
            let sentenceHeight = sizeSentence.height
            var numLines = 1
            var countWordsPerLine = 0
            if sentenceWidth > displayWidth {
                numLines = Int(sentenceWidth / displayWidth) + 1
                wordAr = vocabularyDefinitionAr[i].characters.split{$0 == " "}.map(String.init)
                countWordsPerLine = Int(ceil(Double(wordAr.count) / Double(numLines)))
            }
            
            nodeDefinitionAr.append(SKNode())
            nodeDefinitionAr[i].position = CGPoint(x: self.size.width/2, y: self.size.height*(10-2.5 * CGFloat(i))/24)
            nodeDefinitionAr[i].zPosition = 100.0
            nodeDefinitionAr[i].name = "choicenode" + String(i)
            
            if numLines == 1 {
                let labelDefinition = SKLabelNode(fontNamed: "Arial")
                labelDefinition.text = vocabularyDefinitionAr[i]
                labelDefinition.fontSize = SELECTTEXT_FONTSIZE
                labelDefinition.fontColor = global.lightBlue
                labelDefinition.position = .zero
                labelDefinition.zPosition = 100.0
                labelDefinition.name = "choicelabel" + String(i)
                nodeDefinitionAr[i].addChild(labelDefinition)
                nodeDefinitionAr[i].addChild(CreateShadowLabel(label: labelDefinition,offset: 1))
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

                    let labelDefinition = SKLabelNode(fontNamed: "Arial")
                    labelDefinition.text = definitionLine
                    labelDefinition.fontSize = SELECTTEXT_FONTSIZE
                    labelDefinition.fontColor = global.lightBlue
                    labelDefinition.position = CGPoint(x: 0,y: -sentenceHeight * CGFloat(n))
                    labelDefinition.zPosition = 100.0
                    labelDefinition.name = "choicelabel" + String(i)
                    nodeDefinitionAr[i].addChild(labelDefinition)
                    nodeDefinitionAr[i].addChild(CreateShadowLabel(label: labelDefinition,offset: 1))
                    totalWordsSoFar = totalWordsSoFar + countWords
                }
            }
            
            choiceboxDefinitionAr.append(SKShapeNode(rectOf: CGSize(width: self.size.width-8,height: self.size.height*5/48)))
            choiceboxDefinitionAr[i].name = "choicebox" + String(i)
            choiceboxDefinitionAr[i].fillColor = global.lightPurple
            choiceboxDefinitionAr[i].strokeColor = SKColor.purple
            choiceboxDefinitionAr[i].position = .zero
            nodeDefinitionAr[i].addChild(choiceboxDefinitionAr[i])
            
            addChild(nodeDefinitionAr[i])
        }
        
        background.position = CGPoint(x: frame.size.width * 5 / 6, y: frame.size.height / 6)
        background.scale(to: CGSize(width: self.size.width/3, height: self.size.height/3))
        addChild(background)
        
        let backButton = SKSpriteNode(imageNamed: "backwards.png")
        backButton.name = "backbutton"
        backButton.position = CGPoint(x: frame.size.width/20, y: self.size.height*18.5/20)
        backButton.scale(to: CGSize(width: self.size.width/10, height: self.size.width/10))
        addChild(backButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func AddSpellingDefinition() {
        spellingDefinition = "(" + spellingDefinition + ")"
        let mySentence: NSString = spellingDefinition as NSString
        let sizeSentence: CGSize = mySentence.size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: SELECTTEXT_FONTSIZE)])
        let sentenceWidth = sizeSentence.width
        let sentenceHeight = sizeSentence.height
        var numLines = 1
        var countWordsPerLine = 0
        let displayWidth = size.width * 9 / 10
        if sentenceWidth > displayWidth {
            numLines = Int(sentenceWidth / displayWidth) + 1
            wordAr = spellingDefinition.characters.split{$0 == " "}.map(String.init)
            countWordsPerLine = Int(ceil(Double(wordAr.count) / Double(numLines)))
        }
        
        if numLines == 1 {
            labelSpellingDefinition.text = spellingDefinition
            labelSpellingDefinition.fontSize = SELECTTEXT_FONTSIZE
            labelSpellingDefinition.fontColor = global.lightBlue
            labelSpellingDefinition.position = CGPoint(x: self.size.width/2, y: self.size.height*13/24)
            labelSpellingDefinition.zPosition = 100.0
            labelSpellingDefinition.name = "spellingdefinition"
            addChild(labelSpellingDefinition)
            addChild(CreateShadowLabel(label: labelSpellingDefinition,offset: 1))
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
                
                let labelDefinition = SKLabelNode(fontNamed: "Arial")
                labelDefinition.text = definitionLine
                labelDefinition.fontSize = SELECTTEXT_FONTSIZE
                labelDefinition.fontColor = global.lightBlue
                labelDefinition.position = CGPoint(x: self.size.width/2, y: self.size.height*13/24 - sentenceHeight * CGFloat(n))
                labelDefinition.zPosition = 100.0
                labelDefinition.name = "spellingdefinition"
                addChild(labelDefinition)
                addChild(CreateShadowLabel(label: labelDefinition,offset: 1))
                totalWordsSoFar = totalWordsSoFar + countWords
            }
        }
    }
    
    func GetFileName() -> String {
        var fileName = "Vocabulary1"
        if sceneType == "Spelling" {
            fileName = "Spelling1"
            switch (global.currentGrade) {
                case "K","1":
                    fileName = "Spelling1"
                case "2":
                    fileName = "Spelling2"
                case "3":
                    fileName = "Spelling3"
                case "4":
                    fileName = "Spelling4"
                case "5","6":
                    fileName = "Spelling5"
                case "7","8","9","10","11","12":
                    fileName = "Spelling7"
                default:
                    fileName = "Spelling1"
            }
        }
        
        //FIX
        fileName = "Vocabulary1"
        return fileName
    }
    
    func GetSentence() {
        let fileName = GetFileName()
        
        if let path = Bundle.main.path(forResource: fileName, ofType: "txt")
        {
            let fileText = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
            var lineAr = fileText.components(separatedBy: .newlines)
            
            if sceneType == "Spelling" {
                spellingDefinition = lineAr[currentSentenceNum*2+1]
                
                vocabularyDefinition = lineAr[currentSentenceNum*2]  //this is actually the spellingWord
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
            else {
                lineAr.shuffle()  //FIX should be done once per launch, not per screen
                
                vocabularyWord = lineAr[currentSentenceNum*2]
                vocabularyDefinition = lineAr[currentSentenceNum*2 + 1]
                let vocabCount = lineAr.count / 2
                var randomAlt1 = Int(arc4random_uniform(UInt32(vocabCount)))
                while randomAlt1 == currentSentenceNum {
                    randomAlt1 = Int(arc4random_uniform(UInt32(vocabCount)))
                }
                var randomAlt2 = Int(arc4random_uniform(UInt32(vocabCount)))
                while randomAlt2 == randomAlt1  || randomAlt2 == currentSentenceNum {
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
            
            self.currentSentenceNum = self.currentSentenceNum + 1
        }
        else
        {
            print("file not found")
        }
    }
    
    func GetSentenceLength(wordAr : [String]) -> Int
    {
        var count = 1  //Add 1 for the period at the end
        for word in wordAr
        {
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
                                myBoxNode.fillColor = global.veryLightBlue
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
                myNode.fillColor = global.veryLightBlue
                selectedBox = myNode
            }
        }
        
        for choicebox in choiceboxDefinitionAr {
            if selectedBox != choicebox  {
                choicebox.fillColor = global.lightPurple
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
        
        if let myNode = touchedNode as? SKLabelNode
        {
            if (myNode.name?.contains("choice")) != nil  && (myNode.name?.contains("choice"))!  {
                
                if let parent = myNode.parent {
                    for child in parent.children {
                        if child.name?.contains("choicebox") != nil && (child.name?.contains("choicebox"))!  {
                            if let myBoxNode = child as? SKShapeNode {
                                myBoxNode.fillColor = global.veryLightBlue
                                selectedBox = myBoxNode
                            }
                        }
                    }
                }
            }
        }
        if let myNode = touchedNode as? SKShapeNode {
            if (myNode.name?.contains("choicebox"))!  {
                myNode.fillColor = global.veryLightBlue
                selectedBox = myNode
            }
        }
        
        for choicebox in choiceboxDefinitionAr {
            if selectedBox != choicebox  {
                choicebox.fillColor = global.lightPurple
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
        if let myNode = touchedNode as? SKLabelNode {
            if myNode.name?.contains("choice") != nil && (myNode.name?.contains("choice"))!  {
                if (myNode.name?.contains(String(correctAnswer)))!  {
                    CorrectAnswerSelected()
                }
                else  {
                    IncorrectAnswerSelected()
                }
            }
        }
        if let myNode = touchedNode as? SKShapeNode {
            if myNode.name?.contains("choicebox") != nil && (myNode.name?.contains("choicebox"))!  {
                if (myNode.name?.contains(String(correctAnswer)))!  {
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
        }
    }
    
    func TransitionScene(playSound: SKAction,duration: Double)
    {
        let wait = SKAction.wait(forDuration: duration)
        
        let newScene = SKAction.run({
            let reveal = SKTransition.reveal(with:SKTransitionDirection.left, duration:1.0)
            
            if (self.currentSentenceNum % 6) < 3 {
                let nextScene = VocabularySelectScene(size: self.size,currentSentenceNum:self.currentSentenceNum,correctAnswers:self.correctAnswers,incorrectAnswers:self.incorrectAnswers,currentExtraWordNum:self.currentExtraWordNum,sceneType:self.sceneType)
                self.view?.presentScene(nextScene, transition: reveal)
            }
            else {
                let nextScene = WordDragScene(size: self.size,currentSentenceNum:self.currentSentenceNum,correctAnswers:self.correctAnswers,incorrectAnswers:self.incorrectAnswers,currentExtraWordNum:self.currentExtraWordNum,sceneType:self.sceneType)
                self.view?.presentScene(nextScene, transition: reveal)
            }        
        })
        self.run(SKAction.sequence([playSound,wait,newScene]))
    }
    
    func CorrectAnswerSelected()
    {
        labelInstr.text = "Answer Is Correct!!!"
        labelInstr.fontColor = SKColor.blue
        labelInstr.fontSize = 30
        labelInstrShadow.text = "Answer Is Correct!!!"
        labelInstrShadow.fontSize = 30
        
        self.correctAnswers = self.correctAnswers + 1
        labelCorrect.text = "Correct : " + String(self.correctAnswers)
        labelCorrectShadow.text = "Correct : " + String(self.correctAnswers)
        
        let playSound = SKAction.playSoundFileNamed("QuizRight.wav", waitForCompletion: false)
        TransitionScene(playSound:playSound,duration:1.5)
    }
    
    func IncorrectAnswerSelected()
    {
        for node in nodeDefinitionAr {
            node.removeFromParent()
        }
        labelInstr.text = "Incorrect, the correct answer is:"
        labelInstrShadow.text = "Incorrect, the correct answer is:"
        labelInstrShadow.fontSize = 24
        labelInstr.fontColor = SKColor.red
        labelInstr.fontSize = 24
        
        self.incorrectAnswers = self.incorrectAnswers + 1
        labelIncorrect.text = "Missed : " + String(self.incorrectAnswers)
        labelIncorrectShadow.text = "Missed : " + String(self.incorrectAnswers)

        let displayWidth = size.width * 9 / 10
        
        let mySentence: NSString = vocabularyDefinition as NSString
        let sizeSentence: CGSize = mySentence.size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 20)])
        let sentenceWidth = sizeSentence.width
        let sentenceHeight = sizeSentence.height
        var numLines = 1
        var countWordsPerLine = 0
        if sentenceWidth > displayWidth {
            numLines = Int(sentenceWidth / displayWidth) + 1
            wordAr = vocabularyDefinition.characters.split{$0 == " "}.map(String.init)
            countWordsPerLine = Int(ceil(Double(wordAr.count) / Double(numLines)))
        }
        
        if numLines == 1 {
            labelVocabularyWord.text = vocabularyDefinition
            labelVocabularyWord.fontSize = 20
            labelVocabularyWordShadow.text = vocabularyDefinition
            labelVocabularyWordShadow.fontSize = 20
        }
        else {
            labelVocabularyWord.removeFromParent()
            labelVocabularyWordShadow.removeFromParent()
            
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
                
                let labelDefinition = SKLabelNode(fontNamed: "Arial")
                labelDefinition.text = definitionLine
                labelDefinition.fontSize = 20
                labelDefinition.fontColor = global.lightBlue
                labelDefinition.position = CGPoint(x: self.size.width/2, y: self.size.height*12.5 / 24 - sentenceHeight * CGFloat(n))
                labelDefinition.zPosition = 100.0
                labelDefinition.name = "correctAnswerLabel"
                totalWordsSoFar = totalWordsSoFar + countWords
                addChild(labelDefinition)
                addChild(CreateShadowLabel(label: labelDefinition, offset: 1))
            }
        }
        
        let playSound = SKAction.playSoundFileNamed("QuizWrong.wav", waitForCompletion: false)
        TransitionScene(playSound:playSound,duration:5.0)
    }
}


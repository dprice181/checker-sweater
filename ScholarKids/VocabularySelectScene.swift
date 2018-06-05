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
    let labelInstr = SKLabelNode(fontNamed: "Arial")
    let labelCorrect = SKLabelNode(fontNamed: "Arial")
    let labelIncorrect = SKLabelNode(fontNamed: "Arial")
    let labelVocabularyWord = SKLabelNode(fontNamed: "Arial")
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
    
    var vocabularyWord = ""
    var vocabularyDefinition = ""
    var vocabularyDefinitionAlt1 = ""
    var vocabularyDefinitionAlt2 = ""
    
    var vocabularyDefinitionAr : [String] = []
    var background = SKSpriteNode(imageNamed: "background4.jpg")
    
    
    
    init(size: CGSize, currentSentenceNum:Int, correctAnswers:Int, incorrectAnswers:Int, currentExtraWordNum:Int,sceneType:String) {
        super.init(size: size)
        
        self.currentSentenceNum = currentSentenceNum
        self.correctAnswers = correctAnswers
        self.incorrectAnswers = incorrectAnswers
        self.currentExtraWordNum = currentExtraWordNum
        self.sceneType = sceneType
        
        GetSentence()
        
        
        backgroundColor = SKColor.white
        
        let fullTitle = SKNode()
        fullTitle.position = CGPoint(x: self.size.width/2, y: self.size.height*5/6)
        fullTitle.zPosition = 100.0
        
        labelTitle.text = "VOCABULARY:"
        labelTitle.fontSize = 35
        labelTitle.fontColor = SKColor.red
        labelTitle.position = .zero
        labelTitle.zPosition = 100.0
        fullTitle.addChild(labelTitle)
        
        labelSubtitle.text = "Level " + String(global.currentLevel)
        labelSubtitle.fontSize = 30
        labelSubtitle.fontColor = SKColor.red
        labelSubtitle.position = CGPoint(x: 0, y: -self.size.height/12)
        labelSubtitle.zPosition = 100.0
        fullTitle.addChild(labelSubtitle)
        
        addChild(fullTitle)
        
        labelInstr.text = "Select the correct definition below."
        labelInstr.fontSize = 20
        labelInstr.fontColor = SKColor.black
        labelInstr.position = CGPoint(x: self.size.width/2, y: self.size.height*15/24)
        labelInstr.zPosition = 100.0
        addChild(labelInstr)
        
        let scoreNode = SKNode()
        scoreNode.position = CGPoint(x: self.size.width/8, y: self.size.height/24)
        scoreNode.zPosition = 100.0

        labelCorrect.text = "Correct : " + String(self.correctAnswers)
        labelCorrect.fontSize = 15
        labelCorrect.fontColor = SKColor.red
        labelCorrect.position = CGPoint(x: 0, y: self.size.height/24)
        scoreNode.addChild(labelCorrect)


        labelIncorrect.text = "Missed : " + String(self.incorrectAnswers)
        labelIncorrect.fontSize = 15
        labelIncorrect.fontColor = SKColor.red
        labelIncorrect.position = .zero
        scoreNode.addChild(labelIncorrect)

        addChild(scoreNode)
        
        labelVocabularyWord.text = vocabularyWord
        labelVocabularyWord.fontSize = 30
        labelVocabularyWord.fontColor = SKColor(red: 55/255, green: 15/255, blue: 200/255, alpha: 1)
        labelVocabularyWord.position = CGPoint(x: self.size.width/2, y: self.size.height*12.5/24)
        labelVocabularyWord.zPosition = 100.0
        addChild(labelVocabularyWord)
        
        let displayWidth = size.width * 9 / 10

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
                labelDefinition.fontColor = SKColor.blue
                labelDefinition.position = .zero
                labelDefinition.zPosition = 100.0
                labelDefinition.name = "choicelabel" + String(i)
                nodeDefinitionAr[i].addChild(labelDefinition)
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
                    labelDefinition.fontColor = SKColor.blue
                    labelDefinition.position = CGPoint(x: 0,y: -sentenceHeight * CGFloat(n))
                    labelDefinition.zPosition = 100.0
                    labelDefinition.name = "choicelabel" + String(i)
                    nodeDefinitionAr[i].addChild(labelDefinition)
                    totalWordsSoFar = totalWordsSoFar + countWords
                }
            }
            

            
            choiceboxDefinitionAr.append(SKShapeNode(rectOf: CGSize(width: self.size.width-8,height: self.size.height*5/48)))
            choiceboxDefinitionAr[i].name = "choicebox" + String(i)
            choiceboxDefinitionAr[i].fillColor = SKColor(red: 245/255, green: 225/255, blue: 225/255, alpha: 1)
            choiceboxDefinitionAr[i].strokeColor = SKColor.red
            choiceboxDefinitionAr[i].position = .zero
            nodeDefinitionAr[i].addChild(choiceboxDefinitionAr[i])
            
            addChild(nodeDefinitionAr[i])
        }
        
        
        background.position = CGPoint(x: frame.size.width * 5 / 6, y: frame.size.height / 6)
        background.scale(to: CGSize(width: self.size.width/3, height: self.size.height/3))
        addChild(background)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func GetSentence()
    {
        if let path = Bundle.main.path(forResource: "Vocabulary1", ofType: "txt")
        {
            let fileText = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
            var lineAr = fileText.components(separatedBy: .newlines)
            
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
                                myBoxNode.fillColor = SKColor(red: 225/255, green: 225/255, blue: 255/255, alpha: 1)
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
                myNode.fillColor = SKColor(red: 225/255, green: 225/255, blue: 255/255, alpha: 1)
                selectedBox = myNode
            }
        }
        
        for choicebox in choiceboxDefinitionAr {
            if selectedBox != choicebox  {
                choicebox.fillColor = SKColor(red: 255/255, green: 225/255, blue: 225/255, alpha: 1)
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
                                myBoxNode.fillColor = SKColor(red: 225/255, green: 225/255, blue: 255/255, alpha: 1)
                                selectedBox = myBoxNode
                            }
                        }
                    }
                }
            }
        }
        if let myNode = touchedNode as? SKShapeNode
        {
            if (myNode.name?.contains("choicebox"))!  {
                myNode.fillColor = SKColor(red: 225/255, green: 225/255, blue: 255/255, alpha: 1)
                selectedBox = myNode
            }
        }
        
        for choicebox in choiceboxDefinitionAr {
            if selectedBox != choicebox  {
                choicebox.fillColor = SKColor(red: 255/255, green: 225/255, blue: 225/255, alpha: 1)
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
        if let myNode = touchedNode as? SKLabelNode
        {
            if myNode.name?.contains("choice") != nil && (myNode.name?.contains("choice"))!  {
                if (myNode.name?.contains(String(correctAnswer)))!  {
                    CorrectAnswerSelected()
                }
                else  {
                    IncorrectAnswerSelected()
                }
            }
        }
        if let myNode = touchedNode as? SKShapeNode
        {
            if myNode.name?.contains("choicebox") != nil && (myNode.name?.contains("choicebox"))!  {
                if (myNode.name?.contains(String(correctAnswer)))!  {
                    CorrectAnswerSelected()
                }
                else  {
                    IncorrectAnswerSelected()
                }
            }
        }
    }
    
    func TransitionScene(playSound: SKAction,duration: Double)
    {
        let wait = SKAction.wait(forDuration: duration)
        
        let newScene = SKAction.run({
            let reveal = SKTransition.reveal(with:SKTransitionDirection.left, duration:1.0)
            
            if (self.currentSentenceNum % 6) < 3
            {
                let nextScene = VocabularySelectScene(size: self.size,currentSentenceNum:self.currentSentenceNum,correctAnswers:self.correctAnswers,incorrectAnswers:self.incorrectAnswers,currentExtraWordNum:self.currentExtraWordNum,sceneType:self.sceneType)
                self.view?.presentScene(nextScene, transition: reveal)
            }
            else
            {
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
        
        self.correctAnswers = self.correctAnswers + 1
        labelCorrect.text = "Correct : " + String(self.correctAnswers)
        
        let playSound = SKAction.playSoundFileNamed("Correct-answer.mp3", waitForCompletion: false)
        TransitionScene(playSound:playSound,duration:1.5)
    }
    
    func IncorrectAnswerSelected()
    {
        for node in nodeDefinitionAr {
            node.removeFromParent()
        }
        labelInstr.text = "Incorrect, the correct answer is:"
        labelInstr.fontColor = SKColor.red
        labelInstr.fontSize = 24
        
        self.incorrectAnswers = self.incorrectAnswers + 1
        labelIncorrect.text = "Missed : " + String(self.incorrectAnswers)

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
        }
        else {
            labelVocabularyWord.removeFromParent()
            
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
                labelDefinition.fontColor = SKColor.blue
                labelDefinition.position = CGPoint(x: self.size.width/2, y: self.size.height*12.5 / 24 - sentenceHeight * CGFloat(n))
                labelDefinition.zPosition = 100.0
                labelDefinition.name = "correctAnswerLabel"
                totalWordsSoFar = totalWordsSoFar + countWords
                addChild(labelDefinition)
            }
        }
        
        
        let playSound = SKAction.playSoundFileNamed("Error-sound-effect.mp3", waitForCompletion: false)
        TransitionScene(playSound:playSound,duration:4.0)
    }
}

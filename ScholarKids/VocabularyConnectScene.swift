//
//  VocabularyConnect.swift
//  
//
//  Created by Doug Price on 6/26/18.
//

import SpriteKit
import GameplayKit

class VocabularyConnectScene: SKScene {
    
    let SELECTTEXT_FONTSIZE : CGFloat = 17.0
    
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
    
    var vocabularyDefinitionAr : [String] = []
    var nodeDefinitionAr = [SKNode]()
    var nodeWordAr = [SKNode]()
    var vocabularyWordAr : [String] = []
    var choiceboxDefinitionAr = [SKShapeNode]()
    var circleDefinitionAr = [SKShapeNode]()
    var circleWordAr = [SKShapeNode]()
    var circleDefinitionAr2 = [SKShapeNode]()
    var circleWordAr2 = [SKShapeNode]()
    
    var currentExtraWordNum = 0
    
    
    var wordAr : [String] = []
    var word1Ar : [String] = []
    var word2Ar : [String] = []
    
    var vocabularyWord = ""
    var vocabularyWord1 = ""
    var vocabularyWord2 = ""
    var vocabularyDefinition = ""
    var vocabularyDefinition1 = ""
    var vocabularyDefinition2 = ""
    var correctAnswerAr = [Int]()
    
    var fingerDown = false
    var line = SKShapeNode()
    var startLocation : CGPoint = .zero
    
    var wordChosen = -1
    var definitionChosen = -1
    
    var lineConnections = [Int]()
    var lineAr = [SKShapeNode]()
    
    init(size: CGSize, currentSentenceNum:Int, correctAnswers:Int, incorrectAnswers:Int, currentExtraWordNum:Int,sceneType:String) {
        super.init(size: size)
        physicsWorld.gravity = .zero
        
        backgroundColor = SKColor(red: 234/255, green: 230/255, blue: 236/255, alpha: 1)
        GetSentence()
        
        self.currentExtraWordNum = currentExtraWordNum
        global.sceneType = sceneType        
        
        lineConnections.append(-1)
        lineConnections.append(-1)
        lineConnections.append(-1)
        lineAr.append(SKShapeNode())
        lineAr.append(SKShapeNode())
        lineAr.append(SKShapeNode())
        
        let fullTitle = SKNode()
        fullTitle.position = CGPoint(x: self.size.width/2, y: self.size.height*9/10)
        fullTitle.zPosition = 100.0
        
        labelTitle.text = "VOCABULARY"        
        labelTitle.fontSize = 45
        labelTitle.fontColor = SKColor.red
        labelTitle.position = .zero
        labelTitle.zPosition = 100.0
        fullTitle.addChild(labelTitle)
        labelTitleShadow = CreateShadowLabel(label: labelTitle,offset: 1)
        fullTitle.addChild(labelTitleShadow)
        
        labelSubtitle.text = "Level " + String(global.currentLevel)
        labelSubtitle.fontSize = 40
        labelSubtitle.fontColor = SKColor.red
        labelSubtitle.position = CGPoint(x: 0, y: -self.size.height/18)
        labelSubtitle.zPosition = 100.0
        fullTitle.addChild(labelSubtitle)
        labelSubtitleShadow = CreateShadowLabel(label: labelSubtitle,offset: 1)
        fullTitle.addChild(labelSubtitleShadow)
        addChild(fullTitle)
        
        labelInstr.text = "Connect the 3 words to their definitions."        
        labelInstr.fontSize = 20
        labelInstr.fontColor = SKColor.purple
        labelInstr.position = CGPoint(x: self.size.width/2, y: self.size.height*19/24)
        labelInstr.zPosition = 100.0
        addChild(labelInstr)
        labelInstrShadow = CreateShadowLabel(label: labelInstr,offset: 1)
        addChild(labelInstrShadow)
        
        let scoreNode = SKNode()
        scoreNode.position = CGPoint(x: self.size.width/8, y: self.size.height/36)
        scoreNode.zPosition = 100.0
        
        labelCorrect.text = "Correct : " + String(global.correctAnswers)
        labelCorrect.fontSize = 15
        labelCorrect.fontColor = SKColor.red
        labelCorrect.position = CGPoint(x: 0, y: self.size.height/24)
        scoreNode.addChild(labelCorrect)
        labelCorrectShadow = CreateShadowLabel(label: labelCorrect,offset: 1)
        scoreNode.addChild(labelCorrectShadow)
        
        labelIncorrect.text = "Missed : " + String(global.incorrectAnswers)
        labelIncorrect.fontSize = 15
        labelIncorrect.fontColor = SKColor.red
        labelIncorrect.position = .zero
        scoreNode.addChild(labelIncorrect)
        labelIncorrectShadow = CreateShadowLabel(label: labelIncorrect,offset: 1)
        scoreNode.addChild(labelIncorrectShadow)
        
        addChild(scoreNode)
        
        AddWords()
        AddDefinitions()

        let backButton = SKSpriteNode(imageNamed: "BackwardsClean.png")
        backButton.name = "backbutton"
        backButton.position = CGPoint(x: frame.size.width/20, y: self.size.height*18.5/20)
        backButton.scale(to: CGSize(width: self.size.width/10, height: self.size.width/10))
        addChild(backButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func AddWords() {
        for i in 0...2  {
            nodeWordAr.append(SKNode())
            nodeWordAr[i].position = CGPoint(x: self.size.width/5.1, y: self.size.height*(15-5.5 * CGFloat(i))/24)
            nodeWordAr[i].zPosition = 100.0
            nodeWordAr[i].name = "wordnode" + String(i)
            
            let labelWord = SKLabelNode(fontNamed: "Arial")
            labelWord.text = vocabularyWordAr[i]
            
            var count = vocabularyWordAr[i].count - 10
            if count < 0 {
                count = 0
            }
            let fontSizeRed = count
            labelWord.fontSize = SELECTTEXT_FONTSIZE+5.0 - CGFloat(fontSizeRed)
            labelWord.fontColor = global.blue
            labelWord.position = .zero
            labelWord.zPosition = 100.0
            labelWord.name = "wordlabel" + String(i)
            nodeWordAr[i].addChild(labelWord)
            nodeWordAr[i].addChild(CreateShadowLabel(label: labelWord,offset: 1))
            
            //hidden circle to expand clickable area
//            circleWordAr2.append(SKShapeNode(circleOfRadius: 11.0))
//            circleWordAr2[i].name = "wordcircle" + String(i)
//            circleWordAr2[i].fillColor = SKColor(red: 234/255, green: 230/255, blue: 236/255, alpha: 1)
//            circleWordAr2[i].strokeColor = SKColor(red: 234/255, green: 230/255, blue: 236/255, alpha: 1)
//            circleWordAr2[i].lineWidth = 2
//            circleWordAr2[i].position = CGPoint(x:0,y:self.size.height*2/24)
//            circleWordAr2[i].zPosition = -1
//            nodeWordAr[i].addChild(circleWordAr2[i])
            
            circleWordAr.append(SKShapeNode(circleOfRadius: 7.0))
            circleWordAr[i].name = "wordcircle" + String(i)
            circleWordAr[i].fillColor = SKColor.red
            circleWordAr[i].strokeColor = SKColor.black
            circleWordAr[i].lineWidth = 2
            circleWordAr[i].position = CGPoint(x:0,y:self.size.height*1/24)
            nodeWordAr[i].addChild(circleWordAr[i])
            addChild(nodeWordAr[i])
        }
    }
    
    func AddDefinitions() {
        let displayWidth = size.width * 3 / 10
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
                if countWordsPerLine * (numLines-2) >= wordAr.count {
                    numLines = numLines - 2
                }
                else if countWordsPerLine * (numLines-1) >= wordAr.count {
                    numLines = numLines - 1
                }
            }
            
            nodeDefinitionAr.append(SKNode())
            nodeDefinitionAr[i].position = CGPoint(x: self.size.width*0.7, y: self.size.height*(15-5.5 * CGFloat(i))/24)
            nodeDefinitionAr[i].zPosition = 100.0
            nodeDefinitionAr[i].name = "choicenode" + String(i)
            
            if numLines == 1 {
                let labelDefinition = SKLabelNode(fontNamed: "Arial")
                labelDefinition.text = vocabularyDefinitionAr[i]
                labelDefinition.fontSize = SELECTTEXT_FONTSIZE-1.0
                labelDefinition.fontColor = global.purple
                labelDefinition.position = .zero
                labelDefinition.zPosition = 100.0
                labelDefinition.name = "choicelabel" + String(i)
                nodeDefinitionAr[i].addChild(labelDefinition)
                nodeDefinitionAr[i].addChild(CreateShadowLabel(label: labelDefinition,offset: 1))
            }
            else {
                if numLines > 4 {
                    var definition = wordAr.joined(separator: " ")
                    let defAr = definition.characters.split{$0 == ";"}.map(String.init)
                    definition = defAr[0]
                    if defAr.count > 2 {
                        for i in 1...defAr.count - 2 {
                            definition = definition + ";" + defAr[i]
                        }
                    }
                    let mySentence: NSString = definition as NSString
                    let sizeSentence: CGSize = mySentence.size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: SELECTTEXT_FONTSIZE)])
                    let sentenceWidth = sizeSentence.width
                    wordAr = definition.characters.split{$0 == " "}.map(String.init)
                    numLines = Int(sentenceWidth / displayWidth) + 1
                    if numLines > 5 {
                        numLines = 5
                    }
                    countWordsPerLine = Int(ceil(Double(wordAr.count) / Double(numLines)))
                    
                }
                if countWordsPerLine * (numLines-2) >= wordAr.count {
                    numLines = numLines - 2
                }
                else if countWordsPerLine * (numLines-1) >= wordAr.count {
                    numLines = numLines - 1
                }
                var offset : CGFloat = 0.0
                if numLines == 3 {
                    offset = sentenceHeight * 2 / 3
                }
                if numLines == 4 {
                    offset = sentenceHeight * 8 / 7
                }
                if numLines == 5 {
                    offset = sentenceHeight * 1.62
                }
                var totalWordsSoFar = 0
                for n in 0...numLines-1  {
                    var breakEarly = false
                    var defAr = wordAr.dropFirst(totalWordsSoFar)
                    var countWords = countWordsPerLine
                    if n == numLines-1 {
                        countWords = wordAr.count - totalWordsSoFar
                    }
                    else {
                        if countWords+totalWordsSoFar > wordAr.count {
                            countWords = wordAr.count - totalWordsSoFar
                            breakEarly = true
                        }
                        else {
                            defAr = defAr.dropLast(wordAr.count - (countWords+totalWordsSoFar))
                        }
                    }
                    let definitionLine = defAr.joined(separator: " ")
                    let labelDefinition = SKLabelNode(fontNamed: "Arial")
                    labelDefinition.text = definitionLine
                    labelDefinition.fontSize = SELECTTEXT_FONTSIZE-1.0
                    labelDefinition.fontColor = global.purple
                    labelDefinition.position = CGPoint(x: 0,y: offset - sentenceHeight * CGFloat(n))
                    labelDefinition.zPosition = 100.0
                    labelDefinition.name = "choicelabel" + String(i)
                    nodeDefinitionAr[i].addChild(labelDefinition)
                    nodeDefinitionAr[i].addChild(CreateShadowLabel(label: labelDefinition,offset: 1))
                    totalWordsSoFar = totalWordsSoFar + countWords
                    if breakEarly == true {
                        break
                    }
                }
            }
            
            choiceboxDefinitionAr.append(SKShapeNode(rectOf: CGSize(width: self.size.width/1.85,height: self.size.height*7/48)))
            choiceboxDefinitionAr[i].name = "choicebox" + String(i)
            choiceboxDefinitionAr[i].fillColor = global.greyBlue
            choiceboxDefinitionAr[i].strokeColor = SKColor.purple
            choiceboxDefinitionAr[i].position = .zero
            nodeDefinitionAr[i].addChild(choiceboxDefinitionAr[i])
            
            //hidden circle to expand clickable area
//            circleDefinitionAr2.append(SKShapeNode(circleOfRadius: 11.0))
//            circleDefinitionAr2[i].name = "choicecircle" + String(i)
//            circleDefinitionAr2[i].fillColor = SKColor(red: 234/255, green: 230/255, blue: 236/255, alpha: 1)
//            circleDefinitionAr2[i].strokeColor = SKColor(red: 234/255, green: 230/255, blue: 236/255, alpha: 1)
//            circleDefinitionAr2[i].lineWidth = 2
//            circleDefinitionAr2[i].position = CGPoint(x:0,y:self.size.height*2/24)
//            circleDefinitionAr2[i].zPosition = -1
//            nodeDefinitionAr[i].addChild(circleDefinitionAr2[i])
            
            circleDefinitionAr.append(SKShapeNode(circleOfRadius: 7.0))
            circleDefinitionAr[i].name = "choicecircle" + String(i)
            circleDefinitionAr[i].fillColor = SKColor.red
            circleDefinitionAr[i].strokeColor = SKColor.black
            circleDefinitionAr[i].lineWidth = 2
            circleDefinitionAr[i].position = CGPoint(x:0,y:self.size.height*2/24)
            nodeDefinitionAr[i].addChild(circleDefinitionAr[i])
            
            addChild(nodeDefinitionAr[i])
        }
    }
    
    func GetSentence() {
        let fileName = "Vocabulary" + global.currentGrade
        
        if let path = Bundle.main.path(forResource: fileName, ofType: "txt") {
            let fileText = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
            var lineAr = fileText.components(separatedBy: .newlines)
            
            //vocabularyWord = lineAr[global.currentSentenceNum*2]
            vocabularyWord = lineAr[global.vocabularyConnectNum*2]
            //vocabularyDefinition = lineAr[global.currentSentenceNum*2 + 1]
            vocabularyDefinition = lineAr[global.vocabularyConnectNum*2 + 1]
            global.currentSentenceNum = global.currentSentenceNum + 1
            global.vocabularyConnectNum = global.vocabularyConnectNum + 1
            //vocabularyWord1 = lineAr[global.currentSentenceNum*2]
            vocabularyWord1 = lineAr[global.vocabularyConnectNum*2]
            //vocabularyDefinition1 = lineAr[global.currentSentenceNum*2 + 1]
            vocabularyDefinition1 = lineAr[global.vocabularyConnectNum*2 + 1]
            global.currentSentenceNum = global.currentSentenceNum + 1
            global.vocabularyConnectNum = global.vocabularyConnectNum + 1
            //vocabularyWord2 = lineAr[global.currentSentenceNum*2]
            vocabularyWord2 = lineAr[global.vocabularyConnectNum*2]
            //vocabularyDefinition2 = lineAr[global.currentSentenceNum*2 + 1]
            vocabularyDefinition2 = lineAr[global.vocabularyConnectNum*2 + 1]
            global.currentSentenceNum = global.currentSentenceNum + 1
            global.vocabularyConnectNum = global.vocabularyConnectNum + 1
            
            vocabularyWordAr.append(vocabularyWord)
            vocabularyWordAr.append(vocabularyWord1)
            vocabularyWordAr.append(vocabularyWord2)
            
            let rand = Int(arc4random_uniform(6))
            switch rand {
            case 0:
                correctAnswerAr.append(0)
                correctAnswerAr.append(1)
                correctAnswerAr.append(2)
                vocabularyDefinitionAr.append(vocabularyDefinition)
                vocabularyDefinitionAr.append(vocabularyDefinition1)
                vocabularyDefinitionAr.append(vocabularyDefinition2)
            case 1:
                correctAnswerAr.append(0)
                correctAnswerAr.append(2)
                correctAnswerAr.append(1)
                vocabularyDefinitionAr.append(vocabularyDefinition)
                vocabularyDefinitionAr.append(vocabularyDefinition2)
                vocabularyDefinitionAr.append(vocabularyDefinition1)
            case 2:
                correctAnswerAr.append(1)
                correctAnswerAr.append(0)
                correctAnswerAr.append(2)
                vocabularyDefinitionAr.append(vocabularyDefinition1)
                vocabularyDefinitionAr.append(vocabularyDefinition)
                vocabularyDefinitionAr.append(vocabularyDefinition2)
            case 3:
                correctAnswerAr.append(2)
                correctAnswerAr.append(0)
                correctAnswerAr.append(1)
                vocabularyDefinitionAr.append(vocabularyDefinition1)
                vocabularyDefinitionAr.append(vocabularyDefinition2)
                vocabularyDefinitionAr.append(vocabularyDefinition)
            case 4:
                correctAnswerAr.append(1)
                correctAnswerAr.append(2)
                correctAnswerAr.append(0)
                vocabularyDefinitionAr.append(vocabularyDefinition2)
                vocabularyDefinitionAr.append(vocabularyDefinition)
                vocabularyDefinitionAr.append(vocabularyDefinition1)
            case 5:
                correctAnswerAr.append(2)
                correctAnswerAr.append(1)
                correctAnswerAr.append(0)
                vocabularyDefinitionAr.append(vocabularyDefinition2)
                vocabularyDefinitionAr.append(vocabularyDefinition1)
                vocabularyDefinitionAr.append(vocabularyDefinition)
            default:
                correctAnswerAr.append(0)
                correctAnswerAr.append(1)
                correctAnswerAr.append(2)
                vocabularyDefinitionAr.append(vocabularyDefinition)
                vocabularyDefinitionAr.append(vocabularyDefinition1)
                vocabularyDefinitionAr.append(vocabularyDefinition2)
            }
        }
        else {
            print("file not found")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        let touchLocation = touch.location(in: self)
        let touchedNode = self.atPoint(touchLocation)
        
        if let myNode = touchedNode as? SKNode {
            if (myNode.name?.contains("choice")) != nil  && (myNode.name?.contains("choice"))!  {
                if let numChar = myNode.name?.last {
                    if let num = Int(String(numChar)) {
                        if num >= 0 && num < 3 {
                            fingerDown = true
                            definitionChosen = num
                            startLocation = CGPoint(x:nodeDefinitionAr[num].position.x + circleDefinitionAr[num].position.x,
                                                    y:nodeDefinitionAr[num].position.y + circleDefinitionAr[num].position.y)
                        }
                    }
                }
            }
            if (myNode.name?.contains("word")) != nil  && (myNode.name?.contains("word"))!  {
                if let numChar = myNode.name?.last {
                    if let num = Int(String(numChar)) {
                        if num >= 0 && num < 3 {
                            fingerDown = true
                            wordChosen = num
                            startLocation = CGPoint(x:nodeWordAr[num].position.x + circleWordAr[num].position.x,
                                                    y:nodeWordAr[num].position.y + circleWordAr[num].position.y)
                        }
                    }
                }
            }
        }
        if fingerDown == true {
            var playSound = SKAction.playSoundFileNamed("Star1.wav", waitForCompletion: false)
            if global.soundOption > 0 {
                playSound = SKAction.wait(forDuration: 0.0001)
            }
            self.run(SKAction.sequence([playSound]))
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        var location = touch.location(in: self)
        let touchedNode = self.atPoint(location)
        let prevLocation = touch.previousLocation(in: self)
        
        let moveAmount = CGPoint(x:location.x - prevLocation.x,y:location.y-prevLocation.y)
        line.removeFromParent()
        
        var lineConnected = false
        if fingerDown {
            if let myNode = touchedNode as? SKNode {
                if wordChosen > -1 {
                    if (myNode.name?.contains("choice")) != nil  && (myNode.name?.contains("choice"))!  {
                        if let numChar = myNode.name?.last {
                            if let num = Int(String(numChar)) {
                                if num >= 0 && num < 3 {
                                    location = CGPoint(x:nodeDefinitionAr[num].position.x + circleDefinitionAr[num].position.x,
                                                            y:nodeDefinitionAr[num].position.y + circleDefinitionAr[num].position.y)
                                }
                            }
                        }
                    }
                }
                if definitionChosen > -1 {
                    if (myNode.name?.contains("word")) != nil  && (myNode.name?.contains("word"))!  {
                        if let numChar = myNode.name?.last {
                            if let num = Int(String(numChar)) {
                                if num >= 0 && num < 3 {
                                    location = CGPoint(x:nodeWordAr[num].position.x + circleWordAr[num].position.x,
                                                            y:nodeWordAr[num].position.y + circleWordAr[num].position.y)
                                }
                            }
                        }
                    }
                }
            }
            var points = [startLocation,location]
            line = SKShapeNode(points: &points, count: points.count)
            line.position = .zero
            line.strokeColor = SKColor.red
            line.isAntialiased = true
            line.lineWidth = 4
            line.fillColor = SKColor.red
            self.addChild(line)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 1 - Choose one of the touches to work with
        guard let touch = touches.first else {
            return
        }
        
        var location = touch.location(in: self)
        let touchedNode = self.atPoint(location)
        
        var lineConnected = false
        if fingerDown {
            if let myNode = touchedNode as? SKNode {
                if wordChosen > -1 {
                    if (myNode.name?.contains("choice")) != nil  && (myNode.name?.contains("choice"))!  {
                        if let numChar = myNode.name?.last {
                            if let num = Int(String(numChar)) {
                                if num >= 0 && num < 3 {
                                    lineConnected = true
                                    definitionChosen = num
                                    location = CGPoint(x:nodeDefinitionAr[num].position.x +             circleDefinitionAr[num].position.x,
                                                       y:nodeDefinitionAr[num].position.y + circleDefinitionAr[num].position.y)
                                }
                            }
                        }
                    }
                }
                if definitionChosen > -1 {
                    if (myNode.name?.contains("word")) != nil  && (myNode.name?.contains("word"))!  {
                        if let numChar = myNode.name?.last {
                            if let num = Int(String(numChar)) {
                                if num >= 0 && num < 3 {
                                    lineConnected = true
                                    wordChosen = num
                                    location = CGPoint(x:nodeWordAr[num].position.x + circleWordAr[num].position.x,
                                                       y:nodeWordAr[num].position.y + circleWordAr[num].position.y)
                                }
                            }
                        }
                    }
                }
            }
            
            if lineConnected == true && wordChosen > -1 {
                var points = [startLocation,location]
                let line = SKShapeNode(points: &points, count: points.count)
                line.position = .zero
                line.strokeColor = SKColor.red
                line.isAntialiased = true
                line.lineWidth = 4
                line.fillColor = SKColor.red
                
                self.addChild(line)
                
                lineAr[wordChosen].removeFromParent()
                for i in 0...2 {
                    if lineConnections[i] == definitionChosen {
                        lineAr[i].removeFromParent()
                        lineConnections[i] = -1
                    }
                }
                lineAr[wordChosen] = line
                lineConnections[wordChosen] = definitionChosen
                
                if lineConnections[0] > -1 && lineConnections[1] > -1 && lineConnections[2] > -1 {
                    CheckAnswer()
                }
                var playSound = SKAction.playSoundFileNamed("Star3.wav", waitForCompletion: false)
                if global.soundOption > 0 {
                    playSound = SKAction.wait(forDuration: 0.0001)
                }
                self.run(SKAction.sequence([playSound]))
            }
        }
        
        line.removeFromParent()
        wordChosen = -1
        definitionChosen = -1
        
        fingerDown = false
        if let shapeNode = touchedNode as? SKNode {
            if shapeNode.name?.contains("backbutton") != nil && (shapeNode.name?.contains("backbutton"))!  {
                TransitionBackFromScene(myScene: self)
            }
        }
    }
    
    func TransitionScene(playSound: SKAction,duration: Double) {
        for child in global.overlayNode.children {
            child.removeFromParent()
        }
        global.overlayNode.removeFromParent()
        let wait = SKAction.wait(forDuration: duration)
        
        let newScene = SKAction.run({
            let reveal = SKTransition.reveal(with:SKTransitionDirection.left, duration:1.0)
            
            if (global.currentSentenceNum % 12) < 9 {
                let nextScene = VocabularyConnectScene(size: self.size,currentSentenceNum:global.currentSentenceNum,correctAnswers:global.correctAnswers,incorrectAnswers:global.incorrectAnswers,currentExtraWordNum:self.currentExtraWordNum,sceneType:global.sceneType)
                self.view?.presentScene(nextScene, transition: reveal)
            }
            else {
                let nextScene = VocabularySelectScene(size: self.size,currentSentenceNum:global.currentSentenceNum,correctAnswers:global.correctAnswers,incorrectAnswers:global.incorrectAnswers,currentExtraWordNum:self.currentExtraWordNum,sceneType:global.sceneType)
                self.view?.presentScene(nextScene, transition: reveal)
            }
        })
        self.run(SKAction.sequence([playSound,wait,newScene]))
    }
    
    func CheckAnswer() {
        if lineConnections[0] == correctAnswerAr[0] && lineConnections[1] == correctAnswerAr[1] && lineConnections[2] == correctAnswerAr[2] {
            CorrectAnswerSelected()
        }
        else {
            IncorrectAnswerSelected()
        }
    }
    
    func CorrectAnswerSelected() {
        labelInstr.text = "Answer Is Correct!!!"
        labelInstr.fontColor = SKColor.blue
        labelInstr.fontSize = 30
        labelInstrShadow.text = "Answer Is Correct!!!"
        labelInstrShadow.fontSize = 30
        
        global.correctAnswers = global.correctAnswers + 1
        labelCorrect.text = "Correct : " + String(global.correctAnswers)
        labelCorrectShadow.text = "Correct : " + String(global.correctAnswers)
        
        if global.correctAnswers + global.incorrectAnswers >= 12 {
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
        for line in lineAr {
            line.removeFromParent()
        }
        
        for i in 0...2 {
            let connect = correctAnswerAr[i]
            let wordCirclePos = CGPoint(x:nodeWordAr[i].position.x + circleWordAr[i].position.x,
                                        y:nodeWordAr[i].position.y + circleWordAr[i].position.y)
            let defCirclePos = CGPoint(x:nodeDefinitionAr[connect].position.x + circleDefinitionAr[connect].position.x,
                                       y:nodeDefinitionAr[connect].position.y + circleDefinitionAr[connect].position.y)
            var points = [wordCirclePos,defCirclePos]
            let line = SKShapeNode(points: &points, count: points.count)
            line.position = .zero
            line.strokeColor = SKColor.red
            line.isAntialiased = true
            line.lineWidth = 4
            line.fillColor = SKColor.red
            self.addChild(line)
        }
        
        labelInstr.text = "Incorrect, the correct answer is:"
        labelInstrShadow.text = "Incorrect, the correct answer is:"
        labelInstrShadow.fontSize = 24
        labelInstr.fontColor = SKColor.red
        labelInstr.fontSize = 24
        
        global.incorrectAnswers = global.incorrectAnswers + 1
        labelIncorrect.text = "Missed : " + String(global.incorrectAnswers)
        labelIncorrectShadow.text = "Missed : " + String(global.incorrectAnswers)
        
        if global.correctAnswers + global.incorrectAnswers >= 12 {
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

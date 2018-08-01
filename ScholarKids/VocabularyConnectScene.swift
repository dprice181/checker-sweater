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
    
    var answerSelected = false
    
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
        
        DrawTitle()
        DrawInstructions()
        DrawScoreNode()
        DrawWords()
        DrawDefinitions()
        DrawBackButton(scene:self)
    }
    
    func DrawTitle() {
        let fullTitle = SKNode()
        fullTitle.position = CGPoint(x: self.size.width/2, y: self.size.height*8.87/10)
        fullTitle.zPosition = 100.0
        
        labelTitle.text = "VOCABULARY"
        labelTitle.fontSize = GetFontSize(size:47)
        labelTitle.fontColor = SKColor.red
        labelTitle.position = .zero
        labelTitle.zPosition = 100.0
        fullTitle.addChild(labelTitle)
        labelTitleShadow = CreateShadowLabel(label: labelTitle,offset: GetFontSize(size:1))
        fullTitle.addChild(labelTitleShadow)
        
        labelSubtitle.text = "Level " + String(global.currentLevel)
        labelSubtitle.fontSize = GetFontSize(size:45)
        labelSubtitle.fontColor = SKColor.red
        labelSubtitle.position = CGPoint(x: 0, y: -self.size.height/18)
        labelSubtitle.zPosition = 100.0
        fullTitle.addChild(labelSubtitle)
        labelSubtitleShadow = CreateShadowLabel(label: labelSubtitle,offset: GetFontSize(size:1))
        fullTitle.addChild(labelSubtitleShadow)
        addChild(fullTitle)
    }
    
    func DrawInstructions() {
        labelInstr.text = "Connect the 3 words to their definitions."
        labelInstr.fontSize = GetFontSize(size:19)
        labelInstr.fontColor = global.realPurple
        labelInstr.position = CGPoint(x: self.size.width/2, y: self.size.height*18.5/24)
        labelInstr.zPosition = 100.0
        addChild(labelInstr)
        labelInstrShadow = CreateShadowLabel(label: labelInstr,offset: GetFontSize(size:1))
        addChild(labelInstrShadow)
    }
    
    func DrawScoreNode() {
        let scoreNode = SKNode()
        scoreNode.position = CGPoint(x: self.size.width/7, y: self.size.height/36)
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
    
    func DrawWords() {
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
            labelWord.fontSize = GetFontSize(size:SELECTTEXT_FONTSIZE+5.0 - CGFloat(fontSizeRed))
            labelWord.fontColor = global.blue
            labelWord.position = .zero
            labelWord.zPosition = 100.0
            labelWord.name = "wordlabel" + String(i)
            nodeWordAr[i].addChild(labelWord)
            nodeWordAr[i].addChild(CreateShadowLabel(label: labelWord,offset: GetFontSize(size:1)))        
            
            circleWordAr.append(SKShapeNode(circleOfRadius: GetFontSize(size:7.0)))
            circleWordAr[i].name = "wordcircle" + String(i)
            circleWordAr[i].fillColor = SKColor.red
            circleWordAr[i].strokeColor = SKColor.black
            circleWordAr[i].lineWidth = 2
            circleWordAr[i].position = CGPoint(x:0,y:self.size.height*1/24)
            nodeWordAr[i].addChild(circleWordAr[i])
            addChild(nodeWordAr[i])
        }
    }
    
    func DrawDefinitions() {
        let displayWidth = size.width * 5.6 / 10
        for i in 0...2  {
            let sizeSentence = GetTextSize(text:vocabularyDefinitionAr[i],fontSize:SELECTTEXT_FONTSIZE)            
            let sentenceWidth = sizeSentence.width
            
            nodeDefinitionAr.append(SKNode())
            nodeDefinitionAr[i].position = CGPoint(x: self.size.width*0.67, y: self.size.height*(15-5.5 * CGFloat(i))/24)
            nodeDefinitionAr[i].zPosition = 100.0
            nodeDefinitionAr[i].name = "choicenode" + String(i)
            
            if sentenceWidth < displayWidth {
                let labelDefinition = SKLabelNode(fontNamed: "Arial")
                labelDefinition.text = vocabularyDefinitionAr[i]
                labelDefinition.fontSize = GetFontSize(size:SELECTTEXT_FONTSIZE-1.0)
                labelDefinition.fontColor = global.lightBlue
                labelDefinition.position = .zero
                labelDefinition.zPosition = 100.0
                labelDefinition.name = "choicelabel" + String(i)
                nodeDefinitionAr[i].addChild(labelDefinition)
                nodeDefinitionAr[i].addChild(CreateShadowLabel(label: labelDefinition,offset: GetFontSize(size:1)))
            }
            else {  //multi-line definition
                var curX : CGFloat = 0
                var offY : CGFloat = 0
                var offset : CGFloat = GetDefinitionOffset(definition:vocabularyDefinitionAr[i],displayWidth:displayWidth)
                wordAr = vocabularyDefinitionAr[i].characters.split{$0 == " "}.map(String.init)
                var lineString = ""
                for word in wordAr {
                    let sizeWord = GetTextSize(text:word + " ",fontSize:SELECTTEXT_FONTSIZE-1.0)
                    if curX + sizeWord.width > displayWidth {
                        //next line
                        DrawDefinitionLine(definition:lineString,i:i,offY:offY+offset)
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
                    DrawDefinitionLine(definition:lineString,i:i,offY:offY+offset)
                }
            }
            
            DrawDefinitionBoxAndCircle(i:i)
            addChild(nodeDefinitionAr[i])
        }
    }
    
    func GetDefinitionOffset(definition:String,displayWidth:CGFloat) -> CGFloat {
        var offset : CGFloat = 0
        var numLines = 1
        //get numLines
        var curX : CGFloat = 0
        wordAr = definition.characters.split{$0 == " "}.map(String.init)
        var sizeWord = GetTextSize(text:"best ",fontSize:SELECTTEXT_FONTSIZE-1.0)  //get line height
        for word in wordAr {
            sizeWord = GetTextSize(text:word + " ",fontSize:SELECTTEXT_FONTSIZE-1.0)
            if curX + sizeWord.width > displayWidth {
                //next line
                numLines = numLines + 1
                curX = 0
            }
            curX = curX + sizeWord.width
        }
        if numLines == 2 {
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
        if numLines == 6 {
            offset = sizeWord.height * 2.15
        }
        if numLines >= 7 {
            offset = sizeWord.height * 2.6
        }
        return offset
    }
    
    func DrawDefinitionLine(definition:String,i:Int,offY:CGFloat) {
        let labelDefinition = SKLabelNode(fontNamed: "Arial")
        labelDefinition.text = definition
        labelDefinition.fontSize = GetFontSize(size:SELECTTEXT_FONTSIZE-1.0)
        labelDefinition.fontColor = global.lightBlue
        labelDefinition.position = CGPoint(x: 0,y: offY)
        labelDefinition.zPosition = 100.0
        labelDefinition.name = "choicelabel" + String(i)
        nodeDefinitionAr[i].addChild(labelDefinition)
        nodeDefinitionAr[i].addChild(CreateShadowLabel(label: labelDefinition,offset: GetFontSize(size:1)))
    }
    
    func DrawDefinitionBoxAndCircle(i:Int) {
        choiceboxDefinitionAr.append(SKShapeNode(rectOf: CGSize(width: self.size.width/1.75,height: self.size.height*49/288)))
        choiceboxDefinitionAr[i].name = "choicebox" + String(i)
        choiceboxDefinitionAr[i].fillColor = global.greyBlue
        choiceboxDefinitionAr[i].strokeColor = SKColor.purple
        choiceboxDefinitionAr[i].position = .zero
        nodeDefinitionAr[i].addChild(choiceboxDefinitionAr[i])
        
        circleDefinitionAr.append(SKShapeNode(circleOfRadius: GetFontSize(size:7.0)))
        circleDefinitionAr[i].name = "choicecircle" + String(i)
        circleDefinitionAr[i].fillColor = SKColor.red
        circleDefinitionAr[i].strokeColor = SKColor.black
        circleDefinitionAr[i].lineWidth = 2
        circleDefinitionAr[i].position = CGPoint(x:0,y:self.size.height*2.3/24)
        nodeDefinitionAr[i].addChild(circleDefinitionAr[i])
    }
    
    func GetVocabularyFilename() -> String {
        if let grade = Int(global.currentGrade) {
            if grade > 8 {
                return "Vocabulary8"
            }
        }
        return "Vocabulary" + global.currentGrade
    }
    
    func GetSentence() {
        let fileName = GetVocabularyFilename()
        
        if let path = Bundle.main.path(forResource: fileName, ofType: "txt") {
            let fileText = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
            var lineAr = fileText.components(separatedBy: .newlines)
            global.currentSentenceNum = global.currentSentenceNum % (lineAr.count/2)
            
            vocabularyWord = lineAr[global.currentSentenceNum*2]
            //vocabularyWord = lineAr[global.vocabularyConnectNum*2]
            vocabularyDefinition = lineAr[global.currentSentenceNum*2 + 1]
            //vocabularyDefinition = lineAr[global.vocabularyConnectNum*2 + 1]
            global.currentSentenceNum = (global.currentSentenceNum + 1) % (lineAr.count/2)  //wrap around at eof
            global.vocabularyConnectNum = (global.vocabularyConnectNum + 1) % (lineAr.count/2)  //wrap around at eof
            vocabularyWord1 = lineAr[global.currentSentenceNum*2]
            //vocabularyWord1 = lineAr[global.vocabularyConnectNum*2]
            vocabularyDefinition1 = lineAr[global.currentSentenceNum*2 + 1]
            //vocabularyDefinition1 = lineAr[global.vocabularyConnectNum*2 + 1]
            global.currentSentenceNum = (global.currentSentenceNum + 1) % (lineAr.count/2)  //wrap around at eof
            global.vocabularyConnectNum = (global.vocabularyConnectNum + 1) % (lineAr.count/2)  //wrap around at eof
            vocabularyWord2 = lineAr[global.currentSentenceNum*2]
            //vocabularyWord2 = lineAr[global.vocabularyConnectNum*2]
            vocabularyDefinition2 = lineAr[global.currentSentenceNum*2 + 1]
            //vocabularyDefinition2 = lineAr[global.vocabularyConnectNum*2 + 1]
            global.currentSentenceNum = (global.currentSentenceNum + 1) % (lineAr.count/2)  //wrap around at eof
            global.vocabularyConnectNum = (global.vocabularyConnectNum + 1) % (lineAr.count/2)  //wrap around at eof
            
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
        guard let touch = touches.first else {
            return
        }
        if answerSelected {
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
        global.overlayNode.removeAllActions()
        global.overlayNode.removeAllChildren()
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
        labelInstrShadow.fontSize = GetFontSize(size:24)
        labelInstr.fontColor = SKColor.red
        labelInstr.fontSize = GetFontSize(size:24)
        
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
}

//
//  WordDragScene.swift
//  ScholarKids
//
//  Created by Doug Price on 5/21/18.
//  Copyright © 2018 Doug Price. All rights reserved.
//

import SpriteKit
import GameplayKit

class SpellingDragScene: SKScene {
    let SELECTTEXT_FONTSIZE : CGFloat = 45.0
    let SELECTTEXT_FONTSIZE_DEFINITION : CGFloat = 20.0
    let SELECTTEXT_FONTSIZE_CHOICE : CGFloat = 17.0
    
    var labelSpaceAr = [SKLabelNode]()
    var correctAnswerAr : [Int]  = []
    var wordAr : [String] = []
    var sentenceDataAr : [String] = []
    let labelTitle = SKLabelNode(fontNamed: "MarkerFelt-Thin")
    let labelSubtitle = SKLabelNode(fontNamed: "MarkerFelt-Thin")
    let labelInstr = SKLabelNode(fontNamed: "Arial")
    let labelInstr2 = SKLabelNode(fontNamed: "Arial")
    var labelInstrShadow = SKLabelNode(fontNamed: "Arial")
    var labelInstrShadow2 = SKLabelNode(fontNamed: "Arial")
    let labelCorrect = SKLabelNode(fontNamed: "Arial")
    var labelCorrectShadow = SKLabelNode(fontNamed: "Arial")
    let labelIncorrect = SKLabelNode(fontNamed: "Arial")
    var labelIncorrectShadow = SKLabelNode(fontNamed: "Arial")
    let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
    var sentence = ""
    var choiceWordAr = [String]()
    var selectedNode = SKSpriteNode()
    
    var answerboxPos = CGPoint(x:0,y:0)
    var currentExtraWordNum = 0
    var sentenceData = ""
    
    var answerPos = 0
    var choiceMade = false
    var background = SKSpriteNode(imageNamed: "background4.png")
    
    var emptyCorrectAnswer = 0
    var answerSelected = false
    
    var spellingDefinition = ""
    var spellingPartsRandomAr = [String]()
    var spellingWord = ""
    var spellingWordMissingPart = ""
    var spellingPartsAr = [String]()
    var correctAnswer = 0
    var underlineString = ""
    
    var labelSpellingWord = SKLabelNode()
    let nodeDefinition = SKNode()
    
    init(size: CGSize, currentSentenceNum:Int, correctAnswers:Int, incorrectAnswers:Int, currentExtraWordNum:Int,sceneType:String) {
        super.init(size: size)
        
        self.currentExtraWordNum = currentExtraWordNum
        global.sceneType = sceneType
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        backgroundColor = SKColor(red: 234/255, green: 230/255, blue: 236/255, alpha: 1)
        
        InitLetterStrings()
        GetSentence(increment:true)
        DrawTitle()
        DrawScoreNode()
        DrawChoiceBoxes()
        DrawSpellingWord()
        DrawSpellingDefinition()
        DrawBackground()
        DrawBackButton()
    }
    
    func GetUnderlinePos(word:String) -> CGFloat {
        var i = 0
        for char in word {
            i = i + 1
            if char == "_" {
                break
            }
        }
        return CGFloat(i)
    }
    
    func GetFirstPartOfWord(word:String) -> String {
        var returnStr = ""
        for char in word {
            returnStr = returnStr + String(char)
            if char == "_" {
                break
            }
        }
        return returnStr
    }
    
    func DrawSpellingWord() {
        let wordFirstPart = GetFirstPartOfWord(word:spellingWordMissingPart)
        
        let myWord: NSString = spellingWordMissingPart as NSString
        let sizeWord: CGSize = myWord.size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: SELECTTEXT_FONTSIZE)])
        let widthWord = sizeWord.width
        
        let myWordFirst: NSString = wordFirstPart as NSString
        let sizeWordFirst: CGSize = myWordFirst.size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: SELECTTEXT_FONTSIZE)])
        let widthWordFirst = sizeWordFirst.width
        let offX =  -widthWord/2 + widthWordFirst
        
        labelSpellingWord = SKLabelNode(fontNamed: "Arial")
        labelSpellingWord.zPosition = 100.0
        labelSpellingWord.name = "word"
        labelSpellingWord.text = spellingWordMissingPart
        labelSpellingWord.fontSize = SELECTTEXT_FONTSIZE
        labelSpellingWord.fontColor = global.purple
        labelSpellingWord.position = CGPoint(x: self.size.width/2, y: self.size.height * 10.5 / 24)
        addChild(labelSpellingWord)
        addChild(CreateShadowLabel(label: labelSpellingWord,offset: 1))
        
        let answerBoxNode = SKSpriteNode()
        answerBoxNode.position = CGPoint(x: offX + size.width/2, y: sizeWord.height/2 + self.size.height * 10.5 / 24)
        answerBoxNode.name = "answerbox"
        answerBoxNode.physicsBody = SKPhysicsBody(rectangleOf: sizeWord)
        answerBoxNode.physicsBody?.isDynamic = true
        answerBoxNode.physicsBody?.categoryBitMask = PhysicsCategory.answerbox
        answerBoxNode.physicsBody?.contactTestBitMask = PhysicsCategory.choicebox
        answerBoxNode.physicsBody?.collisionBitMask = PhysicsCategory.none
        answerBoxNode.physicsBody?.usesPreciseCollisionDetection = true
        
        let myUnderline: NSString = underlineString as NSString
        let sizeUnderline: CGSize = myUnderline.size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: SELECTTEXT_FONTSIZE+5)])
        let sizeBox = CGSize(width:sizeUnderline.width,height:sizeUnderline.height*0.75)
        let box = SKShapeNode(rectOf: sizeBox,cornerRadius: 20.0)
        box.name = "answerboxrect"
        box.fillColor = SKColor.lightGray
        box.strokeColor = SKColor.red
        box.position = .zero
        answerBoxNode.addChild(box)
        addChild(answerBoxNode)
    }
    
    func DrawDefinition(definition:String,i:Int,incorrectAnswer:Bool,pos:CGPoint) {
        var fontColor = global.lightBlue
        var fontSize = SELECTTEXT_FONTSIZE_DEFINITION
        
        let position = pos
        let displayWidth = size.width * 9.25 / 10
        let sizeSentence = GetTextSize(text:definition,fontSize:fontSize)
        let sentenceWidth = sizeSentence.width
        
        nodeDefinition.position = position
        nodeDefinition.zPosition = 100.0
        nodeDefinition.name = "definitionnode" + String(i)
        
        if sentenceWidth < displayWidth {
            if incorrectAnswer && global.sceneType=="Spelling" {
                fontSize = 28
            }
            let labelDefinition = SKLabelNode(fontNamed: "Arial")
            labelDefinition.text = definition
            labelDefinition.fontSize = fontSize
            labelDefinition.fontColor = fontColor
            labelDefinition.position = .zero
            labelDefinition.zPosition = 100.0
            labelDefinition.name = "definitionlabel" + String(i)
            nodeDefinition.addChild(labelDefinition)
            nodeDefinition.addChild(CreateShadowLabel(label: labelDefinition,offset: 1))
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
        let labelDefinition = SKLabelNode(fontNamed: "Arial")
        labelDefinition.text = definition
        labelDefinition.fontSize = fontSize
        labelDefinition.fontColor = fontColor
        labelDefinition.position = CGPoint(x: 0,y: offY)
        labelDefinition.zPosition = 100.0
        labelDefinition.name = "definitionlabel" + String(i)
        nodeDefinition.addChild(labelDefinition)
        nodeDefinition.addChild(CreateShadowLabel(label: labelDefinition,offset: 1))
    }
    
    func DrawSpellingDefinition() {
        spellingDefinition = "(" + spellingDefinition + ")"
        DrawDefinition(definition:spellingDefinition,i:0,incorrectAnswer:false,pos:CGPoint(x: self.size.width/2, y: self.size.height*8.5/24))
        addChild(nodeDefinition)
    }
    
    func DrawChoiceBoxes() {
        var posX = self.size.width/6
        //add three choice boxes
        for n in 0...2 {
            var correctWord = spellingPartsRandomAr[n]
            let myWord: NSString = correctWord + "    " as NSString
            var sizeWordChoice: CGSize = myWord.size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: SELECTTEXT_FONTSIZE_CHOICE)])
            sizeWordChoice.width = sizeWordChoice.width * 1.6
            sizeWordChoice.height = sizeWordChoice.height * 2.0
            
            //parent node with physics body for collision
            let choiceNode = SKSpriteNode()
            choiceNode.position = CGPoint(x: posX, y: self.size.height * 14.5 / 24)
            choiceNode.zPosition = 100.0
            choiceNode.name = "choice" + String(n)
            choiceNode.physicsBody = SKPhysicsBody(rectangleOf: sizeWordChoice)
            choiceNode.physicsBody?.isDynamic = true
            choiceNode.physicsBody?.categoryBitMask = PhysicsCategory.choicebox
            choiceNode.physicsBody?.contactTestBitMask = PhysicsCategory.answerbox
            choiceNode.physicsBody?.collisionBitMask = PhysicsCategory.none
            choiceNode.physicsBody?.usesPreciseCollisionDetection = true
            
            correctWord = correctWord.replacingOccurrences(of: ".", with: "")
            let labelChoice = SKLabelNode(fontNamed: "Arial")
            labelChoice.zPosition = 100.0
            labelChoice.name = "choicelabel"
            labelChoice.text = correctWord.lowercased()
            labelChoice.fontSize = SELECTTEXT_FONTSIZE_CHOICE
            labelChoice.fontColor = SKColor.white
            labelChoice.horizontalAlignmentMode = .center
            labelChoice.position = CGPoint(x:  0, y: -sizeWordChoice.height/4)
            choiceNode.addChild(labelChoice)
            choiceNode.addChild(CreateShadowLabel(label: labelChoice,offset: 1))
            
            let boxChoice = SKSpriteNode(imageNamed: "RedButtonBig.png")
            boxChoice.name = "choicebox"
            boxChoice.position = .zero
            boxChoice.scale(to: sizeWordChoice)
            choiceNode.addChild(boxChoice)
            addChild(choiceNode)
            
            posX = posX + self.size.width*2/6
        }
    }
    
    func DrawTitle() {
        let fullTitle = SKNode()
        fullTitle.position = CGPoint(x: self.size.width/2, y: self.size.height*21/24)
        fullTitle.zPosition = 100.0
        
        labelTitle.text = "SPELLING"
        labelTitle.fontSize = 55
        labelTitle.fontColor = SKColor.red
        labelTitle.position = .zero
        labelTitle.zPosition = 100.0
        fullTitle.addChild(labelTitle)
        let labelTitleShadow = CreateShadowLabel(label: labelTitle,offset: 1)
        fullTitle.addChild(labelTitleShadow)
        
        labelSubtitle.text = "Level " + String(global.currentLevel)
        labelSubtitle.fontSize = 45
        labelSubtitle.fontColor = SKColor.red
        labelSubtitle.position = CGPoint(x: 0, y: -self.size.height/12)
        labelSubtitle.zPosition = 100.0
        fullTitle.addChild(labelSubtitle)
        let labelSubtitleShadow = CreateShadowLabel(label: labelSubtitle,offset: 1)
        fullTitle.addChild(labelSubtitleShadow)
        
        addChild(fullTitle)
        
        labelInstr.text = "Drag the correct spelling"
        labelInstr.fontSize = 25
        labelInstr.fontColor = SKColor.purple
        labelInstr.position = CGPoint(x: self.size.width/2, y: self.size.height*17.5/24)
        labelInstr.zPosition = 100.0
        addChild(labelInstr)
        labelInstrShadow = CreateShadowLabel(label: labelInstr,offset: 1)
        addChild(labelInstrShadow)
        
        labelInstr2.text = "to the sentence below."
        labelInstr2.fontSize = 25
        labelInstr2.fontColor = SKColor.purple
        labelInstr2.position = CGPoint(x: self.size.width/2, y: self.size.height*16.5/24)
        labelInstr2.zPosition = 100.0
        addChild(labelInstr2)
        labelInstrShadow2 = CreateShadowLabel(label: labelInstr2,offset: 1)
        addChild(labelInstrShadow2)
    }
    
    func DrawScoreNode() {
        let scoreNode = SKNode()
        scoreNode.position = CGPoint(x: self.size.width/8, y: self.size.height/24)
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
    }
    
    func DrawBackground() {
        background.position = CGPoint(x: frame.size.width * 5 / 6, y: frame.size.height / 6)
        background.scale(to: CGSize(width: self.size.width/3, height: self.size.height/3))
        addChild(background)
    }
    
    func DrawBackButton() {
        let backButton = SKSpriteNode(imageNamed: "BackwardsClean.png")
        backButton.name = "backbutton"
        backButton.position = CGPoint(x: frame.size.width/20, y: self.size.height*18.5/20)
        backButton.scale(to: CGSize(width: self.size.width/10, height: self.size.width/10))
        addChild(backButton)
    }
    
    func GetVocabularyFilename() -> String {
        if let grade = Int(global.currentGrade) {
            if grade > 8 {
                return "Vocabulary8"
            }
        }
        return "Vocabulary" + global.currentGrade
    }
    
    func GetSentence(increment:Bool) {
        let fileName = GetVocabularyFilename()
        if let path = Bundle.main.path(forResource: fileName, ofType: "txt") {
            let fileText = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
            var lineAr = fileText.components(separatedBy: .newlines)
            global.currentSentenceNum = global.currentSentenceNum % lineAr.count
          
            spellingDefinition = lineAr[global.currentSentenceNum*2+1]
            spellingWord = lineAr[global.currentSentenceNum*2]
            spellingPartsAr = GetSpellingParts(word:spellingWord)
            underlineString = "__"
            
            spellingWordMissingPart = ReplaceFirstOccurence(myString: spellingWord,substring: spellingPartsAr[0],replaceStr: underlineString)
            correctAnswer = Int(arc4random_uniform(3))
            if correctAnswer==0  {
                spellingPartsRandomAr.append(spellingPartsAr[0])
            }
            spellingPartsRandomAr.append(spellingPartsAr[1])
            if correctAnswer==1  {
                spellingPartsRandomAr.append(spellingPartsAr[0])
            }
            spellingPartsRandomAr.append(spellingPartsAr[2])
            if correctAnswer==2  {
                spellingPartsRandomAr.append(spellingPartsAr[0])
            }
            
            global.currentSentenceNum = (global.currentSentenceNum + 1) % lineAr.count
        }
        else {
            print("file not found")
        }
    }
    
    func GetSpellingParts(word:String) -> [String] {
        var returnAr = [String]()
        var replacedLetterGroup = ""
        
        let start = Int(arc4random_uniform(UInt32(global.letterStrings.count)))
        for i in 0..<global.letterStrings.count {
            let ind = (start + i) % global.letterStrings.count
            let letterStringAr = global.letterStrings[ind]
            for letterGroup in letterStringAr {   //loop through until we find a replaceable group
                if word.contains(letterGroup) {  //found one
                    replacedLetterGroup = letterGroup
                    returnAr.append(replacedLetterGroup)
                    var i = 0
                    for letterGroup in letterStringAr {
                        //replace with another letterGroup in the Ar
                        if letterGroup == replacedLetterGroup {
                            continue
                        }
                        returnAr.append(letterGroup)
                        i = i + 1
                        if i >= 2 {
                            break
                        }
                    }
                    return returnAr
                }
            }
        }

        return returnAr  //should never get here
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        let touchLocation = touch.location(in: self)
        let touchedNode = self.atPoint(touchLocation)
        
        if choiceMade == false {
            selectedNode.position = touchLocation
        }
        else  {
            selectedNode.position = answerboxPos
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        if answerSelected {
            return
        }
        
        let touchLocation = touch.location(in: self)
        let touchedNode = self.atPoint(touchLocation)
        
        if touchedNode.name == "choicelabel" || touchedNode.name == "choicebox" {
            if touchedNode == nil || touchedNode.parent == nil {
                selectedNode = SKSpriteNode()
            }
            else {
                selectedNode = touchedNode.parent! as! SKSpriteNode
            }
        }
        else if touchedNode.name?.contains("choice") != nil && (touchedNode.name?.contains("choice"))! {
            if touchedNode == nil || touchedNode.parent == nil {
                selectedNode = SKSpriteNode()
            }
            else {
                selectedNode = touchedNode as! SKSpriteNode
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
        
        selectedNode = SKSpriteNode()
        
        let touchLocation = touch.location(in: self)
        let shapeNode = self.atPoint(touchLocation)
        
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
    
    func TransitionScene(playSound: SKAction,duration : TimeInterval) {
        global.overlayNode.removeAllActions()
        global.overlayNode.removeAllChildren()
        global.overlayNode.removeFromParent()
        let wait = SKAction.wait(forDuration: duration)
        
        let newScene = SKAction.run({
            let reveal = SKTransition.reveal(with:SKTransitionDirection.left, duration:1.0)
            if (global.currentSentenceNum % 6) < 3 {
                let nextScene = VocabularySelectScene(size: self.size,currentSentenceNum:global.currentSentenceNum,correctAnswers:global.correctAnswers,incorrectAnswers:global.incorrectAnswers,currentExtraWordNum:self.currentExtraWordNum,sceneType:global.sceneType)
                self.view?.presentScene(nextScene, transition: reveal)
            }
            else {
                let nextScene = SpellingDragScene(size: self.size,currentSentenceNum:global.currentSentenceNum,correctAnswers:global.correctAnswers,incorrectAnswers:global.incorrectAnswers,currentExtraWordNum:self.currentExtraWordNum,sceneType:global.sceneType)
                self.view?.presentScene(nextScene, transition: reveal)
            }
        })
        self.run(SKAction.sequence([playSound,wait,newScene]))
    }
    
    func CorrectAnswerSelected() {
        answerSelected = true
        
        labelInstr.text = "Answer Is Correct!!!"
        labelInstr.fontColor = global.blue
        labelInstr.fontSize = 30
        labelInstrShadow.text = "Answer Is Correct!!!"
        labelInstrShadow.fontSize = 30
        
        labelInstr2.removeFromParent()
        labelInstrShadow2.removeFromParent()
        
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
            TransitionScene(playSound:playSound,duration: 1.5)
        }
    }
    
    func IncorrectAnswerSelected() {
        answerSelected = true
        
        labelInstr.text = "Sorry, Answer Is Incorrect"
        labelInstr.fontColor = SKColor.red
        labelInstr.fontSize = 30
        labelInstrShadow.text = "Sorry, Answer Is Incorrect"
        labelInstrShadow.fontSize = 30
        
        labelInstr2.removeFromParent()
        labelInstrShadow2.removeFromParent()
        
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
            TransitionScene(playSound:playSound, duration: 4.0)
        }
    }
    
    func ChoiceBoxMovedToAnswerBox(choicebox: SKSpriteNode, answerbox: SKSpriteNode) {
        choiceMade = true
        answerboxPos = answerbox.position
        answerbox.removeFromParent()
        if choicebox.name == "choice" + String(correctAnswer) {
            CorrectAnswerSelected()
        }
        else {
            IncorrectAnswerSelected()
        }
    }
}

extension SpellingDragScene : SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }
        else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if ((firstBody.categoryBitMask & PhysicsCategory.answerbox != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.choicebox != 0)) {
            if let answerbox = firstBody.node as? SKSpriteNode,
                let choicebox = secondBody.node as? SKSpriteNode {
                ChoiceBoxMovedToAnswerBox(choicebox: choicebox, answerbox: answerbox)
            }
        }
    }
}



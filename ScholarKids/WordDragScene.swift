//
//  WordDragScene.swift
//  ScholarKids
//
//  Created by Doug Price on 5/21/18.
//  Copyright © 2018 Doug Price. All rights reserved.
//

import SpriteKit
import GameplayKit

struct PhysicsCategory {
    static let none      : UInt32 = 0
    static let all       : UInt32 = UInt32.max
    static let answerbox : UInt32 = 0b1       // 1
    static let choicebox : UInt32 = 0b10      // 2
}

class WordDragScene: SKScene {
    
    let SELECTTEXT_FONTSIZE : CGFloat = 17.0
    
    var labelAr = [SKLabelNode]()
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
    
    var levelMode = "n"
    var answerPos = 0    
    var choiceMade = false
    var background = SKSpriteNode(imageNamed: "background4.png")
    
    
    func GetSentence()
    {
        var fileName = "Sentences1"
        if global.sceneType == "Vocabulary" || global.sceneType == "Spelling" {
            fileName = "VocabularySentences1"
        }
        if let path = Bundle.main.path(forResource: fileName, ofType: "txt")
        {
            let fileText = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
            var lineAr = fileText.components(separatedBy: .newlines)
            lineAr.shuffle()  //FIX should be done once per launch, not per screen
            //while (lineAr[global.currentSentenceNum] == "") {
            var curSentenceNum = global.spellingDragNum
            if global.sceneType == "Grammar" {
                curSentenceNum = global.grammarDragNum
            }
            
            while (lineAr[curSentenceNum] == "") {
                global.currentSentenceNum = global.currentSentenceNum + 1
                if global.sceneType == "Spelling" {
                    global.spellingDragNum = global.spellingDragNum + 1
                    if global.spellingDragNum >= lineAr.count {
                        global.spellingDragNum = 0
                        break
                    }
                }
                else {  //Grammar
                    global.grammarDragNum = global.grammarDragNum + 1
                    if global.grammarDragNum >= lineAr.count {
                        global.grammarDragNum = 0
                        break
                    }
                }
                if global.currentSentenceNum >= lineAr.count {
                    global.currentSentenceNum = 0
                    break
                }
                
            }
            
            curSentenceNum = global.spellingDragNum
            if global.sceneType == "Grammar" {
                curSentenceNum = global.grammarDragNum
            }
            let sentenceAr = lineAr[curSentenceNum].characters.split{$0 == "*"}.map(String.init)
            
            sentence = sentenceAr[0]
            let sentenceData = sentenceAr[1]
            wordAr = sentence.characters.split{$0 == " "}.map(String.init)
            sentenceDataAr = sentenceData.characters.split{$0 == " "}.map(String.init)
            global.currentSentenceNum = global.currentSentenceNum + 1
            if global.sceneType == "Spelling" {
                global.spellingDragNum = global.spellingDragNum + 1
                if global.spellingDragNum >= lineAr.count {
                    global.spellingDragNum = 0                    
                }
            }
            else {  //Grammar
                global.grammarDragNum = global.grammarDragNum + 1
                if global.grammarDragNum >= lineAr.count {
                    global.grammarDragNum = 0
                }
            }
        }
        else
        {
            print("file not found")
        }
    }
    
    func GetChoiceArray()
    {
        var extraWord1 = ""
        var extraWord2 = ""
        var correctWord = wordAr[correctAnswerAr[0]]
        if global.sceneType == "Spelling" {
            var vocabularyWordAr = Misspell(word: correctWord)
            extraWord1 = vocabularyWordAr[1]
            extraWord2 = vocabularyWordAr[2]
        }
        else if global.sceneType == "Vocabulary" {
            let fileName = "Vocabulary" + global.currentGrade
            if let path = Bundle.main.path(forResource: fileName, ofType: "txt")  {
                let fileText = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
                var lineAr = fileText.components(separatedBy: .newlines)
                lineAr.shuffle()  //FIX should be done once per launch, not per screen
                
                extraWord1 = lineAr[currentExtraWordNum*2]
            }
            else {
                print("file not found")
            }
            if let path = Bundle.main.path(forResource: fileName, ofType: "txt")  {
                let fileText = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
                var lineAr = fileText.components(separatedBy: .newlines)
                lineAr.shuffle()  //FIX should be done once per launch, not per screen
                
                extraWord2 = lineAr[currentExtraWordNum*2]
            }
            else {
                print("file not found")
            }
        }
        else {
            if let path = Bundle.main.path(forResource: "Verbs1", ofType: "txt")  {
                let fileText = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
                var lineAr = fileText.components(separatedBy: .newlines)
                lineAr.shuffle()  //FIX should be done once per launch, not per screen
                
                extraWord1 = lineAr[currentExtraWordNum]
            }
            else {
                print("file not found")
            }
            
            if let path = Bundle.main.path(forResource: "Adjectives1", ofType: "txt") {
                let fileText = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
                var lineAr = fileText.components(separatedBy: .newlines)
                lineAr.shuffle()  //FIX should be done once per launch, not per screen
                
                extraWord2 = lineAr[currentExtraWordNum]
            }
            else {
                print("file not found")
            }
        }
        
        self.currentExtraWordNum = self.currentExtraWordNum + 1
        
        answerPos = Int(arc4random_uniform(3))
        if answerPos==0 {
            choiceWordAr.append(correctWord)
        }
        choiceWordAr.append(extraWord1)
        if answerPos==1 {
            choiceWordAr.append(correctWord)
        }
        choiceWordAr.append(extraWord2)
        if answerPos==2 {
            choiceWordAr.append(correctWord)
        }
    }
    
    func SetCorrectAnswer()
    {
        var ind = 0
        for var ans in sentenceDataAr {
            //pronouns count as nouns
            if levelMode == "n"  {
                if ans == "o" {
                    ans = "n"
                }
            }
            
            if ans == levelMode  {
                correctAnswerAr.append(ind)
            }
            
            ind = ind + 1
        }
    }
    
    func GetSentenceLength(wordAr : [String]) -> Int
    {
        var count = 1  //Add 1 for the period at the end
        for word in wordAr {
            count += (word.characters.count + 1)
        }
        
        return count
    }
    
    init(size: CGSize, currentSentenceNum:Int, correctAnswers:Int, incorrectAnswers:Int, currentExtraWordNum:Int,sceneType:String) {
        super.init(size: size)
        
        global.currentSentenceNum = currentSentenceNum
        global.correctAnswers = correctAnswers
        global.incorrectAnswers = incorrectAnswers
        self.currentExtraWordNum = currentExtraWordNum
        global.sceneType = sceneType
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        GetSentence()
        SetCorrectAnswer()
        
        backgroundColor = SKColor(red: 234/255, green: 230/255, blue: 236/255, alpha: 1)
        
        let fullTitle = SKNode()
        fullTitle.position = CGPoint(x: self.size.width/2, y: self.size.height*5/6)
        fullTitle.zPosition = 100.0
        
        if global.sceneType == "Vocabulary" {
            labelTitle.text = "VOCABULARY"
        }
        else if global.sceneType == "Spelling" {
            labelTitle.text = "SPELLING"
        }
        else {
            labelTitle.text = "NOUNS"
        }
        labelTitle.fontSize = 45
        labelTitle.fontColor = SKColor.red
        labelTitle.position = .zero
        labelTitle.zPosition = 100.0
        fullTitle.addChild(labelTitle)
        let labelTitleShadow = CreateShadowLabel(label: labelTitle,offset: 1)
        fullTitle.addChild(labelTitleShadow)
        
        labelSubtitle.text = "Level " + String(global.currentLevel)
        labelSubtitle.fontSize = 40
        labelSubtitle.fontColor = SKColor.red
        labelSubtitle.position = CGPoint(x: 0, y: -self.size.height/18)
        labelSubtitle.zPosition = 100.0
        fullTitle.addChild(labelSubtitle)
        let labelSubtitleShadow = CreateShadowLabel(label: labelSubtitle,offset: 1)
        fullTitle.addChild(labelSubtitleShadow)
        
        addChild(fullTitle)
        
        if global.sceneType == "Vocabulary" {
            labelInstr.text = "Drag the correct word"
        }
        else if global.sceneType == "Spelling" {
            labelInstr.text = "Drag the correct spelling"
        }
        else {
            labelInstr.text = "Drag the noun"
        }
        labelInstr2.text = "to the sentence below."
        labelInstr.fontSize = 22
        labelInstr.fontColor = SKColor.purple
        labelInstr.position = CGPoint(x: self.size.width/2, y: self.size.height*16/24)
        labelInstr.zPosition = 100.0
        addChild(labelInstr)
        labelInstrShadow = CreateShadowLabel(label: labelInstr,offset: 1)
        addChild(labelInstrShadow)
    
        labelInstr2.fontSize = 22
        labelInstr2.fontColor = SKColor.purple
        labelInstr2.position = CGPoint(x: self.size.width/2, y: self.size.height*15/24)
        labelInstr2.zPosition = 100.0
        addChild(labelInstr2)
        labelInstrShadow2 = CreateShadowLabel(label: labelInstr2,offset: 1)
        addChild(labelInstrShadow2)
        
        let scoreNode = SKNode()
        scoreNode.position = CGPoint(x: self.size.width/8, y: self.size.height/6)
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
        
        GetChoiceArray()
        
        var posX = self.size.width/6
        
        //add three choice boxes
        for n in 0...2
        {
            var correctWord = choiceWordAr[n]
            let myWord: NSString = correctWord as NSString
            var sizeWordChoice: CGSize = myWord.size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: SELECTTEXT_FONTSIZE-2.0)])
            sizeWordChoice.width = sizeWordChoice.width * 1.45
            sizeWordChoice.height = sizeWordChoice.height * 2.0
            
            //parent node with physics body for collision
            let choiceNode = SKSpriteNode()
            choiceNode.position = CGPoint(x: posX, y: self.size.height * 13 / 24)
            choiceNode.zPosition = 100.0
            choiceNode.name = "choice" + String(n)
            choiceNode.physicsBody = SKPhysicsBody(rectangleOf: sizeWordChoice)
            choiceNode.physicsBody?.isDynamic = true
            choiceNode.physicsBody?.categoryBitMask = PhysicsCategory.choicebox
            choiceNode.physicsBody?.contactTestBitMask = PhysicsCategory.answerbox
            choiceNode.physicsBody?.collisionBitMask = PhysicsCategory.none
            choiceNode.physicsBody?.usesPreciseCollisionDetection = true
            
            correctWord = correctWord.replacingOccurrences(of: ".", with: "")
            let labelChoice = SKLabelNode(fontNamed: "Verdana")
            labelChoice.zPosition = 100.0
            labelChoice.name = "choicelabel"
            labelChoice.text = correctWord.lowercased()
            labelChoice.fontSize = SELECTTEXT_FONTSIZE-2.0
            labelChoice.fontColor = SKColor.white
            labelChoice.horizontalAlignmentMode = .center
            labelChoice.position = CGPoint(x:  0, y: -sizeWordChoice.height/4)
            choiceNode.addChild(labelChoice)
            choiceNode.addChild(CreateShadowLabel(label: labelChoice,offset: 1))
            
            
//            let boxChoice = SKShapeNode(rectOf: sizeWordChoice,cornerRadius: 20.0)
//            boxChoice.name = "choicebox"
//            boxChoice.fillColor = SKColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
//            boxChoice.strokeColor = SKColor.red
//            boxChoice.position = .zero
//            choiceNode.addChild(boxChoice)
            let boxChoice = SKSpriteNode(imageNamed: "RedButtonBig.png")
            boxChoice.name = "choicebox"
            boxChoice.position = .zero
            boxChoice.scale(to: sizeWordChoice)
            choiceNode.addChild(boxChoice)
            
//            let boxChoiceShadow = SKShapeNode(rectOf: sizeWordChoice,cornerRadius: 30.0)
//            boxChoiceShadow.fillColor = SKColor.black
//            boxChoiceShadow.strokeColor = SKColor.black
//            boxChoiceShadow.zPosition = -1.0
//            boxChoice.position = CGPoint(x:-1.0,y:1.0)
//            choiceNode.addChild(boxChoiceShadow)
        
            addChild(choiceNode)
            
            posX = posX + self.size.width*2/6
        }
        
        let mySentence: NSString = sentence as NSString
        let sizeSentence: CGSize = mySentence.size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: SELECTTEXT_FONTSIZE)])
        var widthSentence = sizeSentence.width
        
        let space = "  "
        let mySpace: NSString = space as NSString
        let sizeSpace: CGSize = mySpace.size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: SELECTTEXT_FONTSIZE)])
        let widthSpace = sizeSpace.width
        
        widthSentence = widthSentence + CGFloat(widthSpace) * CGFloat(wordAr.count)
        
        let widthSentenceHalf = widthSentence / 2
        var startX = size.width / 2 - widthSentenceHalf
        if startX < size.width * 0.05 {
            startX = size.width * 0.05
        }
        var startY:CGFloat = 0.0
        var widthSum:CGFloat = 0.0
        
        let displayWidth = size.width * 9 / 10
        
        let firstCorrectAnswer = correctAnswerAr[0]
        
        var i = 0
        for var word in wordAr
        {
            word = word + "   "
            let myWord: NSString = word as NSString
            let sizeWord: CGSize = myWord.size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: SELECTTEXT_FONTSIZE)])
            let widthWord = sizeWord.width
            
            if widthSum+widthWord > displayWidth {   //shouldn't need +widthWord but seems to need
                startY = startY - sizeWord.height * 1.25  //give a bit of extra space between rows
                widthSum = 0.0
            }
            
            labelAr.append(SKLabelNode(fontNamed: "Verdana"))
            labelAr[i].zPosition = 100.0
            labelAr[i].name = "word"
            labelAr[i].text = word
            labelAr[i].fontSize = SELECTTEXT_FONTSIZE
            labelAr[i].fontColor = global.lightBlue
            labelAr[i].horizontalAlignmentMode = .left
            labelAr[i].position = CGPoint(x: startX + widthSum, y: startY + self.size.height * 9 / 24)
            
            if firstCorrectAnswer == i {
                //parent node with physics body for collision
                let answerBoxNode = SKSpriteNode()
                answerBoxNode.position = CGPoint(x: startX + widthSum + sizeWord.width/2, y: startY + self.size.height * 9 / 24 + sizeWord.height/2)
                answerBoxNode.name = "answerbox"
                answerBoxNode.physicsBody = SKPhysicsBody(rectangleOf: sizeWord)
                answerBoxNode.physicsBody?.isDynamic = true
                answerBoxNode.physicsBody?.categoryBitMask = PhysicsCategory.answerbox
                answerBoxNode.physicsBody?.contactTestBitMask = PhysicsCategory.choicebox
                answerBoxNode.physicsBody?.collisionBitMask = PhysicsCategory.none
                answerBoxNode.physicsBody?.usesPreciseCollisionDetection = true
                
                let box = SKShapeNode(rectOf: sizeWord,cornerRadius: 20.0)
                box.name = "answerboxrect"
                box.fillColor = SKColor.lightGray
                box.strokeColor = SKColor.red
                box.position = .zero
                answerBoxNode.addChild(box)
                addChild(answerBoxNode)
                
                widthSum = widthSum + widthWord / 4   //give extra space for the blank
            }
            else {
                addChild(labelAr[i])
                addChild(CreateShadowLabel(label: labelAr[i],offset: 1))
            }
            
            widthSum = widthSum + widthWord
            i = i + 1
        }
        
        background.position = CGPoint(x: frame.size.width * 5 / 6, y: frame.size.height / 6)
        background.scale(to: CGSize(width: self.size.width/3, height: self.size.height/3))
        addChild(background)
        
        let backButton = SKSpriteNode(imageNamed: "BackwardsClean.png")
        backButton.name = "backbutton"
        backButton.position = CGPoint(x: frame.size.width/20, y: self.size.height*18.5/20)
        backButton.scale(to: CGSize(width: self.size.width/10, height: self.size.width/10))
        addChild(backButton)
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
        
        if let labelNode = touchedNode as? SKLabelNode {
            if labelNode.name == "word"  {
                labelNode.fontColor = global.lightBlue
            }
        }
            
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

        let touchLocation = touch.location(in: self)
        let touchedNode = self.atPoint(touchLocation)

        if touchedNode.name == "choicelabel" || touchedNode.name == "choicebox" {
            if touchedNode.parent == nil {
                selectedNode = SKSpriteNode()
            }
            else {
                selectedNode = touchedNode.parent! as! SKSpriteNode
            }
        }
        else if touchedNode.name?.contains("choice") != nil && (touchedNode.name?.contains("choice"))! {
            if touchedNode.parent == nil {
                selectedNode = SKSpriteNode()
            }
            else {
                selectedNode = touchedNode as! SKSpriteNode
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 1 - Choose one of the touches to work with
        guard let touch = touches.first else {
            return
        }

        selectedNode = SKSpriteNode()   //FIX
        
        let touchLocation = touch.location(in: self)
        let touchedNode = self.atPoint(touchLocation)
        if let labelNode = touchedNode as? SKLabelNode {
            if labelNode.name == "word"  {
                var correctAnswerSelected = false
                for correctAnswer in correctAnswerAr {
                    if labelNode == labelAr[correctAnswer] {
                        CorrectAnswerSelected()
                        correctAnswerSelected = true
                    }
                }
                if (correctAnswerSelected == false) {
                    IncorrectAnswerSelected()
                }
            }
        }
        else if let shapeNode = touchedNode as? SKNode {
            if shapeNode.name?.contains("backbutton") != nil && (shapeNode.name?.contains("backbutton"))!  {
                TransitionBackFromScene(myScene: self)
            }
            if shapeNode.name?.contains("home") != nil && (shapeNode.name?.contains("home"))!  {
                TransitionBackFromScene(myScene: self)
            }
            if shapeNode.name?.contains("retry") != nil && (shapeNode.name?.contains("retry"))!  {
                var playSound = SKAction.playSoundFileNamed("QuizRight.wav", waitForCompletion: false)
                if global.soundOption > 0 {
                    playSound = SKAction.wait(forDuration: 0.0001)
                }
                TransitionScene(playSound:playSound,duration:0.0)
            }
            if shapeNode.name?.contains("next") != nil && (shapeNode.name?.contains("next"))!  {
                global.currentLevel = global.currentLevel + 1
                var playSound = SKAction.playSoundFileNamed("QuizRight.wav", waitForCompletion: false)
                if global.soundOption > 0 {
                    playSound = SKAction.wait(forDuration: 0.0001)
                }
                TransitionScene(playSound:playSound,duration:0.0)
            }
        }
    }
    
    func TransitionScene(playSound: SKAction,duration : TimeInterval)
    {
        for child in global.overlayNode.children {
            child.removeFromParent()
        }
        global.overlayNode.removeFromParent()
        let wait = SKAction.wait(forDuration: duration)
        
        let newScene = SKAction.run({
            let reveal = SKTransition.reveal(with:SKTransitionDirection.left, duration:1.0)
            if global.sceneType == "Vocabulary" || global.sceneType == "Spelling" {
                if (global.currentSentenceNum % 6) < 3 {
                    let nextScene = VocabularySelectScene(size: self.size,currentSentenceNum:global.currentSentenceNum,correctAnswers:global.correctAnswers,incorrectAnswers:global.incorrectAnswers,currentExtraWordNum:self.currentExtraWordNum,sceneType:global.sceneType)
                    self.view?.presentScene(nextScene, transition: reveal)
                }
                else {
                    let nextScene = WordDragScene(size: self.size,currentSentenceNum:global.currentSentenceNum,correctAnswers:global.correctAnswers,incorrectAnswers:global.incorrectAnswers,currentExtraWordNum:self.currentExtraWordNum,sceneType:global.sceneType)
                    self.view?.presentScene(nextScene, transition: reveal)
                }
            }
            else {
                if (global.currentSentenceNum % 6) < 3 {
                    let nextScene = WordSelectScene(size: self.size,currentSentenceNum:global.currentSentenceNum,correctAnswers:global.correctAnswers,incorrectAnswers:global.incorrectAnswers,currentExtraWordNum:self.currentExtraWordNum,sceneType:global.sceneType)
                    self.view?.presentScene(nextScene, transition: reveal)
                }
                else {
                    let nextScene = WordDragScene(size: self.size,currentSentenceNum:global.currentSentenceNum,correctAnswers:global.correctAnswers,incorrectAnswers:global.incorrectAnswers,currentExtraWordNum:self.currentExtraWordNum,sceneType:global.sceneType)
                    self.view?.presentScene(nextScene, transition: reveal)
                }
            }
        })
        self.run(SKAction.sequence([playSound,wait,newScene]))
    }
    
    func CorrectAnswerSelected() {
        labelInstr.text = "Answer Is Correct!!!"
        labelInstr.fontColor = global.lightBlue
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
            TransitionScene(playSound:playSound,duration: 1.5)
        }
    }
    
    func IncorrectAnswerSelected() {
        labelInstr.text = "Sorry, Answer Is Incorrect"
        labelInstr.fontColor = SKColor.red
        labelInstr.fontSize = 30
        labelInstrShadow.text = "Sorry, Answer Is Incorrect"
        labelInstrShadow.fontSize = 30
        
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
            TransitionScene(playSound:playSound, duration: 4.0)
        }
    }
    
    func ChoiceBoxMovedToAnswerBox(choicebox: SKSpriteNode, answerbox: SKSpriteNode) {
        choiceMade = true
        answerboxPos = answerbox.position
        answerbox.removeFromParent()
        if choicebox.name == "choice" + String(answerPos)
        {
            CorrectAnswerSelected()
        }
        else
        {
            IncorrectAnswerSelected()
        }
    }
}


extension WordDragScene: SKPhysicsContactDelegate {    
    func didBegin(_ contact: SKPhysicsContact) {
        // 1
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        // 2
        if ((firstBody.categoryBitMask & PhysicsCategory.answerbox != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.choicebox != 0)) {
            if let answerbox = firstBody.node as? SKSpriteNode,
                let choicebox = secondBody.node as? SKSpriteNode {
                ChoiceBoxMovedToAnswerBox(choicebox: choicebox, answerbox: answerbox)
            }
        }
    }
}

extension MutableCollection {
    mutating func shuffle() {
        let myCount = count
        guard myCount > 2 else { return }
        
        for unshuffled in stride(from: 0, to: myCount, by: 2)  {
            let unshuffledCount = (myCount - unshuffled) / 2   //groups of 2
            let d: Int = numericCast(arc4random_uniform(numericCast(unshuffledCount))) * 2
            let unshuffledInd = index(startIndex,offsetBy:unshuffled)
            let unshuffledInd2 = index(startIndex,offsetBy:unshuffled+1)
            let i = index(unshuffledInd, offsetBy: d)
            let i2 = index(unshuffledInd2, offsetBy: d)
            swapAt(unshuffledInd, i)
            swapAt(unshuffledInd2, i2)
        }
    }
}

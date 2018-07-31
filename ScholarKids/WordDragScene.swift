//
//  WordDragScene.swift
//  ScholarKids
//
//  Created by Doug Price on 5/21/18.
//  Copyright © 2018 Doug Price. All rights reserved.
//

import SpriteKit
import GameplayKit

class WordDragScene: SKScene {    
    let SELECTTEXT_FONTSIZE : CGFloat = 23.0
    let SELECTTEXT_FONTSIZE_CHOICE : CGFloat = 15.0
    
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
    var sentenceData = ""
    
    var levelMode = "n"
    var titleAr = ["n":"NOUNS","v":"VERBS","a":"ADJECTIVES","p":"PREPOSITIONS","d":"ADVERBS"]
    var instrAr = ["n":"noun","v":"verb","a":"adjective","p":"preposition","d":"adverb"]
    var extraFileAr = ["Nouns","Verbs","Adjectives","Prepositions","Adverbs"]
    
    var answerPos = 0    
    var choiceMade = false
    var background = SKSpriteNode(imageNamed: "background4.png")
    
    var emptyCorrectAnswer = 0
    var answerSelected = false
    
    init(size: CGSize, currentSentenceNum:Int, correctAnswers:Int, incorrectAnswers:Int, currentExtraWordNum:Int,sceneType:String) {
        super.init(size: size)
        
        self.currentExtraWordNum = currentExtraWordNum
        global.sceneType = sceneType
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        backgroundColor = SKColor(red: 234/255, green: 230/255, blue: 236/255, alpha: 1)
        
        GetLevelMode(levelMode:&levelMode)
        GetSentence(increment:true)
        SetCorrectAnswer()
        DrawTitle()
        DrawScoreNode()
        GetChoiceArray()
        DrawChoiceBoxes()
        DrawSentence()
        DrawBackground()
        DrawBackButton(scene:self)
    }
    
    func GetWidthOfSentence(sizeBox:CGSize) -> CGFloat {
        var modSentence = ""
        var i = 0
        for var word in wordAr {
            if i != emptyCorrectAnswer {
                modSentence = modSentence + word + "   "
            }
            i = i + 1
        }
        let mySentence: NSString = modSentence as NSString
        let sizeSentence: CGSize = mySentence.size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: GetFontSize(size:SELECTTEXT_FONTSIZE))])
        let widthSentence = sizeSentence.width + sizeBox.width*5/4
        return widthSentence
    }
    
    func DrawSentence() {
        let mySentence: NSString = sentence as NSString
        let sizeSentence: CGSize = mySentence.size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: GetFontSize(size:SELECTTEXT_FONTSIZE))])
        var widthSentence = sizeSentence.width
        
        let space = "  "
        let mySpace: NSString = space as NSString
        let sizeSpace: CGSize = mySpace.size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: GetFontSize(size:SELECTTEXT_FONTSIZE))])
        let widthSpace = sizeSpace.width
        
        let sizeBox = CGSize(width:size.width/6,height:sizeSentence.height)  //make box standard size
        
        
        widthSentence = GetWidthOfSentence(sizeBox:sizeBox) 
        let widthSentenceHalf = widthSentence / 2
        var startX = size.width / 2 - widthSentenceHalf
        if startX < size.width * 0.05 {
            startX = size.width * 0.05
        }
        var startY:CGFloat = 0.0
        var widthSum:CGFloat = 0.0
        let displayWidth = size.width * 9.4 / 10
        
        var i = 0
        for var word in wordAr {
            word = word + "   "
            let myWord: NSString = word as NSString
            let sizeWord: CGSize = myWord.size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: GetFontSize(size:SELECTTEXT_FONTSIZE))])
            var widthWord = sizeWord.width
            
            if widthSum+widthWord > displayWidth {   //shouldn't need +widthWord but seems to need
                startY = startY - sizeWord.height * 1.35  //give a bit of extra space between rows
                widthSum = 0.0
            }
            
            labelAr.append(SKLabelNode(fontNamed: "Arial"))
            labelAr[i].zPosition = 100.0
            labelAr[i].name = "word"
            labelAr[i].text = word
            labelAr[i].fontSize = GetFontSize(size:SELECTTEXT_FONTSIZE)
            labelAr[i].fontColor = global.lightBlue
            labelAr[i].horizontalAlignmentMode = .left
            labelAr[i].position = CGPoint(x: startX + widthSum, y: startY + self.size.height * 9 / 24)
            
            if emptyCorrectAnswer == i {
                widthWord = sizeBox.width
                //parent node with physics body for collision
                let answerBoxNode = SKSpriteNode()
                answerBoxNode.position = CGPoint(x: startX + widthSum + sizeBox.width/2, y: startY + self.size.height * 8.85 / 24 + sizeWord.height/2)
                answerBoxNode.name = "answerbox"
                answerBoxNode.physicsBody = SKPhysicsBody(rectangleOf: sizeWord)
                answerBoxNode.physicsBody?.isDynamic = true
                answerBoxNode.physicsBody?.categoryBitMask = PhysicsCategory.answerbox
                answerBoxNode.physicsBody?.contactTestBitMask = PhysicsCategory.choicebox
                answerBoxNode.physicsBody?.collisionBitMask = PhysicsCategory.none
                answerBoxNode.physicsBody?.usesPreciseCollisionDetection = true
                
                let box = SKShapeNode(rectOf: sizeBox,cornerRadius: GetCornerSize(size:20.0,max:sizeBox.height))
                box.name = "answerboxrect"
                box.fillColor = SKColor.lightGray
                box.strokeColor = SKColor.red
                box.position = .zero
                answerBoxNode.addChild(box)
                addChild(answerBoxNode)
                
                if i == wordAr.count-1 {  //add punctuation
                    let punctuation = GetPunctuation(word:word)
                    labelAr.append(SKLabelNode(fontNamed: "Arial"))
                    labelAr[i].zPosition = 100.0
                    labelAr[i].name = "word"
                    labelAr[i].text = punctuation
                    labelAr[i].fontSize = GetFontSize(size:SELECTTEXT_FONTSIZE)
                    labelAr[i].fontColor = global.lightBlue
                    labelAr[i].horizontalAlignmentMode = .left
                    labelAr[i].position = CGPoint(x: startX + widthSum + widthWord, y: startY + self.size.height * 9 / 24)
                    addChild(labelAr[i])
                    addChild(CreateShadowLabel(label: labelAr[i],offset: GetFontSize(size:1)))
                }
                
                widthSum = widthSum + widthWord / 4   //give extra space for the blank
            }
            else {
                addChild(labelAr[i])
                addChild(CreateShadowLabel(label: labelAr[i],offset: GetFontSize(size:1)))
            }
            
            widthSum = widthSum + widthWord
            i = i + 1
        }
    }
    
    func GetPunctuation(word:String) -> String {
        var str = word
        while str.last == " " {
            str.removeLast()
        }
        if let punctuation = str.last {
            return String(punctuation)
        }
        
        return "."
    }
    
    func DrawChoiceBoxes() {
        var posX = self.size.width/6
        //add three choice boxes
        for n in 0...2 {
            var word = choiceWordAr[n]
            word = word.replacingOccurrences(of: ".", with: "")
            if word != "I" {
                word = word.lowercased()
            }
            let myWord: NSString = word + "      " as NSString
            var sizeWordChoice: CGSize = myWord.size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: GetFontSize(size:SELECTTEXT_FONTSIZE_CHOICE))])
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
            
            
            let labelChoice = SKLabelNode(fontNamed: "Arial")
            labelChoice.zPosition = 100.0
            labelChoice.name = "choicelabel"
            labelChoice.text = word
            labelChoice.fontSize = GetFontSize(size:SELECTTEXT_FONTSIZE_CHOICE)
            labelChoice.fontColor = SKColor.white
            labelChoice.horizontalAlignmentMode = .center
            labelChoice.position = CGPoint(x:  0, y: -sizeWordChoice.height/4)
            choiceNode.addChild(labelChoice)
            choiceNode.addChild(CreateShadowLabel(label: labelChoice,offset: GetFontSize(size:1)))
            
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
        
        if global.sceneType == "Vocabulary" {
            labelTitle.text = "VOCABULARY"
        }
        else if global.sceneType == "Spelling" {
            labelTitle.text = "SPELLING"
        }
        else {
            labelTitle.text = titleAr[levelMode]!
        }
        labelTitle.fontSize = GetFontSize(size:50)
        labelTitle.fontColor = SKColor.red
        labelTitle.position = .zero
        labelTitle.zPosition = 100.0
        fullTitle.addChild(labelTitle)
        let labelTitleShadow = CreateShadowLabel(label: labelTitle,offset: GetFontSize(size:1))
        fullTitle.addChild(labelTitleShadow)
        
        labelSubtitle.text = "Level " + String(global.currentLevel)
        labelSubtitle.fontSize = GetFontSize(size:45)
        labelSubtitle.fontColor = SKColor.red
        labelSubtitle.position = CGPoint(x: 0, y: -self.size.height/12)
        labelSubtitle.zPosition = 100.0
        fullTitle.addChild(labelSubtitle)
        let labelSubtitleShadow = CreateShadowLabel(label: labelSubtitle,offset: GetFontSize(size:1))
        fullTitle.addChild(labelSubtitleShadow)
        
        addChild(fullTitle)
        
        if global.sceneType == "Vocabulary" {
            labelInstr.text = "Drag the correct word"
        }
        else if global.sceneType == "Spelling" {
            labelInstr.text = "Drag the correct spelling"
        }
        else {
            labelInstr.text = "Drag the " + instrAr[levelMode]!
        }
        labelInstr.fontSize = GetFontSize(size:25)
        labelInstr.fontColor = global.realPurple
        labelInstr.position = CGPoint(x: self.size.width/2, y: self.size.height*16/24)
        labelInstr.zPosition = 100.0
        addChild(labelInstr)
        labelInstrShadow = CreateShadowLabel(label: labelInstr,offset: GetFontSize(size:1))
        addChild(labelInstrShadow)
        
        labelInstr2.text = "to the sentence below."
        labelInstr2.fontSize = GetFontSize(size:25)
        labelInstr2.fontColor = global.realPurple
        labelInstr2.position = CGPoint(x: self.size.width/2, y: self.size.height*15/24)
        labelInstr2.zPosition = 100.0
        addChild(labelInstr2)
        labelInstrShadow2 = CreateShadowLabel(label: labelInstr2,offset: GetFontSize(size:1))
        addChild(labelInstrShadow2)
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
    
    func DrawBackground() {
        background.position = CGPoint(x: frame.size.width * 5 / 6, y: frame.size.height / 6)
        background.scale(to: CGSize(width: self.size.width/3, height: self.size.height/3))
        addChild(background)
    }
        
    func GetFileName() -> String {
        switch global.currentGrade {
        case "K","1","2":
            return "Sentences1"
        case "3","4","5":
            return "Sentences2"
        case "6","7","8":
            return "Sentences3"
        default:
            return "Sentences3"
        }
        return "Sentences1"
    }
    
    func GetSentence(increment:Bool) {
        var fileName = GetFileName()
        if let path = Bundle.main.path(forResource: fileName, ofType: "txt") {
            let fileText = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
            var lineAr = fileText.components(separatedBy: .newlines)
            global.currentSentenceNum = global.currentSentenceNum % lineAr.count
            let curSentenceNum = global.currentSentenceNum
            let sentenceAr = lineAr[curSentenceNum].characters.split{$0 == "*"}.map(String.init)
            global.currentSentenceNum = (global.currentSentenceNum + 1) % lineAr.count
            if increment {
                if global.sceneType == "Spelling" {
                    global.spellingDragNum = (global.spellingDragNum + 1) % lineAr.count
                }
                else {  //Grammar
                    global.grammarDragNum = (global.grammarDragNum + 1) % lineAr.count
                }
            }
            
            if sentenceAr.count > 1 {
                sentence = sentenceAr[0]
                sentenceData = sentenceAr[1]
                wordAr = sentence.characters.split{$0 == " "}.map(String.init)
                sentenceDataAr = sentenceData.characters.split{$0 == " "}.map(String.init)
            }
            else {
                GetSentence(increment:false)
            }
            
            var i = 0
            while !SentenceContainsLevelMode() && i < 249 {
                GetSentence(increment:false)  //get the next sentence if it doesn't contain the levelType (nouns, verbs, etc.)
                i = i + 1
            }
        }
        else {
            print("file not found")
        }
    }
    
    func SentenceContainsLevelMode() -> Bool {
        if sentenceData.contains(levelMode) {
            return true
        }
        return false
    }
    
    func GetChoiceArray() {
        var rand = Int(arc4random_uniform(UInt32(correctAnswerAr.count)))
        emptyCorrectAnswer = correctAnswerAr[rand]
        
        var extraWord1 = ""
        var extraWord2 = ""
        var correctWord = TrimPunctuation(inStr:wordAr[emptyCorrectAnswer])
        if global.sceneType == "Spelling" {
            var vocabularyWordAr = Misspell(word: correctWord)
            extraWord1 = vocabularyWordAr[1]
            extraWord2 = vocabularyWordAr[2]
        }        
        else {  //Grammar
            var levelModeFullName = "Nouns"
            if levelMode == "n" || levelMode == "o" {
                levelModeFullName = "Nouns"
            }
            if levelMode == "v" {
                levelModeFullName = "Verbs"
            }
            if levelMode == "a" {
                levelModeFullName = "Adjectives"
            }
            if levelMode == "p" {
                levelModeFullName = "Prepositions"
            }
            if levelMode == "d" {
                levelModeFullName = "Adverbs"
            }
            var rand = Int(arc4random_uniform(UInt32(extraFileAr.count)))
            while extraFileAr[rand] == levelModeFullName {
                rand = Int(arc4random_uniform(UInt32(extraFileAr.count)))
            }
            let fileName = extraFileAr[rand]
            
            if let path = Bundle.main.path(forResource: fileName, ofType: "txt")  {
                let fileText = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
                var lineAr = fileText.components(separatedBy: .newlines)
                lineAr.shuffle()  //FIX should be done once per launch, not per screen
                
                var n = 0
                extraWord1 = TrimPunctuation(inStr:lineAr[n])
                n = n + 1
                while extraWord1 == correctWord {
                    extraWord1 = TrimPunctuation(inStr:lineAr[n])
                    n = n + 1
                }
                extraWord2 = TrimPunctuation(inStr:lineAr[n])
                while extraWord2 == correctWord {
                    extraWord2 = TrimPunctuation(inStr:lineAr[n])
                    n = n + 1
                }                
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
    
    func TrimPunctuation(inStr: String) -> String {
        var str = inStr
        if str.last == "." || str.last == "?" || str.last == "!" {
            str.removeLast()
        }
        return str
    }
    
    func SetCorrectAnswer() {
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
    
    func GetSentenceLength(wordAr : [String]) -> Int {
        var count = 1  //Add 1 for the period at the end
        for word in wordAr {
            count += (word.characters.count + 1)
        }
        
        return count
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
    
    func TransitionScene(playSound: SKAction,duration : TimeInterval) {
        global.overlayNode.removeAllActions()
        global.overlayNode.removeAllChildren()
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
                let totalCount = global.grammarSelectNum + global.grammarDragNum
                if (totalCount % 6) < 3 {
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
        answerSelected = true
        
        labelInstr.text = "Answer Is Correct!!!"
        labelInstr.fontColor = global.blue
        labelInstr.fontSize = GetFontSize(size:30)
        labelInstrShadow.text = "Answer Is Correct!!!"
        labelInstrShadow.fontSize = GetFontSize(size:30)
        
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
        labelInstr.fontSize = GetFontSize(size:30)
        labelInstrShadow.text = "Sorry, Answer Is Incorrect"
        labelInstrShadow.fontSize = GetFontSize(size:30)
        
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

extension WordDragScene : SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
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

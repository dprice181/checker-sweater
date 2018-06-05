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
    let labelTitle = SKLabelNode(fontNamed: "ChalkDuster")
    let labelSubtitle = SKLabelNode(fontNamed: "ChalkDuster")
    let labelInstr = SKLabelNode(fontNamed: "Arial")
    let labelCorrect = SKLabelNode(fontNamed: "Arial")
    let labelIncorrect = SKLabelNode(fontNamed: "Arial")
    let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
    var sentence = ""
    var choiceWordAr = [String]()
    var selectedNode = SKSpriteNode()
    
    var answerboxPos = CGPoint(x:0,y:0)
    
    var correctAnswers = 0
    var incorrectAnswers = 0
    var currentSentenceNum = 0
    var currentExtraWordNum = 0
    
    var levelMode = "n"
    var answerPos = 0
    
    var choiceMade = false
    
    var background = SKSpriteNode(imageNamed: "background4.jpg")
    
    var sceneType = ""
    
    func GetSentence()
    {
        var fileName = "Sentences1"
        if sceneType == "Vocabulary" {
            fileName = "VocabularySentences1"
        }
        if let path = Bundle.main.path(forResource: fileName, ofType: "txt")
        {
            let fileText = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
            var lineAr = fileText.components(separatedBy: .newlines)
            lineAr.shuffle()  //FIX should be done once per launch, not per screen
            while (lineAr[currentSentenceNum] == "") {
                self.currentSentenceNum = self.currentSentenceNum + 1
            }
            let sentenceAr = lineAr[currentSentenceNum].characters.split{$0 == "*"}.map(String.init)
            
            sentence = sentenceAr[0]
            let sentenceData = sentenceAr[1]
            wordAr = sentence.characters.split{$0 == " "}.map(String.init)
            sentenceDataAr = sentenceData.characters.split{$0 == " "}.map(String.init)
            self.currentSentenceNum = self.currentSentenceNum + 1
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
        let correctWord = wordAr[correctAnswerAr[0]]
        if sceneType == "Vocabulary" {
            if let path = Bundle.main.path(forResource: "Vocabulary1", ofType: "txt")  {
                let fileText = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
                var lineAr = fileText.components(separatedBy: .newlines)
                lineAr.shuffle()  //FIX should be done once per launch, not per screen
                
                extraWord1 = lineAr[currentExtraWordNum*2]
            }
            else {
                print("file not found")
            }
            if let path = Bundle.main.path(forResource: "Vocabulary1", ofType: "txt")  {
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
                if ans == "o"
                {
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
        
        self.currentSentenceNum = currentSentenceNum
        self.correctAnswers = correctAnswers
        self.incorrectAnswers = incorrectAnswers
        self.currentExtraWordNum = currentExtraWordNum
        self.sceneType = sceneType
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        GetSentence()
        
        SetCorrectAnswer()
        
        backgroundColor = SKColor.white
        
        let fullTitle = SKNode()
        fullTitle.position = CGPoint(x: self.size.width/2, y: self.size.height*5/6)
        fullTitle.zPosition = 100.0
        
        if sceneType == "Vocabulary" {
            labelTitle.text = "VOCABULARY:"
        }
        else {
            labelTitle.text = "NOUNS:"
        }
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
        
        if sceneType == "Vocabulary" {
            labelInstr.text = "Drag the correct word to the sentence below."
        }
        else {
            labelInstr.text = "Drag the noun to the sentence below."
        }
        labelInstr.fontSize = 18
        labelInstr.fontColor = SKColor.black
        labelInstr.position = CGPoint(x: self.size.width/2, y: self.size.height*15/24)
        labelInstr.zPosition = 100.0
        addChild(labelInstr)
        
        let scoreNode = SKNode()
        scoreNode.position = CGPoint(x: self.size.width/8, y: self.size.height/6)
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
        
        GetChoiceArray()
        
        var posX = self.size.width/5
        
        //add three choice boxes
        for n in 0...2
        {
            let correctWord = choiceWordAr[n]
            let myWord: NSString = correctWord as NSString
            var sizeWordChoice: CGSize = myWord.size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: SELECTTEXT_FONTSIZE)])
            sizeWordChoice.width = sizeWordChoice.width * 1.25
            sizeWordChoice.height = sizeWordChoice.height * 1.25
            
            //parent node with physics body for collision
            let choiceNode = SKSpriteNode()
            choiceNode.position = CGPoint(x: posX, y: self.size.height * 6 / 12)
            choiceNode.zPosition = 100.0
            choiceNode.name = "choice" + String(n)
            choiceNode.physicsBody = SKPhysicsBody(rectangleOf: sizeWordChoice)
            choiceNode.physicsBody?.isDynamic = true
            choiceNode.physicsBody?.categoryBitMask = PhysicsCategory.choicebox
            choiceNode.physicsBody?.contactTestBitMask = PhysicsCategory.answerbox
            choiceNode.physicsBody?.collisionBitMask = PhysicsCategory.none
            choiceNode.physicsBody?.usesPreciseCollisionDetection = true
            
            
            let labelChoice = SKLabelNode(fontNamed: "Verdana")
            labelChoice.zPosition = 100.0
            labelChoice.name = "choicelabel"
            labelChoice.text = correctWord
            labelChoice.fontSize = SELECTTEXT_FONTSIZE
            labelChoice.fontColor = SKColor.blue
            labelChoice.horizontalAlignmentMode = .center
            labelChoice.position = CGPoint(x:  0, y: -sizeWordChoice.height/4)
            choiceNode.addChild(labelChoice)
            
            
            let boxChoice = SKShapeNode(rectOf: sizeWordChoice)
            boxChoice.name = "choicebox"
            boxChoice.fillColor = SKColor(red: 225/255, green: 225/255, blue: 225/255, alpha: 1)
            boxChoice.strokeColor = SKColor.red
            boxChoice.position = .zero
            choiceNode.addChild(boxChoice)
            addChild(choiceNode)
            
            posX = posX + self.size.width*3/10
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
            labelAr[i].fontColor = SKColor.blue
            labelAr[i].horizontalAlignmentMode = .left
            labelAr[i].position = CGPoint(x: startX + widthSum, y: startY + self.size.height * 4 / 12)

            
            if firstCorrectAnswer == i {
                //parent node with physics body for collision
                let answerBoxNode = SKSpriteNode()
                answerBoxNode.position = CGPoint(x: startX + widthSum + sizeWord.width/2, y: startY + self.size.height * 4 / 12 + sizeWord.height/2)
                answerBoxNode.name = "answerbox"
                answerBoxNode.physicsBody = SKPhysicsBody(rectangleOf: sizeWord)
                answerBoxNode.physicsBody?.isDynamic = true
                answerBoxNode.physicsBody?.categoryBitMask = PhysicsCategory.answerbox
                answerBoxNode.physicsBody?.contactTestBitMask = PhysicsCategory.choicebox
                answerBoxNode.physicsBody?.collisionBitMask = PhysicsCategory.none
                answerBoxNode.physicsBody?.usesPreciseCollisionDetection = true
                
                let box = SKShapeNode(rectOf: sizeWord)
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
            }
            
            widthSum = widthSum + widthWord
            
            i = i + 1
        }
        
        background.position = CGPoint(x: frame.size.width * 5 / 6, y: frame.size.height / 6)
        background.scale(to: CGSize(width: self.size.width/3, height: self.size.height/3))
        addChild(background)
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
                labelNode.fontColor = SKColor.blue
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


        if touchedNode.name == "choicelabel" || touchedNode.name == "choicebox"
        {
            if touchedNode.parent == nil {
                selectedNode = SKSpriteNode()
            }
            else {
                selectedNode = touchedNode.parent! as! SKSpriteNode
            }
        }
        else if touchedNode.name?.contains("choice") != nil && (touchedNode.name?.contains("choice"))!
        {
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
        if let labelNode = touchedNode as? SKLabelNode
        {
            if labelNode.name == "word"  {
                var correctAnswerSelected = false
                for correctAnswer in correctAnswerAr
                {
                    if labelNode == labelAr[correctAnswer]
                    {
                        CorrectAnswerSelected()
                        correctAnswerSelected = true
                    }
                }
                if (correctAnswerSelected == false)
                {
                    IncorrectAnswerSelected()
                }
            }
        }
    }
    
    func TransitionScene(playSound: SKAction)
    {
        let wait = SKAction.wait(forDuration: 1.5)
        
        let newScene = SKAction.run({
            let reveal = SKTransition.reveal(with:SKTransitionDirection.left, duration:1.0)
            if self.sceneType == "Vocabulary" {
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
            }
            else {
                if (self.currentSentenceNum % 6) < 3
                {
                    let nextScene = WordSelectScene(size: self.size,currentSentenceNum:self.currentSentenceNum,correctAnswers:self.correctAnswers,incorrectAnswers:self.incorrectAnswers,currentExtraWordNum:self.currentExtraWordNum,sceneType:self.sceneType)
                    self.view?.presentScene(nextScene, transition: reveal)
                }
                else
                {
                    let nextScene = WordDragScene(size: self.size,currentSentenceNum:self.currentSentenceNum,correctAnswers:self.correctAnswers,incorrectAnswers:self.incorrectAnswers,currentExtraWordNum:self.currentExtraWordNum,sceneType:self.sceneType)
                    self.view?.presentScene(nextScene, transition: reveal)
                }
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
        TransitionScene(playSound:playSound)
    }
    
    func IncorrectAnswerSelected()
    {
        labelInstr.text = "Sorry, Answer Is Incorrect"
        labelInstr.fontColor = SKColor.red
        labelInstr.fontSize = 30
        
        self.incorrectAnswers = self.incorrectAnswers + 1
        labelIncorrect.text = "Missed : " + String(self.incorrectAnswers)
        
        let playSound = SKAction.playSoundFileNamed("Error-sound-effect.mp3", waitForCompletion: false)
        TransitionScene(playSound:playSound)
    }
    
    func ChoiceBoxMovedToAnswerBox(choicebox: SKSpriteNode, answerbox: SKSpriteNode)
    {
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

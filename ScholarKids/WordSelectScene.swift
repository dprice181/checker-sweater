//
//  WordSelectScene.swift
//  ScholarKids
//
//  Created by Doug Price on 5/19/18.
//  Copyright © 2018 Doug Price. All rights reserved.
//

import SpriteKit
import GameplayKit

class WordSelectScene: SKScene {

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
    var labelTitleShadow = SKLabelNode(fontNamed: "ChalkDuster")
    var labelSubtitleShadow = SKLabelNode(fontNamed: "ChalkDuster")
    var labelInstrShadow = SKLabelNode(fontNamed: "Arial")
    var labelCorrectShadow = SKLabelNode(fontNamed: "Arial")
    var labelIncorrectShadow = SKLabelNode(fontNamed: "Arial")
    let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
    var sentence = ""
    
    var correctAnswers = 0
    var incorrectAnswers = 0
    var currentSentenceNum = 0
    var currentExtraWordNum = 0
    var sceneType = ""
    
    var levelMode = "n"
    var background = SKSpriteNode(imageNamed: "background4.png")
    
    init(size: CGSize, currentSentenceNum:Int, correctAnswers:Int, incorrectAnswers:Int, currentExtraWordNum:Int,sceneType:String) {
        super.init(size: size)
        
        self.currentSentenceNum = currentSentenceNum
        self.correctAnswers = correctAnswers
        self.incorrectAnswers = incorrectAnswers
        self.currentExtraWordNum = currentExtraWordNum
        self.sceneType = sceneType
        
        GetSentence()        
        SetCorrectAnswer()
        
        backgroundColor = SKColor(red: 234/255, green: 230/255, blue: 236/255, alpha: 1)
        
        let fullTitle = SKNode()
        fullTitle.position = CGPoint(x: self.size.width/2, y: self.size.height*5/6)
        fullTitle.zPosition = 100.0

        labelTitle.text = "NOUNS"
        labelTitle.fontSize = 40
        labelTitle.fontColor = SKColor.red
        labelTitle.position = .zero
        labelTitle.zPosition = 100.0
        fullTitle.addChild(labelTitle)
        labelTitleShadow = CreateShadowLabel(label: labelTitle,offset: 1)
        fullTitle.addChild(labelTitleShadow)
        
        labelSubtitle.text = "Level " + String(global.currentLevel)
        labelSubtitle.fontSize = 35
        labelSubtitle.fontColor = SKColor.red
        labelSubtitle.position = CGPoint(x: 0, y: -self.size.height/18)
        labelSubtitle.zPosition = 100.0
        fullTitle.addChild(labelSubtitle)
        labelSubtitleShadow = CreateShadowLabel(label: labelSubtitle,offset: 1)
        fullTitle.addChild(labelSubtitleShadow)

        addChild(fullTitle)
        
        
        labelInstr.text = "Select the noun from the sentence below."
        labelInstr.fontSize = 18
        labelInstr.fontColor = SKColor.purple
        labelInstr.position = CGPoint(x: self.size.width/2, y: self.size.height*16/24)
        labelInstr.zPosition = 100.0
        addChild(labelInstr)
        labelInstrShadow = CreateShadowLabel(label: labelInstr,offset: 1)
        addChild(labelInstrShadow)
        
        let scoreNode = SKNode()
        scoreNode.position = CGPoint(x: self.size.width/8, y: self.size.height/6)
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
        
        
        let mySentence: NSString = sentence as NSString
        let sizeSentence: CGSize = mySentence.size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: SELECTTEXT_FONTSIZE)])
        var widthSentence = sizeSentence.width
        
        let displayWidth = size.width * 9 / 10
        
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
        
        var i = 0
        for var word in wordAr
        {
            word = word + "   "
            let myWord: NSString = word as NSString
            let sizeWord: CGSize = myWord.size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: SELECTTEXT_FONTSIZE)])
            let widthWord = sizeWord.width
            
            labelAr.append(SKLabelNode(fontNamed: "Verdana"))
            labelAr[i].zPosition = 100.0
            labelAr[i].name = "word"
            labelAr[i].text = word
            labelAr[i].fontSize = SELECTTEXT_FONTSIZE
            labelAr[i].fontColor = global.lightBlue
            labelAr[i].horizontalAlignmentMode = .left
            labelAr[i].position = CGPoint(x: startX + widthSum, y: startY + self.size.height * 12 / 24)
            widthSum = widthSum + widthWord
            addChild(labelAr[i])
            addChild(CreateShadowLabel(label: labelAr[i],offset: 1))
            
            i = i + 1
            
            if widthSum+widthWord > displayWidth {   //shouldn't need +widthWord but seems to need
                startY = startY - sizeWord.height * 1.25  //give a bit of extra space between rows
                widthSum = 0.0
            }
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
    
    func GetSentence()
    {
        if let path = Bundle.main.path(forResource: "Sentences1", ofType: "txt")
        {
            let fileText = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
            let lineAr = fileText.components(separatedBy: .newlines)
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
    
    func SetCorrectAnswer()
    {
        var ind = 0
        for var ans in sentenceDataAr
        {
            //pronouns count as nouns
            if levelMode == "n"
            {
                if ans == "o"
                {
                    ans = "n"
                }
            }
            
            if ans == levelMode
            {
                correctAnswerAr.append(ind)
            }
            
            ind = ind + 1
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
        
        let touchLocation = touch.location(in: self)
        let touchedNode = self.atPoint(touchLocation)
        
        if let labelNode = touchedNode as? SKLabelNode {
            if labelNode.name == "word"  {
                labelNode.fontColor = SKColor.blue
            }
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        let touchLocation = touch.location(in: self)
        let touchedNode = self.atPoint(touchLocation)
        if let labelNode = touchedNode as? SKLabelNode
        {
            if labelNode.name == "word"  {
                labelNode.fontColor = SKColor.red
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
        }
    }
    
    func TransitionScene(playSound: SKAction)
    {
        let wait = SKAction.wait(forDuration: 1.5)
        
        let newScene = SKAction.run({
            let reveal = SKTransition.reveal(with:SKTransitionDirection.left, duration:1.0)
            if (self.currentSentenceNum % 6) < 3 {
                let nextScene = WordSelectScene(size: self.size,currentSentenceNum:self.currentSentenceNum,correctAnswers:self.correctAnswers,incorrectAnswers:self.incorrectAnswers,currentExtraWordNum:self.currentExtraWordNum,sceneType:self.sceneType)
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
//        for label in labelAr {
//            label.removeFromParent()
//        }
        
        labelInstr.text = "Answer Is Correct!!!"
        labelInstr.fontColor = SKColor.blue
        labelInstr.fontSize = 30
        labelInstrShadow.text = "Answer Is Correct!!!"
        labelInstrShadow.fontSize = 30
        
        self.correctAnswers = self.correctAnswers + 1
        labelCorrect.text = "Correct : " + String(self.correctAnswers)
        labelCorrectShadow.text = "Correct : " + String(self.correctAnswers)
        
        let playSound = SKAction.playSoundFileNamed("QuizRight.wav", waitForCompletion: false)
        TransitionScene(playSound:playSound)
    }
    
    func IncorrectAnswerSelected()
    {
//        for label in labelAr {
//            label.removeFromParent()
//        }
        
        labelInstr.text = "Sorry, Answer Is Incorrect"
        labelInstr.fontColor = SKColor.red
        labelInstr.fontSize = 30
        labelInstrShadow.text = "Sorry, Answer Is Incorrect"
        labelInstrShadow.fontSize = 30
        
        self.incorrectAnswers = self.incorrectAnswers + 1
        labelIncorrect.text = "Missed : " + String(self.incorrectAnswers)
        labelIncorrectShadow.text = "Missed : " + String(self.incorrectAnswers)
        
        let playSound = SKAction.playSoundFileNamed("QuizWrong.wav", waitForCompletion: false)
        TransitionScene(playSound:playSound)
    }
}

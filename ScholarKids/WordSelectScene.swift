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

    let SELECTTEXT_FONTSIZE : CGFloat = 26.0
    
    var labelAr = [SKLabelNode]()
    var labelSpaceAr = [SKLabelNode]()
    var correctAnswerAr : [Int]  = []
    var wordAr : [String] = []
    var sentenceDataAr : [String] = []
    let labelTitle = SKLabelNode(fontNamed: "MarkerFelt-Thin")
    let labelSubtitle = SKLabelNode(fontNamed: "MarkerFelt-Thin")
    let labelInstr = SKLabelNode(fontNamed: "Arial")
    let labelInstrR2 = SKLabelNode(fontNamed: "Arial")
    let labelInstr2 = SKLabelNode(fontNamed: "Arial")
    let labelCorrect = SKLabelNode(fontNamed: "Arial")
    let labelIncorrect = SKLabelNode(fontNamed: "Arial")
    var labelTitleShadow = SKLabelNode(fontNamed: "MarkerFelt-Thin")
    var labelSubtitleShadow = SKLabelNode(fontNamed: "MarkerFelt-Thin")
    var labelInstrShadow = SKLabelNode(fontNamed: "Arial")
    var labelInstrR2Shadow = SKLabelNode(fontNamed: "Arial")
    var labelInstr2Shadow = SKLabelNode(fontNamed: "Arial")
    var labelCorrectShadow = SKLabelNode(fontNamed: "Arial")
    var labelIncorrectShadow = SKLabelNode(fontNamed: "Arial")
    var lineTitle2 = SKShapeNode()
    let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
    var sentence = ""
    
    var currentExtraWordNum = 0
        
    var levelMode = "n"
    var background = SKSpriteNode(imageNamed: "background4.png")
    
    init(size: CGSize, currentSentenceNum:Int, correctAnswers:Int, incorrectAnswers:Int, currentExtraWordNum:Int,sceneType:String) {
        super.init(size: size)
        
        global.currentSentenceNum = currentSentenceNum
        global.correctAnswers = correctAnswers
        global.incorrectAnswers = incorrectAnswers
        self.currentExtraWordNum = currentExtraWordNum
        global.sceneType = sceneType
        
        GetSentence()        
        SetCorrectAnswer()
        
        backgroundColor = SKColor(red: 234/255, green: 230/255, blue: 236/255, alpha: 1)
        
        DrawTitle()
        DrawInstructions()
        DrawScoreNode()
        DrawSentence()
        
        background.position = CGPoint(x: frame.size.width * 5 / 6, y: frame.size.height / 6)
        background.scale(to: CGSize(width: self.size.width/3, height: self.size.height/3))
        addChild(background)
        
        let backButton = SKSpriteNode(imageNamed: "BackwardsClean.png")
        backButton.name = "backbutton"
        backButton.position = CGPoint(x: frame.size.width/20, y: self.size.height*18.5/20)
        backButton.scale(to: CGSize(width: self.size.width/10, height: self.size.width/10))
        addChild(backButton)
    }
    
    func DrawSentence() {
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
        for var word in wordAr {
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
            labelAr[i].position = CGPoint(x: startX + widthSum, y: startY + self.size.height * 11 / 24)
            widthSum = widthSum + widthWord
            addChild(labelAr[i])
            addChild(CreateShadowLabel(label: labelAr[i],offset: 1))
            
            i = i + 1
            
            if widthSum+widthWord > displayWidth {   //shouldn't need +widthWord but seems to need
                startY = startY - sizeWord.height * 1.35  //give a bit of extra space between rows
                widthSum = 0.0
            }
        }
    }
    
    func DrawTitle() {
        let fullTitle = SKNode()
        fullTitle.position = CGPoint(x: self.size.width/2, y: self.size.height*21/24)
        fullTitle.zPosition = 100.0
        
        labelTitle.text = "NOUNS"
        labelTitle.fontSize = 55
        labelTitle.fontColor = SKColor.red
        labelTitle.position = .zero
        labelTitle.zPosition = 100.0
        fullTitle.addChild(labelTitle)
        labelTitleShadow = CreateShadowLabel(label: labelTitle,offset: 1)
        fullTitle.addChild(labelTitleShadow)
        
        labelSubtitle.text = "Level " + String(global.currentLevel)
        labelSubtitle.fontSize = 45
        labelSubtitle.fontColor = SKColor.red
        labelSubtitle.position = CGPoint(x: 0, y: -self.size.height/12)
        labelSubtitle.zPosition = 100.0
        fullTitle.addChild(labelSubtitle)
        labelSubtitleShadow = CreateShadowLabel(label: labelSubtitle,offset: 1)
        fullTitle.addChild(labelSubtitleShadow)
        
        addChild(fullTitle)
    }
    
    func DrawInstructions() {
        labelInstr.text = "Select the noun"
        labelInstr.fontSize = 24
        labelInstr.fontColor = SKColor.purple
        labelInstr.position = CGPoint(x: self.size.width/2, y: self.size.height*17/24)
        labelInstr.zPosition = 100.0
        addChild(labelInstr)
        labelInstrShadow = CreateShadowLabel(label: labelInstr,offset: 1)
        addChild(labelInstrShadow)
        
        labelInstrR2.text = "from the sentence below."
        labelInstrR2.fontSize = 24
        labelInstrR2.fontColor = SKColor.purple
        labelInstrR2.position = CGPoint(x: self.size.width/2, y: self.size.height*16/24)
        labelInstrR2.zPosition = 100.0
        addChild(labelInstrR2)
        labelInstrR2Shadow = CreateShadowLabel(label: labelInstrR2,offset: 1)
        addChild(labelInstrR2Shadow)
        
        labelInstr2.text = "(A Noun is the name of a person place or thing)"
        labelInstr2.fontSize = 16
        labelInstr2.fontColor = SKColor.red
        labelInstr2.position = CGPoint(x: self.size.width/2, y: self.size.height*14.5/24)
        labelInstr2.zPosition = 100.0
        addChild(labelInstr2)
        labelInstr2Shadow = CreateShadowLabel(label: labelInstr2,offset: 1)
        addChild(labelInstr2Shadow)
        
        var pointsTitle2 = [CGPoint(x:0.0, y:0.0),CGPoint(x:self.size.width*3/4, y:0.0)]
        lineTitle2 = SKShapeNode(points: &pointsTitle2, count: pointsTitle2.count)
        lineTitle2.position = CGPoint(x:self.size.width/8,y:self.size.height*14.2/24)
        lineTitle2.lineWidth = 2.0
        lineTitle2.strokeColor = SKColor.red
        self.addChild(lineTitle2)
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
    
    func GetSentence()
    {
        if let path = Bundle.main.path(forResource: "Sentences1", ofType: "txt") {
            let fileText = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
            let lineAr = fileText.components(separatedBy: .newlines)
            //let sentenceAr = lineAr[global.currentSentenceNum].characters.split{$0 == "*"}.map(String.init)
            let sentenceAr = lineAr[global.grammarSelectNum].characters.split{$0 == "*"}.map(String.init)
            sentence = sentenceAr[0]
            let sentenceData = sentenceAr[1]
            wordAr = sentence.characters.split{$0 == " "}.map(String.init)
            sentenceDataAr = sentenceData.characters.split{$0 == " "}.map(String.init)
            global.currentSentenceNum = global.currentSentenceNum + 1
            global.currentSentenceNum = global.grammarSelectNum + 1
        }
        else {
            print("file not found")
        }
    }
    
    func SetCorrectAnswer()
    {
        var ind = 0
        for var ans in sentenceDataAr {
            //pronouns count as nouns
            if levelMode == "n" {
                if ans == "o"
                {
                    ans = "n"
                }
            }
            
            if ans == levelMode {
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
            if shapeNode.name?.contains("home") != nil && (shapeNode.name?.contains("home"))!  {
                TransitionBackFromScene(myScene: self)
            }
            if shapeNode.name?.contains("retry") != nil && (shapeNode.name?.contains("retry"))!  {
                let playSound = SKAction.playSoundFileNamed("QuizRight.wav", waitForCompletion: false)
                TransitionScene(playSound:playSound,duration:0.0)
            }
            if shapeNode.name?.contains("next") != nil && (shapeNode.name?.contains("next"))!  {
                global.currentLevel = global.currentLevel + 1
                let playSound = SKAction.playSoundFileNamed("QuizRight.wav", waitForCompletion: false)
                TransitionScene(playSound:playSound,duration:0.0)
            }
        }
    }
    
    func TransitionScene(playSound: SKAction,duration: TimeInterval)
    {
        for child in global.overlayNode.children {
            child.removeFromParent()
        }
        global.overlayNode.removeFromParent()
        let wait = SKAction.wait(forDuration: duration)
        
        let newScene = SKAction.run({
            let reveal = SKTransition.reveal(with:SKTransitionDirection.left, duration:1.0)
            if (global.currentSentenceNum % 6) < 3 {
                let nextScene = WordSelectScene(size: self.size,currentSentenceNum:global.currentSentenceNum,correctAnswers:global.correctAnswers,incorrectAnswers:global.incorrectAnswers,currentExtraWordNum:self.currentExtraWordNum,sceneType:global.sceneType)
                self.view?.presentScene(nextScene, transition: reveal)
            }
            else {
                let nextScene = WordDragScene(size: self.size,currentSentenceNum:global.currentSentenceNum,correctAnswers:global.correctAnswers,incorrectAnswers:global.incorrectAnswers,currentExtraWordNum:self.currentExtraWordNum,sceneType:global.sceneType)
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
        
        global.correctAnswers = global.correctAnswers + 1
        labelCorrect.text = "Correct : " + String(global.correctAnswers)
        labelCorrectShadow.text = "Correct : " + String(global.correctAnswers)
        
        if global.correctAnswers + global.incorrectAnswers >= 12 {
            DisplayLevelFinished(scene:self)
        }
        else {
            let playSound = SKAction.playSoundFileNamed("QuizRight.wav", waitForCompletion: false)
            TransitionScene(playSound:playSound,duration:1.5)
        }
    }
    
    func IncorrectAnswerSelected()
    {
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
            let playSound = SKAction.playSoundFileNamed("QuizWrong.wav", waitForCompletion: false)
            TransitionScene(playSound:playSound,duration:4.0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

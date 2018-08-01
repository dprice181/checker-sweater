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

    let SELECTTEXT_FONTSIZE : CGFloat = 23.0
    
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
    let labelInstr3 = SKLabelNode(fontNamed: "Arial")
    let labelCorrect = SKLabelNode(fontNamed: "Arial")
    let labelIncorrect = SKLabelNode(fontNamed: "Arial")
    var labelTitleShadow = SKLabelNode(fontNamed: "MarkerFelt-Thin")
    var labelSubtitleShadow = SKLabelNode(fontNamed: "MarkerFelt-Thin")
    var labelInstrShadow = SKLabelNode(fontNamed: "Arial")
    var labelInstrR2Shadow = SKLabelNode(fontNamed: "Arial")
    var labelInstr2Shadow = SKLabelNode(fontNamed: "Arial")
    var labelInstr3Shadow = SKLabelNode(fontNamed: "Arial")
    var labelCorrectShadow = SKLabelNode(fontNamed: "Arial")
    var labelIncorrectShadow = SKLabelNode(fontNamed: "Arial")
    var lineTitle2 = SKShapeNode()
    let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
    var sentence = ""
    var sentenceData = ""
    
    var currentExtraWordNum = 0
    var answerSelected = false
        
    var levelMode = "n"
    var titleAr = ["n":"NOUNS","v":"VERBS","a":"ADJECTIVES","p":"PREPOSITIONS","d":"ADVERBS"]
    var instrAr = ["n":"noun","v":"verb","a":"adjective","p":"preposition","d":"adverb"]
    var instrAr2 = ["n":"(A Noun is the name of a person place or thing)","v":"(A Verb is an action word)","a":"(An Adjective describes a noun)","p":"(A Preposition relates the noun to the sentence)","d":"(An adverb describes a verb, adjective, or other adverb)"]
    let linkingVerbStr = "(A linking verb connects subject and predicate)"
    
    var background = SKSpriteNode(imageNamed: "background4.png")
    
    init(size: CGSize, currentSentenceNum:Int, correctAnswers:Int, incorrectAnswers:Int, currentExtraWordNum:Int,sceneType:String) {
        super.init(size: size)
        
        self.currentExtraWordNum = currentExtraWordNum
        global.sceneType = sceneType
        backgroundColor = SKColor(red: 234/255, green: 230/255, blue: 236/255, alpha: 1)
        
        GetLevelMode(levelMode:&levelMode)        
        GetSentence(increment:true)        
        SetCorrectAnswer()
        DrawTitle()
        DrawInstructions()
        DrawScoreNode()
        DrawSentence()
        DrawBackButton(scene:self)
        DrawBackground()
    }
    
    func DrawSentence() {
        let mySentence: NSString = sentence as NSString
        let sizeSentence: CGSize = mySentence.size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: GetFontSize(size:SELECTTEXT_FONTSIZE))])
        var widthSentence = sizeSentence.width
        
        let displayWidth = size.width * 9.2 / 10
        
        let space = " "
        let mySpace: NSString = space as NSString
        let sizeSpace: CGSize = mySpace.size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: GetFontSize(size:SELECTTEXT_FONTSIZE))])
        let widthSpace = sizeSpace.width
        
        widthSentence = widthSentence + CGFloat(widthSpace) * CGFloat(wordAr.count)
        
        let widthSentenceHalf = widthSentence / 2
        var startX = size.width / 2 - widthSentenceHalf
        if startX < size.width * 0.04 {
            startX = size.width * 0.04
        }
        var startY:CGFloat = 0.0
        var widthSum:CGFloat = 0.0
        
        var i = 0
        for var word in wordAr {
            word = word + "  "
            let myWord: NSString = word as NSString
            let sizeWord: CGSize = myWord.size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: GetFontSize(size:SELECTTEXT_FONTSIZE))])
            let widthWord = sizeWord.width
            
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
            labelAr[i].position = CGPoint(x: startX + widthSum, y: startY + self.size.height * 11 / 24)
            addChild(labelAr[i])
            addChild(CreateShadowLabel(label: labelAr[i],offset: GetFontSize(size:1)))
            widthSum = widthSum + widthWord
            
            i = i + 1
        }
    }
    
    func DrawTitle() {
        let fullTitle = SKNode()
        fullTitle.position = CGPoint(x: self.size.width/2, y: self.size.height*21/24)
        fullTitle.zPosition = 100.0
        
        labelTitle.text = titleAr[levelMode]!
        labelTitle.fontSize = GetFontSize(size:50)
        labelTitle.fontColor = SKColor.red
        labelTitle.position = .zero
        labelTitle.zPosition = 100.0
        fullTitle.addChild(labelTitle)
        labelTitleShadow = CreateShadowLabel(label: labelTitle,offset: GetFontSize(size:1))
        fullTitle.addChild(labelTitleShadow)
        
        labelSubtitle.text = "Level " + String(global.currentLevel)
        labelSubtitle.fontSize = GetFontSize(size:45)
        labelSubtitle.fontColor = SKColor.red
        labelSubtitle.position = CGPoint(x: 0, y: -self.size.height/12)
        labelSubtitle.zPosition = 100.0
        fullTitle.addChild(labelSubtitle)
        labelSubtitleShadow = CreateShadowLabel(label: labelSubtitle,offset: GetFontSize(size:1))
        fullTitle.addChild(labelSubtitleShadow)
        
        addChild(fullTitle)
    }
    
    func DrawInstructions() {
        labelInstr.text = "Select the " + instrAr[levelMode]!
        labelInstr.fontSize = GetFontSize(size:25)
        labelInstr.fontColor = global.realPurple
        labelInstr.position = CGPoint(x: self.size.width/2, y: self.size.height*17/24)
        labelInstr.zPosition = 100.0
        addChild(labelInstr)
        labelInstrShadow = CreateShadowLabel(label: labelInstr,offset: GetFontSize(size:1))
        addChild(labelInstrShadow)
        
        labelInstrR2.text = "from the sentence below."
        labelInstrR2.fontSize = GetFontSize(size:25)
        labelInstrR2.fontColor = global.realPurple
        labelInstrR2.position = CGPoint(x: self.size.width/2, y: self.size.height*16/24)
        labelInstrR2.zPosition = 100.0
        addChild(labelInstrR2)
        labelInstrR2Shadow = CreateShadowLabel(label: labelInstrR2,offset: GetFontSize(size:1))
        addChild(labelInstrR2Shadow)
        
        var widthSentence : CGFloat = 0
        labelInstr2.text = instrAr2[levelMode]!
        labelInstr2.fontSize = GetWSFontSize(sentence:instrAr2[levelMode]!,fontSize:20,widthSentence: &widthSentence)
        labelInstr2.fontColor = SKColor.red
        labelInstr2.position = CGPoint(x: self.size.width/2, y: self.size.height*14.5/24)
        labelInstr2.zPosition = 100.0
        addChild(labelInstr2)
        labelInstr2Shadow = CreateShadowLabel(label: labelInstr2,offset: GetFontSize(size:1))
        addChild(labelInstr2Shadow)
        
        if levelMode == "v" {
            labelInstr3.text = linkingVerbStr
            labelInstr3.fontSize = GetWSFontSize(sentence:linkingVerbStr,fontSize:20,widthSentence: &widthSentence)
            labelInstr3.fontColor = SKColor.red
            labelInstr3.position = CGPoint(x: self.size.width/2, y: self.size.height*13.5/24)
            labelInstr3.zPosition = 100.0
            addChild(labelInstr3)
            labelInstr3Shadow = CreateShadowLabel(label: labelInstr3,offset: GetFontSize(size:1))
            addChild(labelInstr3Shadow)
            
            var pointsTitle2 = [CGPoint(x:0.0, y:0.0),CGPoint(x:widthSentence*0.95, y:0.0)]
            lineTitle2 = SKShapeNode(points: &pointsTitle2, count: pointsTitle2.count)
            lineTitle2.position = CGPoint(x:(size.width-widthSentence*0.95)/2,y:self.size.height*13.2/24)
            lineTitle2.lineWidth = 2.0
            lineTitle2.strokeColor = SKColor.red
            self.addChild(lineTitle2)
        }
        else {
            var pointsTitle2 = [CGPoint(x:0.0, y:0.0),CGPoint(x:widthSentence*0.95, y:0.0)]
            lineTitle2 = SKShapeNode(points: &pointsTitle2, count: pointsTitle2.count)
            lineTitle2.position = CGPoint(x:(size.width-widthSentence*0.95)/2,y:self.size.height*14.2/24)
            lineTitle2.lineWidth = 2.0
            lineTitle2.strokeColor = SKColor.red
            self.addChild(lineTitle2)
        }
    }
    
    func GetWSFontSize(sentence:String,fontSize:CGFloat,widthSentence: inout CGFloat) -> CGFloat {
        var myFontSize = GetFontSize(size:fontSize)
        let mySentence: NSString = sentence as NSString
        let sizeSentence: CGSize = mySentence.size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: myFontSize)])
        widthSentence = sizeSentence.width
        let displayWidth = size.width * 9.2 / 10
        
        while widthSentence > displayWidth && myFontSize > 8 {
            myFontSize = myFontSize - 1
            let mySentence: NSString = sentence as NSString
            let sizeSentence: CGSize = mySentence.size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: myFontSize)])
            widthSentence = sizeSentence.width
        }
        
        return myFontSize
    }
        
    func DrawBackground() {
        background.position = CGPoint(x: frame.size.width * 5 / 6, y: frame.size.height / 6)
        background.scale(to: CGSize(width: self.size.width/3, height: self.size.height/3))
        addChild(background)
    }
    
    func DrawScoreNode() {
        let scoreNode = SKNode()
        scoreNode.position = CGPoint(x: self.size.width/7, y: self.size.height/24)
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
        if let path = Bundle.main.path(forResource: GetFileName(), ofType: "txt") {
            let fileText = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
            let lineAr = fileText.components(separatedBy: .newlines)
            global.currentSentenceNum = global.currentSentenceNum % lineAr.count
            let sentenceAr = lineAr[global.currentSentenceNum].characters.split{$0 == "*"}.map(String.init)
            //let sentenceAr = lineAr[global.grammarSelectNum].characters.split{$0 == "*"}.map(String.init)
            
            global.currentSentenceNum = (global.currentSentenceNum + 1) % lineAr.count
            if increment {
                global.grammarSelectNum = (global.grammarSelectNum + 1) % lineAr.count  //wrap around at eof
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
    
    func SetCorrectAnswer() {
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
        if answerSelected {
            return
        }
        
        DefaultSentenceColors()
        
        let touchLocation = touch.location(in: self)
        let touchedNode = self.atPoint(touchLocation)
        
        if let labelNode = touchedNode as? SKLabelNode {
            if labelNode.name == "word"  {
                labelNode.fontColor = SKColor.red
            }
        }
    }
    
    func DefaultSentenceColors() {
        for label in labelAr {
            label.fontColor = global.lightBlue
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        if answerSelected {
            return
        }
        
        DefaultSentenceColors()
        
        let touchLocation = touch.location(in: self)
        let touchedNode = self.atPoint(touchLocation)
        if let labelNode = touchedNode as? SKLabelNode {
            if labelNode.name == "word"  {
                labelNode.fontColor = SKColor.red
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
        
        let touchLocation = touch.location(in: self)
        let touchedNode = self.atPoint(touchLocation)
        if let labelNode = touchedNode as? SKLabelNode {
            if labelNode.name == "word"  {
                var correctAnswerSelected = false
                for correctAnswer in correctAnswerAr {
                    if labelNode.text == labelAr[correctAnswer].text {
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
    
    func TransitionScene(playSound: SKAction,duration: TimeInterval) {
        global.overlayNode.removeAllActions()
        global.overlayNode.removeAllChildren()
        global.overlayNode.removeFromParent()
        let wait = SKAction.wait(forDuration: duration)
        
        let newScene = SKAction.run({
            let reveal = SKTransition.reveal(with:SKTransitionDirection.left, duration:1.0)
            let totalCount = global.grammarSelectNum + global.grammarDragNum
            if (totalCount % 6) < 3 {
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
    
    func RemoveLabels() {
        labelInstrR2.removeFromParent()
        labelInstrR2Shadow.removeFromParent()
        labelInstr2.removeFromParent()
        labelInstr2Shadow.removeFromParent()
        labelInstr3.removeFromParent()
        labelInstr3Shadow.removeFromParent()
        lineTitle2.removeFromParent()
    }
    
    func CorrectAnswerSelected() {
        answerSelected = true
        
        labelInstr.text = "Answer Is Correct!!!"
        labelInstr.fontColor = global.blue
        labelInstr.fontSize = GetFontSize(size:30)
        labelInstrShadow.text = "Answer Is Correct!!!"
        labelInstrShadow.fontSize = GetFontSize(size:30)
        
        RemoveLabels()
        
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
        
        for label in labelAr {
            label.fontColor = global.blue
            for correctAnswer in correctAnswerAr {
                if label == labelAr[correctAnswer] {
                    label.fontColor = SKColor.red
                }
            }
        }
        
        labelInstr.text = "Sorry, Answer Is Incorrect"
        labelInstr.fontColor = SKColor.red
        labelInstr.fontSize = GetFontSize(size:30)
        labelInstrShadow.text = "Sorry, Answer Is Incorrect"
        labelInstrShadow.fontSize = GetFontSize(size:30)
        
        RemoveLabels()
        
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

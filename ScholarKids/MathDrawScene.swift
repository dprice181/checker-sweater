//
//  MathDrawScene.swift
//  ScholarKids
//
//  Created by Boo Ja Witzmann on 5/31/18.
//  Copyright © 2018 Doug Price. All rights reserved.
//

import SpriteKit
import GameplayKit

class MathDrawScene: SKScene {
   
    var fingerDown = false
    var circleShadowAr = [SKShapeNode]()
    var problemAr = [String]()
    var labelAnswer = SKLabelNode(fontNamed: "Arial")
    var labelAnswerShadow = SKLabelNode(fontNamed: "Arial")
    var buttonAr = [SKShapeNode]()
    var buttonShadowAr = [SKShapeNode]()
    var buttonLabelAr = [SKLabelNode]()
    var buttonLabelShadowAr = [SKLabelNode]()
    var drawLineAr = [SKShapeNode]()
    let labelTitle = SKLabelNode(fontNamed: "Arial")
    var labelTitleShadow = SKLabelNode(fontNamed: "Arial")
    let labelTitle2 = SKLabelNode(fontNamed: "Arial")
    var labelTitleShadow2 = SKLabelNode(fontNamed: "Arial")
    let labelCorrect = SKLabelNode(fontNamed: "Arial")
    let labelIncorrect = SKLabelNode(fontNamed: "Arial")
    var labelCorrectShadow = SKLabelNode(fontNamed: "Arial")
    var labelIncorrectShadow = SKLabelNode(fontNamed: "Arial")
    var arg1 = 0
    var arg2 = 0
    var oper1 = "+"
    var correctAnswer = 0
    var correctAnswerRemainder = 0
    
    var correctAnswers = 0
    var incorrectAnswers = 0
    var currentSentenceNum = 0
    var currentExtraWordNum = 0
    var sceneType = ""
    
    init(size: CGSize, currentSentenceNum:Int, correctAnswers:Int, incorrectAnswers:Int, currentExtraWordNum:Int,sceneType:String) {
        super.init(size: size)
        
        physicsWorld.gravity = .zero
        backgroundColor = SKColor(red: 234/255, green: 230/255, blue: 236/255, alpha: 1)
        
        self.currentSentenceNum = currentSentenceNum
        self.correctAnswers = correctAnswers
        self.incorrectAnswers = incorrectAnswers
        self.currentExtraWordNum = currentExtraWordNum
        self.sceneType = sceneType
        
        GetProblem()
        
        labelTitle.text = "Use the numbers below to answer"
        labelTitle.fontSize = 23
        labelTitle.fontColor = SKColor.black
        labelTitle.position = CGPoint(x: self.size.width/2, y: self.size.height*22.2/24)
        labelTitle.zPosition = 100.0
        addChild(labelTitle)
        labelTitleShadow = CreateShadowLabel(label: labelTitle,offset: 1)
        addChild(labelTitleShadow)
        
        labelTitle2.text = "(Write your work with your finger)"
        labelTitle2.fontSize = 22
        labelTitle2.fontColor = SKColor.red
        labelTitle2.position = CGPoint(x: self.size.width/2, y: self.size.height*21.3/24)
        labelTitle2.zPosition = 100.0
        addChild(labelTitle2)
        labelTitleShadow2 = CreateShadowLabel(label: labelTitle2,offset: 1)
        addChild(labelTitleShadow2)
        
        if oper1 == "/" {
            AddDivision()
        }
        else {
            let labelArg1 = SKLabelNode(fontNamed: "Arial")
            labelArg1.text = String(arg1)
            labelArg1.fontSize = 80
            labelArg1.fontColor = SKColor.blue
            labelArg1.position = CGPoint(x: self.size.width/2, y: self.size.height*16/24)
            labelArg1.zPosition = 100.0
            addChild(labelArg1)
            addChild(CreateShadowLabel(label: labelArg1,offset: 2))
            
            if let labelArg2 = labelArg1.copy() as? SKLabelNode {
                labelArg2.text = String(arg2)
                labelArg2.position = CGPoint(x: self.size.width/2, y: self.size.height*13.5/24)
                addChild(labelArg2)
                addChild(CreateShadowLabel(label: labelArg2,offset: 2))
            }
            
            if let labelOperand = labelArg1.copy() as? SKLabelNode {
                labelOperand.text = oper1
                labelOperand.position = CGPoint(x: self.size.width/2 + size.width/3.3, y: self.size.height*13.5/24)
                addChild(labelOperand)
                addChild(CreateShadowLabel(label: labelOperand,offset: 2))
            }
            
            var points = [CGPoint(x:0.0, y:0.0),CGPoint(x:self.size.width*6/8, y:0.0)]
            let line = SKShapeNode(points: &points, count: points.count)
            line.position = CGPoint(x:self.size.width/8,y:self.size.height*(13.1)/24)
            line.lineWidth = 5.0
            line.strokeColor = SKColor.blue
            self.addChild(line)
            
            labelAnswer = labelArg1.copy() as! SKLabelNode
            labelAnswer.text = ""
            labelAnswer.position = CGPoint(x: self.size.width/2, y: self.size.height*10.7/24)
            addChild(labelAnswer)
            labelAnswerShadow = CreateShadowLabel(label: labelAnswer,offset: 2)
            addChild(labelAnswerShadow)
        }
        
        DrawNumberButtons()
        DrawOtherButtons()
        DrawCorrectLabels()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func AddDivision() {
        let labelArg1 = SKLabelNode(fontNamed: "Arial")
        labelArg1.text = String(arg1)
        labelArg1.fontSize = 80
        labelArg1.fontColor = SKColor.blue
        labelArg1.position = CGPoint(x: self.size.width/7, y: self.size.height*(12.5)/24)
        labelArg1.zPosition = 100.0
        addChild(labelArg1)
        addChild(CreateShadowLabel(label: labelArg1,offset: 2))
        
        var points = [CGPoint(x:0.0, y:0.0),CGPoint(x:0.0, y:self.size.height/8)]
        let line = SKShapeNode(points: &points, count: points.count)
        line.position = CGPoint(x:self.size.width/3,y:self.size.height*(12.25)/24)
        line.lineWidth = 10.0
        line.strokeColor = SKColor.blue
        self.addChild(line)
        
        var points2 = [CGPoint(x:0.0, y:0.0),CGPoint(x:self.size.width/2, y:0.0)]
        let line2 = SKShapeNode(points: &points2, count: points.count)
        line2.position = CGPoint(x:self.size.width/3,y:self.size.height*(15.1)/24)
        line2.lineWidth = 10.0
        line2.strokeColor = SKColor.blue
        self.addChild(line2)
        
        if let labelArg2 = labelArg1.copy() as? SKLabelNode {
            labelArg2.text = String(arg2)
            labelArg2.position = CGPoint(x: self.size.width/2, y: self.size.height*(12.5)/24)
            addChild(labelArg2)
            addChild(CreateShadowLabel(label: labelArg2,offset: 2))
        }
        
        labelAnswer = labelArg1.copy() as! SKLabelNode
        labelAnswer.text = ""
        labelAnswer.position = CGPoint(x: self.size.width/2, y: self.size.height*15.5/24)
        addChild(labelAnswer)
        labelAnswerShadow = CreateShadowLabel(label: labelAnswer,offset: 2)
        addChild(labelAnswerShadow)
    }
    
    func GetNumber(numDigit: Int) -> Int {
        var range = 1
        var prevRange = 1
        for i in 0..<numDigit {
            prevRange = range
            range = range * 10
        }
        return Int(arc4random_uniform(UInt32(range-prevRange)) + prevRange)
    }
    
    func GetProblem() {
        let randOper = Int(arc4random_uniform(4))
        if randOper == 0 {
            oper1 = "+"
            let rand01 = Int(arc4random_uniform(2))
            let rand2_01 = Int(arc4random_uniform(2))
            arg1 = GetNumber(numDigit: 3+rand01)
            arg2 = GetNumber(numDigit: 3+rand2_01)
            correctAnswer = arg1 + arg2
        }
        else if randOper == 1 {
            oper1 = "-"
            arg1 = GetNumber(numDigit: 3)
            arg2 = GetNumber(numDigit: 3)
            correctAnswer = arg1 - arg2
        }
        else if randOper == 2 {
            oper1 = "X"
            arg1 = GetNumber(numDigit: 2)
            arg2 = GetNumber(numDigit: 2)
            correctAnswer = arg1 * arg2
        }
        else if randOper == 3 {
            oper1 = "/"
            arg1 = GetNumber(numDigit: 2)
            arg2 = GetNumber(numDigit: 2)
            if arg1 > arg2 {
                let temp = arg2
                arg2 = arg1
                arg1 = temp
            }
            correctAnswer = arg2 / arg1
            correctAnswerRemainder = arg2 % arg1
        }
        else {
            oper1 = "+"
            arg1 = GetNumber(numDigit: 2)
            arg2 = GetNumber(numDigit: 2)
            correctAnswer = arg1 + arg2
        }
//        if let path = Bundle.main.path(forResource: "Math4", ofType: "txt")
//        {
//            let fileText = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
//            let lineAr = fileText.components(separatedBy: .newlines)
//            problemAr = lineAr[currentSentenceNum].characters.split{$0 == " "}.map(String.init)
//            self.currentSentenceNum = self.currentSentenceNum + 1
//        }
//        else
//        {
//            print("file not found")
//        }
    }
    
    func DrawCorrectLabels() {
        let scoreNode = SKNode()
        
        scoreNode.position = CGPoint(x: self.size.width*9/10, y: size.height*6/24)
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
    }
    
    func DrawOtherButtons() {
        for i in 0..<5 {
            if i == 0 || i==4 {
                buttonShadowAr.append(SKShapeNode(rectOf: CGSize(width: self.size.width/4,height: self.size.height*2/48),cornerRadius: 30.0))
            }
            else if i == 3 {
                buttonShadowAr.append(SKShapeNode(rectOf: CGSize(width: self.size.width/5,height: self.size.height*2/48),cornerRadius: 30.0))
            }
            else {
                buttonShadowAr.append(SKShapeNode(rectOf: CGSize(width: self.size.width/6,height: self.size.height*2/48),cornerRadius: 30.0))
            }
            buttonShadowAr[i].name = "bshadow" + String(i)
            buttonShadowAr[i].fillColor = SKColor.black
            buttonShadowAr[i].strokeColor = SKColor.black
            buttonShadowAr[i].zPosition = 100.0
            buttonShadowAr[i].lineWidth = 2.0
            
            
            if i == 0 || i==4 {
                buttonAr.append(SKShapeNode(rectOf: CGSize(width: self.size.width/4,height: self.size.height*2/48),cornerRadius: 30.0))
            }
            else if i == 3 {
                buttonAr.append(SKShapeNode(rectOf: CGSize(width: self.size.width/5,height: self.size.height*2/48),cornerRadius: 30.0))
            }
            else {
                buttonAr.append(SKShapeNode(rectOf: CGSize(width: self.size.width/6,height: self.size.height*2/48),cornerRadius: 30.0))
            }
            buttonAr[i].name = "button" + String(i)
            buttonAr[i].fillColor = SKColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
            buttonAr[i].strokeColor = SKColor.red
            buttonAr[i].zPosition = 101.0
            buttonAr[i].lineWidth = 1.5
            
            
            buttonLabelAr.append(SKLabelNode(fontNamed: "Arial"))
            buttonLabelAr[i].name = "buttonlabel" + String(i)
            buttonLabelAr[i].fontSize = 15
            buttonLabelAr[i].fontColor = SKColor.blue
            buttonLabelAr[i].zPosition = 102.0
            
            if i == 3  {
                if oper1 == "-" {
                    addChild(buttonAr[i])
                    addChild(buttonShadowAr[i])
                    addChild(buttonLabelAr[i])
                }
            }
            else if i == 4  {
                if oper1 == "/" {
                    addChild(buttonAr[i])
                    addChild(buttonShadowAr[i])
                    addChild(buttonLabelAr[i])
                }
            }
            else {
                addChild(buttonAr[i])
                addChild(buttonShadowAr[i])
                addChild(buttonLabelAr[i])
            }
            
        }
        buttonShadowAr[0].position = CGPoint(x: self.size.width*6/7 - 2, y: self.size.height*20.5/24 + 2)
        buttonAr[0].position = CGPoint(x: self.size.width*6/7, y: self.size.height*20.5/24)
        buttonLabelAr[0].position = CGPoint(x: self.size.width*6/7, y: self.size.height*20.5/24 - self.size.height/96)
        buttonLabelAr[0].text = "Wipe Screen"
        buttonShadowAr[1].position = CGPoint(x: self.size.width*9/10 - 2, y: self.size.height*9.9/24 + 2)
        buttonAr[1].position = CGPoint(x: self.size.width*9/10, y: self.size.height*9.9/24)
        buttonLabelAr[1].position = CGPoint(x: self.size.width*9/10, y: self.size.height*9.9/24 - self.size.height/96)
        buttonLabelAr[1].text = "Submit"
        buttonShadowAr[2].position = CGPoint(x: self.size.width*9/10 - 2, y: self.size.height*8.4/24 + 2)
        buttonAr[2].position = CGPoint(x: self.size.width*9/10, y: self.size.height*8.4/24)
        buttonLabelAr[2].position = CGPoint(x: self.size.width*9/10, y: self.size.height*8.4/24 - self.size.height/96)
        buttonLabelAr[2].text = "Clear"
        buttonShadowAr[3].position = CGPoint(x: self.size.width/9 - 2, y: self.size.height*11.5/24 + 2)
        buttonAr[3].position = CGPoint(x: self.size.width/9, y: self.size.height*11.5/24)
        buttonLabelAr[3].position = CGPoint(x: self.size.width/9, y: self.size.height*11.5/24 - self.size.height/96)
        buttonLabelAr[3].text = "Put -"
        buttonShadowAr[4].position = CGPoint(x: self.size.width*6/7 - 2, y: self.size.height*18/24 + 2)
        buttonAr[4].position = CGPoint(x: self.size.width*6/7, y: self.size.height*18/24)
        buttonLabelAr[4].position = CGPoint(x: self.size.width*6/7, y: self.size.height*18/24 - self.size.height/96)
        buttonLabelAr[4].text = "Add Remainder"
        buttonLabelAr[4].fontSize = 13
        for j in 0..<5 {
            buttonLabelShadowAr.append(CreateShadowLabel(label: buttonLabelAr[j],offset: 1))
            if j == 3  {
                if oper1 == "-" {
                    addChild(buttonLabelShadowAr[j])
                }
            }
            else if j == 4  {
                if oper1 == "/" {
                    addChild(buttonLabelShadowAr[j])
                }
            }
            else {
                addChild(buttonLabelShadowAr[j])
            }
            
            
        }
    }
    
    func DrawNumberButtons() {
        for i in 1...10 {
            let numText = i % 10
            let circle = SKShapeNode(circleOfRadius: 35)
            var secondRow :CGFloat = 0.0
            if (i-1)/5 > 0 {
                secondRow = 2.7
            }
            circle.position = CGPoint(x:size.width/10 + (size.width/5)*CGFloat((i-1)%5) , y:size.height*(4-secondRow)/24)
            circle.name = "circle" + String(i-1)
            if (i&1) == 0 {
                circle.strokeColor = SKColor.yellow
                circle.fillColor = SKColor.green
            }
            else {
                circle.strokeColor = SKColor.red
                circle.fillColor = SKColor.blue
            }
            circle.lineWidth = 4.0
            circle.zPosition = 100.0
            self.addChild(circle)
            
            circleShadowAr.append(SKShapeNode(circleOfRadius: 35))
            circleShadowAr[i-1].position = CGPoint(x:-2+size.width/10 + (size.width/5)*CGFloat((i-1)%5) , y:2+size.height*(4-secondRow)/24)
            circleShadowAr[i-1].name = "cirshadow" + String(i-1)
            circleShadowAr[i-1].strokeColor = SKColor.black
            circleShadowAr[i-1].fillColor = SKColor.black
            circleShadowAr[i-1].lineWidth = 4.0
            self.addChild(circleShadowAr[i-1])
            
            let numberLabel = SKLabelNode(fontNamed: "Arial")
            numberLabel.text = String(numText)
            numberLabel.fontSize = 36
            if (i&1) == 0 {
                numberLabel.fontColor = SKColor.yellow
            }
            else {
                numberLabel.fontColor = SKColor.red
            }
            numberLabel.position = CGPoint(x:size.width/10 + (size.width/5)*CGFloat((i-1)%5) , y:size.height*(3.6-secondRow)/24)
            numberLabel.zPosition = 102.0
            numberLabel.name = "circle" + String(i-1)
            addChild(numberLabel)            
            addChild(CreateShadowLabel(label: numberLabel,offset: 2))
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let touch = touches.first {
            let location = touch.location(in: self)
            let touchedNode = self.atPoint(location)
            
            for circleShadow in circleShadowAr {
                circleShadow.isHidden = false
            }
            for buttonShadow in buttonShadowAr {
                buttonShadow.isHidden = false
            }

            fingerDown = true;
            if let shapeNode = touchedNode as? SKNode {
                if shapeNode.name?.contains("circle") != nil && (shapeNode.name?.contains("circle"))!  {
                    if let charInd = shapeNode.name?.last {
                        let strInd = String(charInd)
                        if let ind = Int(strInd) {
                            circleShadowAr[ind].isHidden = true
                            fingerDown = false;  //no drawing if they clicked a button
                        }
                    }
                }
                if shapeNode.name?.contains("button") != nil && (shapeNode.name?.contains("button"))!  {
                    if let charInd = shapeNode.name?.last {
                        let strInd = String(charInd)
                        if let ind = Int(strInd) {
                            buttonShadowAr[ind].isHidden = true
                            fingerDown = false;  //no drawing if they clicked a button
                        }
                    }
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        let touchedNode = self.atPoint(location)
        let prevLocation = touch.previousLocation(in: self)
        
        let moveAmount = CGPoint(x:location.x - prevLocation.x,y:location.y-prevLocation.y)
        
        for circleShadow in circleShadowAr {
            circleShadow.isHidden = false
        }
        for buttonShadow in buttonShadowAr {
            buttonShadow.isHidden = false
        }
        
        if fingerDown {
            var points = [CGPoint(x:0.0, y:0.0),moveAmount]
            drawLineAr.append(SKShapeNode(points: &points, count: points.count))
            drawLineAr[drawLineAr.endIndex-1].position = prevLocation
            drawLineAr[drawLineAr.endIndex-1].strokeColor = SKColor.red
            drawLineAr[drawLineAr.endIndex-1].isAntialiased = true
            drawLineAr[drawLineAr.endIndex-1].glowWidth = 4
            drawLineAr[drawLineAr.endIndex-1].fillColor = SKColor.red
            self.addChild(drawLineAr[drawLineAr.endIndex-1])
        }
        else {
            if let shapeNode = touchedNode as? SKNode {
                if shapeNode.name?.contains("circle") != nil && (shapeNode.name?.contains("circle"))!  {
                    if let charInd = shapeNode.name?.last {
                        let strInd = String(charInd)
                        if let ind = Int(strInd) {
                            circleShadowAr[ind].isHidden = true
                        }
                    }
                }
                if shapeNode.name?.contains("button") != nil && (shapeNode.name?.contains("button"))!  {
                    if let charInd = shapeNode.name?.last {
                        let strInd = String(charInd)
                        if let ind = Int(strInd) {
                            buttonShadowAr[ind].isHidden = true
                        }
                    }
                }
            }
            
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>?, with event: UIEvent?) {
        guard let touch = touches?.first else { return }
        let location = touch.location(in: self)
        let touchedNode = self.atPoint(location)
        
        for circleShadow in circleShadowAr {
            circleShadow.isHidden = false
        }
        for buttonShadow in buttonShadowAr {
            buttonShadow.isHidden = false
        }
        
        if fingerDown == false {
            if let shapeNode = touchedNode as? SKNode {
                if shapeNode.name?.contains("circle") != nil && (shapeNode.name?.contains("circle"))!  {
                    if let charInd = shapeNode.name?.last {
                        let strInd = String(charInd)
                        if var ind = Int(strInd) {
                            ind = (ind + 1) % 10
                            CirclePressed(number: String(ind))
                        }
                    }
                }
                if shapeNode.name?.contains("button") != nil && (shapeNode.name?.contains("button"))!  {
                    if let charInd = shapeNode.name?.last {
                        let strInd = String(charInd)
                        if let ind = Int(strInd) {
                            ButtonPressed(ind: ind)
                        }
                    }
                }
            }
        }        
        fingerDown = false
    }
    
    func TransitionScene(playSound: SKAction,duration: TimeInterval)
    {
        let wait = SKAction.wait(forDuration: duration)
        
        let newScene = SKAction.run({
            let reveal = SKTransition.reveal(with:SKTransitionDirection.left, duration:1.0)
            //if (self.currentSentenceNum % 6) < 3 {
                let nextScene = MathDrawScene(size: self.size,currentSentenceNum:self.currentSentenceNum,correctAnswers:self.correctAnswers,incorrectAnswers:self.incorrectAnswers,currentExtraWordNum:self.currentExtraWordNum,sceneType:self.sceneType)
                self.view?.presentScene(nextScene, transition: reveal)
//            }
//            else {
//                let nextScene = VocabularySelectScene(size: self.size,currentSentenceNum:self.currentSentenceNum,correctAnswers:self.correctAnswers,incorrectAnswers:self.incorrectAnswers,currentExtraWordNum:self.currentExtraWordNum,sceneType:self.sceneType)
//                self.view?.presentScene(nextScene, transition: reveal)
//            }
        })
        self.run(SKAction.sequence([playSound,wait,newScene]))
    }
    
    func CorrectAnswerSelected()
    {
        labelTitle.removeFromParent()
        labelTitleShadow.removeFromParent()
        for label in buttonLabelAr {
            label.removeFromParent()
        }
        for label in buttonLabelShadowAr {
            label.removeFromParent()
        }
        for button in buttonAr {
            button.removeFromParent()
        }
        for buttonShadow in buttonShadowAr {
            buttonShadow.removeFromParent()
        }
        
        labelTitle2.text = "Answer Is Correct!!!"
        labelTitle2.fontColor = SKColor.blue
        labelTitle2.fontSize = 30
        labelTitleShadow2.text = "Answer Is Correct!!!"
        labelTitleShadow2.fontSize = 30
        
        self.correctAnswers = self.correctAnswers + 1
        labelCorrect.text = "Correct : " + String(self.correctAnswers)
        labelCorrectShadow.text = "Correct : " + String(self.correctAnswers)
        
        let playSound = SKAction.playSoundFileNamed("Correct-answer.mp3", waitForCompletion: false)
        TransitionScene(playSound:playSound,duration:1.5)
    }
    
    func IncorrectAnswerSelected()
    {
        labelTitle.removeFromParent()
        labelTitleShadow.removeFromParent()
        for label in buttonLabelAr {
            label.removeFromParent()
        }
        for label in buttonLabelShadowAr {
            label.removeFromParent()
        }
        for button in buttonAr {
            button.removeFromParent()
        }
        for buttonShadow in buttonShadowAr {
            buttonShadow.removeFromParent()
        }
    
        labelTitle2.text = "Sorry, Answer Is Incorrect"
        labelTitle2.fontColor = SKColor.red
        labelTitle2.fontSize = 30
        labelTitleShadow2.text = "Sorry, Answer Is Incorrect"
        labelTitleShadow2.fontSize = 30
        labelAnswer.fontColor = SKColor.red
        if correctAnswerRemainder != 0 {
            labelAnswer.text = String(correctAnswer) + "r" + String(correctAnswerRemainder)
            labelAnswerShadow.text = String(correctAnswer) + "r" + String(correctAnswerRemainder)
        }
        else {
            labelAnswer.text = String(correctAnswer)
            labelAnswerShadow.text = String(correctAnswer)
        }
        
        self.incorrectAnswers = self.incorrectAnswers + 1
        labelIncorrect.text = "Missed : " + String(self.incorrectAnswers)
        labelIncorrectShadow.text = "Missed : " + String(self.incorrectAnswers)
        
        let playSound = SKAction.playSoundFileNamed("Error-sound-effect.mp3", waitForCompletion: false)
        TransitionScene(playSound:playSound,duration:4.5)
    }
    
    func ButtonPressed(ind : Int) {
        if ind == 0 {  //Wipe Screen
            for line in drawLineAr {
                line.removeFromParent()
            }
            drawLineAr.removeAll()
        }
        if ind == 1 { //Submit Answer
            SubmitAnswer()
        }
        if ind == 2 { //Clear Answer
            labelAnswer.text = ""
            labelAnswerShadow.text = ""
        }
        if ind == 3 { //negative pressed
            PutNegativePressed()
        }
        if ind == 4 { //negative pressed
            AddRemainderPressed()
        }
    }
    
    func SubmitAnswer() {
        var answerCorrect = false
        if var answer = labelAnswer.text {
            if oper1 == "/" {
                if correctAnswerRemainder != 0 {
                    if answer.contains("r") {
                        var remainder = ""
                        if let index = answer.index(of: "r") {
                            let remainderIndex = answer.index(index, offsetBy: 1)
                            remainder = String(answer.suffix(from: remainderIndex))
                            answer = String(answer.prefix(upTo: index))
                            
                            if let answerInt = Int(answer) {
                                if let remainderInt = Int(remainder) {
                                    print(answerInt,remainderInt,correctAnswer,correctAnswerRemainder)
                                    if correctAnswer == answerInt && correctAnswerRemainder == remainderInt {
                                        answerCorrect = true
                                    }
                                }
                            }
                        }
                    }
                }
                else {
                    if let answerInt = Int(answer) {
                        if correctAnswer == answerInt {
                            answerCorrect = true
                        }
                    }
                }
            }
            else {
                if let answerInt = Int(answer) {
                    if correctAnswer == answerInt {
                        answerCorrect = true
                    }
                }
            }
        }
        if answerCorrect == true {
            CorrectAnswerSelected()
        }
        else {
            IncorrectAnswerSelected()
        }
    }
    
    func AddRemainderPressed() {
        if let answerText = labelAnswer.text {
            if answerText.contains("r") {
                var answerText2 = ""
                if let index = answerText.index(of: "r") {
                    answerText2 = String(answerText.prefix(upTo: index))
                }
                buttonLabelAr[4].text = "Add Remainder"
                buttonLabelShadowAr[4].text = "Add Remainder"
                labelAnswer.text = answerText2
                labelAnswerShadow.text = answerText2
            }
            else {
                buttonLabelAr[4].text = "Rem Remainder"
                buttonLabelShadowAr[4].text = "Rem Remainder"
                labelAnswer.text = answerText + "r"
                labelAnswerShadow.text = answerText + "r"
            }
        }
    }
    
    func PutNegativePressed() {
        if var answerText = labelAnswer.text {
            if answerText.first == "-" {
                answerText.removeFirst()
                buttonLabelAr[3].text = "Put -"
                buttonLabelShadowAr[3].text = "Put -"
                labelAnswer.text = answerText
                labelAnswerShadow.text = answerText
            }
            else {
                buttonLabelAr[3].text = "Remove -"
                buttonLabelShadowAr[3].text = "Remove -"
                labelAnswer.text = "-" + answerText
                labelAnswerShadow.text = "-" + answerText
            }
        }
    }
    
    func CirclePressed(number: String) {
        if let answerText = labelAnswer.text {
            labelAnswer.text = answerText + number
            labelAnswerShadow.text = answerText + number
        }
    }
    
    
}

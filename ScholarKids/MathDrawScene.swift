//
//  MathDrawScene.swift
//  ScholarKids
//
//  Created by Doug Price on 5/31/18.
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
    var buttonAr = [SKSpriteNode]()
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
    var lineTitle2 = SKShapeNode()
    var arg1 = 0
    var arg2 = 0
    var oper1 = "+"
    var correctAnswer = 0
    var correctAnswerRemainder = 0
    var negativeNumbers = false
    
    var currentExtraWordNum = 0
    
    
    init(size: CGSize, currentSentenceNum:Int, correctAnswers:Int, incorrectAnswers:Int, currentExtraWordNum:Int,sceneType:String) {
        super.init(size: size)
        
        physicsWorld.gravity = .zero
        backgroundColor = SKColor(red: 234/255, green: 230/255, blue: 236/255, alpha: 1)
        
        global.currentSentenceNum = currentSentenceNum
        global.correctAnswers = correctAnswers
        global.incorrectAnswers = incorrectAnswers
        self.currentExtraWordNum = currentExtraWordNum
        global.sceneType = sceneType
                
        
        GetProblem()
        DrawTitle()
        DrawProblem()
        DrawNumberButtons()
        DrawOtherButtons()
        DrawCorrectLabels()
        
    }
    
    func DrawProblem() {
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
            addChild(CreateShadowLabel(label: labelArg1,offset: 1.5))
            
            if let labelArg2 = labelArg1.copy() as? SKLabelNode {
                labelArg2.text = String(arg2)
                labelArg2.position = CGPoint(x: self.size.width/2, y: self.size.height*13.5/24)
                addChild(labelArg2)
                addChild(CreateShadowLabel(label: labelArg2,offset: 1.5))
            }
            
            if let labelOperand = labelArg1.copy() as? SKLabelNode {
                labelOperand.text = oper1
                labelOperand.position = CGPoint(x: self.size.width/2 + size.width/3.3, y: self.size.height*13.5/24)
                addChild(labelOperand)
                addChild(CreateShadowLabel(label: labelOperand,offset: 1.5))
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
            labelAnswerShadow = CreateShadowLabel(label: labelAnswer,offset: 1.5)
            addChild(labelAnswerShadow)
        }
    }
    
    func DrawTitle() {
        labelTitle.text = "Answer with the numbers below"
        labelTitle.fontSize = 21
        labelTitle.fontColor = SKColor.black
        labelTitle.position = CGPoint(x: self.size.width/2, y: self.size.height*22.2/24)
        labelTitle.zPosition = 100.0
        addChild(labelTitle)
        labelTitleShadow = CreateShadowLabel(label: labelTitle,offset: 1)
        addChild(labelTitleShadow)
        
        labelTitle2.text = "(Write your work with your finger)"
        labelTitle2.fontSize = 21
        labelTitle2.fontColor = SKColor.red
        labelTitle2.position = CGPoint(x: self.size.width/2, y: self.size.height*21.3/24)
        labelTitle2.zPosition = 100.0
        addChild(labelTitle2)
        labelTitleShadow2 = CreateShadowLabel(label: labelTitle2,offset: 1)
        addChild(labelTitleShadow2)
        
        var pointsTitle2 = [CGPoint(x:0.0, y:0.0),CGPoint(x:self.size.width*3/4, y:0.0)]
        lineTitle2 = SKShapeNode(points: &pointsTitle2, count: pointsTitle2.count)
        lineTitle2.position = CGPoint(x:self.size.width/8,y:self.size.height*21/24)
        lineTitle2.lineWidth = 2.0
        lineTitle2.strokeColor = SKColor.red
        self.addChild(lineTitle2)
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
        addChild(CreateShadowLabel(label: labelArg1,offset: 1))
        
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
            addChild(CreateShadowLabel(label: labelArg2,offset: 1))
        }
        
        labelAnswer = labelArg1.copy() as! SKLabelNode
        labelAnswer.text = ""
        labelAnswer.position = CGPoint(x: self.size.width/2, y: self.size.height*15.5/24)
        addChild(labelAnswer)
        labelAnswerShadow = CreateShadowLabel(label: labelAnswer,offset: 1)
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
    
    func GetNumbers(myOper : String) -> [Int] {
        switch (global.currentGrade) {
        case "K":
            if myOper == "+" {
                if global.currentLevel > 1 {
                    return [Int(arc4random_uniform(10+global.currentLevel)),GetNumber(numDigit: 1)]
                }
            }
            return [GetNumber(numDigit: 1),GetNumber(numDigit: 1)]
        case "1":
            var oper1 = 0
            var oper2 = 0
            if myOper == "-" {
                if global.currentLevel > 5 {
                    oper1 = Int(arc4random_uniform(UInt32(10 * global.currentLevel)))
                    oper2 = Int(arc4random_uniform(UInt32(10 * global.currentLevel)))
                }
                else {
                    oper1 = Int(arc4random_uniform(UInt32(10 * global.currentLevel)))
                    oper2 = GetNumber(numDigit: 1)
                }
                if oper1 < oper2 {
                    let temp = oper1
                    oper1 = oper2
                    oper2 = temp
                }
            }
            else {  //"+"
                oper1 = Int(arc4random_uniform(UInt32(10 * global.currentLevel)))
                oper2 = Int(arc4random_uniform(UInt32(10 * global.currentLevel)))
            }
            return [oper1,oper2]
        case "2":
            var oper1 = 0
            var oper2 = 0
            if myOper == "X" {
                if global.currentLevel > 5 {
                    oper1 = Int(arc4random_uniform(UInt32(5 + global.currentLevel)))
                    oper2 = GetNumber(numDigit: 1)
                }
                else {
                    oper1 = GetNumber(numDigit: 1)
                    oper2 = GetNumber(numDigit: 1)
                }
            }
            else if myOper == "-" {
                oper1 = Int(arc4random_uniform(UInt32(10 + 10 * global.currentLevel)))
                oper2 = Int(arc4random_uniform(UInt32(10 + 10 * global.currentLevel)))
                if oper1 < oper2 {
                    let temp = oper1
                    oper1 = oper2
                    oper2 = temp
                }
            }
            else {  //"+"
                oper1 = Int(arc4random_uniform(UInt32(20 + 10 * global.currentLevel)))
                oper2 = Int(arc4random_uniform(UInt32(20 + 10 * global.currentLevel)))
            }
            return [oper1,oper2]
        case "3":
            var oper1 = 0
            var oper2 = 0
            if myOper == "/" {
                if global.currentLevel > 5 {
                    oper2 = GetNumber(numDigit: 1)
                    oper1 = oper2 * Int(arc4random_uniform(UInt32(global.currentLevel)))
                }
                else if global.currentLevel > 12 {
                    oper1 = GetNumber(numDigit: 1)
                    oper2 = GetNumber(numDigit: 2)
                }
                else {  //should never get here
                    oper1 = GetNumber(numDigit: 1)
                    oper2 = GetNumber(numDigit: 1)
                }
                if oper2 == 0 {
                    oper2 = 1
                }
                else if oper1 < oper2 {
                    let temp = oper1
                    oper1 = oper2
                    oper2 = temp
                }
            }
            else if myOper == "X" {
                if global.currentLevel > 5 {
                    oper1 = Int(arc4random_uniform(UInt32(15 + 5*global.currentLevel)))
                    oper2 = oper1 * Int(arc4random_uniform(UInt32(3*global.currentLevel)))
                }
                else {
                    oper1 = Int(arc4random_uniform(UInt32(15 + 5*global.currentLevel)))
                    oper2 = GetNumber(numDigit: 1)
                }
            }
            else if myOper == "-" {
                oper1 = Int(arc4random_uniform(UInt32(20 + 20 * global.currentLevel)))
                oper2 = Int(arc4random_uniform(UInt32(20 + 20 * global.currentLevel)))
                if oper1 < oper2 {
                    let temp = oper1
                    oper1 = oper2
                    oper2 = temp
                }
            }
            else {  //"+"
                oper1 = Int(arc4random_uniform(UInt32(30 + 30 * global.currentLevel)))
                oper2 = Int(arc4random_uniform(UInt32(30 + 30 * global.currentLevel)))
            }
            return [oper1,oper2]
        case "4":
            var oper1 = 0
            var oper2 = 0
            if myOper == "/" {
                if global.currentLevel > 5 {
                    oper1 = Int(arc4random_uniform(UInt32(10 + 5 * global.currentLevel)))
                    oper2 = Int(arc4random_uniform(UInt32(10 + 10 * global.currentLevel)))
                }
                else if global.currentLevel > 2 {
                    oper1 = Int(arc4random_uniform(UInt32(10 + 3 * global.currentLevel)))
                    oper2 = oper2 * Int(arc4random_uniform(UInt32(5*global.currentLevel)))
                }
                else {
                    oper1 = GetNumber(numDigit: 1)
                    oper2 = oper1 * Int(arc4random_uniform(UInt32(2*global.currentLevel)))
                }
                if oper2 == 0 {
                    oper2 = 1
                }
                else if oper1 < oper2 {
                    let temp = oper1
                    oper1 = oper2
                    oper2 = temp
                }
            }
            else if myOper == "X" {
                oper1 = Int(arc4random_uniform(UInt32(25 + 5*global.currentLevel)))
                oper2 = Int(arc4random_uniform(UInt32(5 + 5*global.currentLevel)))
            }
            else if myOper == "-" {
                oper1 = Int(arc4random_uniform(UInt32(40 + 30 * global.currentLevel)))
                oper2 = Int(arc4random_uniform(UInt32(40 + 30 * global.currentLevel)))
                if oper1 < oper2 {
                    let temp = oper1
                    oper1 = oper2
                    oper2 = temp
                }
            }
            else {  //"+"
                oper1 = Int(arc4random_uniform(UInt32(50 + 50 * global.currentLevel)))
                oper2 = Int(arc4random_uniform(UInt32(50 + 50 * global.currentLevel)))
            }
            return [oper1,oper2]
        case "5","6","7","8","9","10","11","12":
            var oper1 = 0
            var oper2 = 0
            if myOper == "/" {
                oper1 = Int(arc4random_uniform(UInt32(10 + 10 * global.currentLevel)))
                oper2 = Int(arc4random_uniform(UInt32(10 + 20 * global.currentLevel)))
                if oper2 == 0 {
                    oper2 = 1
                }
                else if oper1 < oper2 {
                    let temp = oper1
                    oper1 = oper2
                    oper2 = temp
                }
            }
            else if myOper == "X" {
                oper1 = Int(arc4random_uniform(UInt32(25 + 10*global.currentLevel)))
                oper2 = Int(arc4random_uniform(UInt32(10 + 10*global.currentLevel)))
            }
            else if myOper == "-" {
                oper1 = Int(arc4random_uniform(UInt32(40 + 60 * global.currentLevel)))
                oper2 = Int(arc4random_uniform(UInt32(40 + 60 * global.currentLevel)))
            }
            else {  //"+"
                oper1 = Int(arc4random_uniform(UInt32(50 + 100 * global.currentLevel)))
                oper2 = Int(arc4random_uniform(UInt32(50 + 100 * global.currentLevel)))
            }
            return [oper1,oper2]
        default:
            return [1,1]
            
        }
    }
    
    func GetOperator() -> Int {
        switch (global.currentGrade) {
        case "K":
            if global.currentLevel > 5 {
                return Int(arc4random_uniform(2))
            }
            else {
                return 0
            }
        case "1":
            return Int(arc4random_uniform(2))
        case "2":
            if global.currentLevel > 5 {
                return Int(arc4random_uniform(3))
            }
            else {
                return Int(arc4random_uniform(2))
            }
        case "3":
            if global.currentLevel > 5 {
                return Int(arc4random_uniform(4))
            }
            else {
                return Int(arc4random_uniform(3))
            }
        case "4","5","6","7","8","9","10","11","12":
            return Int(arc4random_uniform(4))
        default:
            return 0
        }
    }
    
    func GetProblem() {
        negativeNumbers = false
        var randOper = GetOperator()
        if randOper == 0 {
            oper1 = "+"
            let numbers = GetNumbers(myOper: oper1)
            arg1 = numbers[0]
            arg2 = numbers[1]
            correctAnswer = arg1 + arg2
        }
        else if randOper == 1 {
            oper1 = "-"
            if let grade = Int(global.currentGrade) {
                if grade >= 5 {
                    negativeNumbers = true
                }
            }
            let numbers = GetNumbers(myOper: oper1)
            arg1 = numbers[0]
            arg2 = numbers[1]
            correctAnswer = arg1 - arg2
        }
        else if randOper == 2 {
            oper1 = "X"
            let numbers = GetNumbers(myOper: oper1)
            arg1 = numbers[0]
            arg2 = numbers[1]
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
            let numbers = GetNumbers(myOper: oper1)
            arg1 = numbers[0]
            arg2 = numbers[1]
            correctAnswer = arg1 + arg2
        }
    }
    
    func DrawCorrectLabels() {
        let scoreNode = SKNode()
        
        scoreNode.position = CGPoint(x: self.size.width*9/10, y: size.height*6/24)
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
    
    func DrawOtherButtons() {
        for i in 0..<5 {
            if i == 0 || i==4 {
                buttonShadowAr.append(SKShapeNode(rectOf: CGSize(width: self.size.width/4,height: self.size.height*2/48),cornerRadius: 40.0))
            }
            else if i == 3 {
                buttonShadowAr.append(SKShapeNode(rectOf: CGSize(width: self.size.width/5,height: self.size.height*2/48),cornerRadius: 40.0))
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
                buttonAr.append(SKSpriteNode(imageNamed: "RedButtonBig.png"))
                buttonAr[i].scale(to: CGSize(width: self.size.width/3.5,height: self.size.height*2.5/48))
            }
            else if i == 3 {
                buttonAr.append(SKSpriteNode(imageNamed: "RedButtonBig.png"))
                buttonAr[i].scale(to: CGSize(width: self.size.width/4.5,height: self.size.height*2.5/48))
            }
            else {
                buttonAr.append(SKSpriteNode(imageNamed: "RedButtonSmall.png"))
                buttonAr[i].scale(to: CGSize(width: self.size.width/5.5,height: self.size.height*2.5/48))
            }
            buttonAr[i].name = "button" + String(i)
            buttonAr[i].zPosition = 101.0
            buttonLabelAr.append(SKLabelNode(fontNamed: "Arial"))
            buttonLabelAr[i].name = "buttonlabel" + String(i)
            buttonLabelAr[i].fontSize = 15
            buttonLabelAr[i].fontColor = SKColor.white
            buttonLabelAr[i].zPosition = 102.0
            
            if i == 3  {
                if oper1 == "-" && negativeNumbers == true {
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
        buttonShadowAr[0].position = CGPoint(x: self.size.width*6/7 - 5, y: self.size.height*20.2/24 + 2)
        buttonAr[0].position = CGPoint(x: self.size.width*6/7, y: self.size.height*20.2/24)
        buttonLabelAr[0].position = CGPoint(x: self.size.width*6/7, y: self.size.height*20.2/24 - self.size.height/96)
        buttonLabelAr[0].text = "Wipe Screen"
        buttonShadowAr[1].position = CGPoint(x: self.size.width*9/10 - 1.5, y: self.size.height*10.2/24 + 1.5)
        buttonAr[1].position = CGPoint(x: self.size.width*9/10, y: self.size.height*10.2/24)
        buttonLabelAr[1].position = CGPoint(x: self.size.width*9/10, y: self.size.height*10.2/24 - self.size.height/96)
        buttonLabelAr[1].text = "Submit"
        buttonShadowAr[2].position = CGPoint(x: self.size.width*9/10 - 1.5, y: self.size.height*8.3/24 + 1.5)
        buttonAr[2].position = CGPoint(x: self.size.width*9/10, y: self.size.height*8.3/24)
        buttonLabelAr[2].position = CGPoint(x: self.size.width*9/10, y: self.size.height*8.3/24 - self.size.height/96)
        buttonLabelAr[2].text = "Clear"
        buttonShadowAr[3].position = CGPoint(x: self.size.width/9 - 3.5, y: self.size.height*11.5/24 + 2.5)
        buttonAr[3].position = CGPoint(x: self.size.width/9, y: self.size.height*11.5/24)
        buttonLabelAr[3].position = CGPoint(x: self.size.width/9, y: self.size.height*11.5/24 - self.size.height/96)
        buttonLabelAr[3].text = "Put -"
        buttonShadowAr[4].position = CGPoint(x: self.size.width*6/7 - 5, y: self.size.height*18/24 + 2)
        buttonAr[4].position = CGPoint(x: self.size.width*6/7, y: self.size.height*18/24)
        buttonLabelAr[4].position = CGPoint(x: self.size.width*6/7, y: self.size.height*18/24 - self.size.height/96)
        buttonLabelAr[4].text = "Add Remainder"
        buttonLabelAr[4].fontSize = 12
        for j in 0..<5 {
            buttonLabelShadowAr.append(CreateShadowLabel(label: buttonLabelAr[j],offset: 1))
            if j == 3  {
                if oper1 == "-" && negativeNumbers == true {
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
            var secondRow :CGFloat = 0.0
            if (i-1)/5 > 0 {
                secondRow = 2.4
            }
            var filename = "SilverButton.png"
            if (i&1) == 1 {
                filename = "GoldButton.png"
            }
            let circle = SKSpriteNode(imageNamed: filename)
            circle.position = CGPoint(x:size.width/10 + (size.width/5)*CGFloat((i-1)%5) , y:size.height*(4-secondRow)/24)
            circle.name = "circle" + String(i-1)
            circle.zPosition = 100.0
            circle.scale(to: CGSize(width: self.size.width/5, height: self.size.width/5))
            self.addChild(circle)
      
            circleShadowAr.append(SKShapeNode(circleOfRadius: 35))
            circleShadowAr[i-1].position = CGPoint(x:-3.0+size.width/10 + (size.width/5)*CGFloat((i-1)%5) , y:3.0+size.height*(4-secondRow)/24)
            circleShadowAr[i-1].name = "cirshadow" + String(i-1)
            circleShadowAr[i-1].strokeColor = SKColor.black
            circleShadowAr[i-1].fillColor = SKColor.black
            circleShadowAr[i-1].lineWidth = 4.0
            self.addChild(circleShadowAr[i-1])
            
            let numberLabel = SKLabelNode(fontNamed: "Arial")
            numberLabel.text = String(numText)
            numberLabel.fontSize = 36
            if (i&1) == 0 {
                numberLabel.fontColor = SKColor(red: 227/255,green:227/255,blue:223/255,alpha:1)
            }
            else {
                numberLabel.fontColor = SKColor(red: 229/255,green:222/255,blue:162/255,alpha:1)
            }
            numberLabel.position = CGPoint(x:size.width/10 + (size.width/5)*CGFloat((i-1)%5) , y:size.height*(3.6-secondRow)/24)
            numberLabel.zPosition = 102.0
            numberLabel.name = "circle" + String(i-1)
            addChild(numberLabel)            
            addChild(CreateShadowLabel(label: numberLabel,offset: 2))
        }
        
        let backButton = SKSpriteNode(imageNamed: "BackwardsClean.png")
        backButton.name = "backbutton"
        backButton.position = CGPoint(x: frame.size.width/20, y: self.size.height*18.5/20)
        backButton.scale(to: CGSize(width: self.size.width/10, height: self.size.width/10))
        addChild(backButton)
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
                if shapeNode.name?.contains("backbutton") != nil && (shapeNode.name?.contains("backbutton"))!  {
                    fingerDown = false;  //no drawing if they clicked a button
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
        fingerDown = false
    }
    
    func TransitionScene(playSound: SKAction,duration: TimeInterval) {
        for child in global.overlayNode.children {
            child.removeFromParent()
        }
        global.overlayNode.removeFromParent()        
        global.currentSentenceNum = global.currentSentenceNum + 1
        
        let wait = SKAction.wait(forDuration: duration)
        
        let newScene = SKAction.run({
            let reveal = SKTransition.reveal(with:SKTransitionDirection.left, duration:1.0)
            if (global.currentSentenceNum % 6) < 3 {
                let nextScene = MathDrawScene(size: self.size,currentSentenceNum:global.currentSentenceNum,correctAnswers:global.correctAnswers,incorrectAnswers:global.incorrectAnswers,currentExtraWordNum:self.currentExtraWordNum,sceneType:global.sceneType)
                self.view?.presentScene(nextScene, transition: reveal)
            }
            else {
                let nextScene = MathDragScene(size: self.size,currentSentenceNum:global.currentSentenceNum,correctAnswers:global.correctAnswers,incorrectAnswers:global.incorrectAnswers,currentExtraWordNum:self.currentExtraWordNum,sceneType:global.sceneType)
                self.view?.presentScene(nextScene, transition: reveal)
            }
        })
        self.run(SKAction.sequence([playSound,wait,newScene]))
    }
    
    func RemoveLabels() {
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
        lineTitle2.removeFromParent()
    }
    
    func CorrectAnswerSelected() {
        RemoveLabels()
        
        labelTitle2.position = CGPoint(x: self.size.width/2, y: self.size.height*20/24)
        labelTitle2.text = "Answer Is Correct!!!"
        labelTitle2.fontColor = SKColor.blue
        labelTitle2.fontSize = 30
        labelTitleShadow2.position = CGPoint(x: self.size.width/2 - 1, y: self.size.height*20/24 + 1)
        labelTitleShadow2.text = "Answer Is Correct!!!"
        labelTitleShadow2.fontSize = 30
        
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
        RemoveLabels()
    
        labelTitle2.position = CGPoint(x: self.size.width/2, y: self.size.height*20/24)
        labelTitle2.text = "Sorry, Answer Is Incorrect"
        labelTitle2.fontColor = SKColor.red
        labelTitle2.fontSize = 30
        labelTitleShadow2.position = CGPoint(x: self.size.width/2 - 1, y: self.size.height*20/24 + 1)
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

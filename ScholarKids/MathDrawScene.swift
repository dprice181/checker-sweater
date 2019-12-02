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
    var buttonShadowAr = [SKSpriteNode]()
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
    let labelHelperText = SKLabelNode(fontNamed: "Arial")
    var labelHelperTextShadow = SKLabelNode(fontNamed: "Arial")
    let labelHelperText2 = SKLabelNode(fontNamed: "Arial")
    var labelHelperTextShadow2 = SKLabelNode(fontNamed: "Arial")
    var helperArrow = SKSpriteNode(imageNamed: "redarrow.png")
    var helperNode = SKNode()
    var lineTitle2 = SKShapeNode()
    var arg1 = 0
    var arg2 = 0
    var oper1 = "+"
    var correctAnswer = 0
    var correctAnswerRemainder = 0
    var negativeNumbers = false
    var currentExtraWordNum = 0
    var answerSelected = false
    var NUMBER_BUTTON_SIZE :CGFloat = 0
    let PROBLEM_FONT_SIZE : CGFloat = 75
    
    init(size: CGSize, currentSentenceNum:Int, correctAnswers:Int, incorrectAnswers:Int, currentExtraWordNum:Int,sceneType:String) {
        super.init(size: size)
        
        physicsWorld.gravity = .zero
        backgroundColor = SKColor(red: 234/255, green: 230/255, blue: 236/255, alpha: 1)
        
        self.currentExtraWordNum = currentExtraWordNum
        global.sceneType = sceneType
        
        NUMBER_BUTTON_SIZE = size.width/5.5
        if global.heightWidthRat < 1.5 {
            NUMBER_BUTTON_SIZE = size.width/6
        }
        
        GetProblem()
        DrawTitle()
        DrawProblem()
        DrawNumberButtons()
        DrawOtherButtons()
        DrawCorrectLabels()
        DrawHelperLabel()
    }
    
    func DrawProblem() {
        if oper1 == "/" {
            AddDivision()
        }
        else {
            let labelArg1 = SKLabelNode(fontNamed: "Arial")
            labelArg1.text = String(arg1)
            labelArg1.fontSize = GetFontSize(size:PROBLEM_FONT_SIZE)
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
        labelTitle.text = "Answer with the buttons below"
        labelTitle.fontSize = GetFontSize(size:18)
        labelTitle.fontColor = global.realPurple
        labelTitle.position = CGPoint(x: self.size.width/2, y: self.size.height*22.1/24)
        labelTitle.zPosition = 100.0
        addChild(labelTitle)
        labelTitleShadow = CreateShadowLabel(label: labelTitle,offset: GetFontSize(size:1))
        addChild(labelTitleShadow)
        
        labelTitle2.text = "(Write your work with your finger)"
        labelTitle2.fontSize = GetFontSize(size:18)
        labelTitle2.fontColor = SKColor.red
        labelTitle2.position = CGPoint(x: self.size.width/2, y: self.size.height*21.3/24)
        labelTitle2.zPosition = 100.0
        addChild(labelTitle2)
        labelTitleShadow2 = CreateShadowLabel(label: labelTitle2,offset: GetFontSize(size:1))
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
        var arg1FontSize : CGFloat = PROBLEM_FONT_SIZE
        var largestCount = String(arg1).count
        if String(arg2).count > largestCount {
            largestCount = String(arg2).count
        }
        if largestCount == 3 {
            arg1FontSize = 60
        }
        else if largestCount == 4 {
            arg1FontSize = 50
        }
        let labelArg1 = SKLabelNode(fontNamed: "Arial")
        labelArg1.text = String(arg1)
        labelArg1.fontSize = GetFontSize(size:arg1FontSize)
        labelArg1.fontColor = SKColor.blue
        if global.heightWidthRat < 1.5 {
            labelArg1.position = CGPoint(x: self.size.width/5, y: self.size.height*(12.5)/24)
        }
        else {
            labelArg1.position = CGPoint(x: self.size.width/6, y: self.size.height*(12.5)/24)
        }
        
        labelArg1.zPosition = 100.0
        addChild(labelArg1)
        addChild(CreateShadowLabel(label: labelArg1,offset: GetFontSize(size:1)))
        
        var points = [CGPoint(x:0.0, y:0.0),CGPoint(x:0.0, y:self.size.height/7.96)]
        let line = SKShapeNode(points: &points, count: points.count)
        line.position = CGPoint(x:self.size.width/2.8,y:self.size.height*(12.25)/24)
        line.lineWidth = GetFontSize(size:10.0)
        line.strokeColor = SKColor.blue
        self.addChild(line)
        
        var points2 = [CGPoint(x:0.0, y:0.0),CGPoint(x:self.size.width/2, y:0.0)]
        let line2 = SKShapeNode(points: &points2, count: points.count)
        line2.position = CGPoint(x:self.size.width/2.8,y:self.size.height*(15.1)/24)
        line2.lineWidth = GetFontSize(size:10.0)
        line2.strokeColor = SKColor.blue
        self.addChild(line2)
        
        if let labelArg2 = labelArg1.copy() as? SKLabelNode {
            labelArg2.text = String(arg2)
            if global.heightWidthRat < 1.5 {
                labelArg2.position = CGPoint(x: self.size.width/2, y: self.size.height*(12.5)/24)
            }
            else {
                labelArg2.position = CGPoint(x: self.size.width/1.8, y: self.size.height*(12.5)/24)
            }
            addChild(labelArg2)
            addChild(CreateShadowLabel(label: labelArg2,offset: GetFontSize(size:1)))
        }
        
        labelAnswer = labelArg1.copy() as! SKLabelNode
        labelAnswer.text = ""
        if global.heightWidthRat < 1.5 {
            labelAnswer.position = CGPoint(x: self.size.width/2, y: self.size.height*15.5/24)
        }
        else {
            labelAnswer.position = CGPoint(x: self.size.width/1.8, y: self.size.height*15.5/24)
        }
        addChild(labelAnswer)
        labelAnswerShadow = CreateShadowLabel(label: labelAnswer,offset: GetFontSize(size:1))
        addChild(labelAnswerShadow)
    }
    
    func GetNumber(numDigit: Int) -> Int {
        var range = 1
        var prevRange = 1
        for _ in 0..<numDigit {
            prevRange = range
            range = range * 10
        }
        return Int(arc4random_uniform(UInt32(range-prevRange)) + UInt32(prevRange))
    }
    
    func GetNumbers(myOper : String) -> [Int] {
        switch (global.currentGrade) {
        case "K":
            if myOper == "+" {
                if global.currentLevel > 1 {
                    return [Int(arc4random_uniform(UInt32(7) + UInt32(2*global.currentLevel))),GetNumber(numDigit: 1)]
                }
                else {
                    return [GetNumber(numDigit: 1),GetNumber(numDigit: 1)]
                }
            }
            else if myOper == "-" {
                var oper1 = Int(arc4random_uniform(UInt32(10 * global.currentLevel)))
                var oper2 = GetNumber(numDigit: 1)
                if oper1 < oper2 {
                    let temp = oper1
                    oper1 = oper2
                    oper2 = temp
                }
                return [oper1,oper2]
            }
            return [GetNumber(numDigit: 1),GetNumber(numDigit: 1)]
        case "1":
            var oper1 = 0
            var oper2 = 0
            if myOper == "-" {
                if global.currentLevel > 5 {
                    oper1 = Int(arc4random_uniform(UInt32(4 + 6 * global.currentLevel)))
                    oper2 = Int(arc4random_uniform(UInt32(5 + 4 * global.currentLevel)))
                }
                else {
                    oper1 = Int(arc4random_uniform(UInt32(7 + 3 * global.currentLevel)))
                    oper2 = GetNumber(numDigit: 1)
                }
                if oper1 < oper2 {
                    let temp = oper1
                    oper1 = oper2
                    oper2 = temp
                }
            }
            else {  //"+"
                oper1 = Int(arc4random_uniform(UInt32(3 + 7 * global.currentLevel)))
                oper2 = Int(arc4random_uniform(UInt32(5 + 5 * global.currentLevel)))
            }
            return [oper1,oper2]
        case "2":
            var oper1 = 0
            var oper2 = 0
            if myOper == "X" {
                if global.currentLevel > 9 {
                    oper1 = Int(arc4random_uniform(UInt32(5 + global.currentLevel)))
                    oper2 = GetNumber(numDigit: 1)
                }
                else {
                    oper1 = GetNumber(numDigit: 1)
                    oper2 = GetNumber(numDigit: 1)
                }
            }
            else if myOper == "-" {
                oper1 = Int(arc4random_uniform(UInt32(10 + 8 * global.currentLevel)))
                oper2 = Int(arc4random_uniform(UInt32(4 + 6 * global.currentLevel)))
                if oper1 < oper2 {
                    let temp = oper1
                    oper1 = oper2
                    oper2 = temp
                }
            }
            else {  //"+"
                oper1 = Int(arc4random_uniform(UInt32(20 + 8 * global.currentLevel)))
                oper2 = Int(arc4random_uniform(UInt32(3 + 7 * global.currentLevel)))
            }
            return [oper1,oper2]
        case "3":
            var oper1 = 0
            var oper2 = 0
            if myOper == "/" {
                if global.currentLevel > 12 {
                    oper1 = GetNumber(numDigit: 1)
                    oper2 = GetNumber(numDigit: 2)
                }
                else if global.currentLevel > 5 {
                    oper1 = GetNumber(numDigit: 1)
                    oper2 = oper1 * Int(arc4random_uniform(UInt32(global.currentLevel)))
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
                    oper1 = Int(arc4random_uniform(UInt32(8 + 5*global.currentLevel)))
                    oper2 = GetNumber(numDigit: 1)
                }
            }
            else if myOper == "-" {
                oper1 = Int(arc4random_uniform(UInt32(20 + 15 * global.currentLevel)))
                oper2 = Int(arc4random_uniform(UInt32(20 + 10 * global.currentLevel)))
                if oper1 < oper2 {
                    let temp = oper1
                    oper1 = oper2
                    oper2 = temp
                }
            }
            else {  //"+"
                oper1 = Int(arc4random_uniform(UInt32(30 + 15 * global.currentLevel)))
                oper2 = Int(arc4random_uniform(UInt32(30 + 15 * global.currentLevel)))
            }
            return [oper1,oper2]
        case "4":
            var oper1 = 0
            var oper2 = 0
            if myOper == "/" {
                if global.currentLevel > 5 {
                    oper1 = Int(arc4random_uniform(UInt32(5 + 5 * global.currentLevel)))
                    oper2 = Int(arc4random_uniform(UInt32(5 + 10 * global.currentLevel)))
                }
                else if global.currentLevel > 2 {
                    oper1 = Int(arc4random_uniform(UInt32(10 + 3 * global.currentLevel)))
                    oper2 = oper1 * Int(arc4random_uniform(UInt32(5*global.currentLevel)))
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
                oper1 = Int(arc4random_uniform(UInt32(20 + 5*global.currentLevel)))
                oper2 = Int(arc4random_uniform(UInt32(5 + 5*global.currentLevel)))
            }
            else if myOper == "-" {
                oper1 = Int(arc4random_uniform(UInt32(40 + 25 * global.currentLevel)))
                oper2 = Int(arc4random_uniform(UInt32(40 + 25 * global.currentLevel)))
                if oper1 < oper2 {
                    let temp = oper1
                    oper1 = oper2
                    oper2 = temp
                }
            }
            else {  //"+"
                oper1 = Int(arc4random_uniform(UInt32(50 + 40 * global.currentLevel)))
                oper2 = Int(arc4random_uniform(UInt32(50 + 40 * global.currentLevel)))
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
                oper2 = Int(arc4random_uniform(UInt32(5 + 10*global.currentLevel)))
            }
            else if myOper == "-" {
                oper1 = Int(arc4random_uniform(UInt32(100 + 50 * global.currentLevel)))
                oper2 = Int(arc4random_uniform(UInt32(100 + 50 * global.currentLevel)))
            }
            else {  //"+"
                oper1 = Int(arc4random_uniform(UInt32(150 + 50 * global.currentLevel)))
                oper2 = Int(arc4random_uniform(UInt32(150 + 50 * global.currentLevel)))
            }
            return [oper1,oper2]
        default:
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
                oper1 = Int(arc4random_uniform(UInt32(15 + 10*global.currentLevel)))
                oper2 = Int(arc4random_uniform(UInt32(5 + 10*global.currentLevel)))
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
            return Int(arc4random_uniform(4))
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
            let numbers = GetNumbers(myOper: oper1)
            arg1 = numbers[0]
            arg2 = numbers[1]
            if arg1 > arg2 {
                let temp = arg2
                arg2 = arg1
                arg1 = temp
            }
            if arg2 < 1 {
                arg2 = 1
            }
            if arg1 < 1 {
                arg1 = 1
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
    
    func DrawHelperLabel() {
        helperArrow.scale(to: CGSize(width: self.size.width/8,height: self.size.height/12))
        helperArrow.position = CGPoint(x: self.size.width/3, y: size.height*1/64)
        helperNode.addChild(helperArrow)
        
        if global.heightWidthRat < 1.5 {
            helperNode.position = CGPoint(x: self.size.width/3.5, y: size.height*6.8/24)
        }
        else {
            helperNode.position = CGPoint(x: self.size.width/3.5, y: size.height*6/24)
        }
        helperNode.zPosition = 100.0
        labelHelperText.text = "Enter final answer"
        labelHelperText.fontSize = GetFontSize(size:20)
        labelHelperText.fontColor = SKColor.red
        if global.heightWidthRat < 1.5 {
            labelHelperText.position = CGPoint(x: 0, y: self.size.height/32)
        }
        else {
            labelHelperText.position = CGPoint(x: 0, y: self.size.height/24)
        }
        helperNode.addChild(labelHelperText)
        labelHelperTextShadow = CreateShadowLabel(label: labelHelperText,offset: GetFontSize(size:1))
        helperNode.addChild(labelHelperTextShadow)
        
        labelHelperText2.text = "with buttons below"
        labelHelperText2.fontSize = GetFontSize(size:20)
        labelHelperText2.fontColor = SKColor.red
        labelHelperText2.position = CGPoint(x: 0, y: 0)
        helperNode.addChild(labelHelperText2)
        labelHelperTextShadow2 = CreateShadowLabel(label: labelHelperText2,offset: GetFontSize(size:1))
        helperNode.addChild(labelHelperTextShadow2)
    }
    
    func DrawCorrectLabels() {
        let scoreNode = SKNode()
        if global.heightWidthRat < 1.5 {
            scoreNode.position = CGPoint(x: self.size.width*6/7, y: size.height*6.8/24)
        }
        else {
            scoreNode.position = CGPoint(x: self.size.width*6/7, y: size.height*6/24)
        }
        scoreNode.zPosition = 100.0
        
        labelCorrect.text = "Correct : " + String(global.correctAnswers)
        labelCorrect.fontSize = GetFontSize(size:15)
        labelCorrect.fontColor = SKColor.red
        if global.heightWidthRat < 1.5 {
            labelCorrect.position = CGPoint(x: 0, y: self.size.height/32)
        }
        else {
            labelCorrect.position = CGPoint(x: 0, y: self.size.height/24)
        }
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
    
    func DrawOtherButtons() {
        var offYSubmitClear : CGFloat = 0
        var yMult : CGFloat = 1
        if global.heightWidthRat < 1.5 {
            offYSubmitClear = self.size.height/32
            yMult = 1.5 / global.heightWidthRat
        }
        
        for i in 0..<5 {
            if i == 0 || i==4 {
                buttonShadowAr.append(SKSpriteNode(imageNamed: "RedButtonBigShadow.png"))
                buttonShadowAr[i].scale(to: CGSize(width: self.size.width/3.5,height: yMult * (self.size.height*2.5/48)))
            }
            else if i == 3 {
                buttonShadowAr.append(SKSpriteNode(imageNamed: "RedButtonBigShadow.png"))
                buttonShadowAr[i].scale(to: CGSize(width: self.size.width/4.5,height: yMult * (self.size.height*2.5/48)))
            }
            else {
                buttonShadowAr.append(SKSpriteNode(imageNamed: "RedButtonSmallShadow.png"))
                buttonShadowAr[i].scale(to: CGSize(width: self.size.width/5.5,height: yMult * (self.size.height*2.5/48)))
            }
            buttonShadowAr[i].name = "bshadow" + String(i)
            buttonShadowAr[i].zPosition = 100.0
            
            if i == 0 || i==4 {
                buttonAr.append(SKSpriteNode(imageNamed: "RedButtonBig.png"))
                buttonAr[i].scale(to: CGSize(width: self.size.width/3.5,height: yMult * (self.size.height*2.5/48)))
            }
            else if i == 3 {
                buttonAr.append(SKSpriteNode(imageNamed: "RedButtonBig.png"))
                buttonAr[i].scale(to: CGSize(width: self.size.width/4.5,height: yMult * (self.size.height*2.5/48)))
            }
            else {
                buttonAr.append(SKSpriteNode(imageNamed: "RedButtonSmall.png"))
                buttonAr[i].scale(to: CGSize(width: self.size.width/5.5,height: yMult * (self.size.height*2.5/48)))
            }
            buttonAr[i].name = "button" + String(i)
            buttonAr[i].zPosition = 101.0
            buttonLabelAr.append(SKLabelNode(fontNamed: "Arial"))
            buttonLabelAr[i].name = "buttonlabel" + String(i)
            buttonLabelAr[i].fontSize = GetFontSize(size:15)
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
        buttonShadowAr[0].position = CGPoint(x: self.size.width*5.75/7 - GetFontSize(size:1.5), y: self.size.height*19.8/24 + GetFontSize(size:1.5))
        buttonAr[0].position = CGPoint(x: self.size.width*5.75/7, y: self.size.height*19.8/24)
        buttonLabelAr[0].position = CGPoint(x: self.size.width*5.75/7, y: self.size.height*19.8/24 - self.size.height/96)
        buttonLabelAr[0].text = "Wipe Screen"
        buttonShadowAr[1].position = CGPoint(x: self.size.width*8.7/10 - GetFontSize(size:1.5), y: self.size.height*10.3/24 + GetFontSize(size:1.5) + offYSubmitClear)
        buttonAr[1].position = CGPoint(x: self.size.width*8.7/10, y: self.size.height*10.3/24 + offYSubmitClear)
        buttonLabelAr[1].position = CGPoint(x: self.size.width*8.7/10, y: self.size.height*10.3/24 - self.size.height/96 + offYSubmitClear)
        buttonLabelAr[1].text = "Submit"
        buttonShadowAr[2].position = CGPoint(x: self.size.width*8.7/10 - GetFontSize(size:1.5), y: self.size.height*8.4/24 + GetFontSize(size:1.5) + offYSubmitClear)
        buttonAr[2].position = CGPoint(x: self.size.width*8.7/10, y: self.size.height*8.4/24 + offYSubmitClear)
        buttonLabelAr[2].position = CGPoint(x: self.size.width*8.7/10, y: self.size.height*8.4/24 - self.size.height/96 + offYSubmitClear)
        buttonLabelAr[2].text = "Clear"
        buttonShadowAr[3].position = CGPoint(x: self.size.width/8 - GetFontSize(size:1.5), y: self.size.height*11.5/24 + GetFontSize(size:1.5))
        buttonAr[3].position = CGPoint(x: self.size.width/8, y: self.size.height*11.5/24)
        buttonLabelAr[3].position = CGPoint(x: self.size.width/8, y: self.size.height*11.5/24 - self.size.height/96)
        buttonLabelAr[3].text = "Put -"
        buttonShadowAr[4].position = CGPoint(x: self.size.width*5.75/7 - GetFontSize(size:1.5), y: self.size.height*18/24 + GetFontSize(size:1.5))
        buttonAr[4].position = CGPoint(x: self.size.width*5.75/7, y: self.size.height*18/24)
        buttonLabelAr[4].position = CGPoint(x: self.size.width*5.75/7, y: self.size.height*18/24 - self.size.height/96)
        buttonLabelAr[4].text = "Add Remainder"
        buttonLabelAr[4].fontSize = GetFontSize(size:12)
        for j in 0..<5 {
            buttonLabelShadowAr.append(CreateShadowLabel(label: buttonLabelAr[j],offset: GetFontSize(size:1)))
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
            var offY = 1.3*(2 - global.heightWidthRat)
            if offY < 0 {
                offY = 0
            }
            let numText = i % 10
            var secondRow :CGFloat = 0.0
            if (i-1)/5 > 0 {
                secondRow = 2.2 + offY
            }
            var filename = "SilverButton.png"
            if (i&1) == 1 {
                filename = "GoldButton.png"
            }
            let circle = SKSpriteNode(imageNamed: filename)
            circle.position = CGPoint(x:size.width*0.135 + (size.width/5.4)*CGFloat((i-1)%5) , y:size.height*(offY+4-secondRow)/24)
            circle.name = "circle" + String(i-1)
            circle.zPosition = 100.0
            circle.scale(to: CGSize(width: NUMBER_BUTTON_SIZE, height: NUMBER_BUTTON_SIZE))
            self.addChild(circle)
      
            if global.heightWidthRat < 1.5 {
                circleShadowAr.append(SKShapeNode(circleOfRadius: GetFontSize(size:45)))
            }
            else if size.width < 375 {
                circleShadowAr.append(SKShapeNode(circleOfRadius: GetFontSize(size:35.5)))
            }
            else {
                circleShadowAr.append(SKShapeNode(circleOfRadius: GetFontSize(size:33.5)))
            }
            circleShadowAr[i-1].position = CGPoint(x:GetFontSize(size:-1.5)+size.width*0.135 + (size.width/5.4)*CGFloat((i-1)%5) ,y:GetFontSize(size:1.5)+size.height*(offY+4-secondRow)/24)
            circleShadowAr[i-1].name = "cirshadow" + String(i-1)
            circleShadowAr[i-1].strokeColor = SKColor.black
            circleShadowAr[i-1].fillColor = SKColor.black
            circleShadowAr[i-1].lineWidth = GetFontSize(size:4.0)
            self.addChild(circleShadowAr[i-1])
            
            let numberLabel = SKLabelNode(fontNamed: "Arial")
            numberLabel.text = String(numText)
            numberLabel.fontSize = GetFontSize(size:36)
            if (i&1) == 0 {
                numberLabel.fontColor = SKColor(red: 227/255,green:227/255,blue:223/255,alpha:1)
            }
            else {
                numberLabel.fontColor = SKColor(red: 229/255,green:222/255,blue:162/255,alpha:1)
            }
            numberLabel.position = CGPoint(x:size.width*0.135 + (size.width/5.4)*CGFloat((i-1)%5) , y:size.height*(offY+3.6-secondRow)/24)
            numberLabel.zPosition = 102.0
            numberLabel.name = "circle" + String(i-1)
            addChild(numberLabel)            
            addChild(CreateShadowLabel(label: numberLabel,offset: GetFontSize(size:2)))
        }
        
        DrawBackButton(scene: self)        
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

            fingerDown = true
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
                if shapeNode.name?.contains("home") != nil && (shapeNode.name?.contains("home"))!  {
                    fingerDown = false;  //no drawing if they clicked a button
                }
                if shapeNode.name?.contains("retry") != nil && (shapeNode.name?.contains("retry"))!  {
                    fingerDown = false;  //no drawing if they clicked a button
                }
                if shapeNode.name?.contains("next") != nil && (shapeNode.name?.contains("next"))!  {
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
            drawLineAr[drawLineAr.endIndex-1].lineWidth = GetFontSize(size:5)
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
                    global.currentSentenceNum = 12 * (global.currentLevel-1)
                    var playSound = SKAction.playSoundFileNamed("QuizRight.wav", waitForCompletion: false)
                    if global.soundOption > 0 {
                        playSound = SKAction.wait(forDuration: 0.0001)
                    }
                    TransitionScene(playSound:playSound,duration:0.0)
                }
                if shapeNode.name?.contains("next") != nil && (shapeNode.name?.contains("next"))!  {
                    shapeNode.name?.contains("next") != nil
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
        fingerDown = false
    }
    
    func TransitionScene(playSound: SKAction,duration: TimeInterval) {
        global.overlayNode.removeAllActions()
        global.overlayNode.removeAllChildren()
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
        answerSelected = true
        RemoveLabels()
        
        labelTitle2.position = CGPoint(x: self.size.width/2, y: self.size.height*20/24)
        labelTitle2.text = "Answer Is Correct!!!"
        labelTitle2.fontColor = global.blue
        labelTitle2.fontSize = GetFontSize(size:30)
        labelTitleShadow2.position = CGPoint(x: self.size.width/2 - GetFontSize(size:1), y: self.size.height*20/24 + GetFontSize(size:1))
        labelTitleShadow2.text = "Answer Is Correct!!!"
        labelTitleShadow2.fontSize = GetFontSize(size:30)
        
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
        RemoveLabels()
    
        labelTitle2.position = CGPoint(x: self.size.width/2, y: self.size.height*20/24)
        labelTitle2.text = "Sorry, Answer Is Incorrect"
        labelTitle2.fontColor = SKColor.red
        labelTitle2.fontSize = GetFontSize(size:30)
        labelTitleShadow2.position = CGPoint(x: self.size.width/2 - GetFontSize(size:1), y: self.size.height*20/24 + GetFontSize(size:1))
        labelTitleShadow2.text = "Sorry, Answer Is Incorrect"
        labelTitleShadow2.fontSize = GetFontSize(size:30)
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
            buttonLabelAr[3].text = "Put -"
            buttonLabelShadowAr[3].text = "Put -"
            buttonLabelAr[4].text = "Add Remainder"
            buttonLabelShadowAr[4].text = "Add Remainder"
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
            if (answer.count == 0) {
                var playSound = SKAction.playSoundFileNamed("WrongProgress.wav", waitForCompletion: false)
                if global.soundOption > 0 {
                    playSound = SKAction.wait(forDuration: 0.0001)
                }
                helperNode.removeFromParent()
                addChild(helperNode)
                self.run(SKAction.sequence([playSound]))
                return
            }
            
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
            helperNode.removeFromParent()
        }
    }
}

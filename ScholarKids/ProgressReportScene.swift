//
//  ProgressReportScene.swift
//  ScholarKids
//
//  Created by Doug Price on 7/13/18.
//  Copyright © 2018 Doug Price. All rights reserved.
//


import SpriteKit
import GameplayKit

class ProgressReportScene: SKScene {
    let GRAPH_OFFSET_Y_MULT :CGFloat = 1.4
    var currentExtraWordNum = 0
    var graphWindowWidth : CGFloat = 0.0
    var graphWindowX : CGFloat = 0.0
    var graphWindowHeight : CGFloat = 0.0
    var graphWindowY : CGFloat = 0.0
    
    var subjectAr = ["Spelling","Vocabulary","Grammar","Math"]
    
    init(size: CGSize, currentSentenceNum:Int, correctAnswers:Int, incorrectAnswers:Int, currentExtraWordNum:Int,sceneType:String) {
        super.init(size: size)                
        
        physicsWorld.gravity = .zero
        backgroundColor = SKColor(red: 234/255, green: 230/255, blue: 236/255, alpha: 1)
        
        self.currentExtraWordNum = currentExtraWordNum
        global.sceneType = sceneType
        
        graphWindowWidth = self.size.width*15/20
        graphWindowX = self.size.width/2 + self.size.width/16
        graphWindowHeight = self.size.height*7/48
        graphWindowY = self.size.height*3/24
        
        DrawTitle()
        DrawPercentageCorrect()
        DrawGraph()
        DrawBackButton(scene:self)
    }
        
    func DrawLine(subjectInd:Int,data:[String]) {
        let graphOffsetY = graphWindowHeight * GRAPH_OFFSET_Y_MULT
        let posX : CGFloat = self.size.width*4.5/24
        let posY : CGFloat = (graphOffsetY * CGFloat(subjectInd)) + graphWindowY - graphWindowHeight/2
        let offXInc : CGFloat = graphWindowWidth / CGFloat(global.maxLevels)
        var prevOffY : CGFloat = 0.0
        var i = 0
        var offX : CGFloat = 0.0
        for valString in data {
            if let value = Int(valString) {
                if value < 0 {
                    continue
                }
                let offY : CGFloat = graphWindowHeight * CGFloat(value) / 12
                if i == 0 {
                    prevOffY = offY
                }
                var points = [CGPoint(x:offX, y:prevOffY),CGPoint(x:offX+offXInc, y:offY)]
                let line = SKShapeNode(points: &points, count: points.count)
                line.position = CGPoint(x:posX,y:posY)
                line.strokeColor = SKColor.blue
                line.lineWidth = 2
                self.addChild(line)
                
                prevOffY = offY
                offX = offX + offXInc
            }
            i = i + 1
        }
    }
    
    func DrawLines(subjectInd: Int) {
        let file = "Players.txt" //this is the file. we will write to and read from it
        if let dir = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true).first {
            let path = dir + "/" + file
            do {
                var fileText = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
                var lineAr = fileText.components(separatedBy: .newlines)
                if lineAr.count > 0 {
                    for i in 0..<lineAr.count {
                        var playerDataAr = lineAr[i].characters.split{$0 == "*"}.map(String.init)
                        if playerDataAr.count < 6 {
                            continue
                        }
                        if global.currentStudent == playerDataAr[0] {
                            var data = [String]()
                            if subjectInd == 0 { //spelling
                                data = playerDataAr[5].characters.split{$0 == " "}.map(String.init)
                            }
                            else if subjectInd == 1 { //vocabulary
                                data = playerDataAr[4].characters.split{$0 == " "}.map(String.init)
                            }
                            else if subjectInd == 2 { //grammar
                                data = playerDataAr[3].characters.split{$0 == " "}.map(String.init)
                            }
                            else if subjectInd == 3 { //math
                                data = playerDataAr[2].characters.split{$0 == " "}.map(String.init)
                            }
                            if data.count > 0 {
                                DrawLine(subjectInd:subjectInd,data:data)
                            }
                        }
                    }
                }
            }
            catch {
                print("File read error:", error)
            }
        }
    }
    
    func DrawPercentageCorrect() {
        let labelPercentCorrect = SKLabelNode(fontNamed: "MarkerFelt-Thin")
        labelPercentCorrect.text = "% Correct"
        labelPercentCorrect.fontSize = GetFontSize(size:15)
        labelPercentCorrect.fontColor = SKColor.red
        labelPercentCorrect.position = CGPoint(x: self.size.width/7.75, y: self.size.height*8.25/10)
        labelPercentCorrect.zPosition = 100.0
        addChild(labelPercentCorrect)
        let labelPercentCorrectShadow = CreateShadowLabel(label: labelPercentCorrect,offset: GetFontSize(size:1))
        addChild(labelPercentCorrectShadow)
    }
    
    func DrawGraph() {
        let offsetY = graphWindowHeight * GRAPH_OFFSET_Y_MULT
        for i in 0..<4 {
            let labelSubject = SKLabelNode(fontNamed: "ChalkDuster")
            labelSubject.text = subjectAr[i]
            labelSubject.fontSize = GetFontSize(size:20)
            labelSubject.fontColor = SKColor.blue
            labelSubject.position = CGPoint(x: graphWindowX, y: (offsetY * CGFloat(i)) + graphWindowY + graphWindowHeight/2)
            labelSubject.zPosition = 100.0
            addChild(labelSubject)
            let labelSubjectShadow = CreateShadowLabel(label: labelSubject,offset: GetFontSize(size:1))
            addChild(labelSubjectShadow)
            
            let graphWindow = SKShapeNode(rectOf: CGSize(width: graphWindowWidth,height: graphWindowHeight))
            graphWindow.name = "graphWindow"
            graphWindow.fillColor = global.greyBlue
            graphWindow.strokeColor = SKColor.purple
            graphWindow.position = CGPoint(x: graphWindowX,y: (offsetY * CGFloat(i)) + graphWindowY)
            addChild(graphWindow)
            
            DrawBottomNotches(offsetY:(offsetY * CGFloat(i)))
            DrawLeftNotches(offsetY:(offsetY * CGFloat(i)))
            
            DrawLines(subjectInd:i)
        }
    }

    func DrawPercentage(percentage: String,xPos: CGFloat,yPos: CGFloat) {
        let labelSubject = SKLabelNode(fontNamed: "MarkerFelt-Thin")
        labelSubject.text = percentage
        labelSubject.fontSize = GetFontSize(size:14)
        labelSubject.fontColor = SKColor.red
        labelSubject.position = CGPoint(x: xPos-self.size.width/12, y: yPos-self.size.width/48)
        labelSubject.zPosition = 100.0
        addChild(labelSubject)
        let labelSubjectShadow = CreateShadowLabel(label: labelSubject,offset: GetFontSize(size:1))
        addChild(labelSubjectShadow)
    }
    
    func DrawLeftNotches(offsetY: CGFloat) {
        let notchHeight = self.size.height/160
        let xPos = graphWindowX - graphWindowWidth/2
        var yPos = offsetY + graphWindowY-graphWindowHeight/2
        for i in 0...20 {
            var points = [CGPoint]()
            if i % 5 == 0 {
                DrawPercentage(percentage:String(i*5),xPos:xPos,yPos:yPos)
                points = [CGPoint(x:0.0, y:0.0),CGPoint(x:-2 * notchHeight, y:0.0)]
            }
            else {
                points = [CGPoint(x:0.0, y:0.0),CGPoint(x:-notchHeight, y:0.0)]
            }
            var lineAr = [SKShapeNode]()
            lineAr.append(SKShapeNode(points: &points, count: points.count))
            lineAr[lineAr.endIndex-1].position = CGPoint(x: xPos,y: yPos)
            lineAr[lineAr.endIndex-1].strokeColor = SKColor.red
            lineAr[lineAr.endIndex-1].isAntialiased = true
            if i % 5 == 0 {
                lineAr[lineAr.endIndex-1].lineWidth = 4
            }
            else {
                lineAr[lineAr.endIndex-1].lineWidth = 2
            }
            lineAr[lineAr.endIndex-1].fillColor = SKColor.red
            addChild(lineAr[lineAr.endIndex-1])
            
            yPos = yPos + graphWindowHeight/20
        }
    }
    
    func DrawBottomNotches(offsetY: CGFloat) {
        let notchHeight = self.size.height/160
        let levelOffset = -4.5 * notchHeight
        var xPos = graphWindowX - graphWindowWidth/2
        for i in 0...global.maxLevels {
            var points = [CGPoint]()
            if i % 5 == 0 {
                DrawLevelNumber(level:i,xPos:xPos,yPos:offsetY + graphWindowY-graphWindowHeight/2 + levelOffset)
                points = [CGPoint(x:0.0, y:0.0),CGPoint(x:0.0, y:-2 * notchHeight)]
            }
            else {
                points = [CGPoint(x:0.0, y:0.0),CGPoint(x:0.0, y:-notchHeight)]
            }
            var lineAr = [SKShapeNode]()
            lineAr.append(SKShapeNode(points: &points, count: points.count))
            lineAr[lineAr.endIndex-1].position = CGPoint(x: xPos,y: offsetY + graphWindowY-graphWindowHeight/2)
            lineAr[lineAr.endIndex-1].strokeColor = SKColor.red
            lineAr[lineAr.endIndex-1].isAntialiased = true
            if i % 5 == 0 {
                lineAr[lineAr.endIndex-1].lineWidth = 4
            }
            else {
                lineAr[lineAr.endIndex-1].lineWidth = 2
            }
            lineAr[lineAr.endIndex-1].fillColor = SKColor.red
            addChild(lineAr[lineAr.endIndex-1])
            
            xPos = xPos + graphWindowWidth/CGFloat(global.maxLevels)
        }
    }
    
    func DrawLevelNumber(level:Int,xPos:CGFloat,yPos:CGFloat) {
        let labelTitle = SKLabelNode(fontNamed: "MarkerFelt-Thin")
        labelTitle.text = String(level)
        labelTitle.fontSize = GetFontSize(size:14)
        labelTitle.fontColor = SKColor.red
        labelTitle.position = CGPoint(x:xPos,y:yPos)
        labelTitle.zPosition = 100.0
        addChild(labelTitle)
        let labelTitleShadow = CreateShadowLabel(label: labelTitle,offset: GetFontSize(size:1))
        addChild(labelTitleShadow)
    }
    
    func DrawTitle() {
        let fullTitle = SKNode()
        fullTitle.position = CGPoint(x: self.size.width/2, y: self.size.height*9/10)
        fullTitle.zPosition = 100.0
        
        let labelTitle = SKLabelNode(fontNamed: "MarkerFelt-Thin")
        labelTitle.text = "PROGRESS REPORT"
        labelTitle.fontSize = GetFontSize(size:34)
        labelTitle.fontColor = SKColor.red
        labelTitle.position = .zero
        labelTitle.zPosition = 100.0
        fullTitle.addChild(labelTitle)
        let labelTitleShadow = CreateShadowLabel(label: labelTitle,offset: GetFontSize(size:1))
        fullTitle.addChild(labelTitleShadow)
        
        let labelSubtitle = SKLabelNode(fontNamed: "MarkerFelt-Thin")
        labelSubtitle.text = global.currentStudent + ": Grade " + global.currentGrade
        labelSubtitle.fontSize = GetFontSize(size:29)
        labelSubtitle.fontColor = global.purple
        labelSubtitle.position = CGPoint(x: 0, y: -self.size.height/24)
        labelSubtitle.zPosition = 100.0
        fullTitle.addChild(labelSubtitle)
        let labelSubtitleShadow = CreateShadowLabel(label: labelSubtitle,offset: GetFontSize(size:1))
        fullTitle.addChild(labelSubtitleShadow)
        addChild(fullTitle)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        let touchLocation = touch.location(in: self)
        let touchedNode = self.atPoint(touchLocation)
        
        if touchedNode.name?.contains("backbutton") != nil && (touchedNode.name?.contains("backbutton"))!  {
            TransitionBackFromSceneToPlayerSelect(myScene: self)
        }
    }
    
    func TransitionBackFromSceneToPlayerSelect(myScene: SKScene) {
        global.overlayNode.removeAllActions()
        global.overlayNode.removeAllChildren()
        global.overlayNode.removeFromParent()        
        
        var playSound = SKAction.playSoundFileNamed("QuizRight.wav", waitForCompletion: false)
        if global.soundOption == 2 {
            playSound = SKAction.wait(forDuration: 0.0001)
        }
        let newScene = SKAction.run({
            let reveal = SKTransition.reveal(with:SKTransitionDirection.left, duration:1.0)
            
            let nextScene = PlayerSelectScene(size: myScene.size,currentSentenceNum:0,correctAnswers:0,incorrectAnswers:0,currentExtraWordNum:0,sceneType:"PlayerSelect")
            myScene.view?.presentScene(nextScene, transition: reveal)
            
        })
        myScene.run(SKAction.sequence([playSound,newScene]))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

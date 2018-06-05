//
//  LevelSelectScene.swift
//  ScholarKids
//
//  Created by Doug Price on 5/25/18.
//  Copyright © 2018 Doug Price. All rights reserved.
//

import SpriteKit
import GameplayKit

class LevelSelectScene: SKScene {
    let minLevel = 1
    let maxLevel = 20
    
    var scrollBoxAr:[(start: CGPoint, end: CGPoint)] = []
    var hotAirBalloonAr = [[SKSpriteNode]]()
    var hotAirBalloonLabelAr = [[SKLabelNode]]()
    var hotAirBalloonLabel2Ar = [[SKLabelNode]]()
    
    var minX : CGFloat = 0.0
    var maxX : CGFloat = 0.0
    var curX : [CGFloat] = [0.0,0.0,0.0,0.0,0.0]
    
    let subjectAr = ["Math","Grammar","Vocabulary","Spelling","Reading"]

    var scrollLocation = CGPoint.zero
    var prevLocation = CGPoint.zero
    var isScrolling = false
    
    init(size: CGSize, currentSentenceNum:Int, correctAnswers:Int, incorrectAnswers:Int, currentExtraWordNum:Int,sceneType:String) {
        super.init(size: size)
        
        backgroundColor = SKColor(red: 234/255, green: 230/255, blue: 236/255, alpha: 1)
        
        let labelTitle = SKLabelNode(fontNamed: "Arial")
        labelTitle.text = "Select Level"
        labelTitle.fontSize = 35
        labelTitle.fontColor = SKColor.black
        labelTitle.position = CGPoint(x: self.size.width/2, y: self.size.height*22/24)
        labelTitle.zPosition = 100.0
        addChild(labelTitle)
        
        let labelNameGrade = SKLabelNode(fontNamed: "Arial")
        labelNameGrade.text = global.currentStudent + ": Grade " + global.currentGrade
        labelNameGrade.fontSize = 24
        labelNameGrade.fontColor = SKColor.red
        labelNameGrade.position = CGPoint(x: self.size.width/2, y: self.size.height*21/24)
        labelNameGrade.zPosition = 100.0
        addChild(labelNameGrade)
        
        var n = 0
        for subject in subjectAr {
            let subjectTitle = SKLabelNode(fontNamed: "ChalkDuster")
            subjectTitle.text = subject
            subjectTitle.fontSize = 25
            subjectTitle.fontColor = SKColor.blue
            subjectTitle.position = CGPoint(x: self.size.width/2, y: self.size.height*(19.5-4*CGFloat(n))/24)
            subjectTitle.zPosition = 100.0
            addChild(subjectTitle)
            
            hotAirBalloonAr.append([])
            hotAirBalloonLabelAr.append([])
            hotAirBalloonLabel2Ar.append([])
            for i in minLevel-1..<maxLevel {
                hotAirBalloonAr[n].append(SKSpriteNode(imageNamed: "hotairballoon.png"))
                hotAirBalloonAr[n][i].position = CGPoint(x: self.size.width/8 + CGFloat(i)*(self.size.width/4),y:self.size.height*(18-4*CGFloat(n))/24)
                hotAirBalloonAr[n][i].scale(to: CGSize(width: self.size.height*3/48,height: (self.size.height*3/48)*(4/2.4)))
                hotAirBalloonAr[n][i].name = "hotairballoon" + String(n) + ":" + String(i)
                addChild(hotAirBalloonAr[n][i])
                
                hotAirBalloonLabelAr[n].append(SKLabelNode(fontNamed: "ChalkDuster"))
                hotAirBalloonLabelAr[n][i].text = "Level"
                hotAirBalloonLabelAr[n][i].fontSize = 15
                hotAirBalloonLabelAr[n][i].fontColor = SKColor.red
                hotAirBalloonLabelAr[n][i].position = CGPoint(x: self.size.width/8 + CGFloat(i)*(self.size.width/4),y:self.size.height*(18.6-4*CGFloat(n))/24 )
                hotAirBalloonLabelAr[n][i].zPosition = 102.0
                hotAirBalloonLabelAr[n][i].name = "hotairballoon" + String(n) + ":" + String(i)
                addChild(hotAirBalloonLabelAr[n][i])
                
                hotAirBalloonLabel2Ar[n].append(SKLabelNode(fontNamed: "ChalkDuster"))
                hotAirBalloonLabel2Ar[n][i].text = String(i+1)
                hotAirBalloonLabel2Ar[n][i].fontSize = 20
                hotAirBalloonLabel2Ar[n][i].fontColor = SKColor.red
                hotAirBalloonLabel2Ar[n][i].position = CGPoint(x: self.size.width/8 + CGFloat(i)*(self.size.width/4),y:self.size.height*(18-4*CGFloat(n))/24)
                hotAirBalloonLabel2Ar[n][i].zPosition = 102.0
                hotAirBalloonLabel2Ar[n][i].name = "hotairballoon" + String(n) + ":" + String(i)
                addChild(hotAirBalloonLabel2Ar[n][i])
            }
            
            maxX = 0.0
            minX = -(self.size.width/8 + CGFloat(16)*(self.size.width/4))
            
            var points = [CGPoint(x:0.0, y:0.0),CGPoint(x:self.size.width*14/16, y:0.0)]
            let line = SKShapeNode(points: &points, count: points.count)
            line.position = CGPoint(x:self.size.width/16,y:self.size.height*(16.5-4*CGFloat(n))/24)
            line.strokeColor = SKColor.red
            self.addChild(line)
            
            scrollBoxAr.append((start:CGPoint(x:0,y:self.size.height*(16.5-4*CGFloat(n))/24),end:CGPoint(x:self.size.width,y:self.size.height*(20-4*CGFloat(n))/24)))
            n = n + 1
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func ScrollAtLocation(location: CGPoint,location2: CGPoint,scrollLeft: Bool)
    {
        var scrollBoxInd = -1
        var ind = 0
        for scrollBox in scrollBoxAr {
            if location.x > scrollBox.start.x && location.y > scrollBox.start.y && location.x < scrollBox.end.x && location.y < scrollBox.end.y {
                
                scrollBoxInd = ind
                break
            }
            ind = ind + 1
        }
        
        if scrollBoxInd > -1 {
            if hotAirBalloonAr.count > scrollBoxInd {
                var scrollX  : CGFloat = location2.x - prevLocation.x
                if curX[scrollBoxInd]+scrollX < minX {
                    scrollX = 0.0
                }
                if curX[scrollBoxInd]+scrollX > maxX {
                    scrollX = 0.0
                }
                
                let action = SKAction.moveBy(x: scrollX, y: 0, duration: 0.1)
                action.timingMode = SKActionTimingMode.easeInEaseOut
                if scrollX != 0.0 {
                    for hotAirBalloon in hotAirBalloonAr[scrollBoxInd] {
                        hotAirBalloon.run(action)
                    }
                    for hotAirBalloonLabel in hotAirBalloonLabelAr[scrollBoxInd] {
                        hotAirBalloonLabel.run(action)
                    }
                    for hotAirBalloonLabel2 in hotAirBalloonLabel2Ar[scrollBoxInd] {
                        hotAirBalloonLabel2.run(action)
                    }
                    isScrolling = true
                }
                curX[scrollBoxInd] = curX[scrollBoxInd] + scrollX
                prevLocation = location2
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
        
        if isScrolling == false {
            if let shapeNode = touchedNode as? SKNode {
                if shapeNode.name?.contains("hotairballoon") != nil && (shapeNode.name?.contains("hotairballoon"))!  {
                    var strInd = ""
                    if var strName = shapeNode.name {
                        while strName.last != ":" {
                            strInd.insert(strName.last!, at: strInd.startIndex)
                            strName.removeLast()
                        }
                        strName.removeLast()
                        let index = strName.index(strName.endIndex, offsetBy: -1 )
                        let sceneIndStr = String(strName[index])
                        if var ind2 : Int = Int(strInd) {
                            ind2 = ind2 + 1
                            if let ind3 : Int = Int(sceneIndStr) {
                                if ind2 >= minLevel && ind2 <= maxLevel {
                                    if ind3 >= 0 && ind3 < subjectAr.count {
                                        global.currentLevel = ind2
                                        TransitionScene(sceneType:subjectAr[ind3])
                                    }
                                }
                            }
                        }
                        
                    }
                }
            }
        }
        
        isScrolling = false
        scrollLocation = CGPoint.zero
        prevLocation = CGPoint.zero
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        let touchLocation = touch.location(in: self)
        let touchedNode = self.atPoint(touchLocation)
        
        ScrollAtLocation(location:scrollLocation,location2:touchLocation,scrollLeft: false)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        let touchLocation = touch.location(in: self)
        let touchedNode = self.atPoint(touchLocation)
        
        isScrolling = false
        scrollLocation = touchLocation
        prevLocation = touchLocation
    }
    
    func TransitionScene(sceneType:String)
    {
        let playSound = SKAction.playSoundFileNamed("Correct-answer.mp3", waitForCompletion: false)
        let newScene = SKAction.run({
            let reveal = SKTransition.reveal(with:SKTransitionDirection.left, duration:1.0)
            
            if sceneType == "Math" {
                let nextScene = MathDrawScene(size: self.size,currentSentenceNum:0,correctAnswers:0,incorrectAnswers:0,currentExtraWordNum:0,sceneType:sceneType)
                self.view?.presentScene(nextScene, transition: reveal)
            }
            else if sceneType == "Vocabulary" {
                let nextScene = VocabularySelectScene(size: self.size,currentSentenceNum:0,correctAnswers:0,incorrectAnswers:0,currentExtraWordNum:0,sceneType:sceneType)
                self.view?.presentScene(nextScene, transition: reveal)
            }
            else if sceneType == "Grammar" {
                let nextScene = WordSelectScene(size: self.size,currentSentenceNum:0,correctAnswers:0,incorrectAnswers:0,currentExtraWordNum:0,sceneType:sceneType)
                self.view?.presentScene(nextScene, transition: reveal)
            }
            
        })
        self.run(SKAction.sequence([playSound,newScene]))
    }
}

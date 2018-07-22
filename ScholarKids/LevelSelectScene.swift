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
    var hotAirBalloonLockAr = [[SKSpriteNode]]()
    var hotAirBalloonLabelAr = [[SKLabelNode]]()
    var hotAirBalloonLabel2Ar = [[SKLabelNode]]()
    var hotAirBalloonLabelShadowAr = [[SKLabelNode]]()
    var hotAirBalloonLabelShadow2Ar = [[SKLabelNode]]()
    var levelUnlockedAr = [String:Int]()
    
    var minX : CGFloat = 0.0
    var maxX : CGFloat = 0.0
    var curX : [CGFloat] = [0.0,0.0,0.0,0.0,0.0]
        
    let subjectAr = ["Math","Grammar","Vocabulary","Spelling"]

    var scrollLocation = CGPoint.zero
    var prevLocation = CGPoint.zero
    var isScrolling = false
    
    let SUB_SPACING : CGFloat = 5.0
    
    init(size: CGSize, currentSentenceNum:Int, correctAnswers:Int, incorrectAnswers:Int, currentExtraWordNum:Int,sceneType:String) {
        super.init(size: size)
        
        backgroundColor = SKColor(red: 234/255, green: 230/255, blue: 236/255, alpha: 1)
        GetUnlockedLevels()
        
        let labelTitle = SKLabelNode(fontNamed: "Arial")
        labelTitle.text = "Select Level"
        labelTitle.fontSize = 35
        labelTitle.fontColor = global.titleColor
        labelTitle.position = CGPoint(x: self.size.width/2, y: self.size.height*22/24)
        labelTitle.zPosition = 100.0
        addChild(labelTitle)
        addChild(CreateShadowLabel(label: labelTitle,offset: 1))
        
        let labelNameGrade = SKLabelNode(fontNamed: "Arial")
        labelNameGrade.text = global.currentStudent + ": Grade " + global.currentGrade
        labelNameGrade.fontSize = 24
        labelNameGrade.fontColor = SKColor.red
        labelNameGrade.position = CGPoint(x: self.size.width/2, y: self.size.height*21/24)
        labelNameGrade.zPosition = 100.0
        addChild(labelNameGrade)
        addChild(CreateShadowLabel(label: labelNameGrade,offset: 1))
        
        var n = 0
        for subject in subjectAr {
            let subjectTitle = SKLabelNode(fontNamed: "ChalkDuster")
            subjectTitle.text = subject
            subjectTitle.fontSize = 25
            subjectTitle.fontColor = SKColor.blue
            subjectTitle.position = CGPoint(x: self.size.width/2, y: self.size.height*(19.5 - SUB_SPACING*CGFloat(n))/24)
            subjectTitle.zPosition = 100.0
            addChild(subjectTitle)
            addChild(CreateShadowLabel(label: subjectTitle,offset: 1.5))
            
            hotAirBalloonAr.append([])
            hotAirBalloonLockAr.append([])
            hotAirBalloonLabelAr.append([])
            hotAirBalloonLabel2Ar.append([])
            hotAirBalloonLabelShadowAr.append([])
            hotAirBalloonLabelShadow2Ar.append([])
            for i in minLevel-1..<maxLevel {
                hotAirBalloonAr[n].append(SKSpriteNode(imageNamed: "hotairballoon.png"))
                hotAirBalloonAr[n][i].position = CGPoint(x: self.size.width/8 + CGFloat(i)*(self.size.width/5),y:self.size.height*(17.5 - SUB_SPACING*CGFloat(n))/24)
                hotAirBalloonAr[n][i].scale(to: CGSize(width: self.size.height*3/48,height: (self.size.height*3/48)*(4/2.4)))
                hotAirBalloonAr[n][i].name = "hotairballoon" + String(n) + ":" + String(i)
                addChild(hotAirBalloonAr[n][i])
                
                //lock
                if !GlobalUnlocked(subject:subject) {
                    if let levelUnlocked = levelUnlockedAr[subject] {
                        if levelUnlocked <= i {
                            hotAirBalloonLockAr[n].append(SKSpriteNode(imageNamed: "lock.png"))
                            let ind = hotAirBalloonLockAr[n].count - 1
                            hotAirBalloonLockAr[n][ind].position = CGPoint(x: self.size.width/8 + CGFloat(i)*(self.size.width/5),y:self.size.height*(17 - SUB_SPACING*CGFloat(n))/24)
                            hotAirBalloonLockAr[n][ind].scale(to: CGSize(width: self.size.height*1.5/48,height: self.size.height*1.5/48))
                            hotAirBalloonLockAr[n][ind].name = "hotairballoon" + String(n) + ":" + String(i)
                            hotAirBalloonLockAr[n][ind].zPosition = 101.5
                            hotAirBalloonLockAr[n][ind].alpha = 1.0
                            addChild(hotAirBalloonLockAr[n][ind])
                        }
                    }
                }
                
                hotAirBalloonLabelAr[n].append(SKLabelNode(fontNamed: "ChalkDuster"))
                hotAirBalloonLabelAr[n][i].text = "Level"
                hotAirBalloonLabelAr[n][i].fontSize = 13
                hotAirBalloonLabelAr[n][i].fontColor = SKColor.red
                hotAirBalloonLabelAr[n][i].position = CGPoint(x: self.size.width/8 + CGFloat(i)*(self.size.width/5),y:self.size.height*(18.1 - SUB_SPACING*CGFloat(n))/24 )
                hotAirBalloonLabelAr[n][i].zPosition = 102.0
                hotAirBalloonLabelAr[n][i].name = "hotairballoon" + String(n) + ":" + String(i)
                addChild(hotAirBalloonLabelAr[n][i])
                hotAirBalloonLabelShadowAr[n].append(CreateShadowLabel(label: hotAirBalloonLabelAr[n][i],offset: 1))
                addChild(hotAirBalloonLabelShadowAr[n][i])
                
                hotAirBalloonLabel2Ar[n].append(SKLabelNode(fontNamed: "ChalkDuster"))
                hotAirBalloonLabel2Ar[n][i].text = String(i+1)
                hotAirBalloonLabel2Ar[n][i].fontSize = 20
                hotAirBalloonLabel2Ar[n][i].fontColor = SKColor.red
                hotAirBalloonLabel2Ar[n][i].position = CGPoint(x: self.size.width/8 + CGFloat(i)*(self.size.width/5),y:self.size.height*(17.5 - SUB_SPACING*CGFloat(n))/24)
                hotAirBalloonLabel2Ar[n][i].zPosition = 102.0
                hotAirBalloonLabel2Ar[n][i].name = "hotairballoon" + String(n) + ":" + String(i)
                addChild(hotAirBalloonLabel2Ar[n][i])
                hotAirBalloonLabelShadow2Ar[n].append(CreateShadowLabel(label: hotAirBalloonLabel2Ar[n][i],offset: 1))
                addChild(hotAirBalloonLabelShadow2Ar[n][i])
            }
            
            maxX = 0.0
            minX = -(self.size.width/8 + CGFloat(16)*(self.size.width/4))
            
            var points = [CGPoint(x:0.0, y:0.0),CGPoint(x:self.size.width*14/16, y:0.0)]
            let line = SKShapeNode(points: &points, count: points.count)
            line.position = CGPoint(x:self.size.width/16,y:self.size.height*(16 - SUB_SPACING*CGFloat(n))/24)
            line.strokeColor = SKColor.red
            self.addChild(line)
            
            scrollBoxAr.append((start:CGPoint(x:0,y:self.size.height*(16 - SUB_SPACING*CGFloat(n))/24),end:CGPoint(x:self.size.width,y:self.size.height*(19.5 - SUB_SPACING*CGFloat(n))/24)))
            n = n + 1
        }
        
        let redLeft = SKSpriteNode(imageNamed: "RedLeft.png")
        redLeft.name = "backbutton"
        redLeft.position = CGPoint(x: frame.size.width * 18/20, y: self.size.height*17/20)
        redLeft.scale(to: CGSize(width: self.size.width/10, height: self.size.width/10))
        addChild(redLeft)
        
        let redLeftLabel = SKLabelNode(fontNamed: "MarkerFelt-Thin")
        redLeftLabel.text = "Swipe Left"
        redLeftLabel.fontSize = 15
        redLeftLabel.fontColor = SKColor.red
        redLeftLabel.position = CGPoint(x: frame.size.width * 18/20, y: self.size.height*16/20)
        redLeftLabel.zPosition = 100.0
        addChild(redLeftLabel)
        addChild(CreateShadowLabel(label: redLeftLabel,offset: 1))
        
        let backButton = SKSpriteNode(imageNamed: "BackwardsClean.png")
        backButton.name = "backbutton"
        backButton.position = CGPoint(x: frame.size.width/20, y: self.size.height*18.5/20)
        backButton.scale(to: CGSize(width: self.size.width/10, height: self.size.width/10))
        addChild(backButton)
    }
    
    func GlobalUnlocked(subject:String) -> Bool {
        switch subject {
        case "Math":
            if global.mathUnlocked > 0 {
                return true
            }
        case "Grammar":
            if global.grammarUnlocked > 0 {
                return true
            }
        case "Vocabulary":
            if global.vocabularyUnlocked > 0 {
                return true
            }
        case "Spelling":
            if global.spellingUnlocked > 0 {
                return true
            }
        default:
            return false
        }
        return false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func GetUnlockedLevels() {
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
                            //spelling
                            var data = playerDataAr[5].characters.split{$0 == " "}.map(String.init)
                            if data.count > 0 {
                                var levelUnlocked = 1
                                if data[0] == "-1" {
                                    levelUnlocked = 1
                                }
                                else {
                                    levelUnlocked = data.count
                                    if let val = Int(data[data.count-1]) {
                                        if val >= global.minimumCorrectToUnlock {
                                            levelUnlocked = data.count + 1
                                        }
                                    }
                                }
                                levelUnlockedAr["Spelling"] = levelUnlocked
                                if global.spellingUnlocked > 0 {
                                    levelUnlockedAr["Spelling"] = global.maxLevels
                                }
                            }
                            //vocabulary
                            data = playerDataAr[4].characters.split{$0 == " "}.map(String.init)
                            if data.count > 0 {
                                var levelUnlocked = 1
                                if data[0] == "-1" {
                                    levelUnlocked = 1
                                }
                                else {
                                    levelUnlocked = data.count
                                    if let val = Int(data[data.count-1]) {
                                        if val >= global.minimumCorrectToUnlock {
                                            levelUnlocked = data.count + 1
                                        }
                                    }
                                }
                                levelUnlockedAr["Vocabulary"] = levelUnlocked
                                if global.vocabularyUnlocked > 0 {
                                    levelUnlockedAr["Vocabulary"] = global.maxLevels
                                }
                            }
                            //grammar
                            data = playerDataAr[3].characters.split{$0 == " "}.map(String.init)
                            if data.count > 0 {
                                var levelUnlocked = 1
                                if data[0] == "-1" {
                                    levelUnlocked = 1
                                }
                                else {
                                    levelUnlocked = data.count
                                    if let val = Int(data[data.count-1]) {
                                        if val >= global.minimumCorrectToUnlock {
                                            levelUnlocked = data.count + 1
                                        }
                                    }
                                }
                                levelUnlockedAr["Grammar"] = levelUnlocked
                                if global.grammarUnlocked > 0 {
                                    levelUnlockedAr["Grammar"] = global.maxLevels
                                }
                            }
                            //math
                            data = playerDataAr[2].characters.split{$0 == " "}.map(String.init)
                            if data.count > 0 {
                                var levelUnlocked = 1
                                if data[0] == "-1" {
                                    levelUnlocked = 1
                                }
                                else {
                                    levelUnlocked = data.count
                                    if let val = Int(data[data.count-1]) {
                                        if val >= global.minimumCorrectToUnlock {
                                            levelUnlocked = data.count + 1
                                        }
                                    }
                                }
                                levelUnlockedAr["Math"] = levelUnlocked
                                if global.mathUnlocked > 0 {
                                    levelUnlockedAr["Math"] = global.maxLevels
                                }
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
                    for hotAirBalloonLock in hotAirBalloonLockAr[scrollBoxInd] {
                        hotAirBalloonLock.run(action)
                    }
                    for hotAirBalloonLabel in hotAirBalloonLabelAr[scrollBoxInd] {
                        hotAirBalloonLabel.run(action)
                    }
                    for hotAirBalloonLabel2 in hotAirBalloonLabel2Ar[scrollBoxInd] {
                        hotAirBalloonLabel2.run(action)
                    }
                    for hotAirBalloonLabelShadow in hotAirBalloonLabelShadowAr[scrollBoxInd] {
                        hotAirBalloonLabelShadow.run(action)
                    }
                    for hotAirBalloonLabelShadow2 in hotAirBalloonLabelShadow2Ar[scrollBoxInd] {
                        hotAirBalloonLabelShadow2.run(action)
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
                                        if let levelUnlocked = levelUnlockedAr[subjectAr[ind3]] {
                                            if levelUnlocked >= ind2 {
                                                global.currentLevel = ind2
                                                TransitionScene(sceneType:subjectAr[ind3])
                                            }
                                            else {
                                                var playSound = SKAction.playSoundFileNamed("WrongProgress.wav", waitForCompletion: false)
                                                if global.soundOption == 2 {
                                                    playSound = SKAction.wait(forDuration: 0.0001)
                                                }
                                                self.run(SKAction.sequence([playSound]))
                                            }
                                        }
                                    }
                                }
                            }
                        }                        
                    }
                }
                if shapeNode.name?.contains("backbutton") != nil && (shapeNode.name?.contains("backbutton"))!  {
                    TransitionBack()
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
        ScrollAtLocation(location:scrollLocation,location2:touchLocation,scrollLeft: false)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        let touchLocation = touch.location(in: self)
        
        isScrolling = false
        scrollLocation = touchLocation
        prevLocation = touchLocation
    }
    
    func TransitionBack() {
        for child in global.overlayNode.children {
            child.removeFromParent()
        }
        global.overlayNode.removeFromParent()
        var playSound = SKAction.playSoundFileNamed("QuizRight.wav", waitForCompletion: false)
        if global.soundOption == 2 {
            playSound = SKAction.wait(forDuration: 0.0001)
        }
        let newScene = SKAction.run({
            let reveal = SKTransition.reveal(with:SKTransitionDirection.left, duration:1.0)
            
            let nextScene = PlayerSelectScene(size: self.size,currentSentenceNum:0,correctAnswers:0,incorrectAnswers:0,currentExtraWordNum:0,sceneType:"PlayerSelect")
            self.view?.presentScene(nextScene, transition: reveal)
            
        })
        self.run(SKAction.sequence([playSound,newScene]))
    }
    
    func TransitionScene(sceneType:String) {
        global.sceneType = sceneType
        
        if global.musicOption == 1 {
            let dictToSend: [String: String] = ["fileToPlay": "BackgroundMusic" ]
            NotificationCenter.default.post(name: Notification.Name(rawValue: "StopBackgroundSound"), object: self, userInfo:dictToSend)
        }
        
        var playSound = SKAction.playSoundFileNamed("QuizRight.wav", waitForCompletion: false)
        if global.soundOption == 2 {
            playSound = SKAction.wait(forDuration: 0.0001)
        }
        let newScene = SKAction.run({
            let reveal = SKTransition.reveal(with:SKTransitionDirection.left, duration:1.0)
            
            global.correctAnswers = 0
            global.incorrectAnswers = 0
            if global.sceneType == "Math" {
                global.wordProblemsNum = 6 * (global.currentLevel-1)
                global.currentSentenceNum = 12 * (global.currentLevel-1)
                let nextScene = MathDrawScene(size: self.size,currentSentenceNum:0,correctAnswers:0,incorrectAnswers:0,currentExtraWordNum:0,sceneType:global.sceneType)
                self.view?.presentScene(nextScene, transition: reveal)
            }
            else if global.sceneType == "Vocabulary" {
                global.vocabularySelectNum = 6 * (global.currentLevel-1)
                global.vocabularyConnectNum = 18 * (global.currentLevel-1)
                global.currentSentenceNum = 24 * (global.currentLevel-1)
                let nextScene = VocabularyConnectScene(size: self.size,currentSentenceNum:0,correctAnswers:0,incorrectAnswers:0,currentExtraWordNum:0,sceneType:global.sceneType)
                self.view?.presentScene(nextScene, transition: reveal)
            }
            else if global.sceneType == "Grammar" {
                global.grammarSelectNum = 6 * (global.currentLevel-1)
                global.grammarDragNum = 6 * (global.currentLevel-1)
                global.currentSentenceNum = 12 * (global.currentLevel-1)
                let nextScene = WordSelectScene(size: self.size,currentSentenceNum:0,correctAnswers:0,incorrectAnswers:0,currentExtraWordNum:0,sceneType:global.sceneType)
                self.view?.presentScene(nextScene, transition: reveal)
            }
            else if global.sceneType == "Spelling" {
                global.spellingSelectNum = 6 * (global.currentLevel-1)
                global.spellingDragNum = 6 * (global.currentLevel-1)
                global.currentSentenceNum = 12 * (global.currentLevel-1)
                let nextScene = VocabularySelectScene(size: self.size,currentSentenceNum:0,correctAnswers:0,incorrectAnswers:0,currentExtraWordNum:0,sceneType:global.sceneType)
                self.view?.presentScene(nextScene, transition: reveal)
            }
        })
        self.run(SKAction.sequence([playSound,newScene]))
    }
}

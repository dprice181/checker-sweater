//
//  GameViewController.swift
//  ScholarKids
//
//  Created by Doug Price on 5/18/18.
//  Copyright © 2018 Doug Price. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import AVFoundation

class Global {
    var currentStudent = ""
    var currentGrade = ""
    var currentLevel = 1
    var view : SKView?
    var letterStrings = [[String]]()
    var letterStringsSingleFind = [String]()
    var letterStringsSingleReplace = [[String]]()
    var letterStringsFind = [String]()
    var letterStringsReplace = [[String]]()
    let titleColor = SKColor(red: 185/255, green: 80/255, blue: 185/255, alpha: 1.0)
    let blue = SKColor(red:90/255,green:90/255,blue:215/255,alpha:1)
    let lightBlue = SKColor(red:130/255,green:130/255,blue:225/255,alpha:1)    
    let lightPurple = SKColor(red: 245/255, green: 225/255, blue: 245/255, alpha: 0.8)
    let veryLightBlue = SKColor(red: 225/255, green: 225/255, blue: 255/255, alpha: 0.8)
    let purple = SKColor(red: 55/255, green: 15/255, blue: 200/255, alpha: 1)
    let greyBlue = SKColor(red: 240/255, green: 240/255, blue: 255/255, alpha: 0.8)
    let lightPink = SKColor(red: 240/255, green:128/255, blue:128/255, alpha: 0.8)
    let realPurple = SKColor(red: 165/255, green: 60/255, blue: 165/255, alpha: 1.0)
    let overlayNode = SKNode()
    var correctAnswers = 0
    var incorrectAnswers = 0
    var currentSentenceNum = 0
    var wordProblemsNum = 0
    var sceneType : String = ""
    var vocabularySelectNum = 0
    var vocabularyConnectNum = 0
    var grammarSelectNum = 0
    var grammarDragNum = 0
    var spellingSelectNum = 0
    var spellingDragNum = 0
    var mathUnlocked = 0
    var grammarUnlocked = 0
    var vocabularyUnlocked = 0
    var spellingUnlocked = 0
    var musicOption = 1
    var soundOption = 2
    var minimumCorrectToUnlock = 9
    var optionAr = [String]()
    var maxLevels = 25
    var musicStarted = false
    var heightWidthRat : CGFloat = 0
}

let global = Global()

func GetFontSize(size:CGFloat) -> CGFloat {
    var returnSize = size
    if let frameWidth = global.view?.frame.width {
        if frameWidth < 375 {
            returnSize = (frameWidth/400) * size
        }
        if frameWidth > 425 {
            returnSize = (frameWidth/500) * size
        }
    }
    return returnSize
}

func GetCornerSize(size:CGFloat,max:CGFloat) -> CGFloat {
    if 2 * size > max {
        return max/2.1
    }
    return size
}

func DrawBackButton(scene:SKScene) {
    if let frame = global.view?.frame {
        let width = frame.width
        let height = frame.height
        let backButton = SKSpriteNode(imageNamed: "BackwardsClean.png")
        backButton.name = "backbutton"
        
        if global.heightWidthRat < 1.5 {
            backButton.position = CGPoint(x: width/18, y: height*18.3/20)
            backButton.scale(to: CGSize(width: width/12.5, height: width/12.5))
        }
        else {
            backButton.position = CGPoint(x: width/13, y: height*18.3/20)
            backButton.scale(to: CGSize(width: width/10, height: width/10))
        }
        scene.addChild(backButton)
    }
}

struct PhysicsCategory {
    static let none      : UInt32 = 0
    static let all       : UInt32 = UInt32.max
    static let answerbox : UInt32 = 0b1       // 1
    static let choicebox : UInt32 = 0b10      // 2
}

func CreateShadowLabel(label : SKLabelNode,offset: CGFloat) -> SKLabelNode {
    if let shadowLabel = label.copy() as? SKLabelNode {
        shadowLabel.fontColor = SKColor.black
        shadowLabel.position = CGPoint(x:-offset+shadowLabel.position.x , y:offset+shadowLabel.position.y)
        shadowLabel.zPosition = shadowLabel.zPosition - 0.5
        return shadowLabel
    }
    
    return SKLabelNode()
}

func WriteOptionsToFile() {
    let file = "Options.txt" //this is the file. we will write to and read from it
    if let dir = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true).first {
        let path = dir + "/" + file
        do {
            let fileText = global.optionAr.joined(separator: "*")
            try! fileText.write(toFile: path, atomically: false, encoding: String.Encoding.utf8)
        }
        catch {
            print("File read error:", error)
        }
    }
}

func UpdateOptions() {
    let oldMusicOption = global.musicOption
    global.mathUnlocked = Int(global.optionAr[7])!
    global.grammarUnlocked = Int(global.optionAr[9])!
    global.vocabularyUnlocked = Int(global.optionAr[11])!
    global.spellingUnlocked = Int(global.optionAr[13])!
    global.musicOption = Int(global.optionAr[1])!
    global.soundOption = Int(global.optionAr[3])!
    global.minimumCorrectToUnlock = (Int(global.optionAr[5])!) * 3
    
    if  global.musicOption == 2 && oldMusicOption < 2 {
        let dictToSend: [String: String] = ["fileToPlay": "BackgroundMusic" ]
        NotificationCenter.default.post(name: Notification.Name(rawValue: "StopBackgroundSound"), object: SKScene(), userInfo:dictToSend)
    }
    if  global.musicOption < 2 && oldMusicOption == 2 && !global.musicStarted{
        let dictToSend: [String: String] = ["fileToPlay": "BackgroundMusic" ]
        NotificationCenter.default.post(name: Notification.Name(rawValue: "PlayBackgroundSound"), object: SKScene(), userInfo:dictToSend)
    }
}

func CreateOptionsFileIfNecessary() {
    let file = "Options.txt"
    if let dir = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true).first {
        let path = dir + "/" + file
        do {
            let fileText = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
        }
        catch {
            print("File read error:", error)
            let fileText = "Music*1*Sound*0*Correct*3*Math*0*Grammar*0*Vocabulary*0*Spelling*0"
            try! fileText.write(toFile: path, atomically: false, encoding: String.Encoding.utf8)
        }
    }
}

func ReadOptionsFile() {
    let file = "Options.txt" //this is the file. we will write to and read from it
    if let dir = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true).first {
        let path = dir + "/" + file
        do {
            //let fileText2 = "Music*1*Sound*0*Correct*3*Math*0*Grammar*0*Vocabulary*0*Spelling*0"
            //try! fileText2.write(toFile: path, atomically: false, encoding: String.Encoding.utf8)
            var fileText = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
            global.optionAr = fileText.characters.split{$0 == "*"}.map(String.init)
        }
        catch {
            print("File read error:", error)
        }
    }
}

func TransitionBackFromScene(myScene: SKScene) {
    global.overlayNode.removeAllActions()
    global.overlayNode.removeAllChildren()
    global.overlayNode.removeFromParent()
    
    if global.musicOption == 1 && !global.musicStarted {  //music menu only
        let dictToSend: [String: String] = ["fileToPlay": "BackgroundMusic" ]
        NotificationCenter.default.post(name: Notification.Name(rawValue: "PlayBackgroundSound"), object: myScene, userInfo:dictToSend)
    }
    
    var playSound = SKAction.playSoundFileNamed("QuizRight.wav", waitForCompletion: false)
    if global.soundOption == 2 {
        playSound = SKAction.wait(forDuration: 0.0001)
    }
    let newScene = SKAction.run({
        let reveal = SKTransition.reveal(with:SKTransitionDirection.left, duration:1.0)
        
        let nextScene = LevelSelectScene(size: myScene.size,currentSentenceNum:0,correctAnswers:0,incorrectAnswers:0,currentExtraWordNum:0,sceneType:"LevelSelect")
        myScene.view?.presentScene(nextScene, transition: reveal)
        
    })
    myScene.run(SKAction.sequence([playSound,newScene]))
}

func ReplaceFirstOccurence(myString: String,substring: String,replaceStr: String) -> String {
    let chars = Array(myString.characters)
    var newChars = [Character]()
    let subchars = Array(substring.characters)
    let replacechars = Array(replaceStr.characters)
    var i = 0
    var match = false
    for _ in 0..<chars.count {
        if chars[i] == subchars[0] && match == false && i + substring.count <= myString.count {
            match = true
            for j in 0..<substring.count {
                if (chars[i+j] != subchars[j]) {
                    match = false
                    break
                }
            }
            if match == true {
                for j in 0..<replaceStr.count {
                    newChars.append(replacechars[j])
                }
                i = i + substring.count
                if i >= chars.count {
                    break
                }
            }
        }
       
        newChars.append(chars[i])
        i = i + 1
        if i >= chars.count {
            break
        }
    }
    
    let modifiedString = String(newChars)
    return modifiedString
}

func GetLevelMode(levelMode: inout String) {
    if global.currentGrade == "K" {
        if global.currentLevel < 10 {
            levelMode = "n"
        }
        else {
            if (global.currentLevel % 2) == 1 {
                levelMode = "n"
            }
            else {
                levelMode = "a"
            }
        }
    }
    else if global.currentGrade == "1" {
        if (global.currentLevel % 2) == 1 {
            levelMode = "n"
        }
        else {
            levelMode = "v"
        }
    }
    else if global.currentGrade == "2" {
        if global.currentLevel < 10 {
            if (global.currentLevel % 2) == 1 {
                levelMode = "n"
            }
            else {
                levelMode = "v"
            }
        }
        else {
            if (global.currentLevel % 3) == 1 {
                levelMode = "n"
            }
            else if (global.currentLevel % 3) == 2 {
                levelMode = "v"
            }
            else {
                levelMode = "a"
            }
        }
    }
    else if global.currentGrade == "3" {
        if global.currentLevel < 10 {
            if (global.currentLevel % 3) == 1 {
                levelMode = "n"
            }
            else if (global.currentLevel % 3) == 2 {
                levelMode = "v"
            }
            else {
                levelMode = "a"
            }
        }
        else {
            if (global.currentLevel % 4) == 1 {
                levelMode = "n"
            }
            else if (global.currentLevel % 4) == 2 {
                levelMode = "v"
            }
            else if (global.currentLevel % 4) == 3 {
                levelMode = "a"
            }
            else {
                levelMode = "p"
            }
        }
    }
    else {
        if (global.currentLevel % 5) == 1 {
            levelMode = "n"
        }
        else if (global.currentLevel % 5) == 2 {
            levelMode = "v"
        }
        else if (global.currentLevel % 5) == 3 {
            levelMode = "a"
        }
        else if (global.currentLevel % 5) == 4 {
            levelMode = "p"
        }
        else {
            levelMode = "d"
        }
    }
}

func InitLetterStrings() {
    global.letterStringsFind.append("ie")
    global.letterStringsFind.append("ei")
    global.letterStringsFind.append("ae")
    global.letterStringsFind.append("ey")
    global.letterStringsFind.append("ee")
    global.letterStringsFind.append("ui")
    global.letterStringsFind.append("oo")
    global.letterStringsFind.append("iu")
    global.letterStringsFind.append("ue")
    global.letterStringsFind.append("ou")
    global.letterStringsFind.append("oo")
    global.letterStringsFind.append("ck")
    global.letterStringsFind.append("kk")
    global.letterStringsFind.append("cc")
    global.letterStringsFind.append("ff")
    global.letterStringsFind.append("ph")
    global.letterStringsFind.append("gh")
    global.letterStringsFind.append("gg")
    global.letterStringsFind.append("wh")
    global.letterStringsFind.append("rr")
    global.letterStringsFind.append("ll")
    global.letterStringsFind.append("nn")
    global.letterStringsFind.append("mm")
    global.letterStringsFind.append("mn")
    global.letterStringsFind.append("pp")
    global.letterStringsFind.append("bb")
    global.letterStringsFind.append("qu")
    global.letterStringsFind.append("ss")
    global.letterStringsFind.append("tt")
    global.letterStringsFind.append("dd")
    global.letterStringsFind.append("bb")
    global.letterStringsFind.append("dd")
    global.letterStringsFind.append("vv")
    global.letterStringsFind.append("cks")
    global.letterStringsFind.append("cs")
    global.letterStringsFind.append("ks")
    global.letterStringsFind.append("zz")
    global.letterStringsFind.append("ch")
    
    global.letterStringsReplace.append(["ei","i","e","ee"])
    global.letterStringsReplace.append(["ie","ae","ey","ay","a"])
    global.letterStringsReplace.append(["ay","ei","a"])
    global.letterStringsReplace.append(["ey","ae","ay"])
    global.letterStringsReplace.append(["e","ie"])
    global.letterStringsReplace.append(["oo","iu","u"])
    global.letterStringsReplace.append(["ui","o"])
    global.letterStringsReplace.append(["ui","i","u"])
    global.letterStringsReplace.append(["u","oo","o"])
    global.letterStringsReplace.append(["o","u","ow"])
    global.letterStringsReplace.append(["o","ui","u"])
    global.letterStringsReplace.append(["c","k","cc"])
    global.letterStringsReplace.append(["cc","k","c"])
    global.letterStringsReplace.append(["c","k","s"])
    global.letterStringsReplace.append(["f","ph"])
    global.letterStringsReplace.append(["ff","f"])
    global.letterStringsReplace.append(["ph","f","ff"])
    global.letterStringsReplace.append(["g","gh","k"])
    global.letterStringsReplace.append(["w","h"])
    global.letterStringsReplace.append(["r","l"])
    global.letterStringsReplace.append(["l","r"])
    global.letterStringsReplace.append(["n","mm","mn"])
    global.letterStringsReplace.append(["nn","m","mn","pn"])
    global.letterStringsReplace.append(["n","pn","m"])
    global.letterStringsReplace.append(["p","bb"])
    global.letterStringsReplace.append(["b","pp"])
    global.letterStringsReplace.append(["q","kw","cw"])
    global.letterStringsReplace.append(["s","c","cc"])
    global.letterStringsReplace.append(["t","dd"])
    global.letterStringsReplace.append(["d","tt"])
    global.letterStringsReplace.append(["b","dd"])
    global.letterStringsReplace.append(["d","bb"])
    global.letterStringsReplace.append(["v","w"])
    global.letterStringsReplace.append(["x","ks","cs"])
    global.letterStringsReplace.append(["cks","ks","x"])
    global.letterStringsReplace.append(["cs","cks","x"])
    global.letterStringsReplace.append(["z","s","ss"])
    global.letterStringsReplace.append(["tch","sh","c"])

    
    global.letterStringsSingleFind.append("a")
    global.letterStringsSingleFind.append("b")
    global.letterStringsSingleFind.append("c")
    global.letterStringsSingleFind.append("d")
    global.letterStringsSingleFind.append("e")
    global.letterStringsSingleFind.append("f")
    global.letterStringsSingleFind.append("g")
    global.letterStringsSingleFind.append("h")
    global.letterStringsSingleFind.append("i")
    global.letterStringsSingleFind.append("j")
    global.letterStringsSingleFind.append("k")
    global.letterStringsSingleFind.append("l")
    global.letterStringsSingleFind.append("m")
    global.letterStringsSingleFind.append("n")
    global.letterStringsSingleFind.append("o")
    global.letterStringsSingleFind.append("p")
    global.letterStringsSingleFind.append("q")
    global.letterStringsSingleFind.append("r")
    global.letterStringsSingleFind.append("s")
    global.letterStringsSingleFind.append("t")
    global.letterStringsSingleFind.append("u")
    global.letterStringsSingleFind.append("v")
    global.letterStringsSingleFind.append("w")
    global.letterStringsSingleFind.append("x")
    global.letterStringsSingleFind.append("y")
    global.letterStringsSingleFind.append("z")
    
    global.letterStringsSingleReplace.append(["ay","e","i","ae"])
    global.letterStringsSingleReplace.append(["bb","d","p"])
    global.letterStringsSingleReplace.append(["ck","k","cc","s"])
    global.letterStringsSingleReplace.append(["dd","b","p"])
    global.letterStringsSingleReplace.append(["ee","ie","i"])
    global.letterStringsSingleReplace.append(["ff","ph","gh"])
    global.letterStringsSingleReplace.append(["gg","k","j"])
    global.letterStringsSingleReplace.append(["wh","hh","w"])
    global.letterStringsSingleReplace.append(["a","e","ie"])
    global.letterStringsSingleReplace.append(["jj","g","gg"])
    global.letterStringsSingleReplace.append(["c","ck","kk","cc"])
    global.letterStringsSingleReplace.append(["ll","r","rr"])
    global.letterStringsSingleReplace.append(["mm","n","mn"])
    global.letterStringsSingleReplace.append(["nn","mn","m"])
    global.letterStringsSingleReplace.append(["oe","u","ou","ow","a"])
    global.letterStringsSingleReplace.append(["pp","b","bb"])
    global.letterStringsSingleReplace.append(["k","c","ck"])
    global.letterStringsSingleReplace.append(["rr","l","ll"])
    global.letterStringsSingleReplace.append(["ss","c","cc"])
    global.letterStringsSingleReplace.append(["tt","d","dd"])
    global.letterStringsSingleReplace.append(["u","o","oo"])
    global.letterStringsSingleReplace.append(["vv","w","ww"])
    global.letterStringsSingleReplace.append(["u","wh"])
    global.letterStringsSingleReplace.append(["cks","ks","cs"])
    global.letterStringsSingleReplace.append(["i","ie","ay"])
    global.letterStringsSingleReplace.append(["zz","s"])
}

func Misspell(word: String) -> [String] {    
    var returnAr = [String]()
    if word.count < 2 {
        returnAr.append(word)
        returnAr.append(word)
        returnAr.append(word)
        return returnAr
    }
    
    let letterStringsFind = [global.letterStringsFind,global.letterStringsSingleFind]
    let letterStringsReplace = [global.letterStringsReplace,global.letterStringsSingleReplace]
    for x in 0...1 {
        var letterArInd = Int(arc4random_uniform(UInt32(letterStringsFind[x].count)))
        var end = letterArInd
        if end == -1 {
            end = letterStringsFind[x].count - 1
        }
        
        var letterGroup2 = ""
        //cycle around the array with a random started index
        repeat  {
            let letterAr = letterStringsFind[x][letterArInd]
            let letterGroup = letterAr
            if word.contains(letterGroup) {
                var underscoreStr = "_"
                //for _ in 0...letterGroup.count-1 {
                    //underscoreStr = underscoreStr + "_"
                //}
                returnAr.append(ReplaceFirstOccurence(myString:word,substring:letterGroup,replaceStr:underscoreStr))
                
                var replaceStr = ""
                var letterGroupInd2 = Int(arc4random_uniform(UInt32(letterStringsReplace[x][letterArInd].count)))
                var end3 = letterGroupInd2
                if end3 == -1 {
                    end3 = letterStringsReplace[x][letterArInd].count - 1
                }
                repeat  {
                    letterGroup2 = letterStringsReplace[x][letterArInd][letterGroupInd2]
                    if letterGroup2 != letterGroup {
                        replaceStr = letterGroup2
                        break
                    }
                    letterGroupInd2 = (letterGroupInd2 + 1) % letterStringsReplace[x][letterArInd].count
                } while letterGroupInd2 != end3
                returnAr.append(ReplaceFirstOccurence(myString:word,substring:letterGroup,replaceStr:replaceStr))
               
                letterGroupInd2 = Int(arc4random_uniform(UInt32(letterStringsReplace[x][letterArInd].count)))
                end3 = letterGroupInd2
                if end3 == -1 {
                    end3 = letterStringsReplace[x][letterArInd].count - 1
                }
                repeat {
                    letterGroup2 = letterStringsReplace[x][letterArInd][letterGroupInd2]
                    if letterGroup2 != letterGroup && letterGroup2 != replaceStr {
                        replaceStr = letterGroup2
                        break
                    }
                    letterGroupInd2 = (letterGroupInd2 + 1) % letterStringsReplace[x][letterArInd].count
                } while letterGroupInd2 != end3
                
                returnAr.append(ReplaceFirstOccurence(myString:word,substring:letterGroup,replaceStr:replaceStr))
            
                return returnAr
            }
            
            letterArInd = (letterArInd + 1) % letterStringsFind[x].count
        } while letterArInd != end
    }
    
    return returnAr
}

func GetTextSize(text:String,fontSize:CGFloat) -> CGSize {
    let mySentence: NSString = text as NSString
    return mySentence.size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: GetFontSize(size:fontSize))])
}

func DrawLine(scene : SKScene, overlayNode : SKNode, ratio: Int,yPos : CGFloat, color : SKColor) {
    var startX = -scene.size.width/3
    var al = [SKAction]()
    let myRatio = 40 * ratio/12
    for i in 0...40 {
        var endX : CGFloat
        let n = i
        if n < myRatio {
            endX = startX+scene.size.width/61
        }
        else {
            endX = startX
        }
        let path = CGMutablePath()
        path.move(to: CGPoint(x:startX, y:yPos))
        path.addLine(to: CGPoint(x:endX, y:yPos))
        let line = SKShapeNode()
        line.path = path
        line.strokeColor = color
        line.isAntialiased = true
        line.lineWidth = GetFontSize(size:8)
        line.zPosition = 301.0
        startX = endX
        al.append(SKAction.run({
            overlayNode.addChild(line)
        }))
    }
    let w = SKAction.wait(forDuration: 0.05)
    overlayNode.run(SKAction.sequence([w,al[0],w,al[1],w,al[2],w,al[3],w,al[4],w,al[5]
        ,w,al[6],w,al[7],w,al[8],w,al[9],w,al[10],w,al[11],w,al[12],w,al[13],w,al[14],w,al[15]
        ,w,al[16],w,al[17],w,al[18],w,al[19],w,al[20],w,al[21],w,al[22],w,al[23],w,al[24],w,al[25]
        ,w,al[26],w,al[27],w,al[28],w,al[29],w,al[30],w,al[31],w,al[32],w,al[33],w,al[34],w,al[35]
        ,w,al[36],w,al[37],w,al[38],w,al[39],w,al[40]]))
}

func DisplayLevelFinished(scene : SKScene) {
    WriteResultsToFile()
    
    global.overlayNode.position = CGPoint(x: scene.size.width/2, y: 0)
    global.overlayNode.zPosition = 300
    
    let correctAnswers = global.correctAnswers
    let incorrectAnswers = global.incorrectAnswers
    let overlay = SKShapeNode(rectOf: CGSize(width: scene.size.width*8/10,height: scene.size.height*25/48),cornerRadius: GetCornerSize(size:30.0,max:scene.size.height*25/48))
    overlay.name = "overlay"
    overlay.fillColor = SKColor.white
    overlay.strokeColor = SKColor.purple
    overlay.position = .zero
    overlay.zPosition = 200
    global.overlayNode.addChild(overlay)
    
    for i in 0...2 {
        let star = SKSpriteNode(imageNamed: "BlackStar.png")
        var offset :CGFloat = 0.0
        if i == 1 {
            offset = scene.size.height/72
        }
        star.name = "star"
        star.position = CGPoint(x: -scene.size.width/8 + CGFloat(i) * (scene.size.width/8), y: offset+scene.size.height*5/24)
        star.scale(to: CGSize(width:scene.size.width/10,height:scene.size.width/10.5))
        star.zPosition = 201
        global.overlayNode.addChild(star)
    }
    
    let labelComplete = SKLabelNode(fontNamed: "Arial")
    labelComplete.text = "Level " + String(global.currentLevel) + " Complete!"
    labelComplete.fontSize = GetFontSize(size:25)
    labelComplete.fontColor = SKColor.red
    labelComplete.position = CGPoint(x: 0, y: scene.size.height*3/24)
    labelComplete.zPosition = 201.0
    labelComplete.name = "levelcomplete"
    global.overlayNode.addChild(labelComplete)
    let shadowComplete = CreateShadowLabel(label: labelComplete,offset: 0.6)
    global.overlayNode.addChild(shadowComplete)

    if correctAnswers >= global.minimumCorrectToUnlock && global.currentLevel == global.maxLevels {
        let labelComplete2 = SKLabelNode(fontNamed: "Arial")
        labelComplete2.text = "Congratulations!!!"
        labelComplete2.fontSize = GetFontSize(size:20)
        labelComplete2.fontColor = global.purple
        labelComplete2.position = CGPoint(x: 0, y: scene.size.height*2/24)
        labelComplete2.zPosition = 201.0
        labelComplete2.name = "levelcomplete"
        global.overlayNode.addChild(labelComplete2)
        let shadowComplete2 = CreateShadowLabel(label: labelComplete2,offset: 0.6)
        global.overlayNode.addChild(shadowComplete2)
        
        let labelComplete3 = SKLabelNode(fontNamed: "Arial")
        labelComplete3.text = "You completed the final level!"
        labelComplete3.fontSize = GetFontSize(size:18)
        labelComplete3.fontColor = global.purple
        labelComplete3.position = CGPoint(x: 0, y: scene.size.height*1.3/24)
        labelComplete3.zPosition = 201.0
        labelComplete3.name = "levelcomplete"
        global.overlayNode.addChild(labelComplete3)
        let shadowComplete3 = CreateShadowLabel(label: labelComplete3,offset: 0.6)
        global.overlayNode.addChild(shadowComplete3)
    }
    else if correctAnswers >= global.minimumCorrectToUnlock {
        let labelComplete2 = SKLabelNode(fontNamed: "Arial")
        labelComplete2.text = "You unlocked the next level!"
        labelComplete2.fontSize = GetFontSize(size:20)
        labelComplete2.fontColor = global.purple
        labelComplete2.position = CGPoint(x: 0, y: scene.size.height*1.5/24)
        labelComplete2.zPosition = 201.0
        labelComplete2.name = "levelcomplete"
        global.overlayNode.addChild(labelComplete2)
        let shadowComplete2 = CreateShadowLabel(label: labelComplete2,offset: 0.6)
        global.overlayNode.addChild(shadowComplete2)
    }
    else {
        let labelComplete2 = SKLabelNode(fontNamed: "Arial")
        labelComplete2.text = "Get at least " + String(global.minimumCorrectToUnlock) + "/12 correct"
        labelComplete2.fontSize = GetFontSize(size:16)
        labelComplete2.fontColor = global.purple
        labelComplete2.position = CGPoint(x: 0, y: scene.size.height*2/24)
        labelComplete2.zPosition = 201.0
        labelComplete2.name = "levelcomplete"
        global.overlayNode.addChild(labelComplete2)
        let shadowComplete2 = CreateShadowLabel(label: labelComplete2,offset: 0.6)
        global.overlayNode.addChild(shadowComplete2)
        
        let labelComplete3 = SKLabelNode(fontNamed: "Arial")
        labelComplete3.text = "to unlock the next level"
        labelComplete3.fontSize = GetFontSize(size:16)
        labelComplete3.fontColor = global.purple
        labelComplete3.position = CGPoint(x: 0, y: scene.size.height*1.3/24)
        labelComplete3.zPosition = 201.0
        labelComplete3.name = "levelcomplete"
        global.overlayNode.addChild(labelComplete3)
        let shadowComplete3 = CreateShadowLabel(label: labelComplete3,offset: 0.6)
        global.overlayNode.addChild(shadowComplete3)
    }
    
    let labelCorrect = SKLabelNode(fontNamed: "Arial")
    labelCorrect.text = "Correct Answers: " + String(correctAnswers) + " / 12"
    labelCorrect.fontSize = GetFontSize(size:18)
    labelCorrect.fontColor = SKColor.blue
    labelCorrect.position = CGPoint(x: 0, y: -scene.size.height*0.5/24)
    labelCorrect.zPosition = 201.0
    labelCorrect.name = "levelcomplete"
    global.overlayNode.addChild(labelCorrect)
    let shadowCorrect = CreateShadowLabel(label: labelCorrect,offset: 0.6)
    global.overlayNode.addChild(shadowCorrect)
    
    let labelIncorrect = SKLabelNode(fontNamed: "Arial")
    labelIncorrect.text = "Incorrect Answers: " + String(incorrectAnswers) + " / 12"
    labelIncorrect.fontSize = GetFontSize(size:18)
    labelIncorrect.fontColor = SKColor.red
    labelIncorrect.position = CGPoint(x: 0, y: -scene.size.height*2.5/24)
    labelIncorrect.zPosition = 201.0
    labelIncorrect.name = "levelcomplete"
    global.overlayNode.addChild(labelIncorrect)
    let shadowIncorrect = CreateShadowLabel(label: labelIncorrect,offset: 0.6)
    global.overlayNode.addChild(shadowIncorrect)
    scene.addChild(global.overlayNode)
    
    let home = SKSpriteNode(imageNamed: "home.png")
    home.name = "home"
    home.position = CGPoint(x: -scene.size.width/5, y: -scene.size.height*5/24)
    home.scale(to: CGSize(width:scene.size.width/10,height:scene.size.width/10))
    home.zPosition = 201
    global.overlayNode.addChild(home)
    
    let labelHome = SKLabelNode(fontNamed: "Arial")
    labelHome.text = "Home"
    labelHome.fontSize = GetFontSize(size:10)
    labelHome.fontColor = SKColor.red
    labelHome.position = CGPoint(x: -scene.size.width/5, y: -scene.size.height*6/24)
    labelHome.zPosition = 201.0
    labelHome.name = "home"
    global.overlayNode.addChild(labelHome)
    let shadowHome = CreateShadowLabel(label: labelHome,offset: 0.6)
    global.overlayNode.addChild(shadowHome)
    
    let retry = SKSpriteNode(imageNamed: "retry.png")
    retry.name = "retry"
    retry.position = CGPoint(x: 0, y: -scene.size.height*5/24)
    retry.scale(to: CGSize(width:scene.size.width/14,height:scene.size.width/14))
    retry.zPosition = 201
    global.overlayNode.addChild(retry)
    
    let labelRetry = SKLabelNode(fontNamed: "Arial")
    labelRetry.text = "Retry"
    labelRetry.fontSize = GetFontSize(size:10)
    labelRetry.fontColor = SKColor.red
    labelRetry.position = CGPoint(x: 0, y: -scene.size.height*6/24)
    labelRetry.zPosition = 201.0
    labelRetry.name = "retry"
    global.overlayNode.addChild(labelRetry)
    let shadowRetry = CreateShadowLabel(label: labelRetry,offset: 0.6)
    global.overlayNode.addChild(shadowRetry)
    
    if correctAnswers >= global.minimumCorrectToUnlock && global.currentLevel != global.maxLevels {
        let next = SKSpriteNode(imageNamed: "next.png")
        next.name = "next"
        next.position = CGPoint(x: scene.size.width/5, y: -scene.size.height*5/24)
        next.scale(to: CGSize(width:scene.size.width/12,height:scene.size.width/12))
        next.zPosition = 201
        global.overlayNode.addChild(next)
        
        let labelNext = SKLabelNode(fontNamed: "Arial")
        labelNext.text = "Next"
        labelNext.fontSize = GetFontSize(size:10)
        labelNext.fontColor = SKColor.red
        labelNext.position = CGPoint(x: scene.size.width/5, y: -scene.size.height*6/24)
        labelNext.zPosition = 201.0
        labelNext.name = "next"
        global.overlayNode.addChild(labelNext)
        let shadowNext = CreateShadowLabel(label: labelNext,offset: 0.6)
        global.overlayNode.addChild(shadowNext)
    }
    
    var addStars = [SKAction]()
    for i in 0...2 {
        addStars.append(SKAction.run({
            var star = SKSpriteNode(imageNamed: "BlackStar.png")
            if (i+1)*3 <= correctAnswers {
                star = SKSpriteNode(imageNamed: "GoldStar.png")
            }
            var offset :CGFloat = 0.0
            if i == 1 {
                offset = scene.size.height/72
            }
            star.name = "star"
            star.position = CGPoint(x: -scene.size.width/8 + CGFloat(i) * (scene.size.width/8), y: offset+scene.size.height*5/24)
            star.scale(to: CGSize(width:scene.size.width/10,height:scene.size.width/10.5))
            star.zPosition = 202
            global.overlayNode.addChild(star)
        }))
    }
    
    
    var wrongProgressSound = SKAction.wait(forDuration: 0.001)
    var correctProgressSound = SKAction.wait(forDuration: 0.001)
    if correctAnswers > 0 {
        correctProgressSound = SKAction.playSoundFileNamed("CorrectProgress.wav", waitForCompletion: false)
        if global.soundOption == 2 {
            correctProgressSound = SKAction.wait(forDuration: 0.0001)
        }
    }
    if incorrectAnswers > 0 {
        wrongProgressSound = SKAction.playSoundFileNamed("WrongProgress.wav", waitForCompletion: false)
        if global.soundOption == 2 {
            wrongProgressSound = SKAction.wait(forDuration: 0.0001)
        }
    }
    
    var levelCompleteSound = SKAction.playSoundFileNamed("LevelCompleted.wav", waitForCompletion: false)
    if global.soundOption == 2 {
        levelCompleteSound = SKAction.wait(forDuration: 0.0001)
    }
    var star1Sound = SKAction.wait(forDuration: 0.001)
    var star2Sound = SKAction.wait(forDuration: 0.001)
    var star3Sound = SKAction.wait(forDuration: 0.001)
    if correctAnswers >= 3 {
        star1Sound = SKAction.playSoundFileNamed("Star1.wav", waitForCompletion: false)
        if global.soundOption == 2 {
            star1Sound = SKAction.wait(forDuration: 0.0001)
        }
    }
    if correctAnswers >= 6 {
        star2Sound = SKAction.playSoundFileNamed("Star2.wav", waitForCompletion: false)
        if global.soundOption == 2 {
            star2Sound = SKAction.wait(forDuration: 0.0001)
        }
    }    
    if correctAnswers >= 9 {
        star3Sound = SKAction.playSoundFileNamed("Star3.wav", waitForCompletion: false)
        if global.soundOption == 2 {
            star3Sound = SKAction.wait(forDuration: 0.0001)
        }
    }
    
    global.correctAnswers = 0
    global.incorrectAnswers = 0
    
    let wait = SKAction.wait(forDuration: 0.6)
    let action = SKAction.moveBy(x: 0, y: scene.size.height/2, duration: 1.5)
    action.timingMode = SKActionTimingMode.easeInEaseOut
    global.overlayNode.run(SKAction.sequence([levelCompleteSound,action,wait,star1Sound,addStars[0],wait,star2Sound,addStars[1],wait,star3Sound,addStars[2],wait,
                                       correctProgressSound,
                                       SKAction.run({
                                        DrawLine(scene:scene,overlayNode:global.overlayNode,ratio:correctAnswers,yPos:-scene.size.height*2/48,color:SKColor.blue)}),
                                       wait,wait,
                                       wrongProgressSound,
                                       SKAction.run({
                                       DrawLine(scene:scene,overlayNode:global.overlayNode,ratio:incorrectAnswers,yPos:-scene.size.height*6/48,color:SKColor.red)
                                        })
        ]))
    
    
    
}

func WriteResultsToFile() {
    let sceneTypeAr = ["Math","Grammar","Vocabulary","Spelling"]
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
                        for x in 0..<sceneTypeAr.count {
                            if global.sceneType == sceneTypeAr[x] {
                                var data = playerDataAr[2+x].characters.split{$0 == " "}.map(String.init)
                                let levelCompleteCount = data.count
                                if levelCompleteCount < global.currentLevel {
                                    if levelCompleteCount < global.currentLevel-1 {
                                        for _ in levelCompleteCount..<global.currentLevel-1 {
                                            data.append("0")
                                        }
                                    }
                                    data.append(String(global.correctAnswers))
                                }
                                else  {
                                    data[global.currentLevel-1] = String(global.correctAnswers)
                                }
                                playerDataAr[2+x] = data.joined(separator: " ")
                                break
                            }
                        }
                        lineAr[i] = playerDataAr.joined(separator: "*")
                    }
                }
            }
            fileText = lineAr.joined(separator: "\n")
            try! fileText.write(toFile: path, atomically: false, encoding: String.Encoding.utf8)
        }
        catch {
            print("File read error:", error)
        }
    }
}

class GameViewController: UIViewController, SKViewDelegate {

    var bgSoundPlayer:AVAudioPlayer?
    var background = SKSpriteNode(imageNamed: "background3.jpg")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.playBackgroundSound(_:)), name: NSNotification.Name(rawValue: "PlayBackgroundSound"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.stopBackgroundSound), name: NSNotification.Name(rawValue: "StopBackgroundSound"), object: nil)
       
        let scene = GameScene(size: view.bounds.size)
        let skView = view as! SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.ignoresSiblingOrder = true
        global.view = skView
        scene.scaleMode = .resizeFill
        //skView.delegate = self as SKViewDelegate
        scene.viewController = self
        skView.presentScene(scene)        
    }
    
    func playBackgroundSound(_ notification: Notification) {
        global.musicStarted = true
        //get the name of the file to play from the data passed in with the notification
        let name = (notification as NSNotification).userInfo!["fileToPlay"] as! String
        
        //if the bgSoundPlayer already exists, stop it and make it nil again
        if (bgSoundPlayer != nil) {
            bgSoundPlayer!.stop()
            bgSoundPlayer = nil
        }
        
        //as long as name has at least some value, proceed...
        if (name != ""){
            //create a URL variable using the name variable and tacking on the "mp3" extension
            let fileURL:URL = Bundle.main.url(forResource:name, withExtension: "mp3")!
            
            //basically, try to initialize the bgSoundPlayer with the contents of the URL
            do {
                bgSoundPlayer = try AVAudioPlayer(contentsOf: fileURL)
            } catch _{
                bgSoundPlayer = nil
                
            }
            
            bgSoundPlayer!.volume = 0.75 //set the volume anywhere from 0 to 1
            bgSoundPlayer!.numberOfLoops = -1 // -1 makes the player loop forever
            bgSoundPlayer!.prepareToPlay() //prepare for playback by preloading its buffers.
            bgSoundPlayer!.play() //actually play
        }
    }
    
    func stopBackgroundSound() {
        global.musicStarted = false
        //if the bgSoundPlayer isn't nil, then stop it
        if (bgSoundPlayer != nil){
            bgSoundPlayer!.stop()
            bgSoundPlayer = nil
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
            return .portrait
    }
  /*
    override var shouldAutorotate: Bool {
        return true
    }
 */
 /*
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
 */
}

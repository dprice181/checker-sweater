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
    let titleColor = SKColor(red: 185/255, green: 80/255, blue: 185/255, alpha: 1.0)
    let blue = SKColor(red:90/255,green:90/255,blue:215/255,alpha:1)
    let lightBlue = SKColor(red:130/255,green:130/255,blue:225/255,alpha:1)
    let lightPurple = SKColor(red: 245/255, green: 225/255, blue: 245/255, alpha: 0.8)
    let veryLightBlue = SKColor(red: 225/255, green: 225/255, blue: 255/255, alpha: 0.8)
    let purple = SKColor(red: 55/255, green: 15/255, blue: 200/255, alpha: 1)
    let greyBlue = SKColor(red: 240/255, green: 240/255, blue: 255/255, alpha: 0.8)
    let overlayNode = SKNode()
    var correctAnswers = 0
    var incorrectAnswers = 0
    var currentSentenceNum = 0
}

let global = Global()

func CreateShadowLabel(label : SKLabelNode,offset: CGFloat) -> SKLabelNode
{
    if let shadowLabel = label.copy() as? SKLabelNode {
        shadowLabel.fontColor = SKColor.black
        shadowLabel.position = CGPoint(x:-offset+shadowLabel.position.x , y:offset+shadowLabel.position.y)
        shadowLabel.zPosition = shadowLabel.zPosition - 0.5
        return shadowLabel
    }
    
    return SKLabelNode()
}

func TransitionBackFromScene(myScene: SKScene)
{
    for child in global.overlayNode.children {
        child.removeFromParent()
    }
    global.overlayNode.removeFromParent()
    let dictToSend: [String: String] = ["fileToPlay": "BackgroundMusic" ]
    NotificationCenter.default.post(name: Notification.Name(rawValue: "PlayBackgroundSound"), object: myScene, userInfo:dictToSend)
    
    let playSound = SKAction.playSoundFileNamed("QuizRight.wav", waitForCompletion: false)
    let newScene = SKAction.run({
        let reveal = SKTransition.reveal(with:SKTransitionDirection.left, duration:1.0)
        
        let nextScene = LevelSelectScene(size: myScene.size,currentSentenceNum:0,correctAnswers:0,incorrectAnswers:0,currentExtraWordNum:0,sceneType:"LevelSelect")
        myScene.view?.presentScene(nextScene, transition: reveal)
        
    })
    myScene.run(SKAction.sequence([playSound,newScene]))
}

func ReplaceFirstOccurence(myString: String,substring: String,replaceStr: String) -> String {
    var chars = Array(myString.characters)
    var newChars = [Character]()
    var subchars = Array(substring.characters)
    var replacechars = Array(replaceStr.characters)
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

func InitLetterStrings() {
    global.letterStrings.append(["e","a","i"])
    global.letterStrings.append(["ie","ei","ae","ey","a"])
    global.letterStrings.append(["ee", "ui", "e","i"])
    global.letterStrings.append(["oo", "iu", "ue", "u"])
    global.letterStrings.append(["ou","oo","o"])
    global.letterStrings.append(["ck", "kk", "k", "cc", "c", ])
    global.letterStrings.append(["ff","f","ph","gh"])
    global.letterStrings.append(["gg", "g", "j"])
    global.letterStrings.append(["wh","gh", "h"])
    global.letterStrings.append(["ll","rr","r","l"])
    global.letterStrings.append(["nn","mm","mn","n","m"])
    global.letterStrings.append(["pp","bb","p","b"])
    global.letterStrings.append(["qu","q","k"])
    global.letterStrings.append(["ss","cc","c","s",])
    global.letterStrings.append(["tt","dd","d","t"])
    global.letterStrings.append(["bb","dd","b","d"])
    global.letterStrings.append(["vv","v","w"])
    global.letterStrings.append(["cks","cs","ks","x"])
    global.letterStrings.append(["ie","ee","y","e"])
    global.letterStrings.append(["zz","ss","z","s"])
}

func Misspell(word: String) -> [String] {
    
    var returnAr = [String]()
    if word.count < 2 {
        returnAr.append(word)
        returnAr.append(word)
        returnAr.append(word)
        return returnAr
    }
    
    var letterArInd = Int(arc4random_uniform(UInt32(global.letterStrings.count)))
    var end = letterArInd-1
    if end == -1 {
        end = global.letterStrings.count - 1
    }
    
    var letterGroup2 = ""
    //cycle around the array with a random started index
    while letterArInd != end {        
        let letterAr = global.letterStrings[letterArInd]
        
        var letterGroupInd = Int(arc4random_uniform(UInt32(letterAr.count)))
        var end2 = letterGroupInd-1
        if end2 == -1 {
            end2 = letterAr.count - 1
        }
        while letterGroupInd != end2 {
            let letterGroup = letterAr[letterGroupInd]
            if word.contains(letterGroup) {
                var underscoreStr = ""
                for _ in 0...letterGroup.count-1 {
                    underscoreStr = underscoreStr + "_"
                }
                returnAr.append(ReplaceFirstOccurence(myString:word,substring:letterGroup,replaceStr:underscoreStr))
                
                var replaceStr = ""
                var letterGroupInd2 = Int(arc4random_uniform(UInt32(letterAr.count)))
                var end3 = letterGroupInd2-1
                if end3 == -1 {
                    end3 = letterAr.count - 1
                }
                while letterGroupInd2 != end3 {
                    letterGroup2 = letterAr[letterGroupInd2]
                    if letterGroup2 != letterGroup {
                        replaceStr = letterGroup2
                        break
                    }
                    letterGroupInd2 = (letterGroupInd2 + 1) % letterAr.count
                }
                returnAr.append(ReplaceFirstOccurence(myString:word,substring:letterGroup,replaceStr:replaceStr))
               
                letterGroupInd2 = Int(arc4random_uniform(UInt32(letterAr.count)))
                end3 = letterGroupInd2-1
                if end3 == -1 {
                    end3 = letterAr.count - 1
                }
                while letterGroupInd2 != end3 {
                    letterGroup2 = letterAr[letterGroupInd2]
                    if letterGroup2 != letterGroup && letterGroup2 != replaceStr {
                        replaceStr = letterGroup2
                        break
                    }
                    letterGroupInd2 = (letterGroupInd2 + 1) % letterAr.count
                }
                
                returnAr.append(ReplaceFirstOccurence(myString:word,substring:letterGroup,replaceStr:replaceStr))
            
                return returnAr
            }
            letterGroupInd = (letterGroupInd + 1) % letterAr.count
        }
        letterArInd = (letterArInd + 1) % global.letterStrings.count
    }
    
    return returnAr
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
        line.lineWidth = 8
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
    global.overlayNode.position = CGPoint(x: scene.size.width/2, y: 0)
    global.overlayNode.zPosition = 300
    
    let overlay = SKShapeNode(rectOf: CGSize(width: scene.size.width*8/10,height: scene.size.height*25/48),cornerRadius: 30.0)
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
    labelComplete.fontSize = 25
    labelComplete.fontColor = SKColor.red
    labelComplete.position = CGPoint(x: 0, y: scene.size.height*3/24)
    labelComplete.zPosition = 201.0
    labelComplete.name = "levelcomplete"
    global.overlayNode.addChild(labelComplete)
    let shadowComplete = CreateShadowLabel(label: labelComplete,offset: 0.6)
    global.overlayNode.addChild(shadowComplete)
    
    if global.correctAnswers >= 9 {
        let labelComplete2 = SKLabelNode(fontNamed: "Arial")
        labelComplete2.text = "You unlocked the next level!"
        labelComplete2.fontSize = 20
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
        labelComplete2.text = "Get at least 9/12 correct"
        labelComplete2.fontSize = 16
        labelComplete2.fontColor = global.purple
        labelComplete2.position = CGPoint(x: 0, y: scene.size.height*2/24)
        labelComplete2.zPosition = 201.0
        labelComplete2.name = "levelcomplete"
        global.overlayNode.addChild(labelComplete2)
        let shadowComplete2 = CreateShadowLabel(label: labelComplete2,offset: 0.6)
        global.overlayNode.addChild(shadowComplete2)
        
        let labelComplete3 = SKLabelNode(fontNamed: "Arial")
        labelComplete3.text = "to unlock the next level"
        labelComplete3.fontSize = 16
        labelComplete3.fontColor = global.purple
        labelComplete3.position = CGPoint(x: 0, y: scene.size.height*1.3/24)
        labelComplete3.zPosition = 201.0
        labelComplete3.name = "levelcomplete"
        global.overlayNode.addChild(labelComplete3)
        let shadowComplete3 = CreateShadowLabel(label: labelComplete3,offset: 0.6)
        global.overlayNode.addChild(shadowComplete3)
    }
    
    let labelCorrect = SKLabelNode(fontNamed: "Arial")
    labelCorrect.text = "Correct Answers: " + String(global.correctAnswers) + " / 12"
    labelCorrect.fontSize = 18
    labelCorrect.fontColor = SKColor.blue
    labelCorrect.position = CGPoint(x: 0, y: -scene.size.height*0.5/24)
    labelCorrect.zPosition = 201.0
    labelCorrect.name = "levelcomplete"
    global.overlayNode.addChild(labelCorrect)
    let shadowCorrect = CreateShadowLabel(label: labelCorrect,offset: 0.6)
    global.overlayNode.addChild(shadowCorrect)
    
    let labelIncorrect = SKLabelNode(fontNamed: "Arial")
    labelIncorrect.text = "Incorrect Answers: " + String(global.incorrectAnswers) + " / 12"
    labelIncorrect.fontSize = 18
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
    labelHome.fontSize = 10
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
    labelRetry.fontSize = 10
    labelRetry.fontColor = SKColor.red
    labelRetry.position = CGPoint(x: 0, y: -scene.size.height*6/24)
    labelRetry.zPosition = 201.0
    labelRetry.name = "retry"
    global.overlayNode.addChild(labelRetry)
    let shadowRetry = CreateShadowLabel(label: labelRetry,offset: 0.6)
    global.overlayNode.addChild(shadowRetry)
    
    if global.correctAnswers >= 9 {
        let next = SKSpriteNode(imageNamed: "next.png")
        next.name = "next"
        next.position = CGPoint(x: scene.size.width/5, y: -scene.size.height*5/24)
        next.scale(to: CGSize(width:scene.size.width/12,height:scene.size.width/12))
        next.zPosition = 201
        global.overlayNode.addChild(next)
        
        let labelNext = SKLabelNode(fontNamed: "Arial")
        labelNext.text = "Next"
        labelNext.fontSize = 10
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
            if (i+1)*3 <= global.correctAnswers {
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
    if global.correctAnswers > 0 {
        correctProgressSound = SKAction.playSoundFileNamed("CorrectProgress.wav", waitForCompletion: false)
    }
    if global.incorrectAnswers > 0 {
        wrongProgressSound = SKAction.playSoundFileNamed("WrongProgress.wav", waitForCompletion: false)
    }
    
    let levelCompleteSound = SKAction.playSoundFileNamed("LevelCompleted.wav", waitForCompletion: false)
    var star1Sound = SKAction.wait(forDuration: 0.001)
    var star2Sound = SKAction.wait(forDuration: 0.001)
    var star3Sound = SKAction.wait(forDuration: 0.001)
    if global.correctAnswers >= 3 {
        star1Sound = SKAction.playSoundFileNamed("Star1.wav", waitForCompletion: false)
    }
    if global.correctAnswers >= 6 {
        star2Sound = SKAction.playSoundFileNamed("Star2.wav", waitForCompletion: false)
    }
    if global.correctAnswers >= 9 {
        star3Sound = SKAction.playSoundFileNamed("Star3.wav", waitForCompletion: false)
    }
    let wait = SKAction.wait(forDuration: 0.6)
    let action = SKAction.moveBy(x: 0, y: scene.size.height/2, duration: 1.5)
    action.timingMode = SKActionTimingMode.easeInEaseOut
    global.overlayNode.run(SKAction.sequence([levelCompleteSound,action,wait,star1Sound,addStars[0],wait,star2Sound,addStars[1],wait,star3Sound,addStars[2],wait,
                                       correctProgressSound,
                                       SKAction.run({
                                        DrawLine(scene:scene,overlayNode:global.overlayNode,ratio:global.correctAnswers,yPos:-scene.size.height*2/48,color:SKColor.blue)}),
                                       wait,wait,
                                       wrongProgressSound,
                                       SKAction.run({
                                       DrawLine(scene:scene,overlayNode:global.overlayNode,ratio:global.incorrectAnswers,yPos:-scene.size.height*6/48,color:SKColor.red)
                                            global.correctAnswers = 0
                                            global.incorrectAnswers = 0
                                            global.currentSentenceNum = 0
                                        })
        ]))
}

class GameViewController: UIViewController, SKViewDelegate {

        var bgSoundPlayer:AVAudioPlayer?
    
        var background = SKSpriteNode(imageNamed: "background3.jpg")
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.playBackgroundSound(_:)), name: NSNotification.Name(rawValue: "PlayBackgroundSound"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.stopBackgroundSound), name: NSNotification.Name(rawValue: "StopBackgroundSound"), object: nil)
        /*
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
 */
        let scene = GameScene(size: view.bounds.size)
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        global.view = skView
        scene.scaleMode = .resizeFill
        //skView.delegate = self as SKViewDelegate
        scene.viewController = self
        skView.presentScene(scene)
        
    }
    
    func playBackgroundSound(_ notification: Notification) {        
        //get the name of the file to play from the data passed in with the notification
        let name = (notification as NSNotification).userInfo!["fileToPlay"] as! String
        
        //if the bgSoundPlayer already exists, stop it and make it nil again
        if (bgSoundPlayer != nil){
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
        //if the bgSoundPlayer isn't nil, then stop it
        if (bgSoundPlayer != nil){
            bgSoundPlayer!.stop()
            bgSoundPlayer = nil
        }
    }
    
    /*
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
 */
}

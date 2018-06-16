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
    let lightBlue = SKColor(red:130/255,green:130/255,blue:225/255,alpha:1)
    let lightPurple = SKColor(red: 245/255, green: 225/255, blue: 245/255, alpha: 0.8)
    let veryLightBlue = SKColor(red: 225/255, green: 225/255, blue: 255/255, alpha: 0.8)
}

let global = Global()

func CreateShadowLabel(label : SKLabelNode,offset: CGFloat) -> SKLabelNode
{
    if let shadowLabel = label.copy() as? SKLabelNode
    {
        shadowLabel.fontColor = SKColor.black
        shadowLabel.position = CGPoint(x:-offset+shadowLabel.position.x , y:offset+shadowLabel.position.y)
        shadowLabel.zPosition = shadowLabel.zPosition - 0.5
        return shadowLabel
    }
    
    return SKLabelNode()
}

func TransitionBackFromScene(myScene: SKScene)
{
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

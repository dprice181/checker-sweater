//
//  OptionsScene.swift
//  ScholarKids
//
//  Created by Doug Price on 7/16/18.
//  Copyright © 2018 Doug Price. All rights reserved.
//

//purchase levels
//give credit to music guy
import SpriteKit
import GameplayKit

class OptionsScene: SKScene {
    
    var buttonAr = [SKShapeNode]()
    var labelAr = [SKLabelNode]()
    var labelShadowAr = [SKLabelNode]()
    var lockAr = [SKSpriteNode]()
    var clickButtonAr = [SKShapeNode]()
    var clickButtonShadowAr = [SKShapeNode]()
    var buttonLabelAr = [SKLabelNode]()
    
    var optionAr = [String]()
    var optionsStrings = ["Music":1,"Sound":3,"Correct":5,"Math":7,"Grammar":9,"Vocabulary":11,"Spelling":13]
    
    init(size: CGSize, currentSentenceNum:Int, correctAnswers:Int, incorrectAnswers:Int, currentExtraWordNum:Int,sceneType:String) {
        super.init(size: size)
        
        backgroundColor = SKColor(red: 234/255, green: 230/255, blue: 236/255, alpha: 1)
        CreateFileIfNecessary()
        ReadOptionsFile()
        DrawTitle()
        DrawOptions()
        DrawBackButton()
    }
    
    func CreateFileIfNecessary()
    {
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
    
    func ReadOptionsFile()
    {
        let file = "Options.txt" //this is the file. we will write to and read from it
        if let dir = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true).first {
            let path = dir + "/" + file
            do {
                var fileText = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
                optionAr = fileText.characters.split{$0 == "*"}.map(String.init)
                
                //try! fileText.write(toFile: path, atomically: false, encoding: String.Encoding.utf8)
            }
            catch {
                print("File read error:", error)
            }
        }
    }
    
    func IsButtonSelected(text:String,text2:String,i:Int) -> Bool {
        var returnVal = false
        if text == "Music" {
            if optionAr[optionsStrings["Music"]!] == String(i) {
                returnVal = true
            }
        }
        if text == "Sound Effects" {
            if optionAr[optionsStrings["Sound"]!] == String(i) {
                returnVal = true
            }
        }
        if text == "# Correct To Advance Level" {
            if optionAr[optionsStrings["Correct"]!] == String(i) {
                returnVal = true
            }
        }
        if text2 == "Math" {
            if optionAr[optionsStrings["Math"]!] == "1" {
                returnVal = true
            }
        }
        if text2 == "Grammar" {
            if optionAr[optionsStrings["Grammar"]!] == "1" {
                returnVal = true
            }
        }
        if text2 == "Vocabulary" {
            if optionAr[optionsStrings["Vocabulary"]!] == "1" {
                returnVal = true
            }
        }
        if text2 == "Spelling" {
            if optionAr[optionsStrings["Spelling"]!] == "1" {
                returnVal = true
            }
        }
        return returnVal
    }
    
    func DrawOptions() {
        var textAr1 = ["Always","Menus","Always"]
        var textAr2 = ["On","Only","Off"]
        var offY : CGFloat = 0.0
        DrawOption(ind:0,text:"Music",textAr1:textAr1,textAr2:textAr2,offY:offY,fontSize:25,fontSize2:18,fontColor:global.purple,boxColor:global.lightPink,boxColorSelected:SKColor.red,extraBoxWidth:0,removeAds:false,lock:false)
        
        textAr1 = ["Always","Menus","Always"]
        textAr2 = ["On","Only","Off"]
        offY = -self.size.height*7/48
        DrawOption(ind:1,text:"Sound Effects",textAr1:textAr1,textAr2:textAr2,offY:offY,fontSize:25,fontSize2:18,fontColor:global.purple,boxColor:global.lightPink,boxColorSelected:SKColor.red,extraBoxWidth:0,removeAds:false,lock:false)
        
        textAr1 = ["0","3","6","9","12"]
        textAr2 = []
        offY = -self.size.height*14/48
        DrawOption(ind:2,text:"# Correct To Advance Level",textAr1:textAr1,textAr2:textAr2,offY:offY,fontSize:25,fontSize2:30,fontColor:global.purple,boxColor:global.lightPink,boxColorSelected:SKColor.red,extraBoxWidth:0,removeAds:false,lock:false)
        
        textAr1 = ["Math","Grammar","Vocabulary","Spelling"]
        textAr2 = []
        offY = -self.size.height*22/48
        DrawOption(ind:3,text:"Unlock All Levels",textAr1:textAr1,textAr2:textAr2,offY:offY,fontSize:25,fontSize2:16,fontColor:SKColor.red,boxColor:global.realPurple,boxColorSelected:global.realPurple,extraBoxWidth:self.size.width/24,removeAds:true,lock:true)
        
        DrawButtons()
    }
    
    func DrawOption(ind:Int,text: String,textAr1:[String],textAr2:[String],offY:CGFloat,fontSize:CGFloat,
                    fontSize2:CGFloat,fontColor:SKColor,boxColor:SKColor,boxColorSelected:SKColor,extraBoxWidth:CGFloat,
                    removeAds:Bool,lock:Bool) {
        var myOffY = offY
        let fullLabel = SKNode()
        fullLabel.position = CGPoint(x: self.size.width/24, y: self.size.height*42/48 + myOffY)
        fullLabel.zPosition = 100.0
        
        let label = SKLabelNode(fontNamed: "Arial")
        label.text = text
        label.fontSize = fontSize
        label.fontColor = fontColor
        label.horizontalAlignmentMode = .left
        label.position = .zero
        label.zPosition = 100.0
        fullLabel.addChild(label)
        let labelShadow = CreateShadowLabel(label: label,offset: 1)
        fullLabel.addChild(labelShadow)
        
        if removeAds {
            let label2 = SKLabelNode(fontNamed: "Arial")
            label2.text = "(Any Purchase Removes All Ads)"
            label2.fontSize = fontSize-2
            label2.fontColor = fontColor
            label2.horizontalAlignmentMode = .left
            label2.position = CGPoint(x:0,y:-self.size.height*2/48)
            myOffY = myOffY - self.size.height*2/48
            label2.zPosition = 100.0
            fullLabel.addChild(label2)
            let label2Shadow = CreateShadowLabel(label: label2,offset: 1)
            fullLabel.addChild(label2Shadow)
        }
        addChild(fullLabel)
        
        var xPos = self.size.width/5
        var xPosInc = self.size.width/4
        var labOffY : CGFloat = 0.0
        if textAr1.count == 5 {
            xPos = self.size.width/18
            xPosInc = self.size.width/5
            labOffY = -self.size.height*0.4/24
        }
        if textAr1.count == 4 {
            xPos = self.size.width/12
            xPosInc = self.size.width/4
            labOffY = self.size.height*0.1/24
        }
        
        for i in 0..<textAr1.count {
            let isButtonSelected = IsButtonSelected(text:text,text2:textAr1[i],i:i)
            
            let fullButton = SKNode()
            fullButton.position = CGPoint(x: self.size.width/24, y: self.size.height*42.5/48 + myOffY)
            fullButton.zPosition = 100.0
            
            buttonAr.append(SKShapeNode(rectOf: CGSize(width: self.size.width/6 + extraBoxWidth,height: self.size.height*4/48),cornerRadius: 20.0))
            buttonAr.last!.name = "optionbutton" + String(ind)
            buttonAr.last!.fillColor = backgroundColor
            if isButtonSelected {
                buttonAr.last!.strokeColor = boxColorSelected
            }
            else {
                buttonAr.last!.strokeColor = boxColor
            }
            buttonAr.last!.lineWidth = 3
            buttonAr.last!.position = CGPoint(x: xPos, y: -self.size.height*1.6/24)
            fullButton.addChild(buttonAr.last!)
            
            labelAr.append(SKLabelNode(fontNamed: "Arial"))
            labelAr.last!.text = textAr1[i]
            labelAr.last!.name = "optionbutton" + String(ind)
            labelAr.last!.fontSize = fontSize2
            if isButtonSelected {
                labelAr.last!.fontColor = boxColorSelected
            }
            else {
                labelAr.last!.fontColor = boxColor
            }
            labelAr.last!.position = CGPoint(x: xPos, y: -self.size.height*1.6/24 + labOffY)
            labelAr.last!.zPosition = 100.0
            fullButton.addChild(labelAr.last!)
            labelShadowAr.append(CreateShadowLabel(label: labelAr.last!,offset: 1))
            labelShadowAr.last!.name = "optionshadow" + String(ind)
            if isButtonSelected == false && lock==false {  //always hightlight the unlock levels
                labelShadowAr.last!.isHidden = true
            }
            fullButton.addChild(labelShadowAr.last!)
            
            if textAr2.count > i {
                labelAr.append(SKLabelNode(fontNamed: "Arial"))
                labelAr.last!.text = textAr2[i]
                labelAr.last!.name = "optionbutton" + String(ind)
                labelAr.last!.fontSize = fontSize2
                if isButtonSelected {
                    labelAr.last!.fontColor = boxColorSelected
                }
                else {
                    labelAr.last!.fontColor = boxColor
                }
                labelAr.last!.position = CGPoint(x: xPos, y: -self.size.height*1.6/24 - self.size.height/32)
                labelAr.last!.zPosition = 100.0
                fullButton.addChild(labelAr.last!)
                labelShadowAr.append(CreateShadowLabel(label: labelAr.last!,offset: 1))
                labelShadowAr.last!.name = "optionshadow" + String(ind)
                if isButtonSelected == false && lock==false {  //always hightlight the unlock levels
                    labelShadowAr.last!.isHidden = true
                }
                fullButton.addChild(labelShadowAr.last!)
            }
            
            if lock && isButtonSelected == false {
                lockAr.append(SKSpriteNode(imageNamed: "lock.png"))
                lockAr.last!.position = CGPoint(x: xPos, y: -self.size.height*1.6/24 - self.size.height/48)
                lockAr.last!.scale(to: CGSize(width: self.size.height*1.5/48,height: self.size.height*1.5/48))
                lockAr.last!.name = "lock"
                lockAr.last!.zPosition = 101.5
                lockAr.last!.alpha = 1.0
                fullButton.addChild(lockAr.last!)
            }
            
            xPos = xPos + xPosInc
            addChild(fullButton)
        }
    }
    
    func DrawButtons() {
        DrawButton(text:"Unlock All Subject Levels",offY:self.size.height*9.5/48,i:1)
        DrawButton(text:"Credits",offY:self.size.height*3.5/48,i:2)
    }
    
    func DrawButton(text: String,offY:CGFloat,i:Int) {
        let myText: NSString = text as NSString
        let sizeText: CGSize = myText.size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 25)])
        let widthText = sizeText.width
        
        let clickButton = SKNode()
        clickButton.position = CGPoint(x: self.size.width/2, y: offY)
        clickButton.zPosition = 100.0
        
        clickButtonShadowAr.append(SKShapeNode(rectOf: CGSize(width: widthText*1.3,height: self.size.height*4/48),cornerRadius: 30.0))
        clickButtonShadowAr.last!.name = "sbshadow"
        clickButtonShadowAr.last!.fillColor = SKColor.black
        clickButtonShadowAr.last!.strokeColor = SKColor.black
        clickButtonShadowAr.last!.position = CGPoint(x:-2.5, y: 2.5)
        clickButton.addChild(clickButtonShadowAr.last!)
        
        clickButtonAr.append(SKShapeNode(rectOf: CGSize(width: widthText*1.3,height: self.size.height*4/48),cornerRadius: 30.0))
        clickButtonAr.last!.name = "clickbutton" + String(i)
        clickButtonAr.last!.fillColor = SKColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        clickButtonAr.last!.strokeColor = SKColor.purple
        clickButtonAr.last!.position = CGPoint(x: 0, y: 0)
        clickButton.addChild(clickButtonAr.last!)
        
        buttonLabelAr.append(SKLabelNode(fontNamed: "Arial"))
        buttonLabelAr.last!.text = text
        buttonLabelAr.last!.name = "labelclickbutton" + String(i)
        buttonLabelAr.last!.fontSize = 25
        buttonLabelAr.last!.fontColor = SKColor(red: 165/255, green: 60/255, blue: 165/255, alpha: 1.0)
        buttonLabelAr.last!.position = CGPoint(x: 0, y: -self.size.height/64)
        buttonLabelAr.last!.zPosition = 100.0
        clickButton.addChild(buttonLabelAr.last!)
        clickButton.addChild(CreateShadowLabel(label: buttonLabelAr.last!,offset: 1))
        addChild(clickButton)
    }
    
    func DrawTitle() {
        let fullTitle = SKNode()
        fullTitle.position = CGPoint(x: self.size.width/2, y: self.size.height*36.5/40)
        fullTitle.zPosition = 100.0
        
        let labelTitle = SKLabelNode(fontNamed: "MarkerFelt-Thin")
        labelTitle.text = "OPTIONS"
        labelTitle.fontSize = 50
        labelTitle.fontColor = SKColor.red
        labelTitle.position = .zero
        labelTitle.zPosition = 100.0
        fullTitle.addChild(labelTitle)
        let labelTitleShadow = CreateShadowLabel(label: labelTitle,offset: 1)
        fullTitle.addChild(labelTitleShadow)
        
        addChild(fullTitle)
    }
    
    func DrawBackButton() {
        let backButton = SKSpriteNode(imageNamed: "BackwardsClean.png")
        backButton.name = "backbutton"
        backButton.position = CGPoint(x: frame.size.width/20, y: self.size.height*19/20)
        backButton.scale(to: CGSize(width: self.size.width/10, height: self.size.width/10))
        addChild(backButton)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        let touchLocation = touch.location(in: self)
        let buttonNode = self.atPoint(touchLocation)
        
        for button in clickButtonShadowAr {
            button.isHidden = false
        }
        
        if buttonNode.name?.contains("optionbutton") != nil && (buttonNode.name?.contains("optionbutton"))!  {
            let ind = String(buttonNode.name!.last!)
            if (buttonNode.name?.contains("optionbutton" + ind))! {
                for child in buttonAr {
                    if child.name?.contains(ind) != nil && (child.name?.contains(ind))! {
                        child.strokeColor = global.lightPink
                    }
                }
                for child in labelAr {
                    if child.name?.contains(ind) != nil && (child.name?.contains(ind))! {
                        child.fontColor = global.lightPink
                    }
                }
                for child in labelShadowAr {
                    if child.name?.contains(ind) != nil && (child.name?.contains(ind))! {
                        child.fontColor = global.lightPink
                        child.isHidden = true
                    }
                }
            }
            
            if let parentNode = buttonNode.parent {
                for child in parentNode.children {
                    if let box = child as? SKShapeNode {
                        box.strokeColor = SKColor.red
                    }
                    if let label = child as? SKLabelNode {
                        if label.name?.contains("optionbutton") != nil && (label.name?.contains("optionbutton"))! {
                            label.fontColor = SKColor.red
                        }
                        else {
                            label.fontColor = SKColor.black
                            label.isHidden = false
                        }
                    }
                }
            }
        }
        
        if buttonNode.name?.contains("clickbutton") != nil && (buttonNode.name?.contains("clickbutton"))!  {
            if let parentNode = buttonNode.parent {
                for child in parentNode.children {
                    if let box = child as? SKShapeNode {
                        if box.name?.contains("sbshadow") != nil && (box.name?.contains("sbshadow"))!  {
                            box.isHidden = true
                        }
                    }
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        let touchLocation = touch.location(in: self)
        let buttonNode = self.atPoint(touchLocation)
        
        for button in clickButtonShadowAr {
            button.isHidden = false
        }
        
        if buttonNode.name?.contains("optionbutton") != nil && (buttonNode.name?.contains("optionbutton"))!  {
            let ind = String(buttonNode.name!.last!)
            if (buttonNode.name?.contains("optionbutton" + ind))! {
                for child in buttonAr {
                    if child.name?.contains(ind) != nil && (child.name?.contains(ind))! {
                        child.strokeColor = global.lightPink
                    }
                }
                for child in labelAr {
                    if child.name?.contains(ind) != nil && (child.name?.contains(ind))! {
                        child.fontColor = global.lightPink
                    }
                }
                for child in labelShadowAr {
                    if child.name?.contains(ind) != nil && (child.name?.contains(ind))! {
                        child.fontColor = global.lightPink
                        child.isHidden = true
                    }
                }
            }
            
            if let parentNode = buttonNode.parent {
                for child in parentNode.children {
                    if let box = child as? SKShapeNode {
                        box.strokeColor = SKColor.red
                    }
                    if let label = child as? SKLabelNode {
                        if label.name?.contains("optionbutton") != nil && (label.name?.contains("optionbutton"))! {
                            label.fontColor = SKColor.red
                        }
                        else {
                            label.fontColor = SKColor.black
                            label.isHidden = false
                        }
                    }
                }
            }
        }
        
        if buttonNode.name?.contains("clickbutton") != nil && (buttonNode.name?.contains("clickbutton"))!  {
            if let parentNode = buttonNode.parent {
                for child in parentNode.children {
                    if let box = child as? SKShapeNode {
                        if box.name?.contains("sbshadow") != nil && (box.name?.contains("sbshadow"))!  {
                            box.isHidden = true
                        }
                    }
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 1 - Choose one of the touches to work with
        guard let touch = touches.first else {
            return
        }
        
        let touchLocation = touch.location(in: self)
        let buttonNode = self.atPoint(touchLocation)
        
        if buttonNode.name?.contains("optionbutton") != nil && (buttonNode.name?.contains("optionbutton"))!  {
            let ind = String(buttonNode.name!.last!)
            if (buttonNode.name?.contains("optionbutton" + ind))! {
                for child in buttonAr {
                    if child.name?.contains(ind) != nil && (child.name?.contains(ind))! {
                        child.strokeColor = global.lightPink
                    }
                }
                for child in labelAr {
                    if child.name?.contains(ind) != nil && (child.name?.contains(ind))! {
                        child.fontColor = global.lightPink
                    }
                }
                for child in labelShadowAr {
                    if child.name?.contains(ind) != nil && (child.name?.contains(ind))! {
                        child.fontColor = global.lightPink
                        child.isHidden = true
                    }
                }
            }
            
            if let parentNode = buttonNode.parent {
                for child in parentNode.children {
                    if let box = child as? SKShapeNode {
                        box.strokeColor = SKColor.red
                    }
                    if let label = child as? SKLabelNode {
                        if label.name?.contains("optionbutton") != nil && (label.name?.contains("optionbutton"))! {
                            label.fontColor = SKColor.red
                        }
                        else {
                            label.fontColor = SKColor.black
                            label.isHidden = false
                        }
                    }
                }
            }
        }
        
        for button in clickButtonShadowAr {
            button.isHidden = false
        }
        
        if buttonNode.name?.contains("backbutton") != nil && (buttonNode.name?.contains("backbutton"))!  {
            TransitionBack()
        }
        
        if buttonNode.name?.contains("clickbutton1") != nil && (buttonNode.name?.contains("clickbutton1"))!  {
            //TransitionSceneStart()
        }
        if buttonNode.name?.contains("clickbutton2") != nil && (buttonNode.name?.contains("clickbutton2"))!  {
            TransitionSceneCredits()
        }
    }
    
    func TransitionSceneCredits()
    {
        for child in global.overlayNode.children {
            child.removeFromParent()
        }
        global.overlayNode.removeFromParent()
        let playSound = SKAction.playSoundFileNamed("QuizRight.wav", waitForCompletion: false)
        let newScene = SKAction.run({
            let reveal = SKTransition.reveal(with:SKTransitionDirection.left, duration:1.0)
            
            let nextScene = CreditsScene(size: self.size,currentSentenceNum:0,correctAnswers:0,incorrectAnswers:0,currentExtraWordNum:0,sceneType:"Credits")
            self.view?.presentScene(nextScene, transition: reveal)
            
        })
        self.run(SKAction.sequence([playSound,newScene]))
    }
    
    func TransitionBack()
    {
        for child in global.overlayNode.children {
            child.removeFromParent()
        }
        global.overlayNode.removeFromParent()
        let playSound = SKAction.playSoundFileNamed("QuizRight.wav", waitForCompletion: false)
        let newScene = SKAction.run({
            let reveal = SKTransition.reveal(with:SKTransitionDirection.left, duration:1.0)
            
            let nextScene = TitleScene(size: self.size,currentSentenceNum:0,correctAnswers:0,incorrectAnswers:0,currentExtraWordNum:0,sceneType:"Title")
            self.view?.presentScene(nextScene, transition: reveal)
            
        })
        self.run(SKAction.sequence([playSound,newScene]))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

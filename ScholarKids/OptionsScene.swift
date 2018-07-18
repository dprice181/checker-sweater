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
        
    var optionsStrings = ["Music":1,"Sound":3,"Correct":5,"Math":7,"Grammar":9,"Vocabulary":11,"Spelling":13]
    
    init(size: CGSize, currentSentenceNum:Int, correctAnswers:Int, incorrectAnswers:Int, currentExtraWordNum:Int,sceneType:String) {
        super.init(size: size)
        
        backgroundColor = SKColor(red: 234/255, green: 230/255, blue: 236/255, alpha: 1)
        CreateOptionsFileIfNecessary()
        ReadOptionsFile()
        DrawTitle()
        DrawOptions()
        DrawBackButton()
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
    
    func IsButtonSelected(text:String,text2:String,i:Int) -> Bool {
        var returnVal = false
        if text == "Music" {
            if global.optionAr[optionsStrings["Music"]!] == String(i) {
                returnVal = true
            }
        }
        if text == "Sound Effects" {
            if global.optionAr[optionsStrings["Sound"]!] == String(i) {
                returnVal = true
            }
        }
        if text == "# Correct To Advance Level" {
            if global.optionAr[optionsStrings["Correct"]!] == String(i) {
                returnVal = true
            }
        }
        if text2 == "Math" {
            if global.optionAr[optionsStrings["Math"]!] == "1" {
                returnVal = true
            }
        }
        if text2 == "Grammar" {
            if global.optionAr[optionsStrings["Grammar"]!] == "1" {
                returnVal = true
            }
        }
        if text2 == "Vocabulary" {
            if global.optionAr[optionsStrings["Vocabulary"]!] == "1" {
                returnVal = true
            }
        }
        if text2 == "Spelling" {
            if global.optionAr[optionsStrings["Spelling"]!] == "1" {
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
        textAr2 = ["Unlocked","Unlocked","Unlocked","Unlocked"]
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
            let unlocked = (lock && isButtonSelected == true)
            var myBoxColorSelected = boxColorSelected
            if unlocked {
                myBoxColorSelected = SKColor.blue
            }
            
            let fullButton = SKNode()
            fullButton.position = CGPoint(x: self.size.width/24, y: self.size.height*42.5/48 + myOffY)
            fullButton.zPosition = 100.0
            
            buttonAr.append(SKShapeNode(rectOf: CGSize(width: self.size.width/6 + extraBoxWidth,height: self.size.height*4/48),cornerRadius: 20.0))
            buttonAr.last!.name = String(i) + "optionbutton" + String(ind)
            buttonAr.last!.fillColor = backgroundColor
            if isButtonSelected {
                buttonAr.last!.strokeColor = myBoxColorSelected
            }
            else {
                buttonAr.last!.strokeColor = boxColor
            }
            buttonAr.last!.lineWidth = 3
            buttonAr.last!.position = CGPoint(x: xPos, y: -self.size.height*1.6/24)
            fullButton.addChild(buttonAr.last!)
            
            labelAr.append(SKLabelNode(fontNamed: "Arial"))
            labelAr.last!.text = textAr1[i]
            labelAr.last!.name = String(i) + "optionbutton" + String(ind)
            labelAr.last!.fontSize = fontSize2
            if isButtonSelected {
                labelAr.last!.fontColor = myBoxColorSelected
            }
            else {
                labelAr.last!.fontColor = boxColor
            }
            labelAr.last!.position = CGPoint(x: xPos, y: -self.size.height*1.6/24 + labOffY)
            labelAr.last!.zPosition = 100.0
            fullButton.addChild(labelAr.last!)
            labelShadowAr.append(CreateShadowLabel(label: labelAr.last!,offset: 1))
            labelShadowAr.last!.name = String(i) + "optionshadow" + String(ind)
            if isButtonSelected == false && lock==false {  //always hightlight the unlock levels
                labelShadowAr.last!.isHidden = true
            }
            fullButton.addChild(labelShadowAr.last!)
            
            if textAr2.count > i {
                labelAr.append(SKLabelNode(fontNamed: "Arial"))
                labelAr.last!.text = textAr2[i]
                labelAr.last!.name = String(i) + "secondoptionbutton" + String(ind)
                labelAr.last!.fontSize = fontSize2
                if isButtonSelected {
                    labelAr.last!.fontColor = myBoxColorSelected
                }
                else {
                    labelAr.last!.fontColor = boxColor
                }
                labelAr.last!.position = CGPoint(x: xPos, y: -self.size.height*1.6/24 - self.size.height/32)
                labelAr.last!.zPosition = 100.0
                fullButton.addChild(labelAr.last!)
                labelShadowAr.append(CreateShadowLabel(label: labelAr.last!,offset: 1))
                labelShadowAr.last!.name = String(i) + "optionshadow" + String(ind)
                if isButtonSelected == false && lock==false {  //always hightlight the unlock levels
                    labelShadowAr.last!.isHidden = true
                }
                fullButton.addChild(labelShadowAr.last!)
                if ind==3 && !unlocked {
                    labelAr.last!.isHidden = true
                    labelShadowAr.last!.isHidden = true
                }
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
            if Int(ind)! < 3 {  //music, sound, #correct
                if (buttonNode.name?.contains("optionbutton" + ind))! {
                    for child in buttonAr {
                        if child.name?.contains("optionbutton" + ind) != nil && (child.name?.contains("optionbutton" + ind))! {
                            child.strokeColor = global.lightPink
                        }
                    }
                    for child in labelAr {
                        if child.name?.contains("optionbutton" + ind) != nil && (child.name?.contains("optionbutton" + ind))! {
                            child.fontColor = global.lightPink
                        }
                    }
                    for child in labelShadowAr {
                        if child.name?.contains("optionshadow" + ind) != nil && (child.name?.contains("optionshadow" + ind))! {
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
            if Int(ind)! < 3 {  //music, sound, #correct
                if (buttonNode.name?.contains("optionbutton" + ind))! {
                    for child in buttonAr {
                        if child.name?.contains("optionbutton" + ind) != nil && (child.name?.contains("optionbutton" + ind))! {
                            child.strokeColor = global.lightPink
                        }
                    }
                    for child in labelAr {
                        if child.name?.contains("optionbutton" + ind) != nil && (child.name?.contains("optionbutton" + ind))! {
                            child.fontColor = global.lightPink
                        }
                    }
                    for child in labelShadowAr {
                        if child.name?.contains("optionshadow" + ind) != nil && (child.name?.contains("optionshadow" + ind))! {
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
            UpdateOptionArray(node:buttonNode)
            
            let ind = String(buttonNode.name!.last!)
            if Int(ind)! < 3 {  //music, sound, #correct
                if (buttonNode.name?.contains("optionbutton" + ind))! {
                    for child in buttonAr {
                        if child.name?.contains("optionbutton" + ind) != nil && (child.name?.contains("optionbutton" + ind))! {
                            child.strokeColor = global.lightPink
                        }
                    }
                    for child in labelAr {
                        if child.name?.contains("optionbutton" + ind) != nil && (child.name?.contains("optionbutton" + ind))! {
                            child.fontColor = global.lightPink
                        }
                    }
                    for child in labelShadowAr {
                        if child.name?.contains("optionshadow" + ind) != nil && (child.name?.contains("optionshadow" + ind))! {
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
                            else {  //shadowlabel
                                label.fontColor = SKColor.black
                                label.isHidden = false
                            }
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
            MessageBox(title:"Unlock All Subjects",message:"Would you like to unlock all subject levels for 2.99?  This will also remove all ads!",cancelButton:true,sectionInd:-1,subject:"all subjects",node:SKNode(),allSubjects:true)
        }
        if buttonNode.name?.contains("clickbutton2") != nil && (buttonNode.name?.contains("clickbutton2"))!  {
            TransitionSceneCredits()
        }
    }
    
    func UpdateOptionArray(node:SKNode) {
        let optionInd = String(node.name!.first!)
        if var sectionInd = Int(String(node.name!.last!)) {
            if sectionInd < 3 {  //music, sound, #correct
                global.optionAr[sectionInd*2+1] = optionInd
            }
            if sectionInd == 3 {  //The unlock levels section
                if let optionIndInt = Int(optionInd) {
                    sectionInd = sectionInd + optionIndInt
                    var subject = "Math"
                    switch optionIndInt {
                    case 0:
                        subject = "Math"
                    case 1:
                        subject = "Grammar"
                    case 2:
                        subject = "Vocabulary"
                    case 3:
                        subject = "Spelling"
                    default:
                        subject = "Math"
                    }
                    if global.optionAr[sectionInd*2+1] == "0" {
                        MessageBox(title:"Unlock " + subject,message:"Would you like to unlock all levels in " + subject + " for 99 cents?  This will also remove all ads!",cancelButton:true,sectionInd:sectionInd,subject:subject,node:node,allSubjects:false)
                    }
                    else {  //already unlocked
                        MessageBox(title:subject + " Already Unlocked",message:subject + " is already unlocked!  Thanks for your previous purchase!",cancelButton:false,sectionInd: -1,subject:subject,node:node,allSubjects:false)
                    }
                }
            }
        }
        
        UpdateOptions()
        WriteOptionsToFile()
    }
    
    func UnlockAllLevels() {
        let ind = "3"  //unlock all levels
        for child in buttonAr {
            if child.name?.contains("optionbutton" + ind) != nil && (child.name?.contains("optionbutton" + ind))! {
                child.strokeColor = SKColor.blue
            }
        }
        for child in labelAr {
            if child.name?.contains("secondoptionbutton" + ind) != nil && (child.name?.contains("secondoptionbutton" + ind))! {
                child.fontColor = SKColor.blue
                child.isHidden = false
            }
            else if child.name?.contains("optionbutton" + ind) != nil && (child.name?.contains("optionbutton" + ind))! {
                child.fontColor = SKColor.blue
            }            
        }
        for child in labelShadowAr {
            if child.name?.contains("optionshadow" + ind) != nil && (child.name?.contains("optionshadow" + ind))! {
                child.fontColor = SKColor.black
                child.isHidden = false
            }
        }
        for child in lockAr {
            child.removeFromParent()
        }
    }
    
    func UnlockLevel(node:SKNode) {
        if let parentNode = node.parent {
            for child in parentNode.children {
                if child.name?.contains("lock") != nil && (child.name?.contains("lock"))! {
                    child.removeFromParent()
                    continue
                }
                if let box = child as? SKShapeNode {
                    box.strokeColor = SKColor.blue
                }
                if let label = child as? SKLabelNode {
                    if label.name?.contains("secondoptionbutton") != nil && (label.name?.contains("secondoptionbutton"))! {
                        label.fontColor = SKColor.blue
                        label.isHidden = false
                    }
                    else if label.name?.contains("optionbutton") != nil && (label.name?.contains("optionbutton"))! {
                        label.fontColor = SKColor.blue
                    }
                    else {  //shadow label
                        label.fontColor = SKColor.black
                        label.isHidden = false
                    }
                }
            }
        }
    }
    
    func MessageBox(title:String,message:String,cancelButton:Bool,sectionInd:Int,subject:String,node:SKNode,allSubjects:Bool)
    {
        let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            if allSubjects {
                global.optionAr[7] = "1"  //Math
                global.optionAr[9] = "1"
                global.optionAr[11] = "1"
                global.optionAr[13] = "1" //Spelling
                self.WriteOptionsToFile()
                self.UnlockAllLevels()
                self.MessageBox(title:"Thank you!",message:"Thank you for your purchase! All levels of " + subject + " are now unlocked and all ads are removed!",cancelButton: false,sectionInd:-1,subject:subject,node:node,allSubjects:false)
            }
            else {
                if sectionInd > 0 {
                    global.optionAr[sectionInd*2+1] = "1"
                    self.WriteOptionsToFile()
                    self.UnlockLevel(node:node)
                    self.MessageBox(title:"Thank you!",message:"Thank you for your purchase! All levels of " + subject + " are now unlocked and all ads are removed!",cancelButton: false,sectionInd:-1,subject:subject,node:node,allSubjects:false)
                }
            }
            
        })
        UpdateOptions()  //put here since we can't access global function form inside lambda
        
        dialogMessage.addAction(ok)
        if cancelButton {
            let cancel = UIAlertAction(title: "Cancel", style: .default) { (action) -> Void in
                print("Cancel button tapped")
            }
            dialogMessage.addAction(cancel)
        }
        topMostController()?.present(dialogMessage, animated: true, completion: nil)
    }
    
    func topMostController() -> UIViewController? {
        var topController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController
        while ((topController?.presentedViewController) != nil) {
            topController = topController?.presentedViewController
        }
        return topController
    }
    
    func TransitionSceneCredits()
    {
        UpdateOptions()
        WriteOptionsToFile()
        
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
        UpdateOptions()
        WriteOptionsToFile()
        
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

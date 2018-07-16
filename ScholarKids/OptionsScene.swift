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
    
    init(size: CGSize, currentSentenceNum:Int, correctAnswers:Int, incorrectAnswers:Int, currentExtraWordNum:Int,sceneType:String) {
        super.init(size: size)
        
        backgroundColor = SKColor(red: 234/255, green: 230/255, blue: 236/255, alpha: 1)
        DrawTitle()
        DrawOptions()
        DrawBackButton()
    }
    
    func DrawOptions() {
        var textAr1 = ["Always","Menus","Always"]
        var textAr2 = ["On","Only","Off"]
        var offY : CGFloat = 0.0
        DrawOption(text:"Music",textAr1:textAr1,textAr2:textAr2,offY:offY,fontSize:25,fontSize2:18,fontColor:global.purple,boxColor:global.lightPink,extraBoxWidth:0,removeAds:false,lock:false)
        
        textAr1 = ["Always","Menus","Always"]
        textAr2 = ["On","Only","Off"]
        offY = -self.size.height*8/48
        DrawOption(text:"Sound Effects",textAr1:textAr1,textAr2:textAr2,offY:offY,fontSize:25,fontSize2:18,fontColor:global.purple,boxColor:global.lightPink,extraBoxWidth:0,removeAds:false,lock:false)
        
        textAr1 = ["0","3","6","9","12"]
        textAr2 = []
        offY = -self.size.height*16/48
        DrawOption(text:"# Correct To Advance Level",textAr1:textAr1,textAr2:textAr2,offY:offY,fontSize:25,fontSize2:30,fontColor:global.purple,boxColor:global.lightPink,extraBoxWidth:0,removeAds:false,lock:false)
        
        textAr1 = ["Math","Grammar","Vocabulary","Spelling"]
        textAr2 = []
        offY = -self.size.height*24/48
        DrawOption(text:"Unlock All Levels",textAr1:textAr1,textAr2:textAr2,offY:offY,fontSize:25,fontSize2:16,fontColor:SKColor.red,boxColor:global.realPurple,extraBoxWidth:self.size.width/24,removeAds:true,lock:true)
        
        DrawButtons()
    }
    
    func DrawOption(text: String,textAr1:[String],textAr2:[String],offY:CGFloat,fontSize:CGFloat,
                    fontSize2:CGFloat,fontColor:SKColor,boxColor:SKColor,extraBoxWidth:CGFloat,
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
            //labOffY = -self.size.height*0.6/24
            labOffY = self.size.height*0.1/24
        }
        
        for i in 0..<textAr1.count {
            let fullButton = SKNode()
            fullButton.position = CGPoint(x: self.size.width/24, y: self.size.height*42/48 + myOffY)
            fullButton.zPosition = 100.0
            
            buttonAr.append(SKShapeNode(rectOf: CGSize(width: self.size.width/6 + extraBoxWidth,height: self.size.height*4/48),cornerRadius: 20.0))
            buttonAr.last!.name = "optionbutton"
            buttonAr.last!.fillColor = backgroundColor
            buttonAr.last!.strokeColor = boxColor
            buttonAr.last!.lineWidth = 3
            buttonAr.last!.position = CGPoint(x: xPos, y: -self.size.height*1.6/24)
            fullButton.addChild(buttonAr.last!)
            
            labelAr.append(SKLabelNode(fontNamed: "Arial"))
            labelAr.last!.text = textAr1[i]
            labelAr.last!.name = "optionbutton"
            labelAr.last!.fontSize = fontSize2
            labelAr.last!.fontColor = boxColor
            labelAr.last!.position = CGPoint(x: xPos, y: -self.size.height*1.6/24 + labOffY)
            labelAr.last!.zPosition = 100.0
            fullButton.addChild(labelAr.last!)
            labelShadowAr.append(CreateShadowLabel(label: labelAr.last!,offset: 1))
            labelShadowAr.last!.name = "optionshadow"
            labelShadowAr.last!.isHidden = true
            fullButton.addChild(labelShadowAr.last!)
            
            if textAr2.count > i {
                labelAr.append(SKLabelNode(fontNamed: "Arial"))
                labelAr.last!.text = textAr2[i]
                labelAr.last!.name = "optionbutton"
                labelAr.last!.fontSize = fontSize2
                labelAr.last!.fontColor = boxColor
                labelAr.last!.position = CGPoint(x: xPos, y: -self.size.height*1.6/24 - self.size.height/32)
                labelAr.last!.zPosition = 100.0
                fullButton.addChild(labelAr.last!)
                labelShadowAr.append(CreateShadowLabel(label: labelAr.last!,offset: 1))
                labelShadowAr.last!.name = "optionshadow"
                labelShadowAr.last!.isHidden = true
                fullButton.addChild(labelShadowAr.last!)
            }
            
            if lock {
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
        DrawButton(text:"Unlock All Subject Levels",offY:self.size.height*7.5/48)
        DrawButton(text:"Credits",offY:self.size.height*2.5/48)
    }
    
    func DrawButton(text: String,offY:CGFloat) {
        let myText: NSString = text as NSString
        let sizeText: CGSize = myText.size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 25)])
        let widthText = sizeText.width
        
        let buttonShadow = SKShapeNode(rectOf: CGSize(width: widthText*1.3,height: self.size.height*4/48),cornerRadius: 30.0)
        buttonShadow.name = "sbshadow"
        buttonShadow.fillColor = SKColor.black
        buttonShadow.strokeColor = SKColor.black
        buttonShadow.position = CGPoint(x: self.size.width/2 - 2.5, y: offY + 2.5)
        addChild(buttonShadow)
        
        let button = SKShapeNode(rectOf: CGSize(width: widthText*1.3,height: self.size.height*4/48),cornerRadius: 30.0)
        button.name = "button"
        button.fillColor = SKColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        button.strokeColor = SKColor.purple
        button.position = CGPoint(x: self.size.width/2, y: offY)
        addChild(button)
        
        let buttonLabel = SKLabelNode(fontNamed: "Arial")
        buttonLabel.text = text
        buttonLabel.name = "buttonlabel"
        buttonLabel.fontSize = 25
        buttonLabel.fontColor = SKColor(red: 165/255, green: 60/255, blue: 165/255, alpha: 1.0)
        buttonLabel.position = CGPoint(x: self.size.width/2, y: offY - self.size.height/64)
        buttonLabel.zPosition = 100.0
        addChild(buttonLabel)
        addChild(CreateShadowLabel(label: buttonLabel,offset: 1))
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
        
        for child in buttonAr {
            child.strokeColor = global.lightPink
        }
        for child in labelAr {
            child.fontColor = global.lightPink
        }
        for child in labelShadowAr {
            child.fontColor = global.lightPink
            child.isHidden = true
        }
        
        if buttonNode.name?.contains("optionbutton") != nil && (buttonNode.name?.contains("optionbutton"))!  {
            if let parentNode = buttonNode.parent {
                for child in parentNode.children {
                    if let box = child as? SKShapeNode {
                        box.strokeColor = SKColor.red
                    }
                    if let box = child as? SKLabelNode {
                        box.fontColor = SKColor.red
                        box.isHidden = false
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
        
        for child in buttonAr {
            child.strokeColor = global.lightPink
        }
        for child in labelAr {
            child.fontColor = global.lightPink
        }
        for child in labelShadowAr {
            child.fontColor = global.lightPink
            child.isHidden = true
        }
        
        if buttonNode.name?.contains("optionbutton") != nil && (buttonNode.name?.contains("optionbutton"))!  {
            if let parentNode = buttonNode.parent {
                for child in parentNode.children {
                    if let box = child as? SKShapeNode {
                        box.strokeColor = SKColor.red
                    }
                    if let label = child as? SKLabelNode {
                        label.fontColor = SKColor.red
                        label.isHidden = false
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
        
        for child in buttonAr {
            child.strokeColor = global.lightPink
        }
        for child in labelAr {
            child.fontColor = global.lightPink
        }
        for child in labelShadowAr {
            child.fontColor = global.lightPink
            child.isHidden = true
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

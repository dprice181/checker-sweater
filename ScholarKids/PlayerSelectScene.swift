//
//  PlayerSelectScene.swift
//  ScholarKids
//
//  Created by Doug Price on 5/25/18.
//  Copyright © 2018 Doug Price. All rights reserved.
//

import SpriteKit
import GameplayKit

class PlayerSelectScene: SKScene {
    
    let SELECTTEXT_FONTSIZE :CGFloat = 18.0
    var nodeDefinitionAr = [SKNode]()
    var playerboxAr = [SKShapeNode]()
    var playerboxShadowAr = [SKShapeNode]()
    var gradeboxAr = [SKShapeNode]()
    var wordAr : [String] = []
    var playerAr : [String] = []
    var nameAr : [String] = []
    var gradeAr : [String] = []
    
    var background = SKSpriteNode(imageNamed: "background3.jpg")
    
    var addName = ""
    var addGrade = ""
    var myPath = ""
    
    let color1 = SKColor(red: 80/255, green: 115/255, blue: 205/255, alpha: 1.0)
    let color2 = SKColor(red: 185/255, green: 80/255, blue: 185/255, alpha: 1.0)
    
    
    
    init(size: CGSize, currentSentenceNum:Int, correctAnswers:Int, incorrectAnswers:Int, currentExtraWordNum:Int,sceneType:String) {
        super.init(size: size)
        
        backgroundColor = SKColor(red: 234/255, green: 230/255, blue: 236/255, alpha: 1)
        
        CreateFile()  //to create the file (cant read until there is a write)
        GetPlayers()
        
        DisplayPlayers()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func topMostController() -> UIViewController? {
        var topController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController
        while ((topController?.presentedViewController) != nil) {
            topController = topController?.presentedViewController
        }
        return topController
    }
    
    func DisplayPlayers()
    {
        let labelTitle = SKLabelNode(fontNamed: "Arial")
        labelTitle.text = "Select Or Create New Student"
        labelTitle.fontSize = 25
        labelTitle.fontColor = global.titleColor
        labelTitle.position = CGPoint(x: self.size.width/2, y: self.size.height*19/24)
        labelTitle.zPosition = 100.0
        addChild(labelTitle)
        addChild(CreateShadowLabel(label: labelTitle,offset: 1))
        
        
        let displayWidth = (size.width * 7.5 / 10) / 2
        
        var i = 0
        for player in playerAr  {
            var playerDataAr = player.characters.split{$0 == "*"}.map(String.init)
            if playerDataAr.count < 1 {
                continue
            }
            let name = playerDataAr[0]
            nameAr.append(name)
            var grade = "0"
            if playerDataAr.count > 1 {
                grade = playerDataAr[1]
            }
            gradeAr.append(grade)
            
            let mySentence: NSString = name as NSString
            let sizeSentence: CGSize = mySentence.size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: SELECTTEXT_FONTSIZE+1.0)])
            let sentenceWidth = sizeSentence.width
            let sentenceHeight = sizeSentence.height
            var numLines = 1
            var countWordsPerLine = 0
            if sentenceWidth > displayWidth {
                numLines = Int(sentenceWidth / displayWidth) + 1
                wordAr = name.characters.split{$0 == " "}.map(String.init)
                if wordAr.count == 1 {  //no spaces
                    let nameCountD2 = name.count / 2
                    wordAr[0] = String(name.dropLast(name.count - nameCountD2))
                    wordAr.append(String(name.dropFirst(nameCountD2)))
                }
                countWordsPerLine = Int(ceil(Double(wordAr.count) / Double(numLines)))
                if countWordsPerLine * (numLines-2) >= wordAr.count {
                    numLines = numLines - 2
                }
                else if countWordsPerLine * (numLines-1) >= wordAr.count {
                    numLines = numLines - 1
                }
            }
            
            
            nodeDefinitionAr.append(SKNode())
            nodeDefinitionAr[i].position = CGPoint(x: self.size.width/2, y: self.size.height*(16-2.2 * CGFloat(i))/24)
            nodeDefinitionAr[i].zPosition = 100.0
            nodeDefinitionAr[i].name = "playerbox" + String(i)
            
            if numLines == 1 {
                let labelDefinition = SKLabelNode(fontNamed: "Arial")
                labelDefinition.text = name
                labelDefinition.fontSize = SELECTTEXT_FONTSIZE+1.0
                labelDefinition.fontColor = color1
                labelDefinition.position = CGPoint(x: -self.size.width/4,y: 0)
                labelDefinition.zPosition = 100.0
                labelDefinition.name = "playerbox" + String(i)
                nodeDefinitionAr[i].addChild(labelDefinition)
                nodeDefinitionAr[i].addChild(CreateShadowLabel(label: labelDefinition,offset: 1))
            }
            else {
                var totalWordsSoFar = 0
                for n in 0...numLines-1  {
                    var defAr = wordAr.dropFirst(totalWordsSoFar)
                    var countWords = countWordsPerLine
                    if n == numLines-1 {
                        countWords = wordAr.count - totalWordsSoFar
                    }
                    else {
                        defAr = defAr.dropLast(wordAr.count - (countWords+totalWordsSoFar))
                    }
                    let definitionLine = defAr.joined(separator: " ")
                    
                    let labelDefinition = SKLabelNode(fontNamed: "Arial")
                    labelDefinition.text = definitionLine
                    labelDefinition.fontSize = SELECTTEXT_FONTSIZE+1.0
                    labelDefinition.fontColor = color1
                    labelDefinition.position = CGPoint(x: -self.size.width/4,y: -sentenceHeight * CGFloat(n))
                    labelDefinition.zPosition = 100.0
                    labelDefinition.name = "playerbox" + String(i)
                    nodeDefinitionAr[i].addChild(labelDefinition)
                    nodeDefinitionAr[i].addChild(CreateShadowLabel(label: labelDefinition,offset: 1))
                    totalWordsSoFar = totalWordsSoFar + countWords
                }
            }
            playerboxShadowAr.append(SKShapeNode(rectOf: CGSize(width: self.size.width-32,height: self.size.height*4/48),cornerRadius:30.0))
            playerboxShadowAr[i].name = "shadowbox" + String(i)
            playerboxShadowAr[i].fillColor = SKColor.black
            playerboxShadowAr[i].strokeColor = SKColor.black
            playerboxShadowAr[i].position = CGPoint(x:-1.5,y:1.5)
            nodeDefinitionAr[i].addChild(playerboxShadowAr[i])
            
            playerboxAr.append(SKShapeNode(rectOf: CGSize(width: self.size.width-32,height: self.size.height*4/48),cornerRadius:30.0))
            playerboxAr[i].name = "playerbox" + String(i)
            playerboxAr[i].fillColor = SKColor(red: 225/255, green: 235/255, blue: 235/255, alpha: 1)
            playerboxAr[i].strokeColor = SKColor.blue
            playerboxAr[i].position = .zero
            nodeDefinitionAr[i].addChild(playerboxAr[i])
            
            gradeboxAr.append(SKShapeNode(rectOf: CGSize(width: size.width/5,height: self.size.height*4/48-2)))
            gradeboxAr[i].name = "playerboxgrade" + String(i)
            gradeboxAr[i].fillColor = SKColor(red: 225/255, green: 245/255, blue: 225/255, alpha: 1)
            gradeboxAr[i].strokeColor = SKColor(red: 185/255, green: 80/255, blue: 185/255, alpha: 1.0)
            gradeboxAr[i].position = CGPoint(x:self.size.width/32,y:0)
            gradeboxAr[i].zPosition = 101.0
            nodeDefinitionAr[i].addChild(gradeboxAr[i])
            
            let labelGrade = SKLabelNode(fontNamed: "Arial")
            labelGrade.text = "Grade: " + grade
            labelGrade.fontSize = SELECTTEXT_FONTSIZE-1.0
            labelGrade.fontColor = color1
            labelGrade.position = CGPoint(x: self.size.width/32,y:0)
            labelGrade.zPosition = 102.0
            labelGrade.name = "playerboxgrade" + String(i)
            nodeDefinitionAr[i].addChild(labelGrade)
            nodeDefinitionAr[i].addChild(CreateShadowLabel(label: labelGrade,offset: 1))
            
            let progressbox = SKShapeNode(rectOf: CGSize(width: size.width/5,height: self.size.height*4/48))
            progressbox.name = "progressbox" + String(i)
            progressbox.fillColor = SKColor(red: 225/255, green: 225/255, blue: 255/255, alpha: 1)
            progressbox.strokeColor = SKColor.blue
            progressbox.position = CGPoint(x:self.size.width/32+self.size.width/5,y:0)
            progressbox.zPosition = 101.0
            nodeDefinitionAr[i].addChild(progressbox)
            
            let labelProgress = SKLabelNode(fontNamed: "Arial")
            labelProgress.text = "Progress"
            labelProgress.fontSize = 15
            labelProgress.fontColor = color2
            labelProgress.position = CGPoint(x: self.size.width/32+self.size.width/5,y:0)
            labelProgress.zPosition = 102.0
            labelProgress.name = "labelprogress" + String(i)
            nodeDefinitionAr[i].addChild(labelProgress)
            nodeDefinitionAr[i].addChild(CreateShadowLabel(label: labelProgress,offset: 1))
            
            let mySentence2: NSString = "Progress" as NSString
            let sizeSentence2: CGSize = mySentence2.size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 15)])
            let sentenceHeight2 = sizeSentence2.height
            let labelProgress2 = SKLabelNode(fontNamed: "Arial")
            labelProgress2.text = "Report"
            labelProgress2.fontSize = 15
            labelProgress2.fontColor = color2
            labelProgress2.position = CGPoint(x: self.size.width/32+self.size.width/5,y:-sentenceHeight2)
            labelProgress2.zPosition = 102.0
            labelProgress2.name = "labelprogress" + String(i)
            nodeDefinitionAr[i].addChild(labelProgress2)
            nodeDefinitionAr[i].addChild(CreateShadowLabel(label: labelProgress2,offset: 1))
            
            let deletebox = SKShapeNode(rectOf: CGSize(width: (size.width-32)/2,height: self.size.height*4/48-2),cornerRadius:30)
            deletebox.name = "deletebox" + String(i)
            deletebox.fillColor = SKColor.red
            deletebox.strokeColor = SKColor.red
            deletebox.position = CGPoint(x:(self.size.width-32)/4,y:0)
            deletebox.zPosition = 100.0
            nodeDefinitionAr[i].addChild(deletebox)
            
            let deleteLabel = SKLabelNode(fontNamed: "Arial")
            deleteLabel.text = "X"
            deleteLabel.fontSize = 30
            deleteLabel.fontColor = SKColor.white
            deleteLabel.position = CGPoint(x: self.size.width*25/64,y:-self.size.height/64)
            deleteLabel.zPosition = 102.0
            deleteLabel.name = "deletebox" + String(i)
            nodeDefinitionAr[i].addChild(deleteLabel)
            nodeDefinitionAr[i].addChild(CreateShadowLabel(label: deleteLabel,offset: 1))
            
            addChild(nodeDefinitionAr[i])
            i = i + 1
        }
        
        if i < 5 {
            let name = "New Student"
            nodeDefinitionAr.append(SKNode())
            nodeDefinitionAr[i].position = CGPoint(x: self.size.width/2, y: self.size.height*(16-2.2 * CGFloat(i))/24)
            nodeDefinitionAr[i].zPosition = 100.0
            nodeDefinitionAr[i].name = "playerbox" + String(i)
            
            let greenPlus = SKSpriteNode(imageNamed: "GreenPlus.png")
            greenPlus.position = CGPoint(x: -self.size.width/3,y:0)
            greenPlus.scale(to: CGSize(width: self.size.height*3/48,height: self.size.height*3/48))
            nodeDefinitionAr[i].addChild(greenPlus)
            
            let labelDefinition = SKLabelNode(fontNamed: "Arial")
            labelDefinition.text = name
            labelDefinition.fontSize = SELECTTEXT_FONTSIZE+1.0
            labelDefinition.fontColor = color1
            labelDefinition.position = CGPoint(x: 0,y: 0)
            labelDefinition.zPosition = 100.0
            labelDefinition.name = "playerbox" + String(i)
            nodeDefinitionAr[i].addChild(labelDefinition)
            nodeDefinitionAr[i].addChild(CreateShadowLabel(label: labelDefinition,offset: 1))
            
            playerboxShadowAr.append(SKShapeNode(rectOf: CGSize(width: self.size.width-32,height: self.size.height*4/48),cornerRadius:30.0))
            playerboxShadowAr[i].name = "shadowbox" + String(i)
            playerboxShadowAr[i].fillColor = SKColor.black
            playerboxShadowAr[i].strokeColor = SKColor.black
            playerboxShadowAr[i].position = CGPoint(x:-1.5,y:1.5)
            nodeDefinitionAr[i].addChild(playerboxShadowAr[i])
            
            playerboxAr.append(SKShapeNode(rectOf: CGSize(width: self.size.width-32,height: self.size.height*4/48),cornerRadius:30.0))
            playerboxAr[i].name = "playerbox" + String(i)
            playerboxAr[i].fillColor = SKColor(red: 225/255, green: 235/255, blue: 235/255, alpha: 1)
            playerboxAr[i].strokeColor = SKColor.blue
            playerboxAr[i].position = .zero
            nodeDefinitionAr[i].addChild(playerboxAr[i])
            addChild(nodeDefinitionAr[i])
        }
        
        background.position = CGPoint(x: frame.size.width / 2, y: self.size.width/5)
        background.scale(to: CGSize(width: self.size.width*1.1, height: self.size.width/2.4))
        addChild(background)
        
        let backButton = SKSpriteNode(imageNamed: "BackwardsClean.png")
        backButton.name = "backbutton"
        backButton.position = CGPoint(x: frame.size.width/20, y: self.size.height*18.5/20)
        backButton.scale(to: CGSize(width: self.size.width/10, height: self.size.width/10))
        addChild(backButton)
    }
    
    func DeleteDataArrays() {
        nodeDefinitionAr.removeAll()
        playerboxAr.removeAll()
        playerboxShadowAr.removeAll()
        gradeboxAr.removeAll()
        wordAr.removeAll()
        playerAr.removeAll()
        nameAr.removeAll()
        gradeAr.removeAll()
    }
    
    func RemoveDialog(studentIndex: Int)
    {
        let playSound = SKAction.playSoundFileNamed("QuizWrong.wav", waitForCompletion: false)
        self.run(SKAction.sequence([playSound]))
        
        let dialogMessage = UIAlertController(title: "Remove Student", message: "Are you sure you want to remove this student?", preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (action) -> Void in
            print("Cancel button tapped")
        }
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            self.RemoveStudent(studentIndex:studentIndex)
        })
        
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        topMostController()?.present(dialogMessage, animated: true, completion: nil)
    }
    
    func GetStudentName()
    {
        var nameTextField: UITextField?
        var gradeTextField: UITextField?
        
        let dialogMessage = UIAlertController(title: "Add Student", message: "Enter your name and grade", preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (action) -> Void in
            print("Cancel button tapped")
        }
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            
            if let nameInput = nameTextField?.text {
                self.addName = String(nameInput.prefix(26))
            }
            if let gradeInput = gradeTextField?.text {
                if let addGradeInt = Int(gradeInput) {
                    if addGradeInt < 1 || addGradeInt > 12 {
                      self.addGrade = "K"
                    }
                    else  {
                        self.addGrade = gradeInput
                    }
                }
                else {
                    self.addGrade = "K"
                }
            }
            self.WriteNewPlayer()
        })
        
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        
        dialogMessage.addTextField { (textField) -> Void in
            nameTextField = textField
            nameTextField?.placeholder = "Name"
        }
        
        dialogMessage.addTextField { (textField) -> Void in
            gradeTextField = textField
            gradeTextField?.placeholder = "Grade"
        }
        
        topMostController()?.present(dialogMessage, animated: true, completion: nil)
    }
    
    func RemoveStudent(studentIndex: Int)
    {
        let file = "Players.txt" //this is the file. we will write to and read from it
        if let dir = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true).first {
            let path = dir + "/" + file
            do {
                var fileText = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
                var lineAr = fileText.components(separatedBy: .newlines)
                if lineAr.count > 0 {
                    for i in 0..<lineAr.count {
                        if i == studentIndex {
                           lineAr.remove(at: i)
                        }
                    }
                    fileText = lineAr.joined(separator: "\n")
                    try! fileText.write(toFile: path, atomically: false, encoding: String.Encoding.utf8)

                    self.removeAllChildren()
                    DeleteDataArrays()
                    GetPlayers()
                    DisplayPlayers()
                }
            }
            catch {
                print("File read error:", error)
            }
        }
    }
    
    func CreateFile()
    {
        let file = "Players.txt" //this is the file. we will write to and read from it
        if let dir = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true).first {
            let path = dir + "/" + file
            do {
                let fileText2 = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
            }
            catch {
                print("File read error:", error)
                let fileText = ""
                try! fileText.write(toFile: path, atomically: false, encoding: String.Encoding.utf8)
            }
        }
    }
    
    func WriteNewPlayer()
    {
        let file = "Players.txt" //this is the file. we will write to and read from it
        if let dir = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true).first {
            let path = dir + "/" + file
            do {
                var fileText = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
                if addName.count < 1 {  //name was empty so add a name
                    let dataAr = fileText.components(separatedBy: .newlines)
                    addName = "Student " + String(dataAr.count)
                }
                let text = addName + "*" + addGrade + "*-1*-1*-1*-1"
                fileText.append("\n"+text)
                try! fileText.write(toFile: path, atomically: false, encoding: String.Encoding.utf8)

                //refresh the players
                self.removeAllChildren()
                DeleteDataArrays()
                GetPlayers()
                DisplayPlayers()
            }
            catch {
                print("File read error:", error)
            }
        }
    }
    
    func GetPlayers()
    {
        let file = "Players.txt" //this is the file. we will write to and read from it
        if let dir = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true).first {
            let path = dir + "/" + file
            do {
                let fileText = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
                playerAr = fileText.components(separatedBy: .newlines)
                var i = 0
                for player in playerAr {
                    if player == "" {
                        playerAr.remove(at: i)
                    }
                    i = i + 1
                }
            }
            catch {
                print("File read error:", error)
            }
        }
    }
    
    func AddPlayer()
    {
        let playSound = SKAction.playSoundFileNamed("QuizRight.wav", waitForCompletion: false)
        self.run(SKAction.sequence([playSound]))
        GetStudentName()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        let touchLocation = touch.location(in: self)
        let touchedNode = self.atPoint(touchLocation)
        
        for node in nodeDefinitionAr {
            for child in node.children {
                if let box = child as? SKShapeNode {
                    if box != touchedNode && box.name?.contains("playerboxgrade") != nil && (box.name?.contains("playerboxgrade"))!{
                        box.fillColor = SKColor(red: 225/255, green: 245/255, blue: 225/255, alpha: 1)
                    }
                    else if box != touchedNode && box.name?.contains("playerbox") != nil && (box.name?.contains("playerbox"))!{
                        box.fillColor = SKColor(red: 225/255, green: 235/255, blue: 235/255, alpha: 1)
                    }
                }
            }
        }
        
        if let shapeNode = touchedNode as? SKNode {
            if shapeNode.name?.contains("playerbox") != nil && (shapeNode.name?.contains("playerbox"))!  {
                if let parentNode = shapeNode.parent {
                    for child in parentNode.children {
                        if let box = child as? SKShapeNode {
                            if box.name?.contains("playerbox") != nil && (box.name?.contains("playerbox"))! {
                                box.fillColor = SKColor.red
                            }
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
        let touchedNode = self.atPoint(touchLocation)
        
        for node in nodeDefinitionAr {
            for child in node.children {
                if let box = child as? SKShapeNode {
                    if box != touchedNode && box.name?.contains("playerboxgrade") != nil && (box.name?.contains("playerboxgrade"))!{
                        box.fillColor = SKColor(red: 225/255, green: 245/255, blue: 225/255, alpha: 1)
                    }
                    else if box != touchedNode && box.name?.contains("playerbox") != nil && (box.name?.contains("playerbox"))!{
                        box.fillColor = SKColor(red: 225/255, green: 235/255, blue: 235/255, alpha: 1)
                    }
                }
            }
        }
        
        if let shapeNode = touchedNode as? SKNode {
            if shapeNode.name?.contains("playerbox") != nil && (shapeNode.name?.contains("playerbox"))!  {
                if let parentNode = shapeNode.parent {
                    for child in parentNode.children {
                        if let box = child as? SKShapeNode {
                            if box.name?.contains("playerbox") != nil && (box.name?.contains("playerbox"))! {
                                box.fillColor = SKColor.red
                            }
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
        let touchedNode = self.atPoint(touchLocation)
        
        for node in nodeDefinitionAr {
            for child in node.children {
                if let box = child as? SKShapeNode {
                    if box.name?.contains("playerboxgrade") != nil && (box.name?.contains("playerboxgrade"))!{
                        box.fillColor = SKColor(red: 225/255, green: 245/255, blue: 225/255, alpha: 1)
                    }
                    else if box.name?.contains("playerbox") != nil && (box.name?.contains("playerbox"))!{
                        box.fillColor = SKColor(red: 225/255, green: 235/255, blue: 235/255, alpha: 1)
                    }
                }
            }
        }
        
        if let shapeNode = touchedNode as? SKNode {
            if shapeNode.name?.contains("playerbox") != nil && (shapeNode.name?.contains("playerbox"))!  {
                if let ind = shapeNode.name?.last {
                    let strInd : String = String(ind)
                    if let ind2 : Int = Int(strInd) {
                        if ind2 >= playerAr.count {
                            AddPlayer()
                        }
                        else {
                            if nameAr.count > ind2 {
                                global.currentStudent = nameAr[ind2]
                            }
                            if gradeAr.count > ind2 {
                                global.currentGrade = gradeAr[ind2]
                            }
                            TransitionScene()
                        }
                    }
                }
            }
            if shapeNode.name?.contains("progress") != nil && (shapeNode.name?.contains("progress"))!  {
                if let ind = shapeNode.name?.last {
                    let strInd : String = String(ind)
                    if let ind2 : Int = Int(strInd) {
                        if ind2 < playerAr.count {
                            if nameAr.count > ind2 {
                                global.currentStudent = nameAr[ind2]
                            }
                            if gradeAr.count > ind2 {
                                global.currentGrade = gradeAr[ind2]
                            }
                            OpenProgressReport()
                        }
                    }
                }                
            }
            if shapeNode.name?.contains("deletebox") != nil && (shapeNode.name?.contains("deletebox"))!  {
                if let ind = shapeNode.name?.last {
                    let strInd : String = String(ind)
                    if let ind2 : Int = Int(strInd) {
                        RemoveDialog(studentIndex: ind2+1)
                    }
                }
            }
            if shapeNode.name?.contains("backbutton") != nil && (shapeNode.name?.contains("backbutton"))!  {
                TransitionBack()
            }            
        }
    }
    
    func OpenProgressReport() {
        let playSound = SKAction.playSoundFileNamed("QuizRight.wav", waitForCompletion: false)
        let newScene = SKAction.run({
            let reveal = SKTransition.reveal(with:SKTransitionDirection.left, duration:1.0)
            
            let nextScene = ProgressReportScene(size: self.size,currentSentenceNum:0,correctAnswers:0,incorrectAnswers:0,currentExtraWordNum:0,sceneType:"ProgressReport")
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
    
    func TransitionScene()
    {
        let playSound = SKAction.playSoundFileNamed("QuizRight.wav", waitForCompletion: false)
        let newScene = SKAction.run({
            let reveal = SKTransition.reveal(with:SKTransitionDirection.left, duration:1.0)
            
        let nextScene = LevelSelectScene(size: self.size,currentSentenceNum:0,correctAnswers:0,incorrectAnswers:0,currentExtraWordNum:0,sceneType:"LevelSelect")
        self.view?.presentScene(nextScene, transition: reveal)
 
        })
        self.run(SKAction.sequence([playSound,newScene]))
    }
}


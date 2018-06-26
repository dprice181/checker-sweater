//
//  VocabularyConnect.swift
//  
//
//  Created by Doug Price on 6/26/18.
//

import SpriteKit
import GameplayKit


class VocabularyConnectScene: SKScene {
    
    var buttonBackground : SKShapeNode = SKShapeNode()
    var startButtonShadow : SKShapeNode = SKShapeNode()
    var startButton : SKShapeNode = SKShapeNode()
    var optionsButtonShadow : SKShapeNode = SKShapeNode()
    var optionsButton : SKShapeNode = SKShapeNode()
    var startButtonLabel = SKLabelNode()
    var optionsButtonLabel = SKLabelNode()
    var background = SKSpriteNode(imageNamed: "background3.jpg")
    
    var labelTitle = SKLabelNode()
    var labelTitleShadow = SKLabelNode()
    var labelSubtitle = SKLabelNode()
    var labelSubtitleShadow = SKLabelNode()
    let text1 = ["S", "c", "h", "o", "l", "a", "r"]
    let text2 = ["K", "i", "d", "s"]
    var titleLabelText = ""
    var subtitleLabelText = ""
    var calls : Int = 0
    var timer : Timer!
    
    init(size: CGSize, currentSentenceNum:Int, correctAnswers:Int, incorrectAnswers:Int, currentExtraWordNum:Int,sceneType:String) {
        super.init(size: size)
        physicsWorld.gravity = .zero
        
        backgroundColor = SKColor(red: 234/255, green: 230/255, blue: 236/255, alpha: 1)

//
//  VocabularyConnect.swift
//  
//
//  Created by Doug Price on 6/26/18.
//

import SpriteKit
import GameplayKit


class VocabularyConnectScene: SKScene {
    

    var background = SKSpriteNode(imageNamed: "background3.jpg")
    
    init(size: CGSize, currentSentenceNum:Int, correctAnswers:Int, incorrectAnswers:Int, currentExtraWordNum:Int,sceneType:String) {
        super.init(size: size)
        physicsWorld.gravity = .zero
        
        backgroundColor = SKColor(red: 234/255, green: 230/255, blue: 236/255, alpha: 1)

        background.position = CGPoint(x: frame.size.width * 5 / 6, y: frame.size.height / 6)
        background.scale(to: CGSize(width: self.size.width/3, height: self.size.height/3))
        addChild(background)
        
        let backButton = SKSpriteNode(imageNamed: "BackwardsClean.png")
        backButton.name = "backbutton"
        backButton.position = CGPoint(x: frame.size.width/20, y: self.size.height*18.5/20)
        backButton.scale(to: CGSize(width: self.size.width/10, height: self.size.width/10))
        addChild(backButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 1 - Choose one of the touches to work with
        guard let touch = touches.first else {
            return
        }
        
        let touchLocation = touch.location(in: self)
        let touchedNode = self.atPoint(touchLocation)
        
        if let shapeNode = touchedNode as? SKNode {
            if shapeNode.name?.contains("backbutton") != nil && (shapeNode.name?.contains("backbutton"))!  {
                TransitionBackFromScene(myScene: self)
            }
        }
    }
}

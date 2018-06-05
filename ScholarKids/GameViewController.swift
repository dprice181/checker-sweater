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

class Global {
    var currentStudent = ""
    var currentGrade = ""
    var currentLevel = 1
    var view : SKView?
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

class GameViewController: UIViewController, SKViewDelegate {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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

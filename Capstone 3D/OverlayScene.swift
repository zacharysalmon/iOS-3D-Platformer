//
//  OverlayScene.swift
//  Capstone 3D
//
//  Created by Zack Salmon on 8/3/20.
//  Copyright © 2020 Zack Salmon. All rights reserved.


import UIKit
import SpriteKit
import SceneKit

class OverlayScene: SKScene
{
	
    var pause_node: SKSpriteNode!
    var score_node: SKLabelNode!
	var game_scene: GameViewController!
	var countdown_node: SKLabelNode!
	
	
	/*
		This variable shows on the screen the number in the countdown.
	*/
	var countdown = 3
	{
		didSet
		{
			self.countdown_node.text = "\(self.countdown)"
		}
	}
	
	/*
		This variable stores the score of the player and displays it to the screen.
	*/
    var score = 0
	{
        didSet
		{
            self.score_node.text = "Score: \(self.score)"
        }
    }
	
	/*
		Initializes the overlay that goes over the game view controller.
		@param size the size of the screen in height and width of the device that's being used.
		@param game_scene the GameViewController object that this overlay gets displayed over.
	*/
    init(size: CGSize, game_scene: GameViewController!)
	{
        super.init(size: size)
		self.game_scene = game_scene
        
		let spriteSize = CGSize(width: 50.0, height: 50.0)
		self.pause_node = SKSpriteNode(imageNamed: "pause_button")
        self.pause_node.size = spriteSize
		self.pause_node.position = CGPoint(x: size.width - spriteSize.width, y: spriteSize.height)
        
        self.score_node = SKLabelNode(text: "Score: 0")
        self.score_node.fontName = "Georgia-Bold"
		self.score_node.fontColor = UIColor.black
        self.score_node.fontSize = 30
		let score_node_position = CGPoint(x: size.width / 2, y: size.height * 0.8)
		self.score_node.position = score_node_position
		
		self.countdown_node = SKLabelNode(text: "3")
		self.countdown_node.fontName = "Georgia-Bold"
		self.countdown_node.fontColor = UIColor.black
		self.countdown_node.fontSize = 50
		let countdown_node_position = CGPoint(x: size.width / 2, y: size.height / 2)
		self.countdown_node.position = countdown_node_position
		
		
        self.addChild(self.pause_node)
        self.addChild(self.score_node)
		self.addChild(self.countdown_node)
		
    }
	
	/*
		This is a required initialized for SKScene children. This doesn't get used.
	*/
    required init?(coder aDecoder: NSCoder)
	{
        super.init(coder: aDecoder)
    }
	
	/*
		This function takes all of the touches that happen on the screen, locates them, and if they
		are in certain bounds, does something with them.
		If the game isn't paused, it uses the game_scene object to pause everything.
	*/
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
	{
		let location = touches.first?.location(in: self)
		if pause_node.contains(location!)
		{
			if !isPaused
			{
				game_scene.pauseWorld()
			}
		}
	}
	
	/*
		This function compares the previous score to the current high score, and determines if the
		previous score should be the new high score. 
	*/
	func setHighScore()
	{
		UserDefaults.standard.setValue(self.score, forKey: "last_score")
		if UserDefaults.standard.value(forKey: "high_score") != nil
		{
			let old_high_score: Int = UserDefaults.standard.value(forKey: "high_score") as! Int
			if old_high_score < self.score
			{
				UserDefaults.standard.setValue(self.score, forKey: "high_score")
			}
		}
		else
		{
			UserDefaults.standard.setValue(self.score, forKey: "high_score")
		}
	}
	
}

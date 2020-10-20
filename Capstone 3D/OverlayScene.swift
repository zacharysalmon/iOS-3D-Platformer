//
//  OverlayScene.swift
//  HitTheTree
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
	var jump_node: SKSpriteNode!
//	var play_again_node: SKSpriteNode!
//	var game_over_node: SKLabelNode!


	//size of the screen is (x: 414.0, y: 896.0)
	//(375, 667)
//	let pause_node_position = CGPoint(x: 350.0, y: 50.0)
//	let play_node_position = CGPoint(x: 207.0, y: 448.0)
//	let play_again_node_position = CGPoint(x: 207.0, y: 700.0)
//	let score_node_position = CGPoint(x: 207.0, y: 750.0)
//	let countdown_node_position = CGPoint(x: 207.0, y: 448.0)
	
	var countdown = 3
	{
		didSet
		{
			self.countdown_node.text = "\(self.countdown)"
		}
	}
    
    var score = 0
	{
        didSet
		{
            self.score_node.text = "Score: \(self.score)"
//			self.game_over_node.text = "Game Over"
        }
    }
    
    init(size: CGSize, game_scene: GameViewController!) {
        super.init(size: size)
		print("size_h: \(size.height), size_w: \(size.width)")
		self.game_scene = game_scene
//		self.backgroundColor = UIColor.red
        
		let spriteSize = CGSize(width: 50.0, height: 50.0)
		self.pause_node = SKSpriteNode(imageNamed: "pause_button")
        self.pause_node.size = spriteSize
		self.pause_node.position = CGPoint(x: size.width - spriteSize.width, y: spriteSize.height)
		
//		self.jump_node = SKSpriteNode(imageNamed: "jump_node")
//		self.jump_node.size = CGSize(width: spriteSize.width * 2, height: spriteSize.height)
//		self.jump_node.position = CGPoint(x: jump_node.size.width, y: spriteSize.height * 2)
		
//		self.play_again_node = SKSpriteNode(imageNamed: "play_again_button")
//		self.play_again_node.size = CGSize(width: spriteSize * 4, height: spriteSize)
//		self.play_again_node.position = play_again_node_position
//		self.play_again_node.isUserInteractionEnabled = false
//		self.play_again_node.isHidden = true
        
        self.score_node = SKLabelNode(text: "Score: 0")
        self.score_node.fontName = "Georgia-Bold"
		self.score_node.fontColor = UIColor.black
        self.score_node.fontSize = 30
		let score_node_position = CGPoint(x: size.width / 2, y: size.height * 0.8)
		self.score_node.position = score_node_position
		
//		self.game_over_node = SKLabelNode(text: "Game Over")
//        self.game_over_node.fontName = "Georgia-Bold"
//		self.game_over_node.fontColor = UIColor.black
//        self.game_over_node.fontSize = 40
//		self.game_over_node.position = CGPoint(x: size.width / 2, y: size.height / 2)
//		self.game_over_node.isHidden = true
		
		self.countdown_node = SKLabelNode(text: "3")
		self.countdown_node.fontName = "Georgia-Bold"
		self.countdown_node.fontColor = UIColor.black
		self.countdown_node.fontSize = 50
		let countdown_node_position = CGPoint(x: size.width / 2, y: size.height / 2)
		self.countdown_node.position = countdown_node_position
		
		
        self.addChild(self.pause_node)
//		self.addChild(self.jump_node)
		
//		self.addChild(self.game_over_node)
//		self.addChild(self.play_again_node)
        self.addChild(self.score_node)
		self.addChild(self.countdown_node)
		
    }
    
    required init?(coder aDecoder: NSCoder)
	{
        super.init(coder: aDecoder)
    }
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
	{
		let location = touches.first?.location(in: self)
//		print(play_again_node.contains(location!), play_again_node.isUserInteractionEnabled)
		if pause_node.contains(location!)
		{
			if !isPaused
			{
//				countdown_node.isHidden = false
				game_scene.pauseWorld()
//				isPaused = true
//				pause_node.texture = SKTexture(imageNamed: "play_button")
//				pause_node.position = play_node_position
			}
//			else
//			{
//				isPaused = false
//				pause_node.position = pause_node_position
//				pause_node.texture = SKTexture(imageNamed: "pause_button")
//				game_scene.unpauseWorld()
//			}
		}
//		else if play_again_node.contains(location!) && play_again_node.isUserInteractionEnabled
//		{
//			print("Resetting")
//			self.game_over_node.isHidden = true
//			self.play_again_node.isHidden = true
//			self.play_again_node.isUserInteractionEnabled = false
//			self.pause_node.isHidden = false
//			self.score_node.position = score_node_position
//			game_scene.resetGame()
//		}
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
	{
//		let location = touches.first?.location(in: self)
//		if jump_node.contains(location!)
//		{
//			print("Overlay")
//			if !isPaused
//			{
//				game_scene.player.jumpPlayer()
//			}
//		}
	}
	
	func setHighScore()
	{
		UserDefaults.standard.setValue(self.score, forKey: "last_score")
		if UserDefaults.standard.value(forKey: "high_score") != nil
		{
			let old_high_score: Int = UserDefaults.standard.value(forKey: "high_score") as! Int
//			print(old_high_score)
			if old_high_score < self.score
			{
				UserDefaults.standard.setValue(self.score, forKey: "high_score")
				print("New_high_score \(String(describing: UserDefaults.standard.value(forKey: "high_score")))")
			}
		}
		else
		{
			UserDefaults.standard.setValue(self.score, forKey: "high_score")
		}
	}
	
	func gameOverText()
	{
//		self.game_over_node.isHidden = false
//		self.play_again_node.isHidden = false
//		self.play_again_node.isUserInteractionEnabled = true
//		self.pause_node.isHidden = true
//		self.game_over_node.position.y = score_node.position.y + game_over_node.fontSize
	}
	
	
}

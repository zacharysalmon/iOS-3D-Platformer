//
//  player.swift
//  Capstone 3D
//
//  Created by Zack Salmon on 10/13/20.
//  Copyright © 2020 Zachary Salmon. All rights reserved.
//

import Foundation
import UIKit
import SceneKit

class Player
{
	
	private let STARTING_PLAYER_SPEED: Float = 1.3
	private let MAX_PLAYER_SPEED: Float = 3.3
	private let PLAYER_SPEED_DELTA: CGFloat = 0.0011
	private let PLAYER_JUMP_HEIGHT: Float = 5.0
	
	private var player_node: SCNNode!
	private var selfie_stick_node: SCNNode!
//	private var cam_1: SCNNode!
	
	private var player_position: SCNVector3 = SCNVector3(0.0, 0.0, 0.0)
	private var player_velocity: SCNVector3? = SCNVector3(0.0, 0.0, 0.0)
	private var player_speed: Float
	private var player_coins: Int
	private var has_jumped: Bool
	
	init(player_node: SCNNode!, selfie_stick_node: SCNNode!)
	{
		self.player_node = player_node
		self.selfie_stick_node = selfie_stick_node
		self.player_position = SCNVector3(0.0, 0.0, 0.0)
		self.player_velocity = SCNVector3(0.0, 0.0, 0.0)
		self.player_speed = 1.3
		self.player_coins = 0
		
		self.has_jumped = false
	}

//____________________________________________________________________________________
	//Accessors
	
	func getPlayerNode() -> SCNNode
	{
		return self.player_node
	}
	
	func getPlayerPosition() -> SCNVector3
	{
		return self.player_position
	}
	
	func getPlayerVelocity() -> SCNVector3
	{
		return self.player_velocity!
	}
	
	func getPlayerSpeed() -> Float
	{
		return self.player_speed
	}
	
	func getPlayerCoins() -> Int
	{
		return self.player_coins
	}
	
	func getStartingPlayerSpeed() -> Float
	{
		return self.STARTING_PLAYER_SPEED
	}
	
	func getMaxPlayerSpeed() -> Float
	{
		return self.MAX_PLAYER_SPEED
	}
	
	func getPlayerSpeedDelta() -> CGFloat
	{
		return self.PLAYER_SPEED_DELTA
	}
	
	func getPlayerJumpHeight() -> Float
	{
		return self.PLAYER_JUMP_HEIGHT
	}
	
//____________________________________________________________________________________
	//Mutators
	
	func setPlayerCoins(coins: Int)
	{
		self.player_coins = coins
	}
	
	func setPlayerSpeed(speed: Float)
	{
		self.player_speed = speed
	}
	
	func setPlayerVelocity(velocity: SCNVector3)
	{
		self.player_velocity = velocity
		self.player_node.physicsBody?.velocity = velocity
	}
	
	func setPlayerPosition(position: SCNVector3)
	{
		self.player_position = position
		self.player_node.position = position
	}
//____________________________________________________________________________________
	//Methods
	
	func jumpPlayer()
	{
		if !self.has_jumped
		{
			self.has_jumped = true
			
			self.player_node.physicsBody?.applyForce(SCNVector3(0.0, PLAYER_JUMP_HEIGHT, 0.0), asImpulse: true)
			
			let wait_duration = 1.2
			let wait_action = SCNAction.wait(duration: wait_duration)
			
			let jump_action = SCNAction.run
			{
				(_) in
				self.has_jumped = false
//				print("Jump allowed now")
			}
			
			let action_sequence = SCNAction.sequence([wait_action, jump_action])
			
//			print("Jumping")
			self.player_node.runAction(action_sequence)
		}
		
	}
	
	func movePlayer()
	{
		let move_forward = SCNAction.moveBy(x: 0.0, y: 0.0, z: CGFloat(-self.player_speed), duration: 0.0001)
		player_node.runAction(move_forward)
		
		self.setPlayerPosition(position: player_node.position)
		self.setPlayerPosition(position: self.player_position)
		self.setPlayerVelocity(velocity: player_node.physicsBody!.velocity)
		moveCamera()
	}
	
	func moveCamera()
	{
		selfie_stick_node.position = player_node.position
	}
}

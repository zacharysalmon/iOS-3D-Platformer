//
//  Coins.swift
//  Capstone 3D
//
//  Created by Zack Salmon on 10/14/20.
//  Copyright © 2020 Zachary Salmon. All rights reserved.
//

import Foundation
import UIKit
import SceneKit

//struct coinColor
//{
//	var color: String
//}

class Coin
{
//	private var yellow_coin_node: SCNNode!
//	private var red_coin_node: SCNNode!
//	private var yellow_coins: SCNNode!
//	private var red_coins: SCNNode!
	private var coin_node: SCNNode!

	private var coin_color: String

	init(coin_node: SCNNode!, coin_color: String)
	{
//		self.yellow_coin_node = yellow_coin_node
//		self.red_coin_node = red_coin_node
//		self.yellow_coins = yellow_coins
//		self.red_coins = red_coins
		self.coin_node = coin_node
		self.coin_color = coin_color
	}
	
//____________________________________________________________________________________
		//Accessors
	
	func getCoinNode() -> SCNNode
	{
		return self.coin_node
	}
	
	func getCoinColor() -> String
	{
		return self.coin_color
	}
	
//____________________________________________________________________________________
	//Mutators
	
	func setCoinColor(coin_color: String)
	{
		self.coin_color = coin_color
	}

//____________________________________________________________________________________
	//Mutators
//
//	func placeCoins(yellow_coins: SCNNode, red_coins: SCNNode, track: Track)
//	{
//		while yellow_coins.childNodes.count < 5
//		{
//			let yellow_clone = Coin(coin_node: self.coin_node.clone(), coin_color: "yellow")
//			yellow_coins.addChildNode(yellow_clone.getCoinNode())
//		}
//		print("yellow: \(yellow_coins.childNodes.count)")
//
//		if red_coins.childNodes.count < 1
//		{
//			print("Adding red coin")
//			let red_clone = Coin(coin_node: self.coin_node.clone(), coin_color: "red")
//			red_coins.addChildNode(red_clone.getCoinNode())
//		}
//		print("red: \(red_coins.childNodes.count)")
//
//
////		print("yellow_count: \(yellow_coins.childNodes.count)")
////		print("red_count: \(red_coins.childNodes.count)")
//
//		for each in yellow_coins.childNodes
//		{
//			each.position = getCoinPositionVector(track: track)
//		}
//
//		for each in red_coins.childNodes
//		{
//			each.position = getCoinPositionVector(track: track)
//		}
//	}
	
//	public func getCoinPositionVector(track: Track) -> SCNVector3
//	{
//		let random_x = CGFloat.random(in: -17.0 ... 17.0)
//		let random_y = CGFloat(3.0)
////		let random_z = CGFloat.random(in: (CGFloat(next_track_position_z + track_length + obstacle_distance_buffer)) ... (CGFloat(next_track_position_z + (track_length * 2) - obstacle_distance_buffer)))
//	let random_z = CGFloat.random(in: (CGFloat(track.getNextTrackPositionZ() + track.getTrackLength() + track.getObstacleDistanceBuffer())) ... (CGFloat(track.getNextTrackPositionZ() + (track.getTrackLength() * 2) - track.getObstacleDistanceBuffer())))
//		return SCNVector3(random_x, random_y, random_z)
//	}
}

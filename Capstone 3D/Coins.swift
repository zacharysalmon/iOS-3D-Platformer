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

struct coinColor
{
	var color: String
}

class Coin
{
	private var yellow_coin_node: SCNNode!
	private var red_coin_node: SCNNode!
	private var yellow_coins: SCNNode!
	private var red_coins: SCNNode!

	private var coin_color: coinColor

	init(yellow_coin_node: SCNNode!, red_coin_node: SCNNode!, yellow_coins: SCNNode!, red_coins: SCNNode!, coin_color: coinColor)
	{
		self.yellow_coin_node = yellow_coin_node
		self.red_coin_node = red_coin_node
		self.yellow_coins = yellow_coins
		self.red_coins = red_coins
		self.coin_color = coin_color
	}

	func placeCoins()
	{
		while yellow_coins.childNodes.count < 5
		{
			yellow_coins.addChildNode(yellow_coin_node.clone())
		}
//		print(yellow_coins.childNodes)

		if red_coins.childNodes.count < 1
		{
			print("Adding red coin")
			red_coins.addChildNode(red_coin_node.clone())
		}
//		print(red_coins.childNodes)


		print("yellow_count: \(yellow_coins.childNodes.count)")
		print("red_count: \(red_coins.childNodes.count)")
//
//		for each in yellow_coins.childNodes
//		{
//			let random_x = CGFloat.random(in: -17.0 ... 17.0)
//			let random_y = CGFloat(3.0)
//			let random_z = CGFloat.random(in: (CGFloat(track.getNextTrackPositionZ() + track.getTrackLength() + track.getObstacleDistanceBuffer())) ... (CGFloat(track.getNextTrackPositionZ() + (track.getTrackLength() * 2) - track.getObstacleDistanceBuffer())))
//			each.position = SCNVector3(random_x, random_y, random_z)
//		}
//
//		for each in red_coins.childNodes
//		{
//			let random_x = CGFloat.random(in: -17.0 ... 17.0)
//			let random_y = CGFloat(7.0)
//			let random_z = CGFloat.random(in: (CGFloat(track.getNextTrackPositionZ() + track.getTrackLength() + track.getObstacleDistanceBuffer())) ... (CGFloat(track.getNextTrackPositionZ() + (track.getTrackLength() * 2) - track.getObstacleDistanceBuffer())))
//			each.position = SCNVector3(random_x, random_y, random_z)
//		}
	}
}

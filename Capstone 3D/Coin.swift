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


class Coin
{
	private var coin_node: SCNNode!

	private var coin_color: String
	
	/*
		Initializer for a coin object.
		@param coin_node the node that is associated with the coin object.
		@param coin_color the color of the given coin.
	*/
	init(coin_node: SCNNode!, coin_color: String)
	{
		self.coin_node = coin_node
		self.coin_color = coin_color
	}
	
//____________________________________________________________________________________
		//Accessors
	
	/*
		Returns the node of the coin it was called on.
	*/
	func getCoinNode() -> SCNNode
	{
		return self.coin_node
	}
	
	/*
		Returns the color of the coin it was called on.
	*/
	func getCoinColor() -> String
	{
		return self.coin_color
	}
	
//____________________________________________________________________________________
	//Mutators
	
	/*
		Sets the color of the coin that this is called on.
	*/
	func setCoinColor(coin_color: String)
	{
		self.coin_color = coin_color
	}
	
}

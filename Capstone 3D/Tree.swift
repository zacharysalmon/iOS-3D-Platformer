//
//  Tree.swift
//  Capstone 3D
//
//  Created by Zack Salmon on 11/9/20.
//  Copyright © 2020 Zachary Salmon. All rights reserved.
//

import Foundation
import UIKit
import SceneKit


class Tree
{
	private var tree_node: SCNNode!

	
	/*
		Initializer for the tree object
		@param tree_node the node associated with the tree object.
	*/
	init(tree_node: SCNNode!)
	{
		self.tree_node = tree_node
	}
	
//____________________________________________________________________________________
		//Accessors
	
	/*
		Returns the node of the tree object this method is called on. 
	*/
	func getTreeNode() -> SCNNode
	{
		return self.tree_node
	}
	
//____________________________________________________________________________________
	//Mutators
	
	
}


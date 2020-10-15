//
//  VectorOperations.swift
//  HitTheTree
//
//  Created by Zack Salmon on 7/10/20.
//  Copyright © 2020 Zack Salmon. All rights reserved.
//

import Foundation
import SceneKit

func +(left: SCNVector3, right: SCNVector3) -> SCNVector3
{
	return SCNVector3(x: left.x + right.x, y: left.y + right.y, z: left.z + right.z)
}

func +=(left: inout SCNVector3, right: SCNVector3)
{
	left = left + right
}

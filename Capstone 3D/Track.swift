//
//  Track.swift
//  Capstone 3D
//
//  Created by Zack Salmon on 10/13/20.
//  Copyright © 2020 Zachary Salmon. All rights reserved.
//

import Foundation
import UIKit
import SceneKit

class Track
{
	private let STARTING_TRACK_POSITION_Z: Float = 0.0
	private let STARTING_TRACK_LENGTH: Float = 530.0
	private let MAX_TRACK_LENGTH: Float = 560.0
	private let FLOOR_DEPTH: Float = -30.0
	private let OBSTACLE_DISTANCE_BUFFER: Float = 80.0

	private var floor: SCNNode!
	private var track: SCNNode!

	private var track_length: Float
	private var next_track_position_z: Float

	init(track: SCNNode!, floor: SCNNode!)
	{
		self.track = track
		self.floor = floor
		self.track_length = 530.0
		self.next_track_position_z = -1060.0
	}

//____________________________________________________________________________________
	//Accessors

	func getTrack() -> SCNNode
	{
		return self.track
	}

	func getFloor() -> SCNNode
	{
		return self.floor
	}

	func getTrackLength() -> Float
	{
		return self.track_length
	}

	func getNextTrackPositionZ() -> Float
	{
		return self.next_track_position_z
	}

	func getStartingTrackPositionZ() -> Float
	{
		return self.STARTING_TRACK_POSITION_Z
	}

	func getStartingTrackLength() -> Float
	{
		return self.STARTING_TRACK_LENGTH
	}

	func getMaxTrackLength() -> Float
	{
		return self.MAX_TRACK_LENGTH
	}

	func getFloorDepth() -> Float
	{
		return self.FLOOR_DEPTH
	}

	func getObstacleDistanceBuffer() -> Float
	{
		return self.OBSTACLE_DISTANCE_BUFFER
	}

//____________________________________________________________________________________
	//Mutators

	func setTrackLength(track_length: Float)
	{
		self.track_length = track_length
	}

	func setNextTrackPositionZ(next_track_position_z: Float)
	{
		self.next_track_position_z = next_track_position_z
	}

//____________________________________________________________________________________
	//Methods

	func loopTrack(track_layer: SCNNode)
	{
		let old_track: SCNNode! = track_layer.childNodes.first
//		print(old_track.position.z)
		
		let new_track: SCNNode! = old_track.clone()
		new_track.position = SCNVector3(0.0, 0.0, next_track_position_z)
		next_track_position_z -= track_length
//		print(new_track.position.z)
		
		old_track.removeFromParentNode()
		track_layer.addChildNode(new_track)
//		print(track_layer.childNodes.count)
		

//		for each in track_layer.childNodes
//		{
//			print("pos: \(each.position.z)")
//		}
//		print("next: \(next_track_position_z)")
	}

}

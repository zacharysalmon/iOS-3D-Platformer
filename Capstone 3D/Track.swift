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
	
	/*
		Initializes a Track object with a track node and a floor node.
		@param track the node that is tied to the track node in the scene that the player slides on.
		@param floor the node that is tied to the floor node in the scene that signals game over
		from falling.
	
	*/
	init(track: SCNNode!, floor: SCNNode!)
	{
		self.track = track
		self.floor = floor
		self.track_length = 530.0
		self.next_track_position_z = -track_length * 2
	}

//____________________________________________________________________________________
	//Accessors
	
	/*
		Returns the track node.
	*/
	func getTrack() -> SCNNode
	{
		return self.track
	}
	
	/*
		Returns the floor node.
	*/
	func getFloor() -> SCNNode
	{
		return self.floor
	}
	
	/*
		Returns the length of the track.
	*/
	func getTrackLength() -> Float
	{
		return self.track_length
	}
	
	/*
		Returns the z coordinate of the next track position.
	*/
	func getNextTrackPositionZ() -> Float
	{
		return self.next_track_position_z
	}
	
	/*
		Returns the z coordinate of the starting track position.
	*/
	func getStartingTrackPositionZ() -> Float
	{
		return self.STARTING_TRACK_POSITION_Z
	}
	
	/*
		Returns the length of the track at the start of the game.
	*/
	func getStartingTrackLength() -> Float
	{
		return self.STARTING_TRACK_LENGTH
	}
	
	/*
		Returns the maximum allowed length of the track.
	*/
	func getMaxTrackLength() -> Float
	{
		return self.MAX_TRACK_LENGTH
	}
	
	/*
		Returns the y coordinate of the floor.
	*/
	func getFloorDepth() -> Float
	{
		return self.FLOOR_DEPTH
	}
	
	/*
		Returns the buffer distance between obstacles on tracks.
	*/
	func getObstacleDistanceBuffer() -> Float
	{
		return self.OBSTACLE_DISTANCE_BUFFER
	}

//____________________________________________________________________________________
	//Mutators

	
	/*
		Changes the length of the track.
	*/
	func setTrackLength(track_length: Float)
	{
		self.track_length = track_length
	}
	
	/*
		Changes the z coordinate of the next track position.
	*/
	func setNextTrackPositionZ(next_track_position_z: Float)
	{
		self.next_track_position_z = next_track_position_z
	}

//____________________________________________________________________________________
	//Methods
	
	
	/*
		Deinitializes memory allocated for the track geometry.
	*/
	deinit
	{
		self.track.geometry = nil
	}

	
	/*
		Loops the track of a given track layer.
		@param track_layer the track layer that needs to be looped.
	*/
	func loopTrack(track_layer: SCNNode)
	{
		let old_track: SCNNode! = track_layer.childNodes.first
		
		let new_track: SCNNode! = old_track.clone()
		new_track.position = SCNVector3(0.0, 0.0, next_track_position_z)
		next_track_position_z -= track_length
		
		old_track.removeFromParentNode()
		track_layer.addChildNode(new_track)
	}

}

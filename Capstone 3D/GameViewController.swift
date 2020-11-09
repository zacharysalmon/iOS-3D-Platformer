//
//  GameViewController.swift
//  Capstone 3D
//
//  Created by Zack Salmon on 7/8/20.
//  Copyright © 2020 Zack Salmon. All rights reserved.
//

import UIKit
import SceneKit
import AVFoundation //Audio Foundation
import CoreData
import CloudKit

class GameViewController: UIViewController
{
	@IBOutlet weak var sceneView: SCNView!
	var scene: SCNScene!
	var sprite_scene: OverlayScene!
	var pause_menu: PauseMenu!

	var player: Player!
	var database: Database!
	
	var track: Track!
	var track_layer: SCNNode!
	
	var yellow_coin: Coin!
	var yellow_coins_1: SCNNode!
	var yellow_coins_2: SCNNode!
	var yellow_coin_node: SCNNode!
	
	var red_coin: Coin!
	var red_coins_1: SCNNode!
	var red_coins_2: SCNNode!
	var red_coin_node: SCNNode!
	
	var tree_node: Tree!
	var obstacle_layer_1: SCNNode!
	var obstacle_layer_2: SCNNode!
	
	//Various numbers used in calculations and constant positions.
	let STARTING_POINT: SCNVector3 =  SCNVector3(0.0, 0.5, 0.0)
	let MAX_NUMBER_OF_TREES: Int = 20
	let COIN_MINIMUM_HIT_TIME: Double = 0.001
	var coin_timer_start = Date.timeIntervalSinceReferenceDate
	var tree_timer_start = Date.timeIntervalSinceReferenceDate
	var jump_count = 0
	var number_of_trees: Int = 10
	var number_of_coins: Int = 5
	
	// Bit masks for each of the categories of objects that are involved in collisions.
	var category_player: Int = 1
	var category_static: Int = 2
	var category_hidden: Int = 4
	
	// Array to keep track of what is currently being collided with the player.
	var collisions_array: [String: Bool] = ["game_over" : false,
									  "jump_sensor" : false,
									  "clear_sensor" : false]
	
	var is_paused: Bool = true
	var start_of_game: Bool = true
	
//__________________________________________________________________________________________________
	
	/*
		This function loads the view after checking the bounds for the iOS device screen.
	*/
	override func loadView()
	{
	   let scnView = SCNView(frame: UIScreen.main.bounds, options: nil)
	   self.view = scnView
	 }
	
	/*
		This function sets up the scene that renders the graphics, the nodes within the world scene,
		and any sounds associated with the gameplay.
	*/
    override func viewDidLoad()
	{
		super.viewDidLoad()
		setupScene()
		setupNodes()
		setupSounds()
    }
	
	/*
		This function puts the player in its position and starts the countdown for the game to
		begin.
	*/
	override func viewDidAppear(_ animated: Bool)
	{
		player.setPlayerPosition(position: player.getPlayerPosition())
		player.getPlayerNode().physicsBody?.velocity = player.getPlayerVelocity()
		startCountdown()
	}
	
	
	/*
		This function sets up the sceneView and the delegate for the physicsWorld to allow
		interactions to take place.
		It sets up the required touch mechanics such as swiping and instantiates the overlay
		scene.
	*/
	func setupScene()
	{
		sceneView = (self.view as! SCNView)
		sceneView.delegate = self
		
		scene = SCNScene(named: "art.scnassets/MainScene.scn")
		sceneView.scene = scene
		
		scene.physicsWorld.contactDelegate = self
		
		self.sprite_scene = OverlayScene(size: self.view.bounds.size, game_scene: self)
		self.sceneView.overlaySKScene = self.sprite_scene
		
		
		let swipe_recognizer = UIPanGestureRecognizer()
		swipe_recognizer.minimumNumberOfTouches = 1
		swipe_recognizer.addTarget(self, action: #selector(GameViewController.sceneViewPanned(recognizer:)))
		sceneView.addGestureRecognizer(swipe_recognizer)
		
		sceneView.preferredFramesPerSecond = 60
		
	}
	
	/*
		This function sets up and ties all nodes to their objects. The nodes are pulled from the
		already established scene and get applied to their respective objects.
	*/
	func setupNodes()
	{
		player = Player(player_node: scene.rootNode.childNode(withName: "player", recursively: true)!, selfie_stick_node: scene.rootNode.childNode(withName: "selfie_stick", recursively: true)!)
		
		
		database = Database()
		
		track_layer = scene.rootNode.childNode(withName: "track_layer", recursively: true)!
		track = Track(track: scene.rootNode.childNode(withName: "track", recursively: true)!, floor: scene.rootNode.childNode(withName: "floor", recursively: true)!)
		
		obstacle_layer_1 = scene.rootNode.childNode(withName: "obstacle_layer_1", recursively: true)!
		obstacle_layer_2 = scene.rootNode.childNode(withName: "obstacle_layer_2", recursively: true)!
		tree_node = Tree(tree_node: scene.rootNode.childNode(withName: "tree", recursively: true)!)
		for i in 0...number_of_trees
		{
			obstacle_layer_1.insertChildNode(tree_node.getTreeNode().clone(), at: i)
			obstacle_layer_2.insertChildNode(tree_node.getTreeNode().clone(), at: i)
		}
		placeObstacles()
		loopObstacles()
		
		yellow_coins_1 = scene.rootNode.childNode(withName: "yellow_coins_1", recursively: true)!
		yellow_coins_2 = scene.rootNode.childNode(withName: "yellow_coins_2", recursively: true)!
		yellow_coin_node = scene.rootNode.childNode(withName: "yellow_coin", recursively: true)!
		yellow_coin = Coin(coin_node: yellow_coin_node, coin_color: "yellow")
		
		red_coins_1 = scene.rootNode.childNode(withName: "red_coins_1", recursively: true)!
		red_coins_2 = scene.rootNode.childNode(withName: "red_coins_2", recursively: true)!
		red_coin_node = scene.rootNode.childNode(withName: "red_coin", recursively: true)!
		red_coin = Coin(coin_node: red_coin_node, coin_color: "red")
		
		placeCoins()
		loopCoins()
		
	}
	
	/*
		This function sets up the sounds for the game. There are no sound effects, but it does
		allow for other sounds that can run in the background be played while the app is running.
	*/
	func setupSounds()
	{
		// Let's the user listen to outside audio while the app is playing.
		try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient)
		try? AVAudioSession.sharedInstance().setActive(true)
	}
	
	
	/*
		This function allows for pan gestures to be recognized and move the player character.
	*/
	@objc func sceneViewPanned(recognizer: UIPanGestureRecognizer)
	{
		if !is_paused
		{
			let location = recognizer.velocity(in: sceneView)
			if location.y < -700.0
			{
				player.jumpPlayer()
			}
			else
			{
				// Applying Force makes it so the player still falls if it's in the air and the screen is being Panned.
				//x is left to right, y is up and down, z is forward and backward
				player.getPlayerNode().physicsBody?.applyForce(SCNVector3(location.x * player.getPlayerSpeedDelta(), 0.0, 0.0), asImpulse: true)
			}
		}
	}
	
	
	/*
		This function starts and runs the countdown at the beginning of the game.
	*/
	func startCountdown()
	{
		if start_of_game
		{
			repeat
			{
				sleep(1)
				self.sprite_scene.countdown -= 1
			} while sprite_scene.countdown > 0
			self.sprite_scene.countdown_node.isHidden = true
			self.sprite_scene.countdown = 3
			start_of_game = false
		}
		unpauseWorld()
	}
	
	
	/*
		All collisions that need to be handled go through this function. Each significant object
		that collides with the player has a specific event occur that gets triggered first in this
		function.
	*/
	func collisionHandler(player: SCNNode, object: SCNNode)
	{
		if object.physicsBody?.categoryBitMask == category_static && !is_paused
		{
			if object.name == "tree" && collisions_array["game_over"] == false
			{
				object.categoryBitMask = -1
				gameOver()
			}
			
		}
	
		if object.physicsBody?.categoryBitMask == category_hidden
		{
			if object.name == "finish_sensor"
			{
				player.physicsBody?.applyForce(SCNVector3(0, 0, 0), asImpulse: true)
				player.position = STARTING_POINT
			}
			else if object.name == "floor" && collisions_array["game_over"] == false && !is_paused
			{
				gameOver()
			}
			else if object.name == "yellow_coin"
			{
				object.parent?.removeFromParentNode()
				yellowCoinHit()
			}
			else if object.name == "red_coin"
			{
				object.parent?.removeFromParentNode()
				redCoinHit()
			}
		}
	}
	
	
	/*
		This function updates the collisions array so that each object that is currently being in
		contact with the player character is being noted and updated.
	*/
	func updateCollisions(object: SCNNode)
	{
		collisions_array[object.name!] = true
		if collisions_array["jump_sensor"] == true && collisions_array["clear_sensor"] == true
		{
			updateScore()
			track.loopTrack(track_layer: track_layer)
			loopObstacles()
			loopCoins()
		}
		
		for each in collisions_array
		{
			if each.key != object.name
			{
				collisions_array[each.key] = false
			}
		}
	}

	
	/*
		This function runs when a yellow coin gets hit and applies the appropriate score to the
		player.
	*/
	func yellowCoinHit()
	{
		let coin_timer_end = NSDate.timeIntervalSinceReferenceDate
		let coin_time_elapsed = coin_timer_end - self.coin_timer_start
		if coin_time_elapsed > COIN_MINIMUM_HIT_TIME
		{
			self.sprite_scene.score += 1
			self.player.setPlayerCoins(coins: self.player.getPlayerCoins() + 1)
		}
		self.coin_timer_start = NSDate.timeIntervalSinceReferenceDate
	}
	
	/*
		This function runs when a red coin gets hit and applies the appropriate score to the player.
	*/
	func redCoinHit()
	{
		let coin_timer_end = NSDate.timeIntervalSinceReferenceDate
		let coin_time_elapsed = coin_timer_end - self.coin_timer_start
		if coin_time_elapsed > COIN_MINIMUM_HIT_TIME
		{
			self.sprite_scene.score += 5
			self.player.setPlayerCoins(coins: self.player.getPlayerCoins() + 5)
		}
		self.coin_timer_start = NSDate.timeIntervalSinceReferenceDate
	}
	
	/*
		This function updates the score in the overlay and keeps track of how many different tracks
		get jumped.
	*/
	func updateScore()
	{
		self.sprite_scene.score += 2
		jump_count += 1
		if jump_count % 3 == 0
		{
			updateLevel()
		}
	}
	
	/*
		This function gets a random position for each obstacle and changes the angle of it if
		it is on one of the walls of the track.
	*/
	func placeObstacles()
	{
		let TRACK_WIDTH: Float = 19.0
		let SIDE_TREE_ANGLE: Float = 0.45
		let TRACK_HEIGHT_OFFSET: Float = 6.0
		for each in obstacle_layer_1.childNodes
		{
			each.eulerAngles = SCNVector3(0.0, 0.0, 0.0)
			var random_position = getTreePositionVector()
			if random_position.x > TRACK_WIDTH
			{
				//right side
				each.eulerAngles.z = SIDE_TREE_ANGLE
				random_position.y = random_position.x.magnitude / TRACK_HEIGHT_OFFSET
			}
			else if random_position.x < -TRACK_WIDTH
			{
				//left side
				each.eulerAngles.z = -SIDE_TREE_ANGLE
				random_position.y = random_position.x.magnitude / TRACK_HEIGHT_OFFSET
			}
		
			each.position = random_position
			
		}
	}
	
	
	/*
		This function updates the position of each obstacle so they are ready and in position
		on the next track the player gets to.
	*/
	func loopObstacles()
	{
		let TRACK_WIDTH: Float = 19.0
		let SIDE_TREE_ANGLE: Float = 0.45
		let TRACK_HEIGHT_OFFSET: Float = 6.0
		var next_looping_layer: SCNNode
		if jump_count % 2 == 0
		{
			next_looping_layer = obstacle_layer_2
		}
		else
		{
			next_looping_layer = obstacle_layer_1
		}
		for each in next_looping_layer.childNodes
		{
			each.eulerAngles = SCNVector3(0.0, 0.0, 0.0)
			var random_position = getTreePositionVector()
			random_position.z -= track.getTrackLength()
			if random_position.x > TRACK_WIDTH
			{
				//right side
				each.eulerAngles.z = SIDE_TREE_ANGLE
				random_position.y = random_position.x.magnitude / TRACK_HEIGHT_OFFSET
			}
			else if random_position.x < -TRACK_WIDTH
			{
				//left side
				each.eulerAngles.z = -SIDE_TREE_ANGLE
				random_position.y = random_position.x.magnitude / TRACK_HEIGHT_OFFSET
			}
			each.position = random_position
		}
	}
	
	
	/*
		This function selects randomized locations and puts them into a single vector that is the
		new position of the respective tree.
		@return the vector location of the respective tree
	*/
	func getTreePositionVector() -> SCNVector3
	{
		let random_x = CGFloat.random(in: -25.0 ... 25.0)
		let random_y = CGFloat(0.0)
		let random_z = CGFloat.random(in: (CGFloat(track.getNextTrackPositionZ() + track.getTrackLength() + track.getObstacleDistanceBuffer())) ... (CGFloat(track.getNextTrackPositionZ() + (track.getTrackLength() * 2) - track.getObstacleDistanceBuffer())))
		return SCNVector3(random_x, random_y, random_z)
	}
	
	
	/*
		Places the coins in a random location within the limits of the track.
	*/
	func placeCoins()
	{
		while yellow_coins_1.childNodes.count < number_of_coins
		{
			let yellow_clone_1 = Coin(coin_node: yellow_coin_node.clone(), coin_color: "yellow")
			yellow_coins_1.addChildNode(yellow_clone_1.getCoinNode())
		}

		if red_coins_1.childNodes.count < 1
		{
			let red_clone_1 = Coin(coin_node: red_coin_node.clone(), coin_color: "red")
			red_coins_1.addChildNode(red_clone_1.getCoinNode())
		}

		for each in yellow_coins_1.childNodes
		{
			each.position = getCoinPositionVector(coin: yellow_coin)
		}

		for each in red_coins_1.childNodes
		{
			each.position = getCoinPositionVector(coin: red_coin)
		}
	}
	
	/*
		Loops the coins around to the next track so the coins are visible to the player before they
		get on the next track.
	*/
	func loopCoins()
	{
		var next_yellow: SCNNode
		var next_red: SCNNode
		if jump_count % 2 == 0
		{
			next_yellow = yellow_coins_2
			next_red = red_coins_2
		}
		else
		{
			next_yellow = yellow_coins_1
			next_red = red_coins_1
		}
		
		while next_yellow.childNodes.count < number_of_coins
		{
			let yellow_clone_1 = Coin(coin_node: yellow_coin_node.clone(), coin_color: "yellow")
			next_yellow.addChildNode(yellow_clone_1.getCoinNode())
		}
		
		if next_red.childNodes.count < 1
		{
			let red_clone_1 = Coin(coin_node: red_coin_node.clone(), coin_color: "red")
			next_red.addChildNode(red_clone_1.getCoinNode())
		}
		
		for each in next_yellow.childNodes
		{
			each.position = getCoinPositionVector(coin: yellow_coin)
			each.position.z -= track.getTrackLength()
		}
		
		for each in next_red.childNodes
		{
			each.position = getCoinPositionVector(coin: red_coin)
			each.position.z -= track.getTrackLength()
		}
	}
	
	/*
		This function takes in a coin and gives it a vector location for it to appear next.
		@return the vector position of the next coin to appear
	*/
	func getCoinPositionVector(coin: Coin) -> SCNVector3
	{
		let TRACK_WIDTH: CGFloat = 17.0
		let COIN_HEIGHT: CGFloat = 3.0
		let RED_COIN_HEIGHT: CGFloat = 7.0
		let random_x = CGFloat.random(in: -TRACK_WIDTH ... TRACK_WIDTH)
		var random_y = COIN_HEIGHT
		if coin.getCoinColor() == "red"
		{
			random_y = RED_COIN_HEIGHT
		}
		let random_z = CGFloat.random(in: (CGFloat(track.getNextTrackPositionZ() + track.getTrackLength() + track.getObstacleDistanceBuffer())) ... (CGFloat(track.getNextTrackPositionZ() + (track.getTrackLength() * 2) - track.getObstacleDistanceBuffer())))
		return SCNVector3(random_x, random_y, random_z)
	}
	
	/*
		This function updates the game difficulty after progressing past certain points.
	*/
	func updateLevel()
	{
		if player.getPlayerSpeed() < player.getMaxPlayerSpeed()
		{
			let player_speed_increment: Float = 0.20
			player.setPlayerSpeed(speed: player.getPlayerSpeed() + player_speed_increment)
		}
		if track.getTrackLength() < track.getMaxTrackLength()
		{
			track.setTrackLength(track_length: track.getTrackLength() + 30)
			track.setNextTrackPositionZ(next_track_position_z: track.getNextTrackPositionZ() - 10)
		}
		if obstacle_layer_1.childNodes.count <= MAX_NUMBER_OF_TREES
		{
			obstacle_layer_1.addChildNode(tree_node.getTreeNode().clone())
		}
	}
	
	/*
		This function is called when the game over is triggered. It sees if the score is the
		new high score and saves the game data to the database.
	*/
	func gameOver()
	{
		let tree_timer_end = NSDate.timeIntervalSinceReferenceDate
		let tree_time_elapsed = tree_timer_end - tree_timer_start
		tree_timer_start = NSDate.timeIntervalSinceReferenceDate
		if tree_time_elapsed > 1.0
		{
			collisions_array["game_over"] = true
			self.player.getPlayerNode().removeFromParentNode()
			sprite_scene.setHighScore()
			database.saveToCloud(score: self.sprite_scene.score, player: player)
			
			openGameOverMenu()
		}
	}
	
	/*
		This function unpauses everything in the world.
	*/
	func unpauseWorld()
	{
		if is_paused
		{
			is_paused = false
			player.getPlayerNode().isPaused = false
		}
	}
	
	/*
		This functino pauses everything in the world and opens the pause menu.
	*/
	func pauseWorld()
	{
		if !is_paused
		{
			is_paused = true
			player.getPlayerNode().isPaused = true
			openPauseMenu()
		}
	}
	
	
	/*
		This function changes the view to the pause menu storyboard.
	*/
	func openPauseMenu()
	{
		let scnStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
		guard let pause_menu = scnStoryboard.instantiateViewController(withIdentifier: "PauseMenu") as? PauseMenu else
		{
			print("Couldn't find the PauseMenu view controller")
			return
		}
		pause_menu.modalTransitionStyle = .crossDissolve
		present(pause_menu, animated: true, completion: nil)
	}
	
	/*
		This function changes the view to the game over storyboard.
	*/
	func openGameOverMenu()
	{
		DispatchQueue.main.async
		{
			let game_over_menu = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "GameOverMenu") as? GameOverMenu 
			if game_over_menu != nil
			{
				game_over_menu?.modalTransitionStyle = .crossDissolve
				self.present(game_over_menu!, animated: true, completion: nil)
			}
		}
		
	}
	
	/*
		This variable indicates the status bar staying visible while the app is open.
	*/
    override var prefersStatusBarHidden: Bool
	{
        return false
    }
	
}


/*
	This class extension sets the GameViewController class  as the renderer delegate so the scene
	renders in this class.
*/
extension GameViewController : SCNSceneRendererDelegate
{
	func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval)
	{
		if !self.is_paused
		{
			player.movePlayer()
		}
		
		player.setPlayerPosition(position: player.getPlayerPosition())
		track.getFloor().position = SCNVector3(player.getPlayerNode().position.x, track.getFloorDepth(), player.getPlayerNode().position.z)
	}
}

/*
	This class extension sets the GameViewController class as the physics contact delegate so it
	knows whenever there is a collision that needs to be reported.
*/
extension GameViewController : SCNPhysicsContactDelegate
{
	func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact)
	{
		var contact_node: SCNNode!
		var player: SCNNode
		if contact.nodeA.name == "player"
		{
			player = contact.nodeA
			contact_node = contact.nodeB
		}
		else
		{
			player = contact.nodeB
			contact_node = contact.nodeA
		}

		if contact_node.name == "tree"
		{
			contact_node.categoryBitMask = -1
			gameOver()
		}
		
		updateCollisions(object: contact_node)
		collisionHandler(player: player, object: contact_node)
	}
}


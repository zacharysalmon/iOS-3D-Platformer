//
//  GameViewController.swift
//  HitTheTree
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
	let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
	var leaderboard: [CKRecord] = []

	
	var player: Player!
	
	var database: Database!
	
	var track: Track!
	var track_layer: SCNNode!
//	var floor: SCNNode!
	
	var yellow_coin: Coin!
	var yellow_coins_1: SCNNode!
	var yellow_coins_2: SCNNode!
	var yellow_coin_node: SCNNode!
	
	var red_coins_1: SCNNode!
	var red_coins_2: SCNNode!
	var red_coin_node: SCNNode!
	var red_coin: Coin!
	
// All nodes that appear in the scene
//  var selfie_stick_node: SCNNode!
//	var cam_1: SCNNode!
	
	var obstacle_layer_1: SCNNode!
	var obstacle_layer_2: SCNNode!
	var tree_node: SCNNode!
	var last_contact: SCNNode!
	
	//Various numbers used in calculations and constant positions.
	let starting_point: SCNVector3 =  SCNVector3(0.0, 0.5, 0.0)
	var count = 0
	var coin_timer_start = Date.timeIntervalSinceReferenceDate
	var tree_timer_start = Date.timeIntervalSinceReferenceDate
	var jump_count = 0
	
	
	var number_of_trees: Int = 10
	let max_number_of_trees: Int = 25
	var number_of_coins: Int = 5
	
	// Bit masks for each of the categories of objects that are involved in collisions.
	var category_player: Int = 1
	var category_static: Int = 2
	var category_hidden: Int = 4
	
	// Array to keep track of what is currently being collided with the player.
	var collisions_array: [String: Bool] = ["game_over" : false,
									  "jump_sensor" : false,
									  "clear_sensor" : false]
	
//	var count: Int = 0
//	var jump_start: TimeInterval = Date.timeIntervalSinceReferenceDate
//	var has_jumped: Bool = false
	var is_paused: Bool = true
	var start_of_game: Bool = true
	
	var sounds: [String: SCNAudioSource] = [:]

	
	override func viewDidAppear(_ animated: Bool)
	{
		print("gameview did appear")
		player.setPlayerPosition(position: player.getPlayerPosition())
		player.getPlayerNode().physicsBody?.velocity = player.getPlayerVelocity()
		startCountdown()
	}
	
    override func viewDidLoad()
	{
		super.viewDidLoad()
		setupScene()
		setupNodes()
//		setupSounds()
    }
	
	override func loadView()
	{
	   let scnView = SCNView(frame: UIScreen.main.bounds, options: nil)
	   self.view = scnView
	 }
	
	func setupScene()
	{
		sceneView = (self.view as! SCNView)
		sceneView.delegate = self
		
		scene = SCNScene(named: "art.scnassets/MainScene.scn")
		sceneView.scene = scene
		
		scene.physicsWorld.contactDelegate = self
		
		
		self.sprite_scene = OverlayScene(size: self.view.bounds.size, game_scene: self)
		self.sceneView.overlaySKScene = self.sprite_scene
		
		self.pause_menu = PauseMenu(game_scene: self)
		
		
		let swipe_recognizer = UIPanGestureRecognizer()
		swipe_recognizer.minimumNumberOfTouches = 1
		swipe_recognizer.addTarget(self, action: #selector(GameViewController.sceneViewPanned(recognizer:)))
		sceneView.addGestureRecognizer(swipe_recognizer)
		
		sceneView.preferredFramesPerSecond = 60
//		sceneView.showsStatistics = true
//		sceneView.debugOptions = .showPhysicsShapes
//		sceneView.allowsCameraControl = true
		
		
	}
	
	func setupNodes()
	{
//		everything_node = scene.rootNode.childNode(withName: "everything", recursively: true)!
		player = Player(player_node: scene.rootNode.childNode(withName: "player", recursively: true)!, selfie_stick_node: scene.rootNode.childNode(withName: "selfie_stick", recursively: true)!)
//		selfie_stick_node = scene.rootNode.childNode(withName: "selfie_stick", recursively: true)!
		
		
		database = Database()
		
		track_layer = scene.rootNode.childNode(withName: "track_layer", recursively: true)!
//		track = scene.rootNode.childNode(withName: "track", recursively: true)!
		track = Track(track: scene.rootNode.childNode(withName: "track", recursively: true)!, floor: scene.rootNode.childNode(withName: "floor", recursively: true)!)
		
//		floor = scene.rootNode.childNode(withName: "floor", recursively: true)!
//		cam_1 = scene.rootNode.childNode(withName: "cam_1", recursively: true)!
		
		obstacle_layer_1 = scene.rootNode.childNode(withName: "obstacle_layer_1", recursively: true)!
		obstacle_layer_2 = scene.rootNode.childNode(withName: "obstacle_layer_2", recursively: true)!
		tree_node = scene.rootNode.childNode(withName: "tree", recursively: true)!
		for i in 0...number_of_trees
		{
			obstacle_layer_1.insertChildNode(tree_node.clone(), at: i)
			obstacle_layer_2.insertChildNode(tree_node.clone(), at: i)
		}
//		print("obstacles 1: \(obstacle_layer_1.childNodes.count)")
//		print("obstacles 2: \(obstacle_layer_2.childNodes.count)")
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
	
	func setupSounds()
	{
//		let background_music = SCNAudioSource(fileNamed: "background.mp3")!
//		background_music.volume = 0.1
//		background_music.loops = true
//		background_music.load()
//		let music_player = SCNAudioPlayer(source: background_music)
//		player.addAudioPlayer(music_player)
		
		// Let's the user listen to outside audio while the app is playing.
		try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient)
		try? AVAudioSession.sharedInstance().setActive(true)
	}
	
	
	@objc func sceneViewPanned(recognizer: UIPanGestureRecognizer)
	{
//		print("velocity: \(location)")
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
	
	func startCountdown()
	{
		if start_of_game
		{
			repeat
			{
				print(self.sprite_scene.countdown)
				sleep(1)
				self.sprite_scene.countdown -= 1
			} while sprite_scene.countdown > 0
			self.sprite_scene.countdown_node.isHidden = true
			self.sprite_scene.countdown = 3
			start_of_game = false
		}
		unpauseWorld()
	}
	
	
	func collisionHandler(player: SCNNode, object: SCNNode)
	{
		if object.physicsBody?.categoryBitMask == category_static && !is_paused
		{
			if object.name == "jump"
			{
				if #available(iOS 11.0, *)
				{
					//Modifying y to a lower number makes the player rotate backwards
					player.runAction(SCNAction.rotateTo(x: 1.5708, y: 1.2, z: 1.5708, duration: 0.1, usesShortestUnitArc: true))
					player.position.y += 0.1
				}
			}
			else if object.name == "track"
			{
				if #available(iOS 11.0, *)
				{
					player.runAction(SCNAction.rotateTo(x: 1.5708, y: 1.5708, z: 1.5708, duration: 0.1))
				}
			}
			else if object.name == "tree" && collisions_array["game_over"] == false
			{
				object.categoryBitMask = -1
				gameOver()
			}
			
		}
	
		if object.physicsBody?.categoryBitMask == category_hidden
		{
//			print("Hidden \(String(describing: object.name))")
			if object.name == "finish_sensor"
			{
//				collisions_array[object.name!] = true
				player.physicsBody?.applyForce(SCNVector3(0, 0, 0), asImpulse: true)
				player.position = starting_point
			}
			else if object.name == "floor" && collisions_array["game_over"] == false && !is_paused
			{
				gameOver()
			}
			else if object.name == "yellow_coin"
			{
//				print("parent: \(object.parent?.parent?.name)")
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
	
	
	func updateCollisions(object: SCNNode)
	{
		collisions_array[object.name!] = true
		if collisions_array["jump_sensor"] == true && collisions_array["clear_sensor"] == true
		{
			updateScore()
//			print("player: \(player.getPlayerPosition().z)")
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

	
	func yellowCoinHit()
	{
		let coin_timer_end = NSDate.timeIntervalSinceReferenceDate
		let coin_time_elapsed = coin_timer_end - self.coin_timer_start
		if coin_time_elapsed > 0.001
		{
			print("elapsed: \(coin_time_elapsed)")
//			print("yellow")
			self.sprite_scene.score += 1
			self.player.setPlayerCoins(coins: self.player.getPlayerCoins() + 1)
		}
		self.coin_timer_start = NSDate.timeIntervalSinceReferenceDate
	}
	
	func redCoinHit()
	{
		let coin_timer_end = NSDate.timeIntervalSinceReferenceDate
		let coin_time_elapsed = coin_timer_end - self.coin_timer_start
		if coin_time_elapsed > 0.001
		{
			print("elapsed: \(coin_time_elapsed)")
//			print("red")
			self.sprite_scene.score += 5
			self.player.setPlayerCoins(coins: self.player.getPlayerCoins() + 5)
		}
		self.coin_timer_start = NSDate.timeIntervalSinceReferenceDate
	}
	
	func updateScore()
	{
		self.sprite_scene.score += 2
		jump_count += 1
		if jump_count % 3 == 0
		{
			updateLevel()
		}
	}
	
	func placeObstacles()
	{
		for each in obstacle_layer_1.childNodes
		{
			each.eulerAngles = SCNVector3(0.0, 0.0, 0.0)
			var random_position = getTreePositionVector()
			if random_position.x > 19.0
			{
				//right side
				each.eulerAngles.z = 0.45
				random_position.y = random_position.x.magnitude / 6.0
			}
			else if random_position.x < -19.0
			{
				//left side
				each.eulerAngles.z = -0.45
				random_position.y = random_position.x.magnitude / 6.0
			}
		
			each.position = random_position
			
		}
	}
	
	func loopObstacles()
	{
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
			if random_position.x > 19.0
			{
				//right side
				each.eulerAngles.z = 0.45
				random_position.y = random_position.x.magnitude / 6.0
			}
			else if random_position.x < -19.0
			{
				//left side
				each.eulerAngles.z = -0.45
				random_position.y = random_position.x.magnitude / 6.0
			}
			each.position = random_position
		}
	}
	
	func getTreePositionVector() -> SCNVector3
	{
		let random_x = CGFloat.random(in: -25.0 ... 25.0)
		let random_y = CGFloat(0.0)
		let random_z = CGFloat.random(in: (CGFloat(track.getNextTrackPositionZ() + track.getTrackLength() + track.getObstacleDistanceBuffer())) ... (CGFloat(track.getNextTrackPositionZ() + (track.getTrackLength() * 2) - track.getObstacleDistanceBuffer())))
		return SCNVector3(random_x, random_y, random_z)
	}
	
	func placeCoins()
	{
		while yellow_coins_1.childNodes.count < number_of_coins
		{
			let yellow_clone_1 = Coin(coin_node: yellow_coin_node.clone(), coin_color: "yellow")
			yellow_coins_1.addChildNode(yellow_clone_1.getCoinNode())
		}

		if red_coins_1.childNodes.count < 1
		{
//			print("Adding red coin")
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
	
	func getCoinPositionVector(coin: Coin) -> SCNVector3
	{
		let random_x = CGFloat.random(in: -17.0 ... 17.0)
		var random_y = CGFloat(3.0)
		if coin.getCoinColor() == "red"
		{
			random_y = CGFloat(7.0)
		}
		let random_z = CGFloat.random(in: (CGFloat(track.getNextTrackPositionZ() + track.getTrackLength() + track.getObstacleDistanceBuffer())) ... (CGFloat(track.getNextTrackPositionZ() + (track.getTrackLength() * 2) - track.getObstacleDistanceBuffer())))
		return SCNVector3(random_x, random_y, random_z)
	}
	
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
		if obstacle_layer_1.childNodes.count <= max_number_of_trees
		{
			obstacle_layer_1.addChildNode(tree_node.clone())
		}
		
//		print("speed: \(player.getPlayerSpeed()), track_length: \(track.getTrackLength()), next_track: \(track.getNextTrackPositionZ()), tree_count: \(obstacle_layer_1.childNodes.count)")
	}
	
	deinit
	{
		scene.rootNode.cleanup()
		print("deinit")
		for each in scene.rootNode.childNodes
		   {
			   each.geometry = nil
			   each.removeFromParentNode()
		   }
		print("everything: \(scene.rootNode.childNodes)")
	}
	
	
	func gameOver()
	{
		let tree_timer_end = NSDate.timeIntervalSinceReferenceDate
		let tree_time_elapsed = tree_timer_end - tree_timer_start
		tree_timer_start = NSDate.timeIntervalSinceReferenceDate
//		print(tree_time_elapsed)
		if tree_time_elapsed > 1.0
		{
			collisions_array["game_over"] = true
			print("Game Over")
			self.player.getPlayerNode().removeFromParentNode()
			sprite_scene.setHighScore()
			database.saveToCloud(score: self.sprite_scene.score, player: player)
			
			openGameOverMenu()
		}
	}
	
	func unpauseWorld()
	{
		print("Unpaused")
		if is_paused
		{
			is_paused = false
			player.getPlayerNode().isPaused = false
		}
	}
	
	func pauseWorld()
	{
		print("Paused")
		if !is_paused
		{
			is_paused = true
			player.getPlayerNode().isPaused = true
			openPauseMenu()
		}
		else
		{
			player.setPlayerPosition(position: player.getPlayerPosition())
			player.setPlayerVelocity(velocity: player.getPlayerVelocity())
			print("Unpause?")
			unpauseWorld()
		}
	}
	
	
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
	
    override var prefersStatusBarHidden: Bool
	{
        return false
    }
	
}


extension GameViewController : SCNSceneRendererDelegate
{
	// This render function updates the scene every frame. Try to keep a minimal amount of operations in this function to not overload the CPU.
	func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval)
	{
		if !self.is_paused
		{
			player.movePlayer()
		}
		
		player.setPlayerPosition(position: player.getPlayerPosition())
//		floor.position = SCNVector3(player.getPlayerNode().position.x, floor_depth, player.getPlayerNode().position.z)
		track.getFloor().position = SCNVector3(player.getPlayerNode().position.x, track.getFloorDepth(), player.getPlayerNode().position.z)
	}
}

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

extension SCNNode
{
	func cleanup()
	{
		for child in childNodes
		{
			print(child.name)
			child.cleanup()
		}
		geometry = nil
	}
}


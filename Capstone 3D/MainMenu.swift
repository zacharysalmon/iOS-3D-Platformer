//
//  MainMenu.swift
//  Capstone 3D
//
//  Created by Zack Salmon on 8/6/20.
//  Copyright © 2020 Zack Salmon. All rights reserved.
//

import Foundation
import UIKit

class MainMenu: UIViewController
{
	@IBOutlet weak var player_name: UITextField!
	@IBOutlet weak var player_high_score: UILabel!
	
	
	/*
		Loads the main menu. This puts all buttons, labels, scores, text fields, and text on the
		screen.
	*/
	override func viewDidLoad()
	{
		super.viewDidLoad()
		player_name.delegate = self
		let user_defaults = UserDefaults.standard
		if user_defaults.string(forKey: "player_name") != ""
		{
			player_name.text = user_defaults.string(forKey: "player_name")
		}
		else
		{
			user_defaults.setValue("player_name", forKey: "")
		}
		if user_defaults.value(forKey: "high_score") != nil
		{
			player_high_score.text = user_defaults.string(forKey: "high_score")
		}
		else
		{
			player_high_score.text = "0"
		}
	}
	
	/*
		This function is tied to the play button on the main menu. It loads the game view and
		presents it to the screen.
	*/
	@IBAction func playTapped(_ sender: Any)
	{
		let scnStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
		guard let game_view = scnStoryboard.instantiateViewController(withIdentifier: "GameView") as? GameViewController else
		{
			print("Couldn't find the view controller")
			return
		}
		game_view.modalTransitionStyle = .crossDissolve
		present(game_view, animated: true, completion: nil)
	}
	
	/*
		This function is tied to the leaderboard button on the main menu. It loads the leaderboard
		view and presents it to the screen.
	*/
	@IBAction func leaderboardTapped(_ sender: Any)
	{
		let scnStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
		guard let game_view = scnStoryboard.instantiateViewController(withIdentifier: "LeaderboardView") as? Leaderboard else
		{
			print("Couldn't find the view controller")
			return
		}
		game_view.modalTransitionStyle = .coverVertical
		present(game_view, animated: true, completion: nil)
	}
	
}

extension MainMenu : UITextFieldDelegate
{
	
	/*
		This function makes it so the editable text field can keep and maintain the name of the
		player and stores it on the device. 
	*/
	func textFieldShouldReturn(_ textField: UITextField) -> Bool
	{
		let user_defaults = UserDefaults.standard
		user_defaults.setValue(player_name.text, forKey: "player_name")
		return textField.resignFirstResponder()
	}
}

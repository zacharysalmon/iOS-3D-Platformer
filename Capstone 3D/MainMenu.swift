//
//  MainMenu.swift
//  HitTheTree
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
	
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		player_name.delegate = self
		let user_defaults = UserDefaults.standard
		player_name.text = user_defaults.string(forKey: "player_name")
		if user_defaults.value(forKey: "high_score") != nil
		{
			player_high_score.text = user_defaults.string(forKey: "high_score")
		}
		else
		{
			player_high_score.text = "0"
		}
		print("MainMenu viewdidload()")
	}
	
	@IBAction func reloadView(_ sender: Any)
	{
		print("MainMenu reloadView()")
//		viewDidLoad()
	}
	
	
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
	
//	override func prepare(for segue: UIStoryboardSegue, sender: Any?)
//	{
//		let game_vc = segue.destination as? GameViewController
//		print("Player name: \(String(describing: player_name.text))")
//	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
	{
//		_ = self.textFieldShouldReturn(player_name)
//		viewDidLoad()
	}
}

extension MainMenu : UITextFieldDelegate
{
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool
	{
		let user_defaults = UserDefaults.standard
		user_defaults.setValue(player_name.text, forKey: "player_name")
		print("saving: \(String(describing: player_name.text)))")
		return textField.resignFirstResponder()
	}
}

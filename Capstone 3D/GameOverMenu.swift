//
//  GameOverMenu.swift
//  Capstone 3D
//
//  Created by Zack Salmon on 8/5/20.
//  Copyright © 2020 Zack Salmon. All rights reserved.
//

import Foundation
import UIKit

class GameOverMenu: UIViewController
{
	
	@IBOutlet weak var score_label: UILabel!
	
	
	/*
		Function that loads the view and displays the previous score.
	*/
	override func viewDidLoad()
	{
		super.viewDidLoad()
		score_label.text = UserDefaults.standard.string(forKey: "last_score")
	}
	
	/*
		This function sorts through the entire list of views that may be stacked on top of each
		other until it gets to the bottom, and then returns to that last one which is the main
		menu. It reloads the main menu view to update the score if there was a new high score
		reached. 
	*/
	@IBAction func returnToMenuTapped(_ sender: Any)
	{
		var vc = self.presentingViewController
		
		while ((vc?.presentingViewController) != nil)
		{
			vc = vc?.presentingViewController
		}
		vc?.dismiss(animated: true, completion: nil)
		vc?.viewDidLoad()
	}
	
}

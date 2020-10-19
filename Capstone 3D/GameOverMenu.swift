//
//  PauseMenu.swift
//  HitTheTree
//
//  Created by Zack Salmon on 8/5/20.
//  Copyright © 2020 Zack Salmon. All rights reserved.
//

import Foundation
import UIKit

class GameOverMenu: UIViewController
{
	
	@IBOutlet weak var score_label: UILabel!
	override func viewDidLoad()
	{
		super.viewDidLoad()
		score_label.text = UserDefaults.standard.string(forKey: "last_score")
	}
	

	
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

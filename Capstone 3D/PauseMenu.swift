//
//  PauseMenu.swift
//  HitTheTree
//
//  Created by Zack Salmon on 8/5/20.
//  Copyright © 2020 Zack Salmon. All rights reserved.
//

import Foundation
import UIKit

class PauseMenu: UIViewController
{
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
//		print("Pause Menu View Did Load")
	}
	
	init(game_scene: GameViewController)
	{
		super.init(nibName: "nibName", bundle: Bundle.main)
	}

	required init?(coder: NSCoder)
	{
		super.init(coder: coder)
	}
	
	
	@IBAction func resumeTapped(_ sender: Any)
	{
		self.dismiss(animated: true, completion: {})
	}
	
	@IBAction func returnToMenuTapped(_ sender: Any)
	{
		var vc = self.presentingViewController
		
		while ((vc?.presentingViewController) != nil)
		{
			vc = vc?.presentingViewController
		}
		vc?.dismiss(animated: true, completion: nil)
	}
	
}

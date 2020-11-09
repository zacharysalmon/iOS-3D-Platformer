//
//  PauseMenu.swift
//  Capstone 3D
//
//  Created by Zack Salmon on 8/5/20.
//  Copyright © 2020 Zack Salmon. All rights reserved.
//

import Foundation
import UIKit

class PauseMenu: UIViewController
{
	
	/*
		This function loads the pause menu.
	*/
	override func viewDidLoad()
	{
		super.viewDidLoad()
	}
	
	/*
		This function is tied to the resume button on the pause menu. It dismisses this view and
		returns the screen to the last presented view which is the game.
	*/
	@IBAction func resumeTapped(_ sender: Any)
	{
		self.dismiss(animated: true, completion: {})
	}
	
	/*
		This function is tied to the return to menu button on the pause menu. It dismisses all views
		until it gets to the last remaining view which is the main menu and presents it. 
	*/
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

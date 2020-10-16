//
//  Leaderboard.swift
//  Capstone 3D
//
//  Created by Zack Salmon on 8/21/20.
//  Copyright © 2020 Zachary Salmon. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

struct cellData
{
	var place: Int!
	var name: String!
	var score: Int!
	var coins: Int!
}

class Leaderboard: UITableViewController
{
	@IBOutlet weak var leaderboardView: UITableView!
	
	let public_database = CKContainer.default().publicCloudDatabase
	let private_database = CKContainer.default().privateCloudDatabase
	
	let defaultContainer = CKContainer.default()

	let containerRecordTypes: [CKContainer: [String]] = [CKContainer.default() : ["Player"]]

	var containers = Array<Any>()
	
	var user_id_list = Array<String>()
	var leaderboard = [CKRecord]()
	var array_of_leaderboard = [cellData]()
	var first_row: Bool = true
	
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		array_of_leaderboard = [cellData(name: "", score: 0, coins: 0)]
		containers = Array(containerRecordTypes.keys)
		queryFromDatabase()
	}
	
	@IBAction func backToMenuTapped(_ sender: Any)
	{
//		print("Back tapped")
		dismiss(animated: true, completion: nil)
	}
	
	func queryFromDatabase()
	{
		print("queryFromDatabase\n")
		for container in containers
		{
			// User data should be stored in the private database.
		 
			
			private_database.fetchAllRecordZones
				{ zones, error in
					guard let zones = zones, error == nil else
					{
						print(error!)
						return
					}
				
				// The true predicate represents a query for all records.
				let alwaysTrue = NSPredicate(value: true)
				for zone in zones
				{
					for recordType in self.containerRecordTypes[container as! CKContainer] ?? []
					{
						let query = CKQuery(recordType: recordType, predicate: alwaysTrue)
						

						let sort_score = NSSortDescriptor(key: "player_score", ascending: false)
						let sort_coins = NSSortDescriptor(key: "player_coins", ascending: false)
						let sort_name = NSSortDescriptor(key: "player_name", ascending: false)
						let sort_id = NSSortDescriptor(key: "user_reference", ascending: true)
						query.sortDescriptors = [sort_score, sort_coins, sort_name, sort_id]
						
						
//						let query = CKQueryOperation(query: aquery)
//						query.resultsLimit = 200
//						self.public_database.add(query)
						self.public_database.perform(query, inZoneWith: zone.zoneID)
						{ records, error in
							guard let records = records, error == nil else
							{
								 // Create and configure the alert controller.
								 let alert = UIAlertController(title: "Something went wrong", message: error.debugDescription,
									   preferredStyle: .alert)
									  
								 self.present(alert, animated: true)
								{
									// The alert was presented
								}
								print("An error occurred fetching these records.")
								return
							}
							var count = 0
							for record in records
							{
								count += 1
//								print(count)
								for key in record
								{
									if key.0 == "user_reference"
									{
										if !self.user_id_list.contains(key.1 as! String)
										{
											self.user_id_list.append(key.1 as! String)
//											print("user_id: \(self.user_id_list)")
//											if self.user_id_list.count < 50
//											{
												self.leaderboard.append(record)
//												print("leaderboard: \(self.leaderboard)")
//											}
										}
									}
								}
							}
							self.reloadLeaderboard(records)
						}
					}
				}
			}
		}
	}
	
	// Utility function to display records.
	// Customize it to display records appropriately
	// according to your app's unique record types.
	func reloadLeaderboard(_ records: [CKRecord])
	{
		DispatchQueue.main.async
		{
			self.tableView.reloadData()
		}
	}
	
	override func numberOfSections(in tableView: UITableView) -> Int
	{
//		print("numberOfSections")
		return 1
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
//		print("numberOfRowsInSection")
		return leaderboard.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
	{
//		print("cellForRowAt")
		let cell = Bundle.main.loadNibNamed("TableViewCell", owner: self, options: nil)?.first as! TableViewCell
	
		let new_name = leaderboard[indexPath.row].value(forKey: "player_name") as! String
		let new_score = leaderboard[indexPath.row].value(forKey: "player_score") as! Int
		let new_coins = leaderboard[indexPath.row].value(forKey: "player_coins") as! Int
		
		cell.place?.text = String(indexPath.row + 1)
		cell.name?.text = new_name
		cell.score?.text = String(new_score)
		cell.coins?.text = String(new_coins)
		
		return cell
	}


}
	


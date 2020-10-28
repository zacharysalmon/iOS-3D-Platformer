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
		print("\nqueryFromDatabase\n")
		for container in containers
		{
			// User data should be stored in the private database.


			public_database.fetchAllRecordZones
			{ zones, error in
				guard let zones = zones, error == nil else
				{
					print(error!)
					return
				}

			// The true predicate represents a query for all records.
			let alwaysTrue = NSPredicate(value: true)

			for recordType in self.containerRecordTypes[container as! CKContainer] ?? []
			{
				let query = CKQuery(recordType: recordType, predicate: alwaysTrue)


				let sort_score = NSSortDescriptor(key: "player_score", ascending: false)
				let sort_coins = NSSortDescriptor(key: "player_coins", ascending: false)
				let sort_name = NSSortDescriptor(key: "player_name", ascending: false)
				let sort_id = NSSortDescriptor(key: "user_reference", ascending: true)
				query.sortDescriptors = [sort_score, sort_coins, sort_name, sort_id]
//
				let query_operation = CKQueryOperation(query: query)
				query_operation.desiredKeys = ["player_score", "player_coins", "player_name", "user_reference"]
				query_operation.queuePriority = .veryHigh
				query_operation.resultsLimit = kJUSTUnlimited
				self.public_database.add(query_operation)
				query_operation.recordFetchedBlock =
					{(record:CKRecord!) -> Void in
						for key in record
						{
							if key.0 == "user_reference"
							{
								if !self.user_id_list.contains(key.1 as! String)
								{
									self.user_id_list.append(key.1 as! String)
									print("user_id: \(self.user_id_list.count)")
									if self.leaderboard.count < 50
									{
										self.leaderboard.append(record)
										print("leaderboard: \(self.leaderboard.count)")
									}
								}
							}
						}
						self.reloadLeaderboard(self.leaderboard)
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
		return 1
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		return leaderboard.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
	{
//		print("cellForRowAt")
		let cell = Bundle.main.loadNibNamed("TableViewCell", owner: self, options: nil)?.first as! TableViewCell
		if leaderboard.count > 0
		{
			let new_name = leaderboard[indexPath.row].value(forKey: "player_name") as! String
			let new_score = leaderboard[indexPath.row].value(forKey: "player_score") as! Int
			let new_coins = leaderboard[indexPath.row].value(forKey: "player_coins") as! Int
			
			cell.place?.text = String(indexPath.row + 1)
			cell.name?.text = new_name
			cell.score?.text = String(new_score)
			cell.coins?.text = String(new_coins)
		}
		
		return cell
	}


}
	


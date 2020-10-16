//
//  Database.swift
//  Capstone 3D
//
//  Created by Zack Salmon on 10/16/20.
//  Copyright © 2020 Zachary Salmon. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import CloudKit

class Database
{
	private let PUBLIC_DATABASE = CKContainer.default().publicCloudDatabase
	private let PRIVATE_DATABASE = CKContainer.default().privateCloudDatabase
	
	private let DEFAULT_CONTAINER = CKContainer.default()
	
	private let containerRecordTypes: [CKContainer: [String]] = [CKContainer.default() : ["Player"]]
	
	
	init()
	{
		print("Database Initialized")
	}
	
	func getPublicDatabase() -> CKDatabase
	{
		return self.PUBLIC_DATABASE
	}
	
	func getPrivateDatabase() -> CKDatabase
	{
		return self.PRIVATE_DATABASE
	}
	
	func getDefaultContainer() -> CKContainer
	{
		return self.DEFAULT_CONTAINER
	}
	
	
	func saveToCloud(score: Int, player: Player)
	{
//		var user_reference = String()
		CKContainer.default().fetchUserRecordID
		{ (record_id, error_1) in
			if error_1 != nil
			{
				print(error_1!)
			}
			let player_name = UserDefaults.standard.string(forKey: "player_name")
			self.PUBLIC_DATABASE.fetch(withRecordID: record_id!)
			{ (record1, error_2) in
				if error_2 != nil
				{
					print(error_2!)
				}
				
				let old_high_score = UserDefaults.standard.value(forKey: "high_score") as! Int
				
				if record1 != nil && old_high_score < score
				{
					record1!.setValue(player_name, forKey: "player_name")
					record1!.setValue(score, forKey: "player_score")
					record1!.setValue(player.getPlayerCoins(), forKey: "player_coins")
					self.PUBLIC_DATABASE.save(record1!)
						{ (record2, error_3)
							in
							guard record2 != nil else {print(error_3!); return}
							print("user_record: \(String(describing: record1))")
						print("record2: \(String(describing: record2))")
						}
				}
				let user_id = record1?.recordID.recordName
				UserDefaults.standard.setValue(user_id, forKey: "user_id")
				
				let player_record = CKRecord(recordType: "Player")
				player_record.setValue(user_id, forKey: "user_reference")
				player_record.setValue(player_name, forKey: "player_name")
				player_record.setValue(score, forKey: "player_score")
				player_record.setValue(player.getPlayerCoins(), forKey: "player_coins")
				let operation = CKModifyRecordsOperation(recordsToSave: [player_record], recordIDsToDelete: nil)
//				print("player_record: \(player_record)")
				self.PUBLIC_DATABASE.add(operation)
			}
		}
		
	}
	
	
	
}

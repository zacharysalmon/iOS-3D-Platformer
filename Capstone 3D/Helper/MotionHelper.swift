//
//  MotionHelper.swift
//  HitTheTree
//
//  Created by Zack Salmon on 7/10/20.
//  Copyright © 2020 Zack Salmon. All rights reserved.
//

import Foundation
import CoreMotion

class MotionHelper
{
	let motion_manager = CMMotionManager()
	
	init()
	{
		
	}
	
	func getAccelerometerData(interval: TimeInterval = 0.1, motion_data_results: ((_ x: Float, _ y: Float, _ z: Float) -> ())? )
	{
		if motion_manager.isAccelerometerAvailable
		{
			motion_manager.accelerometerUpdateInterval = interval
			motion_manager.startAccelerometerUpdates(to: OperationQueue())
			{
				(data, error) in
				if motion_data_results != nil
				{
					motion_data_results!(Float(data!.acceleration.x), Float(data!.acceleration.y), Float(data!.acceleration.z))
				}
			}
		}
	}
}

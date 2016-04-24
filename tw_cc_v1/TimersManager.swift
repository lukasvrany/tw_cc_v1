//
//  TimersManager.swift
//  tw_cc_v1
//
//  Created by Lukáš Vraný on 24.04.16.
//  Copyright © 2016 Laky. All rights reserved.
//

import Foundation
import UIKit

class TimersManager {

	var timers = [String: Timer]()

	init() {
	}

	func add(timer: Timer) {
		timers[timer.name] = timer
	}

	func getOrCreate(name: String) -> Timer {
		if let timer = timers[name] {
			return timer
		} else {
			let newTimer = create(name)
			add(newTimer)
			return newTimer
		}
	}

	func resetAll() {
		for (_, timer) in timers {
			timer.reset()
		}
	}

	func getAllInformations() -> [String: String] {
		var result = [String: String]()
		for (name, timer) in timers {
			result[name] = String(timer.count / 10) + "s"
		}
		return result
	}

	func create(name: String) -> Timer {
		return Timer(name: name)
	}
}

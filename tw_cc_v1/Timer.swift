//
//  Timer.swift
//  tw_cc_v1
//
//  Created by Lukáš Vraný on 24.04.16.
//  Copyright © 2016 Laky. All rights reserved.
//

import Foundation
import UIKit

class Timer {

	var count = 0
	var name: String

	var timer = NSTimer()

	init(name: String) {
		self.name = name
		timer = NSTimer()
	}

	func start() {
		timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(counting), userInfo: nil, repeats: true)
	}

	func end() {
		timer.invalidate()
	}

	func rest() {
		count = 0
	}

	@objc private func counting() {
		count += 1
	}
}

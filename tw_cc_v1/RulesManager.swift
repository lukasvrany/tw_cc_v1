//
//  RulesManager.swift
//  tw_cc_v1
//
//  Created by Lukáš Vraný on 03.05.16.
//  Copyright © 2016 Laky. All rights reserved.
//

import Foundation
import UIKit

class RulesManager {

	var allRulesCount = 0
	var generalRulesCount: Int

	var allRules = [(String, Int)]()
	var generalRules: [(String, Int)]

	init() {
		// General rules
		generalRules = RulesGeneral().getAllRules()
		generalRulesCount = generalRules.count
		allRulesCount += generalRulesCount
		allRules.appendContentsOf(generalRules)
	}
}

//
//  Nikita.swift
//  tw_cc_v1
//
//  Created by Lukáš Vraný on 24.05.16.
//  Copyright © 2016 Laky. All rights reserved.
//

import Foundation
import SwiftJavascriptBridge
import SwiftyJSON

class Nikita {

	private let kJSWebURL = ""
	private var bridge: SwiftJavascriptBridge = SwiftJavascriptBridge.bridge()

	init() {
		addSwiftHandlers()
	}

	private func addSwiftHandlers() {
		// Add handlers that are going to be called from JavasCript with messages.
		weak var safeMe = self

		self.bridge.bridgeAddHandler("returnToAppHandler", handlerClosure: { (data: AnyObject?) -> Void in
			// Handler that receive a string as data.
			let message = data as! String;
			// safeMe?.printMessage(message)
			print(message)
		})
	}

	private func sendRequest() {
		// Note: All JS functions then call handlerToPrintMessages handler to print a message.
		weak var safeMe = self

		// Call a JS Function with a String as arguments.
		let message = String("Swift says: swiftCallWithStringData called.")
		self.bridge.bridgeCallFunction("sendRequest", data: message, callBackClosure: { (data: AnyObject?) -> Void in
			let message: String! = data as! String
			print(message)
		})
	}

}

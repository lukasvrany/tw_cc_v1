//
//  ProgressController.swift
//  tw_cc_v1
//
//  Created by EN on 26.05.16.
//  Copyright © 2016 Laky. All rights reserved.
//

import UIKit
import SnapKit
import WebKit

class ProgressController: UIViewController, WKNavigationDelegate, WKScriptMessageHandler {

	var webView: WKWebView?

	var mail: String!
	var name: String!
	var address: String!
	var city: String!
	var zip: String!
	var phone: String!
	var price: String!

	override func viewDidLoad() {
		super.viewDidLoad()
		self.title = "Vyhodnocování"
		self.view.backgroundColor = UIColor.whiteColor()

		let progressView = UIImageView(image: UIImage(named: "kola"))
		progressView.contentMode = UIViewContentMode.ScaleAspectFit
		self.view.addSubview(progressView)
		progressView.snp_makeConstraints { (make) in
			make.center.equalTo(self.view)
			make.width.equalTo(200)
			make.height.equalTo(200)
		}

		let progressLabel = UILabel()
		progressLabel.text = "Probíhá vyhodnocení"
		progressLabel.font = UIFont(name: "HelveticaNeue", size: 25)
		progressLabel.textAlignment = .Center
		self.view.addSubview(progressLabel)
		progressLabel.snp_makeConstraints { (make) in
			make.top.equalTo(self.snp_topLayoutGuideBottom).offset(20)
			make.leading.equalTo(10)
			make.trailing.equalTo(-10)
		}

		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ProgressController.results))
		view.addGestureRecognizer(tapGesture)

		sendRequestToNikita()

	}

	func sendRequestToNikita() {
		// the following code is used to execute custom javascript
		// in the webview to initialize the webviewer object
		let contentController = WKUserContentController()
		let userScript = WKUserScript(
			source: "window.webviewer.init()",
			injectionTime: WKUserScriptInjectionTime.AtDocumentEnd,
			forMainFrameOnly: true
		)
		contentController.addUserScript(userScript)

		// this code to used to allow the webview to send messages to swift
		// via: webkit.messageHandlers.callbackHandler.postMessage(message);
		contentController.addScriptMessageHandler(
			self,
			name: "callbackHandler"
		)

		let config = WKWebViewConfiguration()
		config.userContentController = contentController

		// create the webview with the above configuration options
		self.webView = WKWebView(frame: self.view.frame, configuration: config)
		// self.view = self.webView

		let url = NSURL(string: "http://146.185.175.250:5000/")
		let req = NSURLRequest(URL: url!)
		webView!.loadRequest(req)

		webView!.hidden = true
		self.view.addSubview(webView!)
		webView!.snp_makeConstraints { make in
			make.edges.equalTo(view)
		}
		webView!.navigationDelegate = self

	}

	func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {

		// when the webview has finished loading, send it a message via javascript
		print("call")
		self.webView!.evaluateJavaScript("submit('\(mail)', '\(name)', '\(price)', '\(address)', '\(city)', '\(zip)', '\(phone)');", completionHandler: nil)
	}

	func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
		let jsonString = String(message.body)
		print(jsonString)
		let data: NSData = jsonString.dataUsingEncoding(NSUTF8StringEncoding)!
		do {
			let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)

			if let id = json["id"] as? String {
				print("check response")
				print(id)
				// zpracovani
			} else if let id = json["transaction_id"] as? String {
				print("submit response")
				self.webView!.evaluateJavaScript("checkResult();", completionHandler: nil)
			}

		} catch {
			print("error serializing JSON: \(error)")
		}

		print("konec")

	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	func results() {
		navigationController?.pushViewController(ResultController(), animated: true)
	}

	/*
	 // MARK: - Navigation

	 // In a storyboard-based application, you will often want to do a little preparation before navigation
	 override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
	 // Get the new view controller using segue.destinationViewController.
	 // Pass the selected object to the new view controller.
	 }
	 */

}

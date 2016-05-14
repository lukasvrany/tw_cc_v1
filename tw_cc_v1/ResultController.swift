//
//  ResultController.swift
//  tw_cc_v1
//
//  Created by EN on 12.05.16.
//  Copyright © 2016 Laky. All rights reserved.
//

import UIKit
import SnapKit
import LTMorphingLabel

class ResultController: UIViewController, LTMorphingLabelDelegate {

	private var label: LTMorphingLabel!

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = UIColor.whiteColor()
        
        let lblTitle = UILabel()
        lblTitle.text = "You're"
        lblTitle.textAlignment = .Center
        lblTitle.font = UIFont(name: lblTitle.font.fontName, size: 30)

		let lblNoun = LTMorphingLabel()
		lblNoun.text = Collector.Instance().getNoun()
        lblNoun.textAlignment = .Center

		let lblAdjective = LTMorphingLabel()
		lblAdjective.text = Collector.Instance().getAdjective()
        lblAdjective.textAlignment = .Center

		let lblAnotherExtra = LTMorphingLabel()
        lblAnotherExtra.text = Collector.Instance().getAnotherExtra()
        lblAnotherExtra.textAlignment = .Center

		let lblExtra = LTMorphingLabel()
        lblExtra.text = Collector.Instance().getExtra()
        lblExtra.textAlignment = .Center

		let mainStackView = UIStackView(arrangedSubviews: [lblTitle, lblNoun, lblAdjective, lblAnotherExtra, lblExtra])

		mainStackView.axis = .Vertical
		mainStackView.spacing = 10
		view.addSubview(mainStackView)
		mainStackView.snp_makeConstraints { (make) in
			make.center.equalTo(view)
		}

		// Do any additional setup after loading the view.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
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

//
//  ResultController.swift
//  tw_cc_v1
//
//  Created by EN on 12.05.16.
//  Copyright © 2016 Laky. All rights reserved.
//

import UIKit
import SnapKit

class ResultController: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()

        let resultTextLabel = UILabel()
        resultTextLabel.text = Collector.Instance().evaluation()
        view.addSubview(resultTextLabel)
        resultTextLabel.snp_makeConstraints { (make) in
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

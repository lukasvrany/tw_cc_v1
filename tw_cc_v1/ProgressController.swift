//
//  ProgressController.swift
//  tw_cc_v1
//
//  Created by EN on 26.05.16.
//  Copyright © 2016 Laky. All rights reserved.
//

import UIKit
import SnapKit

class ProgressController: UIViewController {

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
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action:"results")
        view.addGestureRecognizer(tapGesture)
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func results(){
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

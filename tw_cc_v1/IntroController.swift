//
//  IntroController.swift
//  tw_cc_v1
//
//  Created by EN on 25.05.16.
//  Copyright © 2016 Laky. All rights reserved.
//

import UIKit
import SnapKit

class IntroController: UIViewController {

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
         self.navigationController?.navigationBarHidden = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.tintColor = UIColor(netHex:0x9048de)
        navigationController!.navigationBar.barTintColor = UIColor(netHex:0x59009e)
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 17)!]
        
        let backgroundView = UIImageView()
        
        backgroundView.image = UIImage(named: "background")
        backgroundView.contentMode = UIViewContentMode.ScaleAspectFit
        self.view.addSubview(backgroundView)
        backgroundView.snp_makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .Center
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.text = "Vrátí ti kámoš peníze?"
        titleLabel.font = UIFont(name: "HelveticaNeue", size: 35)
        self.view.addSubview(titleLabel)
        titleLabel.snp_makeConstraints { (make) in
            make.width.equalTo(self.view).offset(-20)
            make.top.equalTo(self.view.snp_top).offset(70)
            make.centerX.equalTo(self.view)
        }
        
        let reasonLabel = UILabel()
        reasonLabel.numberOfLines = 0
        reasonLabel.textAlignment = .Center
        reasonLabel.text = "Tuto aplikaci jsme vyvinuli, aby jsme zamezili krádežím mezi kamarády."
        reasonLabel.font = UIFont(name: "HelveticaNeue", size: 20)
        reasonLabel.textColor = UIColor.whiteColor()
        
        self.view.addSubview(reasonLabel)
        reasonLabel.snp_makeConstraints { (make) in
            make.width.equalTo(self.view).offset(-40)
            make.centerX.equalTo(self.view)
            make.top.equalTo(titleLabel.snp_bottom).offset(30)
        }
        
        let claimLabel = UILabel()
        claimLabel.numberOfLines = 0
        claimLabel.textAlignment = .Center
        claimLabel.text = "Výsledky hodnocení nemusí být lichotivé. Skutečně si přejete pokračovat?"
        claimLabel.font = UIFont(name: "HelveticaNeue", size: 25)
        claimLabel.textColor = UIColor.whiteColor()
        
        self.view.addSubview(claimLabel)
        claimLabel.snp_makeConstraints { (make) in
            make.width.equalTo(self.view).offset(-40)
            make.centerX.equalTo(self.view)
            make.top.equalTo(reasonLabel.snp_bottom).offset(50)
        }
        
        let continueButton = UIButton()
        continueButton.backgroundColor = UIColor(netHex:0x60cb54)
        continueButton.setTitle("Pokračovat", forState: .Normal)
        continueButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        continueButton.addTarget(self, action: "iWannaBeStalked", forControlEvents: .TouchUpInside)
        
        let exitButton = UIButton()
        exitButton.setTitle("Raději vypnout", forState: .Normal)
        exitButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        exitButton.tintColor = UIColor.clearColor()
        
        let contentStack = UIStackView(arrangedSubviews: [continueButton,exitButton])
        contentStack.axis = .Vertical
        contentStack.spacing = 20
        self.view.addSubview(contentStack)
        contentStack.snp_makeConstraints { (make) in
            make.bottom.equalTo(self.view.snp_bottom).offset(-30)
            make.top.greaterThanOrEqualTo(claimLabel.snp_bottom).offset(30)
            make.width.equalTo(self.view).offset(-40)
            make.centerX.equalTo(self.view)
        }
        
        continueButton.snp_makeConstraints { (make) in
            make.height.equalTo(50)
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func iWannaBeStalked(){
        self.navigationController?.pushViewController(ViewController(), animated: true)
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

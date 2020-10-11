//
//  CreditViewController.swift
//  QRcodeGenerator
//
//  Created by 이승기 on 2020/10/09.
//

import UIKit

class CreditViewController: UIViewController{
    
    @IBOutlet weak var appIcon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAppIcon()
    }
    
    func setAppIcon(){
        appIcon.layer.cornerRadius = 14
    }
}

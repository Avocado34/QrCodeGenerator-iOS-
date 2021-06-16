//
//  GlobalExtensions.swift
//  QRcodeGenerator
//
//  Created by 이승기 on 2021/06/10.
//

import UIKit

public extension String{
    
    var localized: String{
        return NSLocalizedString(self, tableName: "Localizable", value: self, comment: "")
    }
}


public extension UITextField{
    
    func addLeftPadding(_ padding: CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func addRightPadding(_ padding: CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: self.frame.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    func addLeftImage(_ image: UIImage,_ imgSize: CGFloat){
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: self.frame.height))
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: imgSize, height: imgSize))
        imageView.center = leftView.center
        imageView.image = image
        imageView.tintColor = UIColor(named: "HintColor")
        leftView.addSubview(imageView)
        self.leftView = leftView
        self.leftViewMode = .always
    }
}

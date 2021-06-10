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

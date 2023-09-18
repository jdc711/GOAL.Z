//
//  UIColor.swift
//  GOALZ
//
//  Created by Carter Stambaugh on 7/15/19.
//  Copyright © 2019 Carter Stambaugh. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    
    static let continueLineTrace = UIColor().colorFormatHex("384145")
    static let coinNumber = UIColor().colorFormatHex("FFBB00")
    static let waterLineContinueTrace = UIColor().colorFormatHex("187E8D")
    
   
    func colorFormatHex(_ hex : String) -> UIColor {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        
        if hexString.hasPrefix("#"){
            hexString.remove(at: hexString.startIndex)
        }
        if hexString.count != 6 {
            return UIColor.black
        }
        var rgb : UInt32 = 0
        Scanner(string: hexString).scanHexInt32(&rgb)
        
        
        return UIColor.init(red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
                            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
                            blue: CGFloat(rgb & 0x0000FF) / 255.0 ,
                            alpha: 1.0)
    }
}

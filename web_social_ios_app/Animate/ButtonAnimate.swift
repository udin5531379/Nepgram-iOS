//
//  ButtonAnimate.swift
//  web_social_ios_app
//
//  Created by Udin Rajkarnikar on 5/5/20.
//  Copyright © 2020 np.com.udinrajkarnikar. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    
    func bouncButton() {
    
    let bounds = layer.bounds
    UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 10, options: .curveEaseInOut, animations: {
        self.layer.bounds = CGRect(x: bounds.origin.x - 20, y: bounds.origin.y, width: bounds.size.width - 60, height: bounds.size.height)
    }) { (sucess: Bool) in
        if sucess {
            self.layer.bounds = bounds
            }
        }
    
    }
}

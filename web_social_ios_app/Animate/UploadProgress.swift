//
//  UploadProgress.swift
//  web_social_ios_app
//
//  Created by Udin Rajkarnikar on 5/9/20.
//  Copyright © 2020 np.com.udinrajkarnikar. All rights reserved.
//

import Foundation
import JGProgressHUD



func incrementHUD(_ hud: JGProgressHUD, progress previousProgress: Int) {
  
 let progress = previousProgress + 1
 hud.progress = Float(progress)/100.0
 hud.detailTextLabel.text = "\(progress)% Complete"
 
 if progress == 100 {
     DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
         UIView.animate(withDuration: 0.1, animations: {
             hud.textLabel.text = "Success. Please wait a moment"
             hud.detailTextLabel.text = nil
             hud.indicatorView = JGProgressHUDSuccessIndicatorView()
         })
         
        
        }
    } else {
    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(20)) {
        incrementHUD(hud, progress: progress)
    }
}
}

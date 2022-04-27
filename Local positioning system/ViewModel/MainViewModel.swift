//
//  MainViewModel.swift
//  Local positioning system
//
//  Created by Леонид Лукашевич on 26.04.2022.
//

import UIKit

class MainViewModel {
    let positioningManager = PositioningManager() 
    
    func startPositioningUser(completionHandler: @escaping () -> ()) {
        positioningManager.startRecordingMotions()
    }
    
    func calculateEnterPoint(for scrollView: UIScrollView) -> CGPoint {
        let centerOffsetX = (scrollView.contentSize.width - scrollView.frame.size.width) / 2
        let centerOffsetY = scrollView.contentSize.height - scrollView.frame.size.height + 100
        let enterPoint = CGPoint(x: centerOffsetX, y: centerOffsetY)
        
        return enterPoint
    }
}

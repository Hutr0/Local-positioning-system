//
//  MainViewModel.swift
//  Local positioning system
//
//  Created by Леонид Лукашевич on 26.04.2022.
//

import UIKit

class MainViewModel {
    
    var scrollViewDelegate: ScrollViewDelegate!
    var positioningManager: PositioningManager!
    
    init(map: UIImageView) {
        scrollViewDelegate = ScrollViewDelegate(map: map)
        positioningManager = PositioningManager()
    }
    
    func startPositioningUser(completionHandler: @escaping () -> ()) {
        positioningManager.startRecordingMotions()
    }
    
    func configure(scrollView: UIScrollView) {
        scrollView.delegate = scrollViewDelegate
        
        scrollView.minimumZoomScale = 0.2
        scrollView.maximumZoomScale = 5.0
        
        scrollView.layoutIfNeeded()
        
        let enterPoint = calculateEnterPoint(for: scrollView)
        scrollView.setContentOffset(enterPoint, animated: false)
    }
    
    func calculateEnterPoint(for scrollView: UIScrollView) -> CGPoint {
        let centerOffsetX = (scrollView.contentSize.width - scrollView.frame.size.width) / 2
        let centerOffsetY = scrollView.contentSize.height - scrollView.frame.size.height + 100
        let enterPoint = CGPoint(x: centerOffsetX, y: centerOffsetY)
        
        return enterPoint
    }
}

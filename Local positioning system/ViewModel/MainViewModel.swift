//
//  MainViewModel.swift
//  Local positioning system
//
//  Created by Леонид Лукашевич on 26.04.2022.
//

import UIKit
import CoreLocation

class MainViewModel {
    
    var scrollViewDelegate: ScrollViewDelegate!
    lazy var positioningManager = PositioningManager()
    lazy var mapManager = MapManager()
    lazy var userManager = UserManager()
    
    init(map: UIImageView) {
        scrollViewDelegate = ScrollViewDelegate(map: map)
    }
    
    func startPositioningUserOnMap(widht: CGFloat, height: CGFloat, completionHandler: @escaping (CGPoint) -> ()) {
        mapManager.startGettingLocation(closureIfWeAreInside: { [weak self] loc in
            guard let self = self else { return }
            
            let coordinates = self.userManager.getUserCoordinatesForMap(mapWidth: widht, mapHeight: height, coordinates: loc)
            completionHandler(coordinates)
        })
    }
    
    func configure(scrollView: UIScrollView, closureForUserPositioning: @escaping () -> ()) {
        scrollViewDelegate.closureForUserPositioning = closureForUserPositioning
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

//
//  ScrollViewDelegate.swift
//  Local positioning system
//
//  Created by Леонид Лукашевич on 27.04.2022.
//

import UIKit

class ScrollViewDelegate: NSObject, UIScrollViewDelegate {
    
    var map: UIImageView!
    var closureForUserPositioning: (() -> ())?
    
    init(map: UIImageView) {
        self.map = map
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return map
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let offsetX = max((scrollView.bounds.width - scrollView.contentSize.width) * 0.5, 0)
        let offsetY = max((scrollView.bounds.height - scrollView.contentSize.height) * 0.5, 0)
        scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: 0, right: 0)
        
        guard let closureForUserPositioning = closureForUserPositioning else { return }
        closureForUserPositioning()
    }
}

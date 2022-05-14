//
//  MainViewController.swift
//  Local positioning system
//
//  Created by Леонид Лукашевич on 26.04.2022.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var map: UIImageView!
    
    @IBOutlet weak var user: UIImageView!
    @IBOutlet weak var userConstraintToLeading: NSLayoutConstraint!
    @IBOutlet weak var userConstraintToTop: NSLayoutConstraint!
    
    var viewModel: MainViewModel!
    var userX: Double?
    var userY: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userX = self.user.frame.origin.x
        userY = self.user.frame.origin.y
        
        viewModel = MainViewModel(map: map)
        
        viewModel.configure(scrollView: scrollView) { [weak self] in
            guard let self = self, let userX = self.userX, let userY = self.userY else { return }
            
            self.userConstraintToLeading.constant = userX * self.scrollView.zoomScale
            self.userConstraintToTop.constant = userY * self.scrollView.zoomScale
        }
        
        viewModel.startPositioningUserOnMap(widht: map.frame.width, height: map.frame.height) { [weak self] point in
            guard let self = self else { return }
            
            self.user.isHidden = false
            
            let x = point.x
            let y = point.y
            let sizeOfUser = self.user.frame.size
            
            self.userX = x
            self.userY = y
            
            self.user.layer.frame = CGRect(x: x * self.scrollView.zoomScale,
                                           y: y * self.scrollView.zoomScale,
                                           width: sizeOfUser.width, height: sizeOfUser.height)
        }
    }
}

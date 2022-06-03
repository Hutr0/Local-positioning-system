//
//  MainViewController.swift
//  Local positioning system
//
//  Created by Леонид Лукашевич on 26.04.2022.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var upButton: UIButton! {
        didSet {
            upButton.imageView?.layer.transform = CATransform3DMakeScale(0.08, 0.08, 0.08)
        }
    }
    @IBOutlet weak var downButton: UIButton! {
        didSet {
            downButton.imageView?.layer.transform = CATransform3DMakeScale(0.08, 0.08, 0.08)
        }
    }
    
    @IBOutlet weak var map: UIImageView! {
        didSet {
            viewModel = MainViewModel(map: map)
        }
    }
    
    @IBOutlet weak var user: UIImageView! {
        didSet {
            userX = user.frame.origin.x
            userY = user.frame.origin.y
        }
    }
    @IBOutlet weak var userConstraintToLeading: NSLayoutConstraint!
    @IBOutlet weak var userConstraintToTop: NSLayoutConstraint!
    
    var viewModel: MainViewModel!
    var userX: Double?
    var userY: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    @IBAction func upButtonTapped(_ sender: UIButton) {
        map.image = UIImage(named: "up mirea map")
    }
    
    @IBAction func downButtonTapped(_ sender: UIButton) {
        map.image = UIImage(named: "down mirea map")
    }
}

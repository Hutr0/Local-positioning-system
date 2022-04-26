//
//  MainViewController.swift
//  Local positioning system
//
//  Created by Леонид Лукашевич on 26.04.2022.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var user: UIImageView!
    @IBOutlet weak var map: UIImageView!
    
    let viewModel = MainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        configureScrollView()
        viewModel.startPositioningUser {
            
        }
    }
    
    func configureScrollView() {
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 5.0
    }
}

extension MainViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return map
    }
}

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
    
    var viewModel: MainViewModel!
    var scrollViewDelegate: ScrollViewDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = MainViewModel()
        scrollViewDelegate = ScrollViewDelegate(map: map)
        
        configureScrollView()
    }
    
    func configureScrollView() {
        scrollView.delegate = scrollViewDelegate
        
        scrollView.minimumZoomScale = 0.2
        scrollView.maximumZoomScale = 5.0
        
        self.scrollView.layoutIfNeeded()
        let enterPoint = viewModel.calculateEnterPoint(for: scrollView)
        scrollView.setContentOffset(enterPoint, animated: false)
    }
}

extension MainViewController: UIScrollViewDelegate {
    
}

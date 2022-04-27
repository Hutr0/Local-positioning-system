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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = MainViewModel(map: map)
        
        viewModel.configure(scrollView: scrollView)
        
        viewModel.startPositioningUser {
            
        }
    }
}

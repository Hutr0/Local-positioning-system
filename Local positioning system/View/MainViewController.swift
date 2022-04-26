//
//  MainViewController.swift
//  Local positioning system
//
//  Created by Леонид Лукашевич on 26.04.2022.
//

import UIKit
import MapKit
import CoreLocation

class MainViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var user: UIImageView!
    @IBOutlet weak var map: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapButton: UIButton!
    
    let viewModel = MainViewModel()
    let mapManager = MapManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureScrollView()
        setupMapView()
        
        viewModel.startPositioningUser {
            
        }
    }
    
    func setupMapView() {
        mapView.delegate = mapManager
        mapView.isHidden = true
        
        mapManager.checkLocationServices(mapView: mapView) {
            mapManager.locationManager.delegate = self
        }
    }
    
    func configureScrollView() {
        scrollView.delegate = self
        
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 5.0
    }
    
    @IBAction func mapButtonPressed(_ sender: UIButton) {
        mapView.isHidden.toggle()
        
        map.isHidden.toggle()
        user.isHidden.toggle()
    }
}

extension MainViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return map
    }
}

extension MainViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        mapManager.checkLocationAutorization(mapView: mapView)
    }
}

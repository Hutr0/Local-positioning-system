//
//  MainViewModel.swift
//  Local positioning system
//
//  Created by Леонид Лукашевич on 26.04.2022.
//

import Foundation

class MainViewModel {
    let positioningManager = PositioningManager() 
    
    func startPositioningUser(completionHandler: @escaping () -> ()) {
        positioningManager.startRecordingMotions()
    }
}

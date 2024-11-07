//
//  OpenSkyService.swift
//  OpenSkyUtah
//
//  Created by Koleton Murray on 11/5/24.
//

import SwiftUI

@Observable class OpenSkyService {
    // MARK: - Propeties
    
    private var aircraftStates: [AircraftState] = []
    
    // MARK: - Model Access
    
    var locatedAircraftStates : [AircraftState] {
        aircraftStates.filter { $0.latitude != nil && $0.longitude != nil}
    }
    
    // MARK: - User Intents
    
    func loadSampleData() {
        // Load sample data without touching the network
        if let data = Constants.sampleData.data(using: .utf8) {
            updateStates(from: data)
        }
    }
    
    func refreshStatus() {
        // Load utah airplanes from the network API
        if let url = Utah.openSkyUrl {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let data, error == nil {
                    self.updateStates(from: data)
                }
            }
            task.resume()
        }
    }
    
    func toggleDetailVisibility(for aircraftState: AircraftState) {
        // Toggle the visibility of the aircraft's detail box (on our map)
        if let selectedIndex = aircraftStates.firstIndex(matching: aircraftState) {
            aircraftStates[selectedIndex].detailsVisible.toggle()
        }
    }
    
    // MARK: - Private Helpers
    
    private func updateStates(from data: Data) {
        if let json = try? JSONSerialization.jsonObject(with: data) as? [String : Any] {
            if let states = json[Constants.statesKey] as? [[Any]] {
                aircraftStates = []
                
                states.forEach { aircraftState in
                    aircraftStates.append(AircraftState(from: aircraftState))
                }
            }
        }
    }
    
    // MARK: - Constants
    
    private struct Constants {
        static let statesKey = "states"
        static let sampleData = """
            {
              "time":1698763574,
              "states":[
                ["aa3cbe","N759PA  ","United States",1698763459,1698763459,-112.0495,41.8071,2133.6,false,61.08,302.62,0,null,2255.52,null,false,0],
                ["aa56b5","UAL1387 ","United States",1698763574,1698763574,-110.836,39.914,11582.4,false,202.67,299.17,0,null,11841.48,null,false,0],["a96577","DAL971  ","United States",1698763573,1698763573,-109.3835,37.5345,11887.2,false,220.92,71.4,0,null,12138.66,"1030",false,0],["a6b5d4","N531TG  ","United States",1698763573,1698763573,-112.2438,40.7986,1684.02,false,40.72,3.62,1.3,null,1790.7,null,false,0],["ae622a","BLADE30 ","United States",1698763573,1698763574,-111.9072,40.7119,2438.4,false,55.71,175.76,0.98,null,2552.7,null,false,0],["a10f9a","N168CB  ","United States",1698763532,1698763532,-111.8633,41.9844,2286,false,54.17,355.64,-1.95,null,2423.16,null,false,0],["a65484","LXJ507  ","United States",1698763574,1698763574,-109.176,39.4726,13716,false,221.25,260.36,0.65,null,13876.02,null,false,0],["a426a5","DAL1461 ","United States",1698763573,1698763573,-110.8809,38.2834,9448.8,false,224.93,46.85,-0.33,null,9753.6,null,false,0],["a4d97e","SKW3448 ","United States",1698763574,1698763574,-111.9791,40.8048,null,true,0,84.38,null,null,null,null,false,0]
                ]
            }
        """
    }
}

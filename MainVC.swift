//
//  ViewController.swift
//  FinalApp
//
//  Created by Duc Nguyen on 12/1/18.
//  Copyright © 2018 Duc Nguyen. All rights reserved.
//

import UIKit
import CoreLocation
import NotificationCenter
import UserNotifications

class MainVC: UIViewController, CLLocationManagerDelegate{

    
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //TODO: Request persmission for notifications
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in
        })
        
        //TODO:Set up the location manager here.
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.startUpdatingLocation()
        
        // coordination
        let geoFenceCenter : CLLocationCoordinate2D = CLLocationCoordinate2DMake(34.0689, 118.4452)
        
        print("starting geofencing")
        monitorRegionAtLocation(center: geoFenceCenter, identifier: "UCLA")
    }
    
    
    
    
    
    
    func triggerNotification(bool : Bool ){
        
        let content = UNMutableNotificationContent()
        content.title = "Time to update you timecard!"
        content.badge = 1
        
        if bool == true{ // user entered work
            content.body = "Tap to clock in!"
        }
        else{ // user exited work
            content.body = "Tap to clock out!"
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "updateTimeCard", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    //Monitoring a region around the specified coordinate
    func monitorRegionAtLocation(center: CLLocationCoordinate2D, identifier: String ) {
        // Make sure the app is authorized.
        if CLLocationManager.authorizationStatus() == .authorizedAlways {
            // Make sure region monitoring is supported.
            if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
                // Register the region.
                let distance = 100
                let region = CLCircularRegion(center: center,
                                              radius: CLLocationDistance(distance), identifier: identifier)
                region.notifyOnEntry = true
                region.notifyOnExit = true
                
                locationManager.startMonitoring(for: region)
                print("Monitoring.....")
            }
        }
    }
    
    // Handling a region-entered notification
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if let region = region as? CLCircularRegion {
            let identifier = region.identifier
            print("user entered region")
            print(region.identifier)
            print("monitoring is working")
            triggerNotification(bool: true)
        }
    }
    
    // Handling a region-exited notification
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if let region = region as? CLCircularRegion {
            let identifier = region.identifier
            // triggerTaskAssociatedWithExitingRegionIdentifier(regionID: identifier)
            print("user Exited region")
            print(region.identifier)
            print("monitoring is working")
            triggerNotification(bool: false)
        }
    }

}


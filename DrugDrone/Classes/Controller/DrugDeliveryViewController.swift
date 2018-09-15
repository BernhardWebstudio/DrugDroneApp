//
//  DrugDeliveryViewController.swift
//  DrugDrone
//
//  Created by Michal Švácha on 15/09/2018.
//  Copyright © 2018 Michal Švácha. All rights reserved.
//

import UIKit
import MapKit
import Material
import MBProgressHUD

class DrugDeliveryViewController: UIViewController {
    @IBOutlet weak var drugLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var deliveryTime: UILabel!
    @IBOutlet weak var confirmButton: FlatButton!
    
    let viewModel = DrugDeliveryViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.register(DroneMarkerView.self, forAnnotationViewWithReuseIdentifier: "drone")
        mapView.register(OriginMarkerView.self, forAnnotationViewWithReuseIdentifier: "origin")
        mapView.register(DestinationMarkerView.self, forAnnotationViewWithReuseIdentifier: "destination")
        
        mapView.delegate = self
        bindDroneTracking()
        
        drugLabel.text = "Delivery of \(viewModel.order?.drug.name ?? "")"
        originLabel.text = "\(viewModel.order?.careProvider.title ?? "") \(viewModel.order?.careProvider.name ?? "")"
        deliveryTime.text = "Unknown"
        confirmButton.apply(Stylesheet.General.flatButton)
        confirmButton.setTitle("Confirm delivery", for: .normal)
        confirmButton.alpha = 0.0
        
        confirmButton.reactive.tap.bind(to: self) { me, _ in
            me.viewModel.droneBinding?.dispose()
            me.navigationController?.popViewController(animated: true)
        }.dispose(in: bag)
        
        /*
        confirmButton.reactive.tap
            .flatMapLatest { [unowned self] in self.viewModel.confirmDelivery() }
            .bind(to: self) { me, result in
                switch result {
                case .loading:
                    me.viewModel.droneBinding?.dispose()
                    MBProgressHUD.showAdded(to: me.view, animated: true)
                case .loaded:
                    me.navigationController?.popViewController(animated: true)
                case .failed:
                    me.navigationController?.popViewController(animated: true)
                }
        }*/
    }
    
    func bindDroneTracking() {
        viewModel.droneBinding = viewModel.droneTracking().bind(to: self) { me, obj in
            let originAnnotations = me.mapView.annotations.filter { $0 is OriginAnnotation }
            if originAnnotations.count == 0 {
                guard let position = me.viewModel.order?.careProvider.geocode?.location else { return }
                let startAnnotation = OriginAnnotation(
                    title: "Origin",
                    coordinate: CLLocationCoordinate2D(
                        latitude: position.latitude,
                        longitude: position.longitude))
                me.mapView.addAnnotation(startAnnotation)
            }
            
            let destinationAnnotations = me.mapView.annotations.filter { $0 is DestinationAnnotation }
            if destinationAnnotations.count == 0 {
                let endAnnotation = DestinationAnnotation(
                    title: "Delivery point",
                    coordinate: CLLocationCoordinate2D(
                        latitude: deviceLatitude,
                        longitude: deviceLongitude))
                me.mapView.addAnnotation(endAnnotation)
                me.zoomToFitMapAnnotations()
            }
            
            let droneAnnotations = me.mapView.annotations.filter { $0 is DroneAnnotation }
            if droneAnnotations.count != 0 {
                let droneAnn = droneAnnotations[0]
                me.mapView.removeAnnotation(droneAnn)
            }
            
            if obj.currentLocation < obj.waypoints.count {
                let coord = obj.waypoints[obj.currentLocation]
                let droneAnnotation = DroneAnnotation(
                    title: me.viewModel.order!.drug.name,
                    coordinate: CLLocationCoordinate2D(
                        latitude: coord.latitude!,
                        longitude: coord.longitude!))
                me.mapView.addAnnotation(droneAnnotation)
                
                if obj.currentLocation == 0 {
                    let deadlineTime = DispatchTime.now() + .seconds(2)
                    DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                        me.viewModel.move(drone: obj)
                    }
                } else {
                    me.viewModel.move(drone: obj)
                }
            }
            
            if (obj.currentLocation + 1) == obj.waypoints.count {
                me.confirmButton.alpha = 1.0
                
                if destinationAnnotations.count > 0 {
                    me.mapView.removeAnnotation(destinationAnnotations[0])
                }
                
                let droneAnnotations2 = me.mapView.annotations.filter { $0 is DroneAnnotation }
                if droneAnnotations2.count != 0 {
                    let droneAnn = droneAnnotations2[0]
                    me.mapView.removeAnnotation(droneAnn)
                    
                    let droneAnnotation = DroneAnnotation(
                        title: me.viewModel.order!.drug.name,
                        coordinate: CLLocationCoordinate2D(
                            latitude: deviceLatitude,
                            longitude: deviceLongitude))
                    me.mapView.addAnnotation(droneAnnotation)
                }
            }
        }
    }
}

// MARK: - Map View Delegate

extension DrugDeliveryViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var identifier: String = ""
        if let _ = annotation as? DroneAnnotation {
            identifier = "drone"
        } else if let _ = annotation as? OriginAnnotation {
            identifier = "origin"
        } else if let _ = annotation as? DestinationAnnotation {
            identifier = "destination"
        }
        
        var view: MKMarkerAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        
        return view
    }
    
    func zoomToFitMapAnnotations() {
        if(mapView.annotations.count == 0) { return }
        
        var topLeftCoord = CLLocationCoordinate2D.init(latitude: -90, longitude: 180)
        var bottomRightCoord = CLLocationCoordinate2D.init(latitude: 90, longitude: -180)
        
        for i in 0..<mapView.annotations.count {
            let annotation = mapView.annotations[i]
            
            topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude)
            topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude)
            
            bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude)
            bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude)
        }
        
        let center = CLLocationCoordinate2D.init(
            latitude: topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5,
            longitude: topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5)
        
        let span = MKCoordinateSpan.init(
            latitudeDelta: fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.3,
            longitudeDelta: fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.3)
        
        var region = MKCoordinateRegion.init(center: center, span: span);
        region = mapView.regionThatFits(region)
        mapView.setRegion(region, animated: true)
    }
}

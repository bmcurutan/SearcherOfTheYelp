//
//  BusinessDetailsViewController.swift
//  Yelp
//
//  Created by Bianca Curutan on 10/23/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import MapKit
import UIKit

class BusinessDetailsViewController: UIViewController {
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingsImageView: UIImageView!
    @IBOutlet weak var reviewsCountLabel: UILabel!
    
    var business: Business!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addressLabel.text = business.address
        categoriesLabel.text = business.categories
        distanceLabel.text = business.distance
        nameLabel.text = business.name
        ratingsImageView.setImageWith(business.ratingImageURL!)
        reviewsCountLabel.text = "\(business.reviewCount!) Reviews"
        
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
        
        // Default location to business
        let centerLocation = CLLocation(latitude: business.latitude, longitude: business.longitude)
        goToLocation(location: centerLocation)
        
        let coordinate = CLLocationCoordinate2DMake(business.latitude, business.longitude)
        addAnnotationAtCoordinate(coordinate)
    }

    // MARK: - IBAction
    
    @IBAction func onBackButton(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Private Methods
    
    fileprivate func addAnnotationAtCoordinate(_ coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
    }
    
    fileprivate func goToLocation(location: CLLocation) {
        let span = MKCoordinateSpanMake(0.1, 0.1)
        let region = MKCoordinateRegionMake(location.coordinate, span)
        mapView.setRegion(region, animated: false)
    }
}

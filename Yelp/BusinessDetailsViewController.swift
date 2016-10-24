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
    
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingsImageView: UIImageView!
    @IBOutlet weak var reviewsCountLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var business: Business!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
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
    
    // MARK: - UITableViewDataSource
}

extension BusinessDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 1: // phone
            let cell = tableView.dequeueReusableCell(withIdentifier: "IconCell", for: indexPath) as! IconCell
            // cell.iconImageView
            cell.phoneLabel.text = business.phone
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath) as! LabelCell
            cell.addressLabel.text = business.address
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var count = 0
        if business.address != nil {
            count += 1
        }
        if business.phone != nil {
            count += 1
        }
        return count
    }
}

// MARK: - UITableViewDelegate

extension BusinessDetailsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselect row appearance after it has been selected
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

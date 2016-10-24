//
//  BusinessDetailsViewController.swift
//  Yelp
//
//  Created by Bianca Curutan on 10/23/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessDetailsViewController: UIViewController {
    
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingsImageView: UIImageView!
    @IBOutlet weak var reviewsCountLabel: UILabel!
    
    var business: Business!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        categoriesLabel.text = business.categories
        distanceLabel.text = business.distance
        nameLabel.text = business.name
        ratingsImageView.setImageWith(business.ratingImageURL!)
        reviewsCountLabel.text = "\(business.reviewCount!) Reviews"
        
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
    }

    // MARK: - IBAction
    
    @IBAction func onBackButton(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
}

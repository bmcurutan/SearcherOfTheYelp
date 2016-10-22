//
//  SearchSettings.swift
//  Yelp
//
//  Created by Bianca Curutan on 10/21/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class SearchSettings {
    
    var category: String?
    var deals: Bool?
    var distance: Int?
    var searchString: String?
    var sort: Int? // 0 = Best matched (Yelp default), 1 = Distance, 2 = Highest Rated
    
    final var maxDistance = 40000 // 40000 meters = 25 miles
    
    init() {
        category = String()
        deals = false
        distance = maxDistance
        searchString = "Restaurants"
        sort = 0
    }
}

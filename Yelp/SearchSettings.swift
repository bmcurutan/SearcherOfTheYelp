//
//  SearchSettings.swift
//  Yelp
//
//  Created by Bianca Curutan on 10/21/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

let maxDistance: Double = 40000

final class SearchSettings {
    
    static let sharedInstance = SearchSettings(categories: [], deals: false, distance: maxDistance, searchString: "Restaurants", sort: YelpSortMode.bestMatched)
    
    var categories: [String]!
    var deals: Bool!
    var distance: Double!
    var searchString: String!
    var sort: YelpSortMode!
    
    init(categories: [String]!, deals: Bool!, distance: Double!, searchString: String!, sort: YelpSortMode!) {
        self.categories = categories
        self.deals = deals
        self.distance = distance
        self.searchString = searchString
        self.sort = sort
    }
    
    // Reset filters to default values - this is the assumed behavior with a new search term
    func resetFiltersForNewSearch() {
        categories = []
        deals = false
        distance = maxDistance
        sort = YelpSortMode.bestMatched
    }
}

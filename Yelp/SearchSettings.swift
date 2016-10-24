//
//  SearchSettings.swift
//  Yelp
//
//  Created by Bianca Curutan on 10/21/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class SearchSettings {
    
    static let sharedInstance = SearchSettings(categories: [], deals: false, distance: 40000, searchString: "Restaurants", sort: YelpSortMode.bestMatched)
    
    var categories: [String]!
    var deals: Bool!
    var distance: Int!
    var searchString: String!
    var sort: YelpSortMode!
    
    init(categories: [String]!, deals: Bool!, distance: Int!, searchString: String!, sort: YelpSortMode!) {
        self.categories = categories
        self.deals = deals
        self.distance = distance
        self.searchString = searchString
        self.sort = sort
    }
    
    // Reset filters to default values - this is the assumed expected behavior when a new search term is used
    func resetFiltersForNewSearch() {
        categories = []
        deals = false
        distance = 40000
        sort = YelpSortMode.bestMatched
    }
}

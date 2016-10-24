//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import MapKit
import MBProgressHUD
import UIKit

class BusinessesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapListButton: UIBarButtonItem!
    
    var businesses: [Business] = []
    var searchBar: UISearchBar!
    
    // Infinite loading variables
    var isLoading = false
    var offset = 0
    final var limit = 20 // Default Yelp limit
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "Restaurants"
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        doSearch()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        tableView.isHidden = false
        
        // Default location to San Francisco
        let centerLocation = CLLocation(latitude: 37.785771, longitude: -122.406165)
        goToLocation(location: centerLocation)
        mapView.isHidden = true
        
        doSearch()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        
        if "filtersSegue" == segue.identifier {
            let filtersViewController = navigationController.topViewController as! FiltersViewController
            filtersViewController.delegate = self
            
        } else if "detailsSegue" == segue.identifier {
            let cell = sender as! BusinessCell
            let indexPath = tableView.indexPath(for: cell)
            let business = businesses[indexPath!.row]
            let detailsViewController = navigationController.topViewController as! BusinessDetailsViewController
            detailsViewController.business = business
            
        }
    }
    
    // MARK: - IBAction
    
    @IBAction func onMapListButton(_ sender: AnyObject) {
        tableView.isHidden = !tableView.isHidden
        mapView.isHidden = !mapView.isHidden
        
        if "Map" == mapListButton.title {
            mapListButton.title = "List"
        } else {
            mapListButton.title = "Map"
        }
    }
    
    // MARK: - Private Methods
    
    fileprivate func goToLocation(location: CLLocation) {
        let span = MKCoordinateSpanMake(0.1, 0.1)
        let region = MKCoordinateRegionMake(location.coordinate, span)
        mapView.setRegion(region, animated: false)
    }
    
    fileprivate func doSearch() {
        doSearchWithOffset(0)
    }
    
    fileprivate func doSearchWithOffset(_ offset: Int) {
    
        //TODO remove comment MBProgressHUD.showAdded(to: self.view, animated: true)
        
        SearchSettings.sharedInstance.resetFiltersForNewSearch()
        Business.searchWithTerm(term: SearchSettings.sharedInstance.searchString, sort: SearchSettings.sharedInstance.sort, categories: SearchSettings.sharedInstance.categories, deals: SearchSettings.sharedInstance.deals, distance: SearchSettings.sharedInstance.distance, offset: offset, completion: { (businesses: [Business]?, error: Error?) -> Void in
            
            for business in businesses! {
                self.businesses.append(business)
            }
            self.tableView.reloadData()
            
            /* Used for testing
            if let businesses = businesses {
                for business in businesses {
                    print(business.name!)
                    print(business.address!)
                }
            }*/
            
            MBProgressHUD.hideAllHUDs(for: self.view, animated: true);
            self.isLoading = false
        })
    }
}

// MARK: - UITableViewDataSource

extension BusinessesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (businesses.count > 0 ? businesses.count : 1)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if businesses.count > 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as! BusinessCell
            cell.business = businesses[indexPath.row]
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BlankCell", for: indexPath)
            cell.textLabel?.text = "No Results Found"
            return cell
        }
    }
}

// MARK: - FiltersViewControllerDelegate

extension BusinessesViewController: FiltersViewControllerDelegate {
    
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: SearchSettings) {
        
        let sort = SearchSettings.sharedInstance.sort
        let deals = SearchSettings.sharedInstance.deals
        let distance = SearchSettings.sharedInstance.distance
        let categories = SearchSettings.sharedInstance.categories
        
        Business.searchWithTerm(term: "Restaurants", sort: sort, categories: categories, deals: deals, distance: distance, completion: { (businesses: [Business]?, error: Error?) -> Void in
            self.businesses = businesses!
            self.tableView.reloadData()
        })
    }
}

// MARK: - UISearchBarDelegate

extension BusinessesViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true;
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        return true;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        SearchSettings.sharedInstance.searchString = searchBar.text
        searchBar.resignFirstResponder()
        doSearch()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if "" == searchText {
            SearchSettings.sharedInstance.searchString = "Restaurants"
            searchBar.resignFirstResponder()
            doSearch()
        }
    }
}

// MARK: - UITableViewDelegate

extension BusinessesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselect row appearance after it has been selected
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UIScrollViewDelegate

extension BusinessesViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                isLoading = true
                offset += limit
                
                doSearchWithOffset(offset)
            }
        }
    }
}

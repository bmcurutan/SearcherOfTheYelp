//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import MBProgressHUD
import UIKit

class BusinessesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
  
    var businesses: [Business]!
    var isLoading = false
    var searchBar: UISearchBar!
    
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
            
            if let businesses = self.businesses {
                let business = businesses[indexPath!.row]
                let detailsViewController = navigationController.topViewController as! BusinessDetailsViewController
                detailsViewController.business = business
            }
        }
    }
    
    // MARK: - Private Methods
    
    fileprivate func doSearch() {
        doSearchWithOffset(nil, limit: nil)
    }
    
    fileprivate func doSearchWithOffset(_ offset: Int, limit: Int) {
    
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        SearchSettings.sharedInstance.resetFiltersForNewSearch()
        Business.searchWithTerm(term: SearchSettings.sharedInstance.searchString, sort: SearchSettings.sharedInstance.sort, categories: SearchSettings.sharedInstance.categories, deals: SearchSettings.sharedInstance.deals, distance: SearchSettings.sharedInstance.distance, offset: offset, limit: limit, completion: { (businesses: [Business]?, error: Error?) -> Void in
            self.businesses = businesses
            self.tableView.reloadData()
            
            if let businesses = businesses {
                for business in businesses {
                    print(business.name!)
                    print(business.address!)
                }
            }
            
            MBProgressHUD.hideAllHUDs(for: self.view, animated: true);
        })
    }
}

// MARK: - UITableViewDataSource

extension BusinessesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businesses?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as! BusinessCell
        cell.business = businesses[indexPath.row]
        return cell
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
            self.businesses = businesses
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
                
                doSearch
            }
        }
    }
}

//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Bianca Curutan on 10/20/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

enum FilterSection: Int {
    case deals = 0, distance, sort, categories
}

protocol FiltersViewControllerDelegate: class {
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: SearchSettings)
}

class FiltersViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    weak var delegate: FiltersViewControllerDelegate?
    
    // List variables
    var categories: [[String:String]]!
    var distances: [[String:AnyObject]]!
    var sorts: [[String:AnyObject]]!
    
    // State variables
    var deals: Bool = false
    var distanceStates: [Int:Bool] = [0: true] // Default to Auto
    var sortStates: [Int:Bool] = [0: true] // Default to Best Matched
    var categoryStates = [Int:Bool]()
    
    // Expand variables
    var distanceExpanded: Bool = false
    var sortExpanded: Bool = false
    var categoriesExpanded: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        distances = yelpDistances()
        sorts = yelpSorts()
        categories = yelpCategories()
    }
    // MARK - IBAction
    
    @IBAction func onCancelButton(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func onSearchButton(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
        
        // Deals
        SearchSettings.sharedInstance.deals = deals
        
        // Sort
        SearchSettings.sharedInstance.sort = YelpSortMode.bestMatched
        for (row, isSelected) in sortStates {
            if isSelected {
                SearchSettings.sharedInstance.sort = sorts[row]["sort"] as! YelpSortMode
                break
            }
        }

        // Distance 
        SearchSettings.sharedInstance.distance = maxDistance
        for (row, isSelected) in distanceStates {
            if isSelected {
                SearchSettings.sharedInstance.distance = distances[row]["meters"] as! Double
                break
            }
        }
        
        // Categories
        var selectedCategories = [String]()
        for (row, isSelected) in categoryStates {
            if isSelected {
                selectedCategories.append(categories[row]["code"]!)
            }
        }

        if selectedCategories.count > 0 {
            SearchSettings.sharedInstance.categories = selectedCategories
        }
        
        delegate?.filtersViewController(filtersViewController: self, didUpdateFilters: SearchSettings.sharedInstance)
    }
    
    // MARK: - Private Methods
    
    fileprivate func yelpSorts() -> [[String:AnyObject]] {
        return [["name" : "Best Matched" as AnyObject, "sort" : YelpSortMode.bestMatched as AnyObject],
                ["name" : "Distance" as AnyObject, "sort" : YelpSortMode.distance as AnyObject],
                ["name" : "Highest Rated" as AnyObject, "sort" : YelpSortMode.highestRated as AnyObject]]
    }
    
    // Approximate distances in meters, converted from miles
    fileprivate func yelpDistances() -> [[String:AnyObject]] {
        let metersPerMile = 1/0.000621371
        return [["name" : "Auto" as AnyObject, "meters" : maxDistance as AnyObject],
                ["name" : "0.3 miles" as AnyObject, "meters" : 0.3 * metersPerMile as AnyObject],
                ["name" : "1 mile" as AnyObject, "meters" : metersPerMile as AnyObject],
                ["name" : "5 miles" as AnyObject, "meters" : 5 * metersPerMile as AnyObject],
                ["name" : "20 miles" as AnyObject, "meters" : 20 * metersPerMile as AnyObject]]
    }
    
    fileprivate func yelpCategories() -> [[String:String]] {
        let categories = [["name" : "Afghan", "code": "afghani"],
                          ["name" : "African", "code": "african"],
                          ["name" : "American, New", "code": "newamerican"],
                          ["name" : "American, Traditional", "code": "tradamerican"],
                          ["name" : "Arabian", "code": "arabian"],
                          ["name" : "Argentine", "code": "argentine"],
                          ["name" : "Armenian", "code": "armenian"],
                          ["name" : "Asian Fusion", "code": "asianfusion"],
                          ["name" : "Asturian", "code": "asturian"],
                          ["name" : "Australian", "code": "australian"],
                          ["name" : "Austrian", "code": "austrian"],
                          ["name" : "Baguettes", "code": "baguettes"],
                          ["name" : "Bangladeshi", "code": "bangladeshi"],
                          ["name" : "Barbeque", "code": "bbq"],
                          ["name" : "Basque", "code": "basque"],
                          ["name" : "Bavarian", "code": "bavarian"],
                          ["name" : "Beer Garden", "code": "beergarden"],
                          ["name" : "Beer Hall", "code": "beerhall"],
                          ["name" : "Beisl", "code": "beisl"],
                          ["name" : "Belgian", "code": "belgian"],
                          ["name" : "Bistros", "code": "bistros"],
                          ["name" : "Black Sea", "code": "blacksea"],
                          ["name" : "Brasseries", "code": "brasseries"],
                          ["name" : "Brazilian", "code": "brazilian"],
                          ["name" : "Breakfast & Brunch", "code": "breakfast_brunch"],
                          ["name" : "British", "code": "british"],
                          ["name" : "Buffets", "code": "buffets"],
                          ["name" : "Bulgarian", "code": "bulgarian"],
                          ["name" : "Burgers", "code": "burgers"],
                          ["name" : "Burmese", "code": "burmese"],
                          ["name" : "Cafes", "code": "cafes"],
                          ["name" : "Cafeteria", "code": "cafeteria"],
                          ["name" : "Cajun/Creole", "code": "cajun"],
                          ["name" : "Cambodian", "code": "cambodian"],
                          ["name" : "Canadian", "code": "New)"],
                          ["name" : "Canteen", "code": "canteen"],
                          ["name" : "Caribbean", "code": "caribbean"],
                          ["name" : "Catalan", "code": "catalan"],
                          ["name" : "Chech", "code": "chech"],
                          ["name" : "Cheesesteaks", "code": "cheesesteaks"],
                          ["name" : "Chicken Shop", "code": "chickenshop"],
                          ["name" : "Chicken Wings", "code": "chicken_wings"],
                          ["name" : "Chilean", "code": "chilean"],
                          ["name" : "Chinese", "code": "chinese"],
                          ["name" : "Comfort Food", "code": "comfortfood"],
                          ["name" : "Corsican", "code": "corsican"],
                          ["name" : "Creperies", "code": "creperies"],
                          ["name" : "Cuban", "code": "cuban"],
                          ["name" : "Curry Sausage", "code": "currysausage"],
                          ["name" : "Cypriot", "code": "cypriot"],
                          ["name" : "Czech", "code": "czech"],
                          ["name" : "Czech/Slovakian", "code": "czechslovakian"],
                          ["name" : "Danish", "code": "danish"],
                          ["name" : "Delis", "code": "delis"],
                          ["name" : "Diners", "code": "diners"],
                          ["name" : "Dumplings", "code": "dumplings"],
                          ["name" : "Eastern European", "code": "eastern_european"],
                          ["name" : "Ethiopian", "code": "ethiopian"],
                          ["name" : "Fast Food", "code": "hotdogs"],
                          ["name" : "Filipino", "code": "filipino"],
                          ["name" : "Fish & Chips", "code": "fishnchips"],
                          ["name" : "Fondue", "code": "fondue"],
                          ["name" : "Food Court", "code": "food_court"],
                          ["name" : "Food Stands", "code": "foodstands"],
                          ["name" : "French", "code": "french"],
                          ["name" : "French Southwest", "code": "sud_ouest"],
                          ["name" : "Galician", "code": "galician"],
                          ["name" : "Gastropubs", "code": "gastropubs"],
                          ["name" : "Georgian", "code": "georgian"],
                          ["name" : "German", "code": "german"],
                          ["name" : "Giblets", "code": "giblets"],
                          ["name" : "Gluten-Free", "code": "gluten_free"],
                          ["name" : "Greek", "code": "greek"],
                          ["name" : "Halal", "code": "halal"],
                          ["name" : "Hawaiian", "code": "hawaiian"],
                          ["name" : "Heuriger", "code": "heuriger"],
                          ["name" : "Himalayan/Nepalese", "code": "himalayan"],
                          ["name" : "Hong Kong Style Cafe", "code": "hkcafe"],
                          ["name" : "Hot Dogs", "code": "hotdog"],
                          ["name" : "Hot Pot", "code": "hotpot"],
                          ["name" : "Hungarian", "code": "hungarian"],
                          ["name" : "Iberian", "code": "iberian"],
                          ["name" : "Indian", "code": "indpak"],
                          ["name" : "Indonesian", "code": "indonesian"],
                          ["name" : "International", "code": "international"],
                          ["name" : "Irish", "code": "irish"],
                          ["name" : "Island Pub", "code": "island_pub"],
                          ["name" : "Israeli", "code": "israeli"],
                          ["name" : "Italian", "code": "italian"],
                          ["name" : "Japanese", "code": "japanese"],
                          ["name" : "Jewish", "code": "jewish"],
                          ["name" : "Kebab", "code": "kebab"],
                          ["name" : "Korean", "code": "korean"],
                          ["name" : "Kosher", "code": "kosher"],
                          ["name" : "Kurdish", "code": "kurdish"],
                          ["name" : "Laos", "code": "laos"],
                          ["name" : "Laotian", "code": "laotian"],
                          ["name" : "Latin American", "code": "latin"],
                          ["name" : "Live/Raw Food", "code": "raw_food"],
                          ["name" : "Lyonnais", "code": "lyonnais"],
                          ["name" : "Malaysian", "code": "malaysian"],
                          ["name" : "Meatballs", "code": "meatballs"],
                          ["name" : "Mediterranean", "code": "mediterranean"],
                          ["name" : "Mexican", "code": "mexican"],
                          ["name" : "Middle Eastern", "code": "mideastern"],
                          ["name" : "Milk Bars", "code": "milkbars"],
                          ["name" : "Modern Australian", "code": "modern_australian"],
                          ["name" : "Modern European", "code": "modern_european"],
                          ["name" : "Mongolian", "code": "mongolian"],
                          ["name" : "Moroccan", "code": "moroccan"],
                          ["name" : "New Zealand", "code": "newzealand"],
                          ["name" : "Night Food", "code": "nightfood"],
                          ["name" : "Norcinerie", "code": "norcinerie"],
                          ["name" : "Open Sandwiches", "code": "opensandwiches"],
                          ["name" : "Oriental", "code": "oriental"],
                          ["name" : "Pakistani", "code": "pakistani"],
                          ["name" : "Parent Cafes", "code": "eltern_cafes"],
                          ["name" : "Parma", "code": "parma"],
                          ["name" : "Persian/Iranian", "code": "persian"],
                          ["name" : "Peruvian", "code": "peruvian"],
                          ["name" : "Pita", "code": "pita"],
                          ["name" : "Pizza", "code": "pizza"],
                          ["name" : "Polish", "code": "polish"],
                          ["name" : "Portuguese", "code": "portuguese"],
                          ["name" : "Potatoes", "code": "potatoes"],
                          ["name" : "Poutineries", "code": "poutineries"],
                          ["name" : "Pub Food", "code": "pubfood"],
                          ["name" : "Rice", "code": "riceshop"],
                          ["name" : "Romanian", "code": "romanian"],
                          ["name" : "Rotisserie Chicken", "code": "rotisserie_chicken"],
                          ["name" : "Rumanian", "code": "rumanian"],
                          ["name" : "Russian", "code": "russian"],
                          ["name" : "Salad", "code": "salad"],
                          ["name" : "Sandwiches", "code": "sandwiches"],
                          ["name" : "Scandinavian", "code": "scandinavian"],
                          ["name" : "Scottish", "code": "scottish"],
                          ["name" : "Seafood", "code": "seafood"],
                          ["name" : "Serbo Croatian", "code": "serbocroatian"],
                          ["name" : "Signature Cuisine", "code": "signature_cuisine"],
                          ["name" : "Singaporean", "code": "singaporean"],
                          ["name" : "Slovakian", "code": "slovakian"],
                          ["name" : "Soul Food", "code": "soulfood"],
                          ["name" : "Soup", "code": "soup"],
                          ["name" : "Southern", "code": "southern"],
                          ["name" : "Spanish", "code": "spanish"],
                          ["name" : "Steakhouses", "code": "steak"],
                          ["name" : "Sushi Bars", "code": "sushi"],
                          ["name" : "Swabian", "code": "swabian"],
                          ["name" : "Swedish", "code": "swedish"],
                          ["name" : "Swiss Food", "code": "swissfood"],
                          ["name" : "Tabernas", "code": "tabernas"],
                          ["name" : "Taiwanese", "code": "taiwanese"],
                          ["name" : "Tapas Bars", "code": "tapas"],
                          ["name" : "Tapas/Small Plates", "code": "tapasmallplates"],
                          ["name" : "Tex-Mex", "code": "tex-mex"],
                          ["name" : "Thai", "code": "thai"],
                          ["name" : "Traditional Norwegian", "code": "norwegian"],
                          ["name" : "Traditional Swedish", "code": "traditional_swedish"],
                          ["name" : "Trattorie", "code": "trattorie"],
                          ["name" : "Turkish", "code": "turkish"],
                          ["name" : "Ukrainian", "code": "ukrainian"],
                          ["name" : "Uzbek", "code": "uzbek"],
                          ["name" : "Vegan", "code": "vegan"],
                          ["name" : "Vegetarian", "code": "vegetarian"],
                          ["name" : "Venison", "code": "venison"],
                          ["name" : "Vietnamese", "code": "vietnamese"],
                          ["name" : "Wok", "code": "wok"],
                          ["name" : "Wraps", "code": "wraps"],
                          ["name" : "Yugoslav", "code": "yugoslav"]]
        return categories
    }
}

// MARK: - UITableViewDataSource

extension FiltersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch FilterSection(rawValue:indexPath.section)! {
        case FilterSection.deals:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
            cell.switchLabel.text = "Offering a Deal"
            cell.delegate = self
            cell.onSwitch.isOn = false
            return cell
            
        case FilterSection.distance:
            if !distanceExpanded && 0 == indexPath.row {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DropdownCell", for: indexPath) as! DropdownCell
                for (row, isSelected) in distanceStates {
                    if isSelected {
                        cell.dropdownLabel.text = distances[row]["name"] as? String
                        break
                    }
                }
                return cell
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
            cell.switchLabel.text = distances[indexPath.row]["name"] as? String
            cell.delegate = self
            cell.onSwitch.isOn = distanceStates[indexPath.row] ?? false
            return cell
            
        case FilterSection.sort:
            if !sortExpanded && 0 == indexPath.row {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DropdownCell", for: indexPath) as! DropdownCell
                for (row, isSelected) in sortStates {
                    if isSelected {
                        cell.dropdownLabel.text = sorts[row]["name"] as? String
                        break
                    }
                }
                return cell
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
            cell.switchLabel.text = sorts[indexPath.row]["name"] as? String
            cell.delegate = self
            cell.onSwitch.isOn = sortStates[indexPath.row] ?? false
            return cell
            
        case FilterSection.categories:
            if !categoriesExpanded && 4 == indexPath.row {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SeeAllCell", for: indexPath)
                return cell
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
            cell.switchLabel.text = categories[indexPath.row]["name"]
            cell.delegate = self
            cell.onSwitch.isOn = categoryStates[indexPath.row] ?? false
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch FilterSection(rawValue: section)! {
        case FilterSection.distance:
            return (distanceExpanded ? distances.count : 1)
        case FilterSection.sort:
            return (sortExpanded ? sorts.count : 1)
        case FilterSection.categories:
            return (categoriesExpanded ? categories.count : 5)
        case FilterSection.deals:
            return 1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch FilterSection(rawValue: section)! {
        case FilterSection.distance:
            return "Distance"
        case FilterSection.sort:
            return "Sort By"
        case FilterSection.categories:
            return "Category"
        default: // FilterSection.deals
            return nil
        }
    }
}

// MARK: - UITableViewDelegate

extension FiltersViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if nil != self.tableView(tableView, titleForHeaderInSection: section) {
            return 45
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselect row appearance after it has been selected
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell = self.tableView(tableView, cellForRowAt: indexPath)
        if "SeeAllCell" == cell.reuseIdentifier {
            categoriesExpanded = true
            tableView.reloadSections(NSIndexSet(index: FilterSection.categories.rawValue) as IndexSet, with: .none)
            
        } else if "DropdownCell" == cell.reuseIdentifier {
            switch FilterSection(rawValue:indexPath.section)! {
            case FilterSection.distance:
                distanceExpanded = true
                tableView.reloadSections(NSIndexSet(index: FilterSection.distance.rawValue) as IndexSet, with: .none)
            case FilterSection.sort:
                sortExpanded = true
                tableView.reloadSections(NSIndexSet(index: FilterSection.sort.rawValue) as IndexSet, with: .none)
            default:
                break
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if nil != self.tableView(tableView, titleForHeaderInSection: section) {
            let headerView = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.view.frame.width, height: 45)))
            let label = UILabel(frame: CGRect(x: 0, y: 10, width: self.view.frame.width, height: 30))
            label.text = self.tableView(tableView, titleForHeaderInSection: section)
            headerView.addSubview(label)
            return headerView
        }
        return nil
    }
}

// MARK: - SwitchCellDelegate

extension FiltersViewController: SwitchCellDelegate {
    
    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
        let indexPath = tableView.indexPath(for: switchCell)!
        
        switch FilterSection(rawValue:indexPath.section)! {
        case FilterSection.deals:
            deals = value
            
        case FilterSection.distance:
            distanceStates = [Int:Bool]() // Reset distance states
            distanceStates[indexPath.row] = value
            distanceExpanded = false
            tableView.reloadSections(NSIndexSet(index: FilterSection.distance.rawValue) as IndexSet, with: .none)
            
        case FilterSection.sort:
            sortStates = [Int:Bool]() // Reset sort states
            sortStates[indexPath.row] = value
            sortExpanded = false
            tableView.reloadSections(NSIndexSet(index: FilterSection.sort.rawValue) as IndexSet, with: .none)
            
        case FilterSection.categories:
            categoryStates[indexPath.row] = value
        }
    }
}

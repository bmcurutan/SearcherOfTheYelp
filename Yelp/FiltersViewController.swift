//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Bianca Curutan on 10/20/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

// TODO
/*enum FilterSection: Int {
    case deals = 0
    case distance
    case sort
    case category
}*/

@objc protocol FiltersViewControllerDelegate {
    @objc optional func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String:AnyObject])
}

class FiltersViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    weak var delegate: FiltersViewControllerDelegate?
    
    var categories: [[String:String]]!
    var switchStates = [Int:Bool]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        categories = yelpCategories()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK - IBAction
    
    @IBAction func onCancelButton(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func onSearchButton(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
        var filters = [String:AnyObject]()
        
        var selectedCategories = [String]()
        for (row, isSelected) in switchStates {
            if isSelected {
                selectedCategories.append(categories[row]["code"]!)
            }
        }
        
        if selectedCategories.count > 0 {
            filters["categories"] = selectedCategories as AnyObject?
        }
        
        delegate?.filtersViewController?(filtersViewController: self, didUpdateFilters: filters)
    }
    
    // MARK: - Private Methods
    
    // For convenience, these are the top level Restaurant categories for the Yelp API
    // https://www.yelp.ca/developers/documentation/v2/category_list
    fileprivate func yelpCategories() -> [[String:String]] {
        return [
            ["name": "Afghan", "code": "afghani"],
            ["name": "African", "code": "african"],
            ["name": "American (Traditional)", "code": "tradamerican"],
            ["name": "Arabian", "code": "arabian"],
            ["name": "Argentine", "code": "argentine"],
            ["name": "Asian Fusion", "code": "asianfusion"],
            ["name": "Australian", "code": "australian"],
            ["name": "Austrian", "code": "austrian"],
            
            ["name": "Bangladeshi", "code": "bangladeshi"],
            ["name": "Barbeque", "code": "bbq"],
            ["name": "Basque", "code": "basque"],
            ["name": "Belgian", "code": "belgian"],
            ["name": "Bistros", "code": "bistros"],
            ["name": "Brasseries", "code": "brasseries"],
            ["name": "Brazilian", "code": "brazilian"],
            ["name": "Breakfast & Brunch", "code": "breakfast_brunch"],
            ["name": "British", "code": "british"],
            ["name": "Buffets", "code": "buffets"],
            ["name": "Burgers", "code": "burgers"],
            ["name": "Burmese", "code": "burmese"],
            
            ["name": "Cafes", "code": "cafes"],
            ["name": "Cambodian", "code": "cambodian"],
            ["name": "Canadian (New)", "code": "newcanadian"],
            ["name": "Caribbean", "code": "caribbean"],
            ["name": "Cheesesteaks", "code": "cheesesteaks"],
            ["name": "Chicken Shop", "code": "chickenshop"],
            ["name": "Chicken Wings", "code": "chicken_wings"],
            ["name": "Chinese", "code": "chinese"],
            ["name": "Comfort Food", "code": "comfortfood"],
            ["name": "Creperies", "code": "creperies"],
            ["name": "Cuban", "code": "cuban"],
            ["name": "Czech", "code": "czech"],
            
            ["name": "Delis", "code": "delis"],
            ["name": "Diners", "code": "diners"],
            ["name": "Dinner Theater", "code": "dinnertheater"],
            ["name": "Ethiopian", "code": "ethiopian"],
            
            ["name": "Fast Food", "code": "hotdogs"],
            ["name": "Filipino", "code": "filipino"],
            ["name": "Fish & Chips", "code": "fishnchips"],
            ["name": "Fondue", "code": "fondue"],
            ["name": "Food Court", "code": "food_court"],
            

             ()
             ()
             ()
             ()
             ()
             ()
             ()
             ()
             ()
             ()
            Food Stands (foodstands)
            French (french)

            Gastropubs (gastropubs)
            German (german)
            Gluten-Free (gluten_free)
            Greek (greek)
            Halal (halal)
            Hawaiian (hawaiian)
            Himalayan/Nepalese (himalayan)
            Hot Dogs (hotdog)
            Hot Pot (hotpot)
            Hungarian (hungarian)
            Iberian (iberian)
            Indian (indpak)
            Indonesian (indonesian)
            International (international)
            Irish (irish)
            Italian (italian)
            Japanese (japanese)
            
            Korean (korean)
            Kosher (kosher)
            Laotian (laotian)
            Latin American (latin)
            
            Live/Raw Food (raw_food)
            Malaysian (malaysian)
            Mediterranean (mediterranean)
            
            Mexican (mexican)
            Middle Eastern (mideastern)
            Modern European (modern_european)
            Mongolian (mongolian)
            Moroccan (moroccan)
            Nicaraguan (nicaraguan)
            Noodles (noodles)
            Pakistani (pakistani)
            Pan Asian (panasian)
            Persian/Iranian (persian)
            Peruvian (peruvian)
            Pizza (pizza)
            Polish (polish)
            Portuguese (portuguese)
            Poutineries (poutineries)
            Russian (russian)
            Salad (salad)
            Sandwiches (sandwiches)
            Scandinavian (scandinavian)
            Scottish (scottish)
            Seafood (seafood)
            Singaporean (singaporean)
            Slovakian (slovakian)
            Soul Food (soulfood)
            Soup (soup)
            Southern (southern)
            Spanish (spanish)
            Sri Lankan (srilankan)
            Steakhouses (steak)
            Supper Clubs (supperclubs)
            Sushi Bars (sushi)
            Syrian (syrian)
            Taiwanese (taiwanese)
            Tapas Bars (tapas)
            Tapas/Small Plates (tapasmallplates)
            Tex-Mex (tex-mex)
            Thai (thai)
            Turkish (turkish)
            Ukrainian (ukrainian)
            Vegan (vegan)
            Vegetarian (vegetarian)
            Vietnamese (vietnamese)
            Waffles (waffles)
                    ]
    }
}

extension FiltersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.section) {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
            cell.switchLabel.text = "Offering a Deal"
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DropdownCell", for: indexPath) as! DropdownCell
            cell.dropdownLabel.text = "Auto"
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DropdownCell", for: indexPath) as! DropdownCell
            cell.dropdownLabel.text = "Best Match"
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
            cell.switchLabel.text = categories[indexPath.row]["name"]
            cell.delegate = self
            cell.onSwitch.isOn = switchStates[indexPath.row] ?? false
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section) {
        case 3:
            return categories.count
        default:
            return 1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch (section) {
        case 1:
            return "Distance"
        case 2:
            return "Sort By"
        case 3:
            return "Category"
        default:
            return ""
        }
    }
}

extension FiltersViewController: SwitchCellDelegate {
    
    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
        let indexPath = tableView.indexPath(for: switchCell)!
        
        switchStates[indexPath.row] = value
    }
}

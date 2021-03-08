//
//  CitiesListController.swift
//  SalamBro
//
//  Created by Arystan on 3/7/21.
//

import UIKit

class CitiesListController: UIViewController {
    
    var countryId: Int = 0
    
    fileprivate lazy var rootView = CitiesListView(delegate: self)
    fileprivate lazy var selectionIndexPath: IndexPath? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
    }
    
    override func loadView() {
        view = rootView
    }
}

extension CitiesListController: CitiesListViewDelegate {
    func test() {
        print("f")
    }
    
    
}

extension CitiesListController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities[countryId].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = cities[countryId][indexPath.row]
        cell.tintColor = .kexRed
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectionIndexPath != nil {
            if selectionIndexPath == indexPath {
                print("proceed to next view")
                let vc = AddressController()
                selectionIndexPath = nil
                navigationController?.pushViewController(vc, animated: true)
            } else {
                print(selectionIndexPath!.row)
                selectionIndexPath = indexPath
                let cell = tableView.cellForRow(at: selectionIndexPath!)
                cell?.accessoryType = .checkmark
            }
        } else {
            selectionIndexPath = indexPath
            let cell = tableView.cellForRow(at: selectionIndexPath!)
            cell?.accessoryType = .checkmark
        }
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .none
    }
}

extension CitiesListController {
    private func configUI() {
        navigationItem.title = "Choose your city"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}

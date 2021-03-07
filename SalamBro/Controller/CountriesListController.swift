//
//  CountriesViewController.swift
//  SalamBro
//
//  Created by Arystan on 3/7/21.
//

import UIKit

class CountriesListController: UIViewController {
    
    fileprivate lazy var rootView = CountriesListView(delegate: self)
    fileprivate lazy var selectionIndexPath: IndexPath? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func loadView() {
        view = rootView
    }
    
    func setupViews() {
        navigationItem.title = "Choose your country"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
//  FIXME: -BUG should deselect after returning back to country select?
//    override func viewWillAppear(_ animated: Bool) {
//        print(selectionIndexPath)
//        if selectionIndexPath != nil {
//            self.tableView.deselectRow(at: selectionIndexPath!, animated: true)
//        }
//    }
}

//MARK: - UITableView
extension CountriesListController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = countries[indexPath.row]
        cell.backgroundColor = .white
        cell.tintColor = .kexRed
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectionIndexPath != nil {
            if selectionIndexPath == indexPath {
                print("next page")
//                let vc = CitiesController()
//                vc.countryId = indexPath.row
//                selectionIndexPath = nil
//                self.navigationController?.pushViewController(vc, animated: true)
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

extension CountriesListController: CountriesListViewDelegate {
    func updateList() {
        print("update list...")
    }
}

//
//  CountryCodePickerViewController.swift
//  SalamBro
//
//  Created by Arystan on 3/13/21.
//

import UIKit

protocol CountryCodePickerDelegate: AnyObject {
    func passCountry(country: Country)
}

class CountryCodePickerViewController: UIViewController {
    
    fileprivate lazy var selectionIndexPath: IndexPath? = nil
    
    var countryViewModel : CountryViewModel!
    var viewTranslation = CGPoint(x: 0, y: 0)
    
    weak var delegate: CountryCodePickerDelegate? = nil
    
    lazy var lineImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "line")
        view.tintColor = .darkGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 18)
        label.text = L10n.CountryCodePicker.Navigation.title
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var citiesTableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.tableFooterView = UIView()
        table.allowsMultipleSelection = false
        table.separatorInset.right = table.separatorInset.left + table.separatorInset.left
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    override func viewDidLoad() {

        callToViewModelForUIUpdate()
        super.viewDidLoad()

        configUI()
        setupViews()
        setupConstraints()
    }
    
    func callToViewModelForUIUpdate(){
        self.updateDataSource()
    }
    
    public func reloadData() {
        citiesTableView.reloadData()
    }
    
    func updateDataSource(){
        DispatchQueue.main.async {
            self.citiesTableView.delegate = self
            self.citiesTableView.dataSource = self
            self.reloadData()
        }
    }
    
    
}

//MARK: - UITableView
extension CountryCodePickerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryViewModel.numberOfCountries()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = countryViewModel.countryArray[indexPath.row].name + "   " +  countryViewModel.countryArray[indexPath.row].callingCode
        if countryViewModel.countryArray[indexPath.row].marked {
            cell.accessoryType = .checkmark
        } else {
            cell .accessoryType = .none
        }
        cell.backgroundColor = .white
        cell.tintColor = .kexRed
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
        countryViewModel.unmarkAll()
        countryViewModel.countryArray[indexPath.row].marked.toggle()
        dismiss(animated: true) {
            self.delegate?.passCountry(country: self.countryViewModel.countryArray[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .none
    }
    
}

extension CountryCodePickerViewController {
    private func configUI() {
        navigationItem.title = L10n.CountryCodePicker.Navigation.title
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}



extension CountryCodePickerViewController {
    func setupViews() {
        view.backgroundColor = .white
        view.addSubview(lineImage)
        view.addSubview(titleLabel)
        view.addSubview(citiesTableView)
    }
    
    func setupConstraints() {
        
        lineImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 6).isActive = true
        lineImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        lineImage.heightAnchor.constraint(equalToConstant: 6).isActive = true
        lineImage.widthAnchor.constraint(equalToConstant: 36).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: lineImage.safeAreaLayoutGuide.bottomAnchor, constant: 12).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        citiesTableView.topAnchor.constraint(equalTo: titleLabel.safeAreaLayoutGuide.bottomAnchor, constant: 22).isActive = true
        citiesTableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        citiesTableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        citiesTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}


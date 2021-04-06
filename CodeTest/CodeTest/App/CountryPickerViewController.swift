//
//  CountryPickerViewController.swift
//  CodeTest
//
//  Created by Jasmin Nišić on 06.04.21.
//  Copyright © 2021 Emmanuel Garnier. All rights reserved.
//

import UIKit

protocol CountryPickerDelegate: class {
    
    func didPickCountry(iso: String)
    
}

class CountryPickerViewController: UITableViewController {

    struct Country {
        var iso: String
        var name: String
    }
    
    private var countries: [Country] = [
        Country(iso: "SE", name: "Sweden"),
        Country(iso: "DE", name: "Germany"),
        Country(iso: "NO", name: "Norway")
    ]
    
    private weak var delegate: CountryPickerDelegate?
    private var preselectedCountryIso: String?
    
    static func create(delegate: CountryPickerDelegate, preselectedCountry: String?) -> UIViewController {
        let viewController = CountryPickerViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        viewController.title = "Select a country"
        navigationController.modalPresentationStyle = .fullScreen
        viewController.delegate = delegate
        viewController.preselectedCountryIso = preselectedCountry
        return navigationController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countries.sort { (c1, c2) -> Bool in
            return c1.name < c2.name
        }
        configUI()
    }
    
    private func configUI() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(close))
    }
    
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        cell.textLabel?.text = countries[indexPath.row].name
        cell.accessoryType = countries[indexPath.row].iso == preselectedCountryIso ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didPickCountry(iso: countries[indexPath.row].iso)
        dismiss(animated: true, completion: nil)
    }
}

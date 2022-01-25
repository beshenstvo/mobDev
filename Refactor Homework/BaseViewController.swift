//
//  ViewController.swift
//  Refactor Homework
//
//  Created by Kirill Varshamov on 20.11.2021.
//

import UIKit

class BaseViewController: UIViewController {
    
    let networkService = NetworkServiceMock()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(BaseCell.self, forCellReuseIdentifier: BaseCell.cellID)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }

    func configure() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Modules"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 44.0
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

}

extension BaseViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BaseCell.cellID, for: indexPath) as? BaseCell else {
            fatalError("Cell must exists")
        }
        
        var cellTitle = ""
        switch indexPath.row {
        case 0:
            cellTitle = "Authorization"
        case 1:
            cellTitle = "Bonus"
        case 2:
            cellTitle = "Call"
        default:
            break
        }
        
        cell.configure(title: cellTitle)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            let phoneBuilder = PhoneBuilder(networkService: NetworkServiceMock())
            let phoneVC = phoneBuilder.build()
//            let phoneEditVC = PhoneEditViewController(networkService: networkService)
            navigationController?.pushViewController(phoneVC, animated: true)
        case 1:
            let bonusBuilder = BonusBuilder(networkService: NetworkServiceMock())
            let bonusVC = bonusBuilder.build()
//            let bonusVC = BonusViewController(networkService: networkService)
            navigationController?.pushViewController(bonusVC, animated: true)
        case 2:
            let callBuilder = CallBuilder(networkService: NetworkServiceMock())
            let callVC = callBuilder.build()
            present(callVC, animated: true, completion: nil)
        default:
            break
        }
    }
}


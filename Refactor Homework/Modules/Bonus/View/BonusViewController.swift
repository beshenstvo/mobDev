//
//  BonusViewController.swift
//

import UIKit

protocol BonusView: AnyObject {
    func setupView()
    func layoutView()
    
    func stopActivityIndicator()
    func updateBonusBalance(_ balance: String)
    func getBonusText(_ text: String)
}

final class BonusViewController: UIViewController {

    let presenter: BonusProtocol
    init(presenter: BonusProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    let activityIndicator = UIActivityIndicatorView(style: .large)
    
    let bonusTitle: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Баланс бонусов:"
        label.textAlignment = .left
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 22)
        return label
    }()
    
    let bonusQuantity: UILabel = {
        let label = UILabel()
        
        label.text = "0"
        label.font = .systemFont(ofSize: 40, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        
        return label
    }()
    
    let bonusTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .systemFont(ofSize: 15)
        textView.textColor = .secondaryLabel
        textView.isEditable = false
        textView.isSelectable = false
        return textView
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        presenter.viewDidLoadEvent()
        
    }
}

extension BonusViewController: BonusView {
    func setupView() {
        navigationItem.title = "Бонусы"
        
        view.backgroundColor = .systemBackground
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(bonusTitle)
        view.addSubview(bonusQuantity)
        view.addSubview(bonusTextView)
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
    }
    
    func layoutView() {
        NSLayoutConstraint.activate([
            bonusTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            bonusTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            bonusTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            
            bonusQuantity.topAnchor.constraint(equalTo: bonusTitle.bottomAnchor, constant: 8),
            bonusQuantity.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            bonusQuantity.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            bonusTextView.topAnchor.constraint(equalTo: bonusQuantity.bottomAnchor, constant: 52),
            bonusTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            bonusTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            bonusTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

    }
    
    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
    }
    
    func updateBonusBalance(_ balance: String) {
        bonusQuantity.text = balance
    }
    
    func getBonusText(_ text: String) {
        bonusTextView.text = text
    }
    
    
}

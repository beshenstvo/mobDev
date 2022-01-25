//
//  BaseCell.swift
//  Refactor Homework
//
//  Created by Kirill Varshamov on 20.11.2021.
//

import UIKit

final class BaseCell: UITableViewCell {
    
    static let cellID = "\(type(of: BaseCell.self))_ID"
    
    let titleLable: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(titleLable)
        
        NSLayoutConstraint.activate([
            titleLable.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLable.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLable.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    func configure(title: String) {
        titleLable.text = title
    }
}

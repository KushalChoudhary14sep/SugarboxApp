//
//  HomeHeaderView.swift
//  SugarBoxApp
//
//  Created by Kaushal Chaudhary on 09/11/23.
//

import Foundation
import UIKit

class HomeHeaderView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    private func commonInit() {
        setupViews()
        setupUI()
    }
}

//MARK: - Setup Title
extension HomeHeaderView {
    func setTitle(with text: String) {
        self.titleLabel.attributedText = NSAttributedString.setAttributedText(
            text: text,
            font: UIFont.systemFont(ofSize: 24, weight: .bold),
            color: .white
        )
    }
}

//MARK: - Setup UI / Constraints
private extension HomeHeaderView {
    private func setupUI() {
        self.backgroundColor = .clear
    }
    
    private func setupViews() {
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 48),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
}

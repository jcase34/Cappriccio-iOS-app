//
//  copyrightFooterView.swift
//  Lento
//
//  Created by Jacob Case on 1/17/23.
//

import UIKit

class copyrightFooterView: UIView {
    private var appTitleVersionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "helvetica", size: 14)
        label.textColor = .black
        label.text = "Lento v1.0"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var copyrightLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "helvetica", size: 14)
        label.textColor = .systemGray
        label.text = "© 2023 Lento"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override init (frame: CGRect) {
        super.init(frame: frame)
        addSubview(appTitleVersionLabel)
        addSubview(copyrightLabel)
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func applyConstraints() {
        let appTitleVersionLabelConstraint = [
            appTitleVersionLabel.topAnchor.constraint(equalTo: topAnchor),
            appTitleVersionLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ]
        let copyrightLabelConstraint = [
            copyrightLabel.topAnchor.constraint(equalTo: appTitleVersionLabel.bottomAnchor),
            copyrightLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ]
        
        NSLayoutConstraint.activate(appTitleVersionLabelConstraint)
        NSLayoutConstraint.activate(copyrightLabelConstraint)
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }

}

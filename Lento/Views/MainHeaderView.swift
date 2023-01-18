//
//  MainHeaderView.swift
//  Lento
//
//  Created by Jacob Case on 1/16/23.
//

import UIKit

class MainHeaderView: UIView {
    
    public var totalMinutesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Copperplate", size: 26)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var totalMinuteDescription: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "helvetica", size: 12)
        label.textColor = .systemGray
        label.text = "Total minutes"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public var sessionCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Copperplate", size: 44)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var sessionCountDescription: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "helvetica", size: 16)
        label.textColor = .systemGray
        label.text = "Total Sessions"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate var mainView: UIView = {
        let view = UIView()
        view.contentMode = .scaleToFill
        view.clipsToBounds = true
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private var topLine: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 400, height: 1))
        view.backgroundColor = .systemGray
        return view
    }()
    
    override init (frame: CGRect) {
        super.init(frame: frame)
        addSubview(mainView)
        addSubview(totalMinutesLabel)
        addSubview(sessionCountLabel)
        addSubview(sessionCountDescription)
        addSubview(totalMinuteDescription)
        addSubview(topLine)
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func applyConstraints() {
        let totalMinutesLabelConstraint = [
            totalMinutesLabel.topAnchor.constraint(equalTo: sessionCountDescription.bottomAnchor, constant: 10),
            totalMinutesLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ]
        
        let totalMinuteDescriptionConstraint = [
            totalMinuteDescription.topAnchor.constraint(equalTo: totalMinutesLabel.bottomAnchor),
            totalMinuteDescription.centerXAnchor.constraint(equalTo: centerXAnchor)
        ]
        
        let sessionCountLabelConstraint = [
            sessionCountLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            sessionCountLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ]
        
        let sessionCountDescriptionConstraint = [
            sessionCountDescription.topAnchor.constraint(equalTo: sessionCountLabel.bottomAnchor),
            sessionCountDescription.centerXAnchor.constraint(equalTo: centerXAnchor)
        ]
        
        let topLineConstraint = [
            topLine.topAnchor.constraint(equalTo: topAnchor),
            topLine.widthAnchor.constraint(equalTo: widthAnchor)
        ]
        
        NSLayoutConstraint.activate(totalMinutesLabelConstraint)
        NSLayoutConstraint.activate(totalMinuteDescriptionConstraint)
        NSLayoutConstraint.activate(sessionCountLabelConstraint)
        NSLayoutConstraint.activate(sessionCountDescriptionConstraint)
        NSLayoutConstraint.activate(topLineConstraint)
        
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        mainView.frame = bounds
    }

}

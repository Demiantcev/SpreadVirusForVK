//
//  CustomInfoMenuView.swift
//  SpreadVirusForVK
//
//  Created by Кирилл Демьянцев on 25.03.2024.
//

import UIKit

final class CustomInfoMenuView: UIView {
    
    private weak var delegate: CustomInfoMenuDelegate?
    
    private var timer: Timer = Timer()
    private var currentTime: Int = 0
    
    private(set) lazy var healthyPeopleLabel: UILabel = {
        var label = UILabel()
        label.textColor = .red
        label.font = UIFont(name: StringConstants.fontName, size: LayerConstants.fontSize16)
        label.textAlignment = .center
        label.text = StringConstants.healthy
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private(set) lazy var healthyPeopleCountLabel: UILabel = {
        var label = UILabel()
        label.textColor = .red
        label.font = UIFont(name: StringConstants.fontName, size: LayerConstants.fontSize25)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private(set) lazy var healthyPeopleView: UIView = {
        var view = UIView()
        view.layer.cornerRadius = LayerConstants.cornerRadiusSize
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 3
        return view
    }()
    
    private(set) lazy var zombiPeopleLabel: UILabel = {
        var label = UILabel()
        label.textColor = .red
        label.text = StringConstants.infected
        label.font = UIFont(name: StringConstants.fontName, size: LayerConstants.fontSize16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private(set) lazy var zombiPeopleCountLabel: UILabel = {
        var label = UILabel()
        label.textColor = .red
        label.font = UIFont(name: StringConstants.fontName, size: LayerConstants.fontSize25)
        label.text = "0"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private(set) lazy var zombiPeopleView: UIView = {
        var view = UIView()
        view.layer.cornerRadius = LayerConstants.cornerRadiusSize
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = LayerConstants.borderWidthSize3
        return view
    }()
    
    private(set) lazy var timerView: UIView = {
        var view = UIView()
        view.layer.cornerRadius = LayerConstants.cornerRadiusSize
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = LayerConstants.borderWidthSize3
        return view
    }()
    
    private(set) lazy var timerLabel: UILabel = {
        var label = UILabel()
        label.textColor = .red
        label.font = UIFont(name: StringConstants.fontName, size: LayerConstants.fontSize16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private(set) lazy var backButton: UIButton = {
        var button = UIButton(type: .roundedRect)
        button.backgroundColor = .lightGray
        button.setImage(
            UIImage(
                systemName: "chevron.backward",
                withConfiguration: UIImage.SymbolConfiguration(weight: .bold)),
            for: .normal)
        button.layer.cornerRadius = LayerConstants.cornerRadiusSize
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = LayerConstants.borderWidthSize3
        return button
    }()
    
    init(delegate: CustomInfoMenuDelegate) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.delegate = delegate
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(humanCount: Int, time: Int) {
        healthyPeopleCountLabel.text = "\(humanCount)"
        timerLabel.text = "\(timer)"
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            self.timerLabelReload(time)
        })
    }
}
private extension CustomInfoMenuView {
    
    @objc func tapButton() {
        delegate?.closeViewController()
    }
    
    private func timerLabelReload(_ time: Int) {
        
        defer {
            timerLabel.text = "\(currentTime)"
        }
        
        if currentTime <= time && currentTime > 1 {
            currentTime -= 1
        } else {
            currentTime = time
        }
    }
    
    func addSubviews() {
        
        [healthyPeopleView, healthyPeopleLabel, healthyPeopleCountLabel, zombiPeopleView, zombiPeopleLabel, zombiPeopleCountLabel, timerView, timerLabel, backButton].forEach {
            self.addSubview($0)
        }
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            
            healthyPeopleView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            healthyPeopleView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/2.5),
            healthyPeopleView.trailingAnchor.constraint(equalTo: zombiPeopleView.leadingAnchor, constant: -ConstraintConstants.offset5),
            healthyPeopleView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1/1.5),
            
            healthyPeopleLabel.topAnchor.constraint(equalTo: healthyPeopleView.topAnchor, constant: ConstraintConstants.offset5),
            healthyPeopleLabel.centerXAnchor.constraint(equalTo: healthyPeopleView.centerXAnchor),
            
            healthyPeopleCountLabel.centerXAnchor.constraint(equalTo: healthyPeopleLabel.centerXAnchor),
            healthyPeopleCountLabel.centerYAnchor.constraint(equalTo: healthyPeopleView.centerYAnchor),
            
            zombiPeopleView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            zombiPeopleView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/2.5),
            zombiPeopleView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1/1.5),
            zombiPeopleView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -ConstraintConstants.offset10),
            
            zombiPeopleLabel.topAnchor.constraint(equalTo: zombiPeopleView.topAnchor, constant: ConstraintConstants.offset5),
            zombiPeopleLabel.centerXAnchor.constraint(equalTo: zombiPeopleView.centerXAnchor),
            
            zombiPeopleCountLabel.centerYAnchor.constraint(equalTo: zombiPeopleView.centerYAnchor),
            zombiPeopleCountLabel.centerXAnchor.constraint(equalTo: zombiPeopleView.centerXAnchor),
            
            timerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: ConstraintConstants.offset5),
            timerView.trailingAnchor.constraint(equalTo: self.healthyPeopleView.leadingAnchor, constant: -ConstraintConstants.offset5),
            timerView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1/3.5),
            timerView.bottomAnchor.constraint(equalTo: self.healthyPeopleView.bottomAnchor),
            
            timerLabel.centerXAnchor.constraint(equalTo: timerView.centerXAnchor),
            timerLabel.centerYAnchor.constraint(equalTo: timerView.centerYAnchor),
            
            backButton.topAnchor.constraint(equalTo: self.healthyPeopleView.topAnchor),
            backButton.leadingAnchor.constraint(equalTo: self.timerView.leadingAnchor),
            backButton.trailingAnchor.constraint(equalTo: self.timerView.trailingAnchor),
            backButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1/3.5)
        ])
    }
}

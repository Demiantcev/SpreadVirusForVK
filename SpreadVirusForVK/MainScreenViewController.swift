//
//  MainScreenViewController.swift
//  SpreadVirusForVK
//
//  Created by Кирилл Демьянцев on 21.03.2024.
//

import UIKit

final class MainScreenViewController: UIViewController {
    
    private(set) var countPeople = String()
    private(set) var infectedPeople = String()
    private(set) var timePeriod = String()
    
    private lazy var customArray = [
        SelectionParametersView(delegate: self, textLabel: .countPeople),
        SelectionParametersView(delegate: self, textLabel: .infectedPeople),
        SelectionParametersView(delegate: self, textLabel: .timePeriod)
    ]
    
    private(set) var mainLabel: UILabel = {
        var label = UILabel()
        label.textColor = .black
        label.text = StringConstants.mainLabelText
        label.font = UIFont(name: StringConstants.fontName, size: LayerConstants.fontSize25)
        label.numberOfLines = 3
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private(set) var stack: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = LayerConstants.spacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private(set) lazy var startButton: UIButton = {
        var button = UIButton(type: .roundedRect)
        button.setTitle(StringConstants.start, for: .normal)
        button.backgroundColor = .yellow
        button.layer.borderWidth = LayerConstants.borderWidthSize5
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = LayerConstants.cornerRadiusSize
        button.setTitleColor(.red, for: .normal)
        button.titleLabel?.font = UIFont(name: StringConstants.fontName, size: LayerConstants.fontSize16)
        button.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
        button.isUserInteractionEnabled = false
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.alpha = 0.5
        return button
    }()
    
    private(set) lazy var randomButton: UIButton = {
        var button = UIButton(type: .roundedRect)
        button.setTitle(StringConstants.random, for: .normal)
        button.backgroundColor = .yellow
        button.layer.borderWidth = LayerConstants.borderWidthSize5
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = LayerConstants.cornerRadiusSize
        button.setTitleColor(.red, for: .normal)
        button.titleLabel?.font = UIFont(name: StringConstants.fontName, size: LayerConstants.fontSize16)
        button.addTarget(self, action: #selector(tapRandomValuesButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private(set) var backgroundImage: UIImageView = {
        var image = UIImageView()
        image.image = UIImage(named: "virus2")
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        image.alpha = 0.9
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubviews()
        setupConstraints()
        hideKeyboardWhenTappedAroundView()
    }
}
private extension MainScreenViewController {
    
    @objc func tapButton(_ sender: UIButton) {
        let secondVC = InfectionSimulatorViewController()
        secondVC.humanCount = Int(countPeople) ?? 0
        secondVC.spreadHumans = Int(infectedPeople) ?? 0
        
        if timePeriod == "0" {
            timePeriod = "1"
        }
        secondVC.time = Int(timePeriod) ?? 0
        
        if !countPeople.isEmpty && !infectedPeople.isEmpty && !timePeriod.isEmpty {
            self.navigationController?.pushViewController(secondVC, animated: true)
        }
    }
    
    @objc func tapRandomValuesButton(_ sender: UIButton) {
        let secondVC = InfectionSimulatorViewController()
        let randomHumanCount = Int.random(in: 1...100)
        let randomSpreadHumans = Int.random(in: 1...100)
        let randomTime = Int.random(in: 1...10)
        
        secondVC.humanCount = randomHumanCount
        secondVC.spreadHumans = randomSpreadHumans
        secondVC.time = randomTime
        
        self.navigationController?.pushViewController(secondVC, animated: true)
    }
    
    func addSubviews() {
        [backgroundImage, mainLabel, stack, startButton, randomButton].forEach {
            view.addSubview($0)
        }
        customArray.forEach {
            stack.addArrangedSubview($0)
        }
    }
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            mainLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: ConstraintConstants.offset30),
            stack.widthAnchor.constraint(equalToConstant: view.bounds.width / 2),
            
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.bottomAnchor.constraint(equalTo: randomButton.topAnchor, constant: -ConstraintConstants.offset10),
            startButton.heightAnchor.constraint(equalToConstant: ConstraintConstants.offset70),
            startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -ConstraintConstants.offset50),
            startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ConstraintConstants.offset50),
            
            randomButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -ConstraintConstants.offset30),
            randomButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            randomButton.heightAnchor.constraint(equalToConstant: ConstraintConstants.offset70),
            randomButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -ConstraintConstants.offset50),
            randomButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ConstraintConstants.offset50)
        ])
    }
    
    func buttonState() {
        if !countPeople.isEmpty && !infectedPeople.isEmpty && !timePeriod.isEmpty {
            startButton.alpha = 1
            startButton.isUserInteractionEnabled = true
        } else {
            startButton.alpha = 0.5
            startButton.isUserInteractionEnabled = false
        }
    }
    func hideKeyboardWhenTappedAroundView() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
        if let nc = self.navigationController {
            nc.view.endEditing(true)
        }
    }
}
extension MainScreenViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        for (index, value) in customArray.enumerated() {
            if textField == value.inputTextField {
                switch index {
                case 0:
                    countPeople = textField.text ?? "0"
                case 1:
                    infectedPeople = textField.text ?? "0"
                default:
                    timePeriod = textField.text ?? "0"
                }
            }
            buttonState()
        }
    }
}

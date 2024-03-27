//
//  SelectionParametersView.swift
//  SpreadVirusForVK
//
//  Created by Кирилл Демьянцев on 21.03.2024.
//

import UIKit

final class SelectionParametersView: UIView {
    
    enum ParameterText: String {
        case countPeople = "Количество людей"
        case infectedPeople = "Количество зараженных\n людей"
        case timePeriod = "Период пересчета"
    }
    
    private(set) lazy var parameterLabel: UILabel = {
        var label = UILabel()
        label.textColor = #colorLiteral(red: 0.9999867082, green: 0.003373512067, blue: 0.09007913619, alpha: 1)
        label.font = UIFont(name: StringConstants.fontName, size: LayerConstants.fontSize18)
        label.textAlignment = .center
        label.numberOfLines = .zero
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private(set) lazy var backgroundView: UIView = {
        var view = UIView()
        view.layer.borderWidth = LayerConstants.borderWidthSize5
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.cornerRadius = LayerConstants.cornerRadiusSize
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private(set) lazy var inputTextField: UITextField = {
        var textField = UITextField()
        let leftPadding = UIView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: 8,
                height: textField.frame.height
            )
        )
        textField.backgroundColor = .lightGray
        textField.adjustsFontSizeToFitWidth = true
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = LayerConstants.borderWidthSize5
        textField.font = UIFont(name: StringConstants.fontName, size: LayerConstants.texFieldFontSize)
        textField.clearButtonMode = .whileEditing
        textField.layer.cornerRadius = LayerConstants.cornerRadiusSize
        textField.leftView = leftPadding
        textField.leftViewMode = .always
        textField.placeholder = StringConstants.placeHolderText
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    init(delegate: UITextFieldDelegate, textLabel: ParameterText) {
        super.init(frame: .zero)
        inputTextField.delegate = delegate
        parameterLabel.text = textLabel.rawValue
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
private extension SelectionParametersView {
    
    func addSubviews() {
        [parameterLabel, inputTextField].forEach {
            self.addSubview($0)
        }
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            
            parameterLabel.topAnchor.constraint(equalTo: self.topAnchor),
            parameterLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            inputTextField.topAnchor.constraint(equalTo: parameterLabel.bottomAnchor, constant: ConstraintConstants.offset5),
            inputTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            inputTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            inputTextField.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            inputTextField.heightAnchor.constraint(equalToConstant: ConstraintConstants.offset70)
        ])
    }
}

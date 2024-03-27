//
//  HumanCollectionViewCell.swift
//  SpreadVirusForVK
//
//  Created by Кирилл Демьянцев on 25.03.2024.
//

import UIKit

final class HumanCollectionViewCell: UICollectionViewCell {
    
    static let reuseId = "HumanCollectionViewCell"
    
    var isInfected: Bool = false
    
    private(set) var humanImage: UIImageView = {
        var image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "human")
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func attemptInfection() -> Bool {
        if !isInfected {
            isInfected = true
            return true
        }
        return false
    }
    
    func reloadCell(isInfected: Bool) {
        humanImage.image = isInfected ? .zombi : .human
    }
}
private extension HumanCollectionViewCell {
    
    func addSubviews() {
        self.addSubview(humanImage)
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            
            humanImage.topAnchor.constraint(equalTo: self.topAnchor),
            humanImage.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            humanImage.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            humanImage.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}

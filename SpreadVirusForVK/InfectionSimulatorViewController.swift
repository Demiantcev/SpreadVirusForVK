//
//  InfectionSimulatorViewController.swift
//  SpreadVirusForVK
//
//  Created by Кирилл Демьянцев on 22.03.2024.
//

import UIKit

protocol CustomInfoMenuDelegate: AnyObject {
    func closeViewController()
}

final class InfectionSimulatorViewController: UIViewController {
    
    private let sectionInserts = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    private var itemPerRow: CGFloat = 5
    
    var humanCount: Int?
    private lazy var totalCount: Int = Int(humanCount ?? 0)
    var spreadHumans: Int?
    private lazy var spreadHumansCount: Int = Int(spreadHumans ?? 0)
    var time = Int()
    
    private var timer: Timer?
    private let alert = AlertAction()
    private let queue = DispatchQueue.global(qos: .userInitiated)
    
    private var cells = [HumanCollectionViewCell]()
    private var infectedHumansArray: [Int] = []
    private var updateIndexes: [Int] = []
    
    private(set) lazy var menuInfoView = CustomInfoMenuView(delegate: self)
    
    lazy private var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.dataSource = self
        collection.delegate = self
        collection.register(HumanCollectionViewCell.self, forCellWithReuseIdentifier: HumanCollectionViewCell.reuseId)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .clear
        return collection
    }()
    
    private(set) var backgroundImage: UIImageView = {
        var image = UIImageView()
        image.image = UIImage(named: "worldVirus")
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        image.alpha = 0.9
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.hidesBackButton = true
        addSubviews()
        setupConstraints()
        menuInfoView.configure(humanCount: totalCount, time: time)
        startTimer()
        setupZoomGesture()
        
        for _ in 0..<totalCount {
            cells.append(HumanCollectionViewCell())
        }
    }
}
private extension InfectionSimulatorViewController {
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(time), target: self, selector: #selector(infectedCount), userInfo: nil, repeats: true)
        menuInfoView.timerLabel.text = "\(time)"
    }
    
    @objc func infectedCount() {
        guard infectedHumansArray.count != cells.count else { return }
        
        queue.async {
            for index in self.infectedHumansArray {
                self.infectAdjacentHumans(forIndex: index, timesToInfect: self.spreadHumansCount)
            }
            
            DispatchQueue.main.async {
                self.refreshPeopleView(for: self.updateIndexes.map { $0 })
            }
        }
        self.updateIndexes = []
    }
    
    func refreshPeopleView(for indexes: [Int]) {
        let currentInfected = infectedHumansArray.count
        let currentGroupSize = totalCount - currentInfected
        
        self.updateParameter(healthy: currentGroupSize, infected: currentInfected)
        
        self.reloadCells(at: indexes)
        
        if currentGroupSize == 0 {
            alert.gameOverAlert(self, score: infectedHumansArray.count) { [self] in
                
                UIView.animate(withDuration: 1) {
                    self.view.alpha = 0
                } completion: { [self] _ in
                    infectedHumansArray.removeAll()
                    cells.forEach { $0.isInfected = false }
                    updateParameter(healthy: totalCount, infected: 0)
                    collectionView.reloadData()
                    UIView.animate(withDuration: 1) {
                        self.view.alpha = 1
                    }
                }
            }
        }
    }
    
    func reloadCells(at indexes: [Int]) {
        let indexPaths = indexes.map( { IndexPath(item: $0, section: 0)})
        DispatchQueue.main.async {
            self.collectionView.reconfigureItems(at: indexPaths)
        }
    }
    
    func tapHuman(at index: Int) {
        guard index <= cells.count else { return }
        
        if cells[index].attemptInfection() {
            infectedHumansArray.append(index)
            refreshPeopleView(for: [index])
        }
    }
    
    func infectAdjacentHumans(forIndex index: Int, timesToInfect: Int) {
        guard timesToInfect > 0 else { return }
        
        let randomAdjacentIndex = getRandomAdjacentIndex(for: index)
        if cells.indices.contains(randomAdjacentIndex) {
            if cells[randomAdjacentIndex].attemptInfection() {
                infectedHumansArray.append(randomAdjacentIndex)
                updateIndexes.append(randomAdjacentIndex)
            }
        }
        
        if Bool.random() {
            infectAdjacentHumans(forIndex: randomAdjacentIndex, timesToInfect: timesToInfect - 1)
        }
    }
    
    func getRandomAdjacentIndex(for index: Int) -> Int {
        let adjacentIndexes = getAdjacentIndexes(for: index).shuffled()
        return adjacentIndexes.first ?? index
    }
    
    func getAdjacentIndexes(for index: Int) -> [Int] {
        var adjacentIndexes = [index + 5, index - 5]
        
        if index % 5 != 0 {
            adjacentIndexes.append(index - 1)
        }
        if index % 5 != 4 {
            adjacentIndexes.append(index + 1)
        }
        
        return adjacentIndexes.filter { cells.indices.contains($0) }
    }
    
    func getHumanAtIndex(_ index: Int) -> HumanCollectionViewCell {
        return cells.indices.contains(index) ? cells[index] : HumanCollectionViewCell()
    }
    
    
    func updateParameter(healthy: Int, infected: Int) {
        self.menuInfoView.healthyPeopleCountLabel.text = "\(healthy)"
        self.menuInfoView.zombiPeopleCountLabel.text = "\(infected)"
    }
    
    func setupZoomGesture() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(_:)))
        collectionView.addGestureRecognizer(pinchGesture)
    }
    
    @objc func handlePinchGesture(_ gestureRecognizer: UIPinchGestureRecognizer) {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        if gestureRecognizer.state == .changed {
            let scale = max(0.5, min(2.0, gestureRecognizer.scale))
            
            let newCellsPerRow = max(Int(round(Double(itemPerRow) / scale)), 1)
            let clampedCellsPerRow = min(5, max(1, newCellsPerRow))
            let screenWidth = UIScreen.main.bounds.width
            let availableWidth = screenWidth - CGFloat(clampedCellsPerRow + 1) * 5
            let cellWidth = availableWidth / CGFloat(clampedCellsPerRow)
            
            layout.itemSize = CGSize(width: cellWidth, height: cellWidth)
            itemPerRow = CGFloat(clampedCellsPerRow)
            
            layout.invalidateLayout()
            collectionView.collectionViewLayout.invalidateLayout()
            
        }
    }
    
    func addSubviews() {
        [backgroundImage, collectionView, menuInfoView].forEach {
            view.addSubview($0)
        }
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            menuInfoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            menuInfoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ConstraintConstants.offset10),
            menuInfoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -ConstraintConstants.offset10),
            menuInfoView.heightAnchor.constraint(equalToConstant: 200),
            
            collectionView.topAnchor.constraint(equalTo: menuInfoView.bottomAnchor, constant: ConstraintConstants.offset10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
extension InfectionSimulatorViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HumanCollectionViewCell.reuseId, for: indexPath) as? HumanCollectionViewCell else {return UICollectionViewCell()}
        cell.reloadCell(isInfected: cells[indexPath.row].isInfected)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.tapHuman(at: indexPath.row)
    }
}
extension InfectionSimulatorViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingWidth = sectionInserts.left * (itemPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingWidth
        let widthPerItem = availableWidth / itemPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
}
extension InfectionSimulatorViewController: CustomInfoMenuDelegate {
    func closeViewController() {
        self.timer?.invalidate()
        self.navigationController?.popViewController(animated: true)
    }
}

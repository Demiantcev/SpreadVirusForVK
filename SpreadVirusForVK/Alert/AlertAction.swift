//
//  AlertAction.swift
//  SpreadVirusForVK
//
//  Created by Кирилл Демьянцев on 26.03.2024.
//

import UIKit

final class AlertAction {
    
    func gameOverAlert(_ view: UIViewController, score: Int, completion: @escaping () -> Void) {
        
        let alertController = UIAlertController(title: "Вы всех заразили 🦠",
                                                message: "Заражено \(score)",
                                                preferredStyle: .alert)
        let alertNewGameAction = UIAlertAction(title: "Оживить всех",
                                               style: .default) { _ in
            completion()
        }
        let alertExitAction = UIAlertAction(title: "Выйти",
                                            style: .destructive) { _ in
            view.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(alertNewGameAction)
        alertController.addAction(alertExitAction)
        view.present(alertController, animated: true)
    }
}

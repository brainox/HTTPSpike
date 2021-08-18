//
//  ViewController.swift
//  HTTPSpike
//
//  Created by Decagon on 17/08/2021.
//

import UIKit

class ViewController: UIViewController {

    let label = UILabel()
    let button = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
    }

}

extension ViewController {
    func style() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Number of Transactions"
        label.font = UIFont.preferredFont(forTextStyle: .body)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Fetch", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        
        button.addTarget(self, action: #selector(fetchButtonTapped), for: .primaryActionTriggered)
    }
    
    func layout() {
        view.addSubview(label)
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
          
            button.topAnchor.constraint(equalToSystemSpacingBelow: label.bottomAnchor, multiplier: 2),
            button.widthAnchor.constraint(equalToConstant: 100),
            button.centerXAnchor.constraint(equalTo: label.centerXAnchor)
        ])
    }
    
    @objc func fetchButtonTapped() {
        HistoryService.shared.fetchTransaction { (result) in
            switch result {
            case .success(let transactions):
                self.label.text = "The number of transaction is \(transactions.count)"
            case .failure(let error):
                print(error)
            }
        }
    }
}

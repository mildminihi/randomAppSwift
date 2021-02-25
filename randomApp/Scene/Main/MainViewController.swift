//
//  ViewController.swift
//  randomApp
//
//  Created by Supanat Wanroj on 5/2/2564 BE.
//

import UIKit

protocol MainViewControllerInterface: class {
    func displayMember(viewModel: MainModel.GetMember.ViewModel)
    func displayWinner(viewModel: MainModel.RandomWinner.ViewModel)
}

class MainViewController: UIViewController, MainViewControllerInterface {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var memberTableView: UITableView!
    
    var interactor: MainInteractorInterface!
    
    var memberList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = "Winner is!"
        
        let presenter = MainPresenter()
        presenter.viewController = self
        
        let interactor = MainInteractor()
        interactor.presenter = presenter
        
        self.interactor = interactor
        interactor.getMemberList(request: MainModel.GetMember.Request())
    }
    
    func displayMember(viewModel: MainModel.GetMember.ViewModel) {
        memberList = viewModel.memberList
        memberTableView.reloadData()
    }
    
    func displayWinner(viewModel: MainModel.RandomWinner.ViewModel) {
        nameLabel.text = viewModel.winner
        interactor.getMemberList(request: MainModel.GetMember.Request())
    }
    
    @IBAction func tapOnRandomButton(_ sender: Any) {
        interactor.randomWinner(request: MainModel.RandomWinner.Request())
    }
    
    @IBAction func tapOnAddButton(_ sender: Any) {
        let alert = UIAlertController(title: "Add member", message: "Name", preferredStyle: .alert)
        alert.addTextField { (input) in
            input.placeholder = "enter name"
        }
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { _ in
            let textField = alert.textFields![0]
            self.interactor.addMember(request: MainModel.AddMember.Request(name: textField.text ?? "empty"))
        }))
        alert.addAction(UIAlertAction(title: "Cancle", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memberList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = memberList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            memberList.remove(at: indexPath.row)
            memberTableView.reloadData()
        }
    }
}

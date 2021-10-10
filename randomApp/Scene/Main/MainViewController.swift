//
//  ViewController.swift
//  randomApp
//
//  Created by Supanat Wanroj on 5/2/2564 BE.
//

import UIKit
import AVFoundation

protocol MainViewControllerInterface: class {
  func displayMember(viewModel: MainModel.GetMember.ViewModel)
  func displayWinner(viewModel: MainModel.RandomWinner.ViewModel)
}

class MainViewController: UIViewController, MainViewControllerInterface {
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var memberTableView: UITableView!
  @IBOutlet weak var memberCountLable: UILabel!
  
  var interactor: MainInteractorInterface!
  
  var memberList: [String] = [] {
    didSet {
      if memberList.isEmpty {
        memberCountLable.text = "no members please add first"
      } else {
        memberCountLable.text = "\(memberList.count) members"
      }
    }
  }
  
   let pianoSound = URL(fileURLWithPath: Bundle.main.path(forResource: "applause", ofType: "mp3")!)
  var audioPlayer = AVAudioPlayer()
  
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
    do {
      audioPlayer = try AVAudioPlayer(contentsOf: pianoSound)
      audioPlayer.play()
    } catch {
    }
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
  
  @IBAction func tapOnAddBulkButton(_ sender: Any) {
    let alertController = UIAlertController(title: "\n\n\n\n\n\n", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
    
    let margin:CGFloat = 8.0
    let rect = CGRect(x: margin, y: margin, width: alertController.view.bounds.size.width - margin * 4.0, height: 100.0)
    let customView = UITextView(frame: rect)
    
    customView.backgroundColor = UIColor.clear
    customView.font = UIFont(name: "Helvetica", size: 15)
    alertController.view.addSubview(customView)
    
    let somethingAction = UIAlertAction(title: "Add Bulk", style: UIAlertAction.Style.default, handler: {(alert: UIAlertAction!) in
      if let members = customView.text {
        self.interactor.addBulkMember(request: MainModel.AddBulkMember.Request(members: members.components(separatedBy: "\n")))
      }
    })
    
    let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: {(alert: UIAlertAction!) in print("cancel")})
    
    alertController.addAction(somethingAction)
    alertController.addAction(cancelAction)
    
    self.present(alertController, animated: true, completion:{})
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

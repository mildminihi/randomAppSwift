//
//  MainInteractor.swift
//  randomApp
//
//  Created by Supanat Wanroj on 25/2/2564 BE.
//

import Foundation

protocol MainInteractorInterface {
  func getMemberList(request: MainModel.GetMember.Request)
  func addMember(request: MainModel.AddMember.Request)
  func addBulkMember(request: MainModel.AddBulkMember.Request)
  func randomWinner(request: MainModel.RandomWinner.Request)
}

class MainInteractor: MainInteractorInterface {
  var presenter: MainPresenterInterface!
  
  var memberList: [String] = []
  
  func getMemberList(request: MainModel.GetMember.Request) {
    presenter.presentMemberList(response: MainModel.GetMember.Response(memberList: memberList))
  }
  
  func addMember(request: MainModel.AddMember.Request) {
    memberList.append(request.name)
    presenter.presentMemberList(response: MainModel.GetMember.Response(memberList: memberList))
  }
  
  func randomWinner(request: MainModel.RandomWinner.Request) {
    var winner: String
    if memberList.count == 0 {
      winner = "Empty la ja"
    } else {
      let index = Int.random(in: 0..<memberList.count)
      winner = memberList[index]
      memberList.remove(at: index)
    }
    presenter.presentWinner(response: MainModel.RandomWinner.Response(winner: winner))
  }
  
  func addBulkMember(request: MainModel.AddBulkMember.Request) {
    for i in request.members {
      memberList.append(i)
    }
    presenter.presentMemberList(response: MainModel.GetMember.Response(memberList: memberList))
  }
}

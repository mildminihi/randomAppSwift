//
//  MainPresenter.swift
//  randomApp
//
//  Created by Supanat Wanroj on 25/2/2564 BE.
//

import Foundation

protocol MainPresenterInterface {
    func presentMemberList(response: MainModel.GetMember.Response)
    func presentWinner(response: MainModel.RandomWinner.Response)
}

class MainPresenter: MainPresenterInterface {
    var viewController: MainViewControllerInterface!
    
    func presentMemberList(response: MainModel.GetMember.Response) {
        viewController.displayMember(viewModel: MainModel.GetMember.ViewModel(memberList: response.memberList))
    }
    
    func presentWinner(response: MainModel.RandomWinner.Response) {
        viewController.displayWinner(viewModel: MainModel.RandomWinner.ViewModel(winner: response.winner))
    }
}

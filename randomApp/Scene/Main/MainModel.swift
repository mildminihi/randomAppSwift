//
//  MainModel.swift
//  randomApp
//
//  Created by Supanat Wanroj on 25/2/2564 BE.
//

import Foundation

struct MainModel {
    struct GetMember {
        struct Request {}
        
        struct Response {
            let memberList: [String]
        }
        
        struct ViewModel {
            let memberList: [String]
        }
    }
    
    struct AddMember {
        struct Request {
            let name: String
        }
    }
    
    struct RandomWinner {
        struct Request {}
        
        struct Response {
            let winner: String
        }
        
        struct ViewModel {
            let winner: String
        }
    }
}

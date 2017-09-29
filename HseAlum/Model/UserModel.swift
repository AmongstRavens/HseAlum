//
//  UserModel.swift
//  HseAlum
//
//  Created by Sergey on 9/29/17.
//  Copyright © 2017 Бизнес в стиле .RU. All rights reserved.
//

import Foundation

class User{
    //Core info
    var firstName : String
    var lastName : String
    var middleName : String
    var profileImageReference : URL?
    var jobs = [Job]()
    
    //Contacts
    var cellNumber: String?
    var email: String?
    var isHidden: Bool = false
    
    //University info
    var departmentName: String?
    var group: Int?
    var graduationYear: Int?
    
    init(lastName: String, firstName: String, middleName: String, imageURL: URL?){
        self.firstName = firstName
        self.lastName = lastName
        self.middleName = middleName
        profileImageReference = imageURL
    }
}

class Job{
    var position: String
    var organizationName: String
    var timestamp: String
    
    init(position: String, organizationName: String, timestamp: String){
        self.organizationName = organizationName
        self.timestamp = timestamp
        self.position = position
    }
}

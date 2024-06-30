//
//  TableView+Extensions.swift
//  MovieDirectory
//
//  Created by IndianRenters on 30/06/24.
//

import Foundation
import UIKit

extension UITableView {
    
    func assignDelegate(delegate: UITableViewDelegate, dataSource: UITableViewDataSource) {
        self.delegate = delegate
        self.dataSource = dataSource
    }
    
    func setContentInset(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) {
        self.contentInset = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
    }
    
    func registerCell(nibName: String) {
        self.register(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: nibName)
    }
    
    func dequeueCell<T>(identifier: String, type: T.Type) -> T {
        return dequeueReusableCell(withIdentifier: identifier) as! T
    }
}

//
//  Helper.swift
//  CoreDataDemo
//
//  Created by Elluminati on 07/01/20.
//  Copyright © 2020 swiftui learn. All rights reserved.
//

import UIKit

extension UIViewController {
    
    public static var alert:UIAlertController!
    
    //MARK:- SHOW LOADING
    func ShowLoading() {
        UIViewController.alert = UIAlertController(title: nil, message: "TXT_PLEASE_WAIT".localized, preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();
        UIViewController.alert.view.addSubview(loadingIndicator)
        present(UIViewController.alert, animated: true, completion: nil)
    }
    
    //MARK:- HIDE LOADING
    func hideLoading() {
        UIViewController.alert.dismiss(animated: true, completion: {
            
        })
    }
}

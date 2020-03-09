//
//  UIView+Extension.swift
//  WMDB
//
//  Created by Wissa Azmy on 2/15/20.
//  Copyright © 2020 Wissa Azmy. All rights reserved.
//

import UIKit

extension UIView {
    func centerXAnchor(to view: UIView) {
        self.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func centerYAnchor(to view: UIView) {
        self.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func anchors(to view: UIView) {
        self.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        self.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func centerAnchor(in view: UIView) {
        self.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func verticalAnchor(to view: UIView, spacing constant: CGFloat = 0) {
        self.topAnchor.constraint(equalTo: view.topAnchor, constant: constant).isActive = true
        self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -constant).isActive = true
    }
    
    func horizontalAnchor(to view: UIView, spacing constant: CGFloat = 0) {
        self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: constant).isActive = true
        self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -constant).isActive = true
    }
    
    func leadingAnchor(to view: UIView, plus constant: CGFloat = 0) {
        self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: constant).isActive = true
    }
    
    func leadingAnchor(toTraillingOf view: UIView, plus constant: CGFloat = 0) {
        self.leadingAnchor.constraint(equalTo: view.trailingAnchor, constant: constant).isActive = true
    }
    
    func traillingAnchor(to view: UIView, plus constant: CGFloat = 0) {
        self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: constant).isActive = true
    }
    
    func topAnchor(to view: UIView, plus constant: CGFloat = 0) {
        self.topAnchor.constraint(equalTo: view.topAnchor, constant: constant).isActive = true
    }
    
    func topAnchor(toBottomOf view: UIView, plus constant: CGFloat = 0) {
        self.topAnchor.constraint(equalTo: view.bottomAnchor, constant: constant).isActive = true
    }
    
    func bottomAnchor(to view: UIView, plus constant: CGFloat = 0) {
        self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: constant).isActive = true
    }
    
    func bottomAnchor(toTopOf view: UIView, plus constant: CGFloat = 0) {
        self.bottomAnchor.constraint(equalTo: view.topAnchor, constant: constant).isActive = true
    }
    
    func bottomAnchor(toSafeAreaOf view: UIView, plus constant: CGFloat = 0) {
        self.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: constant).isActive = true
    }
    
    func setWidthAnchor(to view: UIView) {
        self.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }
    
    func setHeightAnchor(to view: UIView) {
        self.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }

    func setWidth(to width: CGFloat) {
        self.widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    func setHeight(to height: CGFloat) {
        self.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    func setHeight(greaterOrEqualTo height: CGFloat) {
        self.heightAnchor.constraint(greaterThanOrEqualToConstant: 150).isActive = true
    }
}

extension UIView {
    func addSubviews(_ views: UIView...) {
        for view in views {
            self.addSubview(view)
        }
    }
}

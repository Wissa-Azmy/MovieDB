//
//  movieDetailsVC.swift
//  WMDB
//
//  Created by Wissa Azmy on 2/16/20.
//  Copyright © 2020 Wissa Azmy. All rights reserved.
//

import UIKit

struct ColorPalette {
    static let titleStrip = #colorLiteral(red: 0, green: 0.7156304717, blue: 0.9302947521, alpha: 1)
}

class MovieDetailsVC: UIViewController {
    var movie: Movie?
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
        return scrollView
    }()
    let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let posterImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = Images.dummy
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.addCornerRadius()
        return imgView
    }()
    let titleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ColorPalette.titleStrip
        return view
    }()
    let titleLbl: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .natural
        label.adjustsFontSizeToFitWidth = true
        label.font = Fonts.title
        return label
    }()
    let ratingLbl: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .natural
        label.font = Fonts.subTitle
        return label
    }()
    let overviewLbl: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .black
        label.textAlignment = .justified
        label.sizeToFit()
        label.font = Fonts.overview
        return label
    }()
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(posterImgView, titleView, titleLbl, ratingLbl, overviewLbl)
        
        addViewsConstraints()
        configDetails(of: movie!)
    }
    
    func setupNavigationBar() {
        navigationItem.title = "Movie"
        let navBar = navigationController?.navigationBar
        navBar?.barTintColor = .white
        navBar?.backgroundColor = .white
        navBar?.prefersLargeTitles = false
        navBar?.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: Fonts.title]
        navBar?.isTranslucent = false
    }
    
    func addViewsConstraints(){
        scrollView.centerXAnchor(to: view)
        scrollView.setWidthAnchor(to: view)
        scrollView.topAnchor(to: view)
        scrollView.bottomAnchor(toSafeAreaOf: view)
        
        contentView.centerXAnchor(to: scrollView)
        contentView.setWidthAnchor(to: scrollView)
        contentView.verticalAnchor(to: scrollView)
        
        posterImgView.topAnchor(to: contentView, plus: 10)
        posterImgView.horizontalAnchor(to: contentView, spacing: 50)
        posterImgView.setHeight(to: 460)
        
        titleView.setHeight(to: 65)
        titleView.topAnchor(toBottomOf: posterImgView, plus: 10)
        titleView.horizontalAnchor(to: contentView)
        
        titleLbl.horizontalAnchor(to: titleView, spacing: 10)
        titleLbl.topAnchor(to: titleView)
        
        ratingLbl.leadingAnchor(to: titleView, plus: 10)
        ratingLbl.topAnchor(toBottomOf: titleLbl)
        
        overviewLbl.topAnchor(toBottomOf: titleView, plus: 10)
        overviewLbl.bottomAnchor(to: contentView, plus: 50)
        overviewLbl.horizontalAnchor(to: contentView, spacing: 26)
        overviewLbl.setHeight(greaterOrEqualTo: 150)
    }
    
    private func configDetails(of movie: Movie) {
        posterImgView.kf.setImage(with: movie.posterUrl, placeholder: Images.dummy, options: [.transition(.fade(1.0))])
        titleLbl.text = movie.title
        ratingLbl.text = movie.ratingText
        overviewLbl.text = movie.overviewText
        
    }
}

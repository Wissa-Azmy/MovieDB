//
//  MovieCell.swift
//  WMDB
//
//  Created by Wissa Azmy on 2/15/20.
//  Copyright © 2020 Wissa Azmy. All rights reserved.
//

import UIKit
import Kingfisher

struct Images {
    static let overlay = UIImage(named: "gradient-overlay")
    static let dummy = UIImage(named: "dummy_img")
}

class MovieCell: UITableViewCell {
    let titleLbl: UILabel = {
        let label = UILabel()
        label.textAlignment = .natural
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        label.font = Fonts.title
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Images.dummy
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let movieImageOverlay: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = Images.overlay
        return imageView
    }()
    
    private let mainView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    private let activityIndicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView()
        indicatorView.hidesWhenStopped = true
        indicatorView.style = .large
        indicatorView.color = .white
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        return indicatorView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let margins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        contentView.frame = contentView.frame.inset(by: margins)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .white
        contentView.addSubview(mainView)
        mainView.addSubviews(movieImageView, movieImageOverlay, titleLbl, activityIndicatorView)
        addViewsConstraints()
        activityIndicatorView.startAnimating()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        movieImageView.image = nil
    }
    
    private func addViewsConstraints() {
        mainView.anchors(to: contentView)
        movieImageView.anchors(to: mainView)
        movieImageOverlay.anchors(to: mainView)
        
        titleLbl.leadingAnchor(to: mainView, plus: 10)
        titleLbl.traillingAnchor(to: mainView, plus: -10)
        titleLbl.bottomAnchor(to: mainView, plus: -10)
        
        activityIndicatorView.centerAnchor(in: mainView)
    }
    
    func configCell(withDataOf movie: Movie?) {
        if let movie = movie {
            titleLbl.text = movie.title
            movieImageView.kf.setImage(with: movie.backdropUrl, placeholder: Images.dummy, options: [.transition(.fade(1.0))]) {
                _ in
                self.activityIndicatorView.stopAnimating()
            }
        } else {
            activityIndicatorView.startAnimating()
            movieImageView.image = Images.dummy
            titleLbl.text = ""
        }
        
    }

}

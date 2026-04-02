//
//  SingleImageViewController.swift
//  Image Feed
//
//  Created by Анастасия Федотова on 15.03.2026.
//

import UIKit
import Kingfisher

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    weak var delegate: ImagesListCellDelegate?
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .ypGray
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupActivityIndicator()
    }
    
    private func setupActivityIndicator() {
        contentView.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: likeButton.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cellImage.kf.cancelDownloadTask()
    }
    
    @IBAction private func likeButtonClicked() {
        delegate?.imageListCellDidTapLike(self)
    }
    
    func setIsLiked(_ isLiked: Bool) {
        let likeImage = isLiked ? UIImage(resource: .favouritesActive) : UIImage(resource: .favouritesNoActive)
        likeButton.setImage(likeImage, for: .normal)
    }
    
    func setIsLoading(_ isLoading: Bool) {
        if isLoading {
            activityIndicator.startAnimating()
            likeButton.isHidden = true
        } else {
            activityIndicator.stopAnimating()
            likeButton.isHidden = false
        }
    }
}

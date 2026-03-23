//
//  SingleImageViewController.swift
//  Image Feed
//
//  Created by Анастасия Федотова on 16.03.2026.
//

import UIKit

final class SingleImageViewController: UIViewController {

    private enum Constants {
        static let minZoomScale: CGFloat = 0.1
        static let maxZoomScale: CGFloat = 1.5
    }

    // MARK: - IBOutlets
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var shareButton: UIButton!
    
    // MARK: - Public Properties
    
    var image: UIImage? {
        didSet {
            guard isViewLoaded, let image = image else { return }
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
        setupImage()
    }
    
    private func setupScrollView() {
        scrollView.delegate = self
        scrollView.minimumZoomScale = Constants.minZoomScale
        scrollView.maximumZoomScale = Constants.maxZoomScale
    }

    private func setupImage() {
        guard let image else { return }
        rescaleAndCenterImageInScrollView(image: image)
    }
    
    // MARK: - IBActions
    
    @IBAction private func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction private func didTapShareButton(_ sender: UIButton) {
        guard let image = imageView.image else { return }

           let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)

           present(activityVC, animated: true)
    }
    
    // MARK: - Private Methods
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        view.layoutIfNeeded()
        
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        
        let theoreticalScale = max(hScale, vScale)
        let scale = min(maxZoomScale, max(minZoomScale, theoreticalScale))
        
        let scaledWidth = imageSize.width * scale
        let scaledHeight = imageSize.height * scale
        imageView.frame = CGRect(origin: .zero, size: CGSize(width: scaledWidth, height: scaledHeight))
        imageView.image = image
        
        scrollView.contentSize = imageView.frame.size
        scrollView.setZoomScale(1.0, animated: false)
        scrollView.layoutIfNeeded()
        
        let offsetX = max((scrollView.contentSize.width - visibleRectSize.width) / 2, 0)
        let offsetY = max((scrollView.contentSize.height - visibleRectSize.height) / 2, 0)
        scrollView.setContentOffset(CGPoint(x: offsetX, y: offsetY), animated: false)
    }
    
}

// MARK: - UIScrollViewDelegate

extension SingleImageViewController: UIScrollViewDelegate {

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}

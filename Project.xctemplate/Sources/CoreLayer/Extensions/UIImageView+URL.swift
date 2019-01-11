//
//  UIImageView+URL.swift
//  NexusCustomer
//
//  Created by Ivan Epifanov on 11/22/18.
//  Copyright © 2018 Intellectsoft. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func setImage(from url: URL?,
                  contentMode: UIView.ContentMode = .scaleAspectFill,
                  placeholder: UIImage? = nil,
                  placeholderContentMode: UIView.ContentMode? = nil,
                  showSpinner: Bool = false,
                  requestModifier: ((URLRequest) -> URLRequest)? = nil,
                  completionClosure: ((DownloadImageResult, URL?) -> Bool)? = nil) {
        
        self.contentMode = placeholderContentMode ?? contentMode
        self.image = placeholder
        
        guard let url = url else {
            _ = completionClosure?(.failed, nil)
            return
        }
        
        var request = URLRequest(url: url, timeoutInterval: 60)
        if let requestModifier = requestModifier {
            request = requestModifier(request)
        }
        if let data = URLCache.shared.cachedResponse(for: request)?.data, let image = UIImage(data: data) {
            if completionClosure?(.cached, url) ?? true {
                self.contentMode = contentMode
                self.image = image
            }
        } else {
            if showSpinner {
                self.showSpinner()
            }
            URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                if let error = error {
                    debugPrint("Image_Download_ERROR: \(error.localizedDescription)")
                }
                
                guard let data = data, let image = UIImage(data: data) else {
                    DispatchQueue.main.async {
                        if completionClosure?(.failed, url) ?? true {
                            self?.hideSpinner()
                        }
                    }
                    return
                }
                
                if let response = response {
                    let cachedData = CachedURLResponse(response: response, data: data)
                    URLCache.shared.storeCachedResponse(cachedData, for: request)
                }
                DispatchQueue.main.async {
                    if completionClosure?(.downloaded, url) ?? true {
                        self?.hideSpinner()
                        self?.contentMode = contentMode
                        self?.image = image
                    }
                }
            }.resume()
        }
    }
}

private extension UIImageView {
    func showSpinner() {
        
        let indicatorView = UIActivityIndicatorView(style: .whiteLarge)
        indicatorView.startAnimating()
        addSubview(indicatorView)
        
        indicatorView.addCenterXConstraint(toView: self)
        indicatorView.addCenterYConstraint(toView: self)
        
    }
    func hideSpinner() {
        subviews.forEach { ($0 as? UIActivityIndicatorView)?.removeFromSuperview() }
    }
}

enum DownloadImageResult {
    case cached
    case failed
    case downloaded
}

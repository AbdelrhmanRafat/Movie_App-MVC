//
//  ImageViewExtension.swift
//  Movies_App_Intern
//
//  Created by Macbook on 07/02/2021.
//

import Foundation
import UIKit
extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleToFill) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }}
extension UIViewController {
  public func addActionSheetForiPad(actionSheet: UIAlertController) {
    if let popoverPresentationController = actionSheet.popoverPresentationController {
      popoverPresentationController.sourceView = self.view
        popoverPresentationController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.maxY, width: 0, height: 0)
      popoverPresentationController.permittedArrowDirections = []
    }
  }
}

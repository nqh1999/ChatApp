//
//  ImgCell.swift
//  ChatApp
//
//  Created by BeeTech on 09/12/2022.
//

import UIKit
import SDWebImage

class ImgCell: UITableViewCell {
    
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var imgView: UIImageView!
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    
    private var currentFrame: CGRect?
    private var zoomView: UIView?
    
    var finishDownload: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(zoomImage))
        self.addGestureRecognizer(tapGesture)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupImg(_ message: Message) {
        self.spinner.isHidden = false
        self.spinner.startAnimating()
        self.imgView.sd_setImage(with: URL(string: message.img)) {_,_,_,_ in
            self.spinner.stopAnimating()
        }
    }
    
    func setupSentImg() {
        self.stackView.alignment = .trailing
    }
    
    func setupReceivedImg() {
        self.stackView.alignment = .leading
    }
    
    // zoom - scale methods
    @objc private func zoomImage() {
        self.currentFrame = imgView.frame
        let zoomImgView = UIImageView(frame: currentFrame!)
        zoomImgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(zoom(_:))))
        zoomImgView.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(scale(_:))))
        zoomImgView.isUserInteractionEnabled = true
        zoomImgView.image = imgView.image
        
        zoomView = UIView(frame: window!.frame)
        zoomView?.backgroundColor = .white
        zoomView?.alpha = 0
        
        self.window?.addSubview(zoomView!)
        self.window?.addSubview(zoomImgView)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.zoomView?.alpha = 1
            zoomImgView.frame = CGRect(x: 0, y: 0, width: self.window!.frame.width, height: self.window!.frame.height)
            zoomImgView.contentMode = .scaleAspectFit
        }, completion: nil)
    }
    
    @objc private func zoom(_ tapGesture: UITapGestureRecognizer) {
        if let zoomOutImage = tapGesture.view {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
                zoomOutImage.frame = self.currentFrame!
                self.zoomView?.alpha = 0
            } completion: { (complete: Bool) in
                zoomOutImage.removeFromSuperview()
            }
            
        }
    }
    
    @objc private func scale(_ pinch: UIPinchGestureRecognizer) {
        if let view = pinch.view {
            let x = pinch.scale
            let y = pinch.scale
            view.transform = view.transform.scaledBy(x: x, y: y)
            pinch.scale = 1
        }
    }
}

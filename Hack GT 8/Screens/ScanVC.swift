//
//  ScanVC.swift
//  Hack GT 8
//
//  Created by Allen Su on 10/23/21.
//

import UIKit
import AVFoundation
class ScanVC: UIViewController {

    var video = AVCaptureVideoPreviewLayer()
    let session = AVCaptureSession()
    var backgroundImageView: UIImageView!
    
    var videoView: UIView!
    var cardView: UIView!
    var passImageView: UIImageView!
    var passLabel: UILabel!
    var nameLabel: UILabel!
    var dateLabel: UILabel!
    
    var pass: Bool!
    var name: String!
    var date: String!
    
    var scanAgainButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        pass = true
        name = "Allen"
        date = "09/10"
        configureBackgroundImageView()
        configureVideoView()
        configureVideo()
        configureCardView()
        configurePassImageView()
        configurePassLabel()
        configureNameLabel()
        configureDateLabel()
        configureScanAgain()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        video.frame.size = videoView.frame.size
        session.startRunning()
    }
    
    func configureVideoView() {
        videoView = UIView()
        videoView.frame = CGRect(origin: CGPoint(x: view.frame.width * 0.1, y: view.frame.height * 0.1), size: CGSize(width: view.frame.width * 0.8, height: view.frame.width * 0.8))
        view.addSubview(videoView)
        
    }
    
    func configureScanAgain() {
        scanAgainButton = UIButton()
        scanAgainButton.setTitle("Next Scan", for: .normal)
        scanAgainButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        scanAgainButton.setTitleColor(.black, for: .normal)
        scanAgainButton.translatesAutoresizingMaskIntoConstraints = false
        scanAgainButton.addTarget(self, action: #selector(nextScanTapped), for: .touchUpInside)
        view.addSubview(scanAgainButton)
        scanAgainButton.isEnabled = true
        scanAgainButton.isUserInteractionEnabled = true
        NSLayoutConstraint.activate([
            scanAgainButton.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 20),
            scanAgainButton.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            scanAgainButton.widthAnchor.constraint(equalToConstant: 100),
            scanAgainButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc func nextScanTapped() {
        if (!session.isRunning) {
            session.startRunning()
        }
    }
    
    func configureVideo() {
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            session.addInput(input)
        } catch {
        }
        

        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        video = AVCaptureVideoPreviewLayer(session: session)
        
        video.frame.size = videoView.frame.size
        video.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        videoView.layer.addSublayer(video)
        session.startRunning()
    }
    
    func getQRString(text: String) {
        let session = URLSession.shared
        let urlString = "https://chain-the-passport.uk.r.appspot.com/validate?metadata=\(text)"
        guard let url = URL(string: urlString) else { return }
        let task = session.dataTask(with: url, completionHandler: { data, response, error in
            if error != nil {
                return
            }

        })
        task.resume()
    }
    
    func updateFields() {
        guard let isPass = pass else {
            return
        }
        if (isPass) {
            passImageView.image = UIImage(named: "Checkmark")
            passLabel.text = "Pass Valid"
            
        } else {
            passImageView.image = UIImage(named: "Cross")
            passLabel.text = "Pass Invalid"
        }
        guard let name = name, let date = date else { return }
        nameLabel.text = name
        dateLabel.text = date
    }
    
    func configureCardView() {
        cardView = UIView()
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.backgroundColor = .systemBackground
        cardView.layer.cornerRadius = 16
        cardView.layer.shadowColor = UIColor.lightGray.cgColor
        cardView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        cardView.layer.shadowRadius = 8.0
        cardView.layer.shadowOpacity = 0.5
        view.addSubview(cardView)
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: videoView.bottomAnchor, constant: 30),
            cardView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cardView.widthAnchor.constraint(equalToConstant: view.frame.width * 0.8),
            cardView.heightAnchor.constraint(equalToConstant: view.frame.height * 0.3)
        ])
    }
    
    func configurePassImageView() {
        passImageView = UIImageView()
        
        passImageView.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(passImageView)
        
        NSLayoutConstraint.activate([
            passImageView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 10),
            passImageView.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            passImageView.widthAnchor.constraint(equalToConstant: view.frame.height * 0.1),
            passImageView.heightAnchor.constraint(equalToConstant: view.frame.height * 0.1)
        ])
        
    }
    
    func configurePassLabel() {
        passLabel = UILabel()
        passLabel.translatesAutoresizingMaskIntoConstraints = false
        passLabel.textAlignment = .center
        passLabel.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
        cardView.addSubview(passLabel)
        NSLayoutConstraint.activate([
            passLabel.topAnchor.constraint(equalTo: passImageView.bottomAnchor, constant: 10),
            passLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 30),
            passLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -30),
            passLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func configureNameLabel() {
        nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        cardView.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: passLabel.bottomAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 30),
            nameLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -30),
            nameLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func configureDateLabel() {
        dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.textAlignment = .center
        dateLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        cardView.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            dateLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 30),
            dateLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -30),
            dateLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func configureBackgroundImageView() {
        backgroundImageView = UIImageView(image: gradientBackground)
        backgroundImageView.contentMode = .scaleToFill
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundImageView)
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

}

extension ScanVC: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if (!metadataObjects.isEmpty) {
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject {
                if object.type == AVMetadataObject.ObjectType.qr {
                    
                    getQRString(text: object.stringValue!)
                    session.stopRunning()
                    updateFields()
                }
            }
        }
    }
}

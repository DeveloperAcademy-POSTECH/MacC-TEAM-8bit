//
//  ExportViewController.swift
//  OrrRock
//
//  Created by kimhyeongmin on 2022/11/23.
//

import UIKit
import Photos
import SnapKit

class ExportViewController: UIViewController, UINavigationBarDelegate {
    
    var videoInformation: VideoInformation!
    var videoAsset: PHAsset?
    var level: Int = 0
    
    private lazy var previewVideoView: UIView = {
        let view = UIView()
        view.backgroundColor = .orrGray200
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.layoutSubviews()
        
        return view
    }()
    
    private lazy var orrLogo: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "V0")
        
        return imgView
    }()
    
    private lazy var orrTextLogo: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "ORRROCK")
        
        return imgView
    }()
    
    private lazy var calendarIcon: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "calandarIcon")
        
        return imgView
    }()
    
    private lazy var gymIcon: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "gymIcon")
        
        return imgView
    }()
    
    private lazy var gradation: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "gradation")
        
        return imgView
    }()
    
    private lazy var gymName: UILabel = {
        let label = UILabel()
        label.text = videoInformation.gymName
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: UIFont.labelFontSize)
        
        return label
    }()
    
    private lazy var gymVisitDate: UILabel = {
        let label = UILabel()
        label.text = videoInformation.gymVisitDate.timeToString()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: UIFont.labelFontSize)
        
        return label
    }()
    
    lazy var videoPlayView: VideoPlayView = {
        let view = VideoPlayView(videoAsset: videoAsset)
        
        return view
    }()
    
    private lazy var colorPickerView: ColorPickerView = {
        let view = ColorPickerView()
        //???????????? ??????????????? ?????????
        view.pickerSelectValue = 0
        view.delegate = self
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setNavigationBar()
        view.backgroundColor = .orrGray100
    }
    
    override func viewDidLayoutSubviews() {
        addVideoLayer()
    }
    
    func setNavigationBar() {
        let navbar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 75))
        navbar.delegate = self
        
        let navItem = UINavigationItem()
        navItem.title = "????????? ??????"
        navItem.leftBarButtonItem = UIBarButtonItem(title: "??????", style: .plain, target: self, action: #selector(cancelAction))
        navItem.rightBarButtonItem = UIBarButtonItem(title: "??????", style: .plain, target: self, action: #selector(completeAction))
        
        navbar.items = [navItem]
        
        view.addSubview(navbar)
    }
    
    @objc private func completeAction() {
        saveVideo()
        CustomIndicator.startLoading()
    }
    
    @objc private func cancelAction() {
        self.dismiss(animated: true)
    }
    
    private func saveVideo() {
        PHImageManager().requestAVAsset(forVideo: videoAsset!, options: nil) { (asset, audioMix, info) in
            let avUrlAsset = asset as! AVURLAsset
            
            DispatchQueue.main.async {
                self.exportVideo(videoUrlAsset: avUrlAsset, level: self.level) { url in
                    UISaveVideoAtPathToSavedPhotosAlbum(url!.path, self, #selector(self.saveCheck), nil)
                }
            }
        }
    }
    
    @objc func saveCheck(_ videoPath: String, didFinishSavingWithError error: Error?, contextInfo:  UnsafeMutableRawPointer?) {
        if let error = error {
            let alert = UIAlertController(title: "????????? ????????? ??? ????????????.", message: "????????? ???????????? ??? ????????? ?????????????????????.\n?????? ????????? ?????????\n\n?????? ?????? \n\(error)", preferredStyle: .alert)
            
            let confirm = UIAlertAction(title: "??????", style: .default) { _ in
                self.dismiss(animated: true)
            }
            
            alert.addAction(confirm)
            return
        }
        CustomIndicator.stopLoading()
        self.dismiss(animated: true)
    }
}

extension ExportViewController {
    private func setLayout() {
        view.addSubview(colorPickerView)
        colorPickerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-34)
            $0.height.equalTo(70)
        }
        
        view.addSubview(previewVideoView)
        previewVideoView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.snp.top).offset(100)
            $0.bottom.equalTo(colorPickerView.snp.top).offset(-32)
            $0.width.equalTo(previewVideoView.snp.height).multipliedBy(0.5625)
        }
        
        
        previewVideoView.addSubview(videoPlayView)
        videoPlayView.snp.makeConstraints {
            $0.height.equalToSuperview()
            $0.width.equalToSuperview()
            $0.center.equalToSuperview()
        }
    }
    
    private func addVideoLayer() {
        previewVideoView.addSubview(gradation)
        gradation.snp.makeConstraints {
            $0.height.equalToSuperview()
            $0.width.equalToSuperview()
            $0.center.equalToSuperview()
        }
        
        previewVideoView.addSubview(orrLogo)
        orrLogo.snp.makeConstraints {
            $0.height.equalToSuperview().multipliedBy(0.0485)
            $0.width.equalTo(orrLogo.snp.height).multipliedBy(0.9139)
            $0.top.equalToSuperview().offset(previewVideoView.frame.height*0.0901)
            $0.left.equalToSuperview().offset(previewVideoView.frame.width*0.4722)
        }
        
        previewVideoView.addSubview(orrTextLogo)
        orrTextLogo.snp.makeConstraints {
            $0.height.equalToSuperview().multipliedBy(0.0239)
            $0.width.equalTo(orrTextLogo.snp.height).multipliedBy(8.8260)
            $0.top.equalToSuperview().offset(previewVideoView.frame.height*0.1055)
            $0.left.equalToSuperview().offset(previewVideoView.frame.width*0.5859)
        }
        
        previewVideoView.addSubview(calendarIcon)
        calendarIcon.snp.makeConstraints {
            $0.height.equalToSuperview().multipliedBy(0.0265)
            $0.width.equalTo(calendarIcon.snp.height).multipliedBy(1.1960)
            $0.top.equalToSuperview().offset(previewVideoView.frame.height*0.8364)
            $0.left.equalToSuperview().offset(previewVideoView.frame.width*0.0641)
        }
        
        previewVideoView.addSubview(gymIcon)
        gymIcon.snp.makeConstraints {
            $0.height.equalToSuperview().multipliedBy(0.0375)
            $0.width.equalTo(gymIcon.snp.height).multipliedBy(0.9027)
            $0.top.equalToSuperview().offset(previewVideoView.frame.height*0.8895)
            $0.left.equalToSuperview().offset(previewVideoView.frame.width*0.0613)
        }
        
        previewVideoView.addSubview(gymVisitDate)
        gymVisitDate.snp.makeConstraints {
            $0.top.equalToSuperview().offset(previewVideoView.frame.height*0.8348)
            $0.left.equalToSuperview().offset(previewVideoView.frame.width*0.1465)
            gymVisitDate.font = .boldSystemFont(ofSize: previewVideoView.frame.height*0.025)
        }
        
        previewVideoView.addSubview(gymName)
        gymName.snp.makeConstraints {
            $0.top.equalToSuperview().offset(previewVideoView.frame.height*0.8973)
            $0.left.equalToSuperview().offset(previewVideoView.frame.width*0.1465)
            gymName.font = .boldSystemFont(ofSize: previewVideoView.frame.height*0.025)
        }
    }
}

extension ExportViewController {
    func exportVideo(
        videoUrlAsset: AVURLAsset, level: Int, completion: @escaping (URL?) -> Void) -> () {
            
            // ?????? ????????? ???????????? ??????
            let mutableComposition = AVMutableComposition()
            
            // AVAssetTrack (Video) ??????
            let videoAssetTrack = videoUrlAsset.tracks(withMediaType: AVMediaType.video).first!
            
            // AVMutableComposition??? AVMutableCompositionTrack (Video) ??????
            let videoCompositionTrack = mutableComposition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: kCMPersistentTrackID_Invalid)
            
            // AVAssetTrack(????????? ??? ?????? ???????????? ??????)?????? AVMutableCompositionTrack(????????? ??? ?????? ???????????? ??????)?????? ????????? ??????
            videoCompositionTrack?.preferredTransform = videoAssetTrack.preferredTransform
            
            // ?????? ?????? ??????
            let size = videoAssetTrack.naturalSize.applying(videoAssetTrack.preferredTransform)
            let videoHeight = size.height
            let videoWidth = size.width
            if videoHeight < videoWidth {
                videoCompositionTrack?.preferredTransform = CGAffineTransform(scaleX: 1.78, y: 1.78)
            }
            
            // AVMutableCompositionTrack??? 0 ?????? videoAssetTrack??? ?????? ????????? ?????? asset??? ?????? ????????? ??????????????? ??????
            try! videoCompositionTrack?.insertTimeRange(CMTimeRange(start:CMTime.zero, duration:videoAssetTrack.timeRange.duration), of: videoAssetTrack, at: CMTime.zero)
            
            // AVAssetTrack (Audio) ??????
            let audioTracks = videoUrlAsset.tracks(withMediaType: AVMediaType.audio)
            
            // AVMutableComposition??? AVMutableCompositionTrack (Audio) ??????
            let compositionAudioTrack:AVMutableCompositionTrack = mutableComposition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: CMPersistentTrackID())!
            
            // AVMutableCompositionTrack??? 0 ?????? audioTrack??? ?????? ????????? ?????? asset??? ?????? ????????? ??????????????? ??????
            for audioTrack in audioTracks {
                try! compositionAudioTrack.insertTimeRange(audioTrack.timeRange, of: audioTrack, at: CMTime.zero)
            }
            
            let frame = CGRect(x: 0.0, y: 0.0, width: 1080, height: 1920)
            
            // ???????????? ?????? ????????????, ???????????? ?????? ????????? ??????
            let videoLayer = CALayer()
            videoLayer.frame = frame
            
            let imageLayer = CALayer()
            imageLayer.frame = frame
            
            // ??????????????? ??????
            let gradationLayer = CALayer()
            let gradationImage = UIImage(named: "gradation")?.cgImage
            gradationLayer.frame = frame
            gradationLayer.contents = gradationImage
            imageLayer.addSublayer(gradationLayer)
            
            // ?????? ????????? ??????
            let logoImageLayer = CALayer()
            let logoImage = UIImage(named: "V\(level)")?.cgImage
            logoImageLayer.frame = CGRect(x: 510.28, y: 1645, width: 93.22, height: 102)
            logoImageLayer.contents = logoImage
            imageLayer.addSublayer(logoImageLayer)
            
            // ?????? ????????? ??????
            let logoTextLayer = CALayer()
            let logoText = UIImage(named: "ORRROCK")?.cgImage
            logoTextLayer.frame = CGRect(x: 632.86, y: 1671.35, width:  406, height: 46)
            logoTextLayer.contents = logoText
            imageLayer.addSublayer(logoTextLayer)
            
            // ?????? ????????? ??????
            let dateImageLayer = CALayer()
            let dateImage = UIImage(named: "calandarIcon")?.cgImage
            dateImageLayer.frame = CGRect(x: 69.28, y: 260, width: 61, height: 51)
            dateImageLayer.contents = dateImage
            imageLayer.addSublayer(dateImageLayer)
            
            // ?????? ??????
            let dateTextLayer = CATextLayer()
            dateTextLayer.contentsScale = UIScreen.main.scale
            dateTextLayer.fontSize = 48.0
            dateTextLayer.alignmentMode = .left
            dateTextLayer.frame = imageLayer.frame
            dateTextLayer.anchorPoint = CGPoint(x: 0, y: 1)
            dateTextLayer.position = CGPoint(x: 162.28, y: 317)
            dateTextLayer.string = videoInformation.gymVisitDate.timeToString()
            dateTextLayer.foregroundColor = UIColor.white.cgColor
            imageLayer.addSublayer(dateTextLayer)
            
            // ?????? ????????? ??????
            let gymImageLayer = CALayer()
            let gymImage = UIImage(named: "gymIcon")?.cgImage
            gymImageLayer.frame = CGRect(x: 66.28, y: 133, width: 65, height: 72)
            gymImageLayer.contents = gymImage
            imageLayer.addSublayer(gymImageLayer)
            
            // ?????? ??????
            let gymTextLayer = CATextLayer()
            gymTextLayer.fontSize = 48.0
            gymTextLayer.alignmentMode = .left
            gymTextLayer.frame = imageLayer.bounds
            gymTextLayer.anchorPoint = CGPoint(x: 0, y: 1)
            gymTextLayer.position = CGPoint(x: 162.28, y: 197)
            gymTextLayer.foregroundColor = UIColor.white.cgColor
            gymTextLayer.string = videoInformation.gymName
            gymTextLayer.contentsScale = UIScreen.main.scale
            imageLayer.addSublayer(gymTextLayer)
            
            // ?????? ?????? ?????? ?????? ????????? ??????
            let animationLayer = CALayer()
            animationLayer.frame = frame
            
            // videoLayer??? ?????? ????????? ???????????? ??????????????? ?????????????????? ????????? animationLayer??? ?????? ?????? ?????? ??? ????????? ???
            animationLayer.addSublayer(videoLayer)
            animationLayer.addSublayer(imageLayer)
            
            let videoComposition = AVMutableVideoComposition(propertiesOf: (videoCompositionTrack?.asset)!)
            // videoLayer?????? ????????? ????????? ???????????? ?????? ?????? animationLayer??? ????????? ?????? ?????? ???????????? ??????
            videoComposition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videoLayer, in: animationLayer)
            // ????????? ???????????? ?????? ?????? FHD ???????????? ??????
            videoComposition.renderSize = CGSize(width: 1080, height: 1920)
            
            let documentDirectory = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first!
            let documentDirectoryUrl = URL(fileURLWithPath: documentDirectory)
            
            // ????????? ?????? ????????? ?????? ?????? export ??????(??????????????????)??? ???????????? ??????
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMddHHmmss"
            let date = dateFormatter.string(from: Date())
            let destinationFilePath = documentDirectoryUrl.appendingPathComponent("\(date)_OrrRock.mp4")
            
            //
            let exportSession = AVAssetExportSession( asset: mutableComposition, presetName: AVAssetExportPresetHighestQuality)!
            
            exportSession.videoComposition = videoComposition
            exportSession.outputURL = destinationFilePath
            exportSession.outputFileType = AVFileType.mp4
            exportSession.exportAsynchronously { [weak exportSession] in
                if let strongExportSession = exportSession {
                    completion(strongExportSession.outputURL!)
                }
            }
        }
}

extension ExportViewController : ColorPickerViewDelegate{
    func didColorChanged(selectedColorValue: Int) {
        level = selectedColorValue
        orrLogo.image = UIImage(named: "V\(level)")
    }
}

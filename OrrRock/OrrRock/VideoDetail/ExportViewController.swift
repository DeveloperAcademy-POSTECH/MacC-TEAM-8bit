//
//  ExportViewController.swift
//  OrrRock
//
//  Created by kimhyeongmin on 2022/11/23.
//

import UIKit
import Photos

class ExportViewController: UIViewController, UINavigationBarDelegate {
    
    var videoInformation: VideoInformation!
    var videoAsset: PHAsset?
    
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
        label.textColor = .orrWhite
        label.font = UIFont.boldSystemFont(ofSize: UIFont.labelFontSize)
        
        return label
    }()
    
    private lazy var gymVisitDate: UILabel = {
        let label = UILabel()
        label.text = videoInformation.gymVisitDate.timeToString()
        label.textColor = .orrWhite
        label.font = UIFont.boldSystemFont(ofSize: UIFont.labelFontSize)
        
        return label
    }()
    
    lazy var videoPlayView: VideoPlayView = {
        let view = VideoPlayView(videoAsset: videoAsset)
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setNavigationBar()
        view.backgroundColor = .orrWhite
    }
    
    override func viewDidLayoutSubviews() {
        addVideoLayer()
    }
    
    func setNavigationBar() {
        let navbar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 75))
        navbar.backgroundColor = UIColor.orrWhite
        navbar.delegate = self
        
        let navItem = UINavigationItem()
        navItem.title = "사진에 저장"
        navItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelAction))
        navItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(completeAction))
        
        navbar.items = [navItem]
        
        view.addSubview(navbar)
    }
    
    @objc private func completeAction() {
        saveVideo()
    }
    
    @objc private func cancelAction() {
        self.dismiss(animated: true)
    }
    
    private func saveVideo() {
            PHImageManager().requestAVAsset(forVideo: videoAsset!, options: nil) { (asset, audioMix, info) in
                let avUrlAsset = asset as! AVURLAsset
                
                DispatchQueue.main.async {
                    self.merge(videoUrlAsset: avUrlAsset) { url in
                        UISaveVideoAtPathToSavedPhotosAlbum(url!.path, self, #selector(self.saveCheck), nil)
                    }
                }
            }
        }
    
    @objc func saveCheck(_ videoPath: String, didFinishSavingWithError error: Error?, contextInfo:  UnsafeMutableRawPointer?) {
            if let error = error {
                print(error)
                return
            }
            print("success")
        }
}
    
extension ExportViewController {
    private func setLayout() {
        view.addSubview(previewVideoView)
        previewVideoView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.snp.top).offset(100)
            $0.bottom.equalTo(view.snp.bottom).inset(100)
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
    func merge(
        videoUrlAsset: AVURLAsset, completion: @escaping (URL?) -> Void) -> () {
            
            // 변경 가능한 컴포지션 생성
            let mutableComposition = AVMutableComposition()
            
            // AVAssetTrack (Video) 선언
            let videoAssetTrack = videoUrlAsset.tracks(withMediaType: AVMediaType.video).first!
            
            // AVMutableComposition에 AVMutableCompositionTrack (Video) 추가
            let videoCompositionTrack = mutableComposition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: kCMPersistentTrackID_Invalid)
            
            // AVAssetTrack(변경할 수 없는 컴포지션 트랙)에서 AVMutableCompositionTrack(변경할 수 있는 컴포지션 트랙)으로 데이터 변환
            videoCompositionTrack?.preferredTransform = videoAssetTrack.preferredTransform
            
            // 가로 영상 대응
            let size = videoAssetTrack.naturalSize.applying(videoAssetTrack.preferredTransform)
            let videoHeight = size.height
            let videoWidth = size.width
            if videoHeight < videoWidth {
                videoCompositionTrack?.preferredTransform = CGAffineTransform(scaleX: 1.78, y: 1.78)
            }
            
            // AVMutableCompositionTrack에 0 부터 videoAssetTrack의 시간 범위에 대한 asset의 모든 트랙을 컴포지션에 삽입
            try! videoCompositionTrack?.insertTimeRange(CMTimeRange(start:CMTime.zero, duration:videoAssetTrack.timeRange.duration), of: videoAssetTrack, at: CMTime.zero)
            
            // AVAssetTrack (Audio) 선언
            let audioTracks = videoUrlAsset.tracks(withMediaType: AVMediaType.audio)
            
            // AVMutableComposition에 AVMutableCompositionTrack (Audio) 추가
            let compositionAudioTrack:AVMutableCompositionTrack = mutableComposition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: CMPersistentTrackID())!
            
            // AVMutableCompositionTrack에 0 부터 audioTrack의 시간 범위에 대한 asset의 모든 트랙을 컴포지션에 삽입
            for audioTrack in audioTracks {
                try! compositionAudioTrack.insertTimeRange(audioTrack.timeRange, of: audioTrack, at: CMTime.zero)
            }
            
            let frame = CGRect(x: 0.0, y: 0.0, width: 1080, height: 1920)
            
            // 비디오를 담을 레이어와, 이미지를 담을 레이어 선언
            let videoLayer = CALayer()
            videoLayer.frame = frame
            
            let imageLayer = CALayer()
            imageLayer.frame = frame
            
            // 그라데이션 추가
            let gradationLayer = CALayer()
            let gradationImage = UIImage(named: "gradation")?.cgImage
            gradationLayer.frame = frame
            gradationLayer.contents = gradationImage
            imageLayer.addSublayer(gradationLayer)

            // 로고 이미지 추가
            let logoImageLayer = CALayer()
            // FIXME: 레벨별 다른 이미지 가져오기
            let logoImage = UIImage(named: "V0")?.cgImage
            logoImageLayer.frame = CGRect(x: 510.28, y: 1645, width: 93.22, height: 102)
            logoImageLayer.contents = logoImage
            imageLayer.addSublayer(logoImageLayer)

            // 로고 텍스트 추가
            let logoTextLayer = CALayer()
            let logoText = UIImage(named: "ORRROCK")?.cgImage
            logoTextLayer.frame = CGRect(x: 632.86, y: 1671.35, width:  406, height: 46)
            logoTextLayer.contents = logoText
            imageLayer.addSublayer(logoTextLayer)
            
            // 날짜 아이콘 추가
            let dateImageLayer = CALayer()
            let dateImage = UIImage(named: "calandarIcon")?.cgImage
            dateImageLayer.frame = CGRect(x: 69.28, y: 260, width: 61, height: 51)
            dateImageLayer.contents = dateImage
            imageLayer.addSublayer(dateImageLayer)
            
            // 날짜 추가
            let dateTextLayer = CATextLayer()
            dateTextLayer.contentsScale = UIScreen.main.scale
            dateTextLayer.fontSize = 48.0
            dateTextLayer.alignmentMode = .left
            dateTextLayer.frame = imageLayer.frame
            dateTextLayer.anchorPoint = CGPoint(x: 0, y: 1)
            dateTextLayer.position = CGPoint(x: 162.28, y: 317)
            dateTextLayer.string = videoInformation.gymVisitDate.timeToString()
            dateTextLayer.foregroundColor = UIColor.orrWhite?.cgColor
            imageLayer.addSublayer(dateTextLayer)
            
            // 암장 아이콘 추가
            let gymImageLayer = CALayer()
            let gymImage = UIImage(named: "gymIcon")?.cgImage
            gymImageLayer.frame = CGRect(x: 66.28, y: 133, width: 65, height: 72)
            gymImageLayer.contents = gymImage
            imageLayer.addSublayer(gymImageLayer)
            
            // 암장 추가
            let gymTextLayer = CATextLayer()
            gymTextLayer.fontSize = 48.0
            gymTextLayer.alignmentMode = .left
            gymTextLayer.frame = imageLayer.bounds
            gymTextLayer.anchorPoint = CGPoint(x: 0, y: 1)
            gymTextLayer.position = CGPoint(x: 162.28, y: 197)
            gymTextLayer.foregroundColor = UIColor.orrWhite?.cgColor
            gymTextLayer.string = videoInformation.gymName
            gymTextLayer.contentsScale = UIScreen.main.scale
            imageLayer.addSublayer(gymTextLayer)

            // 영상 위에 얹을 추가 레이어 선언
            let animationLayer = CALayer()
            animationLayer.frame = frame
            
            // videoLayer는 다른 레이어 트리에서 가져오거나 추가되어서는 안되고 animationLayer의 하위 계층 트리 에 있어야 함
            animationLayer.addSublayer(videoLayer)
            animationLayer.addSublayer(imageLayer)
            
            let videoComposition = AVMutableVideoComposition(propertiesOf: (videoCompositionTrack?.asset)!)
            // videoLayer안의 합성된 비디오 프레임을 배치 하고 animationLayer를 렌더링 하여 최종 프레임을 생성
            videoComposition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videoLayer, in: animationLayer)
            // 랜더링 사이즈를 세로 방향 FHD 해상도로 고정
            videoComposition.renderSize = CGSize(width: 1080, height: 1920)
            
            let documentDirectory = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first!
            let documentDirectoryUrl = URL(fileURLWithPath: documentDirectory)
            
            // 고유한 이름 생성을 위해 영상 export 시간(연월일시분초)을 제목으로 설정
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

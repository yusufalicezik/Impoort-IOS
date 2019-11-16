//
//  AVPlayerView.swift
//  VideoPlayerDemo
//
//  Created by Kushida　Eiji on 2015/12/05.
//  Copyright © 2015年 Kushida　Eiji. All rights reserved.
//

import UIKit
import AVFoundation
protocol videoPlayerProtocol {
    func didSelectVideoFullScreen()
    func didFinishVideo()
    func didPlayVideo()
    func didLoadVideo()
}
class AVPlayerView: UIView{
    //@IBOutlet weak var btnMute: UIButton!
    
    //@IBOutlet weak var btnFullScreen: UIButton!
    
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    @IBOutlet weak var parentView: UIView!
    var delegate:videoPlayerProtocol?
    var player: AVPlayer? {
        get {
            let layer = self.layer as! AVPlayerLayer
            if(layer.player != nil){
                return layer.player!
            }else{
                return AVPlayer()
            }
            
        }
        set(newValue) {
            let layer = self.layer as! AVPlayerLayer
            layer.player = newValue
        }
    }
    
    override class var layerClass : AnyClass {
        return AVPlayerLayer.self
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //ownFirstNib()
        setup()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //ownFirstNib()
        setup()
        
    }
    func setup(){
        player?.isMuted = true
    }
    func setVideoFillMode(_ mode: String) {
        let layer = self.layer as! AVPlayerLayer
        layer.videoGravity = AVLayerVideoGravity(rawValue: mode)
       layer.masksToBounds = true

        layer.cornerRadius = 15
    }
    func setupVideoView(path: String) {
        if(!path.isEmpty){
           
            //self.btnFullScreen.addTarget(self, action: #selector(self.fullScreen), for: .touchUpInside)
            
           // self.addSubview(fullScreenButton)
            
            self.addVideoEnd()
            
         
            let url:URL? = (player?.currentItem?.asset as? AVURLAsset)?.url
            
            if(url?.absoluteString == path){
                reinitializePlayerLayer()
                
            }else{
                let avAsset = AVURLAsset(url: URL(string: path)!,
                                         options: nil)
                let playerItem = AVPlayerItem(asset: avAsset)
                player = AVPlayer(playerItem: playerItem)
                player?.currentItem!.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions(), context: nil)

                //player?.play()
                
                delegate?.didPlayVideo()
                
                //self.indicatorView.startAnimating()
                //self.indicatorView.isHidden = false
            }
            
            
            
            
            
            
            
            NotificationCenter.default.addObserver(self, selector: #selector(playerItemReachedEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
            NotificationCenter.default.addObserver(self, selector: #selector(setPlayerLayerToNil), name: UIApplication.didEnterBackgroundNotification, object: nil)
            
            // foreground event
          //  NotificationCenter.default.addObserver(self, selector: #selector(reinitializePlayerLayer), name: .UIApplicationWillEnterForeground, object: nil)
            
            // add these 2 notifications to prevent freeze on long Home button press and back
            NotificationCenter.default.addObserver(self, selector: #selector(setPlayerLayerToNil), name: UIApplication.willResignActiveNotification, object: player?.currentItem)
            
         //   NotificationCenter.default.addObserver(self, selector: #selector(reinitializePlayerLayer), name: Notification.Name.UIApplicationDidBecomeActive, object: nil)
        }
        
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if player?.currentItem?.status == AVPlayerItem.Status.readyToPlay {
            print("a")
            delegate?.didLoadVideo()
            //self.indicatorView.stopAnimating()
            //self.indicatorView.isHidden = true
        }
    }
    
    @objc fileprivate func playerItemReachedEnd(){
        // this works like a rewind button. It starts the player over from the beginning
        player?.seek(to: CMTime.zero)
        //NuLog.printLog("playerItemReachedEnd", "")
    }
    
    // background event
    @objc fileprivate func setPlayerLayerToNil(){
        // first pause the player before setting the playerLayer to nil. The pause works similar to a stop button
        player?.pause()
        
        
    }
    @objc func fullScreen(){
        delegate?.didSelectVideoFullScreen()
    }
    @objc fileprivate func reinitializePlayerLayer(){
        //NuLog.printLog("reinitializePlayerLayer", "")
        if let player = player{
            
            //self.l = AVPlayerLayer(player: player)
            
            if #available(iOS 10.0, *) {
                if player.timeControlStatus == .paused{
                    player.play()
                }
            } else {
                // if app is running on iOS 9 or lower
                if player.isPlaying == false{
                    player.play()
                }
            }
        }
    }
    
    fileprivate func addVideoEnd() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.onVideoEnd),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: nil)
    }
    @objc func onVideoEnd(){
        delegate?.didFinishVideo()
        //NuLog.printLog("AVPLyer finish video", "")
    }
    
    
    @IBAction func actMute(_ sender: Any) {
        if(player?.isMuted)!{
            player?.isMuted = false
             //btnMute.setImage(UIImage(named: "sound"), for: .normal)
        }else{
            //btnMute.setImage(UIImage(named: "volumeMute"), for: .normal)
            player?.isMuted = true
        }
        
    }
    
    public func removeVideoEnd() {
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                                  object: nil)
        
    }
    
    
    
}



extension AVPlayer{
    
    var isPlaying: Bool{
        return rate != 0 && error == nil
    }
}

//
//  ViewController.swift
//  MergeVideo
//
//  Created by Anil on 03/06/15.
//  Copyright (c) 2015 Variya Soft Solutions. All rights reserved.
//

import UIKit
import MediaPlayer
import MobileCoreServices
import AVFoundation

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var moviewView: UIView!
    @IBOutlet weak var transprentView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    let documentsDirectoryURL = NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false, error: nil)!
    var firstVideoRecorded = false
    var secondVideoRecorded = false
    
    var video1URL:NSURL!
    var video2URL:NSURL!
    var mergedVideoURL:NSURL?
    
    var avPlayerLayer = AVPlayerLayer()
    var avPlayer = AVPlayer()

    var player: Player!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        transprentView.hidden = true
    }

    @IBAction func recordFirst(sender: AnyObject) {
        
        firstVideoRecorded = true
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            
            
            println("captureVideoPressed and camera available.")
            
            var imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType = .Camera;
            imagePicker.mediaTypes = [kUTTypeMovie!]
            imagePicker.allowsEditing = false
            imagePicker.showsCameraControls = true
            self.presentViewController(imagePicker, animated: true, completion: nil)
            
        } else {
            
            println("Camera not available.")
        }
    }
    
    @IBAction func recoedSecond(sender: AnyObject) {
        
        secondVideoRecorded = true
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            
            
            println("captureVideoPressed and camera available.")
            
            var imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType = .Camera;
            imagePicker.mediaTypes = [kUTTypeMovie!]
            imagePicker.allowsEditing = false
            imagePicker.showsCameraControls = true
            self.presentViewController(imagePicker, animated: true, completion: nil)
            
        } else {
            
            println("Camera not available.")
        }
    }
    
    @IBAction func mergeVideo(sender: AnyObject) {

        if video1URL != nil && video2URL != nil {
            
            exportVideo3()
            
        } else {
            
            var alert = UIAlertController(title: "Alert", message: "Please Record Video First", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func playVideo1(sender: AnyObject) {
        
        if video1URL == nil {
            var alert = UIAlertController(title: "Alert", message: "Please Record Video First", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
        } else {
            
            let asset:AVURLAsset = AVURLAsset(URL: video1URL, options: nil)
            
            let newPlayerItem:AVPlayerItem = AVPlayerItem(asset: asset)
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("videoPlayBackDidFinish"), name: AVPlayerItemDidPlayToEndTimeNotification, object: newPlayerItem)
            
            self.avPlayer = AVPlayer(playerItem: newPlayerItem)
            self.avPlayerLayer = AVPlayerLayer(player: self.avPlayer)
            self.avPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
            
            self.avPlayerLayer.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
            
            self.view.layer.addSublayer(self.avPlayerLayer)
            self.view.layoutIfNeeded()
            
            self.avPlayer.play()

        }
    }
    
    func videoPlayBackDidFinish() {
        
        println("video playback did finish")
        self.avPlayerLayer.removeFromSuperlayer()
        NSNotificationCenter.defaultCenter().removeObserver(self, name: AVPlayerItemDidPlayToEndTimeNotification, object: self.avPlayer)
    }
    
    @IBAction func playVideo2(sender: AnyObject) {
        
        if video2URL == nil {
            var alert = UIAlertController(title: "Alert", message: "Please Record Video First", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
        } else {
            
            let asset:AVURLAsset = AVURLAsset(URL: video2URL, options: nil)
            
            let newPlayerItem:AVPlayerItem = AVPlayerItem(asset: asset)
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("videoPlayBackDidFinish"), name: AVPlayerItemDidPlayToEndTimeNotification, object: newPlayerItem)
            
            self.avPlayer = AVPlayer(playerItem: newPlayerItem)
            self.avPlayerLayer = AVPlayerLayer(player: self.avPlayer)
            self.avPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
            
            self.avPlayerLayer.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
            
            self.view.layer.addSublayer(self.avPlayerLayer)
            self.view.layoutIfNeeded()
            
            self.avPlayer.play()
        }
    }
    @IBAction func playMergedVideo(sender: AnyObject) {
        
        if let mergedVideoURL = mergedVideoURL {
            
            let asset:AVURLAsset = AVURLAsset(URL: mergedVideoURL, options: nil)
            
            let newPlayerItem:AVPlayerItem = AVPlayerItem(asset: asset)
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("videoPlayBackDidFinish"), name: AVPlayerItemDidPlayToEndTimeNotification, object: newPlayerItem)
            
            self.avPlayer = AVPlayer(playerItem: newPlayerItem)
            self.avPlayerLayer = AVPlayerLayer(player: self.avPlayer)
            self.avPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
            
            self.avPlayerLayer.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
            
            self.view.layer.addSublayer(self.avPlayerLayer)
            self.view.layoutIfNeeded()
            
            self.avPlayer.play()
            
        }
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        if firstVideoRecorded {
            let videoURL = info[UIImagePickerControllerMediaURL] as! NSURL!
            let videoData = NSData(contentsOfURL: videoURL)
            let tempURL = documentsDirectoryURL.URLByAppendingPathComponent("items1.mp4")
            let success = videoData?.writeToURL(tempURL, atomically: true)
            video1URL = tempURL
            self.dismissViewControllerAnimated(true, completion: nil)
            firstVideoRecorded = false
            
        } else if secondVideoRecorded {
            
            let videoURL = info[UIImagePickerControllerMediaURL] as! NSURL!
            let videoData = NSData(contentsOfURL: videoURL)
            let tempURL = documentsDirectoryURL.URLByAppendingPathComponent("items2.mp4")
            let success = videoData?.writeToURL(tempURL, atomically: false)
            video2URL = tempURL
            self.dismissViewControllerAnimated(true, completion: nil)
            secondVideoRecorded = false
        }
    }
    func exportVideo3() {
        
        transprentView.hidden = false
        activityIndicator.startAnimating()
        let composition = AVMutableComposition()
        let trackVideo = composition.addMutableTrackWithMediaType(AVMediaTypeVideo, preferredTrackID: CMPersistentTrackID())
        let trackAudio = composition.addMutableTrackWithMediaType(AVMediaTypeAudio, preferredTrackID: CMPersistentTrackID())
        var insertTime = kCMTimeZero
        let path = NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false, error: nil)!.path!
        for index in 1...2 {
            let movieUrl = index == 1 ? video1URL : video2URL
            let sourceAsset = AVURLAsset(URL: movieUrl, options: nil)
            
            let tracks = sourceAsset.tracksWithMediaType(AVMediaTypeVideo)
            let audios = sourceAsset.tracksWithMediaType(AVMediaTypeAudio)
            
            if tracks.count > 0{
                let assetTrack:AVAssetTrack = tracks[0] as! AVAssetTrack
                trackVideo.insertTimeRange(CMTimeRangeMake(kCMTimeZero,sourceAsset.duration), ofTrack: assetTrack, atTime: insertTime, error: nil)
                let assetTrackAudio:AVAssetTrack = audios[0] as! AVAssetTrack
                trackAudio.insertTimeRange(CMTimeRangeMake(kCMTimeZero,sourceAsset.duration), ofTrack: assetTrackAudio, atTime: insertTime, error: nil)
                insertTime = CMTimeAdd(insertTime, sourceAsset.duration)
            }
        }
        
        let exporter = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetHighestQuality)
        exporter.outputURL = documentsDirectoryURL.URLByAppendingPathComponent("mergedMovie.mp4")
        if NSFileManager.defaultManager().fileExistsAtPath(exporter.outputURL.path!) {
            NSFileManager.defaultManager().removeItemAtURL(exporter.outputURL, error: nil)
        }
        
        mergedVideoURL = exporter.outputURL
        exporter.outputFileType = AVFileTypeMPEG4
        exporter.exportAsynchronouslyWithCompletionHandler({
            switch exporter.status{
            case  AVAssetExportSessionStatus.Failed:
                println("failed \(exporter.error)")
            case AVAssetExportSessionStatus.Cancelled:
                println("cancelled \(exporter.error)")
            default:
                self.transprentView.hidden = true
                self.activityIndicator.stopAnimating()
                println("complete")
            }
        })
    }
}
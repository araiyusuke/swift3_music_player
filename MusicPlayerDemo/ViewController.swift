import AVFoundation
import UIKit
import MediaPlayer

class ViewController: UIViewController ,MPMediaPickerControllerDelegate {
    
    var player = MPMusicPlayerController()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var albumLabel: UILabel!
    @IBOutlet weak var songTitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
            self,
            selector:  #selector(ViewController.nowPlayingItemChanged(_:)),
            name: NSNotification.Name.MPMusicPlayerControllerNowPlayingItemDidChange,
            object: player
        )
        player.beginGeneratingPlaybackNotifications()
        
        
    }
    
    func openMediaPicker() {
        let picker = MPMediaPickerController(mediaTypes: .music)
        picker.delegate = self
        picker.prompt = "Select song (Icloud songs must be downloaded to use)"
        picker.showsItemsWithProtectedAssets = false
        picker.allowsPickingMultipleItems = false
        picker.showsCloudItems = false
        present(picker, animated: true, completion:{})
    }
    
    @IBAction func startBtnTapped(sender:AnyObject) {
        player.play()
    }
    @IBAction func stopBtnTapped(sender:AnyObject) {
        player.stop()
    }
    @IBAction func openBtnTapped(sender:AnyObject) {
        openMediaPicker()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func mediaPicker(_ mediaPicker: MPMediaPickerController ,didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        player.setQueue(with: mediaItemCollection)
        player.play()
        dismiss(animated: true, completion: nil)
    }
    
    @objc  func nowPlayingItemChanged( _ notification: NSNotification) {
        print("nowPlayingItemChanged")
        if let mediaItem = player.nowPlayingItem {
            updateSongInformationUI(mediaItem: mediaItem)
        }
    }
    
    func updateSongInformationUI(mediaItem: MPMediaItem) {
        print("####updateSOnginformationUI")
        print(mediaItem.artist ?? "不明なアーティスト")
        print(mediaItem.albumTitle ?? "不明なアルバム")
        print(mediaItem.title ?? "不明な曲")
        
        artistLabel.text = mediaItem.artist ?? "不明なアーティスト"
        albumLabel.text = mediaItem.albumTitle ?? "不明なアルバム"
        songTitleLabel.text = mediaItem.title ?? "不明な曲"
        
        if let artwork = mediaItem.artwork {
            let image = artwork.image(at: imageView.bounds.size)
            imageView.image = image
        } else {
            // アートワークがないとき
            // (今回は灰色表示としました)
            imageView.image = nil
            imageView.backgroundColor = UIColor.gray
        }
    }
    
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        dismiss(animated: true, completion: nil)
    }
}

//
//  DetailViewController.swift
//  BuscadorItunes
//
//  Created by mac on 13/7/18.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class DetailViewController: UIViewController {

    @IBAction func backTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    var prevURL:String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print(prevURL ?? "url error")
       /* let videoURL = URL(string: "http://video.itunes.apple.com/apple-assets-us-std-000001/Video128/v4/be/ef/af/beefaffe-6278-4336-07a1-de180ddaeaf8/mzvf_1177979557611386379.640x468.h264lc.U.p.m4v")
        let player = AVPlayer(url: videoURL!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }*/
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let videoURL = URL(string: "http://video.itunes.apple.com/apple-assets-us-std-000001/Video128/v4/be/ef/af/beefaffe-6278-4336-07a1-de180ddaeaf8/mzvf_1177979557611386379.640x468.h264lc.U.p.m4v")
        let player = AVPlayer(url: videoURL!)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.bounds
        self.view.layer.addSublayer(playerLayer)
        player.play()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

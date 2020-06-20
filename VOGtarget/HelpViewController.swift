//
//  HelpViewController.swift
//  VOGtarget
//
//  Created by 黒田建彰 on 2020/01/18.
//  Copyright © 2020 tatsuaki.kuroda. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {
   var tapInterval=CFAbsoluteTimeGetCurrent()
    @IBOutlet weak var helpImage: UIImageView!
    @IBAction func exitDo(_ sender: Any) {
        doubleTap(0)
    }
    @IBOutlet weak var exitBut: UIButton!
    @IBAction func doubleTap(_ sender: Any) {
        let mainView = storyboard?.instantiateViewController(withIdentifier: "mainView") as! ViewController
          //delTimer()
          self.present(mainView, animated: false, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setButs()
        // Do any additional setup after loading the view.
    }
    func setButs(){
        //       print("setrotate")
        let ww:CGFloat=view.bounds.width
        let wh:CGFloat=view.bounds.height
        let bw:CGFloat=ww*8/48
        let bh:CGFloat=bw*150/440
        let sp=ww/48
        let by=wh-bh-sp
        //         let x1=sp*2
        //         let x2=bw+sp*3
        //         let x3=bw*2+sp*4
        //         let x4=bw*3+sp*5
        let x5=bw*4+sp*6
        //         targetBut.frame   = CGRect(x:x1,   y: by ,width: bw, height: bh)
        //         oknBut.frame   = CGRect(x:x2,   y: by ,width: bw, height: bh)
        //         okpBut.frame   = CGRect(x:x3,   y: by ,width: bw, height: bh)
        //         setteiBut.frame   = CGRect(x:x4,   y: by ,width: bw, height: bh)
        exitBut.frame = CGRect(x:x5,   y: by ,width: bw, height: bh)
        helpImage.frame=CGRect(x:0,y:0,width:ww,height:by)
        //1100*500
        //   titleImage.frame=CGRect(x:0,y:ww/13,width:ww,height:wh-ww/13-bh-sp)
    }
    override func remoteControlReceived(with event: UIEvent?) {
        guard event?.type == .remoteControl else { return }
        
        if let event = event {
            
            switch event.subtype {
            case .remoteControlPlay:
                print("Play")
                if (CFAbsoluteTimeGetCurrent()-tapInterval)<0.3{
                    print("doubleTapPlay")
                    doubleTap(0)
                }
                tapInterval=CFAbsoluteTimeGetCurrent()
            case .remoteControlTogglePlayPause:
                print("TogglePlayPause")
                if (CFAbsoluteTimeGetCurrent()-tapInterval)<0.3{
                    print("doubleTap")
                    doubleTap(0)
                }else{
                    print("singletap")
                }
                tapInterval=CFAbsoluteTimeGetCurrent()
            default:
                print("Others")
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  ViewController.swift
//  VOGtarget
//
//  Created by kuroda tatsuaki on 2019/04/14.
//  Copyright © 2019 tatsuaki.kuroda. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer
class ViewController: UIViewController {
    var controllerF:Bool=false
    var timer: Timer!
    var oknSpeed:Int = 2
    var oknTime:Int = 0
    var oknMode:Int=0
    var okpSpeed:Int=5
    var okpTime:Int=0
    var okpMode:Int=0
    var targetMode:Int = -1
    var soundPlayer: AVAudioPlayer? = nil
    @IBOutlet weak var targetBut: UIButton!
    @IBOutlet weak var oknBut: UIButton!
    @IBOutlet weak var okpBut: UIButton!
    @IBOutlet weak var setteiBut: UIButton!
    @IBOutlet weak var helpBut: UIButton!
    @IBOutlet weak var titleImage: UIImageView!
    @IBOutlet weak var headImage: UIImageView!
    func doModes(){
        UserDefaults.standard.set(targetMode, forKey: "targetMode")
        sound(snd:"silence")
        if targetMode==0{
            let nextView = storyboard?.instantiateViewController(withIdentifier: "target") as! TargetViewController
            self.present(nextView, animated: true, completion: nil)
        }else if targetMode==1{
            let nextView = storyboard?.instantiateViewController(withIdentifier: "okn") as! OknViewController
            self.present(nextView, animated: true, completion: nil)
        }else if targetMode==2{
            let nextView = storyboard?.instantiateViewController(withIdentifier: "okp") as! OkpViewController
            self.present(nextView, animated: true, completion: nil)
        }else if targetMode==3{
            let nextView = storyboard?.instantiateViewController(withIdentifier: "settei") as! SetteiViewController
            self.present(nextView, animated: true, completion: nil)
        }else{
            let nextView = storyboard?.instantiateViewController(withIdentifier: "help") as! HelpViewController
            self.present(nextView, animated: true, completion: nil)
        }
    }
    override func remoteControlReceived(with event: UIEvent?) {
        guard event?.type == .remoteControl else { return }
        
        if let event = event {
            controllerF=true
            switch event.subtype {
            case .remoteControlPlay:
                print("Play")
                doModes()
            case .remoteControlTogglePlayPause:
                print("TogglePlayPause")
                doModes()
            case .remoteControlNextTrack:
                getUserDefaults()
                //setRotate(alp: 0.6)
                targetMode += 1
                if(targetMode>4){
                    targetMode=0
                }
                setalphaButs()
                print("NextTrack")
                print(targetMode)
                UserDefaults.standard.set(targetMode, forKey: "targetMode")
            case .remoteControlPreviousTrack:
                getUserDefaults()
                //setRotate(alp: 0.6)
                targetMode -= 1
                if targetMode<0{
                    targetMode = 4
                }
                setalphaButs()
                print(targetMode)
                print("PreviousTrack")
                UserDefaults.standard.set(targetMode, forKey: "targetMode")
            default:
                print("Others")
            }
        }
    }
    func sound(snd:String){
        if let soundharu = NSDataAsset(name: snd) {
            soundPlayer = try? AVAudioPlayer(data: soundharu.data)
            soundPlayer?.play() // → これで音が鳴る
        }
    }
    func getUserDefault(str:String,ret:Int) -> Int{//getUserDefault_one
        if (UserDefaults.standard.object(forKey: str) != nil){//keyが設定してなければretをセット
            return UserDefaults.standard.integer(forKey:str)
        }else{
            UserDefaults.standard.set(ret, forKey: str)
            return ret
        }
    }
    func getUserDefaults(){
        okpSpeed = getUserDefault(str: "okpSpeed", ret:100)
        okpTime = getUserDefault(str: "okpTime", ret: 5)
        okpMode = getUserDefault(str: "okpMode", ret: 0)
        oknSpeed = getUserDefault(str: "oknSpeed", ret: 100)
        oknTime = getUserDefault(str: "oknTime", ret: 60)
        oknMode = getUserDefault(str: "oknMode", ret: 0)
        targetMode = getUserDefault(str: "targetMode", ret: 0)
    }
    func setUserDefaults(){//default値をセットするんじゃなく、defaultというものに値を設定するという意味
        UserDefaults.standard.set(okpSpeed, forKey: "okpSpeed")
        UserDefaults.standard.set(okpTime, forKey: "okpTime")
        UserDefaults.standard.set(okpMode, forKey: "okpMode")
        UserDefaults.standard.set(oknSpeed, forKey: "oknSpeed")
        UserDefaults.standard.set(oknTime, forKey: "oknTime")
        UserDefaults.standard.set(oknMode, forKey: "oknMode")
        UserDefaults.standard.set(targetMode, forKey: "targetMode")
    }
    @IBAction func doTarget(_ sender: Any) {
        targetMode=0
        doModes()
    }
    
    @IBAction func doOkn(_ sender: Any) {
        targetMode=1
        doModes()
    }
    
    @IBAction func doOkp(_ sender: Any) {
        targetMode=2
        doModes()
    }
    
    @IBAction func doSettei(_ sender: Any) {
        targetMode=3
        doModes()
    }
    
    @IBAction func doHelp(_ sender: Any) {
        targetMode=4
        doModes()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserDefaults()
        sound(snd:"silence")
        UIApplication.shared.beginReceivingRemoteControlEvents()
        self.becomeFirstResponder()
        setButs()
        setalphaButs()
        // Do any additional setup after loading the view, typically from a nib.
    }
    func setButs(){
        //       print("setrotate")
        let ww:CGFloat=view.bounds.width
        let wh:CGFloat=view.bounds.height
        let bw:CGFloat=ww*8/48
        let bh:CGFloat=bw*150/440
        let sp=ww/48
        let by=wh-bh-sp
        let x1=sp*2
        let x2=bw+sp*3
        let x3=bw*2+sp*4
        let x4=bw*3+sp*5
        let x5=bw*4+sp*6
        targetBut.frame   = CGRect(x:x1,   y: by ,width: bw, height: bh)
        oknBut.frame   = CGRect(x:x2,   y: by ,width: bw, height: bh)
        okpBut.frame   = CGRect(x:x3,   y: by ,width: bw, height: bh)
        setteiBut.frame   = CGRect(x:x4,   y: by ,width: bw, height: bh)
        helpBut.frame   = CGRect(x:x5,   y: by ,width: bw, height: bh)
        headImage.frame=CGRect(x:0,y:0,width:ww,height:ww/13)
         //1100*500
        titleImage.frame=CGRect(x:0,y:ww/13,width:ww,height:wh-ww/13-bh-sp)
     }
    func setalphaButs(){
        targetBut.alpha=0.6
        oknBut.alpha=0.6
        okpBut.alpha=0.6
        setteiBut.alpha=0.6
        helpBut.alpha=0.6
        if targetMode==0{
            targetBut.alpha=1.0
        }else if targetMode==1{
            oknBut.alpha=1.0
        }else if targetMode==2{
            okpBut.alpha=1.0
        }else if targetMode==3{
            setteiBut.alpha=1.0
        }else if targetMode==4{
            helpBut.alpha=1.0
        }
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        setButs()
        coordinator.animate(
            alongsideTransition: nil,
            completion: {(UIViewControllerTransitionCoordinatorContext) in
                self.setButs()
        }
        )
    }
    @objc func viewWillEnterForeground(_ notification: Notification?) {
        print("viewWillEnterForground")
        sound(snd:"silence")
    }
//    @IBAction func unwind(_ segue: UIStoryboardSegue) {
//        setRotate()
//    }
}


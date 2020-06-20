//
//  SetteiViewController.swift
//  VOGtarget
//
//  Created by 黒田建彰 on 2020/01/18.
//  Copyright © 2020 tatsuaki.kuroda. All rights reserved.
//

import UIKit

class SetteiViewController: UIViewController {
    var oknSpeed:Int = 2
    var oknTime:Int = 0
    var oknMode:Int=0
    var okpSpeed:Int=1
    var okpTime:Int=0
    var okpMode:Int=0
    var tapInterval=CFAbsoluteTimeGetCurrent()
    @IBOutlet weak var defaultBut: UIButton!
    @IBOutlet weak var exitBut: UIButton!
    @IBOutlet weak var paraTxt0: UILabel!
    @IBOutlet weak var paraTxt1: UILabel!
    @IBOutlet weak var paraTxt2: UILabel!
    @IBOutlet weak var paraTxt3: UILabel!
    @IBOutlet weak var paraTxt4: UILabel!
    @IBOutlet weak var paraTxt5: UILabel!
    @IBOutlet weak var paraCnt0: UISlider!
    @IBOutlet weak var paraCnt1: UISlider!
    @IBOutlet weak var paraCnt2: UISegmentedControl!
    @IBOutlet weak var paraCnt3: UISlider!
    @IBOutlet weak var paraCnt4: UISlider!
    @IBOutlet weak var paraCnt5: UISegmentedControl!
    override func remoteControlReceived(with event: UIEvent?) {
         guard event?.type == .remoteControl else { return }
         
         if let event = event {
             
             switch event.subtype {
             case .remoteControlPlay:
                 print("Play")
                 if (CFAbsoluteTimeGetCurrent()-tapInterval)<0.3{
                     print("doubleTapPlay")
                     doubleTap(0)
                     //                    self.dismiss(animated: true, completion: nil)
                 }
                 tapInterval=CFAbsoluteTimeGetCurrent()
             case .remoteControlTogglePlayPause:
                 print("TogglePlayPause")
                 if (CFAbsoluteTimeGetCurrent()-tapInterval)<0.3{
                     print("doubleTapTogglePlayPause")
                     doubleTap(0)
                     //                    self.dismiss(animated: true, completion: nil)
                 }
                 tapInterval=CFAbsoluteTimeGetCurrent()
             default:
                 print("Others")
             }
         }
    }
    @IBAction func paraAct0(_ sender: UISlider) {
        okpSpeed=Int(sender.value*200)
        dispTexts()
    }
    
    @IBAction func paraAct1(_ sender: UISlider) {
        okpTime=Int(sender.value*50)
        dispTexts()
    }
    @IBAction func paraAct2(_ sender: UISegmentedControl) {
        okpMode=sender.selectedSegmentIndex
        dispTexts()
    }
    @IBAction func paraAct3(_ sender: UISlider) {
        oknSpeed=Int(sender.value*200)
        dispTexts()
    }
    
    @IBAction func paraAct4(_ sender: UISlider) {
        oknTime=Int(sender.value*100)
        dispTexts()
    }
    
    @IBAction func paraAct5(_ sender: UISegmentedControl) {
        oknMode=sender.selectedSegmentIndex
        dispTexts()
    }
    
    @IBAction func defaultAct(_ sender: Any) {
        okpSpeed=100
        okpTime=5
        okpMode=0
        oknSpeed=100
        oknTime=60
        oknMode=0
        setPars()
        dispTexts()
    }
    
    @IBAction func exitAct(_ sender: Any) {
        doubleTap(0)
    }
    
    func setokpMode(){
        paraTxt2.text="OKP-MODE:" + String(Int(okpMode)) + "   "
        if okpMode == 0{
            paraTxt2.text! += " right -> " + String(Int(okpTime)) + "sec -> left"
        }else if okpMode == 1{
            paraTxt2.text! += " left -> " + String(Int(okpTime)) + "sec -> right"
        }else if okpMode == 2{
            paraTxt2.text! += " right"
        }else{
            paraTxt2.text! += " left"
        }
    }
    func setoknMode(){
        paraTxt5.text="OKN-MODE:" + String(Int(oknMode)) + "   "
        if oknMode == 0{
            paraTxt5.text! += " right(" + String(Int(oknTime)) + "sec) -> black"
        }else if oknMode == 1{
            paraTxt5.text! += " left(" + String(Int(oknTime)) + "sec) -> black"
        }else if oknMode == 2{
            paraTxt5.text! += " right"
        }else{
            paraTxt5.text! += " left"
        }
    }
    func setokpSpeed(){
        paraTxt0.text="OKP-MaxSPEED:" + String(Int(okpSpeed*15)) + "pt/sec" + "  ScreenWidth(" + String(Int(view.bounds.width)) + "pt)"
    }
    func setoknSpeed(){
        paraTxt3.text="OKN-SPEED:" + String(Int(oknSpeed*15)) + "pt/sec" + "  ScreenWidth(" + String(Int(view.bounds.width)) + "pt)"
    }
    @IBAction func doubleTap(_ sender: Any) {
        UserDefaults.standard.set(okpSpeed, forKey: "okpSpeed")
        UserDefaults.standard.set(okpTime, forKey: "okpTime")
        UserDefaults.standard.set(okpMode, forKey: "okpMode")
        UserDefaults.standard.set(oknSpeed, forKey: "oknSpeed")
        UserDefaults.standard.set(oknTime, forKey: "oknTime")
        UserDefaults.standard.set(oknMode, forKey: "oknMode")
        
        let mainView = storyboard?.instantiateViewController(withIdentifier: "mainView") as! ViewController
        //delTimer()
        self.present(mainView, animated: false, completion: nil)
    }
    func setPars(){
        paraCnt0.value=Float(okpSpeed)/200.0
        paraCnt1.value=Float(okpTime)/50.0
        paraCnt2.selectedSegmentIndex=okpMode%4
        paraCnt3.value=Float(oknSpeed)/200.0
        paraCnt4.value=Float(oknTime)/100.0
        paraCnt5.selectedSegmentIndex=oknMode%4
    }
    func dispTexts(){
        setokpMode()
        setoknMode()
        setokpSpeed()
        setoknSpeed()
        paraTxt1.text="OKP-PAUSE:" + String(Int(okpTime)) + "sec"
        paraTxt4.text="OKN-TIME:" + String(Int(oknTime)) + "sec"
    }
    func getUserDefault(str:String,ret:Int) -> Int{//getUserDefault_one
        if (UserDefaults.standard.object(forKey: str) != nil){//keyが設定してなければretをセット
            return UserDefaults.standard.integer(forKey:str)
        }else{
            UserDefaults.standard.set(ret, forKey: str)
            return ret
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        okpSpeed = getUserDefault(str: "okpSpeed", ret:100)
        okpTime = getUserDefault(str: "okpTime", ret: 5)
        okpMode = getUserDefault(str: "okpMode", ret: 0)
        oknSpeed = getUserDefault(str: "oknSpeed", ret: 100)
        oknTime = getUserDefault(str: "oknTime", ret: 60)
        oknMode = getUserDefault(str: "oknMode", ret: 0)
        
        setScreen()
        dispTexts()
        setPars()
    }

    func setScreen(){
        let ww=view.bounds.width
        let wh=view.bounds.height
        let x0=ww/25
        var bw=ww/4
        let x1=x0+bw+x0/2
        var sp=wh/45//2 1 1 1 1 2

        var bh=wh/9
        let b0y=bh*4/5
        let b1y=b0y+bh
        let b2y=b1y+bh
        let b3y=b2y+bh+bh/2
        let b4y=b3y+bh
        let b5y=b4y+bh
        paraCnt3.frame  = CGRect(x:x0,   y: b0y ,width: bw, height: bh)
        paraTxt3.frame    = CGRect(x:x1,   y: b0y ,width: bw*5, height: bh)
        paraCnt4.frame  = CGRect(x:x0,   y: b1y ,width: bw, height: bh)
        paraTxt4.frame    = CGRect(x:x1,   y: b1y ,width: bw*5, height: bh)
        paraCnt5.frame  = CGRect(x:x0,   y: b2y+bh/4 ,width: bw,height:bh/2)
        paraTxt5.frame     = CGRect(x:x1,   y: b2y ,width: bw*5,height:bh)
//上下を逆に
        paraCnt0.frame  = CGRect(x:x0,   y: b3y ,width: bw, height: bh)
        paraTxt0.frame    = CGRect(x:x1,   y: b3y ,width: bw*5, height: bh)
        paraCnt1.frame  = CGRect(x:x0,   y: b4y ,width: bw, height: bh)
        paraTxt1.frame    = CGRect(x:x1,   y: b4y ,width: bw*5, height: bh)
        paraCnt2.frame  = CGRect(x:x0,   y: b5y+bh/4 ,width: bw,height:bh/2)
        paraTxt2.frame  = CGRect(x:x1,   y: b5y ,width: bw*5,height:bh)
        
        bw=ww*8/48
        bh=bw*150/440
        sp=ww/48
        let by=wh-bh-sp
        
        let x4=bw*3+sp*5
        let x5=bw*4+sp*6
        defaultBut.frame   = CGRect(x:x4,   y: by ,width: bw, height: bh)
        exitBut.frame   = CGRect(x:x5,   y: by ,width: bw, height: bh)
    }
}

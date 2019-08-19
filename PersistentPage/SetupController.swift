//
//  ViewController.swift
//  PersistentPage
//
//  Created by Simon on 2019-02-14.
//  Copyright © 2019 Simon Berg, Elektro-Kapsel AB. 
//

import UIKit

class SetupController: UIViewController , UITextFieldDelegate {

    var settings: PageSettings?
    @IBOutlet weak var urlField: UITextField!
    
    @IBOutlet weak var timeoutField: UITextField!
    
    @IBOutlet weak var countDownLabel: UILabel!
    
    var startTimer: Timer?
    
    @IBOutlet weak var editButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
        urlField.delegate = self;
        timeoutField.delegate = self;
        urlField.text = "http://www.elektro-kapsel.se"
        
    }
    
    // Counts down seconds before automatically start
    var countDown = 0
    
    func updateCountDownLabel()
    {
        countDownLabel?.text = "Automatically start browser in \(countDown) seconds"
    }
    
    func startStartTimer()
    {
        countDown = 5;
        startTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: {(timer) in self.timerTick()})
        updateCountDownLabel()
    }
    
    func cancelStartTimer()
    {
        startTimer?.invalidate()
        startTimer = nil
    }
    
    func timerTick()
    {
        countDown -= 1;
        updateCountDownLabel()
        if countDown == 0 {
            cancelStartTimer()
            performSegue(withIdentifier: "StartBrowser", sender: self)
        }
        
    }
    let INITIAL_URL:String = "http://";
    
    override func viewDidAppear(_ animated: Bool) {
        loadSettings()
        if settings == nil {
            settings = PageSettings(url: URL(string: INITIAL_URL)!, timeout: 0)
        }
        
        urlField.text = settings!.url.absoluteString
        timeoutField.text = settings!.timeout.description
        urlField.isEnabled = false
        timeoutField.isEnabled = false
        countDownLabel.isHidden = false
        editButton.isHidden = false
        
        if urlField.text! == INITIAL_URL {
            startEditing();
        } else {
            startStartTimer()
        }
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        cancelStartTimer()
        urlField.endEditing(true)
        timeoutField.endEditing(true)
        saveSettings()
        print("Saved settings")
    }
    
    @IBAction func timeoutEntered(_ sender: UITextField) {
        settings!.timeout =  Int(sender.text ?? "0")!
        sender.text = String(settings!.timeout)
    }
    @IBAction func urlEntered(_ sender: UITextField) {
        print("URL: \(sender.text!)")
        if sender.text != nil {
            
            if let page = URL(string: sender.text!) {
                if page.host == nil {
                    let alert = UIAlertController(title: "Invalid URL ", message: "The entered string does not contain a valid host part", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style:.default))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    settings!.url = page
                }
              
            } else {
                let alert = UIAlertController(title: "Invalid URL ", message: "The entered string could not be interpreted as an URL", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style:.default))
                self.present(alert, animated: true, completion: nil)
            }
        }
        sender.text = settings!.url.absoluteString
    }
    
    func startEditing() {
        urlField.isEnabled = true
        timeoutField.isEnabled = true
        countDownLabel.isHidden = true
        editButton.isHidden = true
    }
    
    @IBAction func editSettings(_ sender: UIButton) {
        cancelStartTimer()
        startEditing();
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is WebBrowserController {
            let vc = segue.destination as! WebBrowserController
            vc.settings = settings
        }
    }
    // MARK: Save settings
    private func saveSettings()
    {
        if let settings = self.settings {
            do {
                let archive = try NSKeyedArchiver.archivedData(withRootObject: settings, requiringSecureCoding: false)
                print("Saving to \(PageSettings.ArchiveURL)")
                try archive.write(to: PageSettings.ArchiveURL)
            } catch {
                print("Failed to save settings")
            }
            
        }
    }
    
    private func loadSettings()
    {
        do {
        let data = try Data(contentsOf: PageSettings.ArchiveURL)
            print("Read settings")
            settings = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? PageSettings
        } catch {
            print("Failed to load settings")
        }
    }
}


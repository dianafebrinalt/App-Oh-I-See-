//
//  TextToSpeechViewController.swift
//  App Oh I See!
//
//  Created by Diana Febrina Lumbantoruan on 28/07/21.
//

import UIKit
import CoreData
import AVFoundation
import QuartzCore

class TextToSpeechViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var btnSpeak: UIButton!
    @IBOutlet weak var btnPause: UIButton!
    @IBOutlet weak var btnStop: UIButton!
    @IBOutlet weak var labelJudulDokumen: UINavigationItem!
    @IBOutlet weak var setTextInput: UITextView!
    @IBOutlet weak var selectLanguage: UITextField!
    
    var mainScreenProtocol : ViewControllerProtocol?
    
    var detailText : Text?
    
    var count : Int = 0
    
    var accentThatUserChoose : String?
    
    var lang : String?
    
    var pickerView = UIPickerView()
    
    var totalUtterances: Int! = 0
    
    var currentUtterance: Int! = 0
    
    var totalTextLength: Int = 0
    
    var spokenTextLengths: Int = 0
    
    var previousSelectedRange: NSRange!
    
    let speechSynthesizer = AVSpeechSynthesizer()
    
    
    var voiceAccentBasedOnLanguage = ["Saudi Arabia", "Chinese", "Hongkong", "Taiwan", "Denmark", "Belgium", "Netherlands", "Australia", "Ireland", "South Africa", "England", "America", "Finland", "Canada", "France", "Germany", "Greece", "Israel", "India", "Hungary", "Indonesia", "Italy", "Japan", "South Korea", "Norwegia", "Poland", "Brazil", "Portugal", "Romania", "Russia", "Slovakia", "Mexico", "Spain", "Sweden", "Thailand", "Turkey"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTextInput.delegate = self
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        speechSynthesizer.delegate = self
        
        selectLanguage.inputView = pickerView
        
        var swipeDownGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "handleSwipeDownGesture:")
        swipeDownGestureRecognizer.direction = UISwipeGestureRecognizer.Direction.down
        view.addGestureRecognizer(swipeDownGestureRecognizer)
        
        selectLanguage.attributedPlaceholder = NSAttributedString(string: "Select the accent voice that you want",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemBlue])
        
        
        
        if let detailText = detailText {
            labelJudulDokumen.title = detailText.titleText
            setTextInput.text = detailText.textInput
        }
    }
    
    func animateActionButtonAppearance(shouldHideSpeakButton: Bool) {
        var speakButtonAlphaValue: CGFloat = 1.0
        var pauseStopButtonsAlphaValue: CGFloat = 0.0

        if shouldHideSpeakButton {
            speakButtonAlphaValue = 0.0
            pauseStopButtonsAlphaValue = 1.0
        }

        UIView.animate(withDuration: 0, animations: { () -> Void in
            self.btnSpeak.alpha = speakButtonAlphaValue

            self.btnPause.alpha = pauseStopButtonsAlphaValue

            self.btnStop.alpha = pauseStopButtonsAlphaValue
        })
    }
    
    func unselectLastWord() {
        if let selectRange = previousSelectedRange{
            let currentAttributes = setTextInput.attributedText.attributes(at: selectRange.location, effectiveRange: nil)
            
            let fontAttribute : AnyObject? = currentAttributes[NSAttributedString.Key.font] as AnyObject
            
            let attributeWord = NSMutableAttributedString(string: setTextInput.attributedText.attributedSubstring(from: selectRange).string)
            
            attributeWord.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: NSMakeRange(0, attributeWord.length))
            
            attributeWord.addAttribute(NSAttributedString.Key.font, value: fontAttribute!, range: NSMakeRange(0, attributeWord.length))
            
            setTextInput.textStorage.beginEditing()
            setTextInput.textStorage.replaceCharacters(in: selectRange, with: attributeWord)
            setTextInput.textStorage.endEditing()
        }
    }
    
    @IBAction func playTextToSpeech(_ sender: UIButton) {
        if !speechSynthesizer.isSpeaking {
            let textParagraphs = setTextInput.text.components(separatedBy: "\n")
            
            totalUtterances = textParagraphs.count
            currentUtterance = 0
            totalTextLength = 0
            spokenTextLengths = 0
            
            for pieceOfText in textParagraphs{
                lang = "id-ID"
                
                if accentThatUserChoose == "Saudi Arabia"{
                    lang = "ar-SA"
                }
                else if accentThatUserChoose == "Chinese"{
                    lang = "zh-CN"
                }
                else if accentThatUserChoose == "Hongkong"{
                    lang = "zh-HK"
                }
                else if accentThatUserChoose == "Taiwan"{
                    lang = "zh-TW"
                }
                else if accentThatUserChoose == "Denmark"{
                    lang = "da-DK"
                }
                else if accentThatUserChoose == "Belgium"{
                    lang = "nl-BE"
                }
                else if accentThatUserChoose == "Netherlands"{
                    lang = "nl-NL"
                }
                else if accentThatUserChoose == "Australia"{
                    lang = "en-AU"
                }
                else if accentThatUserChoose == "Ireland"{
                    lang = "en-IE"
                }
                else if accentThatUserChoose == "South Africa"{
                    lang = "en-ZA"
                }
                else if accentThatUserChoose == "England"{
                    lang = "en-GB"
                }
                else if accentThatUserChoose == "America"{
                    lang = "en-US"
                }
                else if accentThatUserChoose == "Finland"{
                    lang = "fi-FI"
                }
                else if accentThatUserChoose == "Canada"{
                    lang = "fr-CA"
                }
                else if accentThatUserChoose == "France"{
                    lang = "fr-FR"
                }
                else if accentThatUserChoose == "Germany"{
                    lang = "de-DE"
                }
                else if accentThatUserChoose == "Greece"{
                    lang = "el-GR"
                }
                else if accentThatUserChoose == "Israel"{
                    lang = "he-IL"
                }
                else if accentThatUserChoose == "India"{
                    lang = "hi-IN"
                }
                else if accentThatUserChoose == "Hungary"{
                    lang = "hu-HU"
                }
                else if accentThatUserChoose == "Indonesia"{
                    lang = "id-ID"
                }
                else if accentThatUserChoose == "Italy"{
                    lang = "it-IT"
                }
                else if accentThatUserChoose == "Japan"{
                    lang = "ja-JP"
                }
                else if accentThatUserChoose == "South Korea"{
                    lang = "ko-KR"
                }
                else if accentThatUserChoose == "Norwegia"{
                    lang = "no-NO"
                }
                else if accentThatUserChoose == "Poland"{
                    lang = "pl-PL"
                }
                else if accentThatUserChoose == "Brazil"{
                    lang = "pt-BR"
                }
                else if accentThatUserChoose == "Portugal"{
                    lang = "pt-PT"
                }
                else if accentThatUserChoose == "Romania"{
                    lang = "ro-RO"
                }
                else if accentThatUserChoose == "Russia"{
                    lang = "ru-RU"
                }
                else if accentThatUserChoose == "Slovakia"{
                    lang = "sk-SK"
                }
                else if accentThatUserChoose == "Mexico"{
                    lang = "es-MX"
                }
                else if accentThatUserChoose == "Spain"{
                    lang = "es-ES"
                }
                else if accentThatUserChoose == "Sweden"{
                    lang = "sv-SE"
                }
                else if accentThatUserChoose == "Thailand"{
                    lang = "th-TH"
                }
                else if accentThatUserChoose == "Turkey"{
                    lang = "tr-TR"
                }
                else{
                    lang = "id-ID"
                }
                
                let utterance = AVSpeechUtterance(string: setTextInput.text!)
                utterance.voice = AVSpeechSynthesisVoice(language: lang)
                utterance.rate = 0.5
                utterance.volume = 80
                utterance.pitchMultiplier = 1
                utterance.postUtteranceDelay = 0.005
                
                totalTextLength = totalTextLength + pieceOfText.count
                
                DispatchQueue.main.async {
                    self.speechSynthesizer.speak(utterance)
                }
            }
        }
        else{
            speechSynthesizer.continueSpeaking()
        }
        
        animateActionButtonAppearance(shouldHideSpeakButton: true)
    }
    
    @IBAction func pauseTheSpeech(_ sender: Any) {
        speechSynthesizer.pauseSpeaking(at: AVSpeechBoundary.word)
        animateActionButtonAppearance(shouldHideSpeakButton: false)
    }
    
    @IBAction func stopTheSpeech(_ sender: Any) {
        speechSynthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
        animateActionButtonAppearance(shouldHideSpeakButton: false)
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        speechSynthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
        animateActionButtonAppearance(shouldHideSpeakButton: false)
        dismiss(animated: true, completion: nil)
    }
}

extension TextToSpeechViewController: AVSpeechSynthesizerDelegate{
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        currentUtterance = currentUtterance + 1
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        
        spokenTextLengths = spokenTextLengths + utterance.speechString.count + 1
        
        if currentUtterance == totalUtterances {
            animateActionButtonAppearance(shouldHideSpeakButton: false)
            unselectLastWord()
            previousSelectedRange = nil
        }
        
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        let rangeInTotalText = NSMakeRange(spokenTextLengths + characterRange.location, characterRange.length)
        
        setTextInput.selectedRange = rangeInTotalText
        
        let currentAttributes = setTextInput.attributedText.attributes(at: rangeInTotalText.location, effectiveRange: nil)
        
        let fontAttribute: AnyObject? = currentAttributes[NSAttributedString.Key.font] as AnyObject
        
        let attributedString = NSMutableAttributedString(string: setTextInput.attributedText.attributedSubstring(from: rangeInTotalText).string)
        
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemOrange, range: NSMakeRange(0, attributedString.length))
        
        attributedString.addAttribute(NSAttributedString.Key.font, value: fontAttribute!, range: NSMakeRange(0, attributedString.string.count))
        
        setTextInput.scrollRangeToVisible(rangeInTotalText)
        
        setTextInput.textStorage.beginEditing()
        
        setTextInput.textStorage.replaceCharacters(in: rangeInTotalText, with: attributedString)
        
        if let previousRange = previousSelectedRange {
            let previousAttributedText = NSMutableAttributedString(string: setTextInput.attributedText.attributedSubstring(from: previousRange).string)
            previousAttributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: NSMakeRange(0, previousAttributedText.length))
            previousAttributedText.addAttribute(NSAttributedString.Key.font, value: fontAttribute!, range: NSMakeRange(0, previousAttributedText.length))
            
            setTextInput.textStorage.replaceCharacters(in: previousRange, with: previousAttributedText)
        }
        
        setTextInput.textStorage.endEditing()
        
        previousSelectedRange = rangeInTotalText
        
    }
}


extension TextToSpeechViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return voiceAccentBasedOnLanguage.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return voiceAccentBasedOnLanguage[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        selectLanguage.text = "Voice Accent : " + voiceAccentBasedOnLanguage[row]
        accentThatUserChoose = voiceAccentBasedOnLanguage[row]
        selectLanguage.resignFirstResponder()
    }
}

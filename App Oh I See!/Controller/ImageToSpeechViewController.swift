//
//  ImageToSpeechViewController.swift
//  App Oh I See!
//
//  Created by Diana Febrina Lumbantoruan on 30/07/21.
//

import UIKit
import CoreData
import AVFoundation
import Vision
import QuartzCore

class ImageToSpeechViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var judulDokumenImage: UINavigationItem!
    @IBOutlet weak var tvExtractTextFromImage: UITextView!
    @IBOutlet weak var selectVoiceLanguage: UITextField!
    @IBOutlet weak var activityProcess: UIActivityIndicatorView!
    @IBOutlet weak var btnPauseSpeech: UIButton!
    @IBOutlet weak var btnPlaySpeech: UIButton!
    @IBOutlet weak var btnStopSpeech: UIButton!
    
    var mainScreenProtocol : ViewControllerProtocol?
    
    var detailImage : Image?
    
    var countTheText : Int = 0
    
    var accentVoiceUserChoose : String?
    
    var language : String?
    
    var pickerViewLanguage = UIPickerView()
    
    var totalUtterancesOfText : Int! = 0
    
    var currentUtteranceOfText: Int! = 0
    
    var totalLengthOfText: Int = 0
    
    var spokenLengthOfText: Int = 0
    
    var previousTheSelectedRange: NSRange!
    
    let speechTheSynthesizer = AVSpeechSynthesizer()
    
    var requestRecognize = VNRecognizeTextRequest(completionHandler: nil)
    
    var voiceAccentLanguage = ["Saudi Arabia", "Chinese", "Hongkong", "Taiwan", "Denmark", "Belgium", "Netherlands", "Australia", "Ireland", "South Africa", "England(UK)", "America(US)", "Finland", "Canada", "France", "Germany", "Greece", "Israel", "India", "Hungary", "Indonesia", "Italy", "Japan", "South Korea", "Norwegia", "Poland", "Brazil", "Portugal", "Romania", "Russia", "Slovakia", "Mexico", "Spain", "Sweden", "Thailand", "Turkey"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tvExtractTextFromImage.text = ""
        
        tvExtractTextFromImage.delegate = self
        
        speechTheSynthesizer.delegate = self
        
        pickerViewLanguage.delegate = self
        pickerViewLanguage.dataSource = self
        
        selectVoiceLanguage.inputView = pickerViewLanguage
        
        startAnimatingProses()
        
        var swipeDownGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "handleSwipeDownGesture:")
        swipeDownGestureRecognizer.direction = UISwipeGestureRecognizer.Direction.down
        view.addGestureRecognizer(swipeDownGestureRecognizer)
        
        selectVoiceLanguage.attributedPlaceholder = NSAttributedString(string: "Select the accent voice that you want",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemBlue])
        
        if let detailImage = detailImage{
            judulDokumenImage.title = detailImage.titleImage
            var image = UIImage(data: detailImage.imageInput!)
            setupVisionTextRecognizeImage(image: image)
        }
    }
    
    private func startAnimatingProses(){
        self.activityProcess.startAnimating()
    }
    
    private func stopAnimatingProses(){
        self.activityProcess.stopAnimating()
    }
    
    func animateActionButton(shouldHideSpeakButton: Bool) {
        var speakTheButtonAlphaValue: CGFloat = 1.0
        var pauseTheStopButtonsAlphaValue: CGFloat = 0.0

        if shouldHideSpeakButton {
            speakTheButtonAlphaValue = 0.0
            pauseTheStopButtonsAlphaValue = 1.0
        }

        UIView.animate(withDuration: 0, animations: { () -> Void in
            self.btnPlaySpeech.alpha = speakTheButtonAlphaValue

            self.btnPauseSpeech.alpha = pauseTheStopButtonsAlphaValue

            self.btnStopSpeech.alpha = pauseTheStopButtonsAlphaValue
        })
    }
    
    func unselectLastWord() {
        if let selectedRange = previousTheSelectedRange{
            let currentAttribute = tvExtractTextFromImage.attributedText.attributes(at: selectedRange.location, effectiveRange: nil)
            
            let fontAttributes : AnyObject? = currentAttribute[NSAttributedString.Key.font] as AnyObject
            
            let attributeWords = NSMutableAttributedString(string: tvExtractTextFromImage.attributedText.attributedSubstring(from: selectedRange).string)
            
            attributeWords.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: NSMakeRange(0, attributeWords.length))
            
            attributeWords.addAttribute(NSAttributedString.Key.font, value: fontAttributes!, range: NSMakeRange(0, attributeWords.length))
            
            tvExtractTextFromImage.textStorage.beginEditing()
            tvExtractTextFromImage.textStorage.replaceCharacters(in: selectedRange, with: attributeWords)
            tvExtractTextFromImage.textStorage.endEditing()
        }
    }
    
    private func setupVisionTextRecognizeImage(image: UIImage?){
        //setupTextRecognation
        
        var textString = ""
        
        requestRecognize = VNRecognizeTextRequest(completionHandler: {(request, error) in
            
            guard let observations = request.results as? [VNRecognizedTextObservation]
            else{
                fatalError("Received Invalid Observation")
            }
            
            for observation in observations {
                guard let topCandidate = observation.topCandidates(1).first
                else{
                    print("No candidate")
                    continue
                }
                
                textString += "\n\(topCandidate.string)"
                DispatchQueue.main.async {
                    self.stopAnimatingProses()
                    self.tvExtractTextFromImage.text = textString
                }
            }
        })
        
        //add some properties
        requestRecognize.customWords = ["custom"]
        requestRecognize.minimumTextHeight = 0.03
        requestRecognize.recognitionLevel = .accurate
        requestRecognize.recognitionLanguages = ["en_US"]
        requestRecognize.usesLanguageCorrection = true
        
        let requests = [requestRecognize]
        
        //creating request handler
        DispatchQueue.global(qos: .userInitiated).async {
            guard let img = image?.cgImage else{
                fatalError("Missing image to scan")}
                let handle = VNImageRequestHandler(cgImage: img, options: [:])
            try? handle.perform(requests)
        }
    }
    
    @IBAction func playTheSpeech(_ sender: Any) {
        if !speechTheSynthesizer.isSpeaking {
            let textParagraphs = tvExtractTextFromImage.text.components(separatedBy: "")
            
            totalUtterancesOfText = textParagraphs.count
            currentUtteranceOfText = 0
            totalLengthOfText = 0
            spokenLengthOfText = 0
            
            for pieceOfText in textParagraphs{
                language = "id-ID"
                
                if accentVoiceUserChoose == "Saudi Arabia"{
                    language = "ar-SA"
                }
                else if accentVoiceUserChoose == "Chinese"{
                    language = "zh-CN"
                }
                else if accentVoiceUserChoose == "Hongkong"{
                    language = "zh-HK"
                }
                else if accentVoiceUserChoose == "Taiwan"{
                    language = "zh-TW"
                }
                else if accentVoiceUserChoose == "Denmark"{
                    language = "da-DK"
                }
                else if accentVoiceUserChoose == "Belgium"{
                    language = "nl-BE"
                }
                else if accentVoiceUserChoose == "Netherlands"{
                    language = "nl-NL"
                }
                else if accentVoiceUserChoose == "Australia"{
                    language = "en-AU"
                }
                else if accentVoiceUserChoose == "Ireland"{
                    language = "en-IE"
                }
                else if accentVoiceUserChoose == "South Africa"{
                    language = "en-ZA"
                }
                else if accentVoiceUserChoose == "England(UK)"{
                    language = "en-GB"
                }
                else if accentVoiceUserChoose == "America(US)"{
                    language = "en-US"
                }
                else if accentVoiceUserChoose == "Finland"{
                    language = "fi-FI"
                }
                else if accentVoiceUserChoose == "Canada"{
                    language = "fr-CA"
                }
                else if accentVoiceUserChoose == "France"{
                    language = "fr-FR"
                }
                else if accentVoiceUserChoose == "Germany"{
                    language = "de-DE"
                }
                else if accentVoiceUserChoose == "Greece"{
                    language = "el-GR"
                }
                else if accentVoiceUserChoose == "Israel"{
                    language = "he-IL"
                }
                else if accentVoiceUserChoose == "India"{
                    language = "hi-IN"
                }
                else if accentVoiceUserChoose == "Hungary"{
                    language = "hu-HU"
                }
                else if accentVoiceUserChoose == "Indonesia"{
                    language = "id-ID"
                }
                else if accentVoiceUserChoose == "Italy"{
                    language = "it-IT"
                }
                else if accentVoiceUserChoose == "Japan"{
                    language = "ja-JP"
                }
                else if accentVoiceUserChoose == "South Korea"{
                    language = "ko-KR"
                }
                else if accentVoiceUserChoose == "Norwegia"{
                    language = "no-NO"
                }
                else if accentVoiceUserChoose == "Poland"{
                    language = "pl-PL"
                }
                else if accentVoiceUserChoose == "Brazil"{
                    language = "pt-BR"
                }
                else if accentVoiceUserChoose == "Portugal"{
                    language = "pt-PT"
                }
                else if accentVoiceUserChoose == "Romania"{
                    language = "ro-RO"
                }
                else if accentVoiceUserChoose == "Russia"{
                    language = "ru-RU"
                }
                else if accentVoiceUserChoose == "Slovakia"{
                    language = "sk-SK"
                }
                else if accentVoiceUserChoose == "Mexico"{
                    language = "es-MX"
                }
                else if accentVoiceUserChoose == "Spain"{
                    language = "es-ES"
                }
                else if accentVoiceUserChoose == "Sweden"{
                    language = "sv-SE"
                }
                else if accentVoiceUserChoose == "Thailand"{
                    language = "th-TH"
                }
                else if accentVoiceUserChoose == "Turkey"{
                    language = "tr-TR"
                }
                else{
                    language = "id-ID"
                }
                
                let utterance = AVSpeechUtterance(string: tvExtractTextFromImage.text!)
                utterance.voice = AVSpeechSynthesisVoice(language: language)
                utterance.rate = 0.5
                utterance.volume = 80
                utterance.pitchMultiplier = 1
                utterance.postUtteranceDelay = 0.005
                
                totalLengthOfText = totalLengthOfText + pieceOfText.count
                
                DispatchQueue.main.async {
                    self.speechTheSynthesizer.speak(utterance)
                }
            }
        }
        else{
            speechTheSynthesizer.continueSpeaking()
        }
        
        animateActionButton(shouldHideSpeakButton: true)
    }
    
    @IBAction func pauseTheSpeech(_ sender: Any) {
        speechTheSynthesizer.pauseSpeaking(at: AVSpeechBoundary.word)
        animateActionButton(shouldHideSpeakButton: false)
    }
    
    @IBAction func stopTheSpeech(_ sender: Any) {
        speechTheSynthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
        animateActionButton(shouldHideSpeakButton: false)
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        speechTheSynthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
        animateActionButton(shouldHideSpeakButton: false)
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
}

extension ImageToSpeechViewController: AVSpeechSynthesizerDelegate{
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        currentUtteranceOfText = currentUtteranceOfText + 1
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        
        spokenLengthOfText = spokenLengthOfText + utterance.speechString.count + 1
        
        if currentUtteranceOfText == totalUtterancesOfText{
            animateActionButton(shouldHideSpeakButton: false)
            unselectLastWord()
            previousTheSelectedRange = nil
        }
        
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        let rangeInTotalTexts = NSMakeRange(spokenLengthOfText + characterRange.location, characterRange.length)
        
        tvExtractTextFromImage.selectedRange = rangeInTotalTexts
        
        let currentAttribute = tvExtractTextFromImage.attributedText.attributes(at: rangeInTotalTexts.location, effectiveRange: nil)
        
        let fontAttributes: AnyObject? = currentAttribute[NSAttributedString.Key.font] as AnyObject
        
        let attributedStrings = NSMutableAttributedString(string: tvExtractTextFromImage.attributedText.attributedSubstring(from: rangeInTotalTexts).string)
        
        attributedStrings.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemOrange, range: NSMakeRange(0, attributedStrings.length))
        
        attributedStrings.addAttribute(NSAttributedString.Key.font, value: fontAttributes!, range: NSMakeRange(0, attributedStrings.string.utf16.count))
        
        tvExtractTextFromImage.scrollRangeToVisible(rangeInTotalTexts)
        
        tvExtractTextFromImage.textStorage.beginEditing()
        
        tvExtractTextFromImage.textStorage.replaceCharacters(in: rangeInTotalTexts, with: attributedStrings)
        
        if let previousRange = previousTheSelectedRange {
            let previousAttributedText = NSMutableAttributedString(string: tvExtractTextFromImage.attributedText.attributedSubstring(from: previousRange).string)
            previousAttributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: NSMakeRange(0, previousAttributedText.length))
            previousAttributedText.addAttribute(NSAttributedString.Key.font, value: fontAttributes!, range: NSMakeRange(0, previousAttributedText.length))
            
            tvExtractTextFromImage.textStorage.replaceCharacters(in: previousRange, with: previousAttributedText)
        }
        
        tvExtractTextFromImage.textStorage.endEditing()
        
        previousTheSelectedRange = rangeInTotalTexts
        
    }
}

extension ImageToSpeechViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return voiceAccentLanguage.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return voiceAccentLanguage[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        selectVoiceLanguage.text = "Voice Accent : " + voiceAccentLanguage[row]
        accentVoiceUserChoose = voiceAccentLanguage[row]
        selectVoiceLanguage.resignFirstResponder()
    }
}


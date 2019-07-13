//
//  TranscriptionTextView.swift
//  Text Project
//
//  Created by Jay Mutzafi on 7/6/19.
//  Copyright © 2019 Paradox Apps. All rights reserved.
//

import UIKit
import Speech

class TranscriptionTextView: UITextView {
    
    private var transcription: SFTranscription?
    
    // MARK: - Initialization
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    // MARK: - Actions
    
    @objc private func handleTap(_ recognizer: UITapGestureRecognizer) {
        var location = recognizer.location(in: self)
        location.x -= textContainerInset.left
        location.y -= textContainerInset.top
        
        let characterIndex = layoutManager.characterIndex(for: location, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        if let word = word(atIndex: characterIndex) {
            // Perform some logic
            print("Selected: \(word)")
        }
        
    }
    
    private func word(atIndex index: Int) -> SFTranscriptionSegment? {
        guard let segments = transcription?.segments else { return nil }
        for segment in segments {
            // TODO: dynamically generate the range of a particular word
            if segment.substringRange.contains(index) {
                return segment
            }
        }
        return nil
    }

    func configure(transcription: SFTranscription) {
        self.transcription = transcription
        
        let string = NSMutableAttributedString()
        
        let selectableAttributes : [NSAttributedString.Key : Any]? = [NSAttributedString.Key.foregroundColor : UIColor.blue]
        
        var index = 0
        for segment in transcription.segments {
            let attributes : [NSAttributedString.Key : Any]? = segment.alternativeSubstrings.count == 1 ? nil : selectableAttributes
            string.append(NSAttributedString(string: segment.substring, attributes: attributes))
            
            // Unless it the last segment, add a space between the segments
            if index < transcription.segments.count - 1 {
                string.append(NSAttributedString(string: " "))
            }
            
            index += 1
        }
        
        attributedText = string
    }
    
    
    

}

## Sample - Voice Prompt
====================

### Overview
- This feature will read route instruction aloud to the user as they swipe through the route instructions or as they traverse them with indoor location.

### Usage

- Need to fill out `applicationId`, `accessKey`, `signatureKey`, `buildingIdentifier`, and `destinationPOIIdentifier` in VoicePromptRouteViewController.swift.

### Sample Code
- [VoicePromptRouteViewController.swift](https://github.com/phunware/maas-mapping-ios-sdk/blob/readme/Samples/MapScenarios/MapScenarios/Scenarios/Voice%20Prompt/VoicePromptRouteViewController.swift)
- [VoicePromptButton.swift](https://github.com/phunware/maas-mapping-ios-sdk/blob/readme/Samples/MapScenarios/MapScenarios/Scenarios/Voice%20Prompt/VoicePromptButton.swift)

**Step 1: Copy the following files to your project**

- VoicePromptRouteViewController.swift
- VoicePromptButton.swift
- VoicePromptButton.xib

Note: For text-to-speech, we use AVFoundation's `AVSpeechSynthesizer` class.

**Step 2: Pay special attention to this method: **

```
func mapView(_ mapView: PWMapView!, didChange instruction: PWRouteInstruction!) {
    turnByTurnCollectionView?.scrollToInstruction(instruction)
    
    if speechEnabled {
        readInstructionAloud(instruction)
    }
}
```

**Step 3: Play the voice instructions for each maneuver by calling `readInstructionAloud(instruction)` **

`BasicInstructionViewModel` is the object used to generate displayed text and voice prompt text. We can create an instance from the current instruction, and use the `voicePrompt` property to retrieve the text we wish to speak aloud. From that, we create an `AVSpeechUtterance`, attach a `AVSpeechSynthesisVoice` for the current language, and finally call the `speak(utterance)` method to speak the text.


# Privacy
You understand and consent to Phunware’s Privacy Policy located at www.phunware.com/privacy. If your use of Phunware’s software requires a Privacy Policy of your own, you also agree to include the terms of Phunware’s Privacy Policy in your Privacy Policy to your end users.

# Terms
Use of this software requires review and acceptance of our terms and conditions for developer use located at http://www.phunware.com/terms/

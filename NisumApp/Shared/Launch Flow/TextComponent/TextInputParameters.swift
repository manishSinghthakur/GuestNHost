//
//  TextInputParameters.swift
//  Nisum_Components
//
//  Created by Ratcha Mahesh Babu on 15/12/21.
//

import Foundation
import CoreGraphics
import UIKit

enum txtValidation {
   case shouldNotContainSpecialCharecters
   case shouldNotContainNumbers
   case shouldContainSpecialCharecters
   case shouldNotContainNumbersAndSpecialCharecter
   case shouldContainNumbers
   case noValidation
}

enum logoIconPlacement {
    case left
    case right
}


class TextInputParameters:ObservableObject {
    
    var defaultLabelName:String = ""
    var isValid:Bool = false
    var padding:CGFloat = 0.0
   
    
    @Published var inputText:String = ""
    static fileprivate var charSet:CharacterSet {
           return CharacterSet.init(charactersIn: "!@#$%^&*()=[]{}+_0123456789)(")
       }
    
      
       static func validateInputText(on validation:txtValidation,validationText:String,minChar:Int,maxChar:Int,minValue:Int,maxValue:Int, labelName:String) ->  String {
           if minChar != 0 && minChar > validationText.count {
               return "\(labelName) should have at least \(minChar) charecters"
           }
         
           if maxChar != 0 && maxChar < validationText.count {
               return "Should not exceed more then \(maxChar) charecters"
           }
        
           let calMsg = calculateMinMaxValue(validationText: validationText, minValue: minValue, maxValue: maxValue)
           if calMsg != "" {
               return calMsg
           }
           
           
          switch validation {
          case .shouldNotContainSpecialCharecters:
              return ShouldNotContainSpecialCharecters(validationText: validationText)
          case .shouldNotContainNumbers:
              return ShouldNotContainNumbers(validationText: validationText)
          case .shouldNotContainNumbersAndSpecialCharecter:
              return CheckingTextContainsNumberAndSpecialCharecters(validationText: validationText)
          case .shouldContainSpecialCharecters:
              return ShouldContainOnlySpecialCharecters(validationText: validationText)
          case .shouldContainNumbers :
              return ShouldContainOnlyNumbers(validationText: validationText)
          case .noValidation:
              return ""
          }
           
      }
    
 
    var ValidateString: String {
       if minCharecters != -1 {
        if inputText.count >= minCharecters{
            isValid = true
        } else {
            isValid = false
            return "Name should contain min of \(minCharecters) charecters"
        }
      }
        if maxCharecters != -1 {
            if inputText.count >= minCharecters{
                isValid = true
            } else {
                isValid = false
                return "Name Should not exceed more then \(minCharecters) charecters"
            }
        }
        
        if minValue != -1 ||  maxValue != -1 {
            let calMsg = TextInputParameters.calculateMinMaxValue(validationText: inputText, minValue: minValue, maxValue: maxValue)
        if calMsg != "" {
            return calMsg
        }
      }
        if validationType != .noValidation {
            var validationTextMessage:String = ""
            switch validationType {
            case .shouldNotContainSpecialCharecters:
                validationTextMessage = TextInputParameters.ShouldNotContainSpecialCharecters(validationText: inputText)
                if validationTextMessage == "" {
                    isValid = true
                } else {
                    isValid = false
                }
                return validationTextMessage
            case .shouldNotContainNumbers:
                validationTextMessage = TextInputParameters.ShouldNotContainNumbers(validationText: inputText)
                if validationTextMessage == "" {
                    isValid = true
                } else {
                    isValid = false
                }
                return validationTextMessage
            case .shouldNotContainNumbersAndSpecialCharecter:
                validationTextMessage = TextInputParameters.CheckingTextContainsNumberAndSpecialCharecters(validationText: inputText)
                if validationTextMessage == "" {
                    isValid = true
                } else {
                    isValid = false
                }
             return validationTextMessage
            case .shouldContainSpecialCharecters:
                validationTextMessage = TextInputParameters.ShouldContainOnlySpecialCharecters(validationText: inputText)
                if validationTextMessage == "" {
                    isValid = true
                } else {
                    isValid = false
                }
                return validationTextMessage
            case .shouldContainNumbers :
                validationTextMessage = TextInputParameters.ShouldContainOnlyNumbers(validationText: inputText)
                if validationTextMessage == "" {
                    isValid = true
                } else {
                    isValid = false
                }
                return validationTextMessage
            case .noValidation:
                return ""
            }
        }
        isValid = true
        return ""
    }
    
    
      
       static func CheckingCharecterLengthAndValidating(validationText:String,minCharLength:Int,maxCharLength:Int) -> String {
           if validationText.count < 3{
               
               return "Text should have at least 3 charecters "
           } else {
               return ""
           }
      }
      
       
      static func calculateMinMaxValue(validationText:String,minValue:Int,maxValue:Int) -> String{
           let validationValue = Int(validationText) ?? 0
           if minValue > 0 && maxValue > 0{
               if validationValue < minValue {
               return "Number should not be less then \(minValue)"
               }
               if validationValue > maxValue {
                   return "Number should not be greater then \(maxValue)"
               }
           } else if minValue > 0 {
               if validationValue < minValue {
               return "Number should not be less then \(minValue)"
               }
           } else if maxValue > 0 {
               if validationValue > maxValue {
                   return "Number should not be greater then \(maxValue)"
               }
           }
           return ""
       }
       
       
       static func CheckingTextContainsNumberAndSpecialCharecters(validationText:String) -> String {
              if validationText.rangeOfCharacter(from: charSet) != nil
            {
                 return "Text should not contains numbers or special charecters "
            } else {
              return ""
          }
      }
       
       
       static func ShouldContainOnlyNumbers(validationText:String) -> String {
            let filtered = validationText.filter { "0123456789".contains($0) }
                           if filtered != validationText {
                               return "Should not contain text"
                           } else {
                               return ""
                   }
          }
       
   static func ShouldNotContainNumbers(validationText:String) -> String {
       var numberCharSet:CharacterSet {
                     return CharacterSet.init(charactersIn: "0123456789")
                 }
       if validationText.rangeOfCharacter(from: numberCharSet) != nil
            {
                 return "Text should not contains numbers"
            } else {
              return ""
          }
      }
       
       static func ShouldNotContainSpecialCharecters(validationText:String) -> String {
           var numberCharSet:CharacterSet {
                         return CharacterSet.init(charactersIn: "!@#$%^&*()=[]{}+_~`-.,><")
                     }
           if validationText.rangeOfCharacter(from: numberCharSet) != nil
                {
                     return "Text should not contains special charecters"
                } else {
                    
                  return ""
              }
          }
       
       static func ShouldNotContainAlpha(validationText:String) -> String {
           var numberCharSet:CharacterSet {
                         return CharacterSet.init(charactersIn: "abcdefghijklmnopqrstuvwxyz")
                     }
           if validationText.rangeOfCharacter(from: numberCharSet) != nil
                {
                     return "Text should not contains numbers"
                } else {
                  return ""
              }
          }

    static func ShouldContainOnlySpecialCharecters(validationText:String) -> String {

        let filtered = validationText.filter { "!@#$%^&*()=[]{}+_~`-.,><".contains($0) }
                        if filtered != validationText {
                            return "\(filtered)"
                        } else {
                            return "Should contain only Special Charectes"
                        }
       }
    
    
       static func ShouldContainOnlyNumber(validationText:String) -> String {
   
           let filtered = validationText.filter { "0123456789".contains($0) }
                           if filtered != validationText {
                               return "\(filtered)"
                           } else {
                               return "Should contain only numbers"
                           }
           
          }
    

    
    
    var logoPlacement:logoIconPlacement = .left
     var labelName:String = ""
     var placeholder:String = ""
     var logoIcon:String = ""
     var minCharecters:Int = -1
     var maxCharecters:Int = -1
     var minValue:Int = -1
     var maxValue:Int = -1
     var validationType:txtValidation = .noValidation
    var securedEntry:Bool = false
    var showLabel:Bool = false
    var textLeadingConstruent:CGFloat = 0.0
    var textTrallingConstruent:CGFloat = 0.0
    var borderWidth:CGFloat = 0.0
    var cornerRadius:CGFloat = 0.0
    var borderColorr:CGColor = UIColor.clear.cgColor
    var textFontColor:CGColor = UIColor.black.cgColor
    var textBackgroundColor:CGColor = UIColor.clear.cgColor

    init() {
    self.labelName = ""
    self.placeholder = ""
    self.logoIcon = ""
        self.minCharecters = -1
        self.maxCharecters = -1
        self.minValue = -1
        self.maxValue = -1
        self.validationType = .noValidation
        self.logoPlacement = .left
        self.securedEntry = false
        self.showLabel = false
        self.padding = 0.0
        self.textLeadingConstruent = 0.0
        self.textTrallingConstruent = 0.0
        self.borderWidth = 0.0
        self.borderColorr = UIColor.clear.cgColor
        self.textFontColor = UIColor.black.cgColor
        self.cornerRadius = 0.0
        self.textBackgroundColor = UIColor.clear.cgColor

  }
    
    convenience init(labelName:String) {
        self.init()
        self.labelName = labelName
    }
    convenience init(placeholdar:String) {
        self.init()
        self.placeholder = placeholdar
    }
    convenience init(logoIcon:String) {
        self.init()
        self.logoIcon = logoIcon
    }
    convenience init(minCharecters:Int) {
        self.init()
        self.minCharecters = minCharecters
    }
    convenience init(maxCharecters:Int) {
        self.init()
        self.maxCharecters = maxCharecters
    }
    
    convenience init(minValue:Int) {
        self.init()
        self.minValue = minValue
    }
    
    convenience init(maxValue:Int) {
        self.init()
        self.maxValue = maxValue
    }
    
    convenience init(securedEntry:Bool) {
        self.init()
        self.securedEntry = securedEntry
    }
    convenience init(validationType:txtValidation) {
        self.init()
        self.validationType = validationType
    }
    convenience init(placeholder:String, logoIcon:String, minCharecters:Int,validationType:txtValidation) {
        self.init()
        self.placeholder = placeholder
        self.logoIcon = logoIcon
        self.minCharecters = minCharecters
        self.validationType = validationType
    }
    
    convenience init(placeholder:String, logoIcon:String, minCharecters:Int,validationType:txtValidation,padding:CGFloat) {
        self.init()
        self.placeholder = placeholder
        self.logoIcon = logoIcon
        self.minCharecters = minCharecters
        self.validationType = validationType
        self.padding = padding
    }
    
    
    convenience init(labelName:String,validationType:txtValidation) {
        self.init()
        self.labelName = labelName
        self.validationType = validationType
    }
    
    convenience init(labelName:String,placeholdar:String) {
        self.init()
        self.labelName = labelName
        self.placeholder = placeholdar
    }
    
    convenience init(labelName:String,placeholdar:String,logoIcon:String) {
        self.init()
        self.labelName = labelName
        self.placeholder = placeholdar
        self.logoIcon = logoIcon
    }
    
    convenience init(labelName:String,placeholdar:String,validationType:txtValidation) {
        self.init()
        self.labelName = labelName
        self.placeholder = placeholdar
        self.validationType = validationType
    }
    convenience init(logoPlacement:logoIconPlacement) {
        self.init()
        self.logoPlacement = logoPlacement
    }
    convenience init(labelName:String,placeholdar:String,logoIcon:String,validationType:txtValidation) {
        self.init()
        self.labelName = labelName
        self.placeholder = placeholdar
        self.logoIcon = logoIcon
        self.validationType = validationType
    }
    convenience init(labelName:String,placeholdar:String,logoIcon:String,minCharecters:Int,validationType:txtValidation) {
        self.init()
        self.labelName = labelName
        self.placeholder = placeholdar
        self.logoIcon = logoIcon
        self.minCharecters = minCharecters
        self.validationType = validationType
    }
    convenience init(labelName:String,placeholdar:String,logoIcon:String,minCharecters:Int,validationType:txtValidation,padding:CGFloat) {
        self.init()
        self.labelName = labelName
        self.placeholder = placeholdar
        self.logoIcon = logoIcon
        self.minCharecters = minCharecters
        self.validationType = validationType
        self.padding = padding
    }
    
    convenience init(labelName:String,placeholdar:String,logoIcon:String,minCharecters:Int,validationType:txtValidation,padding:CGFloat,textLeadingConstruent:CGFloat,textTrallingConstruent:CGFloat) {
        self.init()
        self.labelName = labelName
        self.placeholder = placeholdar
        self.logoIcon = logoIcon
        self.minCharecters = minCharecters
        self.validationType = validationType
        self.padding = padding
        self.textLeadingConstruent = textLeadingConstruent
        self.textTrallingConstruent = textTrallingConstruent
    }
    
    convenience init(labelName:String,placeholdar:String,logoIcon:String,minCharecters:Int,maxCharecters:Int,validationType:txtValidation) {
        self.init()
        self.labelName = labelName
        self.placeholder = placeholdar
        self.logoIcon = logoIcon
        self.minCharecters = minCharecters
        self.maxCharecters = maxCharecters
        self.validationType = validationType
    }
    

    convenience init(labelName:String , placeholder:String, logoIcon:String, maxCharecters:Int,maxValue:Int,validationType:txtValidation) {
        self.init()
        self.labelName = labelName
        self.placeholder = placeholder
        self.logoIcon = logoIcon
        self.maxValue = maxValue
        self.maxCharecters = maxCharecters
        self.validationType = validationType
    }
    
    convenience init(labelName:String , placeholder:String, logoIcon:String, minCharecters:Int,minValue:Int,validationType:txtValidation) {
        self.init()
        self.labelName = labelName
        self.placeholder = placeholder
        self.logoIcon = logoIcon
        self.minCharecters = minCharecters
        self.minValue = minValue
        self.validationType = validationType
    }
    
    convenience init(labelName:String , placeholder:String, logoIcon:String, minCharecters:Int,minValue:Int,maxValue:Int,validationType:txtValidation) {
        self.init()
        self.labelName = labelName
        self.placeholder = placeholder
        self.logoIcon = logoIcon
        self.minCharecters = minCharecters
        self.minValue = minValue
        self.validationType = validationType
    }
    
    convenience init(labelName:String , placeholder:String, logoIcon:String, minCharecters:Int,maxCharecters:Int,validationType:txtValidation) {
        self.init()
        self.labelName = labelName
        self.placeholder = placeholder
        self.logoIcon = logoIcon
        self.minCharecters = minCharecters
        self.maxCharecters = maxCharecters
        self.validationType = validationType
    }
    
    convenience init(labelName: String, placeholder: String, logoIcon: String, minCharecters:Int, maxCharecters:Int , minValue:Int , maxValue:Int,validationType:txtValidation) {
        self.init()
        self.labelName = labelName
        self.placeholder = placeholder
        self.logoIcon = logoIcon
        self.minCharecters = minCharecters
        self.maxCharecters = maxCharecters
        self.minValue = minValue
        self.validationType = validationType
        
     }
    
    convenience init(labelName: String, placeholder: String, logoIcon: String,securedEntry:Bool,validationType:txtValidation,logoPlacement:logoIconPlacement) {
        self.init()
        self.labelName = labelName
        self.placeholder = placeholder
        self.logoIcon = logoIcon
        self.securedEntry = securedEntry
        self.validationType = validationType
        self.logoPlacement = logoPlacement
        
     }
    
    convenience init(labelName: String, placeholder: String, logoIcon: String, minCharecters:Int, maxCharecters:Int , minValue:Int , maxValue:Int,validationType:txtValidation,logoPlacement:logoIconPlacement) {
        self.init()
        self.labelName = labelName
        self.placeholder = placeholder
        self.logoIcon = logoIcon
        self.minCharecters = minCharecters
        self.maxCharecters = maxCharecters
        self.minValue = minValue
        self.validationType = validationType
        self.logoPlacement = logoPlacement
        
     }
    
    convenience init(labelName: String, placeholder: String, logoIcon: String, minCharecters:Int, maxCharecters:Int , minValue:Int , maxValue:Int,securedEntry:Bool,validationType:txtValidation,logoPlacement:logoIconPlacement) {
        self.init()
        self.labelName = labelName
        self.placeholder = placeholder
        self.logoIcon = logoIcon
        self.minCharecters = minCharecters
        self.maxCharecters = maxCharecters
        self.minValue = minValue
        self.securedEntry = securedEntry
        self.validationType = validationType
        self.logoPlacement = logoPlacement
        
     }
    
   
    
    convenience init(labelName: String, placeholder: String, logoIcon: String, minCharecters:Int, maxCharecters:Int , minValue:Int , maxValue:Int,securedEntry:Bool,validationType:txtValidation,logoPlacement:logoIconPlacement,showLabel:Bool) {
        self.init()
        self.labelName = labelName
        self.placeholder = placeholder
        self.logoIcon = logoIcon
        self.minCharecters = minCharecters
        self.maxCharecters = maxCharecters
        self.minValue = minValue
        self.securedEntry = securedEntry
        self.validationType = validationType
        self.logoPlacement = logoPlacement
        self.showLabel = showLabel
     }
    
    convenience init(labelName: String, placeholder: String, logoIcon: String, minCharecters:Int, maxCharecters:Int , minValue:Int , maxValue:Int,securedEntry:Bool,validationType:txtValidation,logoPlacement:logoIconPlacement,showLabel:Bool,padding:CGFloat) {
        self.init()
        self.labelName = labelName
        self.placeholder = placeholder
        self.logoIcon = logoIcon
        self.minCharecters = minCharecters
        self.maxCharecters = maxCharecters
        self.minValue = minValue
        self.securedEntry = securedEntry
        self.validationType = validationType
        self.logoPlacement = logoPlacement
        self.showLabel = showLabel
        self.padding = padding
     }
    
    convenience init(labelName: String, placeholder: String, logoIcon: String, minCharecters:Int, maxCharecters:Int , minValue:Int , maxValue:Int,securedEntry:Bool,validationType:txtValidation,logoPlacement:logoIconPlacement,showLabel:Bool,padding:CGFloat,textLeadingConstruent:CGFloat){
        self.init()
        self.labelName = labelName
        self.placeholder = placeholder
        self.logoIcon = logoIcon
        self.minCharecters = minCharecters
        self.maxCharecters = maxCharecters
        self.minValue = minValue
        self.securedEntry = securedEntry
        self.validationType = validationType
        self.logoPlacement = logoPlacement
        self.showLabel = showLabel
        self.padding = padding
        self.textLeadingConstruent = textLeadingConstruent
  
     }
    
    convenience init(labelName: String, placeholder: String, logoIcon: String, minCharecters:Int, maxCharecters:Int , minValue:Int , maxValue:Int,securedEntry:Bool,validationType:txtValidation,logoPlacement:logoIconPlacement,showLabel:Bool,padding:CGFloat,textLeadingConstruent:CGFloat, textTrallingConstruent:CGFloat) {
        self.init()
        self.labelName = labelName
        self.placeholder = placeholder
        self.logoIcon = logoIcon
        self.minCharecters = minCharecters
        self.maxCharecters = maxCharecters
        self.minValue = minValue
        self.securedEntry = securedEntry
        self.validationType = validationType
        self.logoPlacement = logoPlacement
        self.showLabel = showLabel
        self.padding = padding
        self.textLeadingConstruent = textLeadingConstruent
        self.textTrallingConstruent = textTrallingConstruent
     }
    
    
    
    convenience init(labelName: String, placeholder: String, logoIcon: String, minCharecters:Int, maxCharecters:Int , minValue:Int , maxValue:Int,securedEntry:Bool,validationType:txtValidation,logoPlacement:logoIconPlacement,showLabel:Bool,padding:CGFloat,textLeadingConstruent:CGFloat, textTrallingConstruent:CGFloat,borderWidth:CGFloat,borderColorr:CGColor,textFontColor:CGColor ,cornerRadius:CGFloat
                     , textBackgroundColor:CGColor) {
        self.init()
        self.labelName = labelName
        self.placeholder = placeholder
        self.logoIcon = logoIcon
        self.minCharecters = minCharecters
        self.maxCharecters = maxCharecters
        self.minValue = minValue
        self.securedEntry = securedEntry
        self.validationType = validationType
        self.logoPlacement = logoPlacement
        self.showLabel = showLabel
        self.padding = padding
        self.textLeadingConstruent = textLeadingConstruent
        self.textTrallingConstruent = textTrallingConstruent
        
        self.borderWidth = borderWidth
        self.borderColorr = borderColorr
        self.textFontColor = textFontColor
        self.cornerRadius = cornerRadius
        self.textBackgroundColor = textBackgroundColor
     }
    
}




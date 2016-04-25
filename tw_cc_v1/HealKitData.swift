//
//  Healkit.swift
//  tw_cc_v1
//
//  Created by Petr Bilek on 25.04.16.
//  Copyright © 2016 Laky. All rights reserved.
//

import UIKit
import HealthKit

class HealKitData {

	var healthKitStore: HKHealthStore!
	var isAuthorized = false
    var info = [String: String]()
    

	func healkitIsAvailable() -> Bool
	{
		healthKitStore = HKHealthStore()
		if !HKHealthStore.isHealthDataAvailable()
		{
			let error = NSError(domain: "com.raywenderlich.tutorials.healthkit", code: 2, userInfo: [NSLocalizedDescriptionKey: "HealthKit is not available in this Device"])

			print(error)
		}
		isAuthorized = true

		return isAuthorized
	}
    
    func biologicalSexLiteral(biologicalSex: HKBiologicalSex?) -> String
	{
		var biologicalSexText = "Unknow";

		if biologicalSex != nil {

			switch (biologicalSex!)
			{
				case .Female:
				biologicalSexText = "Female"
				case .Male:
				biologicalSexText = "Male"
				default:
				break;
			}

		}
		return biologicalSexText;
	}
    
    func birthDayLiteral(date: NSDate?) -> String
	{
        if let birthDay = date {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = .LongStyle
            return dateFormatter.stringFromDate(birthDay)
		}

		return "Unknow"
	}
    
    func bloodTypeLiteral(bloodType: HKBloodType?) -> String
	{
		if bloodType != nil {

			switch (bloodType!) {
				case .APositive:
				return "A+"
				case .ANegative:
				return "A-"
				case .BPositive:
				return "B+"
				case .BNegative:
				return "B-"
				case .ABPositive:
				return "AB+"
				case .ABNegative:
				return "AB-"
				case .OPositive:
				return "O+"
				case .ONegative:
				return "O-"
				default:
				break;
			}

		}
		return "Unknow";
    }

	func skinTypeLiteral(skinType: HKFitzpatrickSkinType?) -> String
	{
		if skinType != nil {

			switch (skinType!) {
			case .I:
				return "I"
			case .II:
				return "II"
			case .III:
				return "III"
			case .IV:
				return "IV"
			case .V:
				return "V"
			case .VI:
				return "VI"
			default:
				break;
			}
		}

		return "Unknow";
	}
	
    
   private func readDataFromHealkit()
	{
		let biologicalSex: HKBiologicalSexObject? = try? healthKitStore.biologicalSex()
		info["biologicalSex"] = biologicalSexLiteral(biologicalSex?.biologicalSex)

		let birthDay = try? healthKitStore.dateOfBirth()
		info["birthDay"] = birthDayLiteral(birthDay)

		let bloodType = try? healthKitStore.bloodType()
		info["bloodType"] = bloodTypeLiteral(bloodType?.bloodType)

		let skinType = try? healthKitStore.fitzpatrickSkinType()
		info["skinType"] = skinTypeLiteral(skinType?.skinType)
	}

	func authorizePermission()
	{
		let healthKitTypesToRead = Set(arrayLiteral:
            /*--------------------------------------*/
            /*   HKCharacteristicType Identifiers   */
            /*--------------------------------------*/
            HKObjectType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierBiologicalSex)!,
			HKObjectType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierDateOfBirth)!,
			HKObjectType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierBloodType)!,
			HKObjectType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierFitzpatrickSkinType)!,

			// Body Measurements
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMassIndex)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyFatPercentage)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeight)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierLeanBodyMass)!,
            
            // Fitness
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDistanceWalkingRunning)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDistanceCycling)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBasalEnergyBurned)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierActiveEnergyBurned)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierFlightsClimbed)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierNikeFuel)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierAppleExerciseTime)!,
            
            // Vitals
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyTemperature)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBasalBodyTemperature)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBloodPressureSystolic)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBloodPressureDiastolic)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierRespiratoryRate)!,
            
            // Results
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierOxygenSaturation)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierPeripheralPerfusionIndex)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBloodGlucose)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierNumberOfTimesFallen)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierElectrodermalActivity)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierInhalerUsage)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBloodAlcoholContent)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierForcedVitalCapacity)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierForcedExpiratoryVolume1)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierPeakExpiratoryFlowRate)!,
            
            // Nutrition
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryFatTotal)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryFatPolyunsaturated)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryFatMonounsaturated)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryFatSaturated)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryCholesterol)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietarySodium)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryCarbohydrates)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryFiber)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietarySugar)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryEnergyConsumed)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryProtein)!,
            
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryVitaminA)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryVitaminB6)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryVitaminB12)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryVitaminC)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryVitaminD)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryVitaminE)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryVitaminK)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryCalcium)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryIron)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryThiamin)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryRiboflavin)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryNiacin)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryFolate)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryBiotin)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryPantothenicAcid)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryPhosphorus)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryIodine)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryMagnesium)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryZinc)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietarySelenium)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryCopper)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryManganese)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryChromium)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryMolybdenum)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryChloride)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryPotassium)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryCaffeine)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryWater)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierUVExposure)!,
            
            /*--------------------------------*/
            /*   HKCategoryType Identifiers   */
            /*--------------------------------*/
            HKObjectType.categoryTypeForIdentifier(HKCategoryTypeIdentifierSleepAnalysis)!,
            HKObjectType.categoryTypeForIdentifier(HKCategoryTypeIdentifierAppleStandHour)!,
            HKObjectType.categoryTypeForIdentifier(HKCategoryTypeIdentifierCervicalMucusQuality)!,
            HKObjectType.categoryTypeForIdentifier(HKCategoryTypeIdentifierOvulationTestResult)!,
            HKObjectType.categoryTypeForIdentifier(HKCategoryTypeIdentifierMenstrualFlow)!,
            HKObjectType.categoryTypeForIdentifier(HKCategoryTypeIdentifierIntermenstrualBleeding)!,
            HKObjectType.categoryTypeForIdentifier(HKCategoryTypeIdentifierSexualActivity)!,
            
            /*------------------------------*/
            /*   HKWorkoutType Identifier   */
            /*------------------------------*/
            HKObjectType.workoutType()
		)

		healthKitStore.requestAuthorizationToShareTypes(nil, readTypes: healthKitTypesToRead) { (success, error) -> Void in
            // handle succes && error
		}
        
        self.readDataFromHealkit()
	}

	func getInformation() -> [String: String] {
        info["HealtKit available"] = isAuthorized ? "Yes" : "No"
        
		return info
	}

}

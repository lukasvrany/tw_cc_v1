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

    
   private func readDataFromHealkit()
	{
		let biologicalSex: HKBiologicalSexObject? = try? healthKitStore.biologicalSex()
		info["biologicalSex"] = biologicalSexLiteral(biologicalSex?.biologicalSex)

		let birthDay = try? healthKitStore.dateOfBirth()
		info["birthDay"] = birthDayLiteral(birthDay)

		let bloodType = try? healthKitStore.bloodType()
		info["bloodType"] = bloodTypeLiteral(bloodType?.bloodType)
        
        
        readWeight()
        readHeight()
//        readBMI()
    }
    
//    private func readBMI()
//    {
//        var bmi:HKQuantitySample?
//        
//        let sampleType = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMassIndex)
//        
//        self.readMostRecentSample(sampleType!, completion: { (mostRecentbmi, error) -> Void in
//            
//            if( error != nil )
//            {
//                print("Error reading weight from HealthKit Store: \(error.localizedDescription)")
//                return;
//            }
//            
//            var bmiLocalizedString = "Unknow"
//            
//            bmi = mostRecentbmi as? HKQuantitySample
//            bmi?.quantity
//            if let bmiValue = bmi?.quantity.doubleValueForUnit(HKUnit.weight()) {
////                let formatter = NSFormatter
////                formatter.forPersonHeightUse = true
////                bmiLocalizedString = formatter.stringFrom
//            }
//            
//            print(bmiLocalizedString)
//        });
//    }
    
    
    private func readSexActivity()
    {
        var sex:HKQuantitySample?
        
        let sampleType = HKSampleType.quantityTypeForIdentifier(HKCategoryTypeIdentifierSexualActivity)
        
        self.readMostRecentSample(sampleType!, completion: { (mostRecentSex, error) -> Void in
            
            if( error != nil )
            {
                print("Error reading weight from HealthKit Store: \(error.localizedDescription)")
                return;
            }
            
            var weightLocalizedString = "Unknow"
            
            sex = mostRecentSex as? HKQuantitySample;
//            sex?.quantity.
//            if let kilograms = sex?.quantity.doubleValueForUnit(HKUnit.gramUnitWithMetricPrefix(.Kilo)) {
//                let weightFormatter = NSMassFormatter()
//                weightFormatter.forPersonMassUse = true;
//                weightLocalizedString = weightFormatter.stringFromValue(kilograms, unit: NSMassFormatterUnit.Kilogram)
//            }
            
            print(weightLocalizedString)
        });
    }
    
    private func readHeight()
    {
        var height:HKQuantitySample?
        
        let sampleType = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeight)
        
        self.readMostRecentSample(sampleType!, completion: { (mostRecentHeight, error) -> Void in
            
            if( error != nil )
            {
                print("Error reading weight from HealthKit Store: \(error.localizedDescription)")
                return;
            }
            
            var heightLocalizedString = "Unknow"
            
            height = mostRecentHeight as? HKQuantitySample
            if let meters = height?.quantity.doubleValueForUnit(HKUnit.meterUnit()) {
                let heightFormatter = NSLengthFormatter()
                heightFormatter.forPersonHeightUse = true
                heightLocalizedString = heightFormatter.stringFromValue(meters, unit: NSLengthFormatterUnit.Centimeter)
            }
            
            print(heightLocalizedString)
        });
    }
    
    private func readWeight()
    {
        var weight:HKQuantitySample?
    
        let sampleType = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)
        
        self.readMostRecentSample(sampleType!, completion: { (mostRecentWeight, error) -> Void in
            
            if( error != nil )
            {
                print("Error reading weight from HealthKit Store: \(error.localizedDescription)")
                return;
            }
            
            var weightLocalizedString = "Unknow"
            
            weight = mostRecentWeight as? HKQuantitySample;
            if let kilograms = weight?.quantity.doubleValueForUnit(HKUnit.gramUnitWithMetricPrefix(.Kilo)) {
                let weightFormatter = NSMassFormatter()
                weightFormatter.forPersonMassUse = true;
                weightLocalizedString = weightFormatter.stringFromValue(kilograms, unit: NSMassFormatterUnit.Kilogram)
            }
            
            print(weightLocalizedString)
        });
    }
    
    func readMostRecentSample(sampleType:HKSampleType , completion: ((HKSample!, NSError!) -> Void)!)
    {
        let past = NSDate.distantPast() 
        let now   = NSDate()
        
        let mostRecentPredicate = HKQuery.predicateForSamplesWithStartDate(past, endDate:now, options: .None)
        
        let sortDescriptor = NSSortDescriptor(key:HKSampleSortIdentifierStartDate, ascending: false)

        let limit = 1
        
        let sampleQuery = HKSampleQuery(sampleType: sampleType, predicate: mostRecentPredicate, limit: limit, sortDescriptors: [sortDescriptor])
        { (sampleQuery, results, error ) -> Void in
            
            if error != nil {
                completion(nil,error)
                return;
            }
            
            // Get the first sample
            let mostRecentSample = results!.first as? HKQuantitySample
            
            // Execute the completion closure
            if completion != nil {
                completion(mostRecentSample,nil)
            }
        }
        
        self.healthKitStore.executeQuery(sampleQuery)
    }

	func authorizePermission()
	{
		let healthKitTypesToRead = Set(arrayLiteral:
            /*--------------------------------------*/
            /*   HKCharacteristicType Identifiers   */
            /*--------------------------------------*/
            HKObjectType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierBiologicalSex)!, // D
			HKObjectType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierDateOfBirth)!, // D
			HKObjectType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierBloodType)!, // D

			// Body Measurements
//            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMassIndex)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeight)!, // D
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)!, // D
            
            // Fitness
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDistanceWalkingRunning)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDistanceCycling)!,
            
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBasalEnergyBurned)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierActiveEnergyBurned)!,
            
            // Vitals
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)!,
            
            /*--------------------------------*/
            /*   HKCategoryType Identifiers   */
            /*--------------------------------*/
            HKObjectType.categoryTypeForIdentifier(HKCategoryTypeIdentifierSleepAnalysis)!,
            HKObjectType.categoryTypeForIdentifier(HKCategoryTypeIdentifierMenstrualFlow)!,
            HKObjectType.categoryTypeForIdentifier(HKCategoryTypeIdentifierSexualActivity)! // D
		)

		healthKitStore.requestAuthorizationToShareTypes(nil, readTypes: healthKitTypesToRead) { (success, error) -> Void in
            // handle succes && error
		}
        
	}

	func getInformation() -> [String: String] {
        info["HealtKit available"] = isAuthorized ? "Yes" : "No"
        
        self.readDataFromHealkit()
        
		return info
	}

}

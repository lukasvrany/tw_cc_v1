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
			let error = NSError(domain: "tw-cc-v1", code: 2, userInfo: [NSLocalizedDescriptionKey: "HealthKit is not available in this Device"])

            // Handle error
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
            if (completion != nil && mostRecentSample != nil) {
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
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeight)!, // D
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)!, // D
            
            // Fitness
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)!, // D
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDistanceWalkingRunning)!, // D
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDistanceCycling)!, //D
            
            /*--------------------------------*/
            /*   HKCategoryType Identifiers   */
            /*--------------------------------*/
            HKObjectType.categoryTypeForIdentifier(HKCategoryTypeIdentifierSleepAnalysis)!, // D
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
    
    func getPostData() -> [String: String] {
        return info
    }

}

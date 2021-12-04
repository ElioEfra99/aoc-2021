import Foundation

// Default aoc code
let fileName = "input3"
let DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
let fileURL = DocumentDirURL.appendingPathComponent(fileName).appendingPathExtension("txt")
        
var readString = "" // Used to store the file contents

do {
    // Read the file contents
    readString = try String(contentsOf: fileURL)
} catch let error as NSError {
    print("Failed reading from URL: \(fileURL), Error: " + error.localizedDescription)
}

let inputStrArray = Array(readString.split(separator: "\n"))

// Part 1

func generateGammaRate(from input: Array<Substring>) -> String {
    var gammaRate = ""
    var numberOfZeroBits = 0
    var numberOfOneBits = 0
    
    for i in 0 ..< input[0].count {
        numberOfOneBits = 0
        numberOfZeroBits = 0
        for binary in input {
            if binary[binary.index(binary.startIndex, offsetBy: i)] == "0" {
                numberOfZeroBits += 1
            } else {
                numberOfOneBits += 1
            }
        }

        if numberOfZeroBits > numberOfOneBits {
            gammaRate.append("0")
        } else {
            gammaRate.append("1")
        }
        
    }

    return gammaRate
}

func generateEpsilonRate(from gammaRate: String) -> String {
    var epsilonRate = ""

    for i in gammaRate {
        if i == "0" {
            epsilonRate.append("1")
        } else {
            epsilonRate.append("0")
        }
    }

    return epsilonRate
}

/*let gammaRate = generateGammaRate(from: inputStrArray)
let epsilonRate = generateEpsilonRate(from: gammaRate)

print(gammaRate)
print(epsilonRate)*/

// Part 2

func findOxygenGeneratorRating(from input: Array<Substring>) -> String {
    // Array to copy original items
    var diagnosticReport = input
    var numberOfOneBits = 0
    var numberOfZeroBits = 0

    // Iterate through every input string
    for i in 0 ..< diagnosticReport[0].count {
        if diagnosticReport.count == 1 {
            return String(diagnosticReport.first!)
        }

        numberOfOneBits = 0
        numberOfZeroBits = 0

        for binary in diagnosticReport {
            if binary[binary.index(binary.startIndex, offsetBy: i)] == "0" {
                numberOfZeroBits += 1
            } else {
                numberOfOneBits += 1
            }
        }

        if numberOfZeroBits > numberOfOneBits {
            // Keep only the numbers with the most repeated item (0)
            // In this case, if zero is the most repeated, here we'll preserve it

            // Perform array dump
            diagnosticReport.removeAll(where: { binary in
                binary[binary.index(binary.startIndex, offsetBy: i)] == "1"
            })

        } else if numberOfOneBits > numberOfZeroBits {
            // Keep only the numbers with the most repeated item (1)
            diagnosticReport.removeAll(where: { binary in
                binary[binary.index(binary.startIndex, offsetBy: i)] == "0"
            })
        } else {
            // Amount of 0s and 1s is equal, keep values with a 1 in he current bit position
            // Keep only the numbers with a (1) in the current position
            
            diagnosticReport.removeAll(where: { binary in
                binary[binary.index(binary.startIndex, offsetBy: i)] == "0"
            })
        }
        
    }

    return String(diagnosticReport.first!)

}

func findCo2ScrubberRating(from input: Array<Substring>) -> String {
    var diagnosticReport = input
    var numberOfOneBits = 0
    var numberOfZeroBits = 0

    for i in 0 ..< diagnosticReport[0].count {
        if diagnosticReport.count == 1 {
            return String(diagnosticReport.first!)
        }

        numberOfOneBits = 0
        numberOfZeroBits = 0

        for binary in diagnosticReport {
            if binary[binary.index(binary.startIndex, offsetBy: i)] == "0" {
                numberOfZeroBits += 1
            } else {
                numberOfOneBits += 1
            }
        }

        if numberOfZeroBits < numberOfOneBits {
            // Keep only the numbers with the least repeated item
            // In this case, if zero is the least repeated, here we'll preserve it

            // Perform array dump
            diagnosticReport.removeAll(where: { binary in
                binary[binary.index(binary.startIndex, offsetBy: i)] == "1"
            })

        } else if numberOfOneBits < numberOfZeroBits {
            // Keep only the numbers with (1) bit
            diagnosticReport.removeAll(where: { binary in
                binary[binary.index(binary.startIndex, offsetBy: i)] == "0"
            })
            
        } else {
            // Amount of 0s and 1s is equal, keep values with a 0 in he current bit position
            // Keep only the numbers with a (0) in the current position
            
            diagnosticReport.removeAll(where: { binary in
                binary[binary.index(binary.startIndex, offsetBy: i)] == "1"
            })
        }
        
    }

    return String(diagnosticReport.first!)
}

let oxygenGeneratorRating = findOxygenGeneratorRating(from: inputStrArray)
print(oxygenGeneratorRating)
let co2ScrubberRating = findCo2ScrubberRating(from: inputStrArray)
print(co2ScrubberRating)

import Foundation

let fileName = "input1"
let DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
let fileURL = DocumentDirURL.appendingPathComponent(fileName).appendingPathExtension("txt")

print("FilePath: \(fileURL.path)")        
        
var readString = "" // Used to store the file contents
do {
    // Read the file contents
    readString = try String(contentsOf: fileURL)
} catch let error as NSError {
    print("Failed reading from URL: \(fileURL), Error: " + error.localizedDescription)
}

let inputStrArray = Array(readString.split(separator: "\n"))

// Part 1

let measurements = inputStrArray.map { Int($0)! }
// var increased = 0

/*for i in 1..<measurements.count {
    if measurements[i] > measurements[i - 1] {
        increased += 1
    }
}*/

// Part 2

var increased = 0

for i in 3 ..< measurements.count {
    if measurements[i] > measurements[i - 3] {
        increased += 1
    }
}

print(increased)
import Foundation

// Default aoc code
let fileName = "input5"
let DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
let fileURL = DocumentDirURL.appendingPathComponent(fileName).appendingPathExtension("txt")
var readString = ""

do {
    readString = try String(contentsOf: fileURL)
} catch let error as NSError {
    print("Failed reading from URL: \(fileURL), Error: " + error.localizedDescription)
}

var inputStrArray = Array(readString.split(separator: "\n").map { String($0) })

// Part 1

struct Coordinate {
    let x: Int
    let y: Int

    init(coordinates: String) {
        let coords = coordinates.split(separator: ",")
        self.x = Int(coords[0])!
        self.y = Int(coords[1])!
    }
}

struct VentLine {
    let lineStart: Coordinate
    let lineEnd: Coordinate
}

func createVentLines(input: [String]) -> [VentLine] {
    var ventLines = [VentLine]()
    for line in input {
        let separators = CharacterSet(charactersIn: "->")
        var coordinates = line.components(separatedBy: separators)
        coordinates.removeAll(where: { $0 == "" })
        let trimmedCoordinate = coordinates.compactMap { $0.trimmingCharacters(in: .whitespaces) }

        let lineStart = Coordinate(coordinates: trimmedCoordinate[0])
        let lineEnd = Coordinate(coordinates: trimmedCoordinate[1])
        let ventLine = VentLine(lineStart: lineStart, lineEnd: lineEnd)
        
        ventLines.append(ventLine)
    }
    return ventLines
}

func getHorizontalAndVerticalVentLines(from ventLines: [VentLine]) -> [VentLine] {
    var horizontalAndVerticalVentLines = [VentLine]()

    for lines in ventLines {
        if lines.lineStart.x == lines.lineEnd.x || lines.lineStart.y == lines.lineEnd.y {
            horizontalAndVerticalVentLines.append(lines)
        }
    }

    return horizontalAndVerticalVentLines
}

func generateDiagram(from ventLines: [VentLine]) -> [[Character]] {
    let longestXCoordinate = findLargestXCoordinate(from: ventLines)
    let longestYCoordinate = findLargestYCoordinate(from: ventLines)
    
    var diagram = [[Character]]()
    for _ in 0...longestYCoordinate {
        let row = Array<Character>(repeating: ".", count: longestXCoordinate + 1)
        diagram.append(row)
    }

    return diagram
}

func findLargestXCoordinate(from ventLines: [VentLine]) -> Int {
    var largestCoordinate = 0

    for ventLine in ventLines {
        if ventLine.lineStart.x > largestCoordinate {
            largestCoordinate = ventLine.lineStart.x
        }
        if ventLine.lineEnd.x > largestCoordinate {
            largestCoordinate = ventLine.lineEnd.x
        }
    }

    return largestCoordinate
}

func findLargestYCoordinate(from ventLines: [VentLine]) -> Int {
    var largestCoordinate = 0

    for ventLine in ventLines {
        if ventLine.lineStart.y > largestCoordinate {
            largestCoordinate = ventLine.lineStart.y
        }
        if ventLine.lineEnd.y > largestCoordinate {
            largestCoordinate = ventLine.lineEnd.y
        }
    }

    return largestCoordinate
}

func populateDiagramWithHorizontalAndVerticalLines(_ diagram: inout [[Character]], from ventLines: [VentLine]) {
    for lines in ventLines {
        let isVertical = lines.lineStart.x == lines.lineEnd.x ? true : false
        if isVertical {
            let goesFromBottomToTop = lines.lineStart.y > lines.lineEnd.y
            if goesFromBottomToTop {
                for i in stride(from: lines.lineStart.y, through: lines.lineEnd.y, by: -1) {
                    if var number = Int(String(diagram[i][lines.lineStart.x])) {
                        number += 1
                        diagram[i][lines.lineStart.x] = Character(String(number))
                    } else {
                        diagram[i][lines.lineStart.x] = "1"
                    }
                }
            } else {
                for i in lines.lineStart.y...lines.lineEnd.y {
                    if var number = Int(String(diagram[i][lines.lineStart.x])) {
                        number += 1
                        diagram[i][lines.lineStart.x] = Character(String(number))
                    } else {
                        diagram[i][lines.lineStart.x] = "1"
                    }
                }
            }
        } else {
            let goesFromRightToLeft = lines.lineStart.x > lines.lineEnd.x
            if goesFromRightToLeft {
                for i in stride(from: lines.lineStart.x, through: lines.lineEnd.x, by: -1) {
                    if var number = Int(String(diagram[lines.lineStart.y][i])) {
                        number += 1
                        diagram[lines.lineStart.y][i] = Character(String(number))
                    } else {
                        diagram[lines.lineStart.y][i] = "1"
                    }
                }
            } else {
                for i in lines.lineStart.x...lines.lineEnd.x {
                    if var number = Int(String(diagram[lines.lineStart.y][i])) {
                        number += 1
                        diagram[lines.lineStart.y][i] = Character(String(number))
                    } else {
                        diagram[lines.lineStart.y][i] = "1"
                    }
                }
            }
        }
    }
}

func getDiagonalLines(from ventLines: [VentLine]) -> [VentLine] {
    var diagonalLines = [VentLine]()

    for lines in ventLines {
        if lines.lineStart.x != lines.lineEnd.x && lines.lineStart.y != lines.lineEnd.y {
            diagonalLines.append(lines)
        }
    }

    return diagonalLines
}

func populateDiagramWithDiagonalLines(_ diagram: inout [[Character]], from ventLines: [VentLine]) {
    
    for lines in ventLines {
        let diagonalBottomLeftToTopRight = lines.lineStart.x < lines.lineEnd.x && lines.lineStart.y > lines.lineEnd.y
        let diagonalTopLeftToBottomRight = lines.lineStart.x < lines.lineEnd.x && lines.lineStart.y < lines.lineEnd.y
        let diagonalBottomRightToTopLeft = lines.lineStart.x > lines.lineEnd.x && lines.lineStart.y > lines.lineEnd.y
        let diagonalTopRightToBottomLeft = lines.lineStart.x > lines.lineEnd.x && lines.lineStart.y < lines.lineEnd.y

        if diagonalBottomLeftToTopRight {
            var xAxis = lines.lineStart.x
            var yAxis = lines.lineStart.y

            while xAxis <= lines.lineEnd.x && yAxis >= lines.lineEnd.y {
                
                if var number = Int(String(diagram[yAxis][xAxis])) {
                    number += 1
                    diagram[yAxis][xAxis] = Character(String(number))
                } else {
                    diagram[yAxis][xAxis] = "1"
                }

                xAxis += 1
                yAxis -= 1
            }

        } else if diagonalTopLeftToBottomRight {
            var xAxis = lines.lineStart.x
            var yAxis = lines.lineStart.y

            while xAxis <= lines.lineEnd.x && yAxis <= lines.lineEnd.y {
                if var number = Int(String(diagram[yAxis][xAxis])) {
                    number += 1
                    diagram[yAxis][xAxis] = Character(String(number))
                } else {
                    diagram[yAxis][xAxis] = "1"
                }
                
                xAxis += 1
                yAxis += 1
            }
        } else if diagonalBottomRightToTopLeft {
            var xAxis = lines.lineStart.x
            var yAxis = lines.lineStart.y

            while xAxis >= lines.lineEnd.x && yAxis >= lines.lineEnd.y {
                if var number = Int(String(diagram[yAxis][xAxis])) {
                    number += 1
                    diagram[yAxis][xAxis] = Character(String(number))
                } else {
                    diagram[yAxis][xAxis] = "1"
                }
                
                xAxis -= 1
                yAxis -= 1
            }
        } else if diagonalTopRightToBottomLeft {
            var xAxis = lines.lineStart.x
            var yAxis = lines.lineStart.y

            while xAxis >= lines.lineEnd.x && yAxis <= lines.lineEnd.y {
                if var number = Int(String(diagram[yAxis][xAxis])) {
                    number += 1
                    diagram[yAxis][xAxis] = Character(String(number))
                } else {
                    diagram[yAxis][xAxis] = "1"
                }
                
                xAxis -= 1
                yAxis += 1
            }
        }

    }
}

func whereDoCoordinatesOverlap(in diagram: [[Character]]) {
    var sum = 0
    for row in diagram {
        for col in 0..<row.count {
            if let number = Int(String(row[col])), number >= 2 {
                sum += 1
            }
        }
    }
    print(sum)
}

// Test Data
let testInput = ["0,9 -> 5,9", "8,0 -> 0,8", "9,4 -> 3,4", "2,2 -> 2,1",
                 "7,0 -> 7,4", "6,4 -> 2,0", "0,9 -> 2,9", "3,4 -> 1,4",
                 "0,0 -> 8,8", "5,5 -> 8,2"]
/*
var testVentLines = createVentLines(input: testInput)
var validTestVentLines = removeUnvalidVentLines(from: testVentLines)
var diagram = generateDiagram(from: testVentLines)
print(validTestVentLines)
populateDiagram(&diagram, from: validTestVentLines)


print(diagram)
whereDoCoordinatesOverlap(in: diagram)

*/

/*let ventLines = createVentLines(input: inputStrArray)
var validVentLines = removeUnvalidVentLines(from: ventLines)
var diagram = generateDiagram(from: ventLines)
populateDiagram(&diagram, from: validVentLines)
whereDoCoordinatesOverlap(in: diagram)*/

// Part 2
let ventLines = createVentLines(input: inputStrArray)
var horizontalAndVerticalVentLines = getHorizontalAndVerticalVentLines(from: ventLines)
var diagonalLines = getDiagonalLines(from: ventLines)
var diagram = generateDiagram(from: ventLines)
populateDiagramWithHorizontalAndVerticalLines(&diagram, from: horizontalAndVerticalVentLines)
populateDiagramWithDiagonalLines(&diagram, from: diagonalLines)

whereDoCoordinatesOverlap(in: diagram)


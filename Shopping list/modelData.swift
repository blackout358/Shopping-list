import SwiftUI
import Foundation

struct Items: Codable, Hashable {
    let id = UUID()
    var itemName: String
    var isCompleted: Bool
}


var itemsList: [Items] = load("itemsData.json")

func copyFileFromBundleToDocumentsFolder(sourceFile: String, destinationFile: String = "") {
    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first

    if let documentsURL = documentsURL {
        let sourceURL = Bundle.main.bundleURL.appendingPathComponent("itemsData.json")

        // Use the same filename if destination filename is not specified
        let destURL = documentsURL.appendingPathComponent(!destinationFile.isEmpty ? destinationFile : sourceFile)

        do {
            try FileManager.default.removeItem(at: destURL)
            print("Removed existing file at destination")
        } catch (let error) {
            print(error)
        }

        do {
            try FileManager.default.copyItem(at: sourceURL, to: destURL)
            print("\(sourceFile) was copied successfully.")
        } catch (let error) {
            print(error)
        }
    }
}


func load<T: Decodable>(_ filename: String) -> T {
    let data: Data

    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
    }

    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }

    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}

func writeJSON(items: [Items]) {
    do {
        let fileURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent("itemsData.json")

        let encoder = JSONEncoder()
        try encoder.encode(items).write(to: fileURL)
    } catch {
        print(error.localizedDescription)
    }
    
    func saveJSONDataToFile(json: Data, fileName: String) {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first

        if let documentsURL = documentsURL {
            let fileURL = documentsURL.appendingPathComponent("itemData.json")

            do {
                try json.write(to: fileURL, options: .atomicWrite)
            } catch {
                print(error)
            }
        }
    }
    
    func listDocumentDirectoryFiles() {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first

        if let url = documentsURL {
            do {
                let contents = try FileManager.default.contentsOfDirectory(atPath: url.path)
                print("\(contents.count) files inside the document directory:")
                for file in contents {
                    print(file)
                }
            } catch {
                print("Could not retrieve contents of the document directory.")
            }
        }
    }
}

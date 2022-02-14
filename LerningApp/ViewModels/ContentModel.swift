//
//  ContentModel.swift
//  LerningApp
//
//  Created by Brady Robshaw on 1/15/22.
//

import Foundation

class ContentModel: ObservableObject {
    
    // List of modules
    @Published var modules = [Module]()
    
    // Current Module
    @Published var currentModule: Module?
    var currentModuleIndex = 0
    
    // Current Lesson
    @Published var currentLesson: Lesson?
    var currentLessonIndex = 0
    
    // Corrent Question
    @Published var currentQuestion: Questions?
    var currentQuestionIndex = 0
    
    // Current Lesson explination
    @Published var codeText = NSAttributedString()
    var styleData: Data?
    
    // Current seleted content and test
    @Published var currentContentSelected:Int?
    @Published var currentTestSelected:Int?
    
    
    
    init() {
        
        // parse local included data
        getLocalData()
        
        // download remote data
        getRemoteData()
        
    }
    
    // MARK: - Data methods
    
    func getLocalData() {
        
        let jsonUrl = Bundle.main.url(forResource: "data", withExtension: "json")
        
        
        do {
            let jsonData = try Data(contentsOf: jsonUrl!)
            
            let jsonDecoder = JSONDecoder()
            let modules = try jsonDecoder.decode([Module].self, from: jsonData)
            
            self.modules = modules
        }
        catch {
            print("Colldn't parse local data")
        }
        
        
        //parse the stye data
        let styleUrl = Bundle.main.url(forResource: "style", withExtension: "html")
        
        do {
            let styleData = try Data(contentsOf: styleUrl!)
            
            self.styleData = styleData
        }
        catch {
            print("Couldn't parse style data")
        }
        
    }
    
    func getRemoteData() {
        
        // String path
        let urlString = "https://bradyr88.github.io/learningapp-data/data2.json"
        
        // Create a url object
        let url = URL(string: urlString)
        
        guard url != nil else {
            //Couldn't create url
            return
        }
        
        // Create a URLRequest object
        let request = URLRequest(url: url!)
        
        // get the session and kick off the task
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            // check if there is an error
            guard error == nil else {
                return
            }
            do {
                //create json decoder
                let jsonDecoder = JSONDecoder()
                //decode
                let modules = try jsonDecoder.decode([Module].self, from: data!)
                
                DispatchQueue.main.async {
                    self.modules += modules
                }
                
            }
            catch {
                // Couldn't parse the json
            }
            
        }
        
        // kick of the data task
        dataTask.resume()
    }
    
    // MARK: - Module navigation methods
    
    func beginModule(_ moduleid:Int) {
        
        // Find the index for this module id
        for index in 0..<modules.count {
            
            if modules[index].id == moduleid {
            
                // Found the matching module
                currentModuleIndex = index
                break
            }
        }
        
        // Set the current module
        currentModule = modules[currentModuleIndex]
    }
    
    // MARK: - Lesson navigation merthods
    
    func beginLesson(_ lessonIndex: Int) {
        
        if lessonIndex < currentModule!.content.lessons.count {
            currentLessonIndex = lessonIndex
        }
        else {
            currentLessonIndex = 0
        }
        currentLesson = currentModule!.content.lessons[currentLessonIndex]
        codeText = addStyling(currentLesson!.explanation)
    }
    
    func nextLesson() {
        //advance the lesson index
        currentLessonIndex += 1
        
        //check that it is within range
        if currentLessonIndex < currentModule!.content.lessons.count {
            currentLesson = currentModule!.content.lessons[currentLessonIndex]
            codeText = addStyling(currentLesson!.explanation)
        }
        else {
            // reset the state of the lesson
            currentLessonIndex = 0
            currentLesson = nil
        }
    }
    
    func hasNextLesson() -> Bool {
        return currentLessonIndex + 1 < currentModule!.content.lessons.count
    }
    
    // set the cerint moddule and set the question
    func beginTest(_ moduleId:Int) {
        
        // Set the current module
        beginModule(moduleId)
        
        // Set the current question index
        currentQuestionIndex = 0
        
        // If there are questions, set the current question to the first one
        if currentModule?.test.questions.count ?? 0  > 0 {
            currentQuestion = currentModule!.test.questions[currentQuestionIndex]
            
            // Set the question content
            codeText = addStyling(currentQuestion!.content)
        }
    }
    
    func nextQuestion() {
        //advance the question index
        currentQuestionIndex += 1
        
        //check that it is within range
        if currentQuestionIndex < currentModule!.test.questions.count {
            currentQuestion = currentModule!.test.questions[currentQuestionIndex]
            codeText = addStyling(currentQuestion!.content)
        }
        else {
            // reset the state of the test
            currentQuestionIndex = 0
            currentQuestion = nil
        }
    }
    
    // MARK: - code Styling
    private func addStyling(_ htmlString: String) -> NSAttributedString {
        
        var resultString = NSAttributedString()
        var data = Data()
        
        // add the styling data
        if styleData != nil {
            data.append(styleData!)
        }
        
        // add the html data
        data.append(Data(htmlString.utf8))
        
        //Convert to Attributed String
        do {
            let attributedString = try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
            
                resultString = attributedString
        }
        catch {
            print("Could't turn html into attributed string")
        }
        
        return resultString
    }
}

import Foundation
import Combine
#if canImport(WidgetKit)
import WidgetKit
#endif

func kL(_ k: String) -> String {
#if DEBUG && targetEnvironment(simulator) && !WIDGET_EXTENSION && !QA_TESTS
 if ScreenshotLaunch.current == .cityRoute, let bundle = ScreenshotLaunch.englishBundle {
  return NSLocalizedString(k, bundle: bundle, comment: "")
 }
#endif
 return NSLocalizedString(k, comment: "")
}
let kG = "group.org.littlelantern.safepaths.b73d"
struct bS: Codable, Identifiable { let id: String; let title: String; let art: String; let steps: [bT] }
struct bT: Codable { let prompt: String; let choices: [String]; let right: Int; let why: String; let signal: Int }
struct bQ: Codable, Identifiable { let id: String; let art: String; let prompt: String; let choices: [String]; let right: Int; let why: String }
struct bC: Codable, Identifiable { let id: String; let name: String; let season: String; let scenes: [bS]; let quiz: [bQ] }
struct bR: Codable { var tries=0; var right=0; var visits=0; var last: Date? }
struct bP: Codable {
 var done: Set<String> = []; var exams: Set<String> = []; var awards: [String:Date] = [:]
 var ledger: [String:bR] = [:]; var days: Set<String> = []; var daily: Set<String> = []
 var reminder=false; var hour=17; var minute=0
}
enum bV {
 static let cities: [bC] = {
  guard let u=Bundle(for:bK.self).url(forResource:"Townbook",withExtension:"json"), let d=try? Data(contentsOf:u), let c=try? JSONDecoder().decode([bC].self,from:d) else { return [] }; return c
 }()
 static func day(_ d:Date=Date())->String { let f=DateFormatter(); f.locale=Locale(identifier:"en_US_POSIX");f.dateFormat="yyyy-MM-dd";return f.string(from:d) }
 static func daily(_ d:Date=Date())->bS? {
  let a=cities.flatMap(\.scenes); guard !a.isEmpty else{return nil}
  let c=Calendar(identifier:.gregorian);let n=c.dateComponents([.day],from:c.startOfDay(for:Date(timeIntervalSince1970:0)),to:c.startOfDay(for:d)).day ?? 0
  return a[((n % a.count)+a.count)%a.count]
 }
 static func load(_ store:UserDefaults = UserDefaults(suiteName:kG) ?? .standard)->bP {
  guard let d=store.data(forKey:"path.v1"), let r=try? JSONDecoder().decode(bP.self,from:d) else{return bP()};return r
 }
}
@MainActor final class bK: ObservableObject {
 @Published var p: bP; @Published var diskIssue=false
 private let store:UserDefaults?
 init(store:UserDefaults = UserDefaults(suiteName:kG) ?? .standard) {self.store=store;p=bV.load(store)}
#if DEBUG && targetEnvironment(simulator) && !WIDGET_EXTENSION && !QA_TESTS
 fileprivate init(screenshot: ScreenshotLaunch) {
  store = nil
  p = bP()
  screenshot.seedProgress(in: self)
 }
#endif
 func save() {guard let store else{return};do {let d=try JSONEncoder().encode(p);store.set(d,forKey:"path.v1");WidgetCenter.shared.reloadAllTimelines()} catch { diskIssue=true }}
 func answer(_ id:String,_ good:Bool) {var r=p.ledger[id] ?? bR();r.tries += 1;if good{r.right += 1};r.last=Date();p.ledger[id]=r;save()}
 func finish(_ s:bS) {p.done.insert(s.id);var r=p.ledger[s.id] ?? bR();r.visits += 1;r.last=Date();p.ledger[s.id]=r;p.days.insert(bV.day());if bV.daily()?.id==s.id{p.daily.insert(bV.day())};award();save()}
 func exam(_ c:bC) {p.exams.insert(c.id);p.days.insert(bV.day());award();save()}
 func award() {for c in bV.cities where c.scenes.allSatisfy({p.done.contains($0.id)}) && p.exams.contains(c.id) {if p.awards[c.id]==nil{p.awards[c.id]=Date()}}}
 func unlocked(_ s:bS,_ c:bC)->Bool {guard let i=c.scenes.firstIndex(where:{$0.id==s.id}) else{return false};return i==0 || p.done.contains(c.scenes[i-1].id)}
 func clear() {p=bP();save()}
}

#if DEBUG && targetEnvironment(simulator) && !WIDGET_EXTENSION && !QA_TESTS
enum ScreenshotLaunch: String, CaseIterable {
 // Declaration order is the zero-based App Store screenshot index.
 case cityRoute = "city-route"
 case streetPractice = "street-practice"
 case lessonComplete = "lesson-complete"
 case signsDirectory = "signs-directory"
 case signQuiz = "sign-quiz"
 case signCheckComplete = "sign-check-complete"
 case certificates

 static let current: ScreenshotLaunch? = {
  let process = ProcessInfo.processInfo
  let arguments = process.arguments
  func value(after flag: String) -> String? {
   guard let index = arguments.firstIndex(of: flag), arguments.indices.contains(index + 1) else {
    return nil
   }
   return arguments[index + 1]
  }
  if arguments.contains("-ReviewScreen") {
   return value(after: "-ReviewScreen").flatMap(ScreenshotLaunch.init(rawValue:))
  }
  let environment = process.environment
  guard arguments.contains("-AppStoreScreenshots") || environment["APPSTORE_SCREENSHOTS"] == "1",
        let indexValue = value(after: "-AppStoreScreenshotScreen") ?? environment["APPSTORE_SCREENSHOT_SCREEN"],
        let index = Int(indexValue), allCases.indices.contains(index) else { return nil }
  return allCases[index]
 }()

 static let englishBundle = Bundle.main.path(forResource: "en", ofType: "lproj").flatMap(Bundle.init(path:))

 var sunnyTown: bC? { bV.cities.first { $0.id == "meadow" } }
 var leafLane: bC? { bV.cities.first { $0.id == "amber" } }
 var waitingLight: bS? { sunnyTown?.scenes.first { $0.id == "meadow.0" } }

 @MainActor func makeProgressStore() -> bK { bK(screenshot: self) }

 @MainActor fileprivate func seedProgress(in store: bK) {
  func finishLesson(_ lesson: bS) {
   for _ in lesson.steps { store.answer(lesson.id, true) }
   store.finish(lesson)
  }

  func earnCertificate(for city: bC) {
   for lesson in city.scenes { finishLesson(lesson) }
   for _ in city.quiz { store.answer("quiz." + city.id, true) }
   store.exam(city)
  }

  switch self {
  case .cityRoute, .streetPractice, .signsDirectory, .signQuiz:
   break
  case .lessonComplete:
   if let waitingLight { finishLesson(waitingLight) }
  case .signCheckComplete:
   if let sunnyTown { earnCertificate(for: sunnyTown) }
  case .certificates:
   if let sunnyTown { earnCertificate(for: sunnyTown) }
   if let leafLane { earnCertificate(for: leafLane) }
  }
 }
}
#endif

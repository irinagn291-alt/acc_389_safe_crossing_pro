import SwiftUI
import UserNotifications

@main struct hN:App {
#if DEBUG && targetEnvironment(simulator)
 @StateObject private var z: bK

 init() {
  if let screenshot = ScreenshotLaunch.current {
   UIView.setAnimationsEnabled(false)
   _z = StateObject(wrappedValue: screenshot.makeProgressStore())
  } else {
   _z = StateObject(wrappedValue: bK())
  }
 }

 var body: some Scene {
  WindowGroup {
   if let screenshot = ScreenshotLaunch.current {
    hHome(screenshot: screenshot)
     .transaction {
      $0.animation = nil
      $0.disablesAnimations = true
     }
     .environmentObject(z)
     .preferredColorScheme(.light)
   } else {
    hHome().environmentObject(z).preferredColorScheme(.light)
   }
  }
 }
#else
 @StateObject private var z=bK()
 var body:some Scene {WindowGroup{hHome().environmentObject(z).preferredColorScheme(.light)}}
#endif
}
struct hHome:View {
 @EnvironmentObject var z:bK
 @State private var tab=0;@State private var city=0;@State private var scene:bS?;@State private var quiz:bC?;@State private var parents=false
 @Environment(\.scenePhase) var phase

#if DEBUG && targetEnvironment(simulator)
 @State private var showsInitialResult = false

 init() {}

 init(screenshot: ScreenshotLaunch) {
  switch screenshot {
  case .cityRoute:
   break
  case .streetPractice, .lessonComplete:
   _scene = State(initialValue: screenshot.waitingLight)
   _showsInitialResult = State(initialValue: screenshot == .lessonComplete)
  case .signsDirectory, .signQuiz:
   _tab = State(initialValue: 1)
   if screenshot == .signQuiz {
    _quiz = State(initialValue: screenshot.leafLane)
   }
  case .signCheckComplete:
   _quiz = State(initialValue: screenshot.sunnyTown)
   _showsInitialResult = State(initialValue: true)
  case .certificates:
   _tab = State(initialValue: 2)
  }
 }
#endif

 private var onInitialSheetDismiss: (() -> Void)? {
#if DEBUG && targetEnvironment(simulator)
  if showsInitialResult { return { showsInitialResult = false } }
#endif
  return nil
 }

 var body:some View {TabView(selection:$tab) {
 NavigationStack {ScrollView {VStack(alignment:.leading,spacing:23) {
 HStack(alignment:.top){VStack(alignment:.leading,spacing:6){Text(kL("journey_label")).font(.caption.bold()).tracking(2).foregroundStyle(vG);Text(kL("hero")).font(.system(size:36,weight:.heavy,design:.rounded)).fixedSize(horizontal:false,vertical:true)};Spacer();VStack{Image(systemName:"rosette").font(.title2);Text("\(z.p.awards.count) / 4").font(.caption.bold())}.padding(13).background(vY,in:RoundedRectangle(cornerRadius:20)).accessibilityLabel(kL("certificates")+" \(z.p.awards.count)")}
 if let d=bV.daily() {Button {scene=d} label:{HStack(spacing:15){Image(systemName:z.p.daily.contains(bV.day()) ? "checkmark.circle.fill":"sun.max.fill").font(.title).foregroundStyle(vG);VStack(alignment:.leading,spacing:5){Text(kL("daily_task")).font(.caption.bold()).foregroundStyle(vG);Text(kL(d.title)).font(.headline);Text(kL(z.p.daily.contains(bV.day()) ? "daily_done":"daily_hint")).font(.caption).foregroundStyle(.secondary)};Spacer();Image(systemName:"arrow.up.right")}.panel()}.buttonStyle(.plain).accessibilityIdentifier("dailyTask")}
 ScrollView(.horizontal,showsIndicators:false){HStack(spacing:10){ForEach(Array(bV.cities.enumerated()),id:\.element.id){i,c in Button {city=i}label:{VStack(spacing:4){Text(kL(c.season)).font(.caption);Text(kL(c.name)).font(.subheadline.bold())}.padding(.horizontal,18).padding(.vertical,12).foregroundStyle(city==i ? .white:vA).background(city==i ? vA:.white,in:RoundedRectangle(cornerRadius:18))}.buttonStyle(.plain).accessibilityIdentifier("city\(i)")}}}
 if bV.cities.indices.contains(city) {let c=bV.cities[city]
 ZStack(alignment:.bottomLeading){nTown(season:city).frame(height:235);VStack(alignment:.leading,spacing:4){Text(kL(c.name)).font(.title2.bold());Text("\(c.scenes.filter{z.p.done.contains($0.id)}.count) / 3 "+kL("lessons_done")).font(.subheadline)}.padding(15).background(.regularMaterial,in:RoundedRectangle(cornerRadius:18)).padding(15)}
 HStack{Text(kL("your_route")).font(.title2.bold());Spacer();Text("0\(city+1)").font(.system(.title2,design:.monospaced,weight:.bold)).foregroundStyle(vG)}
 ForEach(Array(c.scenes.enumerated()),id:\.element.id){i,s in let open=z.unlocked(s,c);Button {scene=s} label:{HStack(spacing:15){ZStack{Circle().fill(z.p.done.contains(s.id) ? vG:vY).frame(width:45,height:45);if z.p.done.contains(s.id){Image(systemName:"checkmark").foregroundStyle(.white).bold()}else{Text("\(i+1)").font(.title3.bold())}};VStack(alignment:.leading,spacing:5){Text(kL(s.title)).font(.headline);Text(kL(open ? "three_steps":"finish_previous")).font(.caption).foregroundStyle(.secondary)};Spacer();Image(systemName:open ? "arrow.right":"lock.fill")}.panel().opacity(open ? 1:0.55)}.buttonStyle(.plain).disabled(!open).accessibilityIdentifier("lesson\(i)")}
 Button {quiz=c}label:{HStack{Image(systemName:"signpost.right.fill").font(.title2);VStack(alignment:.leading,spacing:5){Text(kL("city_check")).font(.headline);Text(kL("quiz_description")).font(.caption)};Spacer();Image(systemName:z.p.exams.contains(c.id) ? "checkmark.seal.fill":"arrow.right")}.panel(vY)}.buttonStyle(.plain).accessibilityIdentifier("cityQuiz")
 }
 Text(kL("adult_rule")).font(.footnote).foregroundStyle(.secondary)
 }.padding(22).frame(maxWidth:780).frame(maxWidth:.infinity)}.background(vB).navigationTitle("Safe Crossing").navigationBarTitleDisplayMode(.inline).toolbar{ToolbarItem(placement:.topBarTrailing){Button{parents=true}label:{Image(systemName:"person.crop.circle")}.accessibilityLabel(kL("parents")).accessibilityIdentifier("parents")}}}.tabItem{Label(kL("map"),systemImage:"map.fill")}.tag(0)
 NavigationStack{ScrollView{VStack(alignment:.leading,spacing:22){Text(kL("signs_intro")).font(.title3);ForEach(bV.cities){c in Button{quiz=c}label:{HStack{nSign(kind:c.quiz[0].art,size:64);VStack(alignment:.leading,spacing:6){Text(kL(c.name)).font(.title3.bold());Text(kL("four_questions")).font(.subheadline)};Spacer();Image(systemName:"arrow.right")}.panel()}.buttonStyle(.plain).accessibilityIdentifier("practice."+c.id)};Text(kL("sign_variations")).font(.footnote).foregroundStyle(.secondary)}.padding(22).frame(maxWidth:780).frame(maxWidth:.infinity)}.background(vB).navigationTitle(kL("signs"))}.tabItem{Label(kL("signs"),systemImage:"signpost.right.fill")}.tag(1)
 NavigationStack{ScrollView{VStack(spacing:20){Text(kL("awards_intro")).font(.title3);ForEach(bV.cities){c in VStack(spacing:12){Image(systemName:z.p.awards[c.id] != nil ? "rosette":"seal").font(.system(size:48)).foregroundStyle(z.p.awards[c.id] != nil ? vG:vA.opacity(0.35));Text(kL(c.name)).font(.title2.bold());if let date=z.p.awards[c.id]{Text(kL("certificate_earned")).font(.headline);Text(date,style:.date).font(.subheadline);Text(kL("certificate_text")).font(.footnote).multilineTextAlignment(.center)}else{Text(kL("certificate_how")).font(.subheadline).foregroundStyle(.secondary)}}.frame(maxWidth:.infinity).panel(z.p.awards[c.id] != nil ? vY.opacity(0.25):.white)}}.padding(22).frame(maxWidth:720).frame(maxWidth:.infinity)}.background(vB).navigationTitle(kL("certificates"))}.tabItem{Label(kL("certificates"),systemImage:"rosette")}.tag(2)
 }.tint(vG).foregroundStyle(vA)
  .sheet(item: $scene, onDismiss: onInitialSheetDismiss) { lesson in
#if DEBUG && targetEnvironment(simulator)
   pRun(s: lesson, showingResult: showsInitialResult).environmentObject(z)
#else
   pRun(s: lesson).environmentObject(z)
#endif
  }
  .sheet(item: $quiz, onDismiss: onInitialSheetDismiss) { city in
#if DEBUG && targetEnvironment(simulator)
   pQuiz(c: city, showingResult: showsInitialResult).environmentObject(z)
#else
   pQuiz(c: city).environmentObject(z)
#endif
  }
  .sheet(isPresented:$parents){hGate().environmentObject(z)}.onOpenURL{u in if u.host=="daily"{scene=bV.daily()}else{tab=0}}.onChange(of:phase){_,v in if v == .active {z.objectWillChange.send()}}.alert(kL("save_problem"),isPresented:$z.diskIssue){Button(kL("close"),role:.cancel){}}
 }
}
struct hGate:View {
 @Environment(\.dismiss) var dismiss
 @Environment(\.scenePhase) var phase
 @State private var a=Int.random(in:21...49);@State private var b=Int.random(in:12...39);@State private var answer="";@State private var passed=false;@State private var failed=false
 var body:some View {NavigationStack{Group{if passed {hParent()}else{ScrollView{VStack(spacing:25){Image(systemName:"lock.shield.fill").font(.system(size:64)).foregroundStyle(vG);Text(kL("grownups")).font(.system(.largeTitle,design:.rounded,weight:.bold));Text(kL("gate_note")).multilineTextAlignment(.center);Text("\(a) + \(b) = ?").font(.system(.largeTitle,design:.rounded,weight:.bold)).accessibilityIdentifier("gateQuestion");TextField(kL("answer"),text:$answer).keyboardType(.numberPad).textFieldStyle(.roundedBorder).font(.title2).accessibilityIdentifier("gateAnswer");Button(kL("open_parent")){if Int(answer)==a+b{passed=true}else{answer="";failed=true}}.mainKey().accessibilityIdentifier("gateSubmit");if failed {Text(kL("gate_retry")).foregroundStyle(.red)}}.padding(28).frame(maxWidth:520).frame(maxWidth:.infinity)}}}.background(vB).toolbar{ToolbarItem(placement:.topBarTrailing){Button(kL("close")){dismiss()}}}.navigationTitle(kL("parents")).navigationBarTitleDisplayMode(.inline).onChange(of:phase){_,p in if p == .background {passed=false;answer="";a=Int.random(in:21...49);b=Int.random(in:12...39)}}}}
}
struct hParent:View {
 @EnvironmentObject var z:bK
 @State private var status:UNAuthorizationStatus = .notDetermined;@State private var time=Date();@State private var reset=false;@State private var notice=""
 var body:some View {Form {
 Section(kL("progress")){LabeledContent(kL("completed_lessons"),value:"\(z.p.done.count) / 12");LabeledContent(kL("certificates"),value:"\(z.p.awards.count) / 4");LabeledContent(kL("learning_days"),value:"\(z.p.days.count)");let t=z.p.ledger.values.reduce(0){$0+$1.tries};let r=z.p.ledger.values.reduce(0){$0+$1.right};LabeledContent(kL("careful_choices"),value:t==0 ? "—":"\(r) / \(t)");Text(kL("progress_note")).font(.footnote)}
 Section(kL("report")){ForEach(bV.cities){c in VStack(alignment:.leading,spacing:9){Text(kL(c.name)).font(.headline);ProgressView(value:Double(c.scenes.filter{z.p.done.contains($0.id)}.count+(z.p.exams.contains(c.id) ? 1:0)),total:4).tint(vG);ForEach(c.scenes){s in HStack{VStack(alignment:.leading){Text(kL(s.title));if let last=z.p.ledger[s.id]?.last{Text(last,style:.date).font(.caption).foregroundStyle(.secondary)}};Spacer();Text("\(z.p.ledger[s.id]?.visits ?? 0) ×").foregroundStyle(.secondary)}}}};let weak=bV.cities.flatMap(\.scenes).filter{let r=z.p.ledger[$0.id] ?? bR();return r.tries>r.right};if !weak.isEmpty{Text(kL("review_together")).font(.headline);ForEach(weak){s in Text(kL(s.title)).font(.subheadline)}}}
 Section(kL("reminders")){Text(kL("reminder_value"));DatePicker(kL("lesson_time"),selection:$time,displayedComponents:.hourAndMinute).onChange(of:time){_,d in let c=Calendar.current.dateComponents([.hour,.minute],from:d);z.p.hour=c.hour ?? 17;z.p.minute=c.minute ?? 0;z.save();if z.p.reminder{Task{await schedule()}}};Toggle(kL("daily_reminder"),isOn:Binding(get:{z.p.reminder},set:{on in Task{if on{await enable()}else{removeReminder();z.p.reminder=false;z.save()}}})).accessibilityIdentifier("reminderToggle");if status == .denied {Text(kL("notification_denied")).font(.footnote);Button(kL("open_settings")){if let u=URL(string:UIApplication.openSettingsURLString){UIApplication.shared.open(u)}}};if !notice.isEmpty{Text(notice).font(.footnote)}}
 Section(kL("widget_title")){NavigationLink(kL("widget_title")){wGallery().environmentObject(z)}.accessibilityIdentifier("widgetGallery");Text(kL("widget_detail")).font(.footnote)}
 Section(kL("family_guide")){Text(kL("family_detail"));Text(kL("certificate_limit")).font(.footnote);Text(kL("safety_source")).font(.footnote).foregroundStyle(.secondary)}
 Section(kL("privacy")){Text(kL("privacy_detail"));Text(kL("widget_detail")).font(.footnote);Text(kL("notification_detail")).font(.footnote);Button(kL("reset"),role:.destructive){reset=true}.accessibilityIdentifier("resetProgress")}
 }.task {
  let reminderTime = Calendar.current.date(bySettingHour: z.p.hour, minute: z.p.minute, second: 0, of: Date())
  time = reminderTime ?? Date()
#if DEBUG && targetEnvironment(simulator)
  guard ScreenshotLaunch.current == nil else { return }
#endif
  status = await UNUserNotificationCenter.current().notificationSettings().authorizationStatus
  if status == .denied && z.p.reminder {
   removeReminder()
   z.p.reminder = false
   z.save()
  }
 }.alert(kL("reset_title"),isPresented:$reset){Button(kL("reset"),role:.destructive){removeReminder();z.clear()};Button(kL("cancel"),role:.cancel){}}message:{Text(kL("reset_note"))}
 }
 func removeReminder() {
#if DEBUG && targetEnvironment(simulator)
  guard ScreenshotLaunch.current == nil else { return }
#endif
  UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers:["gentle.path"])
 }
 func enable() async {
#if DEBUG && targetEnvironment(simulator)
  guard ScreenshotLaunch.current == nil else { return }
#endif
  do{let ok=try await UNUserNotificationCenter.current().requestAuthorization(options:[.alert,.sound]);status=await UNUserNotificationCenter.current().notificationSettings().authorizationStatus;if ok{await schedule()}else{z.p.reminder=false;z.save()}}catch{notice=kL("notification_error");z.p.reminder=false;z.save()}}
 func schedule() async {
#if DEBUG && targetEnvironment(simulator)
  guard ScreenshotLaunch.current == nil else { return }
#endif
  let c=UNMutableNotificationContent();c.title="Safe Crossing";c.body=kL("reminder_body");c.sound = .default;var d=DateComponents();d.hour=z.p.hour;d.minute=z.p.minute;let r=UNNotificationRequest(identifier:"gentle.path",content:c,trigger:UNCalendarNotificationTrigger(dateMatching:d,repeats:true));do{try await UNUserNotificationCenter.current().add(r);z.p.reminder=true;z.save();notice=kL("reminder_saved")}catch{z.p.reminder=false;z.save();notice=kL("notification_error")}}
}

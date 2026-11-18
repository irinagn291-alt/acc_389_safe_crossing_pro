import SwiftUI

struct pRun: View {
 @EnvironmentObject var z:bK; @Environment(\.dismiss) var dismiss
 let s:bS; @State private var step=0; @State private var feedback=false; @State private var good=false; @State private var completed=false
#if DEBUG && targetEnvironment(simulator)
 private let startsAtScreenshotResult: Bool
 private static let screenshotResultID = "screenshotLessonResult"

 init(s: bS, showingResult: Bool) {
  self.s = s
  _completed = State(initialValue: showingResult)
  startsAtScreenshotResult = showingResult && ScreenshotLaunch.current == .lessonComplete
 }
#endif
 var body: some View {
  NavigationStack {
   lessonContent
    .background(vB)
    .toolbar {
     ToolbarItem(placement: .topBarTrailing) { Button(kL("close")) { dismiss() } }
    }
    .navigationBarTitleDisplayMode(.inline)
  }
 }

 @ViewBuilder private var lessonContent: some View {
#if DEBUG && targetEnvironment(simulator)
  if startsAtScreenshotResult {
   ScrollViewReader { proxy in
    lessonScrollView.task {
     // Align the card, leaving the footer below it in the normal scroll flow.
     proxy.scrollTo(Self.screenshotResultID, anchor: .bottom)
    }
   }
  } else {
   lessonScrollView
  }
#else
  lessonScrollView
#endif
 }

 private var lessonScrollView: some View {ScrollView {VStack(alignment:.leading,spacing:22) {
  Text(kL("practice_label")).font(.caption.bold()).tracking(2).foregroundStyle(vG)
  Text(kL(s.title)).font(.system(.largeTitle,design:.rounded,weight:.heavy))
  nRoad(signal:completed ? 1:s.steps[step].signal,art:s.art,passed:completed)
  if completed {
#if DEBUG && targetEnvironment(simulator)
   if startsAtScreenshotResult {
    resultCard.id(Self.screenshotResultID)
   } else {
    resultCard
   }
#else
   resultCard
#endif
  }
  else {
   HStack{Text(kL("step")+" \(step+1) / \(s.steps.count)").font(.subheadline.bold());Spacer();ProgressView(value:Double(step),total:Double(s.steps.count)).tint(vG).frame(width:100)}
   Text(kL(s.steps[step].prompt)).font(.system(.title2,design:.rounded,weight:.bold)).fixedSize(horizontal:false,vertical:true).accessibilityIdentifier("scenePrompt")
   ForEach(Array(s.steps[step].choices.enumerated()),id:\.offset){i,k in Button {choose(i)} label:{HStack{Text(kL(k)).multilineTextAlignment(.leading);Spacer();Image(systemName:"arrow.right.circle.fill")}.padding(17).frame(maxWidth:.infinity,minHeight:56).background(.white,in:RoundedRectangle(cornerRadius:17))}.buttonStyle(.plain).disabled(feedback && good).accessibilityIdentifier("choice\(i)")}
   if feedback {VStack(alignment:.leading,spacing:12){Label(kL(good ? "good_choice":"try_again"),systemImage:good ? "checkmark.circle.fill":"heart.fill").font(.headline).foregroundStyle(good ? vG:vA);Text(kL(s.steps[step].why)).fixedSize(horizontal:false,vertical:true);if good {Button(kL("continue")){next()}.mainKey().accessibilityIdentifier("nextStep")}}.panel(good ? Color.green.opacity(0.09):vY.opacity(0.20)).accessibilityIdentifier("feedback")}
  }
  Text(kL("adult_rule")).font(.footnote).foregroundStyle(.secondary)
 }.padding(22).frame(maxWidth:720).frame(maxWidth:.infinity)}}

 private var resultCard: some View {
  VStack(spacing: 16) {
   Image(systemName: "checkmark.seal.fill").font(.system(size: 50)).foregroundStyle(vG)
   Text(kL("well_done")).font(.title.bold())
   Text(kL("practice_with_adult")).multilineTextAlignment(.center)
   Button(kL("back_map")) { dismiss() }
    .mainKey()
    .accessibilityIdentifier("finishLesson")
  }.panel()
 }
 func choose(_ i:Int) {good=i==s.steps[step].right;feedback=true;z.answer(s.id,good);if !good{UIAccessibility.post(notification:.announcement,argument:kL("try_again"))}}
 func next() {if step+1==s.steps.count{z.finish(s);completed=true}else{step += 1;feedback=false;good=false}}
}
struct pQuiz: View {
 @EnvironmentObject var z:bK; @Environment(\.dismiss) var dismiss
 let c:bC; @State private var index=0;@State private var feedback=false;@State private var good=false;@State private var done=false
#if DEBUG && targetEnvironment(simulator)
 init(c: bC, showingResult: Bool) {
  self.c = c
  _done = State(initialValue: showingResult)
 }
#endif
 var q:bQ{c.quiz[index]}
 var body:some View {NavigationStack {ScrollView {VStack(spacing:22){
 Text(kL("sign_quiz")).font(.caption.bold()).tracking(2).foregroundStyle(vG)
 Text(kL(c.name)).font(.system(.largeTitle,design:.rounded,weight:.heavy))
 if done {Image(systemName:"rosette").font(.system(size:86)).foregroundStyle(vG);Text(kL("quiz_complete")).font(.title.bold());Text(kL(z.p.awards[c.id] != nil ? "earned_note":"quiz_practice_note")).multilineTextAlignment(.center);Button(kL("back_map")){dismiss()}.mainKey().accessibilityIdentifier("finishQuiz")}
 else {ProgressView(value:Double(index),total:Double(c.quiz.count)).tint(vG);Text("\(index+1) / \(c.quiz.count)").font(.caption.bold());nSign(kind:q.art,size:126).padding(12);Text(kL(q.prompt)).font(.system(.title2,design:.rounded,weight:.bold)).multilineTextAlignment(.center)
 ForEach(Array(q.choices.enumerated()),id:\.offset){i,k in Button{good=i==q.right;feedback=true;z.answer("quiz."+c.id,good)}label:{Text(kL(k)).font(.headline).frame(maxWidth:.infinity,minHeight:58).padding(.horizontal,12).background(.white,in:RoundedRectangle(cornerRadius:17))}.buttonStyle(.plain).disabled(feedback && good).accessibilityIdentifier("quizChoice\(i)")}
 if feedback {VStack(spacing:12){Text(kL(good ? "good_choice":"try_again")).font(.headline).foregroundStyle(good ? vG:vA);Text(kL(q.why));if good{Button(kL("continue")){if index+1==c.quiz.count{z.exam(c);done=true}else{index += 1;feedback=false;good=false}}.mainKey().accessibilityIdentifier("nextQuiz")}}.panel(vY.opacity(0.18))}}
 Text(kL("sign_variations")).font(.footnote).foregroundStyle(.secondary).multilineTextAlignment(.center)
 }.padding(24).frame(maxWidth:640).frame(maxWidth:.infinity)}.background(vB).toolbar{ToolbarItem(placement:.topBarTrailing){Button(kL("close")){dismiss()}}}}}
}

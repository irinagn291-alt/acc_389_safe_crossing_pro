import WidgetKit
import SwiftUI
struct wE:TimelineEntry {let date:Date;let p:bP}
struct wP:TimelineProvider {
 func placeholder(in context:Context)->wE {wE(date:Date(),p:bP())}
 func getSnapshot(in context:Context,completion:@escaping(wE)->Void){completion(wE(date:Date(),p:bV.load()))}
 func getTimeline(in context:Context,completion:@escaping(Timeline<wE>)->Void){let d=Date();let next=Calendar.current.date(byAdding:.day,value:1,to:Calendar.current.startOfDay(for:d)) ?? d.addingTimeInterval(86400);completion(Timeline(entries:[wE(date:d,p:bV.load()),wE(date:next,p:bV.load())],policy:.after(next)))}
}
struct wFace:View {
 @Environment(\.widgetFamily) var systemFamily
 var sizeOverride:WidgetFamily? = nil
 var family:WidgetFamily{sizeOverride ?? systemFamily}
 let e:wE
 var ready:Bool{e.p.daily.contains(bV.day(e.date))}
 var body:some View {Group{switch family {
 case .accessoryCircular: ZStack{AccessoryWidgetBackground();VStack(spacing:2){Image(systemName:ready ? "checkmark.circle.fill":"figure.walk");Text(ready ? "✓":"…").font(.caption)}}.accessibilityLabel(kL(ready ? "daily_done":"daily_task"))
 case .accessoryInline:Label(kL(ready ? "daily_done":"daily_task"),systemImage:ready ? "checkmark.circle":"figure.walk")
 case .accessoryRectangular:VStack(alignment:.leading){Label("Safe Crossing",systemImage:"figure.walk").font(.headline);Text(kL(ready ? "daily_done":"daily_task")).font(.caption)}
 case .systemSmall:VStack(alignment:.leading,spacing:9){Image(systemName:"rosette").font(.title).foregroundStyle(vG);Text("\(e.p.awards.count) / 4").font(.system(size:34,weight:.heavy,design:.rounded));Text(kL("certificates")).font(.caption.bold());Spacer(minLength:0);Text("Safe Crossing").font(.caption2).foregroundStyle(.secondary)}.frame(maxWidth:.infinity,alignment:.leading)
 case .systemLarge: VStack(alignment:.leading,spacing:10){HStack{Text(kL("your_route")).font(.headline);Spacer();Label("\(e.p.awards.count)",systemImage:"rosette")};nTown(season:Calendar.current.component(.month,from:e.date)%4).frame(height:94);ForEach(bV.cities){c in HStack{Text(kL(c.name)).font(.caption);Spacer();ForEach(c.scenes){s in Image(systemName:e.p.done.contains(s.id) ? "checkmark.circle.fill":"circle").font(.caption).foregroundStyle(vG)};Image(systemName:e.p.awards[c.id] != nil ? "rosette":"seal").font(.caption)}};Divider();Text(kL("completed_lessons")+": \(e.p.done.count) / 12 · "+kL("learning_days")+": \(e.p.days.count)").font(.caption2);Text(kL(ready ? "daily_done":"daily_task")).font(.caption.bold()).foregroundStyle(vG)}
 default:HStack(spacing:16){Image(systemName:ready ? "checkmark.seal.fill":"sun.max.fill").font(.largeTitle).foregroundStyle(vG);VStack(alignment:.leading,spacing:9){Text(kL("daily_task")).font(.caption.bold()).foregroundStyle(vG);Text(kL(bV.daily(e.date)?.title ?? "daily_hint")).font(.headline);let c=bV.cities.first{c in c.scenes.contains{ $0.id==bV.daily(e.date)?.id }};if let c{ProgressView(value:Double(c.scenes.filter{e.p.done.contains($0.id)}.count),total:3).tint(vG)};Text(kL(ready ? "daily_done":"daily_hint")).font(.caption2).foregroundStyle(.secondary)}}
 }}.containerBackground(vB,for:.widget).widgetURL(URL(string:"safecrossing://daily"))}
}
#if WIDGET_EXTENSION
@main
#endif
struct wNest:Widget {let kind="org.littlelantern.safepaths.daily";var body:some WidgetConfiguration{StaticConfiguration(kind:kind,provider:wP()){wFace(e:$0)}.configurationDisplayName(kL("widget_title")).description(kL("widget_description")).supportedFamilies([.systemSmall,.systemMedium,.systemLarge,.accessoryCircular,.accessoryRectangular,.accessoryInline])}}
#if !WIDGET_EXTENSION
struct wGallery:View {
 @EnvironmentObject var z:bK
 var body:some View {ScrollView {VStack(spacing:22){Text(kL("widget_description")).font(.subheadline);wFace(sizeOverride:.systemSmall,e:wE(date:Date(),p:z.p)).padding(16).frame(width:170,height:170).background(vB,in:RoundedRectangle(cornerRadius:24));wFace(sizeOverride:.systemMedium,e:wE(date:Date(),p:z.p)).padding(16).frame(maxWidth:360,minHeight:170).background(vB,in:RoundedRectangle(cornerRadius:24));wFace(sizeOverride:.systemLarge,e:wE(date:Date(),p:z.p)).padding(16).frame(maxWidth:360,minHeight:370).background(vB,in:RoundedRectangle(cornerRadius:24));wFace(sizeOverride:.accessoryRectangular,e:wE(date:Date(),p:z.p)).padding(16).frame(maxWidth:360).background(vB,in:RoundedRectangle(cornerRadius:24))}.padding(24).frame(maxWidth:.infinity)}.navigationTitle(kL("widget_title")).navigationBarTitleDisplayMode(.inline)}
}
#endif

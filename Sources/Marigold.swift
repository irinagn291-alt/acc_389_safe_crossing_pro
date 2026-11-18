import SwiftUI

let vY=Color(red:1,green:0.832,blue:0),vA=Color(red:0.169,green:0.169,blue:0.169),vG=Color(red:0.32,green:0.47,blue:0.08),vB=Color(red:0.98,green:0.97,blue:0.93),vO=Color(red:1,green:0.55,blue:0.26)
extension View {
 func panel(_ fill:Color = .white)->some View {self.padding(20).background(fill,in:RoundedRectangle(cornerRadius:24)).overlay(RoundedRectangle(cornerRadius:24).stroke(vA.opacity(0.07),lineWidth:1))}
 func mainKey()->some View {self.font(.system(.headline,design:.rounded)).foregroundStyle(vA).frame(maxWidth:.infinity,minHeight:52).background(vY,in:RoundedRectangle(cornerRadius:17))}
}
struct nBird: View {
 var body:some View { ZStack {Ellipse().fill(vY).frame(width:63,height:56);Circle().fill(vY).frame(width:44,height:44).offset(x:13,y:-22);Circle().fill(vA).frame(width:5,height:5).offset(x:24,y:-24);UnevenRoundedRectangle(topLeadingRadius:0,bottomLeadingRadius:0,bottomTrailingRadius:4,topTrailingRadius:4).fill(vO).frame(width:17,height:11).rotationEffect(.degrees(10)).offset(x:41,y:-15);Ellipse().fill(Color(red:0.96,green:0.69,blue:0.02)).frame(width:26,height:20).rotationEffect(.degrees(-25)).offset(x:-8,y:6);HStack(spacing:15){Capsule().fill(vO).frame(width:5,height:18);Capsule().fill(vO).frame(width:5,height:18)}.offset(y:32)}.frame(width:100,height:100).accessibilityHidden(true)}
}
struct nSign:View {
 var kind:String;var size:CGFloat=100
 var body:some View {
 ZStack {switch kind {
 case "stop": PolygonN(n:8).fill(Color.red);PolygonN(n:8).stroke(.white,lineWidth:5).padding(5);Image(systemName:"hand.raised.fill").font(.system(size:size*0.43)).foregroundStyle(.white)
 case "crossing": RoundedRectangle(cornerRadius:8).fill(Color(red:0.12,green:0.36,blue:0.72));Image(systemName:"figure.walk").font(.system(size:size*0.48,weight:.bold)).foregroundStyle(.white); VStack{Spacer();HStack(spacing:5){ForEach(0..<4){_ in Rectangle().fill(.white).frame(width:size*0.11,height:7)}}}.padding(10)
 case "path": Circle().fill(Color(red:0.12,green:0.36,blue:0.72));Image(systemName:"figure.walk").font(.system(size:size*0.5,weight:.bold)).foregroundStyle(.white)
 case "school": PolygonN(n:3).fill(.red);PolygonN(n:3).fill(.white).padding(10);Image(systemName:"figure.2").font(.system(size:size*0.30,weight:.bold)).offset(y:7)
 case "red":RoundedRectangle(cornerRadius:15).fill(vA);Image(systemName:"hand.raised.fill").font(.system(size:size*0.45)).foregroundStyle(.red)
 default: RoundedRectangle(cornerRadius:15).fill(vA);Image(systemName:"figure.walk").font(.system(size:size*0.52,weight:.bold)).foregroundStyle(Color.green)
 }}.frame(width:size,height:size).accessibilityLabel(kL("sign_"+kind))
 }
}
struct PolygonN:Shape {var n:Int;func path(in r:CGRect)->Path{Path{p in for i in 0..<n{let a=Double(i)*2*Double.pi/Double(n)-Double.pi/2+(n==8 ? Double.pi/8:0);let pt=CGPoint(x:r.midX+cos(a)*r.width/2,y:r.midY+sin(a)*r.height/2);if i==0{p.move(to:pt)}else{p.addLine(to:pt)}};p.closeSubpath()}}}
struct nTown: View {
 var season:Int=0
 var body:some View {
 GeometryReader {g in
 ZStack {
  RoundedRectangle(cornerRadius:28).fill([Color(red:0.88,green:0.93,blue:0.76),Color(red:0.99,green:0.89,blue:0.72),Color(red:0.85,green:0.92,blue:0.96),Color(red:0.90,green:0.94,blue:0.80)][season%4])
  Canvas {ctx,s in
   var p=Path();p.move(to:CGPoint(x:-25,y:s.height*0.80));p.addCurve(to:CGPoint(x:s.width+30,y:s.height*0.24),control1:CGPoint(x:s.width*0.5,y:s.height*0.95),control2:CGPoint(x:s.width*0.32,y:-20));ctx.stroke(p,with:.color(vA),style:StrokeStyle(lineWidth:62,lineCap:.round));ctx.stroke(p,with:.color(.white.opacity(0.7)),style:StrokeStyle(lineWidth:3,dash:[10,12]))
   for (x,y) in [(0.1,0.15),(0.2,0.50),(0.87,0.7),(0.70,0.85),(0.9,0.12)] {let r=CGRect(x:s.width*x,y:s.height*y,width:25,height:34);ctx.fill(Path(roundedRect:r,cornerRadius:12),with:.color(season==1 ? vO:vG));ctx.fill(Path(CGRect(x:r.midX-2,y:r.maxY-4,width:4,height:12)),with:.color(vA))}
   for (x,y,w) in [(0.14,0.76,43.0),(0.65,0.07,50.0),(0.68,0.49,38.0)] {let r=CGRect(x:s.width*x,y:s.height*y,width:w,height:39);ctx.fill(Path(roundedRect:r,cornerRadius:5),with:.color(.white));var roof=Path();roof.move(to:CGPoint(x:r.minX-4,y:r.minY));roof.addLine(to:CGPoint(x:r.midX,y:r.minY-19));roof.addLine(to:CGPoint(x:r.maxX+4,y:r.minY));roof.closeSubpath();ctx.fill(roof,with:.color(vO));ctx.fill(Path(CGRect(x:r.midX-4,y:r.minY+16,width:8,height:23)),with:.color(vA.opacity(0.7)))}
  }
  ForEach(0..<5){i in RoundedRectangle(cornerRadius:2).fill(.white).frame(width:37,height:8).rotationEffect(.degrees(55)).position(x:g.size.width*0.52+CGFloat(i)*7-14,y:g.size.height*0.48+CGFloat(i)*9-18)}
  nBird().scaleEffect(0.8).position(x:g.size.width*0.35,y:g.size.height*0.38)
  Image(systemName:season==2 ? "snowflake":"sun.max.fill").font(.system(size:30)).foregroundStyle(season==2 ? .white:vY).position(x:g.size.width*0.88,y:37)
 }.clipped().clipShape(RoundedRectangle(cornerRadius:28))
 }.accessibilityHidden(true)
 }
}
struct nRoad:View {
 var signal:Int;var art:String;var passed:Bool
 var body:some View {GeometryReader {g in ZStack {
 Color(red:0.88,green:0.93,blue:0.76)
 VStack(spacing:0) {Color(red:0.90,green:0.88,blue:0.80).frame(height:45);ZStack{vA;HStack(spacing:9){ForEach(0..<6){_ in Rectangle().fill(.white).frame(width:24)}}.frame(width:195).rotationEffect(.degrees(90))}.frame(height:130);Color(red:0.90,green:0.88,blue:0.80).frame(height:45)}
 nBird().scaleEffect(0.75).position(x:g.size.width*0.48,y:passed ? 35:g.size.height-34)
 nSign(kind:signal==0 ? "red":(art=="signal" ? "green":"crossing"),size:67).position(x:g.size.width*0.81,y:52)
 Image(systemName:"car.side.fill").font(.system(size:48)).foregroundStyle(vO).position(x:g.size.width*0.14,y:g.size.height*0.45)
 Image(systemName:"figure.stand").font(.system(size:35,weight:.bold)).position(x:g.size.width*0.64,y:passed ? 31:g.size.height-36)
 }.clipShape(RoundedRectangle(cornerRadius:24))}.frame(height:240).accessibilityElement(children:.ignore).accessibilityLabel(kL(passed ? "arrived":(signal==0 ? "road_red":"road_clear"))) }
}

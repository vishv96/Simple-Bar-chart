//
//  ContentView.swift
//  Shared
//
//  Created by Vishnu Vijayan on 2022-02-07.
//

import SwiftUI
import CoreData

struct Constants {
  static let yIntervalBlockheight = 40
  static let xIntervalBlockheight = 40
}

struct ContentView: View {

  struct ChatValues: Identifiable {
    var id: Int
    var value: CGFloat
  }

  private let title: String = "Sales"

  @State var intervals: [CGFloat] = [CGFloat] ()

  @State var values: [CGFloat] = [53, 32, 50, 80, 20, 32, 32, 50, 80, 20, 32, 32, 50, 80, 20, 32, 32, 50, 80, 20, 32, 32, 50, 80, 20]

  var maxValue: CGFloat { values.max() ?? 0.0 }

  var minValue: CGFloat { values.min() ?? 0.0 }

  private let intervalDistribution = 6

  var body: some View {
    ZStack {
      VStack{
        Spacer()
        //Card
        VStack {
          // Card content
          ZStack {
            VStack {
              HStack {
                Text(title)
                Spacer()
              }
              .padding(.horizontal)
              .padding(.vertical)
              GeometryReader { reader in
                HStack {
                  YlabelView($intervals)
                  ZStack {
                    IntervalLines($intervals)
                    ScrollView(.horizontal) {
                      BarLine(frameHeight: reader.frame(in: .local).height,
                              maxValue: maxValue,
                              totalIntervals: intervals.count,
                              values: $values)
                    }
                    .frame(height: reader.frame(in: .local).height)
                  }
                  Spacer()
                }
                .padding(.horizontal)
              }
              .frame(height: CGFloat(intervals.count * Constants.yIntervalBlockheight))
            }
          }
          .padding(.vertical)

        }
        .background(Color.white)
        .cornerRadius(20)
        .padding(.horizontal)
        .shadow(color: Color.gray,
                radius: 20,
                x: 0, y: 5)

        // Card end here
        Spacer()
        VStack{
          Text("Bar chart")
            .foregroundColor(.white)
          Spacer()
        }
      }.background(Color.green)

    }
    .onAppear{
      intervals = caluclateAllIntervals()
    }
  }

  private func caluclateAllIntervals() -> [CGFloat]{
    let intervalValue: CGFloat = maxValue / CGFloat(intervalDistribution)
    var allValues = [CGFloat]()
    for i in 1...intervalDistribution {
      let prod = intervalValue * CGFloat(i)
      guard prod <= maxValue else {
        break
      }
      allValues.append(prod)
    }
    return allValues.reversed()
  }


}

//MARK: - Y Label
struct YlabelView: View {

  @Binding var intervals: [CGFloat]

  init(_ intervals: Binding<[CGFloat]>) {
    _intervals = intervals
  }

  var body: some View {
    VStack(spacing: 0){
      ForEach(0..<intervals.count, id:\.self) { i in
        VStack (spacing: 0){
          Text("\(Int(intervals[i]))")
            .font(.caption2)
          .foregroundColor(.gray)
          .offset(y:-9)
          Spacer()
        }
        .frame(height: CGFloat(Constants.yIntervalBlockheight))

      }
    }
  }
}

//MARK: - New Bars with values
struct BarLine: View {

  let frameHeight: CGFloat

  let maxValue: CGFloat

  let totalIntervals: Int

  @Binding var values: [CGFloat]

  var body: some View {
    HStack(alignment:.bottom){
      ForEach(0..<values.count, id:\.self){ index in
        VStack (spacing:0){
          Text("\(Int(values[index]))")
            .font(.caption2)
            .fontWeight(.bold)
            .foregroundColor(.blue)
          Bar()
            .stroke(style: StrokeStyle(lineWidth:10, lineCap: .round))
            .fill(LinearGradient(colors: [.blue,.green], startPoint: .top, endPoint: .bottom))
            .frame(height: calculateBarHeight(value: values[index]))
            .padding(.top, 5)
          .padding(.leading, 10)

        }
        
      }
    }
  }

  private func calculateBarHeight(value: CGFloat) -> CGFloat {
    // Calculate percentage of value relative to maximum value on Y
    let percentageOfMaxValue = (value / maxValue) * 100

    let corectedHeight = frameHeight//(CGFloat(totalIntervals) / 0.5)
    // Caluclate height of the bar relative to frame height
    let height = (corectedHeight * percentageOfMaxValue) / 100
    return height
  }

}

//MARK: - Interval Lines
struct IntervalLines: View {

  @Binding var intervals: [CGFloat]

  init(_ intervals: Binding<[CGFloat]>) {
    _intervals = intervals
  }

  private var intervalBlockHeight: CGFloat = CGFloat(Constants.yIntervalBlockheight)

  var body: some View {
    VStack(spacing:0){
      ForEach(0..<intervals.count, id:\.self) { i in
        // Line with label
        VStack {
          Line()
            .stroke(style: StrokeStyle(lineWidth:1, dash:[3] ))
            .opacity(0.4)
        }
        .frame(height: intervalBlockHeight)
        .padding(.trailing,20)
        .foregroundColor(.gray)

      }

    }
  }

}

//MARK: - Shapes
struct Line: Shape {
  func path(in rect: CGRect) -> Path {
    var path = Path()
    path.move(to: .init(x: 0, y: 0))
    path.addLine(to: .init(x: rect.width, y: 0))
    return path
  }
}

//Shape
struct Bar: Shape {
  func path(in rect: CGRect) -> Path {
    var path = Path()
    path.move(to: .init(x: 0, y: 0))
    path.addLine(to: .init(x: 0, y: rect.height))
    return path
  }
}

struct ContentPreview: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

//
//  ContentView.swift
//  Shared
//
//  Created by Vishnu Vijayan on 2022-02-07.
//

import SwiftUI
import CoreData

struct ContentView: View {

  struct ChatValues: Identifiable {
    var id: Int
    var value: CGFloat
  }

  private let title: String = "Sales"

  var maxValue: CGFloat { values.max() ?? 0.0 }

  var minValue: CGFloat { values.min() ?? 0.0 }

  @State var intervals: [CGFloat] = [CGFloat] ()

  @State var values: [CGFloat] = [30, 30, 50, 80, 20]

  private let intervalDistribution = 5

  var body: some View {
    ZStack {
      Color.black.opacity(0.3)
      VStack{
        Spacer()
        //Card
        VStack {
          // Card content

          ZStack(alignment:.bottom) {
            VStack(alignment:.leading) {
              // Bar plot
                VStack {

                  // Title
                  HStack {
                    Text(title)
                    Spacer()
                  }
                  .padding(12)
                  .padding(.leading)
                  .foregroundColor(.gray)

                  // Lines
                  IntervalLines($intervals)

                }.padding(.bottom)


              // Bottom line
              Line()
                .stroke(style: StrokeStyle(lineWidth:1, dash:[3]))
                .foregroundColor(.gray.opacity(0.6))
                .padding(.horizontal, 20)
                .frame(height:30)

            }

            ForEach(0..<values.count, id:\.self) { i in
              HStack {
                Bar()
                  .stroke(style: StrokeStyle(lineWidth:10, lineCap: .round))
                  .fill(LinearGradient(colors: [.blue,.green], startPoint: .top, endPoint: .bottom))
                  .padding(.leading, 50)
                  .frame(height: barHeight(calculateForValue: values[i]))
                  .offset(x: CGFloat(i * 40) )
              }
            }.padding(.bottom, 40)

          }
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

  private func barHeight(calculateForValue value: CGFloat) -> CGFloat{
    let intervalBlockHeight = 30
    let maxBarHeight = CGFloat(intervals.count * intervalBlockHeight)
    let percentageOfMaxValue = (value / maxValue) * 100
    let height = (maxBarHeight * percentageOfMaxValue) / 100
    return height
  }

}

//MARK: - Interval Lines
struct IntervalLines: View {

  @Binding var intervals: [CGFloat]

  init(_ intervals: Binding<[CGFloat]>) {
    _intervals = intervals
  }

  private var intervalBlockHeight: CGFloat = 30

  var body: some View {
    VStack(spacing:0){
      ForEach(0..<intervals.count, id:\.self) { i in

        // Line with label
        VStack {
          HStack {
            Text("\(Int(intervals[i]))").font(.caption2)
            Spacer()
          }
          Line()
            .stroke(style: StrokeStyle(lineWidth:1, dash:[3] ))
            .opacity(0.4)
        }
        .frame(height: intervalBlockHeight)
        .padding(.horizontal,20)
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

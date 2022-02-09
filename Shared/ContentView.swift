//
//  ContentView.swift
//  Shared
//
//  Created by Ryan Wennekes on 09/02/2022.
//

import SwiftUI

struct ContentView: View {
    @State var wheatherData: WeatherData?
    var location: String = "Den Bosch"
    var urlString: String = "https://api.openweathermap.org/data/2.5/weather?q=s-Hertogenbosch&appid=3b7c0bb2df5778f696d6dfc53b6189c9&units=metric"
    
    var body: some View {
        ZStack() {
            Image("Unknown")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            VStack() {
                Text(location)
                Text(getTemperatureString())
                    .fontWeight(.semibold)
            }
            .font(.custom("Helvetica Neue UltraLight", size: 60))
        }
        .onAppear(perform: loadData)
    }
    
    func loadData() {
        guard let url = URL(string: urlString) else {
            print("Failed to construct URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) {data, _, error in
            if let error = error {
                return
            }
            guard let data = data else {
                return
            }
            do {
                let newWheatherData = try JSONDecoder().decode(WeatherData.self, from: data)
                
                DispatchQueue.main.async {
                    self.wheatherData = newWheatherData
                }
            } catch let error as NSError {
                print("")
            }

        }
        task.resume()
    }

    func getTemperatureString() -> String {
        return "\(wheatherData?.main.temp ?? 0) °C"
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

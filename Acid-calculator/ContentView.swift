//
//  ContentView.swift
//  Acid-calculator
//
//  Created by Guest User on 26.08.2021.
//

import SwiftUI

struct CalculationState {
    var currentNumber: Double = 0
    
    var storedNumber: Double?
    var storedAction: ActionView.Action?
    
    
    
    mutating func appendNumber(_ number: Double)  {
        if number.truncatingRemainder(dividingBy: 1) == 0
            &&
            currentNumber.truncatingRemainder(dividingBy: 1) == 0 {
            currentNumber = 10 * currentNumber + number
        } else {
            currentNumber = number
        }
    }
}


struct ContentView: View {
    
    @State var state = CalculationState()
    
    var displayedString: String {
        return String(format: "%.2f", arguments: [state.currentNumber])
    }
    
    var body: some View {
        ZStack {
            (Color.init(#colorLiteral(red: 0.399224729, green: 0.4486305081, blue: 0.6777716397, alpha: 1)))
                .frame(height: .infinity)
                .ignoresSafeArea()
            
        VStack(alignment: .trailing, spacing: 12) {
            Spacer()
            
            Text(displayedString)
                .font(.largeTitle)
                .fontWeight(.bold)
                .lineLimit(3)
                .padding(.bottom, 64)
                .foregroundColor(.init(#colorLiteral(red: 1, green: 0.3820963955, blue: 0.9257567041, alpha: 1)))
                
            
            HStack {
                FunctionView(function: .cosinus, state: $state)
                Spacer()
                FunctionView(function: .sinus, state: $state)
                Spacer()
                FunctionView(function: .tangens, state: $state)
                Spacer()
                ActionView(action: .multiply, state: $state)
                
            }
            
            HStack {
                NumberView(number: 1, state: $state)
                Spacer()
                NumberView(number: 2, state: $state)
                Spacer()
                NumberView(number: 3, state: $state)
                Spacer()
                ActionView(action: .divide, state: $state)
            }
            
            HStack {
                NumberView(number: 4, state: $state)
                Spacer()
                NumberView(number: 5, state: $state)
                Spacer()
                NumberView(number: 6, state: $state)
                Spacer()
                ActionView(action: .plus, state: $state)
            }
            HStack {
                NumberView(number: 7, state: $state)
                Spacer()
                NumberView(number: 8, state: $state)
                Spacer()
                NumberView(number: 9, state: $state)
                Spacer()
                ActionView(action: .minus, state: $state)
            }
            
            HStack {
                NumberView(number: 0, state: $state)
                Spacer()
                NumberView(number: .pi, state: $state)
                Spacer()
                ActionView(action: .clear, state: $state)
                Spacer()
                ActionView(action: .equal, state: $state)
            }
            
            
        }.padding(32)
        
    }
}
}

struct NumberView: View {
    let number: Double
    @Binding var state: CalculationState
    
    var numberString: String {
        if number == .pi {
            return "π"
        }
        return String(Int(number))
    }
    var body : some View {
        Text(numberString)
            .font(.title)
            .fontWeight(.bold)
            .foregroundColor(.init(#colorLiteral(red: 0.9850782858, green: 1, blue: 0.9550227736, alpha: 1)))
            .frame(width: 64, height: 64)
            .background(Color.init(#colorLiteral(red: 0.7895662078, green: 0.2922088154, blue: 1, alpha: 1)))
            .cornerRadius(20)
            .shadow(color: Color.blue.opacity(0.3), radius: 10, x: 0, y: 10)
            .onTapGesture {  self.state.appendNumber(self.number)
            }
    }
    
}


struct FunctionView: View {
    enum MathFunction {
        case sinus, cosinus, tangens
        
        func string() -> String {
            switch  self {
            case .sinus: return "sin"
            case .cosinus: return "cos"
            case . tangens: return "tan"
            }
        }
        func operation(_ input: Double) -> Double {
            switch self{
            case .sinus: return sin(input)
            case .cosinus: return cos(input)
            case .tangens: return tan(input)
            }
        }
    }
    
    var function: MathFunction
    @Binding var state: CalculationState

    
    
    var body: some View {
        return Text(function.string())
            .font(.title)
            .fontWeight(.bold)
            .foregroundColor(.black)
            .frame(width: 64, height: 64)
            .background(Color.init(#colorLiteral(red: 1, green: 0, blue: 0.6739993925, alpha: 1)))
            .cornerRadius(20)
            .shadow(color: Color.gray.opacity(0.9), radius: 10, x: 0, y: 10)
            .onTapGesture {
                self.state.currentNumber = self.function.operation(self.state.currentNumber)
            }
        
        
    }
    
}

struct ActionView: View {
    
    enum Action {
        case equal, clear, plus, minus, multiply, divide
        
        func  image() -> Image {
            switch self {
            case .equal:
                return Image(systemName: "equal")
            case .clear:
                return Image(systemName: "xmark.circle")
            case .plus:
                return Image(systemName: "plus")
            case .minus:
                return Image(systemName: "minus")
            case .multiply:
                return Image(systemName: "multiply")
            case .divide:
                return Image(systemName: "divide")
            }
        }
        func calculate(_ input1: Double, _ input2: Double) -> Double? {
            switch self {
            case .plus:
                return input1 + input2
            case .minus:
                return input1 - input2
            case .multiply:
                return input1 * input2
            case .divide:
                return input1 / input2
            default: return nil
            }
        }
        
    }
    
    let action: Action
    @Binding var state: CalculationState
    
    var body: some View {
        action.image()
            .font(Font.title.weight(.bold))
            .foregroundColor(.black)
            .frame(width: 64, height: 64)
            .background(Color.init((#colorLiteral(red: 0.2337591056, green: 1, blue: 0.7889667388, alpha: 1))))
            .cornerRadius(20)
            .shadow(color: Color.gray.opacity(0.6), radius: 10, x: 0, y: 10)
            .onTapGesture {
                self .tapped()
            }
    }
    
    private func tapped() {
        
        switch action {
        case .clear:
            state.currentNumber = 0
            state.storedNumber = nil
            state.storedAction = nil
            break
        case .equal:
            guard  let storedAction =
                    state.storedAction else {
                return
            }
            guard let storedNumber = state.storedNumber else {
                return
            }
            guard let result =
                    storedAction.calculate(storedNumber, state.currentNumber) else {
                return
            }
            
            state.currentNumber = result
            state.storedNumber = nil
            state.storedAction = nil
            break
        default:
            state.storedNumber = state.currentNumber
            state.currentNumber = 0
            state.storedAction = action
            break
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

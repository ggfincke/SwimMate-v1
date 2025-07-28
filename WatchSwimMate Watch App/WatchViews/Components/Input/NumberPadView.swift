// NumberPadView.swift

import SwiftUI

// custom number pad for watch input
struct NumberPadView: View
{
    @Binding var value: Double
    @Environment(\.dismiss) private var dismiss

    let title: String
    let unit: String
    let maxValue: Double
    let accentColor: Color
    let isCompact: Bool

    @State private var inputString: String = ""
    @State private var showError: Bool = false

    // abbreviated unit for compact mode
    private var displayUnit: String
    {
        guard !unit.isEmpty
        else
        {
            return unit
        }

        switch unit.lowercased()
        {
        case "meters", "meter", "m":
            return "m"
        case "yards", "yard", "yd":
            return "yd"
        case "minutes", "minute", "min":
            return "min"
        case "seconds", "second", "sec":
            return "sec"
        case "calories", "calorie", "cal":
            return "cal"
        default:
            return unit.prefix(2).description
        }
    }

    // max digits allowed based on maxValue
    private var maxDigits: Int
    {
        return String(Int(maxValue)).count
    }

    // number pad layout
    private let numbers: [[String]] = [
        ["1", "2", "3"],
        ["4", "5", "6"],
        ["7", "8", "9"],
        ["⌫", "0", "✓"],
    ]

    // flattened numbers array for unique indexing
    private var flattenedNumbers: [String]
    {
        numbers.flatMap
        {
            $0
        }
    }

    var body: some View
    {
        VStack(spacing: mainSpacing)
        {
            // header
            VStack(spacing: headerSpacing)
            {
                // current value display
                HStack(alignment: .lastTextBaseline, spacing: 2)
                {
                    Text(inputString.isEmpty ? "0" : inputString)
                        .font(.system(size: valueFontSize, weight: .bold, design: .rounded))
                        .foregroundColor(showError ? .red : accentColor)
                        .monospacedDigit()
                        .animation(.easeInOut(duration: 0.2), value: showError)

                    if !displayUnit.isEmpty
                    {
                        Text(displayUnit)
                            .font(.system(size: unitFontSize, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                }

                if showError
                {
                    Text("Max: \(Int(maxValue)) \(unit)")
                        .font(.system(size: errorFontSize))
                        .foregroundColor(.red)
                        .transition(.opacity)
                }
            }

            // number pad grid
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: gridSpacing), count: 3), spacing: gridSpacing)
            {
                ForEach(flattenedNumbers.indices, id: \.self)
                {
                    index in
                    let buttonText = flattenedNumbers[index]
                    numberPadButton(text: buttonText)
                }
            }

            Spacer()
        }
        .padding(.horizontal, horizontalPadding)
        .onAppear
        {
            // init w/ current value if > 0
            if value > 0
            {
                inputString = "\(Int(value))"
            }
        }
    }

    // individual number pad button
    private func numberPadButton(text: String) -> some View
    {
        Button(action:
            {
                handleButtonPress(text)
            })
        {
            ZStack
            {
                // button background
                RoundedRectangle(cornerRadius: buttonCornerRadius)
                    .fill(buttonBackgroundColor(for: text))
                    .frame(height: buttonHeight)

                // button text/icon
                if text == "⌫"
                {
                    Image(systemName: "delete.left")
                        .font(.system(size: buttonIconSize, weight: .medium))
                        .foregroundColor(buttonTextColor(for: text))
                }
                else if text == "✓"
                {
                    Image(systemName: "checkmark")
                        .font(.system(size: buttonIconSize, weight: .semibold))
                        .foregroundColor(.white)
                }
                else
                {
                    Text(text)
                        .font(.system(size: buttonTextSize, weight: .semibold, design: .rounded))
                        .foregroundColor(buttonTextColor(for: text))
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(text == "✓" && inputString.isEmpty)
        .opacity((text == "✓" && inputString.isEmpty) ? 0.5 : 1.0)
    }

    // handle button press logic
    private func handleButtonPress(_ text: String)
    {
        withAnimation(.easeInOut(duration: 0.1))
        {
            showError = false
        }

        WKInterfaceDevice.current().play(.click)

        switch text
        {
        case "⌫":
            // delete last character
            if !inputString.isEmpty
            {
                inputString.removeLast()
            }

        case "✓":
            // confirm & dismiss
            if let newValue = Double(inputString), newValue <= maxValue
            {
                value = newValue
                WKInterfaceDevice.current().play(.success)
                dismiss()
            }
            else
            {
                // show error for invalid input
                withAnimation(.easeInOut(duration: 0.3))
                {
                    showError = true
                }
                WKInterfaceDevice.current().play(.failure)
                // auto-hide error after 2 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0)
                {
                    withAnimation(.easeInOut(duration: 0.3))
                    {
                        showError = false
                    }
                }
            }

        default:
            // add number to input string
            let newString = inputString + text

            // prevent input that's too long or exceeds max value
            if newString.count <= maxDigits, let newValue = Double(newString), newValue <= maxValue
            {
                inputString = newString
            }
            else
            {
                // show brief error indication
                withAnimation(.easeInOut(duration: 0.2))
                {
                    showError = true
                }
                WKInterfaceDevice.current().play(.failure)

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5)
                {
                    withAnimation(.easeInOut(duration: 0.2))
                    {
                        showError = false
                    }
                }
            }
        }
    }

    // button styling helpers
    private func buttonBackgroundColor(for text: String) -> Color
    {
        switch text
        {
        case "✓":
            return accentColor
        case "⌫":
            return Color.red.opacity(0.2)
        default:
            return Color.secondary.opacity(0.15)
        }
    }

    private func buttonTextColor(for text: String) -> Color
    {
        switch text
        {
        case "✓":
            return .white
        case "⌫":
            return .red
        default:
            return .primary
        }
    }
}

// styling properties
extension NumberPadView
{
    // responsive sizing properties
    var valueFontSize: CGFloat
    {
        isCompact ? 20 : 24
    }

    var unitFontSize: CGFloat
    {
        isCompact ? 12 : 12
    }

    var errorFontSize: CGFloat
    {
        isCompact ? 10 : 10
    }

    var gridSpacing: CGFloat
    {
        isCompact ? 4 : 4
    }

    var buttonHeight: CGFloat
    {
        isCompact ? 24 : 32
    }

    var buttonCornerRadius: CGFloat
    {
        isCompact ? 6 : 8
    }

    var buttonIconSize: CGFloat
    {
        isCompact ? 14 : 16
    }

    var buttonTextSize: CGFloat
    {
        isCompact ? 16 : 18
    }

    var horizontalPadding: CGFloat
    {
        isCompact ? 8 : 16
    }

    var headerSpacing: CGFloat
    {
        isCompact ? 2 : 4
    }

    var mainSpacing: CGFloat
    {
        isCompact ? 4 : 4
    }
}

// preview
#Preview("Standard Size")
{
    NumberPadView(
        value: .constant(500.0),
        title: "Distance Goal",
        unit: "meters",
        maxValue: 1_000_000,
        accentColor: .blue,
        isCompact: false
    )
}

#Preview("Compact Size")
{
    NumberPadView(
        value: .constant(500.0),
        title: "Distance Goal",
        unit: "meters",
        maxValue: 1_000_000,
        accentColor: .blue,
        isCompact: true
    )
}

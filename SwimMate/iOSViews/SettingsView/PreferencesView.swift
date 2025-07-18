// SwimMate/iOSViews/SettingsView/PreferencesView.swift

import SwiftUI

struct PreferencesView: View
{
    @EnvironmentObject var manager: Manager
    
    var body: some View 
    {
        Form
        {
            Section(header: Text("User Info"))
            {
                TextField("Enter your name", text: $manager.userName)
                     .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            Section(header: Text("User Preferences"))
            {
                Picker("Stroke Preference", selection: $manager.preferredStroke)
                {
                    ForEach([SwimStroke.freestyle, .backstroke, .breaststroke, .butterfly, .mixed], id: \.self)
                    { stroke in
                        Text(stroke.description).tag(stroke)
                    }
                }

                Picker("Unit Preference", selection: $manager.preferredUnit) 
                {
                    ForEach(MeasureUnit.allCases, id: \.self)
                    { unit in
                        Text(unit.rawValue).tag(unit)
                    }
                }
            }

            Section(header: Text("Save Settings"))
            {
                Button("Save Preferences") 
                {
                    manager.updateStore()
                }
            }
        }
        .navigationTitle("Preferences")
    }
}



#Preview {
    PreferencesView()
        .environmentObject(Manager())
}

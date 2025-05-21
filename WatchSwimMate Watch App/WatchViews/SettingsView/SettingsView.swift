// Settings View implementation
struct SettingsView: View
{
    @EnvironmentObject var manager: WatchManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View
    {
        List
        {
            Section(header: Text("Pool Settings"))
            {
                Picker("Default Unit", selection: $manager.poolUnit)
                {
                    Text("Meters").tag("meters")
                    Text("Yards").tag("yards")
                }
                
                Picker("Default Length", selection: $manager.poolLength)
                {
                    Text("25").tag(25.0)
                    Text("50").tag(50.0)
                    Text("33.33").tag(33.33)
                }
            }
            
            Section
            {
                Button("Done")
                {
                    dismiss()
                }
            }
        }
        .navigationTitle("Settings")
    }
}

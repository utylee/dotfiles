function __fish_launchagent_labels
    for f in ~/Library/LaunchAgents/*.plist
        test -e $f; or continue

        set label (plutil -extract Label xml1 -o - $f 2>/dev/null \
                    | sed -n 's:.*<string>\(.*\)</string>.*:\1:p')

        test -n "$label"; and echo $label
    end
end

complete -c restart \
    -f \
    -a "(__fish_launchagent_labels)"

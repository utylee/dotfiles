function restart
    set -l uid (id -u)
    set -l domain gui/$uid

    function __restart_help
        echo "usage:"
        echo "  restart <launchd-label>"
        echo "  restart --soft <launchd-label>"
        echo ""
        echo "description:"
        echo "  Restart a launchd user agent."
        echo ""
        echo "  default:"
        echo "    Full reload (strong reset):"
        echo "      bootout → bootstrap → enable → kickstart -k"
        echo ""
        echo "  --soft:"
        echo "    Soft restart only:"
        echo "      kickstart -k"
        echo ""
        echo "examples:"
        echo "  restart com.utylee.autossh.tunnels"
        echo "  restart --soft com.utylee.autossh.tunnels"
    end

    # no args → help
    if test (count $argv) -eq 0
        __restart_help
        return 0
    end

    set -l mode "hard"
    set -l label ""

    # parse args
    for a in $argv
        switch $a
            case --soft
                set mode "soft"
            case -h --help
                __restart_help
                return 0
            case '*'
                if test -z "$label"
                    set label $a
                else
                    __restart_help
                    return 1
                end
        end
    end

    if test -z "$label"
        __restart_help
        return 1
    end

    set -l service $domain/$label
    set -l plist "$HOME/Library/LaunchAgents/$label.plist"

    if test "$mode" = "soft"
        echo "↻ soft restart $label"
        launchctl kickstart -k $service
        return $status
    end

    # hard reload
    if not test -f $plist
        echo "restart: plist not found"
        echo "  expected: $plist"
        return 1
    end

    echo "↻ reload+restart $label"

    # best-effort cleanup
    launchctl bootout $service 2>/dev/null; or true
    launchctl bootout $domain $plist 2>/dev/null; or true

    # re-register
    launchctl bootstrap $domain $plist 2>/dev/null; or true
    launchctl enable $service 2>/dev/null; or true

    launchctl kickstart -k $service
end
# function restart
#     if test (count $argv) -ne 1
#         echo "usage: restart <launchd-label>"
#         return 1
#     end

#     set label $argv[1]
#     set uid (id -u)

#     echo "↻ restarting $label"
#     launchctl kickstart -k gui/$uid/$label
# end

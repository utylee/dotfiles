function __fish_lms_running_models
    lms ps 2>/dev/null | tail -n +3 | awk '{print $1}'
end

complete -c lms \
    -n "__fish_seen_subcommand_from unload" \
    -a "(__fish_lms_running_models)" \
    -f

_hope()
{
    local cur script coms opts com
    COMPREPLY=()
    _get_comp_words_by_ref -n : cur words

    # for an alias, get the real script behind it
    if [[ $(type -t ${words[0]}) == "alias" ]]; then
        script=$(alias ${words[0]} | sed -E "s/alias ${words[0]}='(.*)'/\1/")
    else
        script=${words[0]}
    fi

    # lookup for command
    for word in ${words[@]:1}; do
        if [[ $word != -* ]]; then
            com=$word
            break
        fi
    done

    # completing for an option
    if [[ ${cur} == --* ]] ; then
        opts="--help --quiet --verbose --version --ansi --no-ansi --no-interaction"

        case "$com" in

            help)
            opts="${opts} --format --raw"
            ;;

            list)
            opts="${opts} --raw --format"
            ;;

            migrate:dr-eye-dictionary-cache)
            opts="${opts} "
            ;;

            migrate:event-configs)
            opts="${opts} --import --seed"
            ;;

            migrate:home-products)
            opts="${opts} --seed"
            ;;

            migrate:questionnaire)
            opts="${opts} --seed"
            ;;

        esac

        COMPREPLY=($(compgen -W "${opts}" -- ${cur}))
        __ltrim_colon_completions "$cur"

        return 0;
    fi

    # completing for a command
    if [[ $cur == $com ]]; then
        coms="help list migrate:dr-eye-dictionary-cache migrate:event-configs migrate:home-products migrate:questionnaire"

        COMPREPLY=($(compgen -W "${coms}" -- ${cur}))
        __ltrim_colon_completions "$cur"

        return 0
    fi
}

complete -o default -F _hope hope

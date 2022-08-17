function fish_mode_prompt --description 'displays the current mode'
                        # Do nothing if not in vi mode
                        if test "$fish_key_bindings" = "fish_vi_key_bindings"
                            switch $fish_bind_mode
                                case default
                                    set_color --bold "F55D3E"  
                                    echo N
                                case insert
                                    set_color --bold yellow
                                    echo I
                                 case replace
                                     set_color --bold "04A777"
                                     echo R
                                case visual
                                    set_color --bold "8AFFC1"
                                    echo V
                            end
                            set_color normal
                            printf " "
                        end
                    end

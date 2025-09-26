# https://github.com/nickeb96/puffer-fish/blob/master/README.md
# Mit license
# Copyright © Nicholas Boyle
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the 'Software'), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

function _puffer_fish_key_bindings --on-variable fish_key_bindings
    set -l modes
    if test "$fish_key_bindings" = fish_default_key_bindings
        set modes default insert
    else
        set modes insert default
    end

    bind --mode $modes[1] . _puffer_fish_expand_dots
    bind --mode $modes[1] ! _puffer_fish_expand_bang
    bind --mode $modes[1] '$' _puffer_fish_expand_lastarg
    bind --mode $modes[2] --erase . ! '$'
end


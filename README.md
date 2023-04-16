# vgoogle
google search on terminal
made with [vcli](https://github.com/changhz/vcli)

## Installation
1. Install [vlang](https://github.com/vlang/v)
2. Clone this repo and `cd` into it
3. Run `v .` to compile as an executable

## Examples

display search result as plain text `-t` on your terminal, navigate with `less`
``` sh
vgoogle -t -q news | less
```

search keyword `vlang doc` and print the result in `Markdown` format
``` sh
vgoogle -q vlang+doc
```

save the search result
``` sh
vgoogle -q vlang+doc > search.md
```

perform image search
``` sh
vgoogle -q beautiful+sky -m
```

## Contribution
Anyone is welcome to report issues or make pull requests. Thank you.

## Version
0.0.1

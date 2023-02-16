# vgoogle
google search on terminal
made with [vcli](https://github.com/changhz/vcli)

## Installation
1. Install [vlang](https://github.com/vlang/v)
2. Clone this repo and `cd` into it
3. Run `v .` to compile as an executable

## Example Usage
``` sh
# search keyword `vlang doc` and print the result in `Markdown` format
vgoogle -q vlang+doc
```

``` sh
# save the search result
vgoogle -q vlang+doc > search.md
```

``` sh
# perform image search
vgoogle -q beautiful+sky -m
```

## Contribution
Anyone is welcome to report issues or make pull requests. Thank you.

## Version
0.0.1
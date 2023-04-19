# vgoogle
google search on terminal
made with [vcli](https://github.com/changhz/vcli)

# Installation
1. Install [vlang](https://github.com/vlang/v)
2. Clone this repo and `cd` into it
3. Run `v .` to compile as an executable

# Examples

display search result on your terminal, navigate with `less`
``` sh
vgoogle world news | less
```

save the search result
``` sh
vgoogle vlang doc > search.md
```

perform image search with `-m` flag
``` sh
vgoogle beautiful sky -m
```

# Contribution
Anyone is welcome to report issues or make pull requests. Thank you.

# Version
0.1.0

# Changelog
## 0.1.0
- default plain text search (no image)
- updated README.md
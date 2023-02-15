module lib

import regex {regex_opt}

pub type String = string

pub fn (s String) replace(pattern string, txt string) string {
  mut re := regex_opt(pattern) or {panic('well')}
  return re.replace(s, txt)
}
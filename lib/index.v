module lib

import regex {regex_opt}

pub type String = string

pub fn (s String) find(pattern string) []string {
  mut re := regex_opt(pattern) or {panic('well')}
  return re.find_all_str(s)
}

pub fn (s String) replace(pattern string, txt string) String {
  mut re := regex_opt(pattern) or {panic('well')}
  return String(re.replace(s, txt))
}
module main

import os
import flag
import lib {String}

const abort_key = ':q'

fn main() {
  mut fprs := flag.new_flag_parser(os.args)
  fprs.application('vgoogle')
  fprs.version('0.0.1')
  fprs.description('Google Services')
  fprs.skip_executable()

  query := fprs.string('query', `q`, '', 'Make a query')
  page := fprs.int('page', `p`, 1, 'Page Number')

  additional_args := fprs.finalize() or {
    eprintln(err)
    println(fprs.usage())
    return
  }

  user_agent := '"\
    Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) \
    AppleWebKit/537.36 (KHTML, like Gecko) \
    Chrome/110.0.0.0 Safari/537.36\
  "'

  headers := []string{}

  save_as := 'dist/output.html'

  if query != '' {
    url := '"https://www.google.com/search?q=$query&start=${((page-1) * 10).str()}"'
    cmd := 'curl ${headers.join(" ")} -A $user_agent $url -o $save_as'
    println(cmd)

    res := os.execute(cmd)
    println(res.output)

    txt := treat_txt(save_as)

    list_results(txt)

    os.write_file(save_as, txt) or {panic('ok')}
    return
  }

  println(additional_args.join_lines())
  println(fprs.usage())
}

fn list_results(txt string) {
  link_pattern := r'<a(.*)href="(.*)"(.*)>(.*)</a>'
  header_pattern := r'<h[1-6](.*)>(.*)</h[1-6]>'

  links := String(txt).find(link_pattern)
  for link in links {
    mut s := String(link).replace(link_pattern, '\\3\n\\1')
    s = s.replace(header_pattern, r'\1')
    println(s+'\n')
  }
}

fn treat_txt(save_as string) string {
  mut txt := String(os.read_file(save_as) or {panic('oh')})

  for tag in ['head', 'style', 'script', 'svg', 'cite'] {
    txt = txt.replace(r'<'+tag+r'(.*)>(.*)</'+tag+r'>', '')
  }

  for tag in ['span', 'div', 'b', 'br', 'hr'] {
    txt = txt.replace(r'<'+tag+r'(.*)>', '')
    txt = txt.replace(r'</'+tag+r'>', '')
  }

  txt = txt.replace(r'<img(.*)src="(.*)"(.*)>', r'img:\1')
  txt = txt.replace(r'class="(.*)"', '')

  return txt
}
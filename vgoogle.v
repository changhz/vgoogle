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

  mut page := 0

  if query != '' {
    url := '"https://www.google.com/search?q=$query&start=$page.str()"'
    cmd := 'curl ${headers.join(" ")} -A $user_agent $url -o $save_as'
    println(cmd)
    res := os.execute(cmd)
    println(res.output)

    txt := treat_txt(save_as)
    os.write_file(save_as, txt) or {panic('ok')}
    return
  }

  println(additional_args.join_lines())
  println(fprs.usage())
}

fn treat_txt(save_as string) string {
  mut txt := String(os.read_file(save_as) or {panic('oh')})
  txt = txt.replace(r'<style>(.*)</style>', '')
  txt = txt.replace(r'<script(.*)</script>', '')
  txt = txt.replace(r'class="(.*)"', '')
  return txt
}
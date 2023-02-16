module main

import os
import flag
import lib {String}

const abort_key = ':q'

fn main() {
  mut fprs := flag.new_flag_parser(os.args)
  fprs.application('vgoogle')
  fprs.version('0.0.1')
  fprs.description('google search on terminal')
  fprs.skip_executable()

  image := fprs.bool('image', `m`, false, 'Search image')
  plain := fprs.bool('plain', `t`, false, 'Plain text (no image)')
  query := fprs.string('query', `q`, '', 'Make a query')
  page := fprs.int('page', `p`, 1, 'Page Number')

  additional_args := fprs.finalize() or {
    eprintln(err)
    println(fprs.usage())
    return
  }

	// TODO:
  headers := []string{}

  save_as := '$dist/output.html'

  mut url := '\
    https://www.google.com/search\
    ?q=${query}\
    &start=${((page-1) * 10).str()}\
  '

  if image { url += '&tbm=isch' }

  if query != '' {
    cmd := 'curl ${headers.join(" ")} -A $user_agent "$url" -o $save_as'

    os.execute(cmd)

    mut txt := txt_filter(save_as)
    os.execute('rm $save_as')

    mut replace_img := r'![ img ](\1)'
    if plain {replace_img = ''}
    txt = String(txt).replace(img_pattern, replace_img)

    txt = list_results(txt)
		println(txt)

    return
  }

  println(additional_args.join_lines())
  println(fprs.usage())
}

const (
  user_agent = '"\
    Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) \
    AppleWebKit/537.36 (KHTML, like Gecko) \
    Chrome/110.0.0.0 Safari/537.36\
  "'
  dist = '/tmp'
  link_pattern = r'<a(.*)href="(.*)"(.*)>(.*)</a>'
  header_pattern = r'<h[1-6](.*)>(.*)</h[1-6]>'
  img_pattern = r'<img(.*)src="(.*)"(.*)>'
)

fn list_results(txt string) string {
  links := String(txt).find(link_pattern)
  mut r := ''
  for link in links {
    mut s := String(link).replace(link_pattern, '\\3\n\\1')
    s = s.replace(header_pattern, r'\1')
    r += string(s + '\n\n')
  }
  return r
}

fn txt_filter(save_as string) string {
  mut txt := String(os.read_file(save_as) or {panic('oh')})

	mut strip_ls := []string{}

  strip_ls = [
    'style',
    'script',
    'c-wiz',
    'svg',
    'cite',
    'g-more-button',
  ]
  for tag in strip_ls
    {txt = txt.replace(r'<'+tag+r'(.*)>(.*)</'+tag+r'>', '')}

	strip_ls = [
    'g-img',
    'span',
    'div',
    'br',
    'hr',
    'input',
    'meta',
  ]
  for tag in strip_ls {
    txt = txt.replace(r'<'+tag+r'(.*)>', '')
    txt = txt.replace(r'</'+tag+r'>', '')
  }

  strip_ls = [
    'b', 'i', 'strong', 'em'
  ]
  for tag in strip_ls {
    txt = txt.replace(r'<'+tag+r'>', '')
    txt = txt.replace(r'</'+tag+r'>', '')
  }

  txt = txt.replace(r'<h[1-6](.*)>(.*)</h[1-6]>', r'## \1')
  txt = txt.replace(r'class="(.*)"', '')

  return txt
}
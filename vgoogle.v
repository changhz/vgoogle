module main

import os
import flag
import lib {String}
import net.http

const abort_key = ':q'

const user_agent = '"\
		Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) \
		AppleWebKit/537.36 (KHTML, like Gecko) \
		Chrome/110.0.0.0 Safari/537.36\
	"'

const link_pattern = r'<a(.*)href="(.*)"(.*)>(.*)</a>'
const header_pattern = r'<h[1-6](.*)>(.*)</h[1-6]>'
const img_pattern = r'<img(.*)src="(.*)"(.*)>'

fn main() {

	mut fprs := flag.new_flag_parser(os.args)
	fprs.application('vgoogle')
	fprs.version('0.1.0')
	fprs.description('google search on terminal')
	fprs.skip_executable()

	news := fprs.bool('news', `n`, false, 'Search news')
	image := fprs.bool('image', `m`, false, 'Search image')
	page := fprs.int('page', `p`, 1, 'Page Number')

	additional_args := fprs.finalize() or {
		eprintln(err)
		println(fprs.usage())
		return
	}

	query := additional_args.join('+')

	// TODO:
	headers := []string{}

	dist := os.temp_dir()
	save_as := os.join_path(dist, 'output.html')
	mut url := '\
		https://www.google.com/search\
		?q=${query}\
		&start=${((page-1) * 10).str()}\
	'

	mut tab := ''
	if image { tab = 'isch' }
	if news { tab = 'nws' }
	if tab != '' { url += '&tbm=$tab' }

	if query != '' {
		mut req := http.new_request(
			http.Method.get,
			url,
			''
		)

		req.add_custom_header('User-Agent', user_agent) or { panic('Error while adding user agent! ${err}')}

        res := req.do() or { panic("Failed to query! ${err}") }
        os.write_file(save_as, res.body) or { panic("Failed to write response! ${err}") }

		mut txt := txt_filter(save_as)
		os.rm(save_as) or { eprintln('Failed to remove temp file: $err') }

		mut replace_img := ''
		if image {replace_img = r'![ img ](\1)'}
		txt = String(txt).replace(img_pattern, replace_img)

		txt = list_results(txt)
		println(txt)

		return
	}

	println(fprs.usage())
}


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
	println(save_as)
	mut txt := String(os.read_file(save_as) or {panic(err)})

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
		txt = txt.replace(r'<'+tag+r'(.*)>', '\n')
		txt = txt.replace(r'</'+tag+r'>', '')
	}

	strip_ls = [
		'b', 'i', 'strong', 'em'
	]
	for tag in strip_ls {
		txt = txt.replace(r'<'+tag+r'>', '\n')
		txt = txt.replace(r'</'+tag+r'>', '')
	}

	txt = txt.replace(r'<h[1-6](.*)>(.*)</h[1-6]>', r'## \1')
	txt = txt.replace(r'class="(.*)"', '')

	return txt
}

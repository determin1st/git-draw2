###
# initialize
# {{{
username = 'determin1st'
repo     = 'git-drawing'
heatmap  = {
	'2018-12-10T23:59:59+00:00': 1
	'2018-12-11T23:59:59+00:00': 1
	'2018-12-12T23:59:59+00:00': 2
	'2018-12-13T23:59:59+00:00': 2
	'2018-12-14T23:59:59+00:00': 1
	'2018-12-15T23:59:59+00:00': 1
}
proc   = require 'child_process'
os     = require 'os'
fs     = require 'fs'
stdin  = process.stdin
stdout = process.stdout
# prepare input stream
stdin.setEncoding 'utf8'
stdin.resume! if stdin.isPaused!
# }}}
# utils
rmDir = (path) !-> # {{{
	# check valid
	if not path or path.length < 2 or not fs.existsSync path
		return
	# get path separator
	sep = require 'path' .sep
	# remove elements
	for a in fs.readdirSync path
		p = path + sep + a
		if fs.lstatSync p .isDirectory!
			# delete directory (recurse)
			rmDir p
		else
			# delete file
			fs.unlinkSync p
	# remove empty
	fs.rmdirSync path
# }}}
THREAD = (chain) -> # {{{
	return new Promise (complete) !->
		index = 0
		step  = (i) !->
			switch i
			# next
			| true =>
				if not i = chain[++index]
					complete!
					return
			# repeat
			| false =>
				i = chain[index]
			# finish
			| -1 =>
				complete!
				return
			# jump
			| otherwise =>
				index := i
				i = chain[i]
			# run
			new Promise i .then step
		###
		step false
# }}}
###
DATA =
	pre: 'git-draw2> '
	url: 'https://github.com/'+username+'/'+repo
###
THREAD [
	(resolve) !->
		# display intro
		stdout.write '\n'
		stdout.write DATA.pre+'target: '+DATA.url+'\n'
		stdout.write DATA.pre+'select another repo? (Y/N): '
		# ask confirmation
		stdin.setRawMode true
		stdin.once 'data', (k) !->
			if k and k.toUpperCase! == 'Y'
				# continue
				stdout.write 'Yes\n'
				resolve true
			else
				# skip asking
				stdout.write 'No\n'
				resolve 2
	(resolve) !->
		# ask name
		stdout.write DATA.pre+'type the name of your disposable repo: '
		stdin.setRawMode false
		stdin.once 'data', (name) !->
			# validate
			name = name.trim!
			if name and not (/^[a-z]+[a-z0-9_\-]+/i).test name
				# retry
				stdout.write DATA.pre+'wrong name, try again..\n'
				resolve false
			else
				# check empty
				if not name
					stdout.write DATA.pre+'using default..\n'
					name = repo
				# update and restart
				DATA.url = 'https://github.com/'+username+'/'+name
				resolve 0
	(resolve) !->
		# determine commit count
		c = 0
		for a of heatmap
			c += heatmap[a]
		# check
		if not c
			stdout.write DATA.pre+'no data, exiting..\n'
			resolve -1
		# ask confirmation
		stdout.write DATA.pre+'ready to draw (total '+c+' commits)\n'
		stdout.write DATA.pre+'press Y to continue.. '
		stdin.setRawMode true
		stdin.on 'data', (k) !->
			stdout.write '\n'
			if k and k.toUpperCase! == 'Y'
				stdout.write DATA.pre+'confirmed\n'
				resolve true
			else
				stdout.write DATA.pre+'aborted\n'
				resolve -1
	(resolve) !->
		try
			# create temporary directory
			sep    = require 'path' .sep
			tmpdir = fs.mkdtempSync (os.tmpdir! + sep)
			if not fs.existsSync tmpdir
				stdout.write DATA.pre+'failed to create temporary directory..\n'
				throw
			# clone repo
			stdout.write DATA.pre+'working in: '+tmpdir+'\n'
			proc.execSync 'git clone "'+DATA.url+'" "'+tmpdir+'"'
			if not fs.existsSync tmpdir+sep+'.git'
				stdout.write DATA.pre+'failed to clone repository..\n'
				rmDir tmpdir
				throw
			# apply drawing
			stdout.write '\n'
			stdout.write DATA.pre+'commiting: '
			c =
				cwd: tmpdir
				encoding: 'utf8'
			for a,b of heatmap
				while --b >= 0
					proc.execSync 'git commit -m "livescript" --allow-empty --date='+a, c
					stdout.write '+'
			stdout.write '\n'
			# save changes
			stdout.write DATA.pre+'saving changes.. '
			proc.execSync 'git push -q --no-verify', c
			stdout.write 'done\n'
			# remove directory
			stdout.write DATA.pre+'removing: '+tmpdir+'\n'
			rmDir tmpdir
		catch e
			stdout.write DATA.pre+'unexpected error..\n' if e
		# done
		resolve true
]
.then (v) !->
	# done
	debugger
	stdout.write '\n'
	process.exit!



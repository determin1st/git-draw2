"use strict"
do !->
	###
	# initialize
	# {{{
	# check ownership
	a = document.querySelectorAll '.js-profile-editable-edit-button'
	if not a or a.length != 1
		return
	# checkout username
	a = document.querySelectorAll '.vcard-username'
	if not a or a.length != 1
		return
	username = a.0.innerText
	# checkout nodes
	node =
		'svg.js-calendar-graph-svg'
		'div.contrib-legend ul.legend'
		'div.js-calendar-graph'
	node = node.map (selector) ->
		a = document.querySelectorAll selector
		return if a and a.length == 1
			then a.0
			else null
	# check
	for a in node when not a
		return
	# checkout draw area
	rect = [...(node.0.querySelectorAll 'rect.day')]
	legend = [...(node.1.querySelectorAll 'li')]
	rectDraw = rect.map -> 0
	# create controls
	# buttons
	node.3 = a = document.createElement 'div'
	a.classList.add 'git-draw-ctrl'
	btns = ['Get script', 'Draw'].map (name) ->
		a = document.createElement 'div'
		a.innerText = name
		a.classList.add 'git-draw-button'
		node.3.appendChild a
		return a
	# additional legend item
	a = document.createElement 'li'
	a.style.backgroundColor = '#000000'
	a.classList.add 'git-draw-more'
	legend[*] = a
	# inject
	node.1.appendChild a
	node.2.appendChild node.3
	# set default state
	btns.1.classList.add 'active'
	legend.index = 1
	legend.color = [0, 1, 2, 3, 4, 5]
	legend[legend.index].classList.add 'active'
	rect.state = 0
	btns.state = false
	# }}}
	legendSelect = (e) !-> # {{{
		# prepare
		e.preventDefault!
		e.stopPropagation!
		e.stopImmediatePropagation!
		# determine index
		for a,i in legend when a == @
			break
		# check
		if i == legend.index
			return
		# select new draw "color"
		legend[legend.index].classList.remove 'active'
		legend[i].classList.add 'active'
		legend.index = i
	# }}}
	drawPoint = (e) !-> # {{{
		# prepare
		if e.type == 'pointerenter' and not e.buttons
			return
		e.preventDefault!
		e.stopPropagation!
		e.stopImmediatePropagation!
		# determine index
		for a,i in rect when a == @
			break
		# determine commit count
		k = parseInt a.dataset.count
		j = if legend.color[legend.index] <= k
			then 0
			else legend.color[legend.index] - k
		# check
		if j != rectDraw[i]
			# determine new state
			s = rect.state + j - rectDraw[i]
			# set new count
			rectDraw[i] = j
			# determine point color
			k = k + j
			for i,j in legend.color when k <= i
				break
			a.style.fill = legend[j].style.backgroundColor
			# (de)activate script download
			if not rect.state and s
				btns.0.classList.add 'active'
			else if rect.state and not s
				btns.0.classList.remove 'active'
			# done
			rect.state = s
	# }}}
	drawScript = do -> # {{{
		# create
		s = '''
		var username,repo,heatmap,proc,os,fs,stdin,stdout,rmDir,THREAD,DATA;
		username="";
		repo="git-drawing";heatmap={};proc=require("child_process");os=require("os");fs=require("fs");stdin=process.stdin;stdout=process.stdout;stdin.setEncoding("utf8");if(stdin.isPaused()){stdin.resume()}rmDir=function(path){var sep,i$,ref$,len$,a,p;if(!path||path.length<2||!fs.existsSync(path)){return}sep=require("path").sep;for(i$=0,len$=(ref$=fs.readdirSync(path)).length;i$<len$;++i$){a=ref$[i$];p=path+sep+a;if(fs.lstatSync(p).isDirectory()){rmDir(p)}else{fs.unlinkSync(p)}}fs.rmdirSync(path)};THREAD=function(chain){return new Promise(function(complete){var index,step;index=0;step=function(i){switch(i){case true:if(!(i=chain[++index])){complete();return}break;case false:i=chain[index];break;case-1:complete();return;default:index=i;i=chain[i]}new Promise(i).then(step)};step(false)})};DATA={pre:"git-draw2> ",url:"https://github.com/"+username+"/"+repo};THREAD([function(resolve){stdout.write("\\n");stdout.write(DATA.pre+"target: "+DATA.url+"\\n");stdout.write(DATA.pre+"select another repo? (Y/N): ");stdin.setRawMode(true);stdin.once("data",function(k){if(k&&k.toUpperCase()==="Y"){stdout.write("Yes\\n");resolve(true)}else{stdout.write("No\\n");resolve(2)}})},function(resolve){stdout.write(DATA.pre+"type the name of your disposable repo: ");stdin.setRawMode(false);stdin.once("data",function(name){name=name.trim();if(name&&!/^[a-z]+[a-z0-9_\-]+/i.test(name)){stdout.write(DATA.pre+"wrong name, try again..\\n");resolve(false)}else{if(!name){stdout.write(DATA.pre+"using default..\\n");name=repo}DATA.url="https://github.com/"+username+"/"+name;resolve(0)}})},function(resolve){var c,a;c=0;for(a in heatmap){c+=heatmap[a]}if(!c){stdout.write(DATA.pre+"no data, exiting..\\n");resolve(-1)}stdout.write(DATA.pre+"ready to draw (total "+c+" commits)\\n");stdout.write(DATA.pre+"press Y to continue.. ");stdin.setRawMode(true);stdin.on("data",function(k){stdout.write("\\n");if(k&&k.toUpperCase()==="Y"){stdout.write(DATA.pre+"confirmed\\n");resolve(true)}else{stdout.write(DATA.pre+"aborted\\n");resolve(-1)}})},function(resolve){var sep,tmpdir,c,a,ref$,b,e;try{sep=require("path").sep;tmpdir=fs.mkdtempSync(os.tmpdir()+sep);if(!fs.existsSync(tmpdir)){stdout.write(DATA.pre+"failed to create temporary directory..\\n");throw null}stdout.write(DATA.pre+"working in: "+tmpdir+"\\n");proc.execSync('git clone "'+DATA.url+'" "'+tmpdir+'"');if(!fs.existsSync(tmpdir+sep+".git")){stdout.write(DATA.pre+"failed to clone repository..\\n");rmDir(tmpdir);throw null}stdout.write("\\n");stdout.write(DATA.pre+"commiting: ");c={cwd:tmpdir,encoding:"utf8"};for(a in ref$=heatmap){b=ref$[a];while(--b>=0){proc.execSync('git commit -m "livescript" --allow-empty --date='+a,c);stdout.write("+")}}stdout.write("\\n");stdout.write(DATA.pre+"saving changes.. ");proc.execSync("git push -q --no-verify",c);stdout.write("done\\n");stdout.write(DATA.pre+"removing: "+tmpdir+"\\n");rmDir(tmpdir)}catch(e$){e=e$;if(e){stdout.write(DATA.pre+"unexpected error..\\n")}}resolve(true)}]).then(function(v){stdout.write("\\n");process.exit()});
		'''
		# set username
		return s.replace 'username=""', 'username="'+username+'"'
	# }}}
	# attach events
	# {{{
	btns.0.addEventListener 'click', (e) !->
		# prepare
		e.preventDefault!
		e.stopPropagation!
		e.stopImmediatePropagation!
		if rect.state
			# assemble draw map
			# date format: ISO 8601
			map = ''
			for a,i in rectDraw when a
				# randomize time
				h = 23*Math.random! .|. 0
				m = 59*Math.random! .|. 0
				s = 59*Math.random! .|. 0
				map += ',"'+rect[i].dataset.date+'T'+h+':'+m+':'+s+'+00:00":'+a
			# prepare draw script
			map = drawScript.replace 'heatmap={}', 'heatmap={'+(map.substring 1)+'}'
			map = new Blob [map], {type:'text/plain'}
			# initiate download
			/***
			chrome.downloads.download {
				url: window.URL.createObjectURL m
				filename: 'git-draw.js'
				saveAs: true
			}
			/***/
			# create link
			a = document.createElement 'a'
			a.download = 'git-draw.js'
			a.href = window.URL.createObjectURL map
			# trigger event
			a.click!
	btns.1.addEventListener 'click', (e) !->
		if btns.state
			# de-activate draw
			# set state
			btns.state = false
			btns.1.classList.remove 'on'
			document.body.classList.remove 'git-draw'
			node.forEach (a) !->
				a.classList.remove 'git-draw'
			# reset drawn elements
			if rect.state
				rect.state = 0
				btns.0.classList.remove 'active'
				for a,i in rect when rectDraw[i]
					rectDraw[i] = 0
					i = parseInt a.dataset.count
					a.style.fill = legend[i].style.backgroundColor
			# detach events
			legend.forEach (a) !->
				a.removeEventListener 'click', legendSelect
			rect.forEach (a) !->
				a.removeEventListener 'click', drawPoint
				a.removeEventListener 'pointerenter', drawPoint
				a.removeEventListener 'pointerdown', drawPoint
		else
			# activate draw
			# set state
			btns.state = true
			btns.1.classList.add 'on'
			document.body.classList.add 'git-draw'
			node.forEach (a) !->
				a.classList.add 'git-draw'
			# attach events
			legend.forEach (a) !->
				a.addEventListener 'click', legendSelect
			rect.forEach (a) !->
				a.addEventListener 'click', drawPoint
				a.addEventListener 'pointerenter', drawPoint
				a.addEventListener 'pointerdown', drawPoint
	# }}}
# done



"use strict"
do !->
	###
	# initialize
	# {{{
	# checkout draw area
	node = document.querySelectorAll 'svg.js-calendar-graph-svg'
	if not node or node.length != 1
		# deactivate icon
		chrome.runtime.sendMessage '', {active: false}
		return
	node = node.0
	rect = [...(node.querySelectorAll 'rect.day')]
	# checkout
	opts =
		brushMappings: ['#eee', '#d6e685', '#8cc665', '#44a340', '#1e6823']
		maxCommits: 4
		shade: 1
		script: null
	# ...
	# ...
	# ...
	# activate icon
	chrome.runtime.sendMessage '', {active: true}
	/***
	$("rect[data-count]").each(function(i, item) {
			gf.maxCommits = Math.max(gf.maxCommits, item.getAttribute("data-count"));
	})
	gf.commitBlockSize = Math.ceil(gf.maxCommits/4);
	$(".legend>li").unbind("click").click(gf.setBrush);
	$("svg rect").unbind("click").on("mousedown", gf.colorCell);
	$("svg rect").on("mouseover", gf.cellOver);
	var btnGroupNode = $("<div>").addClass("btn-group");
	var renderBtnNode = $("<button>").text("Render").addClass("btn").addClass("btn-sm");
	var downloadBtnNode = $(renderBtnNode).clone().text("");
	var downloadTextNode = $("<span>").text(" Download Script...");
	var downloadIconNode = $("<span>").addClass("octicon").addClass("octicon-desktop-download");
	$(downloadBtnNode).append(downloadIconNode).append(downloadTextNode);
	$(renderBtnNode).click(gf.output);
	$(downloadBtnNode).click(gf.save);
	$(btnGroupNode).append(downloadBtnNode).append(renderBtnNode);
	$(".contrib-legend > span:first").html("Brush Colors:").next().css("cursor", "pointer").next().remove();
	$(".contrib-footer > div.left").empty().append(btnGroupNode);
	/***/
	# }}}
	# ...
	true





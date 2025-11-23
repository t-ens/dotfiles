// ==UserScript==
// @name         Youtube Element Hider
// @version      0.0.1
// @description  Hides unwanted elements on Youtube pages
// @author       Travis Ens
// @match        *://*.youtube.com/*
// ==/UserScript==

const patterns = [
	"#player",
	"#masthead-ad",
]
setInterval(() => {
	document.querySelectorAll(patterns.join(", ")).forEach((element) => {
		element.remove()
	})
}, 50)

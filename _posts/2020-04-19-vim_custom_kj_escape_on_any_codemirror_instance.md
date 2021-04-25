---
layout: post
title: "Vim custom 'kj' escape on any CodeMirror instance"
comments: true
date: "2020-04-19 19:17:17.752000+00:00"
categories:  [productivity]
tags:  [vim, chrome]
---



https://github.com/codemirror/CodeMirror/issues/2840

Install
https://chrome.google.com/webstore/detail/custom-javascript-for-web/poakhlngfciodnhlhhgnaaelnpjljija?hl=en

```javascript
$(document).ready(function() {
  setTimeout(function() {
    document.querySelector('.CodeMirror').CodeMirror
            .constructor.Vim.map('kj', '<Esc>', 'insert');
    //document.querySelector('.CodeMirror').CodeMirror
    //        .keyMap.default['Shift-Tab'] = 'indentLess';
    document.querySelector('.CodeMirror').CodeMirror
            .addKeyMap({
        'Shift-Tab': 'indentLess',
        'F9': function(cm) {
            cm.replaceSelection('```\n\n```') 
        },
        'F10': function(cm) {
            cm.replaceSelection('<details>\n<summary>\nmore\n</summary>\n\n</details>') 
        },
        'F11': function(cm) {
            cm.replaceSelection('<details>\n<summary>\nmore\n</summary>\n\n```\n\n```\n</details>') 
        },
    })
  }, 2000)
  const copyToClipboard = str => {
	  const el = document.createElement('textarea');
	  el.value = str;
	  document.body.appendChild(el);
	  el.select();
	  document.execCommand('copy');
	  document.body.removeChild(el);
	};
	var myPreDone = new WeakSet()
  setInterval(() => {
	$('#doc').find('pre').each(function (){
		if (myPreDone.has(this)){
			return
		}
		let button = $('<button>', { style: 'font-size:12px;display:none;position:absolute;top:3px;right:3px;z-index:10;color:black;'} ).text('copy');
		let txt = this.innerText;
		this.style.position = 'relative'
		button.get(0).addEventListener('click', function (){
			copyToClipboard(txt);
		});
		this.addEventListener('mouseenter', function (){
			button.show(500)
		})
		this.addEventListener('mouseleave', function (){
			button.hide(200)
		})
		$(this).prepend(button);
		myPreDone.add(this)
	});
  }, 2000)
});
```

```javascript
$(document).ready(function() {
  setTimeout(function() {
    document.querySelector('.CodeMirror').CodeMirror
            .constructor.Vim.map('kj', '<Esc>', 'insert');
    //document.querySelector('.CodeMirror').CodeMirror
    //        .keyMap.default['Shift-Tab'] = 'indentLess';
    document.querySelector('.CodeMirror').CodeMirror
            .addKeyMap({
        'Shift-Tab': 'indentLess',
        'F9': function(cm) {
            cm.replaceSelection('```\n\n```') 
        },
        'F10': function(cm) {
            cm.replaceSelection('<details>\n<summary>\nmore\n</summary>\n\n</details>') 
        },
        'F11': function(cm) {
            cm.replaceSelection('<details>\n<summary>\nmore\n</summary>\n\n```\n\n```\n</details>') 
        },
    })
  }, 2000)
});
``` 

![](/assets/img/UPOWe5wek_a1ca2cc2aef8213ce5dc74567e17cd4c.png)



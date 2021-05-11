---
layout: post
title: "Chrome extension build"
comments: true
date: "2021-05-10 14:50:19.151000+00:00"
---






https://developer.chrome.com/docs/extensions/reference/devtools_network/


```javascript
chrome.devtools.network.onRequestFinished.addListener(
  function(request) {
    if (request.response.bodySize > 40*1024) {
      chrome.devtools.inspectedWindow.eval(
          'console.log("Large image: " + unescape("' +
          escape(request.request.url) + '"))');
    }
  }
);
```






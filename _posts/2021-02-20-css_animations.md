---
layout: post
title: "CSS Animations"
comments: true
date: "2021-02-20 02:37:23.569000+00:00"
---


```
img.img1{
  -webkit-animation: mover1 2s  infinite alternate;
    animation: mover1 2s   infinite alternate;
  z-index:3;
}
@-webkit-keyframes mover1 {
    0% { transform: translateY(0); }
```
{% raw %}
<iframe id="myIframe0" style="border:none;" src="https://crashlaker.github.io/assets/posts_iframe/FKoRBlTm8-0.html"></iframe>
<script>
setTimeout(() => {let myiframe = iFrameResize({ 
                    log: false, 
                    enablePublicMethods: true,
                }, '#myIframe0'); }, 1000)
</script>
{% endraw %}
    

```
img.img1{
  -webkit-animation: mover1 2s  forwards;
    animation: mover1 2s   forwards;
  z-index:3;
}
@-webkit-keyframes mover1 {
    0% { transform: translateY(0); }
    100% { transform: translateY(20px); }
}

```
{% raw %}
<iframe id="myIframe1" style="border:none;" src="https://crashlaker.github.io/assets/posts_iframe/FKoRBlTm8-1.html"></iframe>
<script>
setTimeout(() => {let myiframe = iFrameResize({ 
                    log: false, 
                    enablePublicMethods: true,
                }, '#myIframe1'); }, 1000)
</script>
{% endraw %}
    

```
img.spin {

  perspective: 100px;
  animation: spinner 3s infinite linear;
  transform-style: preserve-3d;
  transform: rotate3d(1,0,0,65deg)
             rotate3d(0,1,0,10deg)
             rotate3d(0,0,1,-45deg);

}
 @keyframes spinner {

0%{
      transform: rotate3d(1,0,0,65deg)
             rotate3d(0,1,0,10deg)
             rotate3d(0,0,1,-45deg);
           }

100% {
      transform: rotate3d(1,0,0,65deg)
             rotate3d(0,1,0,10deg)
             rotate3d(0,0,1,310deg);
      }


}

```
{% raw %}
<iframe id="myIframe2" style="border:none;" src="https://crashlaker.github.io/assets/posts_iframe/FKoRBlTm8-2.html"></iframe>
<script>
setTimeout(() => {let myiframe = iFrameResize({ 
                    log: false, 
                    enablePublicMethods: true,
                }, '#myIframe2'); }, 1000)
</script>
{% endraw %}
    
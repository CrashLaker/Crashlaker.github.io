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
crash_iframe[http://automation/blog/css-animation/anim1.html]

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
crash_iframe[http://automation/blog/css-animation/anim2.html]

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
crash_iframe[http://automation/blog/css-animation/anim3.html]
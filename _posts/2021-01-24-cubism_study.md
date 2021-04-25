---
layout: post
title: "Cubism Study"
comments: true
date: "2021-01-24 16:48:14.652000+00:00"
---

# Concepts

https://bernatgel.github.io/karyoploter_tutorial/Tutorial/PlotHorizon/PlotHorizon.html

![](/assets/img/Sf8kW-XxU_horizon.animation.optimized.gif)

# Code

https://github.com/square/cubism/blob/master/cubism.v1.js
```javascript
// consistent overplotting
var round = start / context.step() & 1
    ? cubism_comparisonRoundOdd
    : cubism_comparisonRoundEven;

// positive changes
canvas.fillStyle = colors[2];
for (var i = 0, n = width; i < n; ++i) {
  var y0 = scale(primary_.valueAt(i)),
      y1 = scale(secondary_.valueAt(i));
  if (y0 < y1) canvas.fillRect(round(i), y0, 1, y1 - y0);
}

// negative changes
canvas.fillStyle = colors[0];
for (i = 0; i < n; ++i) {
  var y0 = scale(primary_.valueAt(i)),
      y1 = scale(secondary_.valueAt(i));
  if (y0 > y1) canvas.fillRect(round(i), y1, 1, y0 - y1);
}

// positive values
canvas.fillStyle = colors[3];
for (i = 0; i < n; ++i) {
  var y0 = scale(primary_.valueAt(i)),
      y1 = scale(secondary_.valueAt(i));
  if (y0 <= y1) canvas.fillRect(round(i), y0, 1, strokeWidth);
}

// negative values
canvas.fillStyle = colors[1];
for (i = 0; i < n; ++i) {
  var y0 = scale(primary_.valueAt(i)),
      y1 = scale(secondary_.valueAt(i));
  if (y0 > y1) canvas.fillRect(round(i), y0 - strokeWidth, 1, strokeWidth);
}

canvas.restore();
}
```

# Examples

* https://bl.ocks.org/tomshanley/2e783361974c41d401993cc4aaae7e8a

![](/assets/img/Sf8kW-XxU_db2367f053a26db52e88432dd2634416.png)

* http://bl.ocks.org/tomshanley/61b8c01eb29130a0061b549931315c42
![](/assets/img/Sf8kW-XxU_e3ac2b47e97684f830b76fe7b4c8da15.png)

* https://bl.ocks.org/tomshanley/dd93d10cc2959f72b2bc3858bf486075
![](/assets/img/Sf8kW-XxU_60c216367adad635644984e353aff743.png)

* http://bl.ocks.org/tomshanley/1d58d9d4ab24b5fc3d16901c02229c62
![](/assets/img/Sf8kW-XxU_8fded50f59fae431e952c06b43aa62d2.png)


* https://bl.ocks.org/kmandov/dcb94f02e71e3560eb3255f2de3120e4
![](/assets/img/Sf8kW-XxU_f17740b708931018c877c80fc42a037c.png)

* https://bl.ocks.org/kmandov/6e91165d4f32534ec4cab806b18b6684
![](/assets/img/Sf8kW-XxU_3ff927b713b93321f4ccd7dfcc447ee0.png)


* https://bl.ocks.org/kmandov/a1abe4aa380fb8b4bd0b4c081a76ce13

![](/assets/img/Sf8kW-XxU_edc4b1c76fb1858e76aed3669544e8e0.png)

# Others

https://towardsdatascience.com/using-strip-charts-to-visualize-dozens-of-time-series-at-once-a983baabb54f

![](/assets/img/Sf8kW-XxU_a43b7fa80c8302e48579845d6af18f75.png)

![](/assets/img/Sf8kW-XxU_9cf077cab21a407ecfc62f8f68e8343d.png)



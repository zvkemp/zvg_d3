// Generated by CoffeeScript 1.6.2
(function() {
  ZVG.Map = (function() {
    function Map(options) {
      options || (options = {});
      this.width = options.width || 1200;
      this.height = options.height || 600;
      this.scale(options.scale);
      this.center(options.center);
      this.parallels(options.parallels);
      this.constructProjection();
      this.constructPath();
      this.appendSvg(options.element || 'body');
    }

    Map.prototype.appendSvg = function(element) {
      return this.svg = d3.select(element).append('svg').attr('width', this.width).attr('height', this.height);
    };

    Map.prototype.data = function(d) {
      if (d) {
        this._data = d;
        return this;
      }
      return this._data;
    };

    Map.prototype.feature = function(f) {
      if (f) {
        this._feature = f;
        return this;
      }
      return this._feature;
    };

    Map.prototype.projection = function(p) {
      if (p) {
        this._projection = p;
        return this;
      }
      return this._projection;
    };

    Map.prototype.scale = function(s) {
      if (s) {
        this._scale = s;
        return this;
      }
      return this._scale;
    };

    Map.prototype.center = function(d) {
      if (d) {
        this._center = [0, d[1]];
        this._rotate = [d[0], 0, 0];
        return this;
      }
      return this._center;
    };

    Map.prototype.parallels = function(d) {
      if (d) {
        this._parallels = d;
        return this;
      }
      return this._parallels;
    };

    Map.prototype.colors = function(d) {
      if (d) {
        this._colors = d;
        return this;
      }
      return this._colors;
    };

    Map.prototype.fillStrategy = function(d) {
      if (d) {
        this._fillStrategy = d;
        return this;
      }
      return this._fillStrategy;
    };

    Map.prototype.constructProjection = function() {
      return this._projection = d3.geo.albers().scale(this.scale()).rotate(this._rotate).center(this.center()).parallels(this.parallels()).translate([this.width / 2, this.height / 2]);
    };

    Map.prototype.constructPath = function() {
      return this.path = d3.geo.path().projection(this._projection);
    };

    Map.prototype.applyBackground = function() {
      new ZVG.Background(this.svg, this.height, this.width, 0);
      return this;
    };

    Map.prototype.outline = function(datum, color) {
      if (color == null) {
        color = 'black';
      }
      this.outlineShouldBeApplied = true;
      this.outlineColor = color;
      this.outlineDatum = datum;
      return this;
    };

    Map.prototype.applyOutline = function() {
      console.log('applyOutline');
      return this.svg.append('path').datum(this.outlineDatum).attr('class', 'outline').attr('d', this.path).style('stroke', this.outlineColor).style('stroke-width', '1pt').style('fill', 'none');
    };

    Map.prototype.render = function() {
      var _this = this;

      this.svg.selectAll('.zip').data(this._feature.features).enter().append('path').attr('class', function(d) {
        return "zip z" + d.id;
      }).attr('d', this.path).style('fill', function(d) {
        return _this._colors(_this._fillStrategy(d));
      });
      if (this.outlineShouldBeApplied) {
        return this.applyOutline();
      }
    };

    return Map;

  })();

  window.map = new ZVG.Map({
    scale: 43000,
    center: [122.4100, 37.7800],
    parallels: [35, 36]
  });

  d3.json('data/calpop.json', function(e, population) {
    var k, maxPopulation, x;

    maxPopulation = d3.max((function() {
      var _results;

      _results = [];
      for (k in population) {
        x = population[k];
        _results.push(parseInt(x));
      }
      return _results;
    })());
    return d3.json('data/california_zips3.json', function(e, zips) {
      var populationScale;

      populationScale = d3.scale.linear().domain([0, maxPopulation / 4, maxPopulation]).range(['white', ZVG.flatUIColors['PETER RIVER'], 'red']);
      map.feature(topojson.feature(zips, zips.objects.california_zips)).colors(populationScale).fillStrategy(function(d) {
        return population[d.id] || 0;
      }).outline(topojson.mesh(zips, zips.objects.california_zips, function(a, b) {
        return a === b && a.id === b.id;
      }), 'black').render();
      return window.map = map;
    });
  });

}).call(this);

// Generated by CoffeeScript 1.6.3
(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  ZVG.Column = (function(_super) {
    __extends(Column, _super);

    function Column() {
      this.computeFontSize = __bind(this.computeFontSize, this);
      this.valueFunction_count = __bind(this.valueFunction_count, this);
      this.valueFunction_percentage = __bind(this.valueFunction_percentage, this);
      this.valueHeightFunction = __bind(this.valueHeightFunction, this);
      this.buildSeriesDomains_count = __bind(this.buildSeriesDomains_count, this);
      this.buildSeriesDomains_percentage = __bind(this.buildSeriesDomains_percentage, this);
      var _this = this;
      d3.select('body').append('button').text('randomize').on('click', function() {
        return _this.randomizeData();
      });
      d3.select('body').append('button').text('standard sample data').on('click', function() {
        _this.data(_this.sample_data);
        return _this.render(_this.renderMode);
      });
      d3.select('body').append('button').text('show percentages').on('click', function() {
        return _this.render('percentage');
      });
      d3.select('body').append('button').text('show counts').on('click', function() {
        return _this.render('count');
      });
      d3.select('body').append('br');
      this.initializeSvg();
    }

    Column.prototype.randomizeData = function(s1count, s2count, s3count) {
      var raw, s, _fn, _i, _j, _len, _ref, _results;
      s1count || (s1count = parseInt(Math.random() * 15 + 1));
      s2count || (s2count = parseInt(Math.random() * 15 + 1));
      s3count || (s3count = parseInt(Math.random() * 8 + 2));
      raw = [];
      _ref = (function() {
        _results = [];
        for (var _j = 1; 1 <= s1count ? _j <= s1count : _j >= s1count; 1 <= s1count ? _j++ : _j--){ _results.push(_j); }
        return _results;
      }).apply(this);
      _fn = function(s) {
        var f, s2actual, _k, _l, _len1, _ref1, _results1, _results2;
        s2actual = parseInt(Math.random() * s2count) + 1;
        _ref1 = (function() {
          _results2 = [];
          for (var _l = 1; 1 <= s2actual ? _l <= s2actual : _l >= s2actual; 1 <= s2actual ? _l++ : _l--){ _results2.push(_l); }
          return _results2;
        }).apply(this);
        _results1 = [];
        for (_k = 0, _len1 = _ref1.length; _k < _len1; _k++) {
          f = _ref1[_k];
          _results1.push((function(f) {
            var d, _len2, _m, _n, _ref2, _results3, _results4;
            _ref2 = (function() {
              _results4 = [];
              for (var _n = 1; 1 <= s3count ? _n <= s3count : _n >= s3count; 1 <= s3count ? _n++ : _n--){ _results4.push(_n); }
              return _results4;
            }).apply(this);
            _results3 = [];
            for (_m = 0, _len2 = _ref2.length; _m < _len2; _m++) {
              d = _ref2[_m];
              _results3.push((function(d) {
                return raw.push({
                  series_1: "Survey " + s,
                  series_2: "Filter " + f,
                  series_3: d,
                  value: parseInt(Math.random() * 150)
                });
              })(d));
            }
            return _results3;
          })(f));
        }
        return _results1;
      };
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        s = _ref[_i];
        _fn(s);
      }
      this.data(raw);
      return this.render(this.renderMode);
    };

    Column.prototype.nestData = function(d) {
      return d3.nest().key(function(z) {
        return z.series_1;
      }).key(function(z) {
        return z.series_2;
      }).key(function(z) {
        return z.series_3;
      }).entries(d);
    };

    Column.prototype.color = d3.scale.ordinal().range(ZVG.colorSchemes.warmCool10);

    Column.prototype.resetWidth = function() {
      return this.widenChart(ZVG.BasicChart.prototype.width);
    };

    Column.prototype.render = function(renderMode) {
      if (renderMode == null) {
        renderMode = 'percentage';
      }
      this.renderMode = renderMode;
      this.resetWidth();
      this.setSeries1Spacing();
      this.renderSeries1();
      this.buildSeriesDomains();
      this.renderSeries2();
      this.appendSeries1Labels();
      this.appendSeries2Labels();
      this.initializeY();
      this.initializeLabels();
      this.renderSeries3();
      this.renderSeries3Labels();
      this.bindValueGroupHover();
      return this.renderLegend();
    };

    Column.prototype.setSeries1Spacing = function() {
      var current_x, d, i, maxCount, ranges, scale, totalColumnCount, _fn, _i, _j, _k, _len, _len1, _ref, _ref1, _results,
        _this = this;
      this.series1width = [];
      this.series1x = [];
      scale = d3.scale.ordinal().domain((function() {
        var _i, _len, _ref, _results;
        _ref = this.raw_data;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          d = _ref[_i];
          _results.push(d.series_1);
        }
        return _results;
      }).call(this));
      ranges = {};
      totalColumnCount = 0;
      _ref = this._data;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        d = _ref[_i];
        totalColumnCount += d.values.length;
      }
      this.columnSpacing = this.width / (totalColumnCount + this._data.length);
      this.columnPadding = 0.1 * this.columnSpacing;
      this.seriesPadding = this.columnSpacing / 2;
      current_x = 0;
      maxCount = d3.max(this._data, function(d) {
        return d.values.length;
      });
      _ref1 = this._data;
      _fn = function(d, i) {
        var w;
        w = _this.columnSpacing * (d.values.length + 1);
        _this.series1width[i] = w - _this.seriesPadding * 2;
        _this.series1x[i] = current_x + _this.seriesPadding;
        return current_x += w;
      };
      for (i = _j = 0, _len1 = _ref1.length; _j < _len1; i = ++_j) {
        d = _ref1[i];
        _fn(d, i);
      }
      this.columnBand = d3.scale.ordinal().domain((function() {
        _results = [];
        for (var _k = 0; 0 <= maxCount ? _k < maxCount : _k > maxCount; 0 <= maxCount ? _k++ : _k--){ _results.push(_k); }
        return _results;
      }).apply(this)).rangeRoundBands([0, this.columnSpacing * maxCount], 0.1);
      if (this.columnBand.rangeBand() < 20) {
        return this.widenChart(this.width + 100);
      }
    };

    Column.prototype.widenChart = function(width) {
      this.width = width;
      this.svg.attr('width', this.width);
      this.background.attr('width', this.width);
      return this.setSeries1Spacing();
    };

    Column.prototype.series1TotalWidth = function() {
      return this.width / this._data.length;
    };

    Column.prototype.renderSeries1 = function() {
      var _this = this;
      this.series_1 = this.svg.selectAll('.series1').data(this._data);
      this.series_1.enter().append('g').attr('class', 'series1');
      this.series_1.attr('transform', function(d, i) {
        return "translate(" + _this.series1x[i] + ", 0)";
      });
      return this.series_1.exit().remove();
    };

    Column.prototype.buildSeriesDomains = function() {
      return this["buildSeriesDomains_" + this.renderMode]();
    };

    Column.prototype.buildSeriesDomains_percentage = function() {
      var s1, _i, _len, _ref, _results,
        _this = this;
      this.series3Domains = {};
      _ref = this._data;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        s1 = _ref[_i];
        _results.push((function(s1) {
          var s2, _j, _len1, _ref1, _results1;
          _this.series3Domains[s1.key] = {};
          _ref1 = s1.values;
          _results1 = [];
          for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
            s2 = _ref1[_j];
            _results1.push((function(s2) {
              var d, s3;
              s3 = (function() {
                var _k, _len2, _ref2, _results2;
                _ref2 = s2.values;
                _results2 = [];
                for (_k = 0, _len2 = _ref2.length; _k < _len2; _k++) {
                  d = _ref2[_k];
                  _results2.push(d.values[0].value);
                }
                return _results2;
              })();
              return _this.series3Domains[s1.key][s2.key] = d3.scale.linear().domain([0, d3.sum(s3)]).range([0, _this.height]);
            })(s2));
          }
          return _results1;
        })(s1));
      }
      return _results;
    };

    Column.prototype.buildSeriesDomains_count = function() {
      var maxScale, maxSum, s1, _fn, _i, _j, _len, _len1, _ref, _ref1, _results,
        _this = this;
      maxSum = 0;
      _ref = this._data;
      _fn = function(s1) {
        var s2, _j, _len1, _ref1, _results;
        _ref1 = s1.values;
        _results = [];
        for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
          s2 = _ref1[_j];
          _results.push((function(s2) {
            var d, s3;
            s3 = d3.sum((function() {
              var _k, _len2, _ref2, _results1;
              _ref2 = s2.values;
              _results1 = [];
              for (_k = 0, _len2 = _ref2.length; _k < _len2; _k++) {
                d = _ref2[_k];
                _results1.push(d.values[0].value);
              }
              return _results1;
            })());
            if (s3 > maxSum) {
              return maxSum = s3;
            }
          })(s2));
        }
        return _results;
      };
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        s1 = _ref[_i];
        _fn(s1);
      }
      maxScale = d3.scale.linear().range([0, this.height]).domain([0, maxSum]);
      this.series3Domains = {};
      _ref1 = this._data;
      _results = [];
      for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
        s1 = _ref1[_j];
        _results.push((function(s1) {
          var s2, _k, _len2, _ref2, _results1;
          _this.series3Domains[s1.key] = {};
          _ref2 = s1.values;
          _results1 = [];
          for (_k = 0, _len2 = _ref2.length; _k < _len2; _k++) {
            s2 = _ref2[_k];
            _results1.push((function(s2) {
              return _this.series3Domains[s1.key][s2.key] = maxScale;
            })(s2));
          }
          return _results1;
        })(s1));
      }
      return _results;
    };

    Column.prototype.renderSeries2 = function() {
      var _this = this;
      this.series_2 = this.series_1.selectAll('.series2').data(function(d) {
        return d.values;
      });
      this.series_2.enter().append('g').attr('class', 'column series2').attr('transform', "translate(0,0)");
      this.series_2.attr('label', function(d) {
        return d.key;
      }).transition().duration(300).attr('transform', function(d, i) {
        return "translate(" + (_this.columnBand(i)) + ", 0)";
      });
      return this.series_2.exit().attr('transform', "translate(0,0)").remove();
    };

    Column.prototype.renderSeries3 = function() {
      var current_y,
        _this = this;
      this.series_3 = this.series_2.selectAll('rect.vg').data(function(d) {
        return d.values;
      });
      this.series_3.enter().append("rect").attr("class", 'vg').attr('x', 0).attr('y', this.height).attr('height', 0);
      current_y = this.height;
      this.series_3.style('fill', function(d) {
        return _this.color(d.key);
      }).attr('width', this.columnBand.rangeBand()).transition().delay(200).duration(500).attr('y', function(d, i) {
        var h;
        if (i === 0) {
          current_y = _this.height;
        }
        h = _this.valueHeightFunction(d);
        current_y -= h;
        return current_y;
      }).attr('class', function(d, i) {
        return "vg";
      }).attr('height', this.valueHeightFunction);
      return this.series_3.exit().remove();
    };

    Column.prototype.bindValueGroupHover = function() {
      var vg,
        _this = this;
      vg = this.svg.selectAll('.vg');
      return vg.on('mouseover', function(d) {
        return vg.filter(function(e) {
          return e.key !== d.key;
        }).attr('opacity', 0.2);
      }).on('mouseout', function(d) {
        return _this.svg.selectAll('.vg').attr('opacity', 1);
      });
    };

    Column.prototype.valueHeightFunction = function(d) {
      var dp;
      dp = d.values[0];
      return this.series3Domains[dp.series_1][dp.series_2](dp.value);
    };

    Column.prototype.valueFunction_percentage = function(d) {
      var dp, n;
      dp = d.values[0];
      n = this.series3Domains[dp.series_1][dp.series_2].domain()[1];
      return this.percentFormat(dp.value / n);
    };

    Column.prototype.valueFunction_count = function(d) {
      return d.values[0].value;
    };

    Column.prototype.valueFunction = function() {
      return this["valueFunction_" + this.renderMode];
    };

    Column.prototype.renderSeries3Labels = function(textFunction) {
      var computeFontSize, current_y, valueHeightFunction,
        _this = this;
      if (textFunction == null) {
        textFunction = this.valueFunction();
      }
      this.series_2.selectAll('text.vg').remove();
      this.series_3_labels = this.series_2.selectAll('text.vg').data(function(d) {
        return d.values;
      });
      current_y = this.height;
      this.series_3_labels.enter().append('text').attr('class', 'vg column-label').attr('x', this.columnBand.rangeBand() / 2).attr('y', function(d, i) {
        var h;
        if (i === 0) {
          current_y = _this.height;
        }
        h = _this.valueHeightFunction(d);
        current_y -= h;
        return current_y + h / 2;
      }).attr('opacity', 0).transition().delay(500).attr('opacity', 1);
      computeFontSize = this.computeFontSize;
      valueHeightFunction = this.valueHeightFunction;
      this.series_3_labels.text(textFunction);
      return this.series_3_labels.style('font-size', function(d) {
        return computeFontSize(this, valueHeightFunction(d));
      });
    };

    Column.prototype.computeFontSize = function(node, maxHeight) {
      return "" + (d3.min([10, this.columnBand.rangeBand() / 3, maxHeight])) + "pt";
    };

    Column.prototype.appendSeries2Borders = function() {
      this.borders = this.series_2.selectAll('.border').data(function(d) {
        return d.key;
      });
      this.borders.enter().append('rect').attr('class', 'border');
      return this.borders.style('stroke', 'white').style('stroke-width', '1pt').style('fill', 'none').attr('x', 0).attr('y', this.height).attr('height', 0).attr('width', this.columnBand.rangeBand()).attr('opacity', 0).transition().delay(300).duration(700).attr('y', 0).attr('height', this.height).attr('opacity', 1);
    };

    Column.prototype.percentScale = d3.scale.linear().range([0, 1]);

    Column.prototype.percentFormat = d3.format('.0%');

    Column.prototype.countFormat = d3.format('.0');

    Column.prototype.initializeY = function() {
      this.y = d3.scale.linear().range([0, this.height]);
      return this.current_y = 0;
    };

    Column.prototype.initializeLabels = function() {
      this.labels = d3.scale.linear().range([0, 1]);
      return this.percent = d3.format('.0%');
    };

    Column.prototype.appendSeries1Labels = function() {
      var _this = this;
      this.series_1_labels = this.svg.selectAll('text.series1label').data(this._data);
      this.series_1_labels.enter().append('text').attr('class', 'series1label');
      this.series_1_labels.attr('y', this.height + 20).text(function(d) {
        return d.key;
      }).attr('x', function(d, i) {
        return _this.series1x[i] + _this.series1width[i] / 2;
      });
      return this.series_1_labels.exit().remove();
    };

    Column.prototype.appendSeries2Labels = function() {
      var series_2_labels,
        _this = this;
      this.svg.selectAll('.series2label').remove();
      series_2_labels = this.series_1.selectAll('text.series2label').data(function(d) {
        return d.values;
      });
      series_2_labels.enter().append('text').attr('class', 'series2label');
      return series_2_labels.attr('y', this.height + 10).attr('x', function(d, i) {
        return _this.columnBand(i) + _this.columnBand.rangeBand() / 2;
      }).text(function(d) {
        return d.key;
      });
    };

    return Column;

  })(ZVG.BasicChart);

  window.chart = new ZVG.Column;

  chart.randomizeData();

  chart.render();

  chart.sample_data = [
    {
      series_1: 'Survey 1',
      series_2: 'Filter 1',
      series_3: 1,
      value: 100
    }, {
      series_1: 'Survey 1',
      series_2: 'Filter 1',
      series_3: 2,
      value: 200
    }, {
      series_1: 'Survey 1',
      series_2: 'Filter 2',
      series_3: 1,
      value: 200
    }, {
      series_1: 'Survey 1',
      series_2: 'Filter 2',
      series_3: 2,
      value: 300
    }, {
      series_1: 'Survey 1',
      series_2: 'Filter 4',
      series_3: 1,
      value: 100
    }, {
      series_1: 'Survey 1',
      series_2: 'Filter 4',
      series_3: 2,
      value: 400
    }, {
      series_1: 'Survey 2',
      series_2: 'Filter 1',
      series_3: 1,
      value: 100
    }, {
      series_1: 'Survey 2',
      series_2: 'Filter 1',
      series_3: 2,
      value: 200
    }, {
      series_1: 'Survey 2',
      series_2: 'Filter 3',
      series_3: 1,
      value: 200
    }, {
      series_1: 'Survey 2',
      series_2: 'Filter 3',
      series_3: 2,
      value: 300
    }, {
      series_1: 'Survey 3',
      series_2: 'Filter 3',
      series_3: 1,
      value: 100
    }, {
      series_1: 'Survey 3',
      series_2: 'Filter 3',
      series_3: 2,
      value: 200
    }, {
      series_1: 'Survey 3',
      series_2: 'Filter 2',
      series_3: 1,
      value: 200
    }, {
      series_1: 'Survey 3',
      series_2: 'Filter 2',
      series_3: 2,
      value: 300
    }
  ];

}).call(this);

window.ZVG = {
  flatUIColors: {
    # from http://designmodo.github.io/Flat-UI/
    'TURQUOISE': '#1ABC9C'
    'GREEN SEA': '#16A085'
    'EMERALD': '#2ECC71'
    'NEPHRITIS': '#27AE60'
    'PETER RIVER': '#3498DB'
    'BELIZE HOLE': '#2980B9'
    'AMETHYST': '#9B59B6'
    'WISTERIA': '#8E44AD'
    'WET ASPHALT': '#34495E'
    'MIDNIGHT BLUE': '#2C3E50'
    'SUN FLOWER': '#F1C40F'
    'ORANGE': '#F39C12'
    'CARROT': '#E67E22'
    'PUMPKIN': '#D35400'
    'ALIZARIN': '#E74C3C'
    'POMEGRANATE': '#C0392B'
    'CLOUDS': '#ECF0F1'
    'SILVER': '#BDC3C7'
    'CONCRETE': '#95A5A6'
    'ASBESTOS': '#7F8C8D'
  }
}

class ZVG.BackgroundGradient
  constructor: (svg) ->
    @gradient = svg.append('defs')
      .append('linearGradient')
      .attr('x1', '0%').attr('y1', '0%')
      .attr('x2', '80%').attr('y2', '50%')
      .attr('spreadMethod', 'pad')
      .attr('id', 'standardBackgroundGradient')
    @gradient.append('stop')
      .attr('offset', '10%')
      .attr('stop-color', '#aaa')
      .attr('stop-opacity', 1)
    @gradient.append('stop')
      .attr('offset', '110%')
      .attr('stop-color', '#777')
      .attr('stop-opacity', 1)
#    @shadow = svg.select('defs')
#      .append('filter')
#      .attr('id', 'drop_shadow')
#      .attr('x', 0)
#      .attr('y', 0)
#      .attr('width', '200%')
#      .attr('height', '200%')
#    @shadow.append('feOffset')
#      .attr('result', 'offOut')
#      .attr('in', 'SourceAlpha')
#      .attr('dx', 2)
#      .attr('dy', 2)
#    @shadow.append('feGaussianBlur')
#      .attr('result', 'blurOut')
#      .attr('in', 'offOut')
#      .attr('stdDeviation', 20)
#    @shadow.append('feBlend')
#      .attr('in', 'SourceGraphic')
#      .attr('in2', 'blurOut')
#      .attr('mode', 'normal')
#
class ZVG.Background
  constructor: (svg, height, width, radius = 5) ->

    ZVG.BackgroundGradient(svg)
    backgroundGroup = svg.append('g')
    @background = backgroundGroup.append('rect')
      .attr('fill', ZVG.flatUIColors['CLOUDS'])
      # .style('fill', 'url(#standardBackgroundGradient)')
      #.style('fill', ZVG.flatUIColors['MIDNIGHT BLUE'])
      .attr('height', height)
      .attr('width', width)
      .attr('rx', radius)
      .attr('ry', radius)


class ZVG.BasicChart
  width: 900
  height: 500

  data: (d) ->
    if d
      @raw_data = d
      @_data = @nestData(d)
      return @
    @_data

  nestData: (d) ->
    d3.nest()
      .key((z) -> z.series_1)
      .key((z) -> z.series_2)
      .entries(d)

  series_1_domain: (d) ->
    if d
      @_series_1_domain = d
      return @
    @_series_1_domain

  series_2_domain: (d) ->
    if d
      @_series_2_domain = d
      return @
    @_series_2_domain

  initializeSvg: ->
    @svg = d3.select('body').append('svg')
      .attr('height', @height + 200).attr('width', @width + 200)
    @background = (new ZVG.Background(@svg, @height, @width)).background

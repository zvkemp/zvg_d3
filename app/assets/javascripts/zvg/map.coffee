class ZVG.Map
  constructor: (options) ->
    options or= {}
    @width  = options.width or 1200
    @height = options.height or 600
    @scale(options.scale)
    @center(options.center)
    @parallels(options.parallels)
    @constructProjection()
    @constructPath()
    @appendSvg(options.element or 'body')

  appendSvg: (element) ->
    @svg = d3.select(element).append('svg')
      .attr('width', @width)
      .attr('height', @height)

    

  data: (d) ->
    if d
      @_data = d
      return @
    @_data

  feature: (f) ->
    if f
      @_feature = f
      return @
    @_feature

  projection: (p) ->
    if p
      @_projection = p
      return @
    @_projection

  scale: (s) ->
    if s
      @_scale = s
      return @
    @_scale

  center: (d) ->
    if d
      @_center = [0, d[1]]
      @_rotate = [d[0], 0, 0]
      return @
    @_center

  parallels: (d) ->
    if d
      @_parallels = d
      return @
    @_parallels

  colors: (d) ->
    if d
      @_colors = d
      return @
    @_colors

  fillStrategy: (d) ->
    if d
      @_fillStrategy = d
      return @
    @_fillStrategy

  constructProjection: ->
    @_projection = d3.geo.albers()
      .scale(@scale())
      .rotate(@_rotate)
      .center(@center())
      .parallels(@parallels())
      .translate([@width/2,@height/2])
  constructPath: ->
    @path = d3.geo.path()
      .projection(@_projection)

  applyBackground: ->
    new ZVG.Background(@svg, @height, @width, 0)
    @

  outline: (datum, color = 'black') ->
    @outlineShouldBeApplied = true
    @outlineColor = color
    @outlineDatum = datum
    @

  applyOutline: ->
    console.log('applyOutline')
    @svg.append('path')
      .datum(@outlineDatum)
      .attr('class', 'outline')
      .attr('d', @path)
      .style('stroke', @outlineColor)
      .style('stroke-width', '1pt')
      .style('fill', 'none')

  _render: () ->
    @svg.selectAll('.zip')
      .data(@_feature.features)
      .enter()
      .append('path')
      .attr('class', (d) -> "zip z#{d.id}")
      .attr('d', @path)
      .style('fill', (d) => @_colors(@_fillStrategy(d)))
    @applyOutline() if @outlineShouldBeApplied





window.map = new ZVG.Map({
  scale: 43000
  center: [122.4100, 37.7800]
  parallels: [35,36]
})

d3.json('data/calpop.json', (e, population) ->
  maxPopulation = d3.max(parseInt(x) for k,x of population)
  
  d3.json('data/california_zips3.json', (e, zips) ->
    populationScale = d3.scale.linear()
      .domain([0,maxPopulation/4, maxPopulation])
      .range(['white', ZVG.flatUIColors['PETER RIVER'], 'red'])
    map.feature(topojson.feature(zips, zips.objects.california_zips))
      .colors(populationScale)
      .fillStrategy((d) -> population[d.id] or 0 )
      .outline(topojson.mesh(zips, zips.objects.california_zips, (a,b) -> a == b and a.id == b.id), 'black')
      .render()

    window.map = map
  )
)

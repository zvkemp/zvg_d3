
width = 1660
height = 1660

svg = d3.select('body').append('svg')
  .attr('width', width)
  .attr('height', height)

colors = d3.scale.category10()

d3.json('data/california_zips3.json', (error, zips) ->
  console.log(zips)
  window.zips = zips

  calizips = topojson.feature(zips, zips.objects.california_zips)
  projection = d3.geo.albers()
    .scale(8000)
    .rotate([122.2500, 0, 0])
    .center([0, 37.0500])
    .parallels([36, 35])
    .translate([width/4, height / 2])
  window.projection = projection
  path = d3.geo.path()
    .projection(projection)

  d3.json('data/calpop.json', (error, pop) ->
    max = 0
    window.pop = pop

    (max = parseInt(v) if parseInt(v) > max) for k, v of pop
    console.log('max', max)
    colors = d3.scale.linear()
      .domain([0, max/2,  max])
      .range(['#fff','#f00'])
    window.colors = colors
    svg.selectAll('.zip')
      .data(topojson.feature(zips, zips.objects.california_zips).features)
      .enter().append('path')
      .attr('class', (d) -> "zip z#{d.id}")
      .attr('d', path)
      .style('fill', (d) ->
        p = parseInt(pop[d.id])
        p = 0 unless p
        colors(p)
      )
      .attr('title', (d) -> d.id)
    svg.append('path')
      .datum(topojson.mesh(zips, zips.objects.california_zips, (a,b) -> a == b and a.id == b.id))
      .attr('d', path)
      .style('stroke', '#555')
      .style('stroke-width', '2pt')
      .style('fill', 'none')
  )
)

class ZVG.Rose extends ZVG.Radar
  petal_points: (amplitude, domainIndex) ->
    start = { x: 0, y: 0 }
    middleA = @convertToXY(amplitude / 2.0, domainIndex - 0.5)
    middleB = @convertToXY(amplitude / 2.0, domainIndex + 0.5)
    end = @convertToXY(amplitude, domainIndex)
    [start, middleA, end, middleB]

  renderSeries: ->
    host = @
    pg_data = @polygonData()
    polygon_groups = @polygons.selectAll('g.pgroup')
      .data(pg_data, (k) -> k.key)

    polygon_groups.enter()
      .append('g')
      .attr('class', "pgroup #{@value_group_selector.substr(1,100)}")

    polygons = polygon_groups.selectAll('path.polygon')
      .data((d) -> d.points)

    polygons.enter()
      .append('path')
      .attr('class', "polygon #{@value_group_selector.substr(1,100)}")
      .attr('d', (d) => @polygon({ x: 0, y: 0} for point in d.points))
      .style('fill-opacity', 0.4)

    polygons.attr('label', (d) -> d.key)
      .transition().duration(500)
      .attr('d', (d) => @polygon(d.points))
      .style('stroke', (d) =>
        # FIXME
        # t = @_n_threshold
        # mock_n = if d.n_values.some((n) -> n < t)
        #   0
        # else
        #   d.n_values[0]
        # @n_threshold_color('white')({ n: mock_n })
        'white'
      ).style('fill', (d) => @colors(d.key))

    hover_label_groups = @polygons.selectAll('g.label-hover')
      .data(pg_data)
    hover_label_groups.enter()
      .append('g').attr('class', 'label-hover')
    hover_label_groups
      .style('opacity', 0)
      .each(-> host.applyHoverLabels(this))
    hover_label_groups.exit().remove()

    polygons.exit().remove()

  _polygonDataPoints: (amplitude, domainIndex, key) ->
    { key: key, points: @petal_points(amplitude, domainIndex) }

Dashboard.verbatim = ->

  _chart          = {}
  _data           = []
  _seriesDomain   = []
  _filterDomain   = []
  question_tables = null
  series_selector = d3.select('#verbatims').select('#series_selector')
  filter_selector = d3.select('#verbatims').select('#filter_selector')
  page = 1
  _colors = d3.scale.category10()

  _chart.colors = ->
    return _colors

  _chart.data = (d) ->
    unless d
      return _data

    _data = d
    _chart

  _chart.seriesDomain = (d) ->
    return _seriesDomain unless d
    _seriesDomain = d
    appendSelectorOptions(series_selector, _seriesDomain)
    _chart

  _chart.filterDomain = (d) ->
    return _filterDomain unless d
    _filterDomain = d
    appendSelectorOptions(filter_selector, _filterDomain)
    _colors.domain(_filterDomain)
    _chart

  _chart.render = (options) ->
    options = {} unless options
    renderQuestionTables(options)

  currentSelectedOptions = ->
    {
      series_1: _seriesDomain[series_selector[0][0].selectedIndex - 1]
      series_2: _filterDomain[filter_selector[0][0].selectedIndex - 1]
      page: page
    }

  appendSelectorOptions = (selector, domain) ->
    selector.selectAll('option')
      .data(['[all]'].concat(domain))
      .enter()
      .append('option')
      .attr('value', (d) -> d)
      .text((d) -> d)
    selector.on('change', -> _chart.render(currentSelectedOptions()))


  renderQuestionTables = (options) ->
    question_table = d3.select("#verbatims").select('table.verbatim')
    dataFilter = (d) ->
      s = options.series_1 if options.series_1 && options.series_1 != '[all]'
      f = options.series_2 if options.series_2 && options.series_2 != '[all]'
      d.filter((e) -> if s then e.series_1 == s else e)
        .filter((e) -> if f then e.series_2 == f else e)
        .slice(0, 14)

    rows = question_table.selectAll('tr')
      .data(dataFilter(_data))

    rows.enter()
      .append('tr')
      .attr('class', 'response')
    
    rows.exit().remove()
    rows.selectAll('td').remove()
    rows.style('color', (d) -> _colors(d.series_2))
    rows.append('td')
      .text((d) -> d.id)
    rows.append('td')
      .text((d) -> d.series_1)
    rows.append('td')
      .text((d) -> d.series_2)
    rows.append('td')
      .text((d) -> d.value)

  _chart


d3.json('data/verbatims_age.json', (error, json) ->
  window.data = json.filter((d) -> d.question == 182)
  sd = d3.scale.ordinal().domain(data.map((d) -> d.series_1)).domain()
  fd = d3.scale.ordinal().domain(data.map((d) -> d.series_2)).domain()
  window.chart = Dashboard.verbatim()
    .data(data)
    .seriesDomain(sd)
    .filterDomain(fd)
  chart.render()
)

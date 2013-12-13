Dashboard.verbatim = ->

  _chart          = {}
  _data           = []
  _seriesDomain   = []
  _filterDomain   = []
  question_tables = null
  series_selector = d3.select('#verbatims').select('#series_selector')
  filter_selector = d3.select('#verbatims').select('#filter_selector')
  _page           = 1
  _perPage        = 15
  _nPages         = null
  _colors         = d3.scale.category10()

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

  _chart.page = (p) ->
    return _page unless p
    _page = p
    _chart

  _chart.perPage = (p) ->
    return _perPage unless p
    _perPage = p
    _chart

  _chart.render = (options) ->
    options = {} unless options
    renderQuestionTables(options)

  currentSelectedOptions = ->
    {
      series_1: _seriesDomain[series_selector[0][0].selectedIndex - 1]
      series_2: _filterDomain[filter_selector[0][0].selectedIndex - 1]
      page: _page
    }

  nPages = (n) ->
    return _nPages unless n
    _nPages = n

  findNumberOfPages = (numberOfResponses) ->
    div = Math.floor(numberOfResponses / _perPage)
    rem = numberOfResponses % _perPage
    div += 1 if (div == 0 || rem > 0)
    div

  appendSelectorOptions = (selector, domain) ->
    selector.selectAll('option')
      .data(['[all]'].concat(domain))
      .enter()
      .append('option')
      .attr('value', (d) -> d)
      .text((d) -> d)
    selector.on('change', -> 
      _page = 1
      _chart.render(currentSelectedOptions())
    )


  renderQuestionTables = (options) ->
    console.log("renderQuestionTables", options)
    question_table = d3.select("#verbatims").select('table.verbatim')
    dataFilter = (d) ->
      s = options.series_1 if options.series_1 && options.series_1 != '[all]'
      f = options.series_2 if options.series_2 && options.series_2 != '[all]'
      d.filter((e) -> if s then e.series_1 == s else e)
        .filter((e) -> if f then e.series_2 == f else e)
    filtered = dataFilter(_data)
    paginate(options.page, filtered.length)

    rows = question_table.selectAll('tr')
      .data(filtered.slice((_page - 1) * _perPage, _perPage * _page))

    rows.enter()
      .append('tr')
      .attr('class', 'response')
    
    rows.exit().remove()
    rows.selectAll('td').remove()
    rows.append('td')
      .text((d) -> d.id)
    rows.append('td')
      .text((d) -> d.series_1)
    rows.append('td')
      .text((d) -> d.series_2)
      .style('color', (d) -> _colors(d.series_2))
    rows.append('td')
      .text((d) -> d.value)

  paginate = (pageNumber, responseCount) ->
    nPages(findNumberOfPages(responseCount))
    allPages = [1.._nPages]

    pStart = _page - 5
    pStart = 1 if pStart < 1
    pEnd = _page + 4
    pEnd = _nPages if pEnd > _nPages

    includeStartEllipsis = pStart > 1
    includeEndEllipsis = pEnd < _nPages

    pagination = []
    pagination.push(1) if includeStartEllipsis
    pagination.push('...') if includeStartEllipsis
    pagination.push x for x in [pStart..pEnd]
    pagination.push('...') if includeEndEllipsis
    pagination.push(_nPages) if includeEndEllipsis
    console.log(pagination)
    links = d3.select('#paginate').selectAll('a').data(pagination)
    links.enter()
      .append('a')
    links.text((d) -> " #{d} ")
      .on('click', (d) ->
        unless d == '...'
          _page = d
          renderQuestionTables(currentSelectedOptions())
      )
    links.exit().remove()
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

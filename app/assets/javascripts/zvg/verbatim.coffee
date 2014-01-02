class ZVG.Verbatim
  constructor: (container,question_id) ->
    @container = container
    @initializeQuestionTable()
    @_page = 1
    @_perPage = 15
    @question_id = question_id

  render: (options = {}) ->
    dataFilter = (d) ->
      s = options.series_1 if options.series_1 && options.series_1 != '[all]'
      f = options.series_2 if options.series_2 && options.series_2 != '[all]'
      d.filter((e) -> if s then e.series_1 == s else e)
        .filter((e) -> if f then e.series_2 == f else e)

    filtered = dataFilter(@_data)
    @paginate(options.page, filtered.length)
    rows = @question_table.selectAll('tr')
      .data(filtered.slice((@_page - 1) * @_perPage, @_perPage * @_page))

    rows.enter()
      .append('tr')
      .attr('class', 'response')

    rows.exit().remove()
    rows.selectAll('td').remove()
    rows.append('td').text((d) -> d.series_1).attr('class', 'zvg_series_1 zvg_series')
    rows.append('td').text((d) -> d.series_2).attr('class', 'zvg_series_2 zvg_series')
    rows.append('td').text((d) -> d.value).attr('class', 'zvg_verbatim_value')

  initializeQuestionTable: ->
    @controls = d3.select(@container).append('div').attr('class', 'controls')
    @pagination = d3.select(@container).append('div').attr('class', 'pagination')
    @question_table = d3.select(@container).append('table').attr('class', 'verbatim')
    @series_selector = @controls.append('select').attr('name', 'series_selector')
    @filter_selector = @controls.append('select').attr('name', 'filter_selector')
    

  colors: -> @_colors

  data: (d) ->
    if d
      @_data = (x for x in d when x.question == @question_id)
      @seriesDomain(d3.scale.ordinal().domain(x.series_1 for x in d).domain())
      @filterDomain(d3.scale.ordinal().domain(x.series_2 for x in d).domain())
      return @
    @_data

  getData: (source) =>
    d3.json(source, (error, json) =>
      @data(json)
      @render()
    )

  seriesDomain: (d) ->
    if d
      @_seriesDomain = d
      @appendSelectorOptions(@series_selector, @_seriesDomain)
      return @
    @_seriesDomain

  filterDomain: (d) ->
    if d
      @_filterDomain = d
      @appendSelectorOptions(@filter_selector, @_filterDomain)
      return @
    @_filterDomain

  page: (p) ->
    if p
      @_page = p
      return @
    @_page

  perPage: (p) ->
    if p
      @_perPage = p
      return @
    @_perPage

  appendSelectorOptions: (selector, domain) ->
    s = selector.selectAll('option').data(['[all]'].concat(domain))
    s.enter().append('option')
    s.attr('value', (d) -> d) .text((d) -> d)
    s.exit().remove()

    selector.on('change', =>
      console.log('change event')
      @_page = 1
      @render(@currentSelectedOptions())
    )

  currentSelectedOptions: ->
    {
      series_1: @_seriesDomain[@series_selector[0][0].selectedIndex - 1]
      series_2: @_filterDomain[@filter_selector[0][0].selectedIndex - 1]
      page: @page()
    }

  calculateNumberOfPages: (n) ->
    div = Math.floor(n/@_perPage)
    rem = n % @_perPage
    div += 1 if (div == 0 || rem > 0)
    @numberOfPages = div

  paginate: (pageNumber, responseCount) ->
    @calculateNumberOfPages(responseCount)
    allPages = [1..@numberOfPages]

    pStart = @_page - 5
    pStart = 1 if pStart < 1
    pEnd = @_page + 4
    pEnd = @numberOfPages if pEnd > @numberOfPages

    includeStartEllipsis = pStart > 1
    includeEndEllipsis = pEnd < @numberOfPages

    pagination = []
    pagination.push({ text: 'prev', page: @_page - 1 }) if @_page > 1
    pagination.push({ text: 1, page: 1 }) if includeStartEllipsis
    pagination.push({ text: '...', page: null }) if includeStartEllipsis
    pagination.push({ text: x, page: x }) for x in [pStart..pEnd]
    pagination.push({ text: '...', page: null }) if includeEndEllipsis
    pagination.push({ text: @numberOfPages, page: @numberOfPages }) if includeEndEllipsis
    pagination.push({ text: 'next', page: @_page + 1 }) if @_page < @numberOfPages

    console.log(pagination)
    links = @pagination.selectAll('a.zvg_page').data(pagination)
    pageAction = (d) =>
      @page(d.page) if d.page
      @render(@currentSelectedOptions())

    links.enter()
      .append('a')
      .attr('class', (d) -> "zvg_page_#{d.text} zvg_page")
      .attr('href', '#')
    links.text((d) -> " #{d.text} ")
      .style('color', (d) =>
        if d.page == @_page
          'red'
        else
          'black'
      )
      .on('click', (d) ->
        pageAction(d)
        d3.event.preventDefault()
      )
    links.exit().remove()




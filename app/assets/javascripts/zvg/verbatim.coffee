class ZVG.Verbatim
  constructor: (container,options,renderCallback = -> null) ->
    @container       = container
    @_series_header  = options.series_header or "series_title"
    @_filter_header  = options.filter_header or "filter_title"
    @_tag_header     = options.tag_header or "tag_title"
    @_currentMetadata = {}
    @initializeQuestionTable()

    @_page          = 1
    @_perPage       = 15
    @question_id    = options.question_id
    @renderCallback = renderCallback

  render: (options = {}, callback) ->
    dataFilter = @constructDataFilter(options)
    filtered = dataFilter(@displayData(options))
    @data(filtered)
    @paginate(options.page, @_currentMetadata.total_count or filtered.length)
    rows = @question_table.selectAll('tr.response')
      .data(@data())

    rows.enter()
      .append('tr')
      .attr('class', 'response')
      .on('click', ->
        selection = d3.select(@)
        isSelected = selection.classed('selected')
        selection.classed('selected', not isSelected)
      )

    rows.attr('id', (d) -> "respondent_#{d.id}")
    @selectNoResponses()

    rows.exit().remove()
    rows.selectAll('td').remove()
    rows.append('td').text((d) -> d.series_1).attr('class', 'zvg_series_1 zvg_series')
    rows.append('td').text((d) -> d.series_2).attr('class', 'zvg_series_2 zvg_series')
    response_td = rows.append('td')
    response_td.append('div').attr('class', 'text').text((d) -> d.value)
    tags = response_td.append('div').attr('class', 'tags')

    tag_spans = tags.selectAll('span.tag').data((d) -> d.tags or [])
    tag_spans.enter()
      .append('span').attr('class', 'tag')

    tag_spans.text((d) -> d)
    @renderCallback(@)

  renderTags: (container, tag_list) ->
    tag_spans = tags.selectAll('span.tag').data((d) -> d.tags or [])
    tag_spans.remove()

  displayData: ->
    @_data

  selectAllResponses: ->
    @question_table.selectAll('tr.response').classed('selected', true)

  selectNoResponses: ->
    @question_table.selectAll('tr.response').classed('selected', false)

  initializeQuestionTable: =>
    # @controls        = d3.select(@container).append('table').attr('class', 'controls')
    @pagination      = d3.select(@container).append('div').attr('class', 'pagination')
    @question_table  = d3.select(@container).append('table').attr('class', 'verbatim')
    @control_row     = @question_table.append('tr').attr('class', 'controls')

    @series_cell     = @control_row.append('td').attr('class', 'zvg_series')
    @series_title    = @series_cell.append('h5').text(@_series_header).attr('class', 'verb_selector_title')
    @series_selector = @series_cell.append('select').attr('name', 'series_selector')
    @filter_cell     = @control_row.append('td').attr('class', 'zvg_series')
    @filter_title    = @filter_cell.append('h5').text(@_filter_header).attr('class', 'verb_selector_title')
    @filter_selector = @filter_cell.append('select').attr('name', 'filter_selector')
    @tag_cell        = @control_row.append('td').attr('class', 'zvg_series_wide')
    @tag_title       = @tag_cell.append('h5').text(@_tag_header).attr('class', 'verb_selector_title')
    @tag_selector    = @tag_cell.append('select').attr('name', 'tag_selector')

  constructDataFilter: (options) ->
    @filterOpts = options
    s = options.series_1 if options.series_1 && options.series_1 != '[all]'
    f = options.series_2 if options.series_2 && options.series_2 != '[all]'
    t = options.tag if options.tag && options.series_2 != '[all]'

    return (d) -> d
    # TODO: remove the rest, filtering now happens on server
    (d) ->
      d.filter((e) -> if s then e.series_1 == s else e)
        .filter((e) -> if f then e.series_2 == f else e)
        .filter((e) -> if t then (e.tags or []).indexOf(t) >= 0 else e)


  colors: -> @_colors

  data: (d) ->
    if d
      @_data = (x for x in d when x.question == @question_id)
      if @_currentMetadata
        @seriesDomain(d3.scale.ordinal().domain(x for x, y of @_currentMetadata.primary_filter_counts).domain())
        @filterDomain(d3.scale.ordinal().domain(x for x, y of @_currentMetadata.secondary_filter_counts).domain())
        @tagDomain(d3.scale.ordinal().domain(@metadataTags()).domain())
      else
        @seriesDomain(d3.scale.ordinal().domain(x.series_1 for x in @_data).domain())
        @filterDomain(d3.scale.ordinal().domain(x.series_2 for x in @_data).domain())
      return @
    @_data

  metadataTags: ->
    key for key, _ of @metadataTagCounts()

  metadataTagCounts: ->
    (@_currentMetadata.tags or {})[@question_id] or {}

  getData: (source) =>
    d3.json(source, (error, json) =>
      @data(json)
      @render({}, (chart) -> console.log('getData callback, chart: ', chart))
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

  tagDomain: (d) ->
    if d
      @_tagDomain = d
      @appendSelectorOptions(@tag_selector, @_tagDomain)
      return @
    @_tagDomain

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
    host = @
    s = selector.selectAll('option').data(['[all]'].concat(domain))
    s.enter().append('option')
    s.attr('value', (d) -> d).text((d) -> "#{d}#{host._tagCountString(d)}")
    s.exit().remove()

    selector.on('change', =>
      @_page = 1
      @render(@currentSelectedOptions())
      (selector.callback or (->))()
    )

  _tagCount: (tag) ->
    @metadataTagCounts()[tag]

  _tagCountString: (tag) ->
    if count = @_tagCount(tag)
      " (#{count})"
    else
      ''

  currentSelectedOptions: ->
    {
      series_1: @_seriesDomain[@series_selector[0][0].selectedIndex - 1]
      series_2: @_filterDomain[@filter_selector[0][0].selectedIndex - 1]
      tag: @_tagDomain[@tag_selector[0][0].selectedIndex - 1]
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
    pagination.push({ text: 'prev', page: if @_page > 1 then @_page - 1 else null })
    pagination.push({ text: 'next', page: if @_page < @numberOfPages then @_page + 1 else null })
    pagination.push({ text: 1, page: 1 }) if includeStartEllipsis
    pagination.push({ text: '...', page: null }) if includeStartEllipsis
    pagination.push({ text: x, page: x }) for x in [pStart..pEnd]
    pagination.push({ text: '...', page: null }) if includeEndEllipsis
    pagination.push({ text: @numberOfPages, page: @numberOfPages }) if includeEndEllipsis

    links = @pagination.selectAll('a.zvg_page').data(pagination)
    pageAction = (d) =>
      @page(d.page) if d.page
      @render(@currentSelectedOptions())

    links.enter()
      .append('a')
      .attr('class', (d) -> "zvg_page_#{d.text} zvg_page")
      .attr('href', '#')
    links.text((d) -> " #{d.text} ")
      .classed('current', (d) => d.page == @_page)
      .on('click', (d) ->
        pageAction(d)
        d3.event.preventDefault()
      )
    links.exit().remove()




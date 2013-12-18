buttons = d3.select('body').append('div')
  .attr('id', 'buttons')

window.chart = new ZVG.Column
chart.randomizeData()
chart.render()


buttons.append('button')
  .text('randomize')
  .on('click', => chart.randomizeData())
buttons.append('button')
  .text('standard sample data')
  .on('click', =>
    chart.data(chart.sample_data)
    chart.series_2_domain("Filter #{n}" for n in [1,2,3,4])
    chart.render(chart.renderMode)
  )
buttons.append('button')
  .text('show percentages')
  .on('click', => chart.render('percentage'))
buttons.append('button')
  .text('show counts')
  .on('click', => chart.render('count'))


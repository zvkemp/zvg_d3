buttons = d3.select('body').append('div')
  .attr('id', 'buttons')

chart = new ZVG.Point
window.chart = chart
chart.data(chart.sample_data)
  .series_1_domain("Survey #{n}" for n in [1,2,3,4])
  .series_2_domain("Filter #{n}" for n in [1,2,3,4,5])
  .series_3_domain("#{n}" for n in [100])
  .min_value(1)
  .max_value(5)
  .render()


buttons.append('button')
  .text('randomize')
  .on('click', =>
    chart.randomizeData())
buttons.append('button')
  .text('standard sample data')
  .on('click', =>
    chart.series_1_domain("Survey #{n}" for n in [4,3,2,1])
    chart.series_2_domain("Filter #{n}" for n in [1,2,3,4,5])
    chart.series_3_domain("#{n}" for n in [100, 101])
    chart.data(chart.sample_data)
    chart.render(chart.renderMode)
  )
buttons.append('button')
  .text('show percentages')
  .on('click', => chart.render('percentage'))
buttons.append('button')
  .text('show counts')
  .on('click', => chart.render('count'))


window.chart = chart

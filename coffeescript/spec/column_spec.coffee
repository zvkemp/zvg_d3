describe 'Charts::Column', ->
  it 'should exist', ->
    expect(ZVG.Column).toBeDefined()

  describe 'initialization', ->
    it 'should append an svg element', ->
      column = new ZVG.Column



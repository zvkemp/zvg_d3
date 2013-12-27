beforeEach ->
  @addMatchers { toBeEmpty: -> @.actual.empty() }

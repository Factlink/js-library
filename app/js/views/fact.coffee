highlight_time_on_load    = 1500
highlight_time_on_in_view = 1500
delay_between_highlight_and_show_button_open = 400

class Highlighter
  constructor: (@$elements) ->

  highlight:   -> @$elements.addClass('fl-active')
  dehighlight: -> @$elements.removeClass('fl-active')

class Factlink.Fact
  constructor: (@id, @elements) ->
    @button_attention = new Factlink.AttentionSpan
      lost_attention:   => @show_button.hide()
      gained_attention: => @show_button.show()
      wait_for_attention: 700
      wait_for_neglection: 300

    @highlight_attention = new Factlink.AttentionSpan
      lost_attention:   => @highlighter.dehighlight()
      gained_attention: => @highlighter.highlight()
      wait_for_attention: 300
      wait_for_neglection: 300

    @highlighter = new Highlighter $(@elements)

    @show_button = new Factlink.ShowButton
      mouseenter: => @onFocus()
      mouseleave: => @onBlur()
      click:      => @openFactlinkModal()

    @highlight_temporary highlight_time_on_load

    $(@elements)
      .on('mouseenter', (e)=> @onFocus(e))
      .on('mouseleave', => @onBlur())
      .on('click', => @openFactlinkModal())
      .on 'inview', (event, isInView, visiblePart) =>
        @highlight_temporary(highlight_time_on_in_view) if ( isInView && visiblePart == 'both' )

  highlight_temporary: (duration) ->
    @highlighter.highlight()
    setTimeout (=> highlight_attention.check_attention()), duration

  onBlur: ->
    @highlight_attention.neglect()
    @button_attention.neglect()
  onFocus: (e) =>
    if e?
      @show_button.setCoordinates($(e.target).offset().top, e.pageX)
    @highlight_attention.attend()
    @button_attention.attend()

  shouldHaveEmphasis: => || @_loading

  openFactlinkModal: =>
    @startLoading()
    Factlink.showInfo @id, => @stopLoading()

  startLoading: ->
    @show_button.startLoading()
    @highlight_attention.gain_attention()
    @button_attention.gain_attention()

  stopLoading: ->
    @highlight_attention.loose_attention()
    @button_attention.loose_attention()

  destroy: ->
    for el in @elements
      $el = $(el)
      unless $el.is('.fl-first')
        $el.before $el.html()

      $el.remove()

    @show_button.destroy()

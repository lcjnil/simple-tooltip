class Tooltip extends Widget
  opts:
    placement: null
    content: ""
    cls: null
    selector: null
    delay: 1000

  @_placements: [
    "bottom"
    "top"
    "left"
    "right"
  ]

  @_tpl:
    tooltip: '''
      <div class="simple-tooltip">
        <div class="tooltip-arrow"></div>
        <div class="tooltip-content"></div>
      </div>
    '''

  _init: ->
    if not @opts.content
      throw '[Tooltip] - 内容不能为空'

    @_render()
    @_bind()
    @el.data("tooltip", @)
    @refresh()

  _render: ->
    @el = $(Tooltip._tpl.tooltip).addClass @opts.cls
    @selector = @opts.selector

    @el.find('.tooltip-content').append(@opts.content)
    @el.appendTo('body')

    @selector.addClass('tooltip-selector')
      .data('tooltip', @)

  _bind: ->
    @selector.on "mouseenter.simple-tooltip", (e) =>
      e.preventDefault()
      @destroy()

    @selector.on "mouseleave.simple-tooltip", (e) =>
      delay = =>
        @el.fadeOut 1000

      setTimeout delay, @opts.delay


  _unbind: ->
    @el.off(".simple-tooltip")
    $(document).off(".simple-tooltip")
    $(window).off(".simple-tooltip")

  destroy: ->
#    if @triggerHandler("tooltip:beforeDestroy", [@]) is false
#      return
    @_unbind()
    @el.remove()
    @selector.removeClass("tooltip-selector")
      .removeData("tooltip")
    @trigger("tooltip:destroy", [@])

  refresh: ->
    @el.remove()
    .css({ top: 0, left: 0, display: 'block' })
    .appendTo('body')

    pos = @getPosition()
    actualWidth = @el[0].offsetWidth
    actualHeight = @el[0].offsetHeight

    bodyHeight = $('body').height()
    bodyWidth = $('body').width()

    if not @opts.placement
      if pos.top + pos.height + actualHeight < bodyHeight
        @opts.placement = 'bottom'
      else if pos.top - actualHeight > 0
        @opts.placement = 'top'
      else if pos.left - actualWidth > 0
        @opts.placement = 'left'
      else
        @opts.placement = 'right'



    switch @opts.placement
      when 'bottom' then tp = {top: pos.top + pos.height, left: pos.left + pos.width / 2 - actualWidth / 2}
      when 'top' then tp = {top: pos.top - actualHeight, left: pos.left + pos.width / 2 - actualWidth / 2}
      when 'left' then tp = {top: pos.top + pos.height / 2 - actualHeight / 2, left: pos.left - actualWidth}
      else tp = {top: pos.top + pos.height / 2 - actualHeight / 2, left: pos.left + pos.width}


    @el.css tp
      .addClass "placement-#{ @opts.placement } tooltip-in"

  getPosition: ->
    el = @selector[0]
    return $.extend {}, el.offset, {top: el.offsetTop, left: el.offsetLeft, width: el.offsetWidth, height: el.offsetHeight}


@simple ||= {}

@simple.Tooltip = (opts) ->
  return new Tooltip opts

@simple.Tooltip.destroyAll = Tooltip.destroyAll

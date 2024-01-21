


{ Button } = require "Buttons"



class NavigationComponent extends FlowComponent
	constructor: (@options={}) ->

		_.defaults @options,
			# screen: null
		
		super @options


	
	# @define 'view',
	# 	get: -> @options.view
	# 	set: (value) ->
	# 		print "?"
	# 		# @options.view = value
	# 		# print value
	# 		# @parent = value
	# 		# @width = value.width
	# 		# @height = value.height
	# 		# print @
	# 		# @backgroundColor = "blue"
	# 		# print @parent




	stackTransition: (nav, layerA, layerB, overlay) ->
		transition =
			layerA:
				show: {x: 0, y: 0}
				hide: {x: 0 - layerA?.width / 2, y: 0}
			layerB:
				show: {x: 0, y: 0}
				hide: {x: layerB.width, y: 0}
			overlay:
				show: {opacity: .5, x: 0, y: 0, size: nav.size}
				hide: {opacity: 0, x: 0, y: 0, size: nav.size}


	modalTransition: (nav, layerA, layerB, overlay) ->
		transition =
			layerA:
				show: {x: 0, y: 0}
				hide: {x: 0, y: 0}
			layerB:
				show: {x: 0, y: 0}
				hide: {x: 0, y: layerA?.height + 10}
			overlay:
				show: {opacity: .5, x: 0, y: 0, size: nav.size}
				hide: {opacity: 0, x: 0, y: 0, size: nav.size}





	create_BackButton: (parentLayer) ->
		return new Button
			parent: parentLayer
			width: 100, height: 82, y: 54
			backgroundColor: null
			opacity: 0.4
			handler: () -> @custom.flow.showPrevious()
			custom:
				flow: @



	open: (navigationView) ->
		if navigationView.custom and navigationView.custom.view
			navigationView.custom.view.scrollToTop(false)
			@transition(navigationView, @modalTransition)
		else
			navigationView.scrollToTop(false)
			@transition(navigationView, @stackTransition)



	createView: (bgColor = "white") ->
		navigationView = new NavigationView
			width: @width
			height: @height
			backgroundColor: bgColor
			scrollVertical: true
			scrollHorizontal: false
			directionLock: true
		
		navigationView.on Events.SwipeRightStart, (event, layer) =>
			@showPrevious()
		
		@showNext(navigationView)
		@showPrevious(animate: false)

		@create_BackButton(navigationView.content)
		
		return navigationView
	

	createModal: (bgColor = "white", gap = 66, radius = 56) ->
		navigationView_Wrapper = new ModalView
			name: "wrapper"
			width: @width
			height: @height
			backgroundColor: null
			custom:
				view: null
				handler: null

		navigationView = new ScrollComponent
			parent: navigationView_Wrapper
			y: gap
			width: @width
			height: @height - gap
			backgroundColor: bgColor
			scrollVertical: true
			scrollHorizontal: false
			directionLock: true
			borderRadius: radius
			custom:
				flow: @

		navigationView_Wrapper.custom.view = navigationView

		navigationView_Handler = new Layer
			parent: navigationView_Wrapper
			width: 40, height: 3, x: Align.center, y: gap - 11
			backgroundColor: bgColor, opacity: 0.5
		
		navigationView_Wrapper.custom.handler = navigationView_Handler

		navigationView.on Events.SwipeRightStart, (event, layer) ->
			@custom.flow.showPrevious()

		navigationView.on Events.SwipeDownStart, (event, layer) ->
			if @scrollY < 0 then @custom.flow.showPrevious()
		
		@showNext(navigationView_Wrapper)
		@showPrevious(animate: false)
		
		return navigationView_Wrapper




	# init_NavigationViewContent: (navigationView, contentView) ->
	# 	if navigationView.custom and navigationView.custom.view
	# 		contentView.parent = navigationView.custom.view.content
	# 		contentView.backgroundColor = null
	# 	else
	# 		contentView.parent = navigationView.content









class NavigationView extends ScrollComponent
	constructor: (@options={}) ->

		_.defaults @options,
		
		super @options

	add: (contentView) ->
		contentView.parent = @content


class ModalView extends Layer
	constructor: (@options={}) ->

		_.defaults @options,
		
		super @options

	add: (contentView) ->
		contentView.parent = @custom.view.content
		@backgroundColor = null


module.exports = { NavigationComponent }

class exports.Device_Class extends Layer
	constructor: (@options={}) ->

		_.defaults @options,
			backgroundColor: "000"
			view: null

		super @options

		# update from parent
		@states =
			"normal": { scale: 1 }
			"fill": { scale: 1 }

		@initBorderViewCss()
		@sendToBack()
	


	@define 'view',
		get: -> @options.view
		set: (value) ->
			@options.view = value
			@options.width = value.width + 16 * 2
			@options.height = value.height + 16 * 2
			@borderRadius = value.borderRadius + 16

	stateSwitchToNormal: () =>
		@animate(scale: @states["normal"].scale, options: { curve: Bezier.linear, time: 0 })
	
	stateSwitchToFill: () =>
		@animate(scale: @states["fill"].scale, options: { curve: Bezier.linear, time: 0 })

	animateStateToNormal: () =>
		@animate(scale: @states["normal"].scale, options: { curve: Spring(damping: 1), time: 0.5 })
	
	animateStateToFill: () =>
		@animate(scale: @states["fill"].scale, options: { curve: Spring(damping: 1), time: 0.5 })



	initBorderViewCss: () =>
		@classList.add("iphone-tilllur-v")
 
		css = """
		.iphone-tilllur-v {
			background: linear-gradient(
			160.74deg,
			rgba(36, 36, 36, 0.3) 24.39%,
			rgba(28, 28, 28, 0.3) 29.47%,
			rgba(10, 10, 10, 0.3) 99.85%
			),
			linear-gradient(
			180deg,
			rgba(2, 2, 2, 0.6) -0.21%,
			rgba(21, 21, 21, 0.6) 6.52%,
			rgba(6, 6, 6, 0.6) 99.79%
			),
			#5a5a5a;
		box-shadow: 8px 14px 20px rgba(0, 0, 0, 0.25),
			inset 0px -4px 16px rgba(255, 255, 255, 0.1),
			inset 4px 0px 4px rgba(255, 255, 255, 0.1),
			inset -4px 0px 4px rgba(0, 0, 0, 0.7);

		}
		"""
		
		Utils.insertCSS(css)
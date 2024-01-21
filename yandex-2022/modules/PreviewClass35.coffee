

{PreviewClass3} = require "PreviewClass3"


class exports.PreviewClass35 extends PreviewClass3
	constructor: (@options={}) ->

		_.defaults @options,
			borderView: null
			showDevice: false
		
		super @options

		@borderView = new Layer
			backgroundColor: "000"
			borderRadius: @borderRadius + 16
			opacity: 1

		@borderView.sendToBack()
		# if @showDevice then @showBorderView()

		@initBorderViewCss()
		@updateBorderView()

		@on "change:size", ->
			@updateBorderView()
		
		@on "change:scale", ->
			@updateBorderView()
		
		@on "change:x", ->
			@updateBorderView()
		
		@on "change:y", ->
			@updateBorderView()
		

	
	@define 'borderView',
		get: -> @options.borderView
		set: (value) -> @options.borderView = value
	
	@define 'showDevice',
		get: -> @options.showDevice
		set: (value) -> @options.showDevice = value
	
	


	showBorderView: () =>
		@borderView.opacity = 1
	
	hideBorderView: () =>
		@borderRadius.opacity = 0

	updateBorderView: () =>
		deltaG = 16

		# @borderView.x = @x - deltaG
		# @borderView.y = @y - deltaG
		@borderView.width = @width + deltaG * 2
		@borderView.height = @height + deltaG * 2
		@borderView.x = Align.center()
		@borderView.y = Align.center()
		@borderView.scale = @scale
		
	
	initBorderViewCss: () =>
		@borderView.classList.add("iphone-tilllur-v")
 
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
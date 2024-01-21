
class exports.HomeBar_Class extends Layer
	constructor: (@options={}) ->

		_.defaults @options,
			parent: @view
			width: @view.width
			
			theme: @view.homeBar_theme
			
			height: 34, y: Align.bottom, name: ".home bar", backgroundColor: null
		
		super @options

		@create()



	@define 'view',
		get: -> @options.view
		set: (value) -> @options.view = value

	@define 'theme',
		get: -> @options.theme
		set: (value) -> @options.theme = value



	viewSize: (w, h) => return @view.width == w and @view.height == h

	create: () =>
		if @viewSize(375, 812) or @viewSize(390, 844) or @viewSize(414, 896) or @viewSize(428, 926) or @viewSize(360, 782) or @viewSize(393, 852)
			@createHomeIndicator()
	
	
	createHomeIndicator: () =>
		new Layer
			name: ".homeView"
			parent: @, width: 135, height: 5, x: Align.center, y: Align.bottom(-8)
			backgroundColor: device_assets.color[@theme], borderRadius: 20



device_assets =
	color:
		dark: "#000"
		light: "#FFF"
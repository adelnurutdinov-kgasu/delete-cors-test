
# SVG = require "PCSVG"

class Text extends TextLayer
	constructor: (@options={}) ->
		
		_.defaults @options,
			# fontFamily: fontAveria
			fontSize: 18
			weight: 700
			color: "white"
			height: 20
			letterSpacing: 0.7
			letterSpacing: 0.4
		
		super @options

		@style =
			"font-family": "'SF Pro Text', 'PT Sans', 'Helvetica', 'Tahoma', sans-serif;"
			"font-weight": 700
			"-webkit-font-feature-settings": "'ss02' on, 'ss06' on, 'ss09' on, 'ss11' on;"
			"-moz-font-feature-settings": "'ss02' on, 'ss06' on, 'ss09' on, 'ss11' on;"
			"-ms-font-feature-settings": "'ss02' on, 'ss06' on, 'ss09' on, 'ss11' on;"
			"font-feature-settings": "'ss02' on, 'ss06' on, 'ss09' on, 'ss11' on;"
		



class TextButton extends Text
	constructor: (@options={}) ->
		
		_.defaults @options,
			tuple: { normal: 0.5, hover: 0.8 }
			handler: null

		
		super @options
		@style = cursor: "pointer"
		
		@.onMouseOver @Hover
		@.onMouseOut @HoverOff

		@updateTuple(@tuple)
	
	
		
	Hover: =>
		@opacity = @tuple.hover
	HoverOff: =>
		@opacity = @tuple.normal
	
	updateTuple: (newTuple) =>
		@tuple = newTuple
		@emit Events.MouseOver
		@emit Events.MouseOut
	
	
	@define 'handler',
		set: (value) -> @on(Events.Tap, value)
	
	@define 'tuple',
		get: -> @options.tuple
		set: (value) ->
			@options.tuple = value



class Button extends Text
	constructor: (@options={}) ->
		
		_.defaults @options,
			handler: null
			height: 32, borderRadius: 8
			padding: { top: 6, bottom: 7, left: 9, right: 9 }
			backgroundColor: "rgba(0,0,0,0.7)"
		
		super @options
		@showHint = -> ;
		@style = cursor: "pointer"
		
		@.onMouseOver @Hover
		@.onMouseOut @HoverOff
		
	Hover: =>
		@backgroundColor = "rgba(0,0,0,0.4)"
	HoverOff: =>
		@backgroundColor = "rgba(0,0,0,0.7)"
	
	@define 'handler',
		set: (value) -> @on(Events.Tap, value)


class ButtonTab extends Button
	constructor: (@options={}) ->
		
		_.defaults @options,
			selected: true
	
		super @options

	Hover: =>
		@backgroundColor = "rgba(0,0,0,0.4)"
	HoverOff: =>
		if @selected then @backgroundColor = "rgba(0,0,0,0.7)"
		else @backgroundColor = "rgba(0,0,0,0.2)"

	@define 'selected',
		get: -> @options.selected
		set: (value) ->
			@options.selected = value
			if value then @backgroundColor = "rgba(0,0,0,0.7)"
			else @backgroundColor = "rgba(0,0,0,0.2)"


# Button: SVG

# class SVGButton extends TextButton
# 	constructor: (@options={}) ->
		
# 		_.defaults @options,
# 			text: ""
# 			asset: null
# 			clip: false
# 			autoSize: false
		
# 		@svgShape = new SVGLayer
# 			backgroundColor: "null", name: "svgShape"
		
# 		super @options
# 		@svgShape.parent = @
# 		@updateSVGSize()
	
	
# 	@define 'asset',
# 		get: -> @options.asset
# 		set: (value) ->
# 			@options.asset = value
# 			@svgShape.states =
# 				"onDark": { svg: value.onDark }
# 				"onLight": { svg: value.onLight }
# 			@svgShape.stateSwitch("onDark")
	
# 	updateSVGSize: () =>
# 		@svgShape.width = @width
# 		@svgShape.height = @height
	




# Button: Copy

# class CopyButton extends TextButton
# 	constructor: (@options={}) ->
		
# 		_.defaults @options,
# 			link: "https://tilllur.com"
# 			handler: @copyHandler
		
# 		@area = new Layer
# 			opacity: 0, x: -3000, html: null
		
# 		super @options
# 		@area.parent = @
	
	
# 	@define 'link',
# 		get: -> @options.link
# 		set: (value) ->
# 			@options.link = value
# 			@update(value)
	
	
# 	update: (link) =>
# 		@area.html = "<textarea class='js-copytextarea-class' style='opacity:0;'>#{link}</textarea>"
	
	
# 	copyHandler: =>
# 		textDiv = @area.querySelector('.js-copytextarea-class')
# 		textDiv.focus()
# 		textDiv.select()
# 		document.execCommand 'copy'
		
# 		originTitle = @text
# 		@text = "Done 👌"
# 		Utils.delay 1, => @text = originTitle




# # # Button: Copy

# # class LinkButton extends SVGButton
# # 	constructor: (@options={}) ->
		
# # 		_.defaults @options,
# # 			link: "https://tilllur.com"
# # 			borderWidth: 1 * 2
# # 			borderRadius: 20 * 2
# # 			tuple: { normal: 1.0, hover: 0.8 }
			
		
# # 		@tintButtonFix = new Layer
# # 			height: 120 * 2
# # 			backgroundColor: null
		
# # 		@buttonText = new Text
# # 			fontSize: 32 * 2
# # 			textAlign: "right"
# # 			height: 60 * 2
		
# # 		@buttonIcon = new SVGLayer
# # 			width: 24 * 2, height: 24 * 2
# # 			svg: SVG.openIcon.onLight
# # 			opacity: 0.6
			

		
# # 		super @options

# # 		@buttonText.text = @text
# # 		@text = ""

# # 		@tintButtonFix.parent = @parent
# # 		@tintButtonFix.x = Align.right
# # 		@tintButtonFix.y = Align.top
		
# # 		@parent = @tintButtonFix
# # 		@y = Align.top(30 * 2)
# # 		@height = 60 * 2

# # 		@buttonText.parent = @
# # 		@buttonText.x = 16 * 2
# # 		@buttonText.y = 9 * 2

# # 		@buttonIcon.parent = @
# # 		@buttonIcon.x = 16 * 2 + @buttonText.width + 16 * 2
# # 		@buttonIcon.y = Align.center(3 * 2)

# # 		@width = 16 * 2 + @buttonText.width + @buttonIcon.width + 16 * 2 + 16 * 2
# # 		@tintButtonFix.width = @width + 30 * 2 + 16 * 2

# # 		@tintButtonFix.x = Align.right
# # 		@x = Align.right(-30 * 2)
		
	

# # 	@define 'link',
# # 		get: -> @options.link
# # 		set: (value) -> @options.link = value
	
# # 	setColor: (color = null) =>
# # 		if color == null then return
# # 		@tintButtonFix.backgroundColor = color
	








# class PreviewButton extends Text
# 	constructor: (@options={}) ->

# 		_.defaults @options,
# 			tuple: { normal: 1.0, hover: 0.8 }
		
# 		super @options

# 		@removeAllListeners()

# 		@.onMouseOver @Hover
# 		@.onMouseOut @HoverOff

# 	Hover: =>
# 		# @scale = 1.05
# 		@opacity = 1.0
	
# 	HoverOff: =>
# 		# @scale = 1.0
# 		@opacity = 0.8




module.exports = {Text, TextButton, Button, ButtonTab}



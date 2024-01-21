

{UI_Section} = require "UI_Section"
{Text, Button} = require "UI_Buttons"

class exports.UI_Config extends UI_Section
	constructor: (@options={}) ->
		
		_.defaults @options,
			height: 100, y: Align.bottom(-8)
			backgroundColor: null

			view: null

		super @options
		@updateConfigOnResize()


	@define 'view',
		get: -> @options.view
		set: (value) -> @options.view = value


	updateConfigOnResize: () =>
		localConfig = @
		
		Canvas.on "change:height", => localConfig.y = Align.bottom(-8)



	# Override
	addSection: (actionArray = []) =>
		sectionView = new Layer
			parent: @
			width: 360, height: 100, backgroundColor: null
			x: 32, y: Align.bottom()

		@addSectionTitle(sectionView, "Preview")
		sectionView.style = cursor: "pointer"
		sectionView.onTap -> ;
		sectionView.showHint = -> ;

		sumX = 0
		for actionItem, i in actionArray
			sectionButton = @addActionButton(actionItem, i)
			sectionButton.parent = sectionView
			sectionButton.x = sumX
			sumX += sectionButton.width + 8 + 4
		
		@width = Math.max(@width, sumX)
	


	# Override
	addActionButton: (actionItem, index) =>
		buttonLayer = new Button
			text: actionItem.title
			y: 42
			selected: if index is 0 then true else false
			custom:
				actionItem: actionItem
		
		complexHandler = () ->
			@custom.actionItem.handler(@custom.actionItem.data, @)

		buttonLayer.on(Events.Tap, complexHandler)
		return buttonLayer
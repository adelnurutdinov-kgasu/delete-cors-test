

{SectionView} = require "SectionView"
{Text, Button} = require "PCButtons"

class exports.ConfigView extends SectionView
	constructor: (@options={}) ->
		
		_.defaults @options,
			height: 100
			y: Align.bottom(-8)

		super @options

	# Override
	addSection: (actionArray = []) =>
		if !Utils.isMobile()
			sectionView = new Layer
				parent: @
				width: 360, height: 100, backgroundColor: null
				x: 32, y: Align.bottom()

			@addSectionTitle(sectionView, "Preview Settings")
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
	


	# # Override
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
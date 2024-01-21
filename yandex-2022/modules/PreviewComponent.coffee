# Preview Component

Framer.Defaults.Animation =
	curve: Spring(damping: 1)
	time: 0.5

# {Preview_Class} = require "Preview_Class"
# {Preview_Init} = require "Preview_Init"
{Preview_UI} = require "Preview_UI"
# {Control_Class} = require "Control_Class"

class FixPreviewExport extends Preview_UI
class exports.Preview extends FixPreviewExport




# Native

`window.savePreviewMessageFramerObject = function (layer) {
	window.previewMessageFramerObject = layer
}
`

`window.receiveMessageNormal = function (event) {
	window.previewMessageFramerObject.animateStateToNormal()
}
window.addEventListener("animateNormal", receiveMessageNormal, false);
`

`window.receiveMessage = function (event) {
	console.log(event)
	window.previewMessageFramerObject.animateStateToFill()
}
window.addEventListener("animateFill", receiveMessage, false);
`







class_name Telegram

var sender
var reciever
var message:int
var wait_time:float
var extra_info

func init(isender, ireciever, imessage, iwait_time, iextra_info):
	sender = isender
	reciever = ireciever
	message = imessage
	wait_time = iwait_time
	extra_info = iextra_info

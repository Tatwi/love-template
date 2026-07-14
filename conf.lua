love.conf = function(t)
	t.window.title      = "Title Goes Here"
	t.identity = "some_name"
	t.version  = "11.5"
	t.console  = false
	t.window.width      = 1024
	t.window.height     = 768
	t.window.minwidth = 640
	t.window.minheight = 480
	t.window.resizable  = false
	t.window.borderless = false
	t.window.fullscreen = false
	t.window.vsync      = 1
	-- For HiDPI screens
	t.window.highdpi = true
	t.window.usedpiscale = true
end

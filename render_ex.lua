

local render2d = render2d 

local function newRect(self,w,h,ax,ay)
	local node = self:newNode()
	node.ax = ax or 0
	node.ay = ay or 0
	node.presentation = function()
		local ax,ay = node.ax,node.ay 
		ax = ax + 0.5 
		ay = ay + 0.5
		local l,t,r,b = -ax*w,-ay*h,(1-ax)*w,(1-ax)*h
		render2d.fillRect(l,t,r,b)
	end

	function node:getAnchor()
		return self.ax,ay
	end 
	function node:setAnchor(ax,ay) --设置锚点
		local ax = ax or self.ax --允许只接收单个参数
		local ay = ay or self.ay
		self.ax,self.ay = ax,ay 
	end
	return node
end




display.Stage2D.methods.newRect = newRect
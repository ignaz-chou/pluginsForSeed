--[[
插件名称:render_ex
插件用途:
	1.提供快速的通过render2d创建图形的方法
	2.提供图形node的锚点设置方法
插件作者:Ignaz Chou,Singing Cicada
必备组件:
	无
使用方法:
	require("render_ex")
	local stage = display:newStage2D()

	--可选参数args
	local args = {
		ax = 0, --锚点x
		ay = 0,  --锚点y
		isBorder = true, --是否为边框。isBorder为true时绘制空心形状，否则绘制实心形状
	}

	local rect = stage:newRect(100,100,args)
	rect.x,rect.y = 0,0  
	rect:setAnchor(-0.5,-0.5)

	local circle = stage:newCircle(100,args)
	circle.x,circle.y = 0,0 
	circle:setAnchor(-0.5,-0.5)

版本说明
	v.1.01 alpha 2013-1-26
		1.完成newCircle基本功能
		2.ax,ay转移至参数args
		3.args中添加参数isBorder.决定是否绘制空心形状
		4.添加assert,在参数错误时给出正确的提示
		5.添加newAnchorNode方法.创建自带锚点的空Node
	v.1.00 alpha 2013-1-26
		1.完成newRect基本功能
]]--

local render2d = render2d 


local function newAnchorNode(self,ax,ay) --创建默认带锚点的node
	local node = self:newNode()
	node.ax = ax or 0
	node.ay = ay or 0
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

local function newRect(self,w,h,args) --绘制矩形
	local args = arsg or {}
	local isBorder = args.isBorder
	assert(w and h,"newRect绘制矩形需要给定宽高属性")
	assert(type(w) == "number" and type(h) == "number","width，height宽高属性需要给定数字")
	local node = self:newAnchorNode()
	node.ax = args.ax or 0
	node.ay = args.ay or 0
	node.presentation = function()
		local ax,ay = node.ax,node.ay 
		ax = ax + 0.5 
		ay = ay + 0.5
		local l,t,r,b = -ax*w,-ay*h,(1-ax)*w,(1-ax)*h
		if isBorder then 
			render2d.drawRect(l,t,r,b)
		else 
			render2d.fillRect(l,t,r,b)
		end
	end

	return node
end

local function newCircle(self,r,args) --绘制圆形
	local args = arsg or {}
	local isBorder = args.isBorder
	assert(r,"newCircle绘制圆形需要给定半径属性")
	assert(type(r) == "number","radius半径属性需要给定数字")
	local node = self:newAnchorNode()
	node.ax = args.ax or node.ax or 0 
	node.ay = args.ay or node.ay or 0 
	node.presentation = function()
		local ax,ay = node.ax,node.ay 
		local x,y = -ax*r*2,-ay*r*2
		if isBorder then
			render2d.drawCircle(x,y,r)
		else 
			render2d.fillCircle(x,y,r)
		end
	end
	return node
end

display.Stage2D.methods.newAnchorNode = newAnchorNode
display.Stage2D.methods.newRect = newRect
display.Stage2D.methods.newCircle = newCircle
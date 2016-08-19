
--lua DFA 
--------------------------------------------

Tree = class("Tree")
Tree.__index = Tree
function Tree:ctor()
	self.root = nil
	self.child = {}
end

function addChild(tree, str )
	if not str then return end
	local tbl = tree
    if type(tbl) ~= "table" then return end
    for k,v in pairs(str) do
        if type(tbl) ~= "table" then 
            break     
        end
        if  tbl[v] then
           tbl = tbl[v]
        else
            if k == # str then
                tbl[v] = true
            else
                tbl[v] = {}
            end
            tbl = tbl[v]
            
        end
    end

end

function split_words(str)
 	if not str then return end
    local len  = #str
    local left = 0
    local arr  = {0, 0xc0, 0xe0, 0xf0, 0xf8, 0xfc}
    local t = {}
    local start = 1
    local wordLen = 0
    while len ~= left do
        local tmp = string.byte(str, start)
        local i   = #arr
        while arr[i] do
            if tmp >= arr[i] then
                break
            end
            i = i - 1
        end
        wordLen = i + wordLen
        local tmpString = string.sub(str, start, wordLen)
        start = start + i
        left = left + i
        t[#t + 1] = tmpString
    end
    return t
 
end

function convert_to_tree(sensitive_tbl)
	local tree = {}
	for key, value in pairs(sensitive_tbl) do
		local tbl = split_words(value)
		 addChild(tree, tbl)
	end	 
    return tree 
end
 

function search_sensitive_words_in_tree(str)
    local source_tbl = split_words(str)
    local dictory = NEW_SENSITIVE_WORDS_TBL
    local temp = dictory

	for key, value in pairs(source_tbl) do
         if temp[value] then 
             if type(temp[value]) == "table" then
                temp = temp[value]
             else
                 if temp[value] == true then return true end
             end
         else
            temp = dictory
            if type(temp[value]) == "table" then
                temp = temp[value]
             else
                 if temp[value] == true then return true end
             end
         end   
          
	end	  
    return false
end

function check_has_Chinese_words(str)
    local lenInByte = #str
  
    for i=1,lenInByte do
        local curByte = string.byte(str, i)
        local byteCount = 1;
        if curByte > 127 then            
            return true
        end                
    end
    return false
end


---------------------------------------------------------
-------将敏感字表转化为树，提高查询效率           -------
--function start()
--    local root = convert_to_tree(SENSITIVIE_WORDS_TBL)
--    wfile = io.open("sensitive_words_tbl.lua", "w")

--        local tv = "\n"
--        local xn = 0
--        local function tvlinet(xn)
--            -- body
--            for i = 1, xn do
--                tv = tv .. "\t"
--            end
--        end

--        local function printTab(i, v)
--            -- body
--            if type(v) == "table" then
--                tvlinet(xn)
--                xn = xn + 1
--                tv = tv .. "['" .. i .. "']" .. "={\n"
--                table.foreach(v, printTab)
--                tvlinet(xn)
--                tv = tv .. "},\n"
--                xn = xn - 1
--            elseif type(v) == nil then
--                tvlinet(xn)
--                tv = tv .. i .. ":nil\n"
--            else
--                tvlinet(xn)
--                tv = tv .. "['" .. i .. "']" .. "= " .. tostring(v) .. ",\n"
--            end
--        end
--        local function dumpParam(tab)
--            for i = 1, #tab do
--                if tab[i] == nil then
--                    tv = tv .. "nil\t"
--                elseif type(tab[i]) == "table" then
--                    xn = xn + 1
--                    tv = tv .. "\ntable{\n"
--                    table.foreach(tab[i], printTab)
--                    tv = tv .. "\t},\n"
--                else
--                    tv = tv .. tostring(tab[i]) .. "\t"
--                end
--            end
--        end
--        local x = root
--        if type(x) == "table" then
--            table.foreach(x, printTab)
--        else
--            dumpParam( { root})
--            -- table.foreach({...},printTab)
--        end

--        tv = "NEW_SENSITIVE_WORDS_TBL = {" .. tv  .. "}"

--        wfile:write(tv)
--        wfile:close()

--end

--start()

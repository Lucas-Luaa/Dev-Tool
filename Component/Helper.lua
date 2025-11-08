local Helper = {}

function Helper.GetReturnData(fn, ...)
	local results = table.pack(pcall(fn, ...))
	local count = results.n - 1
	results.n = nil
	return table.remove(results, 1), results, count
end


function Helper.MergeCopy(t1, t2)
	local new = {}
	for k, v in pairs(t1) do new[k] = v end
	for k, v in pairs(t2) do
		if new[k] == nil then
			new[k] = v
		end
	end
	return new
end

function Helper.MergeOverwrite(t1, t2)
	local new = {}
	for k, v in pairs(t1) do new[k] = v end
	for k, v in pairs(t2) do new[k] = v end
	return new
end


function Helper.Copy(t)
	local new = {}
	for k, v in pairs(t) do new[k] = v end
	return new
end

function Helper.DeepCopy(t)
	if type(t) ~= "table" then return t end
	local new = {}
	for k, v in pairs(t) do
		new[k] = Helper.DeepCopy(v)
	end
	return new
end

function Helper.Clear(t)
	for k in pairs(t) do
		t[k] = nil
	end
end

function Helper.Count(t)
	local c = 0
	for _ in pairs(t) do c = c + 1 end
	return c
end

return Helper

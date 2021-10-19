local M = {}

local jbeam_io = require('jbeam/io')

local fuel_types = {
	{engine="petrol", fuel="petrol"},
	{engine="diesel", fuel="diesel"},
	{engine="electric", fuel="battery"}
}

string.strEndsWith = function(s, suffix)
	return s:lower():sub(-string.len(suffix:lower())) == suffix:lower()
end

local function randomizeVehicleParts()
	local all_slots = jbeam_io.getAvailableSlotMap(extensions.core_vehicle_manager.getPlayerVehicleData().ioCtx)
	local all_parts = jbeam_io.getAvailableParts(extensions.core_vehicle_manager.getPlayerVehicleData().ioCtx)

	-- Choose fuel type to use randomly
	local fuel_type = fuel_types[math.random(3)]
	
	-- Cycle through each slot
	for slot_name, _ in pairs(all_slots) do
		local parts_for_slot = all_slots[slot_name]
		
		if parts_for_slot then

			if slot_name:match("fueltank") or slot_name:match("fuelcell") then
			
				local filtered_parts = {}
					
				for _, part in pairs(parts_for_slot) do
					if part:match(fuel_type.fuel) then
						table.insert(filtered_parts, part)   
					end
				end
				
				-- If no fueltanks matched the fuel type, find petrol fueltanks
				if #filtered_parts == 0 then
					for _, part in pairs(parts_for_slot) do
						local has_match = false
					
						for _, a_fuel_type in pairs(fuel_types) do
							if part:match(a_fuel_type.fuel) then
								has_match = true
							end
						end
					
						if not has_match then
							table.insert(filtered_parts, part)
						end
					end
				end
				
				all_parts[slot_name] = filtered_parts[math.random(#filtered_parts)]

			elseif slot_name:strEndsWith("engine") then
				local filtered_parts = {}
					
				for _, part in pairs(parts_for_slot) do
					if part:match(fuel_type.engine) then
						table.insert(filtered_parts, part)   
					end
				end
				
				-- If no engines matched the fuel type, find petrol engines
				if #filtered_parts == 0 then
					for _, part in pairs(parts_for_slot) do
						local has_match = false
					
						for _, a_fuel_type in pairs(fuel_types) do
							if part:match(a_fuel_type.engine) then
								has_match = true
							end
						end
					
						if not has_match then
							table.insert(filtered_parts, part)
						end
					end
				end
				
				all_parts[slot_name] = filtered_parts[math.random(#filtered_parts)]		
			
			elseif slot_name:match("differential") then
				if fuel_type.fuel == fuel_types[3].fuel then
					-- Any differential for electric vehicle
				
					local random_part = parts_for_slot[math.random(#parts_for_slot)]			
					all_parts[slot_name] = random_part
					
				else
					-- If not electric vehicle, don't choose electric motor
				
					local filtered_parts = {}
					
					for _, part in pairs(parts_for_slot) do
						if not part:match(fuel_types[3].engine) then
							table.insert(filtered_parts, part)   
						end
					end
					
					all_parts[slot_name] = filtered_parts[math.random(#filtered_parts)]
					
				end
				
			else
				-- Get random part
				
				local random_part = parts_for_slot[math.random(#parts_for_slot)]

				all_parts[slot_name] = random_part
			end         
		end
	end
	
	extensions.core_vehicle_partmgmt.setPartsConfig(all_parts, true)
end

M.randomizeVehicleParts = randomizeVehicleParts

return M
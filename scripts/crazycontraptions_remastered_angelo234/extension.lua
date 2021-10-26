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

local function getRandomFuelTankPart(parts_for_slot, fuel_type)
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
	
	return filtered_parts[math.random(#filtered_parts)]
end

local function getRandomEnginePart(parts_for_slot, fuel_type)
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
	
	return filtered_parts[math.random(#filtered_parts)]
end

local function getRandomDifferentialPart(parts_for_slot, fuel_type)
	if fuel_type.fuel == fuel_types[3].fuel then
		-- Any differential for electric vehicle
	
		return parts_for_slot[math.random(#parts_for_slot)]			
		
	else
		-- If not electric vehicle, don't choose electric motor
	
		local filtered_parts = {}
		
		for _, part in pairs(parts_for_slot) do
			if not part:match(fuel_types[3].engine) then
				table.insert(filtered_parts, part)   
			end
		end
		
		return filtered_parts[math.random(#filtered_parts)]
		
	end
end

local function getRandomFinalDrivePart(parts_for_slot, chosen_final_drive)
	if chosen_final_drive then
		-- If final drive chosen, filter by that final drive
	
		local filtered_parts = {}
					
		for _, part in pairs(parts_for_slot) do
			if part:strEndsWith(chosen_final_drive) then
				table.insert(filtered_parts, part)   
			end		
		end
		
		return filtered_parts[math.random(#filtered_parts)]	
		
	else
		return parts_for_slot[math.random(#parts_for_slot)]	
	
	end
end

local function randomizeVehicleParts()
	local all_slots = jbeam_io.getAvailableSlotMap(extensions.core_vehicle_manager.getPlayerVehicleData().ioCtx)
	local all_parts = jbeam_io.getAvailableParts(extensions.core_vehicle_manager.getPlayerVehicleData().ioCtx)

	local veh_name = be:getPlayerVehicle(0):getJBeamFilename()

	-- Choose fuel type to use randomly
	local fuel_type = fuel_types[math.random(3)]
	
	local chosen_final_drive = nil
	
	-- Cycle through each slot and choose random parts for them
	for slot_name, _ in pairs(all_slots) do
		local parts_for_slot = all_slots[slot_name]
		
		if parts_for_slot then

			-- Some slots need part to be chosen wisely

			if slot_name:find(veh_name) and (slot_name:match("fueltank") or slot_name:match("fuelcell")) then
			
				all_parts[slot_name] = getRandomFuelTankPart(parts_for_slot, fuel_type)

			elseif slot_name:find(veh_name) and slot_name:strEndsWith("engine") then
				
				all_parts[slot_name] = getRandomEnginePart(parts_for_slot, fuel_type)
			
			elseif slot_name:find(veh_name) and slot_name:match("differential") then
			
				all_parts[slot_name] = getRandomDifferentialPart(parts_for_slot, fuel_type)
				
			elseif slot_name:find(veh_name) and slot_name:match("finaldrive") then
				all_parts[slot_name] = getRandomFinalDrivePart(parts_for_slot, chosen_final_drive)
				
				if not chosen_final_drive then
					local split_str = split(all_parts[slot_name], "_")
					
					chosen_final_drive = split_str[#split_str]
				end
				
			else
				-- For all other slots, just get a random part
				
				local random_part = parts_for_slot[math.random(#parts_for_slot)]

				all_parts[slot_name] = random_part
				
			end         
		end
	end
	
	extensions.core_vehicle_partmgmt.setPartsConfig(all_parts, true)
end

M.randomizeVehicleParts = randomizeVehicleParts

return M
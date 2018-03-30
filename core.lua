local DebugMessages = false;

local function strsplit(delimiter, text)
	local list = {}
	local pos = 1
	if strfind("", delimiter, 1) then -- this would result in endless loops
		error("delimiter matches empty string!")
	end
	while 1 do
		local first, last = strfind(text, delimiter, pos)
		if first then -- found?
			tinsert(list, strsub(text, pos, first-1))
			pos = last+1
		else
			tinsert(list, strsub(text, pos))
			break
		end
	end
	return list
end

local function tContains(t, item)
	local index = 1;
	while t[index] do
		if ( item == t[index] ) then
			return 1;
		end
		index = index + 1;
	end
	return nil;
end

local function PrintDebug(msg)
	if ( DebugMessages ) then
		if(ChatFrame2) then
			ChatFrame2:AddMessage(msg, 1.0, 1.0, 0.0);
		end
	end
end
local function Print(msg)
	if ( DEFAULT_CHAT_FRAME ) then 
		DEFAULT_CHAT_FRAME:AddMessage(msg);
	end
end
PrintDebug("FuckingSpam loaded");

local FiltrThisShit = {
-- misc
-- buy/sell
"|htrade:.*cheap", -- yes, it even accepts LUA patterns
"wtt",
"cheap.*|htrade:",
"sell.*|htrade:",
"|htrade:.*sell",
"|htrade:.*mats",
"mats.*|htrade:",
"|htrade:.*/w",
"wts",
"wtb",
"^sell",
"are on sale",
"able to craft.*whisper",
-- pvp
"[235]%s*v[ersu]*[s]?%s*[235]",
-- raids
"^lf%d",
"^lf%s",
"%slf",
"lfm",
"lf%dm",
"lfg",
"need tank",
"for.*w me",
"need %d heal",
"need %d tank",
"need %d dps",
-- imported
"queue%s",
"guild.*recrut",
"%d+.*que[ue]?%s",
"<.+>.*recruit",
"<.+>.*look",
"<.+>.*guild",
"guild.*looking for",
"hitem.*%sat.*%sah",
"gm%spl[s]?[z]?",
"gm%shelp",
"guild.*recruit",
"look.*%sguild",
"%s is recruiting",
"need last.*for",
"guild.*inv.*players",
"^looking for tank",
"join wsg ",
"guild.*active.*player",
"hitem:.*%on ah",
"last%s*spot%s",
"^in ah.*hitem:",
"^need heal ",
".*%sfor%s.*last spot$",
"hitem:.*%sin ah$",
"hitem:.*%sin ah%s",
"%sis recruiting",
"^two more dps",
"^one more dps",
"%s*need%s*tank",
"%need%s+.*tank",
"enchanter in service",
"tank for rfd",
"lf%s*tank",
"^lfw%s",
"^%ddps.*strat",
"^%d+g.*buy.*hitem",
"^...%sneed",
"looking.*for.*raid.*join",
"guild.*seek",
"<.*>.*recruit.*inv",
"<.*>.*info",
"<.*>.*apply"
};

FuckingSpamArray = FuckingSpamArray or {};
lastIgnoredPerson = {};

local blue = "|cff1c91ff";
local green = "|cff4ce334";

function FuckingSpam_ShowHelp()
	Print(blue .. "FuckingSpam:|r usage: /spam add|delete|list|check|debug");
end

SlashCmdList["PSFilter"] = function(_msg)
	if (_msg == "" or _msg == "help") then
		FuckingSpam_ShowHelp();
	else
		local splitted = strsplit(" ", _msg);
		local cmd = splitted[1] or nil
		local arg1 = splitted[2] or nil
		local args_size = table.getn(splitted)
		
		if ( args_size > 2 ) then
			local long_msg = ""
			for i=2,args_size do
				if ( i == args_size ) then
					long_msg = long_msg .. splitted[i]
				else
					long_msg = long_msg .. splitted[i] .. " "
				end
			end
			arg1 = long_msg
		end
		
		if(cmd and arg1) then
		cmd = strlower(cmd);
		arg1 = strlower(arg1);
			--PrintDebug("|cff1e9ae0Command: |r|cff47e434" .. cmd .. "|r|cff1e9ae0, Arg1: |r|cff47e434" .. arg1 .. "|r");
			
			-- add word
			if(cmd == "add" or cmd == "fuck" or cmd == "ins" or cmd == "insert" or cmd == "ffs") then
				if not(tContains(FuckingSpamArray, arg1)) then
					tinsert(FuckingSpamArray, arg1);
					Print("|cff1e9ae0Custom word \"|r|cff47e434" .. arg1 .. "|r|cff1e9ae0\" is now filtered|r");
				else
					Print("|cff1e9ae0Word \"|r|cff47e434" .. arg1 .. "|r|cff1e9ae0\" is already filtered|r");
				end
			end
			-- remove word
			if(cmd == "delete" or cmd == "fuckoff" or cmd == "remove" or cmd == "rem" or cmd == "del") then
				for k,v in ipairs(FuckingSpamArray) do
					if(v == arg1) then
						tremove(FuckingSpamArray, k);
						Print("|cff1e9ae0Word \"|r|cff47e434" .. arg1 .. "|r|cff1e9ae0\" has beed removed|r");
						break;
					end
				end
			end
			-- check word against dictionary
			if(cmd == "check" or cmd == "lookup") then

				local startPos;
				local endPos;
				local msgStart;
				local msgEnd;
				local msgFiltered;
				local ShouldFilter = false;
				local msg = arg1;
				local usedFilter;
				
				for k,v in ipairs(FiltrThisShit) do
					startPos, endPos = strfind(strlower(msg),v)
					if ( startPos ) then
						msgStart = strsub(msg, 1, startPos-1)
						msgFiltered = strsub(msg, startPos, endPos)
						msgEnd = strsub(msg, endPos+1)
						usedFilter = v;
						ShouldFilter = true;
						break;
					end
				end
				
				if ( ShouldFilter ) then
					Print("|cff1e9ae0This message will be filtered (" .. usedFilter .. "): |r" .. msgStart .. green .. msgFiltered .. "|r" .. msgEnd);
				else
					-- check custom words made by user
					for k,v in ipairs(FuckingSpamArray) do
						startPos, endPos = strfind(strlower(msg),v)
						if ( startPos ) then
							msgStart = strsub(msg, 1, startPos-1)
							msgFiltered = strsub(msg, startPos, endPos)
							msgEnd = strsub(msg, endPos+1)
							usedFilter = v;
							ShouldFilter = true;
							break;
						end
					end
					
					if ( ShouldFilter ) then
						Print("|cff1e9ae0This message will be filtered (" .. usedFilter .. "): |r" .. msgStart .. green .. msgFiltered .. "|r" .. msgEnd);
					else
						-- Give up, word was not found neithier in addon dictionary nor user dictionary
						Print("|cff1e9ae0This message will not be filtered: |r" .. msg);
					end
					
				end
				
			end
		elseif(cmd and not arg1) then
		cmd = strlower(cmd);
			if ( cmd == "debug" ) then
				if ( DebugMessages ) then
					DebugMessages = false
					Print("|cff1e9ae0Debug messages disabled.|r");
				else
					DebugMessages = true
					Print("|cff1e9ae0Debug messages enabled, see combat log for details.|r");
				end
			end
			-- list all words
			if(cmd == "list" or cmd == "listall" or cmd == "show" or cmd == "print") then
				local words = nil;
				local num = table.getn(FuckingSpamArray);
				for k,v in ipairs(FuckingSpamArray) do
					if( k ~= num) then
						if words ~= nil then
							words = words .. v .. ", ";
						else
							words =   v .. ", ";
						end
					else 
						if words ~= nil then
							words = words .. v;
						else
							words = v;
						end
					end
				end
				if words == nil then
					Print("|cff1e9ae0Your filter list is empty.|r");
				else
					Print("|cff1e9ae0Filtered custom words are: \"|r|cff47e434" .. words .. "|r|cff1e9ae0\".|r");
				end
			end
			--PrintDebug("|cff1e9ae0Command: |cff47e434" .. cmd .. "|r|r");
		end
	end
end

SLASH_PSFilter1 = "/spam";
SLASH_PSFilter2 = "/ffs";

function FuckingSpan_ChatFrameSupressor_OnEvent(event)
	local ShouldFilter = true; -- false to skip message from frame
	local arg1 = arg1;
	local arg2 = arg2;
	local arg3 = arg3;
	local arg4 = arg4;
	local arg5 = arg5;
	local arg6 = arg6;
	local arg7 = arg7;
	local arg8 = arg8;
	local arg9 = arg9;
	if ( arg1 == nil ) then arg1 = "nil" end
	if ( arg2 == nil ) then arg2 = "nil" end
	if ( arg3 == nil ) then arg3 = "nil" end
	if ( arg4 == nil ) then arg4 = "nil" end
	if ( arg5 == nil ) then arg5 = "nil" end
	if ( arg6 == nil ) then arg6 = "nil" end
	if ( arg7 == nil ) then arg7 = "nil" end
	if ( arg8 == nil ) then arg8 = "nil" end
	if ( arg9 == nil ) then arg9 = "nil" end
	
	
	-- target only world channel, because it's a cancer of all private wow servers
	if ( event == "CHAT_MSG_CHANNEL" and arg9 == "world" ) then
		local msg = arg1;
		local author = arg2;
		
		if ( author == UnitName("player") ) then -- never filter the player
			return ShouldFilter
		end
		
		-- Skip calls from same person & message
		-- actually.. NOPE, cause event seems to be passed to EVERY chat frame
		--[[if ( FuckingSpam_ChatFrameSupressor_OnEvent_LastMessage and FuckingSpam_ChatFrameSupressor_OnEvent_LastSender ) then
			if ( FuckingSpam_ChatFrameSupressor_OnEvent_LastMessage == msg and FuckingSpam_ChatFrameSupressor_OnEvent_LastSender == author ) then
				return true;
			end
		end]]
		
		FuckingSpam_ChatFrameSupressor_OnEvent_LastMessage = msg;
		FuckingSpam_ChatFrameSupressor_OnEvent_LastSender = author;
		
		--PrintDebug("DEBUG msg="..msg)
		--PrintDebug("DEBUG event="..event)
		--PrintDebug("DEBUG arg1="..arg1.." arg2="..arg2.." arg3="..arg3.." arg4="..arg4.." arg5="..arg5.." arg6="..arg6)
		--PrintDebug("DEBUG arg7="..arg7.." arg8="..arg8.." arg9="..arg9)
		
		local floodInt = 35;
		local startPos;
		local endPos;
		local msgStart;
		local msgFiltered;
		local msgEnd;
		
		if (lastIgnoredPerson[author] ~= nil) then -- time-controlled filter
			if ( lastIgnoredPerson[author]+floodInt > time() ) then
				--PrintDebug(blue .. "Timer|r " .. author .. ": " .. msg);
				lastIgnoredPerson[author] = time();
				--return false;
				ShouldFilter = false;
			end
		end
		
		if ( not ShouldFilter ) then
			return ShouldFilter;
		end
		
		for k,v in ipairs(FiltrThisShit) do
			startPos, endPos = strfind(strlower(msg),v)
			if ( startPos ) then
				msgStart = strsub(msg, 1, startPos-1)
				msgFiltered = strsub(msg, startPos, endPos)
				msgEnd = strsub(msg, endPos+1)
				--PrintDebug(blue .. v .. "|r " .. author .. ": " .. gsub(msg,"\124","\124\124") .. "|r");
				PrintDebug(blue .. v .. "|r " .. format("|Hplayer:" .. author .. "|h[" .. author .. "]|h") .. ": " .. msgStart .. green .. msgFiltered .. "|r" .. msgEnd);
				lastIgnoredPerson[author] = time();
				--return false;
				ShouldFilter = false;
				break;
			end
		end
		
		if ( ShouldFilter ) then
			
			-- DEBUG
			local DebugFilters = ""
			
			-- word was not found in addon dictionary, let's check user dictionary
			for k,v in ipairs(FuckingSpamArray) do
				startPos, endPos = strfind(strlower(msg),v)
				DebugFilters = DebugFilters .. v .. " "
				if ( startPos ) then
					msgStart = strsub(msg, 1, startPos-1)
					msgFiltered = strsub(msg, startPos, endPos)
					msgEnd = strsub(msg, endPos+1)
					PrintDebug(blue .. v .. "|r " .. format("|Hplayer:" .. author .. "|h[" .. author .. "]|h") .. ": " .. msgStart .. green .. msgFiltered .. "|r" .. msgEnd);
					lastIgnoredPerson[author] = time();
					ShouldFilter = false;
					break;
				end
			end
			
			-- DEBUG
			if ( DebugLastMsg ) then
				if ( msg ~= DebugLastMsg ) then
					DebugLastMsg = msg
					
					PrintDebug("DEBUG1 " .. format("|Hplayer:" .. author .. "|h[" .. author .. "]|h") .. ": " .. msg .." = \"" .. green .. strupper(msg) .. "\"")
				end
			else
				DebugLastMsg = msg
				
				PrintDebug("DEBUG2 " .. format("|Hplayer:" .. author .. "|h[" .. author .. "]|h") .. ": " .. msg .." = \"" .. green .. strupper(msg) .. "\"")
			end
			
			
			
		end
		
		return ShouldFilter;
	end
	
	return true;
end

--Hook ChatFrame_OnEvent
FuckingSpam_ChatFrame_OnEvent_orig = ChatFrame_OnEvent;
ChatFrame_OnEvent = function(event) if(FuckingSpan_ChatFrameSupressor_OnEvent(event)) then FuckingSpam_ChatFrame_OnEvent_orig(event); end; end;
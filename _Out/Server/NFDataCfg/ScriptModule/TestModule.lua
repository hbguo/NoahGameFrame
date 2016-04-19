TestModule = {}

io.write("TestModule Init!\n");

function TestModule:Init()
	io.write("Lua Init!\n");
	io.write("Addr of pPluginManager " .. tostring(pPluginManager) .. "\n");

	local pKernelModule = pPluginManager:FindKernelModule("NFCKernelModule");
	io.write("Addr of NFCKernelModule " .. tostring(pKernelModule) .. "\n");

	local pLogicClassModule = pPluginManager:FindLogicClassModule("NFCLogicClassModule");
	io.write("Addr of NFCLogicClassModule " .. tostring(pLogicClassModule) .. "\n");

	local pElementInfoModule = pPluginManager:FindElementInfoModule("NFCElementInfoModule");
	io.write("Addr of NFCElementInfoModule " .. tostring(pElementInfoModule) .. "\n");
end

function TestModule:AfterInit()
	io.write("Lua AfterInit!" .. tostring(pLuaScriptModule) .. "\n");

	local pKernelModule = pPluginManager:FindKernelModule("NFCKernelModule");
	pKernelModule:CreateScene(1);

	local pObject = pKernelModule:CreateObject(NFGUID(), 1, 0, "Player", "", NFCDataList());
	local OID = pObject:Self();

	--property callback
	pLuaScriptModule:AddPropertyCallBack(OID, "MAXHP", "TestModule.MaxPropertyCallBack");
	pKernelModule:SetPropertyInt(OID,"MAXHP",100);

	--record callback
	pLuaScriptModule:AddRecordCallBack(OID, "TaskList", "TestModule.TaskListCallBack");
	local varTask =  NFCDataList();
	varTask:AddString("Task_From_Lua");
	varTask:AddInt(1);
	varTask:AddInt(1);

	pLuaScriptModule:AddRow(OID, "TaskList", varTask);
	pKernelModule:SetRecordInt(OID, "TaskList", 0, 1, 3);
	pKernelModule:SetRecordString(OID, "TaskList", 0, 0, "NewStr_Task_From_Lua");

	--event callback
	pLuaScriptModule:AddEventCallBack(OID, 1, "TestModule.EventCallBack");

	local obj = NFCDataList();
	obj:AddInt(21);
	obj:AddFloat(22.5);
	obj:AddString("str23");

	local ident = NFGUID();
	ident:SetHead(241);
	ident:SetData(242);

	obj:AddObject(ident);

	pLuaScriptModule:DoEvent(OID, 1, obj);

	--Hearback
	pLuaScriptModule:AddHeartBeat(OID, "strHeartBeatName", "TestModule.HearCallBack", 1, 55);
end

function TestModule.MaxPropertyCallBack(self, propertyName, oldVar, newVar)
	local nOldVar = oldVar:GetInt();
	local nNewVar = newVar:GetInt();

	local obj = NFCDataList();
	--io.write("Hello Lua MaxPropertyCallBack oldVar:".. nOldVar .." newVar:" .. nNewVar .. "\n");
	io.write("Hello Lua MaxPropertyCallBack oldVar:" .. tostring(nOldVar) .. " newVar:" .. tostring(nNewVar) .. "\n");
end

function TestModule.TaskListCallBack(self, recordName, nOpType, nRow, nCol, oldVar, newVar)
	io.write("Hello Lua TaskListCallBack ")
	if nCol == 0 then
		local nOldVar = oldVar:GetString();
		local nNewVar = newVar:GetString();

		io.write(" nOpType:".. tostring(nOpType).. " oldVar:".. tostring(nOldVar) .." newVar:" .. tostring(nNewVar) .. "\n");
	end

	if nCol == 1 then
		local nOldVar = oldVar:GetInt();
		local nNewVar = newVar:GetInt();

		io.write(" nOpType:".. tostring(nOpType).. " oldVar:".. tostring(nOldVar) .." newVar:" .. tostring(nNewVar) .. "\n");
	end

end

function TestModule.EventCallBack(self, nEventID, arg)
	local nValue = arg:Int(0);
	local fValue = arg:Float(1);
	local strValue = arg:String(2);


	local ident = arg:Object(3);
	local head = ident:GetHead();
	local data = ident:GetData();

	io.write("Hello Lua EventCallBack nEventID:".. nEventID .. "\n");
	io.write("\r\targ:nValue:".. tostring(nValue) .. " fValue:"..tostring(fValue).. " strValue:"..tostring(strValue).." head:"..tostring(head).." data:"..tostring(data).."\n");
end

function TestModule:HearCallBack(self, strHeartBeat, fTime, nCount)
	local obj = NFCDataList();
	io.write("Hello Lua HearCallBack :".. strHeartBeat .. "\n");
end

function TestModule.OnClassCommonEvent(self, strClassName, eventID, varData)
	--io.write("onClassCommonEvent, ClassName: " .. tostring(strClassName) .. " EventID: " .. tostring(eventID) .. "\n");
end

function TestModule.OnRecordCommonEvent(self, xEventData, oldVar, newVar)
	--io.write("OnRecordCommonEvent, self: " .. tostring(self) .. " xEventData: " .. tostring(xEventData) .. " oldVar: " .. tostring(oldVar) .. " newVar: " .. tostring(newVar) .. "\n");
end

function TestModule.OnPropertyCommEvent(self, strPropertyName, oldVar, newVar)
	--io.write("OnPropertyCommEvent, self: " .. tostring(self) .. " strPropertyName: " .. tostring(strPropertyName) .. " oldVar: " .. tostring(oldVar) .. " newVar: " .. tostring(newVar) .. "\n");
end

function TestModule:Execute()
	io.write("Lua Execute!\n");
end

function TestModule:BeforeShut()
	io.write("Lua BeforeShut!\n");
end

function TestModule:Shut()
	io.write("Lua Shut!\n");
end
--[[
function TestModule:AfterInit(kernel, self)
	io.write("Hello Lua AfterInit!\n");

	if kernel == nil then
		io.write("kernel is nil\n");
	end

	if self == nil then
		io.write("self is nil\n");
	end

	io.write("Start use C++ functions\n");
	nMaxhp = GetPropertyInt(kernel, self, "MAXHP");
	--io.write("Hello Lua MAXHP:" ..nMaxhp .. "\n");

	--property callback
	AddPropertyCallBack(kernel, self, "MAXHP", "TestModule", "MaxPropertyCallBack");
	local maxHP = 400;
	SetPropertyInt(kernel, self, "MAXHP", maxHP);

	nMaxhp = GetPropertyInt(kernel, self, "MAXHP");
	--io.write("Hello Lua GetPropertyInt MAXHP:" ..nMaxhp .. "\n");

	--record callback
	AddRecordCallBack(kernel, self, "TaskList","TestModule", "TaskListCallBack");

	local varTask =  NFCDataList();
	varTask:AddString("Task_From_Lua");
	varTask:AddInt(1);
	varTask:AddInt(1);

	AddRow(kernel, self, "TaskList", varTask);
	SetRecordInt(kernel, self, "TaskList", 0, 1, 3);
	SetRecordString(kernel, self, "TaskList", 0, 0, "NewStr_Task_From_Lua");
	--event callback
	AddEventCallBack(kernel, self, 1, "TestModule", "EventCallBack");

	local obj = NFCDataList();
	obj:AddInt(21);
	obj:AddFloat(22.5);
	obj:AddString("str23");

	local ident = NFGUID();
	ident:SetHead(241);
	ident:SetData(242);

	obj:AddObject(ident);

	io.write("aaaaaaaaaaaaaaaaaa\n");
	DoEvent(kernel, self, 1, obj);

	--Hearback
	AddHeartBeat(kernel, self, "strHeartBeatName","TestModule", "HearCallBack", 1, 55);
end
--]]

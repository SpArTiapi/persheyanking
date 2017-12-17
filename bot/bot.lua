#start Project Anti Spam V5:)
json = dofile('./libs/JSON.lua')
serpent = dofile("./libs/serpent.lua")
redis =  dofile("./libs/redis.lua")
minute = 60
hour = 3600
day = 86400
offset = 0
week = 604800
local color = {
  black = {30, 40},
  red = {31, 41},
  green = {32, 42},
  yellow = {33, 43},
  blue = {34, 44},
  magenta = {35, 45},
  cyan = {36, 46},
  white = {37, 47}
}
SendApi = '451264924:AAFeOQRoYoLJK56AWb-w_G5sYehJ5lYpEvI' ---Token Bot
SDP_ID = redis:get('BOT-ID')
http = require "socket.http"
utf8 = dofile('./bot/utf8.lua')
json = dofile('./libs/JSON.lua')
djson = dofile('./libs/dkjson.lua')
http = require("socket.http")
https = require("ssl.https")
URL = require("socket.url")
https = require "ssl.https"
shieldteam = '`اختصاصی تیم شیلد `'
SUDO_ID = {374668345} --Admins
Full_Sudo = {374668345} --Sudo --- 
ChannelLogs = -1001055437458 ---Channel log
BotHelper = 451264924 --ID Bot helper
Channel = '@ShieldTeamS' -- Channel
MsgTime = os.time() - 60
Plan1 = 2592000
Plan2 = 7776000
function UpTime()
  local uptime = io.popen("uptime"):read("*all")
  days = uptime:match("up %d+ days")
  hours = uptime:match(",  %d+:")
  minutes = uptime:match(":%d+,")
    sec = uptime:match(":%d+ up")
  if hours then
    hours = hours
  else
    hours = ""
  end
  if days then
    days = days
  else
    days = ""
  end
  if minutes then
    minutes = minutes
  else
    minutes = ""
  end
  days = days:gsub("up", "")
  local a_ = string.match(days, "%d+")
  local b_ = string.match(hours, "%d+")
  local c_ = string.match(minutes, "%d+")
   local d_ = string.match(sec, "%d+")
  if a_ then
    a = a_
  else
    a = 0
  end
  if b_ then
    b = b_
  else
    b = 0
  end
  if c_ then
    c = c_
  else
    c = 0
  end
    if d_ then
    d = d_
  else
    d = 0
  end
return a..'روز و '..b..' ساعت و '..c..' دقیقه و '..d..' ثانیه'
end
local function getParse(parse_mode)
local P = {}
if parse_mode then
local mode = parse_mode:lower()
if mode == 'markdown' or mode == 'md' then
P._ = 'textParseModeMarkdown'
elseif mode == 'html' then
P._ = 'textParseModeHTML'
end
end
return P
end
function is_sudo(msg)
local var = false
for v,user in pairs(SUDO_ID) do
if user == msg.sender_user_id then
var = true
end
end
if redis:sismember("SUDO-ID", msg.sender_user_id) then
var = true
end
return var
end
function is_Fullsudo(msg)
local var = false
for v,user in pairs(Full_Sudo) do
if user == msg.sender_user_id then
var = true
end
end
return var 
end
function is_GlobalyBan(user_id)
local var = false
local hash = 'GlobalyBanned:'
local gbanned = redis:sismember(hash, user_id)
if gbanned then
var = true
end
return var
end
-- Owner Msg
function is_Owner(msg) 
local hash = redis:sismember('OwnerList:'..msg.chat_id,msg.sender_user_id)
if hash or is_sudo(msg) then
return true
else
return false
end
end
-----shield team
function is_Mod(msg) 
  local hash = redis:sismember('ModList:'..msg.chat_id,msg.sender_user_id)
if hash or is_sudo(msg) or is_Owner(msg) then
return true
else
return false
end
end
function is_Vip(msg) 
local hash = redis:sismember('Vip:'..msg.chat_id,msg.sender_user_id)
if hash or is_sudo(msg) or is_Owner(msg) or is_Mod(msg) then
return true
else
return false
end
end
function is_Banned(chat_id,user_id)
local hash =  redis:sismember('BanUser:'..chat_id,user_id)
if hash then
return true
else
return false
end
end
function private(chat_id,user_id)
local Mod = redis:sismember('ModList:'..chat_id,user_id)
local Vip = redis:sismember('Vip:'..chat_id,user_id)
local Owner = redis:sismember('OwnerList:'..chat_id,user_id)
if tonumber(user_id) == tonumber(SDP_ID) or Owner or Mod or Vip then
return true
else
return false
end
end
function is_filter(msg,value)
local list = redis:smembers('Filters:'..msg.chat_id)
var = false
for i=1, #list do
if value:match(list[i]) then
var = true
end
end
return var
end
function is_MuteUser(chat_id,user_id)
local hash =  redis:sismember('MuteUser:'..chat_id,user_id)
if hash then
return true
else
return false
end
end
function ec_name(name) 
shield = name
if shield then
if shield:match('_') then
shield = shield:gsub('_','')
end
if shield:match('*') then
shield = shield:gsub('*','')
end
if shield:match('`') then
shield = shield:gsub('`','')
end
return shield
end
end
function check_markdown(text)
str = text
if str:match('_') then
output = str:gsub('_',[[_]])
elseif str:match('*') then
output = str:gsub('*','\\*')
elseif str:match('`') then
output = str:gsub('`','\\`')
else
output = str
end
return output
end
function sendText(chat_id,msg,text, parse)
assert( tdbot_function ({
_ = "sendMessage",chat_id = chat_id,
reply_to_message_id = msg,
disable_notification = 0,
from_background = 1,
reply_markup = nil,
input_message_content = {
_ = "inputMessageText",text = text,
disable_web_page_preview = 1,
clear_draft = 0,
parse_mode = getParse(parse),
entities = {}
}
}, dl_cb, nil))
end

local function getChatId(chat_id)
local chat = {}
local chat_id = tostring(chat_id)
if chat_id:match('^-100') then
local channel_id = chat_id:gsub('-100', '')
chat = {id = channel_id, type = 'channel'}
else
local group_id = chat_id:gsub('-', '')
chat = {id = group_id, type = 'group'}
end
return chat
end
local function getMe(cb)
assert (tdbot_function ({
_ = "getMe",
}, cb, nil))
end
function Pin(channelid,messageid,disablenotification)
assert (tdbot_function ({
_ = "pinChannelMessage",
channel_id = getChatId(channelid).id,
message_id = messageid,
disable_notification = disablenotification
}, dl_cb, nil))
end
function Unpin(channelid)
assert (tdbot_function ({
_ = 'unpinChannelMessage',
channel_id = getChatId(channelid).id
}, dl_cb, nil))
end
function KickUser(chat_id, user_id)
tdbot_function ({
_ = "changeChatMemberStatus",
chat_id = chat_id,
user_id = user_id,
status = {
_ = "chatMemberStatusBanned"
},
}, dl_cb, nil)
end
function getFile(fileid,cb)
assert (tdbot_function ({
_ = 'getFile',
file_id = fileid
}, cb, nil))
end
function Call(userid)
  assert (tdbot_function ({
    _ = 'createCall',
    user_id = userid,
  }, dl_cb, nil))
end

function Left(chat_id, user_id, s)
assert (tdbot_function ({
_ = "changeChatMemberStatus",
chat_id = chat_id,
user_id = user_id,
status = {
_ = "chatMemberStatus" ..s
},
}, dl_cb, nil))
end
function changeDes(shield,sdp)
assert (tdbot_function ({
_ = 'changeChannelDescription',
channel_id = getChatId(shield).id,
description = sdp
}, dl_cb, nil))
end
function changeChatTitle(chat_id, title)
assert (tdbot_function ({
_ = "changeChatTitle",
chat_id = chat_id,
title = title
}, dl_cb, nil))
end

function mute(chat_id, user_id, Restricted, right)
local chat_member_status = {}
if Restricted == 'Restricted' then
chat_member_status = {
is_member = right[1] or 1,
restricted_until_date = right[2] or 0,
can_send_messages = right[3] or 1,
can_send_media_messages = right[4] or 1,
can_send_other_messages = right[5] or 1,
can_add_web_page_previews = right[6] or 1
}
chat_member_status._ = 'chatMemberStatus' .. Restricted
assert (tdbot_function ({
_ = 'changeChatMemberStatus',
chat_id = chat_id,
user_id = user_id,
status = chat_member_status
}, dl_cb, nil))
end
end
function promoteToAdmin(chat_id, user_id)
tdbot_function ({
_ = "changeChatMemberStatus",
chat_id = chat_id,
user_id = user_id,
status = {
_ = "chatMemberStatusAdministrator"
},
}, dl_cb, nil)
end
function resolve_username(username,cb)
tdbot_function ({
_ = "searchPublicChat",
username = username
}, cb, nil)
end
function RemoveFromBanList(chat_id, user_id)
tdbot_function ({
_ = "changeChatMemberStatus",
chat_id = chat_id,
user_id = user_id,
status = {
_ = "chatMemberStatus" .."Left"
},
}, dl_cb, nil)
end

function getChatHistory(chat_id, from_message_id, offset, limit,cb)
tdbot_function ({
_ = "getChatHistory",
chat_id = chat_id,
from_message_id = from_message_id,
offset = offset,
limit = limit
}, cb, nil)
end
function deleteMessagesFromUser(chat_id, user_id)
tdbot_function ({
_ = "deleteMessagesFromUser",
chat_id = chat_id,
user_id = user_id
}, dl_cb, nil)
end
function deleteMessages(chat_id, message_ids)
tdbot_function ({
_= "deleteMessages",
chat_id = chat_id,
message_ids = message_ids -- vector {[0] = id} or {id1, id2, id3, [0] = id}
}, dl_cb, nil)
end
local function getMessage(chat_id, message_id,cb)
tdbot_function ({
_ = "getMessage",
chat_id = chat_id,
message_id = message_id
}, cb, nil)
end
 function GetChat(chatid,cb)
assert (tdbot_function ({
_ = 'getChat',
chat_id = chatid
}, cb, nil))
end
function sendInline(chatid, replytomessageid, disablenotification, frombackground, queryid, resultid)
assert (tdbot_function ({
_ = 'sendInlineQueryResultMessage',
chat_id = chatid,
reply_to_message_id = replytomessageid,
disable_notification = disablenotification,
from_background = frombackground,
query_id = queryid,
result_id = tostring(resultid)
}, dl_cb,nil))
end
function get(bot_user_id, chat_id, latitude, longitude, query,offset, cb)
  assert (tdbot_function ({
_ = 'getInlineQueryResults',
 bot_user_id = bot_user_id,
chat_id = chat_id,
user_location = {
 _ = 'location',
latitude = latitude,
longitude = longitude 
},
query = tostring(query),
offset = tostring(off)
}, cb, nil))
end
function  viewMessages(chat_id, message_ids)
tdbot_function ({
_ = "viewMessages",
chat_id = chat_id,
message_ids = message_ids
}, dl_cb, nil)
end
local function getInputFile(file, conversion_str, expectedsize)
local input = tostring(file)
local infile = {}
if (conversion_str and expectedsize) then
infile = {
_ = 'inputFileGenerated',
original_path = tostring(file),
conversion = tostring(conversion_str),
expected_size = expectedsize
}
else
if input:match('/') then
infile = {_ = 'inputFileLocal', path = file}
elseif input:match('^%d+$') then
infile = {_ = 'inputFileId', id = file}
else
infile = {_ = 'inputFilePersistentId', persistent_id = file}
end
end
return infile
end
local function getVector(str)
  local v = {}
  local i = 1
  for k in string.gmatch(str, '(%d%d%d+)') do
    v[i] = '[' .. i-1 .. ']="' .. k .. '"'
    i = i+1
  end
  v = table.concat(v, ',')
  return load('return {' .. v .. '}')()
end
function addChatMembers(chatid, userids)
  assert (tdbot_function ({
    _ = 'addChatMembers',
    chat_id = chatid,
    user_ids = getVector(userids),
}, dl_cb, nil))
end
function GetChannelFull(channelid)
assert (tdbot_function ({
 _ = 'getChannelFull',
channel_id = getChatId(channelid).id
}, cb, nil))
end
function sendGame(chat_id, reply_to_message_id, botuserid, gameshortname, disable_notification, from_background, reply_markup)
local input_message_content = {
_ = 'inputMessageGame',
bot_user_id = botuserid,
game_short_name = tostring(gameshortname)
}
sendMessage(chat_id, reply_to_message_id, input_message_content, disable_notification, from_background, reply_markup)
end
function SendMetin(chat_id, user_id, msg_id, text, offset, length)
assert (tdbot_function ({
_ = "sendMessage",
chat_id = chat_id,
reply_to_message_id = msg_id,
disable_notification = 0,
from_background = true,
reply_markup = nil,
input_message_content = {
_ = "inputMessageText",
text = text,
disable_web_page_preview = 1,
clear_draft = false,
entities = {[0] = {
offset = offset,
length = length,
_ = "textEntity",
type = {
user_id = user_id,
 _ = "textEntityTypeMentionName"}
}
}
}
}, dl_cb, nil))
end
local function edit(chat_id, message_id, text,length,user_id)
tdbot_function ({
_ = "editMessageText",
chat_id = chat_id,
message_id = message_id,
reply_markup= 0, -- reply_markup:ReplyMarkup
input_message_content = {
_= "inputMessageText",
text = text,
disable_web_page_preview = 1,
clear_draft = 0,
entities = {[0] = {
offset = 0,
length = length,
_ = "textEntity",
type = {
user_id = user_id,
 _ = "textEntityTypeMentionName"}
}
}
}
}, dl_cb, nil)
end
function changeChatPhoto(chat_id,photo)
assert (tdbot_function ({
_ = 'changeChatPhoto',
chat_id = chat_id,
photo = getInputFile(photo)
}, dl_cb, nil))
end
function getFile(fileid)
assert (tdbot_function ({
_ = 'getFile',
file_id = fileid
},dl_cb,nil))
end
function GetWeb(messagetext,cb)
assert (tdbot_function ({
_ = 'getWebPagePreview',
message_text = tostring(messagetext)
}, cb, nil))
end
function downloadFile(fileid)
assert (tdbot_function ({
_ = 'downloadFile',
file_id = fileid,
},  dl_cb, nil))
end
local function sendMessage(c, e, r, n, e, r, callback, data)
assert (tdbot_function ({
_ = 'sendMessage',
chat_id = c,
reply_to_message_id =e,
disable_notification = r or 0,
from_background = n or 1,
reply_markup = e,
input_message_content = r
}, callback or dl_cb, data))
end
local function sendPhoto(chat_id, reply_to_message_id, disable_notification, from_background, reply_markup, photo, caption)
assert (tdbot_function ({
_= "sendMessage",
chat_id = chat_id,
reply_to_message_id = reply_to_message_id,
disable_notification = disable_notification,
from_background = from_background,
reply_markup = reply_markup,
input_message_content = {
_ = "inputMessagePhoto",
photo = getInputFile(photo),
added_sticker_file_ids = {},
width = 0,
height = 0,
caption = caption.."\n"..check_markdown(Channel)
},
}, dl_cb, nil))
end
function GetUser(user_id, cb)
assert (tdbot_function ({
_ = 'getUser',
user_id = user_id
}, cb, nil))
end
local function GetUserFull(user_id,cb)
assert (tdbot_function ({
_ = "getUserFull",
user_id = user_id
}, cb, nil))
end
function file_exists(name)
local f = io.open(name,"r")
if f ~= nil then
io.close(f)
return true
else
return false
end
end
function getChannelFull(shield,sdp)
assert (tdbot_function ({
_ = 'getChannelFull',
channel_id = getChatId(shield).id
}, sdp, nil))
end
function setProfilePhoto(photo_path)
assert (tdbot_function ({
_ = 'setProfilePhoto',
photo = photo_path
},  dl_cb, nil))
end
function ForMsg(chat_id, from_chat_id, message_id,from_background)
assert (tdbot_function ({
_ = "forwardMessages",
chat_id = chat_id,
from_chat_id = from_chat_id,
message_ids = message_id,
disable_notification = 0,
from_background = from_background
}, dl_cb, nil))
end
function getChannelMembers(channelid,mbrfilter,off, limit,cb)
if not limit or limit > 2000000000 then
limit = 2000000000 
end  
assert (tdbot_function ({
_ = 'getChannelMembers',
channel_id = getChatId(channelid).id,
filter = {
_ = 'channelMembersFilter' .. mbrfilter,
},
offset = off,
limit = limit
}, cb, nil))
end
function sendVideoNote(chat_id, reply_to_message_id,disable_notification,from_background ,reply_markup,videonote, vnote_thumb, vnote_duration, vnote_length)
assert (tdbot_function ({
_= "sendMessage",
chat_id = chat_id,
reply_to_message_id = reply_to_message_id,
disable_notification = disable_notification,
from_background = from_background,
reply_markup = reply_markup,
input_message_content = {
_ = 'inputMessageVideoNote',
video_note = getInputFile(videonote),
},
}, dl_cb, nil))
end
function sendGame(chat_id, msg_id, botuserid, gameshortname)
assert (tdbot_function ({
_ = "sendMessage",
chat_id = chat_id,
reply_to_message_id = msg_id,
disable_notification = 0,
from_background = true,
reply_markup = nil,
input_message_content = {
_ = 'inputMessageGame',
bot_user_id = botuserid,
game_short_name = tostring(gameshortname)
}
}, dl_cb, nil))
end
function file_exists(name)
local f = io.open(name,"r")
if f ~= nil then
io.close(f)
return true
else
return false
end
end
function SendMetion(chat_id, user_id, msg_id, text, offset, length)
assert (tdbot_function ({
_ = "sendMessage",
chat_id = chat_id,
reply_to_message_id = msg_id,
disable_notification = 0,
from_background = true,
reply_markup = nil,
input_message_content = {
_ = "inputMessageText",
text = text,
disable_web_page_preview = 1,
clear_draft = false,
entities = {[0] = {
offset =  offset,
length = length,
_ = "textEntity",
type = {user_id = user_id, _ = "textEntityTypeMentionName"}}}
}
}, dl_cb, nil))
end
function dl_cb(arg, data)
end
function is_supergroup(msg)
chat_id = tostring(msg.chat_id)
if chat_id:match('^-100') then 
if not msg.is_post then
return true
end
else
return false
end
end
 function showedit(msg,data)
if msg then
if msg.date < tonumber(MsgTime) then
print('OLD MESSAGE')
return false
end
if is_supergroup(msg) then
if not is_sudo(msg) then
if not redis:sismember('sdpAll',msg.chat_id) then
redis:sadd('sdpAll',msg.chat_id)
redis:set("ExpireData:"..msg.chat_id,'w')
else
if redis:get("ExpireData:"..msg.chat_id) then
if redis:ttl("ExpireData:"..msg.chat_id) and tonumber(redis:ttl("ExpireData:"..msg.chat_id)) < 432000 and not redis:get('CheckExpire:'..msg.chat_id) then
end
redis:set('CheckExpire:'..msg.chat_id,true)
elseif not redis:get("ExpireData:"..msg.chat_id) then
sendText(msg.chat_id,0,"شارژ  "..msg.chat_id.." این گروه به اتمام رسیده است لطفا به مدیر ربات مراجعه کنید","md")
local Link = redis:get('Link:'..msg.chat_id) or 'ثبت نشده'
local textt =[[ شارز گروه زیر به اتمام رسیده است 
شناسه گروه : ]]..msg.chat_id..[[
لینگ گروه : ]]..Link..[[
]]

sendText(ChannelLogs,0,textt,'md')
print(Link)
redis:del("OwnerList:",msg.chat_id)
redis:del("ModList:",msg.chat_id)
redis:del("Filters:",msg.chat_id)
redis:del("MuteList:",msg.chat_id)
Left(msg.chat_id,SDP_ID, "Left")
end       
end
end
end
if is_Owner(msg) then
if msg.content._ == 'messagePinMessage' then
print '      Pinned By Owner       '
redis:set('Pin_id'..msg.chat_id, msg.content.message_id)
end
end
forcemax = 3
if redis:get('force:Max:'..msg.chat_id) then
forcemax = redis:get('force:Max:'..msg.chat_id)
end
forcetime = 30
if redis:get('force:Time:'..msg.chat_id) then
forcetime = redis:get('force:Time:'..msg.chat_id)
end
NUM_MSG_MAX = 6
if redis:get('Flood:Max:'..msg.chat_id) then
NUM_MSG_MAX = redis:get('Flood:Max:'..msg.chat_id)
end
NUM_CH_MAX = 200
if redis:get('NUM_CH_MAX:'..msg.chat_id) then
NUM_CH_MAX = redis:get('NUM_CH_MAX:'..msg.chat_id)
end
TIME_CHECK = 2
if redis:get('Flood:Time:'..msg.chat_id) then
TIME_CHECK = redis:get('Flood:Time:'..msg.chat_id)
end
warn = 5
if redis:get('Warn:Max:'..msg.chat_id) then
warn = redis:get('Warn:Max:'..msg.chat_id)
end
if redis:get('Force:CH'..msg.chat_id) then
warn = redis:get('Force:CH:'..msg.chat_id)
end
if is_supergroup(msg) then
forceaddfor = msg.chat_id..'AddedOK'
added = tonumber(redis:hget('addeduser'..msg.chat_id,msg.sender_user_id) or 1)
function forcestats(msg,status)
if status == "new user" then
if msg.content._ == "messageChatJoinByLink" or msg.content._ == "messageChatAddMembers" then
redis:sadd('forceaddfor'..msg.chat_id,msg.sender_user_id)
deleteMessages(msg.chat_id, {[0] = msg.id})
elseif msg.add then
deleteMessages(msg.chat_id, {[0] = msg.id})
redis:sadd('forceaddfor'..msg.chat_id,msg.add)
end
end
if status == "all" then
if msg.sender_user_id then
deleteMessages(msg.chat_id, {[0] = msg.id})
redis:sadd('forceaddfor'..msg.chat_id,msg.sender_user_id)
end
end
end
if redis:get('forceAdd:'..msg.chat_id) and not is_Mod(msg) and not redis:hget(forceaddfor,msg.sender_user_id) then
print'                  Force Add Enable                          '
local status = redis:get('Force:Status:'..msg.chat_id)
forcestats(msg,status)
end
if redis:sismember('forceaddfor'..msg.chat_id,msg.sender_user_id) and not redis:hget('test'..msg.chat_id,msg.sender_user_id) then
sendText(msg.chat_id,msg.id,"کاربر : "..msg.sender_user_id.." شما باید ("..forcemax..") نفر به گروه اضافه کنید تا مجوز سخن گفتن را بدست بیاورید","md")
redis:hset('test'..msg.chat_id,msg.sender_user_id,true) 
end
if redis:sismember('forceaddfor'..msg.chat_id,msg.sender_user_id) then
deleteMessagesFromUser(msg.chat_id,msg.sender_user_id) 
end
if redis:get('forceAdd:'..msg.chat_id) and not redis:get('deleteallmsgs:'..msg.chat_id) then
deleteMessagesFromUser(msg.chat_id,SDP_ID) 
redis:setex('deleteallmsgs:'..msg.chat_id,tonumber(forcetime),true)
end
-------------Mute All -------------
function muteallstats(msg,status)
if status == "Restricted" then
 if tonumber(msg.sender_user_id) == tonumber(SDP_ID)  then
return true
end
redis:sadd('Mutes:'..msg.chat_id,msg.sender_user_id)
deleteMessages(msg.chat_id, {[0] = msg.id})
print ' mute all '
mute(msg.chat_id,msg.sender_user_id,'Restricted',  {1,0, 0, 0, 0,0})
end
if status == "deletemsg" then
 if tonumber(msg.sender_user_id) == tonumber(SDP_ID)  then
return true
end
deleteMessages(msg.chat_id, {[0] = msg.id})
print ' mute all '
deleteMessagesFromUser(msg.chat_id,msg.sender_user_id) 
end
end
-------------Flood Check------------
function antifloodstats(msg,status)
if status == "kickuser" then
 if tonumber(msg.sender_user_id) == tonumber(SDP_ID)  then
return true
end
sendText(msg.chat_id, msg.id,'_کاربر ـ  : `'..(msg.sender_user_id)..'`  ـبه علت ارسال بیش از حد پیام  از گروه اخراج شدـ' ,'md')
KickUser(msg.chat_id,msg.sender_user_id)
end
if status == "deletemsg" then
 if tonumber(msg.sender_user_id) == tonumber(SDP_ID)  then
return true
end
sendText(msg.chat_id, msg.id,'تمام پیام های  : `'..(msg.sender_user_id)..'` به علت ارسال بیش از حد پیام پاک شد' ,'md')
deleteMessagesFromUser(msg.chat_id,msg.sender_user_id) 
end
if status == "muteuser" then
 if tonumber(msg.sender_user_id) == tonumber(SDP_ID)  then
return true
end
if is_MuteUser(msg.chat_id,msg.sender_user_id) then
 else
sendText(msg.chat_id, msg.id,'کاربر : `'..(msg.sender_user_id)..'` به علت ارسال بیش از حد پیام در گروه محدود شد' ,'md')
mute(msg.chat_id,msg.sender_user_id,'Restricted',   {1, 0, 0, 0, 0,0})
redis:sadd('MuteList:'..msg.chat_id,msg.sender_user_id)
end
end
end
if redis:get('Lock:Flood:'..msg.chat_id) then
if not is_Mod(msg) then
local post_count = 'user1:' .. msg.sender_user_id .. ':flooder'
local msgs = tonumber(redis:get(post_count) or 0)
if msgs > tonumber(NUM_MSG_MAX) then
if redis:get('user:'..msg.sender_user_id..':flooder') then
local status = redis:get('Flood:Status:'..msg.chat_id)
antifloodstats(msg,status)
return false
else
redis:setex('user:'..msg.sender_user_id..':flooder', 15, true)
end
end
redis:setex(post_count, tonumber(TIME_CHECK), msgs+1)
end
end
end
function forcejoin(msg) 
local url  = https.request('https://api.telegram.org/bot'..SendApi..'/getchatmember?chat_id='..Channel..'&user_id='..msg.sender_user_id)
sdp = json:decode(url)
local forcestatus = true
if sdp.result.status == "left" or sdp.result.status == "kicked" or not sdp.ok then
forcestatus = sendText(msg.chat_id,msg.id,'ابتدا باید در کانال زیر عضو شوید،سپس مجدد دستور خود را ارسال کنید\n'..Channel, 'html')
end
return forcestatus
end
-------------MSG shield ------------
local shield = msg.content.text
local shield1 = msg.content.text
if shield then
shield = shield:lower()
end
 if MsgType == 'text' and shield then
if shield:match('^[/#!]') then
shield= shield:gsub('^[/#!]','')
end
end
--------------MSG TYPE----------------
 if msg.content._== "messageText" then
MsgType = 'text'
end
if msg.content._ == "messageChatAddMembers" then
for i=0,#msg.content.member_user_ids do
msg.add = msg.content.member_user_ids[i]
MsgType = 'AddUser'
end
end
if msg.content._ == "messageChatJoinByLink" then
MsgType = 'JoinedByLink'
end
if msg.content._ == "messageDocument" then
MsgType = 'Document'
end
if msg.content._ == "messageSticker" then
print("[ shieldteam ]\nThis is [ Sticker ]")
MsgType = 'Sticker'
end
if msg.content._ == "messageAudio" then
print("[ shieldteam ]\nThis is [ Audio ]")
MsgType = 'Audio'
end
if msg.content._ == "messageVoice" then
print("[ shieldteam ]\nThis is [ Voice ]")
MsgType = 'Voice'
end
if msg.content._ == "messageVideo" then
print("[ shieldteam ]\nThis is [ Video ]")
MsgType = 'Video'
end
if msg.content._ == "messageAnimation" then
print("[ shieldteam ]\nThis is [ Gif ]")
MsgType = 'Gif'
end
if msg.content._ == "messageLocation" then
print("[ shieldteam ]\nThis is [ Location ]")
MsgType = 'Location'
end
if msg.content._ == "messageForwardedFromUser" then
print("[ shieldteam ]\nThis is [ messageForwardedFromUser ]")
MsgType = 'messageForwardedFromUser'
end

if msg.content._ == "messageContact" then
print("[ shieldteam ]\nThis is [ Contact ]")
MsgType = 'Contact'
end
if not msg.reply_markup and msg.via_bot_user_id ~= 0 then
print(serpent.block(data))
print("[ shieldteam ]\nThis is [ MarkDown ]")
MsgType = 'Markreed'
end
if msg.content.game then
print("[ shieldteam ]\nThis is [ Game ]")
MsgType = 'Game'
end
if msg.content._ == "messagePhoto" then
MsgType = 'Photo'
end
if msg.sender_user_id and is_GlobalyBan(msg.sender_user_id) and not SDP_ID then
sendText(msg.chat_id, msg.id,'کاربر  : `'..msg.sender_user_id..'` شما در لیست سیاه ربات قرارر دارید','md')
KickUser(msg.chat_id,msg.sender_user_id)
end

if MsgType == 'AddUser' then
function ByAddUser(shield,sdp)
if is_GlobalyBan(sdp.id) then
print '                      >>>>Is  Globall Banned <<<<<       '
sendText(msg.chat_id, msg.id,'کاربر : `'..sdp.id..'` در لیست سیاه قرار دارد','md')
end
GetUser(msg.content.member_user_ids[0],ByAddUser)
end
end
if msg.sender_user_id and is_Banned(msg.chat_id,msg.sender_user_id) then
KickUser(msg.chat_id,msg.sender_user_id)
end
local welcome = (redis:get('Welcome:'..msg.chat_id) or 'disable') 
if welcome == 'enable' then
if MsgType == 'JoinedByLink' then
print '                       JoinedByLink                        '
if is_Banned(msg.chat_id,msg.sender_user_id) then
KickUser(msg.chat_id,msg.sender_user_id)
sendText(msg.chat_id, msg.id,'کاربر : `'..msg.sender_user_id..'` شما از این گروه محروم شده اید','md')
else
function WelcomeByLink(shield,sdp)
if redis:get('Text:Welcome:'..msg.chat_id) then
txtt = redis:get('Text:Welcome:'..msg.chat_id)
else
txtt = 'سلام \nخوش امدی'
end
local hash = "Rules:"..msg.chat_id
local shield = redis:get(hash) 
if shield then
rules=shield
else
rules= '`قوانین ثبت نشده است`'
end
local hash = "Link:"..msg.chat_id
local shield = redis:get(hash) 
if shield then
link=shield
else
link= 'لینک گروه ثبت نشده است'
end
local txtt = txtt:gsub('{first}',ec_name(sdp.first_name))
local txtt = txtt:gsub('{rules}',rules)
local txtt = txtt:gsub('{link}',link)
local txtt = txtt:gsub('{last}',sdp.last_name or '')
local txtt = txtt:gsub('{username}','@'..check_markdown(sdp.username) or '')
sendText(msg.chat_id, msg.id, txtt,'md')
 end
GetUser(msg.sender_user_id,WelcomeByLink)
end
end
if msg.add then
if is_Banned(msg.chat_id,msg.add) then
KickUser(msg.chat_id,msg.add)
sendText(msg.chat_id, msg.id,'کاربر : `'..msg.add..'` در لیست سیاه قرار دارد','md')
else
function WelcomeByAddUser(shield,sdp)
print('New User : \nChatID : '..msg.chat_id..'\nUser ID : '..msg.add..'')
if redis:get('Text:Welcome:'..msg.chat_id) then
txtt = redis:get('Text:Welcome:'..msg.chat_id)
else
txtt = 'سلام \n خوش امدی'
end
local hash = "Rules:"..msg.chat_id
local shield = redis:get(hash) 
if shield then
rules=shield
else
rules= 'قوانین ثبت نشده است'
end
local hash = "Link:"..msg.chat_id
local shield = redis:get(hash) 
if shield then
link=shield
else
link= 'لینک گروه ثبت نشده است'
end
local txtt = txtt:gsub('{first}',ec_name(sdp.first_name))
local txtt = txtt:gsub('{rules}',rules)
local txtt = txtt:gsub('{link}',link)
local txtt = txtt:gsub('{last}',sdp.last_name or '')
local txtt = txtt:gsub('{username}','@'..check_markdown(sdp.username) or '')
sendText(msg.chat_id, msg.id, txtt,'html')
end
GetUser(msg.add,WelcomeByAddUser)
end
end
end
viewMessages(msg.chat_id, {[0] = msg.id})
redis:incr('Total:messages:'..msg.chat_id..':'..msg.sender_user_id)
if msg.send_state._ == "messageIsSuccessfullySent" then
return false 
end   
if redis:get('forceAdd:'..msg.chat_id) and not redis:hget(forceaddfor,msg.sender_user_id) and not is_Mod(msg) and not is_Vip(msg) then 
if MsgType == 'AddUser' then
function forceAdd(shield,sdp)
if sdp.type._ == "userTypeBot" then
print '               Bot added              '  
sendText(msg.chat_id, msg.id, 'کاربر '..ec_name(sdp.first_name)..' شما نمیتوانید ربات را به گروه اضافه کنید ', 'md')
KickUser(msg.chat_id,sdp.id)
else
if tonumber(forcemax) == tonumber(added) then
redis:hset(forceaddfor,msg.sender_user_id,true)
redis:srem('forceaddfor'..msg.chat_id,msg.sender_user_id)
redis:hdel('test'..msg.chat_id,msg.sender_user_id) 
else 
added = tonumber(added) + 1
sendText(msg.chat_id,msg.id,"متشکرم : "..ec_name(sdp.first_name).." شما یک نفر را به گروه اضافه کردید \nتعداد مانده : "..forcemax.."/"..added,"md")
redis:hset('addeduser'..msg.chat_id,msg.sender_user_id,added)
print '             ok Adding            '
end 
end
end
GetUser(msg.add,forceAdd)
end
end
----------Msg Checks-------------
local chat = msg.chat_id
if redis:get('CheckBot:'..msg.chat_id)  then
if not is_Owner(msg) then
if redis:get('Lock:Pin:'..chat) then
if msg.content._ == 'messagePinMessage' then
print '      Pinned By Not Owner       '
sendText(msg.chat_id, msg.id, 'Only Owners', 'md')
Unpin(msg.chat_id)
local PIN_ID = redis:get('Pin_id'..msg.chat_id)
if Pin_id then
Pin(msg.chat_id, tonumber(PIN_ID), 0)
end
end
end
end
if not is_Mod(msg) and not is_Vip(msg)  then
local chat = msg.chat_id
local user = msg.sender_user_id
----------Lock Link-------------
if redis:get('Lock:Link'..chat) then
 if shield then
local link = (shield:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/") or shield:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]/") or shield:match("[Tt].[Mm][Ee]/") or shield:match('(.*)[.][mM][Ee]') or shield:match('[Ww][Ww][Ww].(.*)') or shield:match('(.*).[Ii][Rr]') or shield:match('[Hh][Tt][Tt][Pp][Ss]://(.*)') or shield:match('[Ww][Ww][Ww].(.*)') or msg.content.text:match('http://(.*)'))
if link  then
if msg.content.entities and msg.content.entities[0] and msg.content.entities[0].type._ == "textEntityTypeUrl" then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("Deleted [Lock] [Link] ")
end
end
end

if msg.content.caption then
local cap = msg.content.caption
local link = (cap:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/") or cap:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]/") or cap:match("[Tt].[Mm][Ee]/") or cap:match('(.*)[.][mM][Ee]') or cap:match('(.*).[Ii][Rr]') or cap:match('[Ww][Ww][Ww].(.*)') or cap:match('[Hh][Tt][Tt][Pp][Ss]://') or msg.content.caption:match('http://(.*)'))
if link then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("Deleted [Lock] [Caption] [Link] ")

end
end
end 
---------------------------
if redis:get('Lock:Tag:'..chat) then
if shield then
local tag = shield:match("@(.*)") or shield:match("@")
if tag then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("Deleted [Lock] [Tag] ")

end
end
if msg.content.caption then
local shield = msg.content.caption
local tag = shield:match("@(.*)")
if tag then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("Deleted [Lock] [Caption] [Tag] ")
end
end
end
---------------------------
if redis:get('Lock:HashTag:'..chat) then
if msg.content.text then
if msg.content.text:match("#(.*)") or msg.content.text:match("#(.*)") or msg.content.text:match("#") then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("Deleted [Lock] [HashTag] ")
end
end
if msg.content.caption then
if msg.content.caption:match("#(.*)")  or msg.content.caption:match("(.*)#") or msg.content.caption:match("#") then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("Deleted [Lock] [Caption] [HashTag] ")

end
end
end
---------------------------
if redis:get('Lock:Video_note:'..chat) then
if msg.content._ == 'messageVideoNote' then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("Deleted [Lock] [VideoNote] ")
end
end
---------------------------
if redis:get('Lock:Arabic:'..chat) then
 if shield and shield:match("[\216-\219][\128-\191]") then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("Deleted [Lock] [Persian] ")
end 
if msg.content.caption then
local shield = msg.content.caption
local is_persian = shield:match("[\216-\219][\128-\191]")
if is_persian then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("Deleted [Lock] [Persian] ")
end
end
end
--------------------------
if redis:get('Lock:English:'..chat) then
if shield and (shield:match("[A-Z]") or shield:match("[a-z]")) then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("Deleted [Lock] [English] ")
end 
if msg.content.caption then
local shield = msg.content.caption
local is_english = (shield:match("[A-Z]") or shield:match("[a-z]"))
if is_english then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("Deleted [Lock] [ENGLISH] ")
end
end
end
if redis:get('Spam:Lock:'..chat) then
 if MsgType == 'text' then
 local _nl, ctrl_chars = string.gsub(msg.content.text, '%c', '')
 local _nl, real_digits = string.gsub(msg.content.text, '%d', '')
local hash = 'NUM_CH_MAX:'..msg.chat_id
if not redis:get(hash) then
sens = 40
else
sens = tonumber(redis:get(hash))
end
local max_real_digits = tonumber(sens) * 50
local max_len = tonumber(sens) * 51
if string.len(msg.content.text) >  sens or ctrl_chars > sens or real_digits >  sens then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("Deleted [Lock] [Spam] ")
end
end
end
----------Filter------------
if shield then
 if is_filter(msg,shield) then
 deleteMessages(msg.chat_id, {[0] = msg.id})
print("Deleted [Filter] ")

 end 
end
-----------------------------------------------
if redis:get('Lock:Bot:'..chat) then
if MsgType == 'AddUser' and msg.add then
function ByAddUser(shield,sdp)
if sdp.type._ == "userTypeBot" then
print '               Bot added              '  
KickUser(msg.chat_id,sdp.id)
end
end
GetUser(msg.add,ByAddUser)
end
end
-----------------------------------------------
if redis:get('Lock:Markdown:'..chat) then
if msg.content.entities and msg.content.entities[0] and (msg.content.entities[0].type._ == "textEntityTypeBold" or msg.content.entities[0].type._ == "textEntityTypeCode" or msg.content.entities[0].type._ == "textEntityTypeitalic") then 
deleteMessages(msg.chat_id, {[0] = msg.id})
print("Deleted [Lock] [Markdown] ")
end
end
----------------------------------------------
if redis:get('Lock:Inline:'..chat) then
 if not msg.reply_markup and msg.via_bot_user_id ~= 0 then
 deleteMessages(msg.chat_id, {[0] = msg.id})
print("Deleted [Lock] [Inline] ")
end
end
----------------------------------------------
if redis:get('Lock:TGservise:'..chat) then
if msg.content._ == "messageChatJoinByLink" or msg.content._ == "messageChatAddMembers" or msg.content._ == "messageChatDeleteMember" then
 deleteMessages(msg.chat_id, {[0] = msg.id})
end
end
------------------------------------------------
if redis:get('Lock:Forward:'..chat) then
if msg.forward_info then
deleteMessages(msg.chat_id, {[0] = msg.id})
end
end
--------------------------------
if redis:get('Lock:Sticker:'..chat) then
if  MsgType == 'Sticker' then
deleteMessages(msg.chat_id, {[0] = msg.id})
end
end
----------Lock Edit-------------
if redis:get('Lock:Edit'..chat) then
if msg.edit_date > 0 then
deleteMessages(msg.chat_id, {[0] = msg.id})
end
end
-------------------------------Mutes--------------------------
if redis:get('Mute:Text:'..chat) then
if MsgType == 'text' then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("Deleted [Lock] [Text] ")
end
end
--------------------------------
if redis:get('automuteall'..msg.chat_id) and (redis:get("automutestart"..msg.chat_id) or redis:get("automuteend"..msg.chat_id)) then
local time = os.date("%H%M")
local start = redis:get("automutestart"..msg.chat_id)
local endtime = redis:get("automuteend"..msg.chat_id)
if tonumber(endtime) < tonumber(start) then
if tonumber(time) <= 2359 and tonumber(time) >= tonumber(start) then
if not redis:get("MuteAll:"..msg.chat_id) then
redis:set("MuteAll:"..msg.chat_id,true)
end
elseif tonumber(time) >= 0000 and tonumber(time) < tonumber(endtime) then
if not redis:get("MuteAll:"..msg.chat_id) then
sendText(msg.chat_id, msg.id,'گروه قفل میباشد لطفا پیامی ارسال نکنید !' , 'md')
redis:set("MuteAll:"..msg.chat_id,true)
end
else
if redis:get("MuteAll:"..msg.chat_id) then
sendText(msg.chat_id, msg.id,'قفل خودکار غیرفعال شد !' , 'md')
local mutes =  redis:smembers('Mutes:'..msg.chat_id)
for k,v in pairs(mutes) do
redis:srem('MuteList:'..msg.chat_id,v)
mute(msg.chat_id,v,'Restricted',   {1, 1, 1, 1, 1,1})
redis:del("MuteAll:"..msg.chat_id)
end
end
end
elseif tonumber(endtime) > tonumber(start) then
if tonumber(time) >= tonumber(start) and tonumber(time) < tonumber(endtime) then
if not redis:get("MuteAll:"..msg.chat_id) then
sendText(msg.chat_id, msg.id,'گروه قفل میباشد لطفا پیامی ارسال نکنید !' , 'md')
redis:set("MuteAll:"..msg.chat_id,true)
end
else
if redis:get("MuteAll:"..msg.chat_id) then
sendText(msg.chat_id, msg.id,'قفل خودکار غیرفعال شد !' , 'md')
redis:del("MuteAll:"..msg.chat_id)
end
end
end
end
-----------------------------------------
if redis:get('Mute:Photo:'..chat) then
 if MsgType == 'Photo' then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("Deleted [Lock] [Photo] ")
end
end 
-------------------------------
if redis:get('Mute:Caption:'..chat) then
if msg.content.caption then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("Deleted [Lock] [Caption] ")
end
end 
-------------------------------
if redis:get('Mute:Reply:'..chat) then
if tonumber(msg.reply_to_message_id) > 0 then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("Deleted [Lock] [Reply] ")
end
end 
-------------------------------
if redis:get('Mute:Document:'..chat) then
if MsgType == 'Document' then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("Deleted [Lock] [Docment] ")
end
end
---------------------------------
if redis:get('Mute:Location:'..chat) then
if MsgType == 'Location' then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("Deleted [Lock] [Location] ")
end
end
-------------------------------
if redis:get('Mute:Voice:'..chat) then
if MsgType == 'Voice' then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("[ shieldteam ] Deleted [Lock] [Voice] ")
end
end
-------------------------------
if redis:get('Mute:Contact:'..chat) then
if MsgType == 'Contact' then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("[ shieldteam ] Deleted [Lock] [Contact] ")
end
end
-------------------------------
if redis:get('Mute:Game:'..chat) then
if MsgType == 'Game' then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("[ shieldteam ] Deleted [Lock] [Game] ")
end
end
--------------------------------
if redis:get('Mute:Video:'..chat) then
if MsgType == 'Video' then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("[ shieldteam ] Deleted [Lock] [Video] ")
end
end
--------------------------------
if redis:get('Mute:Music:'..chat) then
if MsgType == 'Audio' then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("[ shieldteam ] Deleted [Lock] [Music] ")
end
end
-----------Mtes Gif------------
if redis:get('Mute:Gif:'..chat) then
if MsgType == 'Gif' then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("[ shieldteam ] Deleted [Lock] [Gif] ")
end
end
end
end
------------Chat Type------------
function is_channel(msg)
chat_id = tostring(msg.chat_id)
if chat_id:match('^-100') then 
if msg.is_post then
return true
else
return false
end
end
end
function is_group(msg)
chat_id= tostring(msg.chat_id)
if chat_id:match('^-100') then 
return false
elseif chat_id_:match('^-') then
return true
else
return false
end
end
function is_private(msg)
chat_id = tostring(msg.chat_id)
if chat_id:match('^(%d+)') then
print'           ty                                   '
return false
else
return true
end
end
local function run_bash(str)
local cmd = io.popen(str)
local result = cmd:read('*all')
return result
end

if is_Fullsudo(msg) then
if shield and shield:match('^setsudo (%d+)') then
local sudo = shield:match('^setsudo (%d+)')
redis:sadd('SUDO-ID',sudo)
sendText(msg.chat_id, msg.id, '• کاربر `'..sudo..'` به لیست مدیران ربات اضافه شد', 'md')
end
if shield and shield:match('^remsudo (%d+)') then
local sudo = shield:match('^remsudo (%d+)')
redis:srem('SUDO-ID',sudo)
sendText(msg.chat_id, msg.id, '• کاربر `'..sudo..'` از لیست صاحبان ربات حذف شد', 'md')
end
if shield == 'sudolist' then
local hash =  "SUDO-ID"
local list = redis:smembers(hash)
local t = '*Sudo list: *\n'
for k,v in pairs(list) do 
local user_info = redis:hgetall('user:'..v)
if user_info and user_info.username then
local username = user_info.username
t = t..k.." - @"..username.." ["..v.."]\n"
else
t = t..k.." - "..v.."\n"
end
end
if #list == 0 then
t = 'لیست خالی لیست'
end
sendText(msg.chat_id, msg.id,t, 'md')
end
end
if is_supergroup(msg) then
if shield == 'test' then
redis:del('Request1:')
end
if is_sudo(msg) then
if shield == 'bc' and tonumber(msg.reply_to_message_id) > 0 then
function shieldteam(shield,sdp)
local text = sdp.content.text
local list = redis:smembers('sdpAll')
for k,v in pairs(list) do
sendText(v, 0, text, 'md')
end
end
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),shieldteam)
end
if shield == 'fwd' and tonumber(msg.reply_to_message_id) > 0 then
function shieldteam(shield,sdp)
local list = redis:smembers('sdpAll')
for k,v in pairs(list) do
ForMsg(v, msg.chat_id, {[0] = sdp.id}, 1)
end
end
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),shieldteam)
end
if shield and shield:match('^addme (-100)(%d+)$') then
local chat_id = shield:match('^addme (.*)$')
sendText(msg.chat_id,msg.id,'با موفقيت تورو به گروه '..chat_id..' اضافه کردم.','md')
addChatMembers(chat_id,{[0] = msg.sender_user_id})
end
if shield == 'add' then
local function GetName(shield, sdp)
if not redis:get("ExpireData:"..msg.chat_id) then
redis:setex("ExpireData:"..msg.chat_id,day,true)
end 
  redis:sadd("group:",msg.chat_id)
if redis:get('CheckBot:'..msg.chat_id) then
local text = '• گروه `'..sdp.title..'` از قبل در لیست گروه های مدیریتی ربات وجود دارد'
 sendText(msg.chat_id, msg.id,text,'md')
else
local text = '• `گروه ` *'..sdp.title..'* ` به لیست گروه های مدیریتی اضافه شد`'
local Hash = 'StatsGpByName'..msg.chat_id
local ChatTitle = sdp.title
redis:set(Hash,ChatTitle)
print('• New Group\nChat name : '..sdp.title..'\nChat ID : '..msg.chat_id..'\nBy : '..msg.sender_user_id)
local textlogs =[[•• گروه جدیدی به لیست مدیریت اضافه شد 
• اطلاعات گروه :
• نام گروه ]]..sdp.title..[[
• آیدی گروه : ]]..msg.chat_id..[[
• توسط : ]]..msg.sender_user_id..[[
• برای عضویت در گروه میتوانید از  دستور  [addme] استفاده کنید 
> مثال : addme -10023456789878
]]
redis:set('CheckBot:'..msg.chat_id,true) 
if not redis:get('CheckExpire:'..msg.chat_id) then
redis:set('CheckExpire:'..msg.chat_id,true)
end
 sendText(msg.chat_id, msg.id,text,'md')

 sendText(ChannelLogs, 0,textlogs,'html')
end
end
GetChat(msg.chat_id,GetName)
end
if shield == 'ids' then 
sendText(msg.chat_id,msg.id,''..msg.chat_id..'','md')
end
			
if shield == 'reload' then
 dofile('./bot/bot.lua')
sendText(msg.chat_id,msg.id,'• سیستم ربات بروز شد','md')
end 
if shield == 'vardump' then 
function id_by_reply(extra, result, success)
    local TeXT = serpent.block(result, {comment=false})
text= string.gsub(TeXT, "\n","\n\r\n")
sendText(msg.chat_id, msg.id, text,'html')
 end
if tonumber(msg.reply_to_message_id) == 0 then
else
getMessage(msg.chat_id, 
tonumber(msg.reply_to_message_id),id_by_reply)
end
end
if shield == 'rem' then
local function GetName(shield, sdp)
redis:del("ExpireData:"..msg.chat_id)
redis:srem("group:",msg.chat_id)
redis:del("OwnerList:"..msg.chat_id)
redis:del("ModList:"..msg.chat_id)
redis:del('StatsGpByName'..msg.chat_id)
redis:del('CheckExpire:'..msg.chat_id)
 if not redis:get('CheckBot:'..msg.chat_id) then
local text = '• گروه  `'..sdp.title..'` در لیست گروه های مدیریتی قرار ندارد'
 sendText(msg.chat_id, msg.id,text,'md')
else
local text = '• `گروه ` *'..sdp.title..'* ` از لیست گروه های مدیریتی حذف شد`'
local Hash = 'StatsGpByName'..msg.chat_id
redis:del(Hash)
 sendText(msg.chat_id, msg.id,text,'md')
 redis:del('CheckBot:'..msg.chat_id) 
end
end
GetChat(msg.chat_id,GetName)
end
if shield and shield:match('^tdset (%d+)$') then
local SDP_ID = shield:match('^tdset (%d+)$')
redis:set('BOT-ID',SDP_ID)
 sendText(msg.chat_id, msg.id,'شناسه ربات جدید ذخیره شد \n شناسه  : '..SDP_ID,'md')
end
if shield and shield:match('^invite (%d+)$') then
local id = shield:match('^invite (%d+)$')
addChatMembers(msg.chat_id,{[0] = id})
 sendText(msg.chat_id, msg.id,'کاربر به گروه دعوت شد','md')
end
if shield1 and shield1:match('^plan1 (-100)(%d+)$') then
local chat_id = shield1:match('^plan1 (.*)$')
if redis:get('CheckExpire:'..msg.chat_id) then
redis:set('CheckExpire:'..msg.chat_id,true)
end
redis:setex("ExpireData:"..chat_id,Plan1,true)
sendText(msg.chat_id,msg.id,'پلن 1 با موفقيت براي گروه '..chat_id..' فعال شد\nاين گروه تا 30 روز ديگر اعتبار دارد! ( 1 ماه )','md')
sendText(chat_id,0,"ربات با موفقيت فعال شد و تا 30 روز ديگر اعتبار دارد!",'md')
end
------------------Charge Plan 2--------------------------
if shield and shield:match('^plan2 (-100)(%d+)$') then
local chat_id = shield:match('^plan2 (.*)$')
redis:setex("ExpireData:"..chat_id,Plan2,true)
sendText(msg.chat_id,msg.id,'پلن 2 با موفقيت براي گروه '..chat_id..' فعال شد\nاين گروه تا 90 روز ديگر اعتبار دارد! ( 3 ماه )','md')
sendText(chat_id,0,"ربات با موفقيت فعال شد و تا 90 روز ديگر اعتبار دارد! ( 3 ماه )",'md')
if redis:get('CheckExpire:'..msg.chat_id) then
redis:set('CheckExpire:'..msg.chat_id,true)
end
end
-----------------Charge Plan 3---------------------------
if shield and shield:match('^plan3 (-100)(%d+)$') then
local chat_id = shield:match('^plan3 (.*)$')
redis:set("ExpireData:"..chat_id,true)
sendText(msg.chat_id ,msg.id,''..chat_id..'_پلن شماره 3 براي گروه مورد نظر فعال شد!_','md')
sendText(chat_id,0,"_پلن شماره ? براي اين گروه تمديد شد \nمدت اعتبار پنل (نامحدود)!_",'md')
if redis:get('CheckExpire:'..msg.chat_id) then
redis:set('CheckExpire:'..msg.chat_id,true)
end
end
-----------Leave----------------------------------
if shield1 and shield1:match('^leave (-100)(%d+)$') then
local chat_id = shield1:match('^leave (.*)$') 
redis:del("ExpireData:"..chat_id)
redis:srem("group:",chat_id)
redis:del("OwnerList:"..chat_id)
redis:del("ModList:"..chat_id)
redis:del('StatsGpByName'..chat_id)
redis:del('CheckExpire:'..chat_id)
sendText(msg.chat_id,msg.id,'ربات از گروه  '..chat_id..' خارج شد','md')
sendText(chat_id,0,'','md')
Left(chat_id,SDP_ID, "Left")
end 
if shield == 'groups' then
local list = redis:smembers('group:')
local t = '• Groups\n'
for k,v in pairs(list) do
local GroupsName = redis:get('StatsGpByName'..v)
t = t..k.."  *"..v.."*\n "..(GroupsName or '---').."\n" 
end
if #list == 0 then
t = '• لیست خالی است'
end
sendText(msg.chat_id, msg.id,t, 'md')
end
if shield and shield:match('^charge (%d+)$') then
local function GetName(shield, sdp)
local time = tonumber(shield:match('^charge (%d+)$')) * day
 redis:setex("ExpireData:"..msg.chat_id,time,true)
local ti = math.floor(time / day )
local text = '• `گروه ` *'..sdp.title..'* ` شارژ شد ` به مدت  *'..ti..'* روز'
sendText(msg.chat_id, msg.id,text,'md')
if redis:get('CheckExpire:'..msg.chat_id) then
 redis:set('CheckExpire:'..msg.chat_id,true)
end
end
GetChat(msg.chat_id,GetName)
end
if shield == 'message_id' then
sendText(msg.chat_id, msg.id,msg.reply_to_message_id,'md')
end
if shield == "expire" then
local ex = redis:ttl("ExpireData:"..msg.chat_id)
if ex == -1 then
sendText(msg.chat_id, msg.id,  "• نامحدود", 'md' )
else
local d = math.floor(ex / day ) + 1
sendText(msg.chat_id, msg.id,d.."  Day",  'md' )
end
end
if shield == 'leave' then
sendText(msg.chat_id, msg.id,  "• ربات از گروه خارج میشود", 'md' )
Left(msg.chat_id, SDP_ID, 'Left')
end
if shield and shield:match('^call (%d+)$') then
local user_id = shield:match('^call (%d+)$')
Call(user_id)
sendText(msg.chat_id, msg.id,"Done",  'md' )
end
if msg.inline_query_placeholder == 'login' then
print 'tesy'
end
if shield == 'stats' then
local allmsgs = redis:get('allmsgs')
local supergroup = redis:scard('ChatSuper:Bot')
local Groups = redis:scard('Chat:Normal')
local users = redis:scard('ChatPrivite')
local user = io.popen("whoami"):read('*a')
 local uptime = UpTime()
local totalredis = io.popen("du -h /var/lib/redis/dump.rdb"):read("*a")
sizered= string.gsub(totalredis, "/var/lib/redis/dump.rdb","")
local totalbot = io.popen("du -h ./bot/bot.lua"):read("*a")
SourceSize = string.gsub(totalbot, "./bot/bot.lua","")
local text =[[
• تمام پیام های چک شده  : ]]..allmsgs..[[
سوپر گروه ها :]]..supergroup..[[
گروه ها : ]]..Groups..[[
کاربران   : ]]..users..[[
یوزر : ]]..user..[[
آپتایم : ]]..uptime..[[
مقدار مصرف شده ردیس : ]]..sizered..
[[
حجم سورس : ]]..SourceSize
sendText(msg.chat_id, msg.id,text,  'md' )
end
if shield == 'reset' then
 redis:del('allmsgs')
redis:del('ChatSuper:Bot')
 redis:del('Chat:Normal')
 redis:del('ChatPrivite')
sendText(msg.chat_id, msg.id,'آمار ربات از نو شروع شد',  'md' )
end
if shield == 'ownerlist' then
local list = redis:smembers('OwnerList:'..msg.chat_id)
local t = '• OwnerList\n'
for k,v in pairs(list) do
t = t..k.." - *"..v.."*\n" 
end
t = t.."\n\n• شما میتوانید از دستور زیر برای دیدن کاربر استفاده کنید !\nwhois شناسه کاربر\nمثال ! \nwhois 363936960"
if #list == 0 then
t = 'The list is empty'
end
sendText(msg.chat_id, msg.id,t, 'md')
end
if shield and shield:match('^setrank (.*)$') then
local rank = shield:match('^setrank (.*)$') 
local function SetRank_Rep(shield, sdp)
if tonumber(sdp.sender_user_id) == tonumber(SDP_ID) then
sendText(msg.chat_id, msg.id,  'اوه شت :( \nمن نمیتوانم پیام خودم را چک کنم', 'md')
return false
end
redis:set('rank'..sdp.sender_user_id,rank)
local user = sdp.sender_user_id
SendMetion(msg.chat_id,sdp.sender_user_id, msg.id, '• مقام کاربر '..user..' به '..rank..' تغییر کرد', 13,string.len(sdp.sender_user_id))
end
if tonumber(msg.reply_to_message_id) == 0 then
else
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),SetRank_Rep)
end
end
----------------------SetOwner--------------------------------
if shield == 'setowner' then
local function SetOwner_Rep(shield, sdp)
local user = sdp.sender_user_id
if redis:sismember('OwnerList:'..msg.chat_id,user) then
SendMetion(msg.chat_id,sdp.sender_user_id, msg.id, '• کاربر : '..sdp.sender_user_id..' در لیست صاحبان گروه قرار دارد..!', 10,string.len(sdp.sender_user_id))
else
SendMetion(msg.chat_id,sdp.sender_user_id, msg.id, '• کاربر : '..sdp.sender_user_id..' به لیست صاحبان گروه اضافه شد ..', 10,string.len(sdp.sender_user_id))
redis:sadd('OwnerList:'..msg.chat_id,user)
end
end
if tonumber(msg.reply_to_message_id) == 0 then
else
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),SetOwner_Rep)
end
end
if shield and shield:match('^setowner (%d+)') then
local user = shield:match('setowner (%d+)')
if redis:sismember('OwnerList:'..msg.chat_id,user) then
SendMetion(msg.chat_id,user, msg.id, '• کاربر : '..user..' از قبل در لیست صاحبان گروه قرار داشت', 10,string.len(user))
else
SendMetion(msg.chat_id,user, msg.id, '• کاربر : '..user..' به لیست صاحبان گروه اضافه شد', 10,string.len(user))
redis:sadd('OwnerList:'..msg.chat_id,user)
end
end
if shield and shield:match('^setowner @(.*)') then
local username = shield:match('^setowner @(.*)')
function SetOwnerByUsername(shield,sdp)
if sdp.id then
print(''..sdp.id..'')
if redis:sismember('OwnerList:'..msg.chat_id,sdp.id) then
SendMetion(msg.chat_id,sdp.id, msg.id, '• کاربر  : '..sdp.id..'از قبل در لیست صاحبان گروه قرار داشت ', 10,string.len(sdp.id))
else
SendMetion(msg.chat_id,sdp.id, msg.id, '• کاربر : '..sdp.id..' به لیست صاحبان گروه اضافه شد', 10,string.len(sdp.id))
redis:sadd('OwnerList:'..msg.chat_id,sdp.id)
end
else 
text = '• کاربر یافت نشد'
sendText(msg.chat_id, msg.id, text, 'md')
end
end
resolve_username(username,SetOwnerByUsername)
end
if shield == 'remowner' then
local function RemOwner_Rep(shield, sdp)
local user = sdp.sender_user_id
if redis:sismember('OwnerList:'..msg.chat_id, sdp.sender_user_id) then
SendMetion(msg.chat_id,sdp.sender_user_id, msg.id, '• کاربر  : '..(sdp.sender_user_id)..' از لیست صاحبان گروه حذف شد ', 9,string.len(sdp.sender_user_id))
redis:srem('OwnerList:'..msg.chat_id,sdp.sender_user_id)
else
SendMetion(msg.chat_id,sdp.sender_user_id, msg.id, '• کاربر  : '..(sdp.sender_user_id)..' در لیست صاحبان گروه وجود ندارد', 9,string.len(sdp.sender_user_id))
end
end
if tonumber(msg.reply_to_message_id) == 0 then
else
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),RemOwner_Rep)
end
end
if shield and shield:match('^remowner (%d+)') then
local user = shield:match('remowner (%d+)')
if redis:sismember('OwnerList:'..msg.chat_id,user) then
SendMetion(msg.chat_id,user, msg.id, '• کاربر : '..user..' از لیست صاحبان گروه حذف شد ', 10,string.len(user))
redis:srem('OwnerList:'..msg.chat_id,user)
else
SendMetion(msg.chat_id,user, msg.id, '• کاربر : '..user..' در لیست صاحبان گروه وجود ندارد',10,string.len(user))
end
end
if shield and shield:match('^remowner @(.*)') then
local username = shield:match('^remowner @(.*)')
function RemOwnerByUsername(shield,sdp)
if sdp.id then
print(''..sdp.id..'')
if redis:sismember('OwnerList:'..msg.chat_id, sdp.id) then
SendMetion(msg.chat_id,sdp.id, msg.id, '• کاربر : '..sdp.id..' از لیست صاحبان گروه پاک شد', 10,string.len(sdp.id))
redis:srem('OwnerList:'..msg.chat_id,sdp.id)
else
SendMetion(msg.chat_id,sdp.id, msg.id, '• کاربر : '..sdp.id..' در لیست صاحبان گروه وجود ندارد', 10,string.len(sdp.id))
end
else  
text = '• کاربر یافت نشد'
sendText(msg.chat_id, msg.id, text, 'md')
end
end
resolve_username(username,RemOwnerByUsername)
end
if shield == 'clean ownerlist' then
redis:del('OwnerList:'..msg.chat_id)
sendText(msg.chat_id, msg.id,'لیست صاحبان گروه پاکسازی شد', 'md')
end
---------Start---------------Globaly Banned-------------------
if shield == 'banall' then
function GbanByReply(shield,sdp)
if redis:sismember('GlobalyBanned:',sdp.sender_user_id) then
sendText(msg.chat_id, msg.id,  '• `کاربر : ` *'..(sdp.sender_user_id)..'* قبلا در لیست وجود دارد', 'md')
else
sendText(msg.chat_id, msg.id,'• _ کاربر : _ `'..(sdp.sender_user_id)..'` به لیست سیاه اضافه شد', 'md')
redis:sadd('GlobalyBanned:',sdp.sender_user_id)
end
end
if tonumber(msg.reply_to_message_id) == 0 then
else
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),GbanByReply)
end
end
if shield and shield:match('^banall (%d+)') then
local user = shield:match('^banall (%d+)')
if redis:sismember('GlobalyBanned:',user) then
sendText(msg.chat_id, msg.id,  '• `کاربر : ` *'..user..'* قبلا در لیست سیاه وجود دارد', 'md')
else
sendText(msg.chat_id, msg.id,'• _ User : _ `'..user..'` به لیست سیاه اضافه شد', 'md')
redis:sadd('GlobalyBanned:',user)
end
end
if shield and shield:match('^banall @(.*)') then
local username = shield:match('^banall @(.*)')
function BanallByUsername(shield,sdp)
if sdp.id then
print(''..sdp.id..'')
if redis:sismember('GlobalyBanned:', sdp.id) then
text  ='• `کاربر : ` *'..sdp.id..'* از قبل در لیست سیاه وجود دارد'
else
text= '• _ کاربر : _ `'..sdp.id..'` به لیست سیاه اضافه شد'
redis:sadd('GlobalyBanned:',sdp.id)
end
else 
text = '• کاربر یافت نشد'
end
sendText(msg.chat_id, msg.id, text, 'md')
end
resolve_username(username,BanallByUsername)
end
if shield == 'gbans' then
local list = redis:smembers('GlobalyBanned:')
local t = 'Globaly Ban:\n'
for k,v in pairs(list) do
t = t..k.." - *"..v.."*\n" 
end
t = t.."\n\n• شما میتوانید از دستور زیر برای دیدن کاربر استفاده کنید !\nwhois شناسه کاربر\nمثال ! \nwhois 363936960"
if #list == 0 then
t = 'لیست '
end
sendText(msg.chat_id, msg.id,t, 'md')
end
if shield == 'clean gbans' then
redis:del('GlobalyBanned:')
sendText(msg.chat_id, msg.id,'• لیست سیاه پاکسازی شد', 'md')
end
---------------------Unbanall--------------------------------------
if shield and shield:match('^unbanall (%d+)') then
local user = shield:match('unbanall (%d+)')
if tonumber(user) == tonumber(SDP_ID) then
sendText(msg.chat_id, msg.id,  'اوه شت :( \nمن نمیتوانم پیام خودم را چک کنم', 'md')
return false
end
if redis:sismember('GlobalyBanned:',user) then
sendText(msg.chat_id, msg.id,'• _ کاربر : _ `'..user..'` از لیست سیاه حذف  شد', 'md')
redis:srem('GlobalyBanned:',user)
else
sendText(msg.chat_id, msg.id,  '• `کاربر : ` *'..user..'* در لیست سیاه وجود ندارد', 'md')
end
end
if shield and shield:match('^unbanall @(.*)') then
local username = shield:match('^unbanall @(.*)')
function UnbanallByUsername(shield,sdp)
if tonumber(sdp.id) == tonumber(SDP_ID) then
sendText(msg.chat_id, msg.id,  'اوه شت :( \nمن نمیتوانم پیام خودم را چک کنم', 'md')
return false
end
if sdp.id then
print(''..sdp.id..'')
if redis:sismember('GlobalyBanned:',sdp.id) then
text = '• _ کاربر : _ `'..sdp.id..'` از لیست حذف شد'
redis:srem('GlobalyBanned:',sdp.id)
else
text = '• `کاربر : ` *'..user..'* در لیست سیاه وجود ندارد'
end
else 
text = '• کاربر یافت نشد'
end
sendText(msg.chat_id, msg.id, text, 'md')
end
resolve_username(username,UnbanallByUsername)
end
if shield == 'unbanall' then
function UnGbanByReply(shield,sdp)
if tonumber(sdp.sender_user_id) == tonumber(SDP_ID) then
sendText(msg.chat_id, msg.id,  'اوه شت :( \nمن نمیتوانم پیام خودم را چک کنم', 'md')
return false
end
if redis:sismember('GlobalyBanned:',sdp.sender_user_id) then
sendText(msg.chat_id, msg.id,'• _ کاربر : _ `'..(sdp.sender_user_id)..'` از لیست سیاه حذف شد', 'md')
redis:srem('GlobalyBanned:',sdp.sender_user_id)
else
sendText(msg.chat_id, msg.id,  '• `کاربر : ` *'..(sdp.sender_user_id)..'* در لیست سیاه وجود ندارد', 'md')
end
end
if tonumber(msg.reply_to_message_id) == 0 then
else
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),UnGbanByReply)
end
end
if shield == 'clean members' then 
function CleanMembers(shield, sdp) 
for k, v in pairs(sdp.members) do 
if tonumber(v.user_id) == tonumber(SDP_ID)  then
end
KickUser(msg.chat_id,v.user_id)
end
end
print('shield')
getChannelMembers(msg.chat_id,"Recent",0, 2000000,CleanMembers)
sendText(msg.chat_id, msg.id,'• مقداری از کاربران گروه اخراج شده اند', 'md') 
end 
if shield == 'addkick'  then
local function Clean(shield,sdp)
for k,v in pairs(sdp.members) do
addChatMembers(msg.chat_id,{[0] = v.user_id})
end
end
sendText(msg.chat_id, msg.id, 'کاربران لیست سیاه به گروه اضافه شده اند', 'md')
getChannelMembers(msg.chat_id,"Banned", 0, 2000,Clean)
end
-------------------------------
end
if is_Owner(msg) then
if shield == 'lock pin' then
if redis:get('Lock:Pin:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• قفل سنجاق از قبل فعال بود' , 'md')
else
sendText(msg.chat_id, msg.id, '• قفل سنجاق فعال شد' , 'md')
redis:set('Lock:Pin:'..msg.chat_id,true)
end
end
if shield == 'unlock pin' then
if redis:get('Lock:pin:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• قفل سنجاق غیرفعال شد' , 'md')
redis:del('Lock:Pin:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '• قفل سنجاق از قبل غیرفعال بود' , 'md')
end
end
if shield == 'config' then
if not limit or limit > 200 then
limit = 200
end  
local function GetMod(extra,result,success)
local c = result.members
for i=0 , #c do
redis:sadd('ModList:'..msg.chat_id,c[i].user_id)
end
sendText(msg.chat_id,msg.id,"*تمام مدیران گروه به رسمیت شناخته شده اند*!", "md")
end
getChannelMembers(msg.chat_id,'Administrators',0,limit,GetMod)
end
if shield == 'modlist' then
local list = redis:smembers('ModList:'..msg.chat_id)
local t = '• ModList\n'
for k,v in pairs(list) do
t = t..k.." - *"..v.."*\n" 
end
t = t.."\n\n• شما میتوانید از دستور زیر برای دیدن کاربر استفاده کنید !\nwhois شناسه کاربر\nمثال ! \nwhois 363936960"
if #list == 0 then
t = 'لیست مدیران خالی است'
end
sendText(msg.chat_id, msg.id,t, 'md')
end
if shield and shield:match('^unmuteuser (%d+)$') then
local mutes =  shield:match('^unmuteuser (%d+)$')
if tonumber(mutes) == tonumber(SDP_ID) then
sendText(msg.chat_id, msg.id,  'اوه شت :( \nمن نمیتوانم پیام خودم را چک کنم', 'md')
return false
end
redis:srem('MuteList:'..msg.chat_id,mutes)
mute(msg.chat_id, mutes,'Restricted',   {1, 1, 1, 1, 1,1})
sendText(msg.chat_id, msg.id,"• *کاربر* `"..mutes.."` از حالت سکوت خارج شد",  'md' )
end
if shield == "clean deleted" then
function list(shield,sdp)
for k,v in pairs(sdp.members) do
local function Checkdeleted(shield,sdp)
if sdp.type._ == "userTypeDeleted" then
KickUser(msg.chat_id,sdp.id)
end
end
GetUser(v.user_id,Checkdeleted)
print(v.user_id)
end
sendText(msg.chat_id, msg.id,'تمام کاربران دیلیت اکانتی از گروه حذف شداند' ,'md')
end
tdbot_function ({_= "getChannelMembers",channel_id = getChatId(msg.chat_id).id,offset = 0,limit= 1000}, list, nil)
end
if shield == 'promote' then
function PromoteByReply(shield,sdp)
local user = sdp.sender_user_id
sendText(msg.chat_id, msg.id, '• کاربر '..(user)..' ترفیع یافت ','md')
redis:sadd('ModList:'..msg.chat_id,user)
end
if tonumber(msg.reply_to_message_id_) == 0 then
else
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id), PromoteByReply)  
end
end
if shield == 'demote' then
function DemoteByReply(shield,sdp)
redis:srem('ModList:'..msg.chat_id,sdp.sender_user_id)
sendText(msg.chat_id, msg.id, '• کاربر `'..(sdp.sender_user_id)..'` عزل مقام شد', 'md')
end
if tonumber(msg.reply_to_message_id) == 0 then
else
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),DemoteByReply)  
end
end
if shield and shield:match('^demote @(.*)') then
local username = shield:match('^demote @(.*)')
function DemoteByUsername(shield,sdp)
if sdp.id then
print(''..sdp.id..'')
redis:srem('ModList:'..msg.chat_id,sdp.id)
text = '• کاربر `'..sdp.id..'` عزل مقام شد'
else 
text = '• کاربر یافت نشد'
end
sendText(msg.chat_id, msg.id, text, 'md')
end
resolve_username(username,DemoteByUsername)
end
--------------------

if shield and shield:match('^promote @(.*)') then
local username = shield:match('^promote @(.*)')
function PromoteByUsername(shield,sdp)
if sdp.id then
print(''..sdp.id..'')
redis:sadd('ModList:'..msg.chat_id,sdp.id)
text = '• کاربر `'..sdp.id..'` ترفیع یافت '
else 
text = '• کاربر یافت نشد'
end
sendText(msg.chat_id, msg.id, text, 'md')
end
resolve_username(username,PromoteByUsername)
end
----------------------
if shield1 and shield1:match('^[Ss]etdescription (.*)') then
local description = shield1:match('^[Ss]etdescription (.*)')
changeDes(msg.chat_id,description)
local text = [[درباره گروه به  ]]..description..[[ تغییر یا]]
sendText(msg.chat_id, msg.id, text, 'md')
end
if shield1 and shield1:match('^[Ss]etname (.*)') then
local Title = shield1:match('^[Ss]etname (.*)')
local function GetName(shield, sdp)
local Hash = 'StatsGpByName'..msg.chat_id
local ChatTitle = sdp.title
redis:set(Hash,ChatTitle)
changeChatTitle(msg.chat_id,Title)
local text = [[درباره گروه به  ]]..description..[[ تغییر یافت ]]
sendText(msg.chat_id, msg.id, text, 'md')
end
GetChat(msg.chat_id,GetName)
end
if shield and shield:match('^promote (%d+)') then
local user = shield:match('promote (%d+)')
redis:sadd('ModList:'..msg.chat_id,user)
sendText(msg.chat_id, msg.id, '• کاربر `'..user..'` ترفیع یافت', 'md')
end
if shield == 'pin' and  tonumber(msg.reply_to_message_id) > 0 then 
sendText(msg.chat_id,msg.reply_to_message_id, '• این پیام سنجاق شد' ,'md')
Pin(msg.chat_id,msg.reply_to_message_id, 1)
end
if shield == 'unpin' then
sendText(msg.chat_id,msg.id, '• پیام حذف سنجاق شد' ,'md')
Unpin(msg.chat_id)
end
if shield and shield:match('^demote (%d+)') then
local user = shield:match('demote (%d+)')
redis:srem('ModList:'..msg.chat_id,user)
sendText(msg.chat_id, msg.id, '• کاربر `'..user..'`  عزل مقام شد', 'md')
end
if shield == 'automute all enable' then
redis:set('automuteall'..msg.chat_id,true)
sendText(msg.chat_id, msg.id,'•قفل خودکار فعال شد' ,'md')
end
if shield == 'automute all disable' then
redis:del('automuteall'..msg.chat_id)
sendText(msg.chat_id, msg.id,'• قفل خودکار  غیر فعال شد' ,'md')
end

   if shield == 'clean modlist'  then
redis:del('ModList:'..msg.chat_id)
sendText(msg.chat_id, msg.id,  '• لیست مدیران پاکسازی شد', 'md')
end
if shield1 and shield1:match('^([Ss]etmute all) (.*)$') then
local status = {string.match(shield, "^([Ss]etmute all) (.*)$")}
if status[2] == 'restricted' then
redis:set("Mute:All:Status:"..msg.chat_id,'Restricted') 
sendText(msg.chat_id, msg.id, ' قفل همه در حالت محدود سازی قرار گرفت', 'md')
end
if status[2] == 'deletemsg' then
redis:set("Mute:All:Status:"..msg.chat_id,'deletemsg') 
sendText(msg.chat_id, msg.id, 'قفل همه در حالت حذف پیام قرار گرفت', 'md')
end
end
----------------
if shield and shield1:match('^(automute all) (%d+):(%d+)-(%d+):(%d+)$') then
local shield = {
string.match(shield1, "^(automute all) (%d+):(%d+)-(%d+):(%d+)$")
}
if redis:get('automuteall'..msg.chat_id) then
auto= 'فعال'
else
auto= 'غیرفعال'
end
local endtime = shield[4]..shield[5]
local endtime1 = shield[4]..":"..shield[5]
local starttime2 = shield[2]..":"..shield[3]
redis:set('EndTimeSee'..msg.chat_id,endtime1)
redis:set('StartTimeSee'..msg.chat_id,starttime2)
local starttime = shield[2]..shield[3]
if endtime1 == starttime2 then
test = [[• شروع قفل خودکار نمیتواند با پایان آن یکی باشد]]
sendText(msg.chat_id, msg.id,test,"md")
else
redis:set('automutestart'..chat,starttime)
redis:set('automuteend'..chat,endtime)
test= 'گروه شما به صورت خودکار از ساعت  * '..starttime2..'* قفل و در ساعت  *'..endtime1 ..'* باز میشود \n قفل خودکار : `'..auto..'`'
sendText(msg.chat_id, msg.id,test,"md")
  end
end
  if shield == 'time' then
text ='Time:  '..os.date("%H : %M")
sendText(msg.chat_id, msg.id,text,"md")
end
----
end
----
if is_Mod(msg) then
if shield == 'mute all' then
if not redis:get("Mute:All:Status:"..msg.chat_id) then
sendText(msg.chat_id, msg.id,'ابتدا وضعیت قفل همه را تنظیم کنید' ,'md')
else
redis:set('MuteAll:'..msg.chat_id,true)
sendText(msg.chat_id, msg.id,'• قفل همه فعال شد' ,'md')
end
end
if shield == 'unmute all' then
redis:del('MuteAll:'..msg.chat_id)
if redis:get("Mute:All:Status:"..msg.chat_id) == 'Restricted' then
local mutes =  redis:smembers('Mutes:'..msg.chat_id)
for k,v in pairs(mutes) do
redis:srem('MuteList:'..msg.chat_id,v)
mute(msg.chat_id,v,'Restricted',   {1, 1, 1, 1, 1,1})
end
sendText(msg.chat_id, msg.id,'قفل همه غیرفعال شد و تمام کاربران محدود شده توسط ربات آزاد شداند' ,'md')
else
sendText(msg.chat_id, msg.id,'• قفل همه غیر فعال شد' ,'md')
end
end
-----------Delete All-------------
if shield == 'delall' then
function DelallByReply(shield,sdp)
if tonumber(sdp.sender_user_id) == tonumber(SDP_ID) then
sendText(msg.chat_id, msg.id, "اوه شت :( \nمن نمیتوانم پیام های خودم را پاک کنم", 'md')
return false
end
if private(msg.chat_id,sdp.sender_user_id) then
print '                     Private                          '
sendText(msg.chat_id, msg.id, "اوه شت :(\nمن نمیتوانم پیام های یک فرد دارای  مقام را پاک کنم ", 'md')
else
sendText(msg.chat_id, msg.id, '• تمام پیام های   `'..(sdp.sender_user_id)..'` پاکسازی شد', 'md')
deleteMessagesFromUser(msg.chat_id,sdp.sender_user_id) 
end
end
if tonumber(msg.reply_to_message_id) == 0 then
else
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),DelallByReply)  
end
end
if shield and shield:match('^delall @(.*)') then
local username = shield:match('^delall @(.*)')
function DelallByUsername(shield,sdp)
if tonumber(sdp.id) == tonumber(SDP_ID) then
  sendText(msg.chat_id, msg.id, "اوه شت :( \nمن نمیتوانم پیام های خودم را پاک کنم", "md")
return false
    end
  if private(msg.chat_id,sdp.id) then
print '                     Private                          '
sendText(msg.chat_id, msg.id, "اوه شت :(\nمن نمیتوانم پیام های یک فرد دارای  مقام را پاک کنم ", "md")
else
if sdp.id then
text= '• تمام پیام های   `'..sdp.id..'` پاکسازی شد'
deleteMessagesFromUser(msg.chat_id,sdp.id) 
else 
text = '• کاربر یافت نشد'
end
sendText(msg.chat_id, msg.id, text, 'md')
end
end
resolve_username(username,DelallByUsername)
end
if shield and shield:match('^delall (%d+)') then
local user_id = shield:match('^delall (%d+)')
if tonumber(user_id) == tonumber(SDP_ID) then
  sendText(msg.chat_id, msg.id, "اوه شت :( \nمن نمیتوانم پیام های خودم را پاک کنم", "md")
return false
    end
  if private(msg.chat_id,user_id) then
print '                      Private                          '
sendText(msg.chat_id, msg.id, "اوه شت :(\nمن نمیتوانم پیام های یک فرد دارای  مقام را پاک کنم ", "md")   
else
text= '• تمام پیام های  `'..user_id..'` پاکسازی شد'
deleteMessagesFromUser(msg.chat_id,user_id) 
sendText(msg.chat_id, msg.id, text, 'md')
end
end
---------------------------------
if shield == 'viplist' then
local list = redis:smembers('Vip:'..msg.chat_id)
local t = '• کاربران ویژه\n'
for k,v in pairs(list) do
t = t..k.." - *"..v.."*\n" 
end
t = t.."\n\n• شما میتوانید از دستور زیر برای دیدن کاربر استفاده کنید !\nwhois شناسه کاربر\nمثال ! \nwhois 363936960"
if #list == 0 then
t = 'لیست کاربران ویژه خالی است'
end
sendText(msg.chat_id, msg.id,t, 'md')
end
if shield == 'banlist' then
local list = redis:smembers('BanUser:'..msg.chat_id)
local t = '• کاربران محروم\n'
for k,v in pairs(list) do
t = t..k.." - *"..v.."*\n" 
end
t = t.."\n\n• شما میتوانید از دستور زیر برای دیدن کاربر استفاده کنید !\nwhois شناسه کاربر\nمثال ! \nwhois 363936960"
if #list == 0 then
t = 'لیست کاربران محدود خالی است'
end
sendText(msg.chat_id, msg.id,t, 'md')
end
  if shield == 'clean banlist'  then
local function Clean(shield,sdp)
for k,v in pairs(sdp.members) do
redis:del('BanUser:'..msg.chat_id)
RemoveFromBanList(msg.chat_id, v.user_id) 
end
end
sendText(msg.chat_id, msg.id,  '• تمام کابران محروم شده از لیست محرومین حذف شداند ', 'md')
getChannelMembers(msg.chat_id, "Banned", 0, 100000000000,Clean)
end
 if shield == 'clean mutelist'  then
local mute = redis:smembers('MuteList:'..msg.chat_id)
for k,v in pairs(mute) do
redis:del('MuteList:'..msg.chat_id)
mute(msg.chat_id, v,'Restricted',   {1, 0, 0, 0, 0,0})
end
sendText(msg.chat_id, msg.id,  '• تمام افراد محدود شده ازاد شداند ', 'md')
end
if shield == 'clean bots'  then
local function CleanBot(shield,sdp)
for k,v in pairs(sdp.members) do
if tonumber(v.user_id) == tonumber(SDP_ID) then
return false
end
 if private(msg.chat_id,v.user_id) then
print '                      Private                          '
else
end
KickUser(msg.chat_id, v.user_id) 
end
end
local d = 0
for i = 1, 12 do
getChannelMembers(msg.chat_id, "Bots", 0, 100000000000,CleanBot)
end
sendText(msg.chat_id, msg.id,  '• تمام ربات ها اخراج شداند', 'md')
end
if shield == 'setvip' then
function SetVipByReply(shield,sdp)
if redis:sismember('Vip:'..msg.chat_id, sdp.sender_user_id) then
sendText(msg.chat_id, msg.id,  '• `کاربر : ` *'..(sdp.sender_user_id)..'* از قبل در لیست افراد ویژه قرار داشت', 'md')
else
sendText(msg.chat_id, msg.id,'• _ کاربر : _ `'..(sdp.sender_user_id)..'` به لیست افراد ویژه اضافه شده', 'md')
redis:sadd('Vip:'..msg.chat_id, sdp.sender_user_id)
end
end
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),SetVipByReply)
end
if shield and shield:match('^setvip @(.*)') then
local username = shield:match('^setvip @(.*)')
function SetVipByUsername(shield,sdp)
if sdp.id then
print('SetVip\nBy : '..msg.sender_user_id..'\nUser : '..sdp.id..'\nUserName : '..username)
if redis:sismember('Vip:'..msg.chat_id,sdp.id) then
text=  '• کاربر :  `'..sdp.id..'` از قبل در لیست ویژه وجود دارد'
else
text ='• _ کاربر : _ `'..sdp.id..'` _به لیست ویژه اضافه شد_'
redis:sadd('Vip:'..msg.chat_id, sdp.id)
end
else 
text = '• کاربر یافت نشد'
end
sendText(msg.chat_id, msg.id, text, 'md')
end
resolve_username(username,SetVipByUsername)
end 
  if shield == 'clean viplist'  then
redis:del('Vip:'..msg.chat_id)
sendText(msg.chat_id, msg.id,  '• Vip List Has Been Cleaned', 'md')
end
if shield == 'remvip' then
function RemVipByReply(shield,sdp)
if redis:sismember('Vip:'..msg.chat_id, sdp.sender_user_id) then
sendText(msg.chat_id, msg.id,'• _User : _ `'..(sdp.sender_user_id)..'` *Demoted From VIP Member..*', 'md')
redis:srem('Vip:'..msg.chat_id, sdp.sender_user_id or 00000000)
else
sendText(msg.chat_id, msg.id,  '• `User : ` *'..(sdp.sender_user_id)..'* `Not VIP Member..!`', 'md')
end
end
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),RemVipByReply)
end
if shield == 'clean msgs' then
local function pro(arg,data)
for k,v in pairs(data.members) do
deleteMessagesFromUser(msg.chat_id, v.user_id) 
print(k)
end
end
print 'Clean By Del From User ' 
getChannelMembers(msg.chat_id,"Recent", 0, 100000000000,pro)
sendText(msg.chat_id, msg.id,'All Msgs Has Been Cleaned' ,'md')
end
if shield and shield:match('^remvip @(.*)') then
local username = shield:match('^remvip @(.*)')
function RemVipByUsername(shield,sdp)
if sdp.id then
print('RemVip\nBy : '..msg.sender_user_id..'\nUser : '..sdp.id..'\nUserName : '..username)
if redis:sismember('Vip:'..msg.chat_id,sdp.id) then
text = '• _User : _ `'..(sdp.id)..'` *Demoted From VIP Member..*'
redis:srem('Vip:'..msg.chat_id, sdp.id)
else
text = '• `User : ` *'..(sdp.id)..'* `Not VIP Member..!`'
end
else 
text = '• کاربر یافت نشد'
end
sendText(msg.chat_id, msg.id, text, 'md')
end
resolve_username(username,REmVipByUsername)
end 
if shield and shield:match('^muteuser (%d+)$') then
local mutess = shield:match('^muteuser (%d+)$') 
if tonumber(mutess) == tonumber(SDP_ID) then
sendText(msg.chat_id, msg.id,  'اوه شت :( \nمن نمیتوانم خودم را محدود کنم ', 'md')
return false
end
if private(msg.chat_id,mutess) then
sendText(msg.chat_id, msg.id, "اوه شت :(\nمن نمیتوانم یک فرد داری مقام را محدود کنم ", 'md')
else
mute(msg.chat_id, mutess,'Restricted',   {1, 0, 0, 0, 0,0})
redis:sadd('MuteList:'..msg.chat_id,mutess)
sendText(msg.chat_id, msg.id,"• کاربر `"..mutess.."` در حالت سکوت قرار گرفت",  'md' )
end
end
if shield1 and shield1:match('^([Ss]etflood) (.*)$') then
local status = {string.match(shield, "^([Ss]etflood) (.*)$")}
if status[2] == 'kickuser' then
redis:set("Flood:Status:"..msg.chat_id,'kickuser') 
sendText(msg.chat_id, msg.id, 'وضعیت ارسال پیام مکرر بر روی اخراج کاربر قرار گرفت', 'md')
end
if status[2] == 'muteuser' then
redis:set("Flood:Status:"..msg.chat_id,'muteuser') 
sendText(msg.chat_id, msg.id, 'وضعیت ارسال پیام مکرر بر روی سکوت کاربر قرار گرفت', 'md')
end
if status[2] == 'deletemsg' then
redis:set("Flood:Status:"..msg.chat_id,'deletemsg') 
sendText(msg.chat_id, msg.id, 'وضعیت ارسال پیام مکرر بر روی حذف کلی پیام کاربر قرار گرفت قرار گرفت', 'md')
end
end
if shield and shield:match('^([Ss]etforce) (.*)$') then
local status = {string.match(shield, "^([Ss]etforce) (.*)$")}
if status[2] == 'new user' then
redis:set("Force:Status:"..msg.chat_id,'new user') 
sendText(msg.chat_id, msg.id, 'وضعیت افزودن عضو اجباری برای کاربران جدید فعال شد ', 'md')
end
if status[2] == 'all user' then
redis:set("Force:Status:"..msg.chat_id,'all') 
sendText(msg.chat_id, msg.id,'وضعیت افزودن اجباری برای همه فعال شد', 'md')
end
end
if shield and shield:match('^muteuser (%d+)h$') then
local times = shield:match('^muteuser (%d+)h$') 
time = times * 3600
local function Restricted(shield,sdp)
if tonumber(sdp.sender_user_id) == tonumber(SDP_ID) then
sendText(msg.chat_id, msg.id,  'اوه شت :( \nمن نمیتوانم خودم را محدود کنم ', 'md')
return false
end
if private(msg.chat_id,sdp.sender_user_id) then
sendText(msg.chat_id, msg.id, "اوه شت :(\nمن نمیتوانم یک فرد داری مقام را محدود کنم ", 'md')
else
mute(msg.chat_id, sdp.sender_user_id,'Restricted',   {1,msg.date+time, 0, 0, 0,0})
redis:sadd('MuteList:'..msg.chat_id,sdp.sender_user_id)
SendMetion(msg.chat_id,sdp.sender_user_id, msg.id, "• کاربر "..(sdp.sender_user_id).." در حالت سکوت قرار گرفت برای "..times.." ساعت", 8,string.len(sdp.sender_user_id))
end
end
if tonumber(msg.reply_to_message_id) == 0 then
else
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),Restricted)  
end
end
if shield == 'muteuser' then
local function Restricted(shield,sdp)
if tonumber(sdp.sender_user_id) == tonumber(SDP_ID) then
sendText(msg.chat_id, msg.id,  'اوه شت :( \nمن نمیتوانم خودم را محدود کنم ', 'md')
return false
end
if private(msg.chat_id,sdp.sender_user_id) then
sendText(msg.chat_id, msg.id, "اوه شت :(\nمن نمیتوانم یک فرد داری مقام را محدود کنم ", 'md')
else
mute(msg.chat_id, sdp.sender_user_id,'Restricted',   {1,0, 0, 0, 0,0})
redis:sadd('MuteList:'..msg.chat_id,sdp.sender_user_id)
SendMetion(msg.chat_id,sdp.sender_user_id, msg.id, "• کاربر "..(sdp.sender_user_id).." در حالت سکوت قرار گرفت ", 8,string.len(sdp.sender_user_id))
end
end
if tonumber(msg.reply_to_message_id) == 0 then
else
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),Restricted)  
end
end
if shield == 'unmuteuser' then
function Restricted(shield,sdp)
if tonumber(sdp.sender_user_id) == tonumber(SDP_ID) then
sendText(msg.chat_id, msg.id,  'اوه شت :( \nمن نمیتوانم پیام خودم را چک کنم', 'md')
return false
end
redis:srem('MuteList:'..msg.chat_id,sdp.sender_user_id)
mute(msg.chat_id,sdp.sender_user_id,'Restricted',   {1, 1, 1, 1, 1,1})
SendMetion(msg.chat_id,sdp.sender_user_id, msg.id, "• کاربر "..(sdp.sender_user_id).." از حالت سکوت خارج شد", 8,string.len(sdp.sender_user_id))
end
if tonumber(msg.reply_to_message_id) == 0 then
else
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),Restricted)  
end
end
if shield and shield:match('^unmuteuser (%d+)$') then
local mutes =  shield:match('^unmuteuser (%d+)$')
if tonumber(mutes) == tonumber(SDP_ID) then
sendText(msg.chat_id, msg.id,  'اوه شت :( \nمن نمیتوانم پیام خودم را چک کنم', 'md')
return false
end
redis:srem('MuteList:'..msg.chat_id,mutes)
mute(msg.chat_id, mutes,'Restricted',   {1, 1, 1, 1, 1,1})
SendMetion(msg.chat_id,mutes, msg.id, "• کاربر "..mutes.." از حالت سکوت خارج شد", 8,string.len(mutes))
end
if shield == 'setlink'  and tonumber(msg.reply_to_message_id) > 0 then
function GeTLink(shield,sdp)
local getlink = sdp.content.text or sdp.content.caption
for link in getlink:gmatch("(https://t.me/joinchat/%S+)") or getlink:gmatch("t.me", "telegram.me") do
redis:set('Link:'..msg.chat_id,link)
print(link)
end
sendText(msg.chat_id, msg.id,"لینک گروه ذخیره شد",  'md' )
end
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),GeTLink)
end
if shield == 'remlink' then
redis:del('Link:'..msg.chat_id)
sendText(msg.chat_id, msg.id,"لینک گروه حذف شد",  'md' )
end
if shield == 'ban' and tonumber(msg.reply_to_message_id) > 0 then
function BanByReply(shield,sdp)
if tonumber(sdp.sender_user_id) == tonumber(SDP_ID) then
sendText(msg.chat_id, msg.id,"اوه شت :( \nمن نمیتوانم خودم را محدود کنم",  'md' )
return false
end
  if private(msg.chat_id,sdp.sender_user_id) then
print '                     Private                          '
  sendText(msg.chat_id, msg.id, "اوه شت :(\nمن نمیتوانم یک کاربر دارای مقام را مسدود کنم", 'md')
    else
SendMetion(msg.chat_id,sdp.sender_user_id, msg.id, "• کاربر "..(sdp.sender_user_id).." مسدود شد", 8,string.len(sdp.sender_user_id))
redis:sadd('BanUser:'..msg.chat_id,sdp.sender_user_id)
KickUser(msg.chat_id,sdp.sender_user_id)
end
end
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),BanByReply)
end
  if shield == 'clean filterlist'  then
redis:del('Filters:'..msg.chat_id)
sendText(msg.chat_id, msg.id,  '• لیست فیلتر پاکسازی شد', 'md')
end
if shield == 'filterlist' then
local list = redis:smembers('Filters:'..msg.chat_id)
local t = '• لیست کلمات فیلتر شده \n'
for k,v in pairs(list) do
t = t..k.." - *"..v.."*\n" 
end
if #list == 0 then
t = '• لیست کلمات فیلتر شده خالی است'
end
sendText(msg.chat_id, msg.id,t, 'md')
end
if shield == 'mutelist' then
local list = redis:smembers('MuteList:'..msg.chat_id)
local t = '• Mute List \n'
for k,v in pairs(list) do
t = t..k.." - *"..v.."*\n" 
end
t = t.."\n\n• شما میتوانید از دستور زیر برای دیدن کاربر استفاده کنید !\nwhois شناسه کاربر\nمثال ! \nwhois 363936960"
if #list == 0 then
t = 'لیست افراد ساکت شده خالی است'
end
sendText(msg.chat_id, msg.id,t, 'md')
end
if shield == 'clean warnlist' then
redis:del(msg.chat_id..':warn')
sendText(msg.chat_id, msg.id,'لیست اخطار ها پاکسازی شد', 'md')
end
if shield == "warnlist" then
local comn = redis:hkeys(msg.chat_id..':warn')
local t = 'لیست اخطار ها :\n'
for k,v in pairs (comn) do
local cont = redis:hget(msg.chat_id..':warn', v)
t = t..k..'- '..v..' تعداد اخطار  : '..(cont - 1)..'\n'
end
t = t.."\n\n• شما میتوانید از دستور زیر برای دیدن کاربر استفاده کنید !\nwhois شناسه کاربر\nمثال ! \nwhois 363936960"
if #comn == 0 then
t = 'The list is empty'
end 
sendText(msg.chat_id, msg.id,t, 'md')
end
if shield and shield:match('^unban (%d+)') then
local user_id = shield:match('^unban (%d+)')
if tonumber(user_id) == tonumber(SDP_ID) then
sendText(msg.chat_id, msg.id,  'اوه شت :( \nمن نمیتوانم پیام خودم را چک کنم', 'md')
return false
end
redis:srem('BanUser:'..msg.chat_id,user_id)
RemoveFromBanList(msg.chat_id,user_id)
SendMetion(msg.chat_id,user_id, msg.id, "• کاربر "..(user_id).." از لیست محرومین حذف شد", 8,string.len(user_id))
end
if shield and shield:match('^ban (%d+)') then
local user_id = shield:match('^ban (%d+)')
if tonumber(user_id) == tonumber(SDP_ID) then
sendText(msg.chat_id, msg.id,"اوه شت :( \nمن نمیتوانم خودم را مسدود کنم",  'md' )
return false
end
if private(msg.chat_id,user_id) then
print '                     Private                          '
sendText(msg.chat_id, msg.id, "اوه شت :(\nمن نمیتوانم یک کاربر دارای مقام را مسدود کنم", 'md')
else
redis:sadd('BanUser:'..msg.chat_id,user_id)
KickUser(msg.chat_id,user_id)
sendText(msg.chat_id, msg.id, '• کاربر `'..user_id..'` مسدود شد', 'md')
end
end
if shield and shield:match('^unban @(.*)') then
local username = shield:match('unban @(.*)')
function UnBanByUserName(shield,sdp)
if tonumber(sdp.id) == tonumber(SDP_ID) then
sendText(msg.chat_id, msg.id,  'اوه شت :( \nمن نمیتوانم پیام خودم را چک کنم', 'md')
return false
end
if sdp.id then
print('UserID : '..sdp.id..'\nUserName : @'..username)
redis:srem('BanUser:'..msg.chat_id,sdp.id)
SendMetion(msg.chat_id,sdp.id, msg.id, "• کاربر "..(sdp.id).." از لیست محرومین حرف شد", 8,string.len(sdp.id))
else 
sendText(msg.chat_id, msg.id, '• کاربر یافت نشد',  'md')

end
print('Send')
end
resolve_username(username,UnBanByUserName)
end
if shield == 'unban' and tonumber(msg.reply_to_message_id) > 0 then
function UnBan_by_reply(shield,sdp)
if tonumber(sdp.sender_user_id) == tonumber(SDP_ID) then
sendText(msg.chat_id, msg.id,  'اوه شت :( \nمن نمیتوانم پیام خودم را چک کنم', 'md')
return false
end
redis:srem('BanUser:'..msg.chat_id,sdp.sender_user_id)
SendMetion(msg.chat_id,sdp.sender_user_id, msg.id, "• کاربر "..(sdp.sender_user_id).." از لست محرومین حذف شد",8,string.len(sdp.sender_user_id))
RemoveFromBanList(msg.chat_id,sdp.sender_user_id)
 end
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),UnBan_by_reply)
end

if shield and shield:match('^ban @(.*)') then
local username = shield:match('^ban @(.*)')
print '                     Private                          '
function BanByUserName(shield,sdp)
if tonumber(sdp.id) == tonumber(SDP_ID) then
sendText(msg.chat_id, msg.id,"اوه شت :( \nمن نمیتوانم خودم را مسدود کنم",  'md' )
return false
end
if private(msg.chat_id,sdp.id) then
print '                     Private                          '
sendText(msg.chat_id, msg.id, "اوه شت :(\nمن نمیتوانم یک کاربر دارای مقام را مسدود کنم", 'md')
else
if sdp.id then
redis:sadd('BanUser:'..msg.chat_id,sdp.id)
KickUser(msg.chat_id,sdp.id)
SendMetion(msg.chat_id,sdp.id, msg.id, "• کاربر "..(sdp.id).." مسدود شد", 8,string.len(sdp.id))
else 
t = '• کاربر یافت نشد'
sendText(msg.chat_id, msg.id, t,  'md')
end
end
end
resolve_username(username,BanByUserName)
end
if shield== 'kick' and tonumber(msg.reply_to_message_id) > 0 then
function kick_by_reply(shield,sdp)
if tonumber(sdp.sender_user_id) == tonumber(SDP_ID) then
sendText(msg.chat_id, msg.id,"اوه شت :( \nمن نمیتوانم خودم را اخراج کنم",  'md' )
return false
end
if private(msg.chat_id,sdp.sender_user_id) then
print '                     Private                          '
sendText(msg.chat_id, msg.id, "اوه شت :(\nمن نمیتوانم یک فرد دارای مقام را اخراج کنم", 'md')
else
SendMetion(msg.chat_id,sdp.sender_user_id, msg.id, "• کاربر "..(sdp.sender_user_id).." اخراج شد",8,string.len(sdp.sender_user_id))
KickUser(msg.chat_id,sdp.sender_user_id)
RemoveFromBanList(msg.chat_id,sdp.sender_user_id)
 end
end
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),kick_by_reply)
end
if shield and shield:match('^kick @(.*)') then
local username = shield:match('^kick @(.*)')
function KickByUserName(shield,sdp)
if tonumber(sdp.id) == tonumber(SDP_ID) then
sendText(msg.chat_id, msg.id,"اوه شت :( \nمن نمیتوانم خودم را اخراج کنم",  'md' )
return false
end
if private(msg.chat_id,sdp.id) then
print '                     Private                          '
sendText(msg.chat_id, msg.id, "اوه شت :(\nمن نمیتوانم یک فرد دارای مقام را اخراج کنم", 'md')
else
if sdp.id then
KickUser(msg.chat_id,sdp.id)
RemoveFromBanList(msg.chat_id,sdp.id)
SendMetion(msg.chat_id,sdp.id, msg.id, "• کاربر "..(sdp.id).." اخراج شد", 8,string.len(sdp.id))
else 
txtt = '• کاربر یافت نشد'
sendText(msg.chat_id, msg.id,txtt,  'md')
end
end
end
resolve_username(username,KickByUserName)
end
if shield == 'clean restricts' then
local function pro(arg,data)
if redis:get("Check:Restricted:"..msg.chat_id) then
text = 'هر 5دقیقه یکبار ممکن است'
end
for k,v in pairs(data.members) do
redis:del('MuteAll:'..msg.chat_id)
 mute(msg.chat_id, v.user_id,'Restricted',    {1, 1, 1, 1, 1,1})
   redis:setex("Check:Restricted:"..msg.chat_id,350,true)
end
end
getChannelMembers(msg.chat_id,"Recent", 0, 100000000000,pro)
sendText(msg.chat_id, msg.id,'افراد محدود پاک شدند • ' ,'md')
end 
if shield and shield:match('^kick (%d+)') then
local user_id = shield:match('^kick (%d+)')
if tonumber(user_id) == tonumber(SDP_ID) then
sendText(msg.chat_id, msg.id,"اوه شت :( \nمن نمیتوانم خودم را اخراج کنم",  'md' )
return false
end
if private(msg.chat_id,user_id) then
print '                     Private                          '
sendText(msg.chat_id, msg.id, "اوه شت :(\nمن نمیتوانم یک فرد دارای مقام را اخراج کنم", 'md')
else
KickUser(msg.chat_id,user_id)
text= '• کاربر '..user_id..' اخراج شد'
SendMetion(msg.chat_id,user_id, msg.id, text,8, string.len(user_id))
RemoveFromBanList(msg.chat_id,user_id)
end
end
if shield and shield:match('^setflood (%d+)') then
local num = shield:match('^setflood (%d+)')
if tonumber(num) < 2 then
sendText(msg.chat_id, msg.id, '• عددی بزرگتر از *۲* بکار ببرید','md')
else
redis:set('Flood:Max:'..msg.chat_id,num)
sendText(msg.chat_id, msg.id, '• حداکثر پیام مکرر تنطیم شد به :  *'..num..'*', 'md')
end
end
 if shield and shield:match('^setforcemax (%d+)') then
local num = shield:match('^setforcemax (%d+)')
if tonumber(num) < 2 then
sendText(msg.chat_id, msg.id, '• عددی بزرگتر از *۲* بکار ببرید','md')
else
redis:set('force:Max:'..msg.chat_id,num)
sendText(msg.chat_id, msg.id, '• حداکثر  عضو تنطیم شد به :  *'..num..'*', 'md')
end
end
 if shield and shield:match('^settimedelete (%d+)') then
local num = shield:match('^settimedelete (%d+)')
if tonumber(num) < 10 then
sendText(msg.chat_id, msg.id, '• عددی بزرگتر از *10* بکار ببرید','md')
else
redis:set('force:Time:'..msg.chat_id,num)
sendText(msg.chat_id, msg.id, '• زمان پاکسازی خودکار تنظیم شد به :  *'..num..'*', 'md')
end
end
if shield and shield:match('^warnmax (%d+)') then
local num = shield:match('^warnmax (%d+)')
if tonumber(num) < 2 then
sendText(msg.chat_id, msg.id, '• عددی بزرگتر از *۲* بکار ببرید','md')
else
redis:set('Warn:Max:'..msg.chat_id,num)
sendText(msg.chat_id, msg.id, '• حداکثر اخطار تنظیم شد به *'..num..'*', 'md')
end
end

if shield and shield:match('^setspam (%d+)') then
local num = shield:match('^setspam (%d+)')
if tonumber(num) < 40 then
sendText(msg.chat_id, msg.id, '• عددی بزرگتر از *40* بکار ببرید','md')
else
if tonumber(num) > 4096 then
sendText(msg.chat_id, msg.id, '• عددی کوچکتر از *۴۰۹۶* را بکار ببرید','md')
else
redis:set('NUM_CH_MAX:'..msg.chat_id,num)
sendText(msg.chat_id, msg.id, '• حساسیت به پیام های طولانی تنظیم شد به : *'..num..'*', 'md')
end
end
end
if shield and shield:match('^setfloodtime (%d+)') then
local num = shield:match('^setfloodtime (%d+)')
if tonumber(num) < 1 then
sendText(msg.chat_id, msg.id, '• `Select a number greater than` *1*','md')
else
redis:set('Flood:Time:'..msg.chat_id,num)
sendText(msg.chat_id, msg.id, '• `Flood time change to` *'..num..'*', 'md')
end
end
if shield and shield:match('^rmsg (%d+)$') then
local limit = tonumber(shield:match('^rmsg (%d+)$'))
if limit > 90000 and limit < 0 then
sendText(msg.chat_id, msg.id, '*عددی بین * [`1-100`] را انتخاب کنید', 'md')
else
local function cb(arg,data)
for k,v in pairs(data.messages) do
deleteMessages(msg.chat_id,{[0] =v.id})
end
end
getChatHistory(msg.chat_id,msg.id, 0,  limit,cb)
sendText(msg.chat_id, msg.id, '• ('..limit..') Msg Has Been Deleted', 'md')
end
end
if shield == 'menu' then
function GetPanel(shield,sdp)
if sdp.results and sdp.results[0] then
sendInline(msg.chat_id,msg.id, 0, 1, sdp.inline_query_id,sdp.results[0].id)
else
sendText(msg.chat_id, msg.id, 'اوه شت :(\n مشکل فنی در ربات Api','md')
end
end
get(BotHelper, msg.chat_id, 0, 0, msg.chat_id,0, GetPanel)
end
if shield == 'menu pv' then
function GetPanel(shield,sdp)
if sdp.results and sdp.results[0] then
sendInline(msg.sender_user_id,msg.id, 0, 1, sdp.inline_query_id,sdp.results[0].id)
sendText(msg.chat_id, msg.id, 'منوی مدیریت به خصوصی شما ارسال شد ','md')
else
sendText(msg.chat_id, msg.id, 'اوه شت :(\n مشکل فنی در ربات Api','md')
end
end
get(BotHelper, msg.chat_id, 0, 0, msg.chat_id,0, GetPanel)
end
if shield == 'settings' then
local function Get(shield, sdps)
local function GetName(shield, sdp)
local chat = msg.chat_id
if redis:get('Welcome:'..msg.chat_id) == 'enable' then
welcome = 'Enable'
else
welcome = 'Disable'
end
if redis:get('Lock:Edit'..chat) then
edit = 'Enable'
else
edit = 'Disable'
end
if redis:get("Lock:Cmd"..msg.chat_id) then
cmd = 'Enable'
else
cmd = 'Disable'
end
if redis:get('Lock:Link'..chat) then
Link = 'Enable'
else
Link = 'Disable' 
end
if redis:get('Lock:Tag:'..chat) then
tag = 'Enable'
else
tag = 'Disable' 
end
if redis:get('Lock:HashTag:'..chat) then
hashtag = 'Enable'
else
hashtag = 'Disable' 
end
if redis:get('Lock:Video_note:'..chat) then
video_note = 'Enable'
else
video_note = 'Disable' 
end
if redis:get('Lock:Inline:'..chat) then
inline = 'Enable'
else
inline = 'Disable' 
end
if redis:get("Flood:Status:"..msg.chat_id) then
if redis:get("Flood:Status:"..msg.chat_id) == "kickuser" then
Status = 'Kick User'
elseif redis:get("Flood:Status:"..msg.chat_id) == "muteuser" then
Status = 'Mute User'
elseif redis:get("Flood:Status:"..msg.chat_id) == "deletemsg" then
Status = 'Del'
end
else
Status = 'Not Set'
end
if redis:get("Mute:All:Status:"..msg.chat_id) then
if redis:get("Mute:All:Status:"..msg.chat_id) == "Restricted" then
Statusm = 'Restricted'
elseif redis:get("Mute:All:Status:"..msg.chat_id) == "deletemsg" then
Statusm = 'Del Msgs'
end
else
Statusm = 'Not Set'
end
if redis:get("Force:Status:"..msg.chat_id) then
if redis:get("Force:Status:"..msg.chat_id) == "new user" then
forcemod = 'New Memer'
elseif redis:get("Force:Status:"..msg.chat_id) == "all" then
forcemod = 'All members'
end
else
forcemod = 'Not Set'
end
if redis:get('Lock:Pin:'..chat) then
pin = 'Enable'
else
pin = 'Disable' 
end
if redis:get('Lock:Forward:'..chat) then
fwd = 'Enable'
else
fwd = 'Disable' 
end
if redis:get('forceAdd:'..chat) then
force = 'Enable'
else
force = 'Disable' 
end
if redis:get('Lock:Bot:'..chat) then
bot = 'Enable'
else
bot = 'Disable' 
end
if redis:get('Spam:Lock:'..chat) then
spam = 'Enable'
else
spam = 'Disable' 
end
if redis:get('Lock:Arabic:'..chat) then
arabic = 'Enable'
else
arabic = 'Disable' 
end
if redis:get('Lock:English:'..chat) then
en = 'Enable'
else
en = 'Disable' 
end
if redis:get('Lock:Markdown:'..chat) then
mak = 'Enable'
else
mak = 'Disable' 
end
if redis:get('Lock:TGservise:'..chat) then
tg = 'Enable'
else
tg = 'Disable' 
end
if redis:get('Lock:Sticker:'..chat) then
sticker = 'Enable'
else
sticker = 'Disable' 
end
if redis:get('CheckBot:'..msg.chat_id) then
TD = 'Enable'
else
TD = 'Disable'
end
if redis:get('automuteall'..chat_id) then
auto= 'Enable'
else
auto= 'Disable'
end
-------------------------------------------
---------Mute Settings----------------------
if redis:get('Mute:Text:'..msg.chat_id) then
txts = 'Enable'
else
txts = 'Disable'
end
if redis:get('Mute:Caption:'..msg.chat_id) then
caption = 'Enable'
else
caption = 'Disable'
end
if redis:get('Mute:Reply:'..chat) then
rep = 'Enable'
else
rep = 'Disable' 
end
if redis:get('Mute:Contact:'..msg.chat_id) then
contact = 'Enable'
else
contact = 'Disable'
end
if redis:get('Mute:Document:'..msg.chat_id) then
document = 'Enable'
else
document = 'Disable'
end
if redis:get('Mute:Location:'..msg.chat_id) then
location = 'Enable'
else
location = 'Disable'
end
if redis:get('Mute:Voice:'..msg.chat_id) then
voice = 'Enable'
else
voice = 'Disable'
end
if redis:get('Mute:Photo:'..msg.chat_id) then
photo = 'Enable'
else
photo = 'Disable'
end
if redis:get('Mute:Game:'..msg.chat_id) then
game = 'Enable'
else
game = 'Disable'
end
if redis:get('MuteAll:'..chat) then
muteall = 'Enable'
else
muteall = 'Disable' 
end
if redis:get('Lock:Flood:'..msg.chat_id) then
flood = 'Enable'
else
flood = 'Disable'
end
if redis:get('Mute:Video:'..msg.chat_id) then
video = 'Enable'
else
video = 'Disable'
end
if redis:get('Mute:Music:'..msg.chat_id) then
music = 'Enable'
else
music = 'Disable'
end
if redis:get('Mute:Gif:'..msg.chat_id) then
gif = 'Enable'
else
gif = 'Disable'
end
local expire = redis:ttl("ExpireData:"..msg.chat_id)
if expire == -1 then
EXPIRE = "Unlimited"
else
local d = math.floor(expire / day ) + 1
EXPIRE = d.."  Day"
end
------------------------More Settings-------------------------
local stop = (redis:get('EndTimeSee'..msg.chat_id) or 'nil')
local start = (redis:get('StartTimeSee'..msg.chat_id) or 'nil')
local Text = '•• `shield team `\n\n*pershian king bot* : `'..TD..'`\n\n*Settings For* `'..sdp.title..'`\n\n*Links *:` '..Link..'`\n*Edit* : `'..edit..'`\n*Markdown :* `'..mak..'`\n*Tag :* `'..tag..'`\n*HashTag : *`'..hashtag..'`\n*Inline : *`'..inline..'`\n*Video Note :* `'..video_note..'`\n*Pin :* `'..pin..'`\n*Bots : *`'..bot..'`\n*Forward :* `'..fwd..'`\n*Arabic : *`'..arabic..'`\n*English :* `'..en..'`\n*Tgservise :* `'..tg..'`\n*Sticker : *`'..sticker..'`\n\n_Mute Settings_ \n\n*Photo :* `'..photo..'`\n*Music : *`'..music..'`\n*Reply :* `'..rep..'`\n*Caption :* `'..caption..'`\n*Voice : *`'..voice..'`\n*Docoment :*`'..document..'`\n*Video : *`'..video..'`\n*Game :*`'..game..'`\n*Location : *`'..location..'`\n*Gif :* `'..gif..'`\n*Contact : *`'..contact..'`\n*Text :*`'..txts..'`\n*All* : `'..muteall..'`\n*Mute All Status :* `'..Statusm..'`\n\n_More Locks_\n\n*Force Add :* `'..force..'`\n*Force Max * : `'..forcemax..'`\n*Force mod *: `'..forcemod..'`\n*Auto Delete :*`'..forcetime..'`|SC\n*AutoMute All * : `'..auto..'`\n_Stats Auto :_ \n*Start :* `'..start..'`\n*Stop : *`'..stop..'`\n*Command :* `'..cmd..'`\n*Spam : *`'..spam..'`\n*Flood :* `'..flood..'`\n*Flood Stats :* `'..Status..'`\n*Max Flood :* `'..NUM_MSG_MAX..'`\n*Spam Sensitivity : *`'..NUM_CH_MAX..'`\n*Flood Time :* `'..TIME_CHECK..'`\n*Warn Max :* `'..warn..'`\n\n*Expire :* `'..EXPIRE..'`\n*Welcome :* `'..welcome..'`\n\n*SuperGroup Info :*\n`SuperGroup ID :`*'..msg.chat_id..'*\n`Total Admins :` *'..sdps.administrator_count..'*\n`Total Banned :` *'..sdps.banned_count..'*\n`Total Members :` *'..sdps.member_count..'*\n`Group Name :` *'..sdp.title..'*'
sendText(msg.chat_id, msg.id, Text, 'md')
end
GetChat(msg.chat_id,GetName)
end
getChannelFull(msg.chat_id,Get)
end
---------------------Welcome----------------------
if shield == 'welcome enable' then
if redis:get('Welcome:'..msg.chat_id) == 'enable' then
sendText(msg.chat_id, msg.id,'• *Welcome* is _Already_ Enable\n\n' ,'md')
else
sendText(msg.chat_id, msg.id,'• *Welcome* Has Been Enable\n\n' ,'md')
redis:del('Welcome:'..msg.chat_id,'disable')
redis:set('Welcome:'..msg.chat_id,'enable')
end
end
----------------------------------
if shield == 'forcejoin enable' then
if redis:get('ForceJoin'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Lock` *force Join*  is _Already_ `Enable`' , 'md')
else
sendText(msg.chat_id, msg.id, '• `Lock` *force Join* `Has Been Enable`' , 'md')
redis:set('ForceJoin'..msg.chat_id,true)
end
end
if shield == 'forceadd enable' then
if redis:get('forceAdd:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Lock` *force Add*  is _Already_ `Enable`' , 'md')
else
sendText(msg.chat_id, msg.id, '• `Lock` *force Add* `Has Been Enable`' , 'md')
redis:set('forceAdd:'..msg.chat_id,true)
end
end
if shield == 'forceadd disable' then
if redis:get('forceAdd:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Lock` *force Add* `Has Been Disable`' , 'md')
redis:del('forceAdd:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '• `Lock` *force Add*  is _Already_  `Disable`' , 'md')
end
end
if shield == 'welcome disable' then
if redis:get('Welcome:'..msg.chat_id) then
sendText(msg.chat_id, msg.id,'• *Welcome* Has Been Disable\n\n' ,'md')
redis:set('Welcome:'..msg.chat_id,'disable')
redis:del('Welcome:'..msg.chat_id,'enable')
else
sendText(msg.chat_id, msg.id,'• *Welcome* is _Already_ Disable\n\n' ,'md')
end
end
---------------------------------------------------------
-----------------------------------------------Locks------------------------------------------------------------
-----------------Lock Link--------------------
if shield == 'lock link' then
if redis:get('Lock:Link'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Lock` *Link*  is _Already_ `Enable`\n\n' , 'md')
else
sendText(msg.chat_id, msg.id, '• `Lock` *Link* `Has Been Enable`\n\n' , 'md')
redis:set('Lock:Link'..msg.chat_id,true)
end
end
-------------------------------------------
if shield == 'lock command' then
if redis:get('Lock:Cmd'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Lock` *Command*  is _Already_ `Enable`\n\n' , 'md')
else
sendText(msg.chat_id, msg.id, '• `Lock` *Command* `Has Been Enable`\n\n' , 'md')
redis:set('Lock:Cmd'..msg.chat_id,true)
end
end
if shield == 'unlock command' then
if redis:get('Lock:Cmd'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Lock` *Command* `Has Been Disable`\n\n' , 'md')
redis:del('Lock:Cmd'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '• `Lock` *Command*  is _Already_  `Disable`\n\n' , 'md')
end
end
-------------------------------------------
if shield == 'unlock link' then
if redis:get('Lock:Link'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Lock` *Link* `Has Been Disable`\n\n' , 'md')
redis:del('Lock:Link'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '• `Lock` *Link*  is _Already_  `Disable`\n\n' , 'md')
end
end
---------------------------------------------
if shield == 'lock tag' then
if redis:get('Lock:Tag:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Lock` *Tag*  is _Already_ `Enable`\n\n' , 'md')
else
sendText(msg.chat_id, msg.id, '• `Lock` *Tag* `Has Been Enable`\n\n' , 'md')
redis:set('Lock:Tag:'..msg.chat_id,true)
end
end
if shield == 'unlock tag' then
if redis:get('Lock:Tag:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Lock` *Tag* `Has Been Disable`\n\n' , 'md')
redis:del('Lock:Tag:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '• `Lock` *Tag*  is _Already_  `Disable`\n\n' , 'md')
end
end
--------------------------------------------
if shield == 'lock hashtag' then
if redis:get('Lock:HashTag:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Lock` *HadshTag*  is _Already_ `Enable`\n\n' , 'md')
else 
sendText(msg.chat_id, msg.id, '• `Lock` *HashTag* `Has Been Enable`\n\n' , 'md')
redis:set('Lock:HashTag:'..msg.chat_id,true)
end
end
if shield == 'unlock hashtag' then
if redis:get('Lock:HashTag:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Lock` *HashTag* `Has Been Disable`\n\n' , 'md')
redis:del('Lock:HashTag:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '• `Lock` *HashTag*  is _Already_  `Disable`\n\n' , 'md')
end
end
-----------------------------------------------
if shield == 'lock video_note' then
if redis:get('Lock:Video_note:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Lock` *Video note*  is _Already_ `Enable`\n\n' , 'md')
else
sendText(msg.chat_id, msg.id, '• `Lock` *Video note* `Has Been Enable`\n\n' , 'md')
redis:set('Lock:Video_note:'..msg.chat_id,true)
end
end
if shield == 'unlock vide_onote' then
if redis:get('Lock:Video_note:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Lock` *Video note* `Has Been Disable`\n\n' , 'md')
redis:del('Lock:Video_note:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '• `Lock` *Video note*  is _Already_  `Disable`\n\n' , 'md')
end
end
-------------------------------------------------
if shield == 'lock markdown' then
if redis:get('Lock:Markdown:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Lock` *Markdown*  is _Already_ `Enable`\n\n' , 'md')
else
sendText(msg.chat_id, msg.id, '• `Lock` *Markdown* `Has Been Enable`\n\n' , 'md')
redis:set('Lock:Markdown:'..msg.chat_id,true)
end
end
if shield == 'unlock markdown' then
if redis:get('Lock:Markdown:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Lock` *Markdown* `Has Been Disable`\n\n' , 'md')
redis:del('Lock:Markdown:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '• `Lock` *Markdown*  is _Already_  `Disable`\n\n' , 'md')
end
end
if shield == 'unlock  video_note' then
if redis:get('Lock:Video_note:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Lock` *Video note* `Has Been Disable`\n\n' , 'md')
redis:del('Lock:Video_note:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '• `Lock` *Video note*  is _Already_  `Disable`\n\n' , 'md')
end
end
-------------------------------------------------
if shield == 'lock spam' then
if redis:get('Spam:Lock:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Lock` *Spam*  is _Already_ `Enable`\n\n' , 'md')
else
sendText(msg.chat_id, msg.id, '• `Lock` *Spam* `Has Been Enable`\n\n' , 'md')
redis:set('Spam:Lock:'..msg.chat_id,true)
end
end
if shield == 'unlock spam' then
if redis:get('Spam:Lock:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Lock` *Spam* `Has Been Disable`\n\n' , 'md')
redis:del('Spam:Lock:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '• `Lock` *Spam*  is _Already_  `Disable`\n\n' , 'md')
end
end
-------------------------------------
if shield == 'lock inline' then
if redis:get('Lock:Inline:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Lock` *Inline*  is _Already_ `Enable`\n\n' , 'md')
else
sendText(msg.chat_id, msg.id, '• `Lock` *Inline* `Has Been Enable`\n\n' , 'md')
redis:set('Lock:Inline:'..msg.chat_id,true)
end
end
if shield == 'unlock inline' then
if redis:get('Lock:Inline:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Lock` *Inline* `Has Been Disable`\n\n' , 'md')
redis:del('Lock:Inline:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '• `Lock` *Inline*  is _Already_  `Disable`\n\n' , 'md')
end
end
-----------------------------------------------
if shield == 'lock pin' then
if redis:get('Lock:Pin:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Lock` *Pin*  is _Already_ `Enable`\n\n' , 'md')
else
sendText(msg.chat_id, msg.id, '• `Lock` *Pin* `Has Been Enable`\n\n' , 'md')
redis:set('Lock:Pin:'..msg.chat_id,true)
end
end
if shield == 'unlock pin' then
if redis:get('Lock:pin:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Lock` *Pin* `Has Been Disable`\n\n' , 'md')
redis:del('Lock:Pin:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '• `Lock` *Pin*  is _Already_  `Disable`\n\n' , 'md')
end
end
-----------------------------------------------
if shield == 'lock flood' then
if redis:get('Lock:Flood:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Lock` *Flood*  is _Already_ `Enable`\n\n' , 'md')
else
sendText(msg.chat_id, msg.id, '• `Lock` *Flood* `Has Been Enable`\n\n' , 'md')
redis:set('Lock:Flood:'..msg.chat_id,true)
end
end
if shield == 'unlock flood' then
if redis:get('Lock:Flood:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Lock` *Flood* `Has Been Disable`\n\n' , 'md')
redis:del('Lock:Flood:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '• `Lock` *Flood*  is _Already_  `Disable`\n\n' , 'md')
end
end
----------------------------------------------
if shield == 'lock forward' then
if redis:get('Lock:Forward:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Lock` *Forward*  is _Already_ `Enable`\n\n' , 'md')
else
sendText(msg.chat_id, msg.id, '• `Lock` *Forward* `Has Been Enable`\n\n' , 'md')
redis:set('Lock:Forward:'..msg.chat_id,true)
end
end
if shield == 'unlock forward' then
if redis:get('Lock:Forward:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Lock` *Forward* `Has Been Disable`\n\n' , 'md')
redis:del('Lock:Forward:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '• `Lock` *Forward*  is _Already_  `Disable`\n\n' , 'md')
end
end
------------------------------------------------
if shield == 'lock arabic' then
if redis:get('Lock:Arabic:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Lock` *Arabic*  is _Already_ `Enable`\n\n' , 'md')
else
sendText(msg.chat_id, msg.id, '• `Lock` *Arabic* `Has Been Enable`\n\n' , 'md')
redis:set('Lock:Arabic:'..msg.chat_id,true)
end
end
if shield == 'lock bot' then
if redis:get('Lock:Bot:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Lock` *Bot*  is _Already_ `Enable`\n\n' , 'md')
else
sendText(msg.chat_id, msg.id, '• `Lock` *Bot* `Has Been Enable`\n\n' , 'md')
redis:set('Lock:Bot:'..msg.chat_id,true)
end
end
if shield == 'unlock arabic' then
if redis:get('Lock:Arabic:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Lock` *Arabic* `Has Been Disable`\n\n' , 'md')
redis:del('Lock:Arabic:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '• `Lock` *Arabic*  is _Already_  `Disable`\n\n' , 'md')
end
end
if shield == 'unlock bot'then
if redis:get('Lock:Bot:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Lock` *Bot* `Has Been Disable`\n\n' , 'md')
redis:del('Lock:Bot:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '• `Lock` *Bot*  is _Already_  `Disable`\n\n' , 'md')
end
end
--------------------------------------------
if shield == 'lock edit' then
if redis:get('Lock:Edit'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Lock` *Edit*  is _Already_ `Enable`\n\n' , 'md')
else
sendText(msg.chat_id, msg.id, '• `Lock` *Edit* `Has Been Enable`\n\n' , 'md')
redis:set('Lock:Edit'..msg.chat_id,true)
end
end
if shield == 'unlock edit' then
if redis:get('Lock:Edit'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Lock` *Edit* `Has Been Disable`\n\n' , 'md')
redis:del('Lock:Edit'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '• `Lock` *Edit*  is _Already_  `Disable`\n\n' , 'md')
end
end
-----------------------------------------------
if shield == 'lock english' then
if redis:get('Lock:English:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Lock` *English*  is _Already_ `Enable`\n\n' , 'md')
else
sendText(msg.chat_id, msg.id, '• `Lock` *English* `Has Been Enable`\n\n' , 'md')
redis:set('Lock:English:'..msg.chat_id,true)
end
end
if shield == 'unlock english' then
if redis:get('Lock:English:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Lock` *English* `Has Been Disable`\n\n' , 'md')
redis:del('Lock:English:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '• `Lock` *English*  is _Already_  `Disable`\n\n' , 'md')
end
end
--------------------------------------------
if shield == 'lock tgservice' then
if redis:get('Lock:TGservise:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Lock` *TGservise*  is _Already_ `Enable`\n\n' , 'md')
else
sendText(msg.chat_id, msg.id, '• `Lock` *TGservise* `Has Been Enable`\n\n' , 'md')
redis:set('Lock:TGservise:'..msg.chat_id,true)
end
end
if shield == 'unlock tgservice' then
if redis:get('Lock:TGservise:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Lock` *TGservice* `Has Been Disable`\n\n' , 'md')
redis:del('Lock:TGservise:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '• `Lock` *TGservice*  is _Already_  `Disable`\n\n' , 'md')
end
end
-------------------------------------------
if shield == 'lock sticker' then
if redis:get('Lock:Sticker:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Lock` *Sticker*  is _Already_ `Enable`\n\n' , 'md')
else
sendText(msg.chat_id, msg.id, '• `Lock` *Sticker* `Has Been Enable`\n\n' , 'md')
redis:set('Lock:Sticker:'..msg.chat_id,true)
end
end
if shield == 'unlock sticker' then
if redis:get('Lock:Sticker:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Lock` *Sticker* `Has Been Disable`\n\n' , 'md')
redis:del('Lock:Sticker:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '• `Lock` *Sticker*  is _Already_  `Disable`\n\n' , 'md')
end
end
--------------------------------------------
-------------------------Mutes-----------------------------------------
if shield == 'mute text' then
if redis:get('Mute:Text:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Lock` *Text*  is _Already_ `Enable`\n\n' , 'md')
else
sendText(msg.chat_id, msg.id, '• `Lock` *Text* `Has Been Enable`\n\n' , 'md')
redis:set('Mute:Text:'..msg.chat_id,true)
end
end
-----------------------------------------
if shield == 'mute caption' then
if redis:get('Mute:Caption:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Lock` *Caption*  is _Already_ `Enable`\n\n' , 'md')
else
sendText(msg.chat_id, msg.id, '• `Lock` *Caption* `Has Been Enable`\n\n' , 'md')
redis:set('Mute:Caption:'..msg.chat_id,true)
end
end
if shield == 'unmute caption' then
if redis:get('Mute:Caption:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Mute` *Caption* `Has Been Disable`\n\n' , 'md')
redis:del('Mute:Caption:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '• `Mute` *Caption*  is _Already_  `Disable`\n\n' , 'md')
end
end
---------------------------------------------------
if shield == 'mute reply' then
if redis:get('Mute:Reply:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Lock` *Reply*  is _Already_ `Enable`\n\n' , 'md')
else
sendText(msg.chat_id, msg.id, '• `Lock` *Reply* `Has Been Enable`\n\n' , 'md')
redis:set('Mute:Reply:'..msg.chat_id,true)
end
end
if shield == 'unmute reply' then
if redis:get('Mute:Reply:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Mute` *Reply* `Has Been Disable`\n\n' , 'md')
redis:del('Mute:Reply:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '• `Mute` *Reply*  is _Already_  `Disable`\n\n' , 'md')
end
end
-------------------------------------------------
if shield == 'unmute text' then
if redis:get('Mute:Text:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Mute` *Text* `Has Been Disable`\n\n' , 'md')
redis:del('Mute:Text:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '• `Mute` *Text*  is _Already_  `Disable`\n\n' , 'md')
end
end
---------------------------------------------------------------------------------
if shield == 'mute contact' then
if redis:get('Mute:Contact:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Mute` *Contact*  is _Already_ `Enable`\n\n' , 'md')
else
sendText(msg.chat_id, msg.id, '• `Mute` *Contact* `Has Been Enable`\n\n' , 'md')
redis:set('Mute:Contact:'..msg.chat_id,true)
end
end
if shield == 'unmute contact' then
if redis:get('Mute:Contact:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Mute` *Contact* `Has Been Disable`\n\n' , 'md')
redis:del('Mute:Contact:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '• `Mute` *Contact*  is _Already_  `Disable`\n\n' , 'md')
end
end
---------------------------------------------------------------------------------
if shield == 'mute document' then
if redis:get('Mute:Document:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Mute` *Document*  is _Already_ `Enable`\n\n' , 'md')
else
sendText(msg.chat_id, msg.id, '• `Mute` *Document* `Has Been Enable`\n\n' , 'md')
redis:set('Mute:Document:'..msg.chat_id,true)
end
end
if shield == 'unmute document' then
if redis:get('Mute:Document:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Mute` *Document* `Has Been Disable`\n\n' , 'md')
redis:del('Mute:Document:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '• `Mute` *Document*  is _Already_  `Disable`\n\n' , 'md')
end
end
---------------------------------------------------------------------------------
if shield == 'mute location' then
if redis:get('Mute:Location:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Mute` *Location*  is _Already_ `Enable`\n\n' , 'md')
else
sendText(msg.chat_id, msg.id, '• `Mute` *Location* `Has Been Enable`\n\n' , 'md')
redis:set('Mute:Location:'..msg.chat_id,true)
end
end
if shield == 'unmute location' then
if redis:get('Mute:Location:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Mute` *Location* `Has Been Disable`\n\n' , 'md')
redis:del('Mute:Location:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '• `Mute` *Location*  _is Already_  `Disable`\n\n' , 'md')
end
end
---------------------------------------------------------------------------------
if shield == 'mute voice' then
if redis:get('Mute:Voice:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Mute` *Voice*  is _Already_ `Enable`\n\n' , 'md')
else
sendText(msg.chat_id, msg.id, '• `Mute` *Voice* `Has Been Enable`\n\n' , 'md')
redis:set('Mute:Voice:'..msg.chat_id,true)
end
end
if shield == 'unmute voice' then
if redis:get('Mute:Voice:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Mute` *Voice* `Has Been Disable`\n\n' , 'md')
redis:del('Mute:Voice:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '• `Mute` *Voice*  _is Already_  `Disable`\n\n' , 'md')
end
end
---------------------------------------------------------------------------------
if shield == 'mute photo' then
if redis:get('Mute:Photo:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Mute` *Photo*  is _Already_ `Enable`\n\n' , 'md')
else
sendText(msg.chat_id, msg.id, '• `Mute` *Photo* `Has Been Enable`\n\n' , 'md')
redis:set('Mute:Photo:'..msg.chat_id,true)
end
end
if shield == 'unmute photo' then
if redis:get('Mute:Photo:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Mute` *Photo* `Has Been Disable`\n\n' , 'md')
redis:del('Mute:Photo:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '• `Mute` *Photo*  _is Already_  `Disable`\n\n' , 'md')
end
end
---------------------------------------------------------------------------------
if shield == 'mute game' then
if redis:get('Mute:Game:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Mute` *Game*  is _Already_ `Enable`\n\n' , 'md')
else
sendText(msg.chat_id, msg.id, '• `Mute` *Game* `Has Been Enable`\n\n' , 'md')
redis:set('Mute:Game:'..msg.chat_id,true)
end
end
if shield == 'unmute game' then
if redis:get('Mute:Game:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Mute` *Game* `Has Been Disable`\n\n' , 'md')
redis:del('Mute:Game:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '• `Mute` *Game*  _is Already_  `Disable`\n\n' , 'md')
end
end
---------------------------------------------------------------------------------
if shield == 'mute video' then
if redis:get('Mute:Video:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Mute` *Video*  is _Already_ `Enable`\n\n' , 'md')
else
sendText(msg.chat_id, msg.id, '• `Mute` *Video* `Has Been Enable`\n\n' , 'md')
redis:set('Mute:Video:'..msg.chat_id,true)
end
end
if shield == 'unmute video' then
if redis:get('Mute:Video:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Mute` *Video* `Has Been Disable`\n\n' , 'md')
redis:del('Mute:Video:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '• `Mute` *Video*  _is Already_  `Disable`\n\n' , 'md')
end
end
---------------------------------------------------------------------------------
if shield == 'mute music' then
if redis:get('Mute:Music:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Mute` *Music*  is _Already_ `Enable`\n\n' , 'md')
else
sendText(msg.chat_id, msg.id, '• `Mute` *Music* `Has Been Enable`\n\n' , 'md')
redis:set('Mute:Music:'..msg.chat_id,true)
end
end
if shield == 'unmute music' then
if redis:get('Mute:Music:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Mute` *Music* `Has Been Disable`\n\n' , 'md')
redis:del('Mute:Music:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '• `Mute` *Music*  _is Already_  `Disable`\n\n' , 'md')
end
end
---------------------------------------------------------------------------------
if shield == 'mute gif' then
if redis:get('Mute:Gif:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Mute` *Gif*  is _Already_ `Enable`\n\n' , 'md')
else
sendText(msg.chat_id, msg.id, '• `Mute` *Gif* `Has Been Enable`\n\n' , 'md')
redis:set('Mute:Gif:'..msg.chat_id,true)
end
end
if shield == 'unmute gif' then
if redis:get('Mute:Gif:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Mute` *Gif* `Has Been Disable`\n\n' , 'md')
redis:del('Mute:Gif:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '• `Mute` *Gif*  _is Already_  `Disable`\n\n' , 'md')
end
end
-----------End Mutes---------------
----------------------------------------------------------------------------------
if shield1 and shield1:match('^[Ss]etlink (.*)') then
local link = shield1:match('^[Ss]etlink (.*)')
redis:set('Link:'..msg.chat_id,link)
sendText(msg.chat_id, msg.id,'• *New Link Has Been Seted*\n\n', 'md')
end
if shield1 and shield1:match('^[Ss]etwelcome (.*)') then
local wel = shield1:match('^[Ss]etwelcome (.*)')
redis:set('Text:Welcome:'..msg.chat_id,wel)
sendText(msg.chat_id, msg.id,'• *New Welcome Has Been Seted*\n\n', 'md')
end
if shield1 and shield1:match('^[Ss]etrules (.*)') then
local rules = shield1:match('^[Ss]etrules (.*)')
redis:set('Rules:'..msg.chat_id,rules)
sendText(msg.chat_id, msg.id,'• *New rules Has Been Seted*\n\n', 'md')
end

-----------------------------------------------------------------------------------------------------------------------------------------------------
if shield and shield:match('^filter +(.*)') then
local word = shield:match('^filter +(.*)')
redis:sadd('Filters:'..msg.chat_id,word)
sendText(msg.chat_id, msg.id, '• کلمه `'..word..'` به لیست فیلتر اضافه شد', 'md')
end

if shield and shield:match('^remfilter +(.*)') then
local word = shield:match('^remfilter +(.*)')
redis:srem('Filters:'..msg.chat_id,word)
sendText(msg.chat_id, msg.id,'• کلمه `'..word..'` از لیست فیلتر حذف شد', 'md')
end
if shield == "warn" and tonumber(msg.reply_to_message_id) > 0 then
function WarnByReply(shield,sdp)
if tonumber(sdp.sender_user_id or 00000000) == tonumber(SDP_ID) then
sendText(msg.chat_id, msg.id,  'اوه شت :( \nمن نمیتوانم پیام خودم را چک کنم', 'md')
return false
end
if private(msg.chat_id,sdp.sender_user_id or 00000000) then
print '                     Private                          '
sendText(msg.chat_id, msg.id, "اوه شت :(\nمن نمیتوانم به یک فرد دارای مقام اخطار بدهم", 'md')
else
 local hashwarn = msg.chat_id..':warn'
local warnhash = redis:hget(msg.chat_id..':warn',(sdp.sender_user_id or 00000000)) or 1
if tonumber(warnhash) == tonumber(warn) then
KickUser(msg.chat_id,sdp.sender_user_id)
RemoveFromBanList(msg.chat_id,sdp.sender_user_id)
text= "کاربر  "..(sdp.sender_user_id or 00000000).." به علت دریافت بیش از حد پیام از گروه اخراج شد \n اخطار ها : "..warnhash.."/"..warn..""
redis:hdel(hashwarn,sdp.sender_user_id, '0')
SendMetion(msg.chat_id,sdp.sender_user_id, msg.id, text, 7, string.len(sdp.sender_user_id))
else
local warnhash = redis:hget(msg.chat_id..':warn',(sdp.sender_user_id or 00000000)) or 1
 redis:hset(hashwarn,sdp.sender_user_id, tonumber(warnhash) + 1)
text= "کاربر" .. (sdp.sender_user_id or '0000Null0000') .. "شما یک اخطار دریافت کردید \nتعداد اخطار های شما:" ..warnhash .. "/" .. warn .. ""
SendMetion(msg.chat_id,sdp.sender_user_id, msg.id, text, 5, string.len(sdp.sender_user_id))
end
end
 end
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),WarnByReply)
end
if shield and shield:match('^warn (%d+)') then
local user_id = shield:match('^warn (%d+)')
if tonumber(user_id) == tonumber(SDP_ID) then
sendText(msg.chat_id, msg.id,  'اوه شت :( \nمن نمیتوانم پیام خودم را چک کنم', 'md')
return false
end
if private(msg.chat_id,user_id) then
print '                     Private                          '
sendText(msg.chat_id, msg.id, "اوه شت :(\nمن نمیتوانم به یک فرد دارای مقام اخطار بدهم", 'md')
else
 local hashwarn = msg.chat_id..':warn'
local warnhash = redis:hget(msg.chat_id..':warn',user_id) or 1
if tonumber(warnhash) == tonumber(warn) then
KickUser(msg.chat_id,user_id)
RemoveFromBanList(msg.chat_id,user_id)
text= "کاربر  "..user_id.." به علت دریافت بیش از حد پیام از گروه اخراج شد \n اخطار ها : "..warnhash.."/"..warn..""
redis:hdel(hashwarn,user_id, '0')
SendMetion(msg.chat_id,user_id, msg.id, text, 7, string.len(user_id))
else
local warnhash = redis:hget(msg.chat_id..':warn',user_id) or 1
 redis:hset(hashwarn,user_id, tonumber(warnhash) + 1)
text= "کاربر" ..user_id.. "شما یک اخطار دریافت کردید \nتعداد اخطار های شما:" ..warnhash .. "/" .. warn .. ""
SendMetion(msg.chat_id,user_id, msg.id, text, 5, string.len(user_id))
end
end
end
if shield == "unwarn" and tonumber(msg.reply_to_message_id) > 0 then
function UnWarnByReply(shield,sdp)
if tonumber(sdp.sender_user_id) == tonumber(SDP_ID) then
sendText(msg.chat_id, msg.id,  'او شت :( :(\nمن نمیتوانم پیام های خودم را چک کنم', 'md')
return false
end
if private(msg.chat_id,sdp.sender_user_id) then
else
local warnhash = redis:hget(msg.chat_id..':warn',(sdp.sender_user_id)) or 1
if tonumber(warnhash) == tonumber(1) then
text= "کاربر  * ".. sdp.sender_user_id .."* هیچ اخطاری ندارد"
sendText(msg.chat_id, msg.id, text, 'md')
else
local warnhash = redis:hget(msg.chat_id..':warn',(sdp.sender_user_id))
local hashwarn = msg.chat_id..':warn'
redis:hdel(hashwarn,(sdp.sender_user_id),'0')
text= 'کاربر  '..(sdp.sender_user_id)..' تمام اخطار هایش پاک شد'

sendText(msg.chat_id, msg.id, text, 'md')
end
end
end
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),UnWarnByReply)
end
if shield and shield:match('^unwarn (%d+)') then
local user_id = shield:match('^unwarn (%d+)')
if tonumber(user_id) == tonumber(SDP_ID) then
sendText(msg.chat_id, msg.id,  'او شت :( :(\nمن نمیتوانم پیام های خودم را چک کنم', 'md')
return false
end
if private(msg.chat_id,user_id) then
else
local warnhash = redis:hget(msg.chat_id..':warn',user_id) or 1
if tonumber(warnhash) == tonumber(1) then
text= "کاربر  * "..user_id.."* هیچ اخطاری ندارد"
sendText(msg.chat_id, msg.id, text, 'md')
else
local warnhash = redis:hget(msg.chat_id..':warn',user_id)
local hashwarn = msg.chat_id..':warn'
redis:hdel(hashwarn,user_id,'0')
text= 'کاربر  '..user_id..' تمام اخطار هایش پاک شد'
sendText(msg.chat_id, msg.id, text, 'md')
end
end
end
------
end
------

if redis:get("Lock:Cmd"..msg.chat_id) and not is_Mod(msg) then
return false
end
if redis:get('CheckBot:'..msg.chat_id) then
if shield and shield:match('^getpro (%d+)') and forcejoin(msg) then
local offset = tonumber(shield:match('^getpro (%d+)') or  shield:match('^پروفایل (%d+)'))
if offset > 50 then
sendText(msg.chat_id, msg.id,'• اوه شت :( :(\nمن نمیتوانم بیشتر از ۵۰ عکس پروفایل شما را ارسال کنم','md')
elseif offset < 1 then
sendText(msg.chat_id, msg.id, '• لطفا عددی بزرگ تر از 0 بکار ببرید ', 'md')
else
function GetPro1(shield, sdp)
 if sdp.photos[0] then
sendPhoto(msg.chat_id, msg.id, 0, 1, nil, sdp.photos[0].sizes[2].photo.persistent_id,'• Total Profile Photos : '..sdp.total_count..'\n• Photo Size : '..sdp.photos[0].sizes[2].photo.size)
else
sendText(msg.chat_id, msg.id, 'شما عکس پروفایل '..offset ..' ندارید', 'md')
end
end
tdbot_function ({_ ="getUserProfilePhotos", user_id = msg.sender_user_id, offset = offset-1, limit = 100000000000000000000000 },GetPro1, nil)
end
end
if shield == 'id' and forcejoin(msg) and tonumber(msg.reply_to_message_id) > 0 then
function GetID(shield, sdp)
 local user = sdp.sender_user_id
local text = 'shield team\n'..sdp.sender_user_id
SendMetion(msg.chat_id,sdp.sender_user_id, msg.id, text, 16, string.len(sdp.sender_user_id))
end
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),GetID)
end
if shield == "id" and forcejoin(msg) and tonumber(msg.reply_to_message_id) == 0  then 
 function GetPro(shield, sdp)
Msgs = redis:get('Total:messages:'..msg.chat_id..':'..(msg.sender_user_id))
if is_sudo(msg) then
rank =  ''..(redis:get('rank'..msg.sender_user_id) or "Sudo")..'' 
elseif is_Owner(msg) then
rank =  ''..(redis:get('rank'..msg.sender_user_id) or "Owner")..'' 
elseif is_Mod(msg) then
rank =  ''..(redis:get('rank'..msg.sender_user_id) or "ADMIN")..''
elseif is_Vip(msg) then
rank =  ''..(redis:get('rank'..msg.sender_user_id) or "VIP")..''
elseif not is_Mod(msg) then
rank = ''..(redis:get('rank'..msg.sender_user_id) or "Member")..''
end
 if sdp.photos[0] then
print('persistent_id : '..sdp.photos[0].sizes[2].photo.persistent_id)  
sendPhoto(msg.chat_id, msg.id, 0, 1, nil, sdp.photos[0].sizes[2].photo.persistent_id,'• شناسه گروه : ['..msg.chat_id..']\n• شناسه شما : ['..msg.sender_user_id..']\n• مقام شما : ['..rank..']\n• تعداد پیام های شما : '..Msgs..'\n• شناسه ربات : '..SDP_ID..'')
else
sendText(msg.chat_id, msg.id,  '• شناسه گروه : ['..msg.chat_id..']\n• شناسه شما : ['..msg.sender_user_id..']\n• مقام شما : ['..rank..']\n• تعداد پیام های شما : '..Msgs..'\n• شناسه ربات : '..SDP_ID..'', 'md')
end
end
tdbot_function ({_ ="getUserProfilePhotos", user_id = (msg.sender_user_id), offset =0, limit = 100000000 },GetPro, nil)
end
if shield == 'me' or shield == 'من' and forcejoin(msg) then
local function GetName(shield, sdp)
function Get(extra, result, success) 
if is_sudo(msg) then
rank =  ''..(redis:get('rank'..msg.sender_user_id) or "Sudo")..'' 
elseif is_Owner(msg) then
rank =  ''..(redis:get('rank'..msg.sender_user_id) or "Owner")..'' 
elseif is_Mod(msg) then
rank =  ''..(redis:get('rank'..msg.sender_user_id) or "ADMIN")..''
elseif is_Vip(msg) then
rank =  ''..(redis:get('rank'..msg.sender_user_id) or "VIP")..''
elseif not is_Mod(msg) then
rank = ''..(redis:get('rank'..msg.sender_user_id) or "Member")..''
end
if sdp.first_name then
sdpName = ec_name(sdp.first_name)
else  
sdpName = 'nil'
end
if result.about then
sdpAbout = result.about
else  
sdpAbout = 'nil'
end
if result.common_chat_count  then
sdpcommon_chat_count  = result.common_chat_count 
else 
sdpcommon_chat_count  = 'nil'
end
Msgs = redis:get('Total:messages:'..msg.chat_id..':'..msg.sender_user_id)
sendText(msg.chat_id, msg.id,  '• نام کوچک  : ['..sdpName..']\n• شناسه شما : ['..msg.sender_user_id..'\n• بیوگرافی : ['..sdpAbout..']\nتعداد گروه های شما با ربات : ['..sdpcommon_chat_count..']\n• مقام شما : ['..rank..']\n• تعداد پیام های شما : ['..Msgs..']','md')
end
GetUserFull(msg.sender_user_id,Get)
end
GetUser(msg.sender_user_id,GetName)
end
if shield == 'groupinfo' or shield == 'اطلاعات گروه' and forcejoin(msg) then
 local function FullInfo(shield,sdp)
sendText(msg.chat_id, msg.id,'*SuperGroup Info :*\n`SuperGroup ID :`*'..msg.chat_id..'*\n`Total Admins :` *'..sdp.administrator_count..'*\n`Total Banned :` *'..sdp.banned_count..'*\n`Total Members :` *'..sdp.member_count..'*\n`About Group :` *'..sdp.description..'*\n`Link : `*'..sdp.invite_link..'*\n`Total Restricted : `*'..sdp.restricted_count..'*', 'md')
end
getChannelFull(msg.chat_id,FullInfo)
end
-------------------------------
if shield == 'link'  and forcejoin(msg)  then
local link = redis:get('Link:'..msg.chat_id) 
if link then
sendText(msg.chat_id,msg.id,  '• *Group Link:*\n'..link..'', 'md')
else
sendText(msg.chat_id, msg.id, '• *Link Not Set*', 'md')
end
end
if shield == 'rules' and forcejoin(msg) then
local rules = redis:get('Rules:'..msg.chat_id) 
if rules then
sendText(msg.chat_id,msg.id,  '• *Group Rules:*\n'..rules..'', 'md')
else
sendText(msg.chat_id, msg.id, '• *Rules Not Set*', 'md')
end
end
if shield == 'games'  and forcejoin(msg) then
local games = {'Corsairs','LumberJack','MathBattle'}
sendGame(msg.chat_id, msg.id, 166035794, games[math.random(#games)])
end
if shield == 'ping'  and forcejoin(msg) then
sendText(msg.chat_id, msg.id, 'Bot is online ', 'md')
end
if shield and shield:match('^whois (%d+)') and forcejoin(msg) then
local id = tonumber(shield:match('^whois (%d+)') or shield:match('^اطلاعات (%d+)'))
local function Whois(shield,sdp)
 if sdp.first_name then
local username = ec_name(sdp.first_name)
SendMetion(msg.chat_id,sdp.id, msg.id,username,0,utf8.len(username))
else
sendText(msg.chat_id, msg.id,'• کاربر یافت نشد','md')
end
end
GetUser(id,Whois)
end
if shield and shield:match('^id @(.*)') and forcejoin(msg) then
local username = (shield:match('^id @(.*)') or shield:match('^شناسه @(.*)'))
 function IdByUserName(shield,sdp)
if sdp.id then
text = '[`'..sdp.id..'`]'
sendText(msg.chat_id, msg.id, text, 'md')
end
end
resolve_username(username,IdByUserName)
end
if shield == 'help' and forcejoin(msg) then
if is_sudo(msg) then
text =[[•• راهنمای کار با پرشین کینگ برای مقام صاحب ربات

• setsudo [user]
> تنظیم کاربر به عنوان کمک مدیر ربات
• remsudo [user]
> حذف کاربر از لیست کمک مدیر ربات 
• add
> افزودن گروه به لیست گروه های مدیریتی 
• rem 
> حذف گروه از لیست گروه های مدیریتی 
• charge [num]
> شارژ گروه به دلخواه
• plan1 [chat_id]
> شارژ گروه به مدت یک ماه 
• plan2 [chat_id]
> شارژ گروه به مدت 2 ماه 
• plan3 [chat_id]
> شارژ گروه به مدت نامحدود 
• leave [chat_id]
> خروج از گروه مورد نظر
• expire 
> مدت شارژ گروه 
•  groups
> نمایش تمام گروه ها 
• banall [user] or [reply] or [username]
> مسدود کردن کاربر مورد نظر از تمام گروها 
• unbanall [user] or [reply] or [username]
> حذف کاربر مورد نظر از لیست مسدودیت
• setowner 
تنظیم کاربر به عنوان صاحب گروه 
• remowner 
> غزل کاربر از مقام صاحب گروه
• ownerlist 
> نمایش لیست صاحبان گروه
• clean ownerlist
> پاکسازی لیست صاحبان گروه
• clean gbans
> پاکسازی لیست کاربران لیست سیاه
• clean members 
> پاکسازی تمام کاربران گروه 
• gbans 
> لیست کاربران موجود در لیست سیاه 
• leave 
> خارج کردن ربات از گروه مورد نظر 
• bc [reply]
> ارسال پیام مورد نظر به تمام گرو ها 
• fwd [reply]
> فروارد پیام به تمام گروه ها 
• stats 
> نمایش آمار ربات 
• reload 
> بازنگری ربات
]]
elseif is_Owner(msg) then
text =[[•• راهنمای کار با ربات پرشین کینگ برای مقام صاحب گروه 
• welcome enable
> فعال کردن خوش امد گو
• welcome disable
> غیرفعال کردن خوش امد گو
• setwelcome [text]
> تنظیم خوش امد گو
شما میتوانید از 

{first} : بکار بردن نام کاربر
{last} : بکار بردن نام بزرگ 
{username} : بکار بردن یوزرنیم
{rules} : بکار بردن قوانین
{link} : بکار بردن لینک


مثال :
setwelcome سلام {first} {last} {username} به گروه خوش امدی 
• whois [user_id]
> نمایش کاربر
• clean mutelist
> خالی کردن لیست افراد صامت شده گروه و ازادسازی ان ها
• promote [user] or [reply] or [username]
> ترفیع دادن کاربر به مقام کمک مدیر
• demote [user] or [reply] or [username]
> عزل مقام کاربر 
• pin [reply]
> سنجاق کردن پیام
• unpin
> حذف پیام پین شده 
• muteuser [user] or [reply] or [username] or [reply time h]
> محدود کردن کاربر  
• unmuteuser [user] or [reply] or [username]
> رفع محدودیت کاربر
• mute all
> محدود کردن تمام کاربران 
• forcejoin enable 
>  فعال کردن جویین اجباری
• forcejoin enable 
>  غیرفعال کردن جویین اجباری 
• forceadd enable 
> فعال کردن عضو اجباری 
• forceadd disable 
>  غیرفعال کردن عضو اجباری 
• setforce [new user] or [all user]
> تنظیم حالت عضو اجباری 
• setforcemax [num] 
> تنظیم حداکثر عضو اجباری 
• settimedelete [num]

> تنظیم زمان پاک کردن پیام های گروه (درصورت فعال بودم عضو اجباری)

• setmute all [deletemsg] or [restricted]
> تنظیم حالت میوت ال 
• automute all [timestart-timestop]
> تنظیم قفل خودکار
• automuteall [enable or disable]
> تنظیم زمان قفل خودکار
• unmute all 
> رفیع محدودیت تمام اعضا 
• setvip  [reply] or [username]
> ویژه کردن کاربر 
• remvip [user] or [reply] or [username]
> حذف کاربر از لیست ویژه
• viplist
> نمایش اعضای ویزه 
• clean viplist 
> پاکسازی لیست اعضای ویژه
• clean bots
> اخراج تمامی ربات ها 
• filter [word]
> فیلتر کردن کلمه ی مورد نظر
• unfilter [word]
> حذف کلمه مورد نظر از لیست فیلتر 
• kick [user] or [reply] or [username]
> اخراج کاربر از گروه 
• ban [user] or [reply] or [username]
> مسدود کردن کاربر از گروه 
• banlist 
> لیست کاربران مسدود شده 
• clean banlist
> حذف کاربران از لیست مسدودین گروه 
• setflood [num]
> تنظیم پیام رگباری
• setflood [kickuser] or [muteuser]
> تنظیم حالت برخورد با پیام رگباری
• Clean msgs 
> پاکسازی تمام پیام های دردسترس
• setfloodtime [num]
> تنظیم زمان پیام رگباری
• setlink [link] or [reply]
> تنظیم لینک گروه 
• config 
> ارتقا تمام ادمین ها 
• setrules [rules] 
> تنظیم  قوانین گروه 
• clean restricts
> حذف کاربران محدود شده  از لیست

 • lock [link]/[spam][edit]/[tag]/[hashtag]/[inline]/[video_note]/[pin]/[bot]/[forward]/[arabic]/[english]/[tgservice]/[sticker]
قفل کردن  
مثال
lock bot 
قفل ورود ربات

 • unlock [link]/[spam]/[edit]/[tag]/[hashtag]/[inline]/[video_note]/[pin]/[bot]/[forward]/[arabic]/[english]/[tgservice]/[sticker]
بازکردن قفل 
مثال : 
unlock bot 

 • mute [photo]/[music]/[voice]/[document]/[video]/[game]/[location]/[contact]/[contact]/[text]
> بیصدا کردن 
مثال : 
mute photo

 • unmute [photo]/[music]/[voice]/[document]/[video]/[game]/[location]/[contact]/[contact]/[text]
> لغو بیصدا 
مثال : 
 unmute photo

• getpro [num] > limit 50
> دریافت 50 پروفایل خود 
• warnmax [num]
> تنظیم مقدار اخطار
• warn [user] or [reply] or [username]
> اخطار دادن به کاربر 
• unwarn [reply]
> حذف کاربر
• clean warnlist 
> پاکسازی لیست افرادی که اخطار گرفته اند 
• delall [user] or [reply] or [username] 
> پاکسازی تمام پیام های یک کاربر 
• setname [name]
> تنظیم نام گروه
• setdescription [des]
> تنظیم درباره گروه

]]
elseif is_Mod(msg) then
text =[[• • راهنمای کار با پرشین کینگ برای مقام کمک مدیر

• welcome enable
> فعال کردن خوش امد گو
• welcome disable
> غیرفعال کردن خوش امد گو
• setwelcome [text]
> تنظیم خوش امد گو
شما میتوانید از 

{first} : بکار بردن نام کاربر
{last} : بکار بردن نام بزرگ 
{username} : بکار بردن یوزرنیم
{rules} : بکار بردن قوانین
{link} : بکار بردن لینک

مثال :
setwelcome سلام {first} {last} {username} به گروه خوش امدی 

• muteuser [user] or [reply] or [username]
> محدود کردن کاربر  
• unmuteuser [user] or [reply] or [username]
> رفع محدودیت کاربر
• mute all
> محدود کردن تمام کاربران 
• unmute all 
> رفیع محدودیت تمام اعضا 
• setvip [reply] or [username]
> ویژه کردن کاربر 
• remvip [user] or [reply] or [username]
> حذف کاربر از لیست ویژه
• viplist
> نمایش اعضای ویزه 
• clean viplist 
> پاکسازی لیست اعضای ویژه
• clean bots
> اخراج تمامی ربات ها 
• filter [word]
> فیلتر کردن کالمه مورد نظر
• unfilter [word]
> حذف کلمه مورد نظر از لیست فیلتر 
• kick [user] or [reply] or [username]
> اخراج کاربر از گروه 
• ban [user] or [reply] or [username]
> مسدود کردن کاربر از گروه 
• banlist 
> لیست کاربران مسدود شده 
• clean banlist
> حذف کاربران از لیست مسدودین گروه 
• setflood [num]
> تنظیم پیام رگباری
• setfloodtime [num]
> تنظیم زمان پیام رگباری
• setlink [link]
> تنظیم لینک گروه 
• setrules [rules] 
> تنظیم  قوانین گروه 
• forceadd enable 
> فعال کردن عضو اجباری
• forceadd disable 
>  غیرفعال کردن عضو اجباری 
• setforce [new user] or [all user]

> تنظیم حالت عضو اجباری 
• setforcemax [num] 

> تنظیم حداکثر عضو اجباری 
• settimedelete [num]
> تنظیم زمان پاک کردن پیام های گروه (درصورت فعال بودم عضو اجباری)
• clean restricts
> حذف کاربران محدود شده  از لیست
 • lock [link]/[spam][edit]/[tag]/[hashtag]/[inline]/[video_note]/[bot]/[forward]/[arabic]/[english]/[tgservice]/[sticker]
قفل کردن  
مثال
lock bot 
قفل ورود ربات

 • unlock [link]/[spam]/[edit]/[tag]/[hashtag]/[inline]/[video_note]/[bot]/[forward]/[arabic]/[english]/[tgservice]/[sticker]
بازکردن قفل 
مثال : 
unlock bot 

 • mute [photo]/[music]/[voice]/[document]/[video]/[game]/[location]/[contact]/[contact]/[text]
> بیصدا کردن 
مثال : 
mute photo

 • unmute [photo]/[music]/[voice]/[document]/[video]/[game]/[location]/[contact]/[contact]/[text]
> لغو بیصدا 
مثال : 
unmute photo

 clean restricts
> حذف کابران محدود شده از لیست 
• getpro [num] > limit 50
> دریافت 50 پروفایل خود 
• warnmax [num]
> تنظیم مقدار اخطار
• warn [user] or [reply] or [username]
> اخطار دادن به کاربر 
• unwarn [user] or [reply] or [username] 
> حذف یک اخطار از اخطار های کاربر 
• clean warns 
> پاکسازی تمام اخطار های کاربر 
• clean warnlist 
> پاکسازی لیست افرادی که اخطار گرفته اند 
• delall [user] or [reply] or [username] 
> پاکسازی تمام پیام های یک کاربر 

]]
elseif not is_Mod(msg) then
text =[[شما میتوانید از 

• id

• me


• ping

• link

• rules

• getpro [num] > limit 50
> دریافت 50 پروفایل خود 

استفاده کنید]]
end
sendText(msg.chat_id, msg.id, text, 'html')
end
end
------shield team---------.
if shield  then
local function cb(a,b,c)
redis:set('BOT-ID',b.id)
end
getMe(cb)
end
if msg.sender_user_id == SDP_ID then
redis:incr("Botmsg")
end;end
redis:incr("allmsgs")
if msg.chat_id then
local id = tostring(msg.chat_id) 
if id:match('-100(%d+)') then
if not redis:sismember("ChatSuper:Bot",msg.chat_id) then
redis:sadd("ChatSuper:Bot",msg.chat_id)
end
----------------------------------
elseif id:match('^-(%d+)') then
if not  redis:sismember("Chat:Normal",msg.chat_id) then
redis:sadd("Chat:Normal",msg.chat_id)
end 
-----------------------------------------
elseif id:match('') then
if not redis:sismember("ChatPrivite",msg.chat_id) then;redis:sadd("ChatPrivite",msg.chat_id);end;else
if not redis:sismember("ChatSuper:Bot",msg.chat_id) then
redis:sadd("ChatSuper:Bot",msg.chat_id);end;end;end;end;end
function tdbot_update_callback(data)
if (data._ == "updateNewMessage") or (data._ == "updateNewChannelMessage") then
showedit(data.message,data)
 local msg = data.message 
if msg.sender_user_id and redis:get('MuteAll:'..msg.chat_id) and not is_Mod(msg) then
local status = redis:get('Mute:All:Status:'..msg.chat_id)
muteallstats(msg,status)
end
elseif (data._== "updateMessageEdited") then
showedit(data.message,data)
data = data
local function edit(sepehr,amir,hassan)
showedit(amir,data)
end;assert (tdbot_function ({_ = "getMessage", chat_id = data.chat_id,message_id = data.message_id }, edit, nil));assert (tdbot_function ({_ = "openChat",chat_id = data.chat_id}, dl_cb, nil) );assert (tdbot_function ({ _ = 'openMessageContent',chat_id = data.chat_id,message_id = data.message_id}, dl_cb, nil))assert (tdbot_function ({_="getChats",offset_order="9223372036854775807",offset_chat_id=0,limit=20}, dl_cb, nil));end;end
---End Version 5


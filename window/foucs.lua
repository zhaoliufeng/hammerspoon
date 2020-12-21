local frameCache = {}
local logger = hs.logger.new("windows foucs")

last_aciton = ""
same_action_counter = 1
hs.alert.defaultStyle.strokeColor = {white = 1, alpha = 0.1}
hs.alert.defaultStyle.fillColor =  {white = 0.05, alpha = 0.75}
hs.alert.defaultStyle.textColor = {white = 0.8, alpha = 0.75}
hs.alert.defaultStyle.textSize = 22
hs.alert.defaultStyle.atScreenEdge = 0
hs.alert.defaultStyle.radius =  10
hs.alert.fadeInDuration = 0.25
hs.alert.fadeOutDuration = 0.25

function print_targets_title(targets)
  for k, v in pairs(targets) do
    local title = v:application():title()
    print(k, title)
  end
end

function table_length(t)
  local leng=0
  for k, v in pairs(t) do
    leng=leng+1
  end
  return leng;
end

function get_target_windows(targetTitle)
  local wins = hs.window.allWindows()
  local targets = {}
  
  for k, v in pairs(wins) do
    local title = v:application():title()
    -- print(k, title)
    if (include(title,targetTitle)) then
      table.insert(targets, v)
    end
  end
  return targets
end

function include(substring, totaltarget)
  return string.match(' '..substring..' ', '%A'..totaltarget..'%A') ~= nil
end

function show_alert(content, screen)
  hs.alert.show(content, hs.alert.defaultStyle, screen, 1)
end

function show_alert_with_counter(content, screen, counter, total)
  local show_content = content..' '..counter..'/'..total;
  hs.alert.show(show_content, hs.alert.defaultStyle, screen, 1)
end

function open_application(hint)
  print("open application ")
  print(hint)
  local app = hs.application.open(hint)
end

function winfoucs(what)
  local targets = get_target_windows(what)
  -- print_targets_title(targets)
  local length = table_length(targets)

  if length == 0 then 
    -- open target application if not active
    open_application(what)
    return
  end

  if same_action_counter == nul then print ("counter null") end

  if last_aciton == what then
    same_action_counter = same_action_counter + 1;
    if same_action_counter > length then
      same_action_counter = 1
    end
  else
    last_aciton = what
    same_action_counter = 1
  end
  
  if length == 1 then
    show_alert(what, targets.screen)
  else
    show_alert_with_counter(what, targets.screen, same_action_counter, length)
  end
  
  --[[the front window will be the first item in wins array, 
      order will be change when another window come to the front,
      so just use the last item in the array,can always take next window]]--
  local win = targets[length]
  if win ~= nil then
    win:focus()
  end
end

hs.hotkey.bind({"ctrl", "cmd"}, "I",     hs.fnutils.partial(winfoucs, "iTerm"))
hs.hotkey.bind({"ctrl", "cmd"}, "V",     hs.fnutils.partial(winfoucs, "Code"))
hs.hotkey.bind({"ctrl", "cmd"}, "C",     hs.fnutils.partial(winfoucs, "Google Chrome"))
hs.hotkey.bind({"ctrl", "cmd"}, "A",     hs.fnutils.partial(winfoucs, "Android Studio"))
hs.hotkey.bind({"ctrl", "cmd"}, "F",     hs.fnutils.partial(winfoucs, "访达"))
hs.hotkey.bind({"ctrl", "cmd"}, "T",     hs.fnutils.partial(winfoucs, "Typora"))
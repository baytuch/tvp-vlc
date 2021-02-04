
--[[
 $Id$

 Copyright В© 2021 Baytuch
 Copyright В© 2010 VideoLAN and AUTHORS

 This program is free software; you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation; either version 2 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program; if not, write to the Free Software
 Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston MA 02110-1301, USA.
--]]


api_url = "http://vps.it-hobby.km.ua/TVP/"
local json = require("dkjson")

function descriptor()
  return { title="TVP" }
end

function find(haystack, needle)
  local _,_,r = string.find(haystack, needle)
  return r
end

function main()
  fd = vlc.stream(api_url.."api.php")
  if not fd then return nil end

  line = fd:readline()
  buff = ""
  while line ~= nil
  do
    buff = buff..line
    line = fd:readline()
  end

  local obj, pos, err = json.decode(buff, 1, nil)

  for i = 1, #obj.content do
    vlc.sd.add_item( {title  = obj.content[i].video,
                      path = api_url.."media/video/"..obj.content[i].video,
                      arturl = api_url.."image.php?thumb="..obj.content[i].thumb} )
  end

end


--- increment-header-level: Increases Header's level by 1
--
-- 
-- PURPOSE
--
-- Sometimes you don't want to have level 1 headers in your output.
--
--
-- USAGE
--
-- The filter can then be called like this:
--
-- pandoc -s -o doc.md --lua-filter increment-header-level.lua doc.org
-- 
--
-- AUTHOR
--
-- Rolando Garza <rolandog@gmail.com>
--
-- 
-- LICENSE
--
-- cleanup-markdown-metadata
-- 
-- Copyright (C) 2021  Rolando Garza
-- 
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
-- 
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
-- 
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <https://www.gnu.org/licenses/>.

function Header(el)
    el.level = el.level + 1
    return el
end


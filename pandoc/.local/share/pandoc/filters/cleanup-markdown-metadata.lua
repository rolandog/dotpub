--- cleanup-markdown-metadata: Remove unnecessary values from doc.meta
--
-- 
-- PURPOSE
--
-- When converting an Org-Mode document to Markdown, some of the
-- metadata fields are unnecessary.  It would be nice to remove them.
--
--
-- USAGE
--
-- It's likely that a standalone version needs to be specified.

-- The filter can then be called like this:
--
-- pandoc -s -o doc.md --lua-filter move-markdown-abstract doc.org
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

function Meta(m)
    m.filetags = nil
    m.setupfile = nil
    return m
end


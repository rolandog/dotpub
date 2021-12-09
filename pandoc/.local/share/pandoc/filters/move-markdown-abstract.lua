--- move-markdown-abstract: Move a Div.abstract to doc.meta.abstract
--
-- 
-- PURPOSE
--
-- When converting an Org-Mode document to Markdown, Pandoc outputs
-- the abstract as a Div element with "abstract" as one of its
-- classes.  T
--
-- USAGE
--
-- It's likely that a standalone version needs to be specified.

-- The filter can then be called like this:
--
-- pandoc -o doc.md --lua-filter move-markdown-abstract doc.org
-- 
--
-- AUTHOR
--
-- Rolando Garza <rolandog@gmail.com>
--
-- 
-- LICENSE
--
-- move-markdown-abstract
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

function Pandoc(doc)
    local blocks = {}
    for i,el in pairs(doc.blocks) do
        if (el.t == "Div" and el.classes[1] == "abstract") then
           abstractblocks = pandoc.walk_block(el, {
               Blocks = function(el)
                return el
           end }).content
           doc.meta.abstract = pandoc.MetaBlocks(abstractblocks)
        else
            table.insert(blocks, el)
        end
    end
    return pandoc.Pandoc(blocks, doc.meta)
end


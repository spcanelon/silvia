local function ensureHtmlDeps()
  quarto.doc.addHtmlDependency({
    name = "bootstrap-icons",
    version = "1.9.1",
    stylesheets = {"assets/css/all.css"}
  })
end

local function isEmpty(s)
  return s == nil or s == ''
end

local str = pandoc.utils.stringify

return {
  ["bi"] = function(args, kwargs)
    local icon = str(args[1])
    local size = str(kwargs["size"])
    local color = str(kwargs["color"])
    local label = str(kwargs["label"])
    local class = str(kwargs["class"])
    
    if not isEmpty(size) then
      size = "font-size: " .. size .. ";"
    else
      size = ''
    end
    
    if not isEmpty(color) then
      color = "color: " .. color  .. ";"
    else
      color = ''
    end
    
    local style = "style=\"" .. size .. color .. "\""
    
    if not isEmpty(label) then
      label = " aria-label=\"" .. label  .. "\""
    end
    
    if isEmpty(class) then
      class = ''
    end
    
    local role = "role=\"img\""
    local aria_hidden = "aria-hidden=\"true\""

    if quarto.doc.isFormat("html:js") then
      ensureHtmlDeps()
      if isEmpty(label) then
        return pandoc.RawInline(
          'html',
          "<i class=\"bi-" .. icon .. " " .. class .. "\"" .. style .. role .. aria_hidden .. "></i>"
        )
      else
        return pandoc.RawInline(
          'html',
          "<i class=\"bi-" .. icon .. " " .. class .. "\"" .. style .. role .. label .. "></i>"
        )
      end
    else
      return pandoc.Null()
    end

  end
}
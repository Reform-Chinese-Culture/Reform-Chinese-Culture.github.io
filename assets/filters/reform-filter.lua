function RawInline(elem)
  if elem.format == "tex" then
    if elem.text:match("\\reformcopyright") then
      return pandoc.RawInline('html', '<footer class="reform-copyright">© 2025</footer>')
    elseif elem.text:match("\\subtitle") then
      local subtitle = elem.text:match("\\subtitle{(.*)}")
      return pandoc.RawInline('html', '<p class="subtitle">' .. subtitle .. '</p>')
    end
  end
end

function RawBlock(elem)
  if elem.format == "tex" then
    if elem.text:match("\\begin{preamble}") then
      return pandoc.RawBlock('html', '<div class="epigraph"><blockquote>')
    elseif elem.text:match("\\end{preamble}") then
      return pandoc.RawBlock('html', '</blockquote></div>')
    end
  end
end

function Div(elem)
  if elem.classes and elem.classes[1] == "preamble" then
    return pandoc.Div(
      {pandoc.BlockQuote(elem.content)},
      pandoc.Attr("", {"epigraph"}, {})
    )
  end
end

function Header(elem)
  if elem.level == 1 then
    return pandoc.Header(2, elem.content, elem.attr)
  elseif elem.level == 2 then
    return pandoc.Header(3, elem.content, elem.attr)
  end
  return elem
end


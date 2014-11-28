Function search_results_screen(query As String) as object
  screen = CreateObject("roPosterScreen")
  port = CreateObject("roMessagePort")
  screen.SetMessagePort(port)

  screen.SetBreadcrumbText(m.config.search_title, query)
  screen.SetListStyle(m.config.search_layout)

  results = get_search_results(query)

  screen.SetContentList(results)

  screen.show()

  while (true)
    if(results.count() <= 0)
      screen.ShowMessage(m.config.search_error_text)
    endif
    msg = wait(0, port)
    if type(msg) = "roPosterScreenEvent"
      if (msg.isScreenClosed())
        return -1
      else if msg.isListItemSelected()
        detail_screen(results[msg.GetIndex()], "", "")
      endif
    endif
  end while

End Function
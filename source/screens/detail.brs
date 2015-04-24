Function detail_screen(episode As Object, c1 As String, c2 As String) as object
  screen = CreateObject("roSpringboardScreen")
  port = CreateObject("roMessagePort")
  screen.SetMessagePort(port)

  screen.SetDescriptionStyle(m.config.springboard_description_style)
  screen.SetDisplayMode(m.config.scale_mode)
  screen.SetBreadcrumbText(c1, c2)
  screen.SetStaticRatingEnabled(false)
  screen.SetPosterStyle(m.config.springboard_poster_style)

  screen.SetContent(episode)
  screen.ClearButtons()
  screen.AddButton(1, m.config.play_button_text)

  'if there is something is the registry reader for last play position
  if regread(episode.id) <> invalid and regread(episode.id).toint() >=30 then
    screen.AddButton(2, "Resume Playing")
  endif

  screen.show()

  print episode

  while (true)
    msg = wait(0, port)
    if type(msg) = "roSpringboardScreenEvent"
      if (msg.isScreenClosed())
        return -1
      else if (msg.isButtonPressed())
        player_info = get_player_info(episode.id)
        episode.stream = player_info.stream
        print episode.stream
        episode.StreamFormat = player_info.format
        print episode.StreamFormat
        print episode.stream

        if msg.GetIndex() = 1
          if m.config.play_ads = true
            'play episode with the ad offset
            episode.ads = player_info.ads
            ad = get_ad(episode, 0)
            play_episode_with_ad(episode, ad)
          else
            'play episode at 0
            play_episode(episode, 0)
          endif
        else if msg.GetIndex() = 2
          if m.config.play_ads = true
            episode.ads = player_info.ads
            offset = RegRead(episode.id).toInt()
            print "******!"
            print offset
            print "******!"

            ad = get_ad(episode, offset)
            play_episode_with_ad(episode, ad)
          else
            offset = RegRead(episode.id).toInt()
            play_episode(episode, offset)
          endif
        endif
      endif
    endif
  end while

End Function

$ = require 'jQuery'

$(document).ready (event) ->
  isAnimating = false
  firstLoad = false

  #trigger smooth transition from the actual page to the new one
  $('main').on 'click', '[data-type="page-transition"]', (event) ->
    event.preventDefault()
    #detect which page has been selected
    newPage = $(this).attr('href')
    #if the page is not already being animated - trigger animation
    if not isAnimating
      changePage(newPage, true)
    firstLoad = true


  #detect the 'popstate' event - e.g. user clicking the back button
  $(window).on 'popstate', () ->
    if firstLoad

      #Safari emits a popstate event on page load - check if firstLoad is true before animating
      #if it's false - the page has just been loaded

      newPageArray = location.pathname.split('/')
        #this is the url of the page to be loaded
      newPage = newPageArray[newPageArray.length - 1]
      if not isAnimating
        changePage(newPage, false)

    firstLoad = true


  changePage = (url, bool) ->
    isAnimating = true
    # trigger page animation
    $('body').addClass('page-is-changing')
    $('.cd-loading-bar').one 'webkitTransitionEnd otransitionend oTransitionEnd msTransitionEnd transitionend', () ->
      loadNewContent(url, bool)
      $('.cd-loading-bar').off('webkitTransitionEnd otransitionend oTransitionEnd msTransitionEnd transitionend')

    #if browser doesn't support CSS transitions
    if not transitionsSupported()
      loadNewContent(url, bool)

  loadNewContent = (url, bool) ->
    url = if ('' is url) then  'index.html' else url
    newSection = 'cd-'+url.replace('.html', '')
    section = $('<div class="cd-main-content '+newSection+'"></div>')

    section.load url+' .cd-main-content > *', (event) ->
      # load new content and replace <main> content with the new one
      $('main').html(section)
      #if browser doesn't support CSS transitions - dont wait for the end of transitions
      delay = if ( transitionsSupported() ) then 1200 else 0
      setTimeout () ->
        #wait for the end of the transition on the loading bar before revealing the new content
        if ( section.hasClass('cd-about') ) then $('body').addClass('cd-about') else $('body').removeClass('cd-about')
        $('body').removeClass('page-is-changing')
        $('.cd-loading-bar').one 'webkitTransitionEnd otransitionend oTransitionEnd msTransitionEnd transitionend', () ->
          isAnimating = false
          $('.cd-loading-bar').off('webkitTransitionEnd otransitionend oTransitionEnd msTransitionEnd transitionend')


        if( !transitionsSupported() )
          isAnimating = false
      , delay

      if url isnt window.location and bool
        #add the new page to the window.history
        #if the new page was triggered by a 'popstate' event, don't add it
        window.history.pushState({path: url},'',url)

  transitionsSupported = () ->
    return $('html').hasClass('csstransitions')
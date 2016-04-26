cameras_table = undefined
page_load = true

sendAJAXRequest = (settings) ->
  token = $('meta[name="csrf-token"]')
  if token.size() > 0
    headers =
      "X-CSRF-Token": token.attr("content")
    settings.headers = headers
  xhrRequestChangeMonth = jQuery.ajax(settings)
  true

initializeDataTable = ->
  cameras_table = new Datatable
  headers = undefined
  token = $('meta[name="csrf-token"]')

  if token.size() > 0
    headers = 'X-CSRF-Token': token.attr('content')

  cameras_table.init
    src: $('#cameras_datatables')
    onSuccess: (grid) ->
      # execute some code after table records loaded
      return
    onError: (grid) ->
      # execute some code on network or other general error
      return
    onDataLoad: (grid) ->
      #do something
    dataTable:
      'bStateSave': false
      'lengthMenu': [
        [ 25, 50, 100, 150 ]
        [ 25, 50, 100, 150 ]
      ]
      'pageLength': 50
      "order": [[ 13, "desc" ]]
      'processing': true
      'language': 'processing': '<img src="/assets/loading.gif">'
      'ajax':
        'method': 'GET'
        'headers': headers
        'url': '/load_cameras'
      columns: [
        {data: "0", "width": "117px", "orderable": true, "render": linkCamera },
        {data: "1", "width": "150px", "render": linkOwner },
        {data: "2", "width": "100px" },
        {data: "3", "width": "90px" },
        {data: "4", "width": "70px" },
        {data: "5", "width": "75px" },
        {data: "6", "width": "135px" },
        {data: "7", "width": "75px" },
        {data: "8", "width": "110px" },
        {data: "9", "width": "100px" },
        {data: "10", "width": "130px" },
        {data: "11", "width": "60px" },
        {data: "12", "width": "60px", "render": colorStatus },
        {data: "13", "width": "105px", "sType": "uk_datetime" },
        {data: "14", visible: false }
      ],
      initComplete: ->
        # execute some code on network or other general error

searchFilter = ->
  $('.table-group-action-input').on "keyup", ->
    action = $('.table-group-action-input').val()
    cameras_table.setAjaxParam 'fquery', action.replace("'","''")
    cameras_table.getDataTable().ajax.reload()
    return

columnsDropdown = ->
  $(".cameras-column").on "click", ->
    column = cameras_table.getDataTable().column($(this).attr("data-val"))
    column.visible !column.visible()

appendMe = ->
  $("#div-dropdown-checklist").css({"visibility": "visible", "width": "20px", "top": "1px", "float": "right", "right": "22px" })
  $(".dataTables_info").css("display", "none")
  $(".dataTables_length > label").css("display", "none")
  $("#cameras_datatables_paginate > .pagination-panel").css("display", "none")
  $(".paging_bootstrap_extended").css("float","none")

colorStatus = (name) ->
  if name is "true" || name is true
    return "<span style='color: green;'>True</span>"
  else if name is "false" || name is false
    return "<span style='color: red;'>False</span>"

linkCamera = (name, type, row) ->
  return "<a href='/cameras/#{row[15]}'>#{row[0]}</a>"

linkOwner = (name, type, row) ->
  return "<div class='link-user'><a class='pull-left' href='/users/#{row[16]}'>#{name}</a>
    <a class='pull-right' href='#{row[19]}/v1/cameras?api_id=#{row[17]}&api_key=#{row[18]}' target='_blank'><i class='fa fa-external-link'></i></a></div>"

showTable = ->
  $(window).load ->
    $('#cameras-list-row').removeClass 'hide'

window.initializeCameras = ->
  columnsDropdown()
  initializeDataTable()
  appendMe()
  showTable()
  searchFilter()

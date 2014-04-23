process.env.NODE_ENV = 'test'

fs = require 'fs'
assert = require 'should'
marked = require 'marked'
cheerio = require 'cheerio'

describe '社内勉強会のスケジュール', ->

  $ = cheerio.load marked fs.readFileSync 'README.md', 'utf-8'

  dates = []
  entrants = []
  attendees = {}

  before (done) ->
    $('th').each (i, th) ->
      dates[i] = $(th).text()
      return

    $('li').each (i, li) ->
      entrants.push $(li).text()
      return

    $('tr').each (i, tr) ->
      user = null
      $(tr).find('td').each (i, td) ->
        return user = $(td).text() if i is 0
        attendees[user] or= {}
        attendees[user][dates[i]] = /[\u25CB|\u25EF|o]/gi.test $(td).text()
        return
    done()

  it 'should 全員参加可能な日がある', ->
    attendee_accept = {}
    attendee_number = Object.keys(attendees).length
    for attendee, schedules of attendees
      for date, accept of schedules
        attendee_accept[date] or= 0
        attendee_accept[date]++ if accept
    max_date = null
    max_perc = 0.0
    for date, accept of attendee_accept
      attendee_accept[date] /= attendee_number
      if max_perc < attendee_accept[date]
        max_date = date
        max_perc = attendee_accept[date]
    assert.equal max_perc, 1.0, "最高に出られる日は#{max_date}で、#{max_perc * 100}%出れる。"

  it 'should 参加表明の名前リストとスケジュール表の名前リストが一致してる', ->
    assert.deepEqual entrants, Object.keys attendees



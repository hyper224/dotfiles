function show_end_time()
    finishwhen = os.date('%I:%M:%S',os.time()+mp.get_property("time-remaining"))
    mp.osd_message(string.format("Movie ends at: %s", finishwhen),3)
end

mp.add_key_binding('Ctrl+t', 'end-time', show_end_time)

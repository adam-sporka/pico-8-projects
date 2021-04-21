pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
-- this tool converts the current pico-8's music track into a reaper project file.
-- open the output in reaper, add your favorite vst, and hear the entire song.

-- terminology:
-- "note" = a cells in pico-8's tracker
-- "tone" = a continuous sound which may comprise of multiple consecutive notes
-- "event" = a midi event

fn="abc.rpp"
id=1000
iid=1

-- from https://www.lexaloffle.com/bbs/?pid=50094#p
function hex(v) 
  local s,l,r=tostr(v,true),3,11
  while sub(s,l,l)=="0" do l+=1 end
  while sub(s,r,r)=="0" do r-=1 end
  return sub(s,min(l,6),flr(v)==v and 6 or max(r,8))
end

-- from https://github.com/dansanderson/picotool/issues/19
function smallcaps(s)
	local d=""
	local c
	for i=1,#s do
		local a=sub(s,i,i)
		if a!="^" then
			if not c then
				for j=1,26 do
					if a==sub("abcdefghijklmnopqrstuvwxyz",j,j) then
					a=sub("\65\66\67\68\69\70\71\72\73\74\75\76\77\78\79\80\81\82\83\84\85\86\87\88\89\90\91\92",j,j)
					end
				end
			end
			d=d..a
			c=true
		end
		c=not c
	end
	return d
end

function note_name(p)
	local octave = 1 + p \ 12
	local noteidx = 1 + p % 12
	local names = { "c", "c#", "d", "d#", "e", "f", "f#", "g", "g#", "a", "b" }
	return names[noteidx]..octave
end

function get_pat(track,order)
	local a = 0x3100 + 4 * order + track
	local pd = peek(a)
	local p = {}
	if band(pd,64) == 64 then
		p.sil = true
	else
		p.pat = pd%64
		p.sil = false
	end
	return p
end

function get_note(sfxn,row)
	local a = 0x3200 + (68 * sfxn) + (2 * row)
	local n = {}
	n.p = %a%64
	n.w = flr(shr(%a, 6)) % 8
	n.v = flr(shr(%a, 9)) % 8
	n.e = flr(shr(%a, 12)) % 8
	return n
end

-- assuming 120 BPM, 32 sixteenth notes per pattern
function get_pos_t(order)
	return 4 * order
end

-- ditto
function get_len_t(order)
	return 4
end

function rpr(string, start)
	printh(string, fn, start)
end

function rpr_with_id(string, id_forced)
	local last_id=id
	if id_forced~=nil then
		last_id=id_forced
	end
	rpr(string.." {"..last_id.."}")
	id+=1
	return last_id
end

function vis_ptn(track, order, color)
	local x = order * 4
	local y = 20 + track * 4
	rectfill(x, y, x+2, y+2, color)
end

function same_note(n1,n2)
	if n1==nil then return false end
	if n1.v==0 or n2.v==0 then return false end
	if n1.e==3 or n1.e==5 then return false end
	if n2.e==6 or n2.e==7 or n1.e==6 or n1.e==7 then return false end
	if n1.p~=n2.p then return false end
	return true
end

function produces_sound(n)
	return n.v > 0
end

function is_snare_drum(n)
	return n.w == 6 and n.e == 5
end

function is_bass_drum(n)
	return n.e == 3
end

function is_slide(n)
	return n.e == 1
end

function is_vibrato(n)
	return n.e == 2
end

function is_arp(n)
	return n.e == 6 or n.e == 7
end

function is_fadein(n)
	return n.e == 4
end

function is_fadeout(n)
	return n.e == 5
end

function get_velocity(n)
	local vel = n.v * 18
	if vel == 126 then vel = 127 end
	return vel
end

function export_events()
	local pos = 0
	for e in all(events) do
		rpr(chr(69).." "..e.delta.." "..hex(e.sta).." "..hex(e.d1).." "..hex(e.d2))
		pos += e.delta
	end
	remaining = 240 * 32 - pos
	if remaining > 0 then
		rpr(chr(69).." "..remaining.." b0 7b 00")
	end
end

function add_event(pos, sta, d1, d2)
	local e = {}
	e.pos = pos
	-- e.delta = pos - last_event_time
	last_event_time = pos
	e.sta = sta
	e.d1 = d1
	e.d2 = d2
	events[#events+1] = e
end

function sort_events()
	for i = 1, #events do
		local j = i
		while j > 1 and events[j-1].pos > events[j].pos do
			events[j], events[j-1] = events[j-1], events[j]
			j = j - 1
		end
	end
	last_event_time = 0
	for i = 1, #events do
		events[i].delta = events[i].pos - last_event_time
		last_event_time = events[i].pos
	end
end

function reset_tones()
	tones = {}
	events = {}
	last_event_time = 0
	last_vibrato = nil
end

function create_tone(row, note, arpctx)
	local t = {}
	t.s = row
	t.e = row
	t.n = note
	t.vib = {}
	t.vib[#t.vib+1] = is_vibrato(note)
	t.arpctx = arpctx
	t.fadein = is_fadein(note)
	t.fadeout = is_fadeout(note)
	t.slide = is_slide(note)
	return t
end

function extend_tone(tone, note, arpctx)
	local t = tone
	t.e += 1
	t.vib[#t.vib+1] = is_vibrato(note)
	t.fadeout = is_fadeout(note)
	return t
end

function store_tone(tone)
	tones[#tones+1] = tone
end

function process_tones()
	for t in all(tones) do
		-- slide (1)
		if t.slide then
			add_event(t.s * 240, 0xb0 + t.n.w, 65, 127)
		else
			add_event(t.s * 240, 0xb0 + t.n.w, 65, 0)
		end
		-- vibrato (2)
		-- Caution: This won't work for multiple waves used at the same time
		local i = 0
		for v in all(t.vib) do
			if v ~= last_vibrato then
				local value = 0
				if v then value = 127 end
				add_event((t.s + i) * 240, 0xb0 + t.n.w, 1, value)
				last_vibrato = v
			end
			i += 1
		end
		-- drop (3)
		-- fade in (4)
		if (t.fadein) then
			for i = 7, 127, 8 do
				add_event(t.s * 240 + flr(i * 1.875), 0xb0 + t.n.w, 7, i)
			end
		else
			add_event(t.s * 240, 0xb0 + t.n.w, 7, 127)
		end
		-- fade out (5)
		if (t.fadeout) then
			for i = 7, 127, 8 do
				add_event(t.s * 240 + flr(i * 1.875), 0xb0 + t.n.w, 7, 127 - i)
			end
		else
			add_event(t.s * 240, 0xb0 + t.n.w, 7, 127)
		end
		-- arp fast (6)
		-- arp slow (7)
		-- note start & stop
		if is_arp(t.n) then
			local i = 0
			for c in all(t.arpctx) do
				add_event(t.s * 240 + i * 60,     0x90 + t.n.w, c.p + 24, get_velocity(t.n))
				add_event(t.s * 240 + (i+1) * 60, 0x80 + t.n.w, c.p + 24, 64)
				i += 1
			end
		else
			add_event(t.s * 240, 0x90 + t.n.w, t.n.p + 24, get_velocity(t.n))
			add_event((t.e + 1) * 240, 0x80 + t.n.w, t.n.p + 24, 64)
		end
	end
	sort_events()
end

function process_notes(pat)
	rectfill(0, 46, 127, 127, 0)
	reset_tones()
	local state = -1
	last = nil
	current = nil
	for a = 0,63 do
		m = get_note(pat,a)
		-- visualize
		local x = a * 4 + 1
		local yp = 110 - m.p - 1
		local yv = 128 - m.v*2 - 1
		if produces_sound(m) then
			rectfill(x + 1, yp, x + 2, 110, 1)
			rectfill(x + 1, yp, x + 2, yp + 1, m.w + 8)
		end
		rectfill(x, yv, x+2, yv+1, m.v + 1)
		-- arp context
		arpctx = {}
		for b = (a\4)*4, (a\4)*4 + 3 do
			local o = get_note(pat, b)
			arpctx[#arpctx+1] = o
		end
		-- just started
		if state == -1 then
			if produces_sound(m) then
				current = create_tone(a, m, arpctx)
				state = 1
			else
				last_vibrato = false
				current = nil
				state = 0
			end
		-- no note
		elseif state == 0 then
			if produces_sound(m) then
				current = create_tone(a, m, arpctx)
				state = 1
			end
		-- have note
		elseif state == 1 then
			if produces_sound(m) then
				if same_note(last.n, m) then
					current = extend_tone(current, m, arpctx)
				else
					store_tone(current)
					current = create_tone(a, m, arpctx)
				end
			else
				store_tone(last)
				last_vibrato = false
				current = nil
				state = 0
			end
		end
		last = current
	end
	if last then
		store_tone(last)
	end
end

function rpr_item(track, order)
	local p=get_pat(track, order)
	vis_ptn(track, order, 1)
	if not p.sil then
		vis_ptn(track, order, 7)
		rpr("<item")
		rpr("position "..get_pos_t(order))
		rpr("length "..get_len_t(order))
		rpr("loop 0")
		rpr("alltakes 0")
		rpr("mute 0")
		rpr("sel 1")
		rpr_with_id("iguid")
		rpr("iid "..iid)
		iid+=1
		rpr("name \"t"..track.." o"..order.." p"..p.pat.."\"")
		rpr("chanmode 0")
		rpr("soffs 0 0")
		rpr_with_id("guid")
		rpr("<source "..smallcaps("midi"))
		rpr("hasdata 1 960 qn")
		rpr("ccinterp 32")
		process_notes(p.pat)
		process_tones()
		export_events()
		rpr("chase_cc_takeoffs 1")
		rpr_with_id("guid")
		rpr("tracksel 252")
		rpr(">")
		rpr(">")
		vis_ptn(track, order, 3)
	end
end

function rpr_track(trn)
	i=rpr_with_id("<track")
	rpr("name \"track_"..trn.."\"")
	rpr("beat -1")
	rpr("automode 0")
	rpr("iphase 0")
	rpr("isbus 0 0")
	rpr_with_id("trackid", i)
	for a=0,63 do
		rpr_item(trn,a)
	end
	rpr(">")
end

function rpr_project()
	print("pico-8-to-reaper", 0, 0, 7)
	rpr("<reaper_project 0.1 \"6.08/x64\" 0", true)
	rpr("tempo 120 4 4")
	rpr_track(0)
	rpr_track(1)
	rpr_track(2)
	rpr_track(3)
	rpr(">")
end

cls()
rpr_project()

__sfx__
001000003d0503c0503b050390503805037050000003505033050310502f050000002c05000000290502705026050240502305021050200501e050000001c0501a05019050170501605015050130501105010050
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011400000e0430214511045110450c625150451a0451a0450e0430214511045021450c625150451a0451a0450e0430214513045130450c625160451c0451c0450e0430214513045021450c625160451d0451f045
011400000e0430214515045150450c6251a0451d0451d0450e0430214515045021450c6251c0451d0451d0450e0430214516045160450c6251d0451f0451f0450e0430214516045021450c6251d0451f0451f045
011400002d0102d0102d0122d0122d0122d0122d0122d0120e1032410022000300102e0102e0102d0102d0102b0122b0122d0102d01028012280122801228012280122801228012280121c0001c0002601028010
0114000029010290122601026010260122601226012260120e00024000260101a0002901028010260102f00030011300102e0102e0102e0122e0122e0122e0121c0021c0021c0021c0021c0001c0002200522005
01140000350153901532015350152d01532015290152d015350153901532015350152d01532015290152d015370153a015340153701531015340153a01537015370153a015340153701531015340153a01537015
01140000350153901532015350152d01632015290152d015350153901532015350152d01632015290152d015370153a015340153701531016340153a01537015370153a015340153701531016340153a01537015
011400000e0430214511045110450c625150451a0451a0450e0430214513045130450c625160451c0451c0450e0430214511045110450c625150451a0451a045020300203002020020200c625020200c6150c625
011400000e04302145110451104515045150451a0451a0450e04302145130451304516045160451c0451c0450e04302145110451104515045150451a0451a0450204002040020300203002020020200201002010
011400002901029010290122901229012290122801026010210102101221012210122801028012280122801226010260102601226012260122601226012260122600226002260022600226002260022600226002
011400000e0430214511045110450c625150451a0451a0450e0430214513045130450c625160451c0451c0450e0430214511045110450c625150451a0451a0450e0430214511045110450c625150451a0450c625
011000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01140000340153701530015340152b01530015280152b015340153701530015340152b01530015280152b015350153901532015350152d01532015290152d015350153901532015350152d01532015290152d015
00140000350153901530015350152d01630015290152d015350153901530015350152d01630015290152d015370153a01532015370152e016320152b0152e015370153a01532015370152e016320152b0152e015
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011400000e0430014513045130450c6251304518045180450e0430014513045130450c625150451a0451c0450e0430214515045150450c625150451a0451a0450e0430214515045150450c625150451c0451d045
001400000e0430514515045150450c6251504518045180450e0430514515045150450c6251504518045180450e0430714516045160450c625160451a0451a0450e0430714516045160450c625160451c0451d045
001400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011400000e0430714516045160450c625160451a0451a0450e0430714516045160450c625160451c0451d0450e043001451a0451c0450c6251c0451f0451f0450e043011451c0451c0450c625190450c62521045
011400002872028725287152472524720247151f7351f725287352872528715247222472524715297352b72529735297122971226735267122671521735217252973529725297152672226722267152172221725
001400002973529725297152473224725247152173521715297222972529715247352472524715217352171526722287252671528735297252b71528722297152673528725267152873522725217151f72221715
001400002873528725287152472224725247151f7351f725287222872528715247352472524715297352b72529735297222971526735267252671521735217252973529725297152673526725267152172221725
001400002b7352b7252b71522722227252271521735217152b7352b7222b71522735227252271521735217152b7222d7252b7152d7352d7252b7152d7352d7152b7352d7252d7152b735307222d7152b7352d715
011000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010200002a6002e600236002460024600246002360022600206001d6001c6001960018600166001460012600106000e6000d6000c6000a6000960008600076000660004600046000360002600016000160000600
__music__
00 08424344
00 09424344
00 080c4044
00 080d4344
00 080a4344
00 090b4344
00 080a4344
00 11104344
00 181c5444
00 191d4344
00 181e6644
00 1b1f4344
00 080c4044
00 080d4344
00 080a4344
00 090b4344
00 080a4344
00 0e104344
00 181c4344
00 191d4344
00 181e4344
00 1b1f4344
00 080a4344
04 0f104344
00 40424344

runtime t/prelude.vim

syntax on

let s:lines = [
            \ "<<<<<<< HEAD",
            \ "ourselves1",
            \ "=======",
            \ "themselves1",
            \ ">>>>>>> 8374eabc232",
            \ "",
            \ "",
            \ "<<<<<<< HEAD",
            \ "ourselves2",
            \ "=======",
            \ "themselves2",
            \ ">>>>>>> 8374eabc232",
            \ "",
            \ "",
            \ "<<<<<<< HEAD",
            \ "ourselves3",
            \ "=======",
            \ "themselves3",
            \ ">>>>>>> 8374eabc232",
            \ ]
lockvar s:lines

function! GetHighlight(line, col)
    return synIDattr(synID(a:line,a:col,1),'name')
endfunction

describe 'Conflict marker'
    before
        new
        for l in range(1, len(s:lines))
            call setline(l, s:lines[l-1])
        endfor
    end

    after
        close!
    end

    it 'is highlighted'
        doautocmd BufEnter
        for l in [1, 8, 15]
            Expect GetHighlight(l, 1) ==# 'ConflictMarkerBegin'
            Expect GetHighlight(l+1, 2) ==# 'ConflictMarkerOurs'
            Expect GetHighlight(l+2, 3) ==# 'ConflictMarkerSeparator'
            Expect GetHighlight(l+3, 4) ==# 'ConflictMarkerTheirs'
            Expect GetHighlight(l+4, 5) ==# 'ConflictMarkerEnd'
        endfor
    end

    it 'is not highlighted if no marker is detected at BufEnter'
        for l in [1, 8, 15]
            Expect GetHighlight(l, 1) !=# 'ConflictMarkerBegin'
            Expect GetHighlight(l+1, 2) !=# 'ConflictMarkerOurs'
            Expect GetHighlight(l+2, 3) !=# 'ConflictMarkerSeparator'
            Expect GetHighlight(l+3, 4) !=# 'ConflictMarkerTheirs'
            Expect GetHighlight(l+4, 5) !=# 'ConflictMarkerEnd'
        endfor
    end
end

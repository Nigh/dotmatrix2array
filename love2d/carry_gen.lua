-- convert dot matrix to c language array
local cg={}
local bit = require("bit")

-- dm:点阵table
-- start:起始位置'lt','rt','lb','rb'
-- bvh:字节方向'v','h'
-- svh:扫描方向'v','h'
-- lsb:字节序'LSB','MSB'
function cg.generate( dm,start,bvh,svh,lsb )
    local output='final:\n'
    local byte_arr = get_byte_arr( dm,start,bvh,lsb )
    local w,h   -- 按照扫描方向的二维字节数组的宽与高
    if bvh=='v' then
        w = math.ceil(dm.h/8)
        h = dm.w
    else
        w = math.ceil(dm.w/8)
        h = dm.h
    end
    local byte_matrix = get_final_arr(w,h,byte_arr,bvh,svh)
    for _,v in ipairs(byte_matrix) do
        for _,p in ipairs(v) do
            output = output .. bit.tohex(p,2) .. ' '
        end
        output = output .. "\n"
    end
    
    print(output)
    love.system.setClipboardText( output )
end

-- 以与字节方向相同的扫描方向生成一维的字节数组
function get_byte_arr( dm,start,bvh,lsb )
    local byte_arr={}
    local i0,i1,i2,j0,j1,j2

    if string.match(start, 'r') then
        i0,i1,i2 = dm.w,1,-1
    else
        i0,i1,i2 = 1,dm.w,1
    end
    if string.match(start, 'b') then
        j0,j1,j2 = dm.h,1,-1
    else
        j0,j1,j2 = 1,dm.h,1
    end

    if bvh=='v' then
        for i=i0,i1,i2 do
            local hscan,x=0,0
            for j=j0,j1,j2 do
                hscan = hscan+1
                if lsb=='MSB' then
                    x = bit.lshift(x, 1)
                    x = bit.bor(x , dm[j][i] and 0x01 or 0x00)
                else
                    x = bit.rshift(x, 1)
                    x = bit.bor(x , dm[j][i] and 0x80 or 0x00)
                end
                if hscan==8 then
                    hscan = 0
                    table.insert( byte_arr, x )
                    x = 0
                end
            end
            if hscan>0 then
                if lsb=='MSB' then
                    x = bit.lshift(x, 8-hscan)
                else
                    x = bit.rshift(x, 8-hscan)
                end
                table.insert( byte_arr, x )
            end
        end
    else
        for j=j0,j1,j2 do
            local hscan,x=0,0
            for i=i0,i1,i2 do
                hscan = hscan+1
                if lsb=='MSB' then
                    x = bit.lshift(x, 1)
                    x = bit.bor(x , dm[j][i] and 0x01 or 0x00)
                else
                    x = bit.rshift(x, 1)
                    x = bit.bor(x , dm[j][i] and 0x80 or 0x00)
                end
                if hscan==8 then
                    hscan = 0
                    table.insert( byte_arr, x )
                    x = 0
                end
            end
            if hscan>0 then
                if lsb=='MSB' then
                    x = bit.lshift(x, 8-hscan)
                else
                    x = bit.rshift(x, 8-hscan)
                end
                table.insert( byte_arr, x )
            end
        end
    end

    return byte_arr
end

-- 将一维数组转换为二维数组，并按需要进行扫描方向的转置
function get_final_arr( w,h,byte_arr,bvh,svh )
    local fw,fh
    local final_arr={}
    
    local _print='origin:\n'
    for i,v in ipairs(byte_arr) do
        _print = _print .. bit.tohex(v,2) .. ' '
    end
    print(_print)
    if bvh==svh then
        fw,fh=w,h
        for i,v in ipairs(byte_arr) do
            if i%fw==1 or i==1 then
                table.insert( final_arr,{} )
            end
            table.insert( final_arr[#final_arr],v )
        end
    else
        -- print(w,h)
        fw,fh=h,w
        for i=1,fh do
            table.insert( final_arr,{} )
        end
        for i,v in ipairs(byte_arr) do
            local _ = i%fh==0 and fh or i%fh
            table.insert( final_arr[_],v )
        end
    end
    return final_arr
end

-- function tablepush(tab,a)



return cg

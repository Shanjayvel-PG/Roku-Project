function registryServiceRead(section, key) as object
    content = invalid
    if section <> invalid
        sec = CreateObject("roRegistrySection", section)
        if sec.Exists(key):
            content = ParseJson(sec.Read(key))
        end if
    end if
    sec = invalid
    return content
end function

function registryServiceWrite(section, key, data) as boolean
    sec = CreateObject("roRegistrySection", section)
    txtData = FormatJson(data)
    sec.Write(key, txtData)
    sec.Flush()
    sec = invalid
    return true
end function

function registryServiceDelete(section, key) as boolean
    sec = CreateObject("roRegistrySection", section)
    sec.Delete(key)
    sec.Flush()
    sec = invalid
    return true
end function

function globalDataGet(key as string, default = invalid as dynamic) as dynamic
    value = default
    if m.global.DoesExist(key)
        value = m.global[key]
    end if
    return value
end function

sub globalDataUpdate(key as string, value as object)
    if m.global.DoesExist(key)
        obj = m.global[key]
        if obj <> invalid and obj.count() > 0 and type(obj) <> "roSGNode"
            obj.append(value)
        else
            obj = value
        end if
        m.global[key] = obj
    else
        dataType = getInterfaceType(value)
        m.global.AddField(key, dataType, false)
        m.global[key] = value
    end if
end sub

sub getInterfaceType(value as object) as string
    dataType = Type(value)

    if dataType.Instr("ro") = 0
        dataType = Lcase(dataType.Mid(2))
    end if

    if dataType = "associativearray"
        dataType = "assocarray"
    else if dataType = "sgnode"
        dataType = "node"
    end if

    return dataType
end sub

function getAssocArrayValue(dictionary as object, searchKey as string, defaultValue = invalid as dynamic) as dynamic
    result = defaultValue
    value = dictionary
    if not(isAssociativeArray(value) and isNonEmptyString(searchKey))
        return result
    end if

    keyArray = searchKey.Split(".")
    for each key in keyArray
        try
            value = value.LookUpCI(key)
            result = value
        catch e
            result = defaultValue
            exit for
        end try
    end for

    if not isValid(result)
        result = defaultValue
    end if
    return result
end function
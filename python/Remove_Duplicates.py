def remove_duplicates(s):
    result = ""
    for ch in s:
        if ch not in result:
            result += ch
    return result

print(remove_duplicates("banana"))   # ban
print(remove_duplicates("abracadabra"))   # abrcd
print(remove_duplicates("hello world"))    # helo wrd
print(remove_duplicates("Nishitha"))   # Nishtha
function outName = makeName (name,path)
if iscellstr(name)
    outName = sprintf('%s\\%s',path,name{1});
else
    outName = sprintf('%s\\%s',path,name);
end